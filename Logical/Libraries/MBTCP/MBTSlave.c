/******************************************************************************
 * Copyright:    B&R Industrie-Automation AG
 *
 * Project:      Library MBTCP
 *
 * Target:       B&R-PCC
 *
 * AR-Version:   B 2.01
 *
 * AS-Version:   V 3.0.71.16.SP01
 *
 * Filename:     MBTSlave.c
 * 
 * Function:     module-description
 *
 * Dependencies: description of all dependencies
 *
 ******************************************************************************
 * History:
 *
 * Version | Date        | Author      | Description
 * ----------------------------------------------------------------------------
 *    1.00 | 2008-sep-19 | H.Anderes   | creation
 *    2.00 | 2010-okt-04 | H.Anderes   | refactory
 *    3.00 | 2014-okt-22 | M.Denk      | #1724 reqOffset added
 *    4.00 | 2014-nov-07 | W.Froehlich | add frame length check
 *    5.00 | 2021-may-07 | W.Froehlich | set correct FUB state fMBTSClose.uiStatus
 *****************************************************************************/

/******************************************************************************
 * includes
 *****************************************************************************/
/* ansi-c import */
/* system import */
/* user defined import */
#include "MBTCP.h"
#include "MBTSlave.h"

/******************************************************************************
 * type definitions
 ******************************************************************************/

/******************************************************************************
 * functions
 ******************************************************************************/
/*============================================================================*/
UINT fMBTSStates(tstMBT_SVars* inst)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
  1.00    | 2008-sep-19 | H.Anderes   | creation
  2.00    | 2010-okt-04 | H.Anderes   | refactory
  5.00    | 2021-may-12 | W.Froehlich | step IOCTL_CLIENT added
  ============================================================================*/
{
 /* _LOCAL */
 UINT uiFatalErrNum = 0; 
 /* _DYNAMIC */
 /*==========================================================================*/
 /* check if a null pointer is passed to the fub */
 if (inst == NULL) 
 {
  return ((UINT)mbtERR_NULL_POINTER);
 }    
  /*--------------------------------------------------------------------------------
    state machine : Modbus TCP Slave
  ---------------------------------------------------------------------------------*/
  
 switch (inst->uiStep) 
 {
  /*-----------------------------------------------------------------------------
    INIT: initialize TcpOpen and variables
  ------------------------------------------------------------------------------*/
  case INIT:
   inst->uiStatus           = 0;
   inst->stTcpOpen.pIfAddr  = 0;    /* 0: listening in, valid for SG4 targets */
   inst->stTcpOpen.port     = inst->uiPort;
   inst->stTcpOpen.options  = tcpOPT_REUSEADDR;

   inst->usiOpenRetries = 0;
   inst->uiReturnStep   = WAIT_REQUEST;
  /* FALL THROUGH */ 
  /*-----------------------------------------------------------------------------
  DISBALE: waits until the fub is enabled
  ------------------------------------------------------------------------------*/
  case DISABLE:
   if (inst->bEnable) 
   {
    inst->uiStep = OPEN_PORT;
   }
   break;
  /*-----------------------------------------------------------------------------
    OPEN: opens a TCP - socket
  ------------------------------------------------------------------------------*/
  case OPEN_PORT:
   inst->stTcpOpen.enable = TRUE;
   /* call TcpOpen */
   TcpOpen(&inst->stTcpOpen);
   /* verify status */
   switch (inst->stTcpOpen.status) 
   {
    /*-------------------------------------------------------------------------*/
    case ERR_OK:
     inst->uiStep = IOCTL;
     break;
    /*-------------------------------------------------------------------------*/
    case ERR_FUB_BUSY:
     inst->uiStep = OPEN_PORT;
     break;  
    /*-------------------------------------------------------------------------*/          
    case tcpERR_NOMORE_IDENTS:
    case tcpERR_ALREADY_EXIST:
    case tcpERR_SOCKET_CREATE:
    case tcpERR_SOCKET_BIND:
    case tcpERR_INTERFACE:
    case tcpERR_SYSTEM:
    case ERR_FUB_ENABLE_FALSE:
    default:
     inst->uiStatus = inst->stTcpOpen.status;
     inst->uiStep   = FATAL_ERROR0;
     break;
   }
   break;
  /*-----------------------------------------------------------------------------
    IOCTRL: configuration of the TCP - connection
  ------------------------------------------------------------------------------*/
  case IOCTL:
   /* set linger that the connection is abort immediately */
   inst->sLinger.lOnOff       = 1;
   inst->sLinger.lLinger      = 0;
   /* initialize fub */
   inst->stTcpIoctl.enable    = 1;
   inst->stTcpIoctl.ident     = inst->stTcpOpen.ident;
   inst->stTcpIoctl.ioctl     = tcpSO_LINGER_SET;     
   inst->stTcpIoctl.pData     = (UDINT)&inst->sLinger;
   inst->stTcpIoctl.datalen   = sizeof(inst->sLinger);
   /* call TcpIoctl */
   TcpIoctl(&inst->stTcpIoctl);
   /* verfiy status */
   switch (inst->stTcpIoctl.status)
   {
    /*-------------------------------------------------------------------------*/
    case ERR_OK:
     /* prepare TcpServer */
     inst->stTcpServer.enable  = TRUE;
     inst->stTcpServer.ident   = inst->stTcpOpen.ident;
     inst->stTcpServer.backlog = 0;
     inst->stTcpServer.pIpAddr = (UDINT)inst->cltAddr;
     inst->usiOpenRetries      = 0;           /* we reset prior to next step */
     inst->uiStep              = WAIT_REQUEST;
     break;
    /*-------------------------------------------------------------------------*/
    case ERR_FUB_BUSY:
     inst->uiStep = IOCTL;
     break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_INVALID_IDENT:
     inst->uiStatus = inst->stTcpIoctl.status;
     if (inst->usiOpenRetries < MAX_OPEN_RETRIES)
     {
      inst->uiStep = OPEN_PORT;
      inst->usiOpenRetries++;
      /***************************************************/
#ifdef _MBTCP_LOGGER_DEBUG
      ERRxwarning( mbtERR_OPEN_RETRIES_IOC,
       inst->stTcpServer.ident,
       "MBTCP Server: OPEN Retries IOCTL");
#endif
      /***************************************************/
     }
     else
     {
      inst->uiStep = FATAL_ERROR1;
     }
     break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_PARAMETER:
     inst->uiStatus = inst->stTcpIoctl.status;
     inst->uiStep   = CLOSE_SLAVE; 
     break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_INVALID_IOCTL:
    case ERR_FUB_ENABLE_FALSE:
    default:
     inst->uiStatus = inst->stTcpIoctl.status;
     inst->uiStep   = FATAL_ERROR2;
     break;
   }
   break;
  /*-----------------------------------------------------------------------------
    WAIT: waits until a request of a client received
  ------------------------------------------------------------------------------*/
  case WAIT_REQUEST:
   /* call TcpServer */
   TcpServer(&inst->stTcpServer);
   /* verify status */
   switch (inst->stTcpServer.status) 
   {
    /*-------------------------------------------------------------------------*/
    case ERR_OK:      
     if (add_client(inst) == EXIT_FAILURE) 
     {
      strcpy(inst->szMsg, "WAIT_REQUEST:TcpServer: Reached MAX_CLIENT");
      /***************************************************/
#ifdef _MBTCP_LOGGER_DEBUG
      ERRxwarning( mbtERR_MAX_CLIENT,
       inst->uiStep,
       "MBTCP Server: Reached Max Clients");
#endif
      /***************************************************/   
     }
		 else
		 {
      /* set linger option for new client connection */
      inst->uiStep   = IOCTL_CLIENT;
      /* set linger that the connection is aborted immediately */
      inst->sLinger.lOnOff       = 1;
      inst->sLinger.lLinger      = 0;
      /* initialize fub */
      inst->stTcpIoctl.enable    = 1;
      inst->stTcpIoctl.ident     = inst->stTcpServer.identclnt;
      inst->stTcpIoctl.ioctl     = tcpSO_LINGER_SET;     
      inst->stTcpIoctl.pData     = (UDINT)&inst->sLinger;
      inst->stTcpIoctl.datalen   = sizeof(inst->sLinger);
		 }
     inst->usiOpenRetries = 0;
     break;
    /*-------------------------------------------------------------------------*/
    case ERR_FUB_BUSY:
     /*************************************************************************/
     /* call client_handler() 
     this function handels the receiving,
     sending and the closing of the TCP - Connection */
     client_handler(inst); 
     /*************************************************************************/
     break;
    case tcpERR_INVALID_IDENT:
     inst->uiStatus = inst->stTcpServer.status;
     if (inst->usiOpenRetries < MAX_OPEN_RETRIES)
     {
      inst->uiStep = OPEN_PORT;
      inst->usiOpenRetries++;
      /**********************************************************************/
#ifdef _MBTCP_LOGGER_DEBUG
      ERRxwarning( mbtERR_OPEN_RETRIES_WR,
       inst->stTcpServer.ident,
       "MBTCP Server: OPEN Retries Wait Request");
#endif
      /**********************************************************************/
     }
     else
     {
      inst->uiStep = FATAL_ERROR3;
     }
     break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_SOCKET_LISTEN:
    case tcpERR_SOCKET_ACCEPT:
     inst->uiStatus = inst->stTcpServer.status;
     inst->uiStep   = CLOSE_SLAVE;              
    /*-------------------------------------------------------------------------*/
    case tcpERR_NOMORE_IDENTS:
    case ERR_FUB_ENABLE_FALSE:
    default:
     inst->uiStatus = inst->stTcpServer.status;      
     inst->uiStep   = FATAL_ERROR4;
     break;
   }
   break;
  /*-----------------------------------------------------------------------------
    IOCTL_CLIENT: configuration of the TCP - client connection
  ------------------------------------------------------------------------------*/
  case IOCTL_CLIENT:
   /* call TcpIoctl */
   TcpIoctl(&inst->stTcpIoctl);
   /* verfiy status */
   switch (inst->stTcpIoctl.status)
   {
    /*-------------------------------------------------------------------------*/
    case ERR_OK:
     inst->usiOpenRetries      = 0;
     inst->uiStep              = WAIT_REQUEST;
     break;
    /*-------------------------------------------------------------------------*/
    case ERR_FUB_BUSY:
     inst->uiStep = IOCTL_CLIENT;
     break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_INVALID_IDENT:
     inst->uiStatus = inst->stTcpIoctl.status;
     if (inst->usiOpenRetries < MAX_OPEN_RETRIES)
     {
      inst->uiStep = OPEN_PORT;
      inst->usiOpenRetries++;
      /***************************************************/
      #ifdef _MBTCP_LOGGER_DEBUG
       ERRxwarning( mbtERR_OPEN_RETRIES_IOC,
       inst->stTcpServer.ident,
       "MBTCP Server: OPEN Retries IOCTL_CLIENT");
      #endif
      /***************************************************/
     }
     else
     {
      inst->uiStep = FATAL_ERROR1;
     }
     break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_PARAMETER:
     inst->uiStatus = inst->stTcpIoctl.status;
     inst->uiStep   = CLOSE_SLAVE; 
     break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_INVALID_IOCTL:
    case ERR_FUB_ENABLE_FALSE:
    default:
     inst->uiStatus = inst->stTcpIoctl.status;
     inst->uiStep   = FATAL_ERROR2;
     break;
   }
	 break;
  /*-----------------------------------------------------------------------------
    CLOSE: closes the TCP - socket
  ------------------------------------------------------------------------------*/
  case CLOSE_SLAVE:
   inst->bClosing     = TRUE;
    
   if (inst->usiCltNr > 0)
   {
    /* new namespace */
    {
     USINT ii = 0;
     for (ii = 0; ii < MAX_CLIENT; ii++)
     {
      if (inst->cltInfo[ii].udiIdent > 0) 
      {
       inst->uiStepCltHandler[ii] = enMBTCP_CLT_HANDLER_DISCONNECT;
       inst->uiStep               = WAIT_REQUEST;
       inst->uiReturnStep         = CLOSE_SLAVE;
       break;
      }
     }    
    }
   }
   else
   {
    /* jump over if ident is not valid */ 
    if (inst->stTcpOpen.ident == NULL)
    {
     inst->bClosing = FALSE;
     inst->bEnable  = 0;
     inst->uiStep   = INIT; 
     break;
    }
    inst->stTcpClose[0].enable = TRUE; 
    inst->stTcpClose[0].ident  = inst->stTcpOpen.ident; 
    inst->stTcpClose[0].how    = 0; 
    /* call TcpClose */
    TcpClose(&inst->stTcpClose[0]);
    /* verify status */ 
    switch (inst->stTcpClose[0].status)
    {
     /*-------------------------------------------------------------------------*/
     case ERR_OK:
     case tcpERR_INVALID_IDENT:
      strcpy(inst->szMsg, 
       "TCP_CLOSE: Slave closed. Set _bEnable_ to 1 to restart");
      inst->bClosing = FALSE;
      inst->bEnable  = 0;
      inst->uiStep   = INIT; 
      break;
     /*-------------------------------------------------------------------------*/
     case ERR_FUB_BUSY:

      break;
     /*-------------------------------------------------------------------------*/
     case ERR_FUB_ENABLE_FALSE:
     default:
      inst->uiStatus = inst->stTcpClose[0].status;
      inst->uiStep   = FATAL_ERROR5;
      break;
    }
   }
   break;
  /*-----------------------------------------------------------------------------
    FATAL ERROR: a fatal error occured
  ------------------------------------------------------------------------------*/  
  case FATAL_ERROR0:
  case FATAL_ERROR1:
  case FATAL_ERROR2:
  case FATAL_ERROR3:
  case FATAL_ERROR4:
  case FATAL_ERROR5:
  case FATAL_ERROR6:
  case FATAL_ERROR7:
  case FATAL_ERROR8:
  default:
   /* vefiy in which state the fatal error occured */
   switch(inst->uiStep)
   {
    case FATAL_ERROR0: uiFatalErrNum = 0; break;
    case FATAL_ERROR1: uiFatalErrNum = 1; break;
    case FATAL_ERROR2: uiFatalErrNum = 2; break;
    case FATAL_ERROR3: uiFatalErrNum = 3; break;
    case FATAL_ERROR4: uiFatalErrNum = 4; break;
    case FATAL_ERROR5: uiFatalErrNum = 5; break;
    case FATAL_ERROR6: uiFatalErrNum = 6; break;
    case FATAL_ERROR7: uiFatalErrNum = 7; break;
    case FATAL_ERROR8: uiFatalErrNum = 8; break;
    default:
     uiFatalErrNum = 9; break;		
   }
   /*************************************************************************/
#ifdef _MBTCP_LOGGER_DEBUG
   ERRxwarning( mbtERR_FATAL_ERROR,
    (UINT)uiFatalErrNum,
    "MBTCP Server: Fatal Error State machine");
#endif
   /*************************************************************************/
              
   inst->uiStep = FINAL_ERROR;
   break;
	 /*--------------------------------------------------------------------------
    FINAL ERROR: a final error occured -> not able to acknowledge/recovery
  ---------------------------------------------------------------------------*/ 
  case FINAL_ERROR:
   /*Do nothing until Reboot RPS*/
   strcpy(inst->szMsg, "FINAL ERROR");
   break;
 } /* switch inst->uiStep */
  
 /* call  mberror() */
 mberror(inst); /* gets debug information */
 /*==========================================================================*/
 return ERR_OK;
} /* fMBTSStates */
  
  
/*============================================================================*/
void client_handler(tstMBT_SVars* inst)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
  1.00    | 2010-okt-04 | H.Anderes   | creation
  ============================================================================*/
{
  /* _LOCAL */
  UINT uiClt = 0;
  /* _DYNAMIC */
  /*==========================================================================*/
  for (uiClt = 0; uiClt < MAX_CLIENT; uiClt++) 
  {
    /*--------------------------------------------------------------------------
      state machine : client handler
     -------------------------------------------------------------------------*/
    switch(inst->uiStepCltHandler[uiClt])
    {
    /*--------------------------------------------------------------------------
      WAIT: waits until a request from a client is received
    --------------------------------------------------------------------------*/ 
    case enMBTCP_CLT_HANDLER_W4_REQUEST:
      /* call recv_client() */
      recv_client(inst, uiClt);
      /* call mberror_client() */
      mberror_client(inst, uiClt); 
      break;
    /*--------------------------------------------------------------------------
      SEND: sends the response to the client
    --------------------------------------------------------------------------*/
    case enMBTCP_CLT_HANDLER_SEND_RESPONSE:
      /* call send_response */
      send_response(inst, uiClt);
      /* call mberror_client() */
      mberror_client(inst, uiClt); 
      break;
    /*-------------------------------------------------------------------------
      DISCONNECT: closes the TCP - socket
    --------------------------------------------------------------------------*/
    case enMBTCP_CLT_HANDLER_DISCONNECT:
      /* call disconnect_client */
      disconnect_client(inst, uiClt);
      /* call mberror_client() */
      mberror_client(inst, uiClt); 
      break;
    /*-------------------------------------------------------------------------
      ERROR: internal error
    --------------------------------------------------------------------------*/
    default:
      inst->uiStep = FATAL_ERROR8;
      break;  
    } /* switch(inst->uiStepCltHandler[i]) */
  } /* for (i = 0; i < MAX_CLIENT; i++) */
  /*==========================================================================*/
} /* client_handler */


/*============================================================================*/
void recv_client(tstMBT_SVars* inst, UINT clt)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
  1.00    | 2008-sep-19 | H.Anderes    | creation
  2.00    | 2010-okt-04 | H.Anderes   | refactory
  ============================================================================*/
{
  /* _LOCAL */
  /* _DYNAMIC */
  /*==========================================================================*/
  inst->TOFRecv[clt].IN = FALSE;          /* start timer (t1 falling edge) */ 
  /* call TOF */ 
  TOF(&(inst->TOFRecv[clt]));  
  /* call TcpRecv */
  TcpRecv(&inst->stTcpRecv[clt]);
  if (inst->TOFRecv[clt].Q == 1)          /* if still within delay time... */
   { 
    /* verify status */
    switch (inst->stTcpRecv[clt].status)
    {
    /*-------------------------------------------------------------------------*/
    case ERR_OK:
      inst->TOFRecv[clt].IN = TRUE;       /* stop timer */
      /* call TOF() */
      TOF(&(inst->TOFRecv[clt]));  
      /* call analyze_req_from_client() */
      if (analyze_req_from_client(inst, clt) == ERR_OK)  /* if an answer is ready */ 
      {     
        inst->usiCltServed          = (USINT) clt;
        inst->stTcpSend[clt].ident  = inst->stTcpRecv[clt].ident;
        inst->stTcpSend[clt].flags  = 0;
        inst->uiStepCltHandler[clt] = enMBTCP_CLT_HANDLER_SEND_RESPONSE; /* send response to client */
        inst->udiRecvCnt++;
      }
      else
		    {
        /**********************************************************************/
        #ifdef _MBTCP_LOGGER_DEBUG
			     ERRxwarning( mbtERR_REQUEST,
                     clt,
                     "MBTCP Server: Request not ok. Sends no Response back");
        #endif
        /**********************************************************************/             	
		    }
      break;
    /*-------------------------------------------------------------------------*/
    case ERR_FUB_BUSY:
      /* do nothing */
      break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_NO_DATA:               
      strcpy(inst->szMsg, "TCP_RECV: Waiting (NO_DATA)");
      /* do nothing, wait for timeout to take over */
      break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_INVALID_IDENT:
    case tcpERR_NOT_CONNECTED:
        strcpy(inst->szMsg, 
               "TcpRecv:INVALID_IDENT, NOT_CONNECTED, disconnecting");
      inst->uiStepCltHandler[clt] = enMBTCP_CLT_HANDLER_DISCONNECT;
      break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_SYSTEM:
      strcpy(inst->szMsg, "TCP_RECV: NO_OOBDATA, SYSTEM");
      inst->uiStep = CLOSE_SLAVE;
      break;
    /*-------------------------------------------------------------------------*/
    case ERR_FUB_ENABLE_FALSE:
      /* do nothing */
       break; 
    /*-------------------------------------------------------------------------*/
    case tcpERR_NO_OOBDATA:
    case tcpERR_PARAMETER:
    case tcpERR_INVALID:
    default:
      strcpy(inst->szMsg, "TCP_RECV: unknown error");
      inst->uiStep = FATAL_ERROR8;
      break;
    }
   }  
  else                                   /* if beyond delay... disconnect */
  { 
    if(inst->stTcpRecv[clt].ident > 0)
    {
      inst->TOFRecv[clt].IN = TRUE;          /* reset timer (t0 rising edge) */  
      /* call TOF() */
      TOF(&(inst->TOFRecv[clt])); 
      inst->uiReturnStep             = WAIT_REQUEST;  
      inst->uiStepCltHandler[clt]    = enMBTCP_CLT_HANDLER_DISCONNECT; 
	     /************************************************************************/
      #ifdef _MBTCP_LOGGER_DEBUG
	     ERRxwarning( mbtERR_TIMEOUT,
                   inst->stTcpRecv[clt].ident,
                   "MBTCP Server: Timeout/no Data recevd");
      #endif
      /************************************************************************/
    }
  } 
  /*==========================================================================*/
} /* recv_client */


/*============================================================================*/
void send_response(tstMBT_SVars* inst, UINT clt)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date     | Author      | Description
  ----------------------------------------------------------------------------
  1.00 | 2010-okt-04 | H.Anderes   | creation
  ============================================================================*/
  {
  /* _LOCAL */
  INT     ii = 0;
  /* _DYNAMIC */
  /*==========================================================================*/ 
  /* check if a response must be send */
  if (inst->usiReqIdx[clt] < MAX_CLIENT_REQUEST)
  {
  	for(ii = inst->usiReqIdx[clt]; ii < MAX_CLIENT_REQUEST; ii++)
	  {
	    if (inst->stSendBuf[clt][inst->usiReqIdx[clt]].uiSendByte == 0)
     {
      inst->usiReqIdx[clt]++; 
		    if (inst->usiReqIdx[clt] == MAX_CLIENT_REQUEST)
		    {
			    inst->usiReqIdx[clt]        = 0; 
          inst->uiStepCltHandler[clt] = enMBTCP_CLT_HANDLER_W4_REQUEST;
			    return;
	      }
      }
      else
	    {
	      break;	
      }
	  }
    /* set the request in the send buffer */
    inst->stTcpSend[clt].enable   = 1;
    inst->stTcpSend[clt].pData    
      = (UDINT)inst->stSendBuf[clt][inst->usiReqIdx[clt]].byte;
    inst->stTcpSend[clt].datalen  
      = inst->stSendBuf[clt][inst->usiReqIdx[clt]].uiSendByte;
    /* call TcpSend */
    TcpSend(&inst->stTcpSend[clt]);
    /* verify status */
    switch (inst->stTcpSend[clt].status) 
    {
    /*------------------------------------------------------------------------*/
    case ERR_OK:
      /* delete send buffer */
	  
      memset( (USINT*)inst->stSendBuf[clt][inst->usiReqIdx[clt]].byte, 
              0, 
              sizeof(inst->stSendBuf[clt][inst->usiReqIdx[clt]].byte));
      inst->stSendBuf[clt][inst->usiReqIdx[clt]].uiSendByte = 0;
      /* check if */
      if(    (inst->usiReqIdx[clt] < inst->usiNbrReq)
          && (inst->usiReqIdx[clt] <= MAX_CLIENT_REQUEST))
      {   
        inst->usiReqIdx[clt]++; 
      }
      else
      {
        inst->usiReqIdx[clt] = 0;
        /* wait for the next request */
        inst->uiStepCltHandler[clt] = enMBTCP_CLT_HANDLER_W4_REQUEST;
      }
      /* debugging */
      inst->udiSendCnt++;
      break;
    /*------------------------------------------------------------------------*/
    case ERR_FUB_BUSY:
    case tcpERR_SENTLEN:
    case tcpERR_WOULDBLOCK:
      /* do nothing */ ;
      break;
    /*------------------------------------------------------------------------*/
    case tcpERR_NOT_CONNECTED:
      if (inst->cltInfo[clt].udiIdent > 0) 
      {
        inst->uiReturnStep               = WAIT_REQUEST;
        inst->uiStepCltHandler[clt]      = enMBTCP_CLT_HANDLER_DISCONNECT;
        /**********************************************************************/
        #ifdef _MBTCP_LOGGER_DEBUG
        ERRxwarning( mbtERR_NOT_CONNECTED,
                     inst->cltInfo[clt].udiIdent,
                     "MBTCP Server: ERR_NOT_CONNECTED");
        #endif
        /**********************************************************************/
      }
      break;
    /*------------------------------------------------------------------------*/
    case tcpERR_INVALID_IDENT:
    case tcpERR_PARAMETER:
      inst->uiStatus              = inst->stTcpSend[clt].status;
      inst->uiStepCltHandler[clt] = enMBTCP_CLT_HANDLER_W4_REQUEST;
      break;
    /*------------------------------------------------------------------------*/
    case tcpERR_SYSTEM:
      inst->uiStatus = inst->stTcpSend[clt].status;
      inst->uiStep   = CLOSE_SLAVE;
      break;
    /*------------------------------------------------------------------------*/
    case ERR_FUB_ENABLE_FALSE:
    default:
      inst->uiStatus = inst->stTcpSend[clt].status;
      inst->uiStep   = FATAL_ERROR5;
      break;
    } /*  switch (inst->stTcpSend[i].status)  */
  } /* if (inst->stSendBuf[i][inst->usiReqCnt].uiSendByte > 0) */
  else
  {
    inst->usiReqIdx[clt]        = 0; 
    inst->uiStepCltHandler[clt] = enMBTCP_CLT_HANDLER_W4_REQUEST;
  }
  /*==========================================================================*/
  } /* send_answer */


/*============================================================================*/
void disconnect_client(tstMBT_SVars* inst, UINT clt)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date     | Author      | Description
  ----------------------------------------------------------------------------
  1.00 | 2010-okt-04 | H.Anderes   | creation
  ============================================================================*/
  {
  /* _LOCAL */
  /* _DYNAMIC */
  /*==========================================================================*/ 
  /* check if a response must be send */
  if(inst->cltInfo[clt].udiIdent > 0)
    {       
      inst->stTcpClose[clt].enable = TRUE;
      inst->stTcpClose[clt].ident  = inst->cltInfo[clt].udiIdent;
      inst->stTcpClose[clt].how    = 0;
      /* call  TcpClose */
      TcpClose(&inst->stTcpClose[clt]);
      /* verify status */
      switch (inst->stTcpClose[clt].status)
      {
      /*----------------------------------------------------------------------*/
      case ERR_OK:
        inst->uiStep                  = inst->uiReturnStep;
        inst->uiStepCltHandler[clt]   = enMBTCP_CLT_HANDLER_W4_REQUEST;
        inst->stTcpRecv[clt].enable   = 0;  
        inst->stTcpRecv[clt].ident    = 0; 
        inst->cltInfo[clt].udiIdent   = 0;
        inst->cltInfo[clt].usiPort    = 0;
        strcpy((char*)inst->cltInfo[clt].szIp_addr,(char*)"");
        /* decrease amount of clients which are served */
        (inst->usiCltNr)--; 
        break;
      /*----------------------------------------------------------------------*/
      case ERR_FUB_BUSY:
        /* do nothing */
        break; 
      /*----------------------------------------------------------------------*/     
      case tcpERR_INVALID_IDENT:
        inst->uiStatus = inst->stTcpClose[clt].status;
        inst->uiStep   = inst->uiReturnStep;
        break;
      /*----------------------------------------------------------------------*/
      case ERR_FUB_ENABLE_FALSE:
      default:
        inst->uiStatus = inst->stTcpClose[clt].status;
        inst->uiStep   = FATAL_ERROR7;
        break;
      }
    }
   else
    {
      inst->uiStep                = inst->uiReturnStep;
      inst->uiStepCltHandler[clt] = enMBTCP_CLT_HANDLER_W4_REQUEST;
    }
  /*==========================================================================*/
  } /* disconnect_client */
  
  
/*============================================================================*/
UINT add_client(tstMBT_SVars* inst)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes    | creation
     2.00 | 2010-okt-04 | H.Anderes   | refactory
  ============================================================================*/
  {
  /* _LOCAL */
  USINT c = 0;
  UINT uiStatus = EXIT_FAILURE;
  /* _DYNAMIC */
  /*==========================================================================*/
  if (inst->usiCltNr < MAX_CLIENT) 
  {
    /* search for available ident == 0 */
    while (    (inst->cltInfo[c].udiIdent > 0) 
            && (c < MAX_CLIENT))
    {
      c++;
    }
    if (inst->cltInfo[c].udiIdent == 0) 
    {
      /* hold some information in the cltInfo struture for 
         monitoring at the fub interface */
      inst->cltInfo[c].udiIdent    = inst->stTcpServer.identclnt;
      inst->cltInfo[c].usiPort     = inst->stTcpServer.portclnt;
      strcpy(inst->cltInfo[c].szIp_addr, (STRING *)(inst->cltAddr));
      /************************************************************************/
      #ifdef _MBTCP_LOGGER_EVENT
	     ERRxwarning( mbtEVENT_IPADRESS_IDENT,
                   inst->stTcpServer.identclnt,
                   (STRING*)inst->cltAddr);
      #endif
      /************************************************************************/ 
      /* prepare TcpRecv fb */                       
      inst->stTcpRecv[c].enable    = 1;
      inst->stTcpRecv[c].ident     = inst->stTcpServer.identclnt;
      inst->stTcpRecv[c].pData     = (UDINT)inst->stRecvBuf[c].byte;
      /* maximal data which can be received are given by the receive buffer */
      inst->stTcpRecv[c].datamax   = sizeof(inst->stRecvBuf[c].byte);
      inst->stTcpRecv[c].flags     = 0;
      /* reset timer */  
      inst->TOFRecv[c].IN 		       = TRUE;          
      /* call TOF */
      TOF(&(inst->TOFRecv[c]));  
      (inst->usiCltNr)++;
      /************************************************************************/
      #ifdef _MBTCP_LOGGER_EVENT
	     ERRxwarning( mbtEVENT_ADD_CLIENT,
                   inst->stTcpServer.identclnt,
                   "MBTCP Server: Add Client");
      #endif
      /************************************************************************/
      uiStatus = ERR_OK;
    }
  }
  return (uiStatus);
  /*==========================================================================*/
  } /* add_client */



/*============================================================================*/
UINT analyze_req_from_client(tstMBT_SVars* inst, USINT clt)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes   | creation
     2.00 | 2010-okt-04 | H.Anderes   | refactory
     4.00 | 2014-nov-07 | W.Froehlich | add frame length check
  ============================================================================*/
  {
  /* _LOCAL */
  t_client_request request;
  UINT uint_var   = 0;
  UINT uiFrameLen = 0;
  UINT uiReqOffset= 0;
  USINT usiNbrReq = 0;
  /* _DYNAMIC */
  /*==========================================================================*/
  if (inst->stTcpRecv[clt].recvlen == 0)  /* Client closed connection */
  { 
    inst->uiStepCltHandler[clt]    = enMBTCP_CLT_HANDLER_DISCONNECT;
    return (EXIT_FAILURE) ;          /* No answer */
  } 
  else 
  {
    if (inst->stTcpRecv[clt].recvlen < MIN_FRAME_LEN)
    {
      /************************************************************************/
      #ifdef _MBTCP_LOGGER_DEBUG
	     ERRxwarning( mbtERR_MIN_FRAME_LEN,
                   inst->cltInfo[clt].udiIdent,
                   "MBTCP Server: Request < MIN_FRAME_LEN");	
      #endif
      /************************************************************************/
      return (EXIT_FAILURE) ;       /* No answer */
    } 
    else 
    {
      /* get the maximal data which are received */
      uiFrameLen      = inst->stTcpRecv[clt].recvlen;
      inst->usiNbrReq = 0;
      /* loop over the requests */
      for (usiNbrReq = 0; usiNbrReq < MAX_CLIENT_REQUEST; usiNbrReq++)
      {
        /* get the next request out of the receive buffer */
        memmove( &uint_var, 
                 &(inst->stRecvBuf[clt].byte[uiReqOffset + 0]), 
                 sizeof(uint_var));           
        request.uiTxID = SWAPUINT(uint_var);    
		    inst->stSendBuf[clt][usiNbrReq].uiTxID = request.uiTxID;	
        memmove( &uint_var, 
                 &(inst->stRecvBuf[clt].byte[uiReqOffset + 2]), 
                 sizeof(uint_var));             
        request.uiProtocolID = SWAPUINT(uint_var);      
        memmove( &uint_var, 
                 &(inst->stRecvBuf[clt].byte[uiReqOffset + 4]), 
                 sizeof(uint_var));             
        request.length   = SWAPUINT(uint_var);
        request.usiUnit  = inst->stRecvBuf[clt].byte[uiReqOffset + 6];      
        request.usiFCode = inst->stRecvBuf[clt].byte[uiReqOffset + 7];   
        /* verify if a valid request is received */
        if ( (request.uiProtocolID != 0)
             || (request.length == 0)
						 || (request.length + 6 > uiFrameLen)
             || (request.usiUnit >= (*(inst->pData)).uiNbrUnits 
                                  + (*(inst->pData)).uiOffsetUnits)
             || (request.usiFCode == 0) ) 
        {
          /**********************************************************************/
          #ifdef _MBTCP_LOGGER_DEBUG
    	  	if(request.length == 0)
          {     
		        ERRxwarning( mbtERR_REQUEST_LEN_ZERO,
                         inst->cltInfo[clt].udiIdent,
                         "MBTCP Server: request.lenght == 0");
          }
	
    	  	if(HEADER_LEN + request.length > uiFrameLen)
          {     
		        ERRxwarning( mbtERR_MIN_FRAME_LEN,
                         inst->cltInfo[clt].udiIdent,
                         "MBTCP Server: request.lenght > frame length");
          }
	
      		if(    (request.usiUnit >= (*(inst->pData)).uiNbrUnits 
                                     + (*(inst->pData)).uiOffsetUnits) 
              || (request.usiUnit < (*(inst->pData)).uiOffsetUnits))
          {       
      		  ERRxwarning( mbtERR_REQUEST_UNIT,
                         inst->cltInfo[clt].udiIdent, 
                         "MBTCP Server: request.usiUnit out of range");
          }

      		if(request.uiProtocolID != 0)
          {     
      		   ERRxwarning( mbtERR_PROTOCOL_ID, 
                          inst->cltInfo[clt].udiIdent, 
                          "MBTCP Server: Protocol ID != 0");	
          }
        
      		if(request.usiFCode == 0)
          {
            ERRxwarning( mbtERR_FCODE_ZERO, 
                         inst->cltInfo[clt].udiIdent, 
                         "MBTCP Server: usiFCode == 0");       
          }
          #endif           
          /**********************************************************************/
          /* No answer */    
        } 
        else 
        {
          switch(request.usiFCode) 
          {
          case READ_COILS:                     /* 0x01 */
            read_coils(inst, clt, usiNbrReq, uiReqOffset);
            break;
          case READ_DISCRETE_INPUTS:           /* 0x02 */
            read_discrete_inputs(inst, clt, usiNbrReq, uiReqOffset);
            break;
          case READ_HOLDING_REGISTERS:         /* 0x03 */
            read_holding_registers(inst, clt, usiNbrReq, uiReqOffset);
            break;
          case READ_INPUT_REGISTERS:           /* 0x04 */
            read_input_registers(inst, clt, usiNbrReq, uiReqOffset);
            break;
          case WRITE_SINGLE_COIL:              /* 0x05 */
            write_single_coil(inst, clt, usiNbrReq, uiReqOffset);
            break;
          case WRITE_SINGLE_REGISTER:          /* 0x06 */
            write_single_register(inst, clt, usiNbrReq, uiReqOffset);
            break;
          case WRITE_MULTIPLE_COILS:           /* 0x0F */
            write_multiple_coils(inst, clt, usiNbrReq, uiReqOffset);
            break;
          case WRITE_MULTIPLE_REGISTERS:       /* 0x10 */
            write_multiple_registers(inst, clt, usiNbrReq, uiReqOffset);
            break;
          case READ_WRITE_MULTIPLE_REGISTERS:  /* 0x17 */
            read_write_multiple_registers(inst, clt, usiNbrReq, uiReqOffset);
            break;
          default:
            /**********************************************************************/
            #ifdef _MBTCP_LOGGER_DEBUG
  		        ERRxwarning( mbtERR_ILLEGAL_FUNCTION, 
                         inst->cltInfo[clt].udiIdent,
                         "MBTCP Server: Illegal function");
            #endif
            /**********************************************************************/
            /* call create_exception_response() */
            create_exception_response( inst, 
                                       clt, 
                                       usiNbrReq, 
                                       uiReqOffset, 
                                       MB_ILLEGAL_FUNCTION);
            break;
          } /* switch(request.usiFCode) */
         } /* else */
         /* calculate next frame lenght */
         if (uiFrameLen != 0)
         {
           uiFrameLen = uiFrameLen - inst->stSendBuf[clt][usiNbrReq].uiReqLength;
         }   
         if (uiFrameLen == 0)
         {
           /* last requst is read */
           uiReqOffset = 0;
           return  (ERR_OK);
         }
         else if(uiFrameLen < MIN_FRAME_LEN)
         {
           /**********************************************************************/
           #ifdef _MBTCP_LOGGER_DEBUG
           ERRxwarning( mbtERR_MIN_FRAME_LEN,
                        inst->cltInfo[clt].udiIdent,
                        "MBTCP Server: Request < MIN_FRAME_LEN");
           #endif
           /**********************************************************************/            
           return (EXIT_FAILURE);
         }
         else
         {
         inst->usiNbrReq++;
           /* calculate request length */
		       uiReqOffset = uiReqOffset + inst->stSendBuf[clt][usiNbrReq].uiReqLength;	 
           /* read next request out of the receive buffer */
         }
       } /* for (inst->usiNbrReq = 0; inst->usiNbrReq < MAX_CLIENT_REQUEST; inst->usiNbrReq++) */
     } /* else */
   } /* else */
   return (EXIT_FAILURE);
  /*==========================================================================*/
  } /* analyze_req_from_client */


/*============================================================================*/
void create_exception_response( tstMBT_SVars* inst, 
                                USINT clt, 
                                USINT req, 
                                UINT  reqOffset, 
                                USINT excode)
/*----------------------------------------------------------------------------
  Function:  Create exception response according to section 7 of Modbus standard
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes    | creation
  ============================================================================*/
  {
  /* _LOCAL */
  UINT  uint_var;
  UINT  length;
  /* _DYNAMIC */
  /*==========================================================================*/
  inst->uiStatus = mbtERR_NUM_BASE + excode;
  memset( inst->stSendBuf[clt][req].byte, 
          0, 
          sizeof(inst->stSendBuf[clt][req].byte));
  /* Build 6 byte header with: (bytes 0,1) transaction id */
  memmove(&inst->stSendBuf[clt][req].byte[0], 
          &inst->stRecvBuf[clt].byte[reqOffset + 0], sizeof(uint_var));
  /* (bytes 2,3) Protocol ID, always 0x0000 */
  memmove(&inst->stSendBuf[clt][req].byte[2], 
          &inst->stRecvBuf[clt].byte[reqOffset + 2], sizeof(uint_var));
  /* Exception response length that follows (bytes 4, 5) */
  length = 3;
  uint_var = SWAPUINT(length);
  memmove(&inst->stSendBuf[clt][req].byte[4], &uint_var, sizeof(uint_var));
  /* Client unit (byte 6) */
  inst->stSendBuf[clt][req].byte[6] = inst->stRecvBuf[clt].byte[reqOffset + 6];
  /* Function code that caused exception (byte 7, with bit 7 ON) */
  inst->stSendBuf[clt][req].byte[7] 
    = inst->stRecvBuf[clt].byte[reqOffset + 7] | 0x80;
  /* Exception code (byte 8) */
  inst->stSendBuf[clt][req].byte[8] = excode;
  /* holds the request length to check if more than one request in the 
         receive buffer */
  inst->stSendBuf[clt][req].uiSendByte  = (HEADER_LEN + length);
  /*==========================================================================*/
  } /* create_exception_response */


/*============================================================================*/
void read_coils(tstMBT_SVars* inst, USINT clt, USINT req, UINT reqOffset)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes    | creation
  ============================================================================*/
  {
  /* _LOCAL */
  t_read_request read_coils;
  UINT           coil;
  UINT           i;
  USINT          su, usiByteNr;
  UINT           uint_var;
  UINT           length;
  /* _DYNAMIC */
  /*==========================================================================*/
  inst->stSendBuf[clt][req].uiSendByte = 0;
  /* (byte 8, 9) starting adress */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 8]), 
           sizeof(uint_var));
  read_coils.uiAddr = SWAPUINT(uint_var);
  /* (byte 10, 11) quantity of coils */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 10]), 
           sizeof(uint_var));
  read_coils.uiQty = SWAPUINT(uint_var);
  /* (byte 6) slave unit */
  su = inst->stRecvBuf[clt].byte[reqOffset + 6];
  if (    (read_coils.uiQty <= (*(inst->pData)).stUnit[su].uiNbrCoils) 
       && (read_coils.uiQty <= MAX_COILS))
  {
    if ( (read_coils.uiAddr + read_coils.uiQty) <= 
         (*(inst->pData)).stUnit[su].uiNbrCoils ) 
    {
      if ((read_coils.uiQty % 8) > 0)
        usiByteNr = (read_coils.uiQty / 8) + 1;
      else
        usiByteNr = (read_coils.uiQty / 8);

      memset( inst->stSendBuf[clt][req].byte, 
              0, 
              sizeof(inst->stSendBuf[clt][req].byte)); 
      /* Build 6 byte header with: (bytes 0,1) transaction id */ 
      memmove(&inst->stSendBuf[clt][req].byte[0], 
              &inst->stRecvBuf[clt].byte[reqOffset + 0], sizeof(uint_var)); 
      /* (bytes 2,3) Protocol ID, always 0x0000 */ 
      memmove(&inst->stSendBuf[clt][req].byte[2], 
              &inst->stRecvBuf[clt].byte[reqOffset + 2], sizeof(uint_var)); 
      /* (bytes 4,5) Response length from byte 6 onwards */ 
      length = 3 + usiByteNr; 
      uint_var = SWAPUINT(length); 
      memmove(&inst->stSendBuf[clt][req].byte[4], &uint_var, sizeof(uint_var)); 
      /* Slave unit: 1 byte */
      inst->stSendBuf[clt][req].byte[6] = su;
      /* Function code: 1 byte */
      inst->stSendBuf[clt][req].byte[7] 
        = inst->stRecvBuf[clt].byte[reqOffset + 7];
      /* Byte nr: 1 byte */
      inst->stSendBuf[clt][req].byte[8] = usiByteNr;
      /* aggregate adjacent coil bits into bytes and place in usiSendBuf */ 
      for (i = 0; i < read_coils.uiQty; i++) 
      {
        coil = read_coils.uiAddr + i;
        /* if coil exists and contains a bit */
        if ( ((*(inst->pData)).stUnit[su].pCoils[coil]) 
             && (((BOOL)((*(inst->pData)).stUnit[su].pCoils[coil]))) )
                                             /* turn on the bit */
          inst->stSendBuf[clt][req].byte[9 + (i/8)] = 
            inst->stSendBuf[clt][req].byte[9 + (i/8)] | (USINT)(0x01 << (i%8));
        else                                 /* zero out the bit */
          inst->stSendBuf[clt][req].byte[9 + (i/8)] = 
            inst->stSendBuf[clt][req].byte[9 + (i/8)] & (USINT)~(0x01 << (i%8));
      }
      /* holds the send byte for the TCPSend */
      inst->stSendBuf[clt][req].uiSendByte  = (HEADER_LEN + length);
    } 
    else 
    {  /* read_coils.uiAddr + read_coils.input_nr <= MAX_COILS */
      create_exception_response( inst, 
                                 clt,
                                 req, 
                                 reqOffset, 
                                 MB_ILLEGAL_DATA_ADDRESS);
    }
  } 
  else 
  { /* read_coils.coils_nr <= MAX_COILS */
    create_exception_response( inst, 
                               clt, 
                               req, 
                               reqOffset, 
                               MB_ILLEGAL_DATA_VALUE);
  }
  /* holds the request length to check if more than one request in the 
         receive buffer */
  inst->stSendBuf[clt][req].uiReqLength = (HEADER_LEN + REQ_LEN_READ_COILS);
  /*==========================================================================*/
  } /* read_coils */
  
  
/*============================================================================*/
void read_discrete_inputs( tstMBT_SVars* inst, 
                           USINT clt, 
                           USINT req, 
                           UINT reqOffset)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes    | creation
  ============================================================================*/
  {
  /* _LOCAL */
  t_read_request read_discrete_inputs;
  UINT           dinput;
  UINT           i;
  USINT          su, usiByteNr;
  UINT           uint_var;
  UINT           length;
  /* _DYNAMIC */
  /*==========================================================================*/
  inst->stSendBuf[clt][req].uiSendByte = 0;
  /* (byte 8, 9) starting adress */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 8]), 
           sizeof(uint_var));
  read_discrete_inputs.uiAddr = SWAPUINT(uint_var);
  /* (byte 10, 11) quantity of coils */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 10]), 
           sizeof(uint_var));
  read_discrete_inputs.uiQty = SWAPUINT(uint_var);
  /* (byte 6) slave unit */
  su = inst->stRecvBuf[clt].byte[reqOffset + 6];         
  if (    (read_discrete_inputs.uiQty 
            <= (*(inst->pData)).stUnit[su].uiNbrDiscreteInputs) 
       && (read_discrete_inputs.uiQty <= MAX_DISCRETE_INPUTS))
  {
    if ((read_discrete_inputs.uiAddr + read_discrete_inputs.uiQty) 
          <= (*(inst->pData)).stUnit[su].uiNbrDiscreteInputs ) 
    {
      if ((read_discrete_inputs.uiQty % 8) > 0)
        usiByteNr = (read_discrete_inputs.uiQty / 8) + 1;
      else
        usiByteNr = (read_discrete_inputs.uiQty / 8);
 
      memset( inst->stSendBuf[clt][req].byte, 
              0, 
              sizeof(inst->stSendBuf[clt][req].byte));
      /* Build 6 byte header with: (bytes 0,1) transaction id */
      memmove(&inst->stSendBuf[clt][req].byte[0], 
              &inst->stRecvBuf[clt].byte[reqOffset + 0], sizeof(uint_var));
      /* (bytes 2,3) Protocol ID, always 0x0000 */
      memmove(&inst->stSendBuf[clt][req].byte[2], 
              &inst->stRecvBuf[clt].byte[reqOffset + 2], sizeof(uint_var));
      /* (bytes 4,5) Response length from byte 6 onwards */
      length = 3 + usiByteNr;
      uint_var = SWAPUINT(length);
      memmove(&inst->stSendBuf[clt][req].byte[4], &uint_var, sizeof(uint_var));
      /* Slave unit: 1 byte */
      inst->stSendBuf[clt][req].byte[6] = su;
      /* Function code: 1 byte */
      inst->stSendBuf[clt][req].byte[7] 
        = inst->stRecvBuf[clt].byte[reqOffset + 7];
      /* Byte nr: 1 byte */
      inst->stSendBuf[clt][req].byte[8] = usiByteNr;
      for (i = 0; i < read_discrete_inputs.uiQty; i++) {
        dinput = read_discrete_inputs.uiAddr + i;
        if (((*(inst->pData)).stUnit[su].pDiscreteInputs[dinput]) 
            && (((BOOL)((*(inst->pData)).stUnit[su].pDiscreteInputs[dinput])))) 
                                             /* turn on the bit */
          inst->stSendBuf[clt][req].byte[9 + (i/8)] 
            = inst->stSendBuf[clt][req].byte[9 + (i/8)] | (USINT)(0x01 << (i%8));
        else                                 /* zero out the bit */
          inst->stSendBuf[clt][req].byte[9 + (i/8)] 
            = inst->stSendBuf[clt][req].byte[9 + (i/8)] & (USINT)~(0x01 << (i%8));
      }
      /* holds the send byte for the TCPSend */
      inst->stSendBuf[clt][req].uiSendByte = (HEADER_LEN + length);
    } 
    else 
    { /* (read_discrete_inputs.uiAddr + read_discrete_inputs.input_nr) 
              <= MAX_DISCRETE_INPUTS */
      create_exception_response( inst, 
                                 clt, 
                                 req, 
                                 reqOffset, 
                                 MB_ILLEGAL_DATA_ADDRESS);
    }
  } 
  else 
  { /* read_discrete_inputs.inputs_nr <= MAX_DISCRETE_INPUTS */
    create_exception_response(inst, clt, req, reqOffset, MB_ILLEGAL_DATA_VALUE);
  }
  /* holds the request length to check if more than one request in the 
         receive buffer */
  inst->stSendBuf[clt][req].uiReqLength 
    = (HEADER_LEN + REQ_LEN_READ_DISCRETE_INPUTS);
  /*==========================================================================*/
  } /* read_discrete_inputs */
  
  
/*============================================================================*/
void read_holding_registers( tstMBT_SVars* inst, 
                             USINT clt, 
                             USINT req, 
                             UINT reqOffset)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes    | creation
  ============================================================================*/
  {
  /* _LOCAL */
  t_read_request read_holding_registers;
  UINT  hreg;
  UINT  i, usiByteNr;
  USINT su; 
  UINT  uint_var;
  INT   int_var;
  UINT  length;
  /* _DYNAMIC */
  /*==========================================================================*/
  inst->stSendBuf[clt][req].uiSendByte = 0;
  /* (byte 8, 9) starting adress */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 8]), 
           sizeof(uint_var));
  read_holding_registers.uiAddr = SWAPUINT(uint_var);
  /* (byte 10, 11) quantity of register */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 10]), 
           sizeof(uint_var));
  read_holding_registers.uiQty = SWAPUINT(uint_var);
  /* (byte 6) slave unit */
  su = inst->stRecvBuf[clt].byte[reqOffset + 6];           
  if (    (read_holding_registers.uiQty 
             <= (*(inst->pData)).stUnit[su].uiNbrHoldingRegs )
       && (read_holding_registers.uiQty <= MAX_HOLDING_REGISTER))
  {
    if ((read_holding_registers.uiAddr + read_holding_registers.uiQty)
        <= (*(inst->pData)).stUnit[su].uiNbrHoldingRegs ) 
    {
      usiByteNr = read_holding_registers.uiQty * 2;
      
      memset( inst->stSendBuf[clt][req].byte, 
              0, 
              sizeof(inst->stSendBuf[clt][req].byte));
      /* Build 6 byte header with: (bytes 0,1) transaction id */
      memmove(&inst->stSendBuf[clt][req].byte[0], 
              &inst->stRecvBuf[clt].byte[reqOffset + 0], sizeof(uint_var));
      /* (bytes 2,3) Protocol ID, always 0x0000 */
      memmove(&inst->stSendBuf[clt][req].byte[2], 
              &inst->stRecvBuf[clt].byte[reqOffset + 2], sizeof(uint_var));
      /* (bytes 4,5) Response length from byte 6 onwards */
      length = 3 + usiByteNr;
      uint_var = SWAPUINT(length);
      memmove(&inst->stSendBuf[clt][req].byte[4], &uint_var, sizeof(uint_var));
      /* Slave unit: 1 byte */
      inst->stSendBuf[clt][req].byte[6] = su;
      /* Function code: 1 byte */
      inst->stSendBuf[clt][req].byte[7] 
        = inst->stRecvBuf[clt].byte[reqOffset + 7];
      /* Byte nr: 1 byte */
      inst->stSendBuf[clt][req].byte[8] = usiByteNr;
      /* Pile register data into inst->usiSendBuf */
      for (i = 0; i < read_holding_registers.uiQty; i++) 
      {
        hreg = read_holding_registers.uiAddr + i;
        if ((*(inst->pData)).stUnit[su].pHoldingRegs[hreg] > 0) 
        {
          int_var 
            = SWAPINT((INT)((*(inst->pData)).stUnit[su].pHoldingRegs[hreg]));
          memmove( &inst->stSendBuf[clt][req].byte[9 + (i*2)], 
                   &int_var, 
                   sizeof(int_var));
        } 
        else 
        {
          int_var = 0;
          memmove( &inst->stSendBuf[clt][req].byte[9 + (i*2)], 
                   &int_var, 
                   sizeof(int_var));
        }
      }
      /* holds the send byte for the TCPSend */
      inst->stSendBuf[clt][req].uiSendByte = (HEADER_LEN + length);
    } 
    else 
    {  /* (read_holding_registers.uiAddr 
          + read_holding_registers.registers_nr) <= MAX_HOLDING_REGISTERS */
      create_exception_response( inst, 
                                 clt, 
                                 req, 
                                 reqOffset, 
                                 MB_ILLEGAL_DATA_ADDRESS);
    }
  } 
  else 
  { 
    /* read_holding_registers.uiQty <= MAX_HOLDING_REGISTERS */
    create_exception_response( inst, 
                               clt, 
                               req, 
                               reqOffset, 
                               MB_ILLEGAL_DATA_VALUE);
  }
  /* holds the request length to check if more than one request in the 
         receive buffer */
  inst->stSendBuf[clt][req].uiReqLength 
    = (HEADER_LEN + REQ_LEN_READ_HOLDING_REGISTERS);
  /*==========================================================================*/
  } /* read_holding_registers */
  
  
/*============================================================================*/
void read_input_registers( tstMBT_SVars* inst, 
                           USINT clt, 
                           USINT req, 
                           UINT reqOffset)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes    | creation
  ============================================================================*/
  {
  /* _LOCAL */
  t_read_request        read_input_registers;
  UINT                  ireg;
  USINT                 i;
  USINT                 su, usiByteNr;
  UINT                  uint_var;
  INT                   int_var;
  UINT                  length;
  /* _DYNAMIC */
  /*==========================================================================*/
  inst->stSendBuf[clt][req].uiSendByte =  0;
  /* (byte 8, 9) starting adress */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 8]), 
           sizeof(uint_var));
  read_input_registers.uiAddr = SWAPUINT(uint_var);
  /* (byte 10, 11) quantity of register */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 10]), 
           sizeof(uint_var));
  read_input_registers.uiQty = SWAPUINT(uint_var);
  /* (byte 6) slave unit */
  su = inst->stRecvBuf[clt].byte[reqOffset + 6]; 
  if (    (read_input_registers.uiQty <= (*(inst->pData)).stUnit[su].uiNbrInputRegs) 
       && (read_input_registers.uiQty <= MAX_INPUT_REGISTER))
  {
    if ( (read_input_registers.uiAddr + read_input_registers.uiQty) 
         <= (*(inst->pData)).stUnit[su].uiNbrInputRegs) 
    {
      usiByteNr = read_input_registers.uiQty * 2;
      
      memset( inst->stSendBuf[clt][req].byte, 
              0, 
              sizeof(inst->stSendBuf[clt][req].byte));
      /* Build 6 byte header with: (bytes 0,1) transaction id */
      memmove(&inst->stSendBuf[clt][req].byte[0], 
              &inst->stRecvBuf[clt].byte[reqOffset + 0], sizeof(uint_var));
      /* (bytes 2,3) Protocol ID, always 0x0000 */
      memmove(&inst->stSendBuf[clt][req].byte[2], 
              &inst->stRecvBuf[clt].byte[reqOffset + 2], sizeof(uint_var));
      /* (bytes 4,5) Response length from byte 6 onwards */
      length = 3 + usiByteNr;
      uint_var = SWAPUINT(length);
      memmove(&inst->stSendBuf[clt][req].byte[4], &uint_var, sizeof(uint_var));
      /* Slave unit: 1 byte */
      inst->stSendBuf[clt][req].byte[6] = su;
      /* Function code: 1 byte */
      inst->stSendBuf[clt][req].byte[7] 
        = inst->stRecvBuf[clt].byte[reqOffset + 7];
      /* Byte nr: 1 byte */
      inst->stSendBuf[clt][req].byte[8] = usiByteNr;
      /* Pile register data into inst->usiSendBuf */
      for (i = 0; i < read_input_registers.uiQty; i++) 
      {
        ireg = read_input_registers.uiAddr + i;
        if ((*(inst->pData)).stUnit[su].pInputRegs[ireg]) 
        {
          int_var 
            = SWAPINT((INT)((*(inst->pData)).stUnit[su].pInputRegs[ireg]));
          memmove( &inst->stSendBuf[clt][req].byte[9 + (i*2)], 
                   &int_var, 
                   sizeof(int_var));
        } 
        else 
        {
          int_var = 0;
          memmove( &inst->stSendBuf[clt][req].byte[9 + (i*2)], 
                   &int_var, 
                   sizeof(int_var));
        }
      }
      /* holds the send byte for the TCPSend */
      inst->stSendBuf[clt][req].uiSendByte = (HEADER_LEN + length);
    } 
    else 
    {
      /* (read_input_registers.uiAddr 
         + read_input_registers.uiQty) <= MAX_INPUT_REGISTERS */
      create_exception_response( inst, 
                                 clt, 
                                 req, 
                                 reqOffset, 
                                 MB_ILLEGAL_DATA_ADDRESS);
    }
  } else {
    /* read_input_registers.uiQty <= MAX_INPUT_REGISTERS */
    create_exception_response( inst, 
                               clt, 
                               req, 
                               reqOffset, 
                               MB_ILLEGAL_DATA_VALUE);
  }

  /* holds the request length to check if more than one request in the 
         receive buffer */
  inst->stSendBuf[clt][req].uiReqLength 
    = (HEADER_LEN + REQ_LEN_READ_INPUT_REGISTERS);
  /*==========================================================================*/
  } /* read_input_registers */
  
  
/*============================================================================*/
void write_single_coil(tstMBT_SVars* inst, USINT clt, USINT req, UINT reqOffset)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes   | creation
  ============================================================================*/
  {
  /* _LOCAL */
  t_single_write_request        write_single_coil;
  USINT                         su;
  UINT                          uint_var;
  UINT                          length;
  /* _DYNAMIC */
  /*==========================================================================*/
  inst->stSendBuf[clt][req].uiSendByte =  0;
  /* (byte 8, 9) starting adress */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 8]), 
           sizeof(uint_var));
  write_single_coil.uiAddr = SWAPUINT(uint_var);
  /* (byte 10, 11) quantity of coils */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 10]), 
           sizeof(uint_var));
  write_single_coil.uiVal = SWAPUINT(uint_var);
  /* (byte 6) slave unit */
  su = inst->stRecvBuf[clt].byte[reqOffset + 6];
  if (    (write_single_coil.uiVal == ON) 
       || (write_single_coil.uiVal == OFF)) 
  {
    if (write_single_coil.uiAddr <= (*(inst->pData)).stUnit[su].uiNbrCoils) 

    {
      if (write_single_coil.uiVal == ON)
        (*(inst->pData)).stUnit[su].pCoils[write_single_coil.uiAddr] 
          = (tCOIL) 1;
      else
        (*(inst->pData)).stUnit[su].pCoils[write_single_coil.uiAddr] 
          = (tCOIL) 0;

      /* Create response to client */
      memset( inst->stSendBuf[clt][req].byte, 
              0, 
              sizeof(inst->stSendBuf[clt][req].byte));
      /* Build 6 byte header with: (bytes 0,1) transaction id */
      memmove(&inst->stSendBuf[clt][req].byte[0], 
              &inst->stRecvBuf[clt].byte[reqOffset + 0], sizeof(uint_var));
      /* (bytes 2,3) Protocol ID, always 0x0000 */
      memmove(&inst->stSendBuf[clt][req].byte[2], 
              &inst->stRecvBuf[clt].byte[reqOffset + 2], sizeof(uint_var));
      /* (bytes 4,5) Response length from byte 6 onwards */
      length = 6;
      uint_var = SWAPUINT(length);
      memmove(&inst->stSendBuf[clt][req].byte[4], &uint_var, sizeof(uint_var));
      /* Slave unit: 1 byte */
      inst->stSendBuf[clt][req].byte[6] = su;
      /* Function code: 1 byte */
      inst->stSendBuf[clt][req].byte[7] 
        = inst->stRecvBuf[clt].byte[reqOffset + 7];
      /* Starting address: 2 bytes */
      memmove( &inst->stSendBuf[clt][req].byte[8], 
               &inst->stRecvBuf[clt].byte[reqOffset + 8], 
               2);
      /* Value: 2 bytes */
      memmove( &inst->stSendBuf[clt][req].byte[10], 
               &inst->stRecvBuf[clt].byte[reqOffset + 10], 
               2);
      /* holds the send byte for the TCPSend */
      inst->stSendBuf[clt][req].uiSendByte = (HEADER_LEN + length);
    } 
    else 
    {
      create_exception_response( inst, 
                                 clt, 
                                 req, 
                                 reqOffset, 
                                 MB_ILLEGAL_DATA_ADDRESS);
    }
  } 
  else 
  {
    /* (write_single_coil.uiVal == ON) || (write_single_coil.uiVal == OFF) */
    create_exception_response( inst, 
                               clt, 
                               req, 
                               reqOffset, 
                               MB_ILLEGAL_DATA_VALUE);
  }
  /* holds the request length to check if more than one request in the 
         receive buffer */
  inst->stSendBuf[clt][req].uiReqLength 
    = (HEADER_LEN + REQ_LEN_WRITE_SINGLE_COIL);
  /*==========================================================================*/
  } /* write_single_coil */
  
  
/*============================================================================*/
void write_single_register( tstMBT_SVars* inst, 
                            USINT clt, 
                            USINT req, 
                            UINT reqOffset)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes    | creation
  ============================================================================*/
  {
  /* _LOCAL */
  t_single_write_request        write_single_register;
  USINT                         su;
  INT                           int_var;
  UINT                          uint_var;
  UINT                          length;
  /* _DYNAMIC */
  /*==========================================================================*/
  inst->stSendBuf[clt][req].uiSendByte =  0;
  /* (byte 8, 9) starting adress */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 8]), 
           sizeof(uint_var));
  write_single_register.uiAddr = SWAPUINT(uint_var);
  /* (byte 10, 11) quantity of register */
  memmove( &int_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 10]), 
           sizeof(int_var));
  write_single_register.uiVal = SWAPUINT(int_var);
  /* (byte 6) slave unit */
  su = inst->stRecvBuf[clt].byte[reqOffset + 6];     
  if ( 1 ) /* Protocol: if ((val >= 0x0000) && (val <= 0xFFFF)), always true */
  {
    if (write_single_register.uiAddr <=(*(inst->pData)).stUnit[su].uiNbrHoldingRegs)
    {
      (*(inst->pData)).stUnit[su].pHoldingRegs[write_single_register.uiAddr] 
        = write_single_register.uiVal;
      memset( inst->stSendBuf[clt][req].byte, 
              0, 
              sizeof(inst->stSendBuf[clt][req].byte));
      /* Build 6 byte header with: (bytes 0,1) transaction id */
      memmove(&inst->stSendBuf[clt][req].byte[0], 
              &inst->stRecvBuf[clt].byte[reqOffset + 0], sizeof(uint_var));
      /* (bytes 2,3) Protocol ID, always 0x0000 */
      memmove(&inst->stSendBuf[clt][req].byte[2], 
              &inst->stRecvBuf[clt].byte[reqOffset + 2], sizeof(uint_var));
      /* (bytes 4,5) Response length from byte 6 onwards */
      length = 6;
      uint_var = SWAPUINT(length);
      memmove(&inst->stSendBuf[clt][req].byte[4], &uint_var, sizeof(uint_var));
      /* Slave unit: 1 byte */
      inst->stSendBuf[clt][req].byte[6] = su;
      /* Function code: 1 byte */
      inst->stSendBuf[clt][req].byte[7] 
        = inst->stRecvBuf[clt].byte[reqOffset + 7];
      /* Starting address: 2 bytes */
      memmove( &inst->stSendBuf[clt][req].byte[8], 
               &inst->stRecvBuf[clt].byte[reqOffset + 8], 
               2);
      /* Value: 2 bytes */
      memmove( &inst->stSendBuf[clt][req].byte[10], 
               &inst->stRecvBuf[clt].byte[reqOffset + 10], 
               2);
      /* holds the send byte for the TCPSend */
      inst->stSendBuf[clt][req].uiSendByte = (HEADER_LEN + length);
    } 
    else 
    {
      /* (read_coils.uiAddr + read_coils.input_nr) <= MAX_COILS */
      create_exception_response( inst, 
                                 clt, 
                                 req, 
                                 reqOffset, 
                                 MB_ILLEGAL_DATA_ADDRESS);
    }
  }
  else 
  {
    create_exception_response( inst, 
                               clt, 
                               req, 
                               reqOffset, 
                               MB_ILLEGAL_DATA_VALUE);
  }
  /* holds the request length to check if more than one request in the 
         receive buffer */
  inst->stSendBuf[clt][req].uiReqLength 
    = (HEADER_LEN + REQ_LEN_WRITE_SINGLE_REGISTER); 
  /*==========================================================================*/
  } /* write_single_register */


/*============================================================================*/
void write_multiple_coils( tstMBT_SVars* inst, 
                           USINT clt, 
                           USINT req, 
                           UINT reqOffset)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes   | creation
     3.00 | 2014-okt-22 | M.Denk      | #1724 reqOffset added
  ============================================================================*/
  {
  /* _LOCAL */
  t_multiple_write_request write_multiple_coil;
  USINT su;
  UINT  coil;
  UINT  uint_var;
  UINT  length;
  UINT  i;
  /* _DYNAMIC */
  /*==========================================================================*/
  inst->stSendBuf[clt][req].uiSendByte = 0;
  /* (byte 8, 9) starting adress */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 8]), 
           sizeof(uint_var));
  write_multiple_coil.uiAddr = SWAPUINT(uint_var);
  /* (byte 10, 11) quantity of coils */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 10]), 
           sizeof(uint_var));
  write_multiple_coil.uiQty = SWAPUINT(uint_var);
  /* (byte 12) quantity of bytes */
  write_multiple_coil.usiByteNr = inst->stRecvBuf[clt].byte[reqOffset + 12];
  /* (byte 6) slave unit */
  su = inst->stRecvBuf[clt].byte[reqOffset + 6];           
  if (    (write_multiple_coil.uiQty > 0) 
       && (write_multiple_coil.uiQty <= (*(inst->pData)).stUnit[su].uiNbrCoils)
       && (write_multiple_coil.uiQty <= MAX_COILS))  
  {
    if ( (write_multiple_coil.uiAddr + write_multiple_coil.uiQty)
         <= (*(inst->pData)).stUnit[su].uiNbrCoils) 
    {
      for (i = 0; i < write_multiple_coil.uiQty; i++) 
      {
        coil = write_multiple_coil.uiAddr + i;
        if ((inst->stRecvBuf[clt].byte[reqOffset + 13 + (i/8)] & (USINT)(0x01 << (i%8))))
          (*(inst->pData)).stUnit[su].pCoils[coil] = (tCOIL) 1;
        else
          (*(inst->pData)).stUnit[su].pCoils[coil] = (tCOIL) 0;
      }
      memset( inst->stSendBuf[clt][req].byte, 
              0, 
              sizeof(inst->stSendBuf[clt][req].byte));
      /* Build 6 byte header with: (bytes 0,1) transaction id */ 
      memmove(&inst->stSendBuf[clt][req].byte[0], 
              &inst->stRecvBuf[clt].byte[reqOffset + 0], sizeof(uint_var));
      /* (bytes 2,3) Protocol ID, always 0x0000 */
      memmove(&inst->stSendBuf[clt][req].byte[2], 
              &inst->stRecvBuf[clt].byte[reqOffset + 2], sizeof(uint_var));
      /* (bytes 4,5) Response length from byte 6 onwards */ 
      length = 6;
      uint_var = SWAPUINT(length);
      memmove(&inst->stSendBuf[clt][req].byte[4], &uint_var, sizeof(uint_var));
      /* Slave unit: 1 byte */
      inst->stSendBuf[clt][req].byte[6] = su;
      /* Function code: 1 byte */
      inst->stSendBuf[clt][req].byte[7] 
        = inst->stRecvBuf[clt].byte[reqOffset + 7];
      /* Starting address: 2 bytes */
      memmove( &inst->stSendBuf[clt][req].byte[8], 
               &inst->stRecvBuf[clt].byte[reqOffset + 8], 
               2);
      /* Value: 2 bytes */
      memmove( &inst->stSendBuf[clt][req].byte[10], 
               &inst->stRecvBuf[clt].byte[reqOffset + 10], 
               2);
      /* holds the send byte for the TCPSend */
      inst->stSendBuf[clt][req].uiSendByte = (HEADER_LEN + length);
    } 
    else 
    { /* (read_coils.uiAddr + read_coils.input_nr) <= MAX_COILS */
      create_exception_response( inst, 
                                 clt, 
                                 req, 
                                 reqOffset, 
                                 MB_ILLEGAL_DATA_ADDRESS);
    }
  } 
  else 
  { 
    create_exception_response( inst, 
                               clt, 
                               req, 
                               reqOffset, 
                               MB_ILLEGAL_DATA_VALUE);
  }
  /* holds the request length to check if more than one request in the 
         receive buffer */
  inst->stSendBuf[clt][req].uiReqLength 
    = (HEADER_LEN + REQ_LEN_WRITE_MULTIPLE_COILS
                  + write_multiple_coil.usiByteNr); 
  /*==========================================================================*/
  } /* write_multiple_coils */
  
  
/*============================================================================*/
void write_multiple_registers( tstMBT_SVars* inst, 
                               USINT clt, 
                               USINT req, 
                               UINT reqOffset)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes   | creation
  ============================================================================*/
  {
  /* _LOCAL */
  t_multiple_write_request write_multi_regs;
  USINT su;
  UINT  hreg;
  INT   int_var;
  UINT  uint_var;
  UINT  length;
  UINT  i;
  /* _DYNAMIC */
  /*==========================================================================*/
  inst->stSendBuf[clt][req].uiSendByte = 0;
  /* (byte 8, 9) starting adress */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 8]), 
           sizeof(uint_var));
  write_multi_regs.uiAddr = SWAPUINT(uint_var);
  /* (byte 10, 11) quantity of registers  */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 10]), 
           sizeof(uint_var));
  write_multi_regs.uiQty = SWAPUINT(uint_var);
  /* (byte 12) quantity of bytes */
  write_multi_regs.usiByteNr = inst->stRecvBuf[clt].byte[reqOffset + 12];
  /* (byte 6) slave unit */
  su = inst->stRecvBuf[clt].byte[reqOffset + 6];
  if (    (write_multi_regs.uiQty > 0) 
       && (write_multi_regs.uiQty <= (*(inst->pData)).stUnit[su].uiNbrHoldingRegs)
       && (write_multi_regs.uiQty <= MAX_INPUT_REGISTER))   
  {
    if ((write_multi_regs.uiAddr + write_multi_regs.uiQty) 
        <= (*(inst->pData)).stUnit[su].uiNbrHoldingRegs) 
    {
      /* copy from recv buffer into slave data unit's holding register */
      for (i = 0; i < write_multi_regs.uiQty; i++) 
      {
        hreg = write_multi_regs.uiAddr + i;
        memmove(&int_var, 
                &inst->stRecvBuf[clt].byte[reqOffset + (13+(i*2))], 
                sizeof(int_var));
        (*(inst->pData)).stUnit[su].pHoldingRegs[hreg] 
          = (tHREG)(SWAPINT(int_var));
      }

      /* Create response to client */
      memset( inst->stSendBuf[clt][req].byte, 
              0, 
              sizeof(inst->stSendBuf[clt][req].byte));
      /* Build 6 byte header with: (bytes 0,1) transaction id */
      memmove(&inst->stSendBuf[clt][req].byte[0], 
              &inst->stRecvBuf[clt].byte[reqOffset + 0], sizeof(uint_var));
      /* (bytes 2,3) Protocol ID, always 0x0000 */
      memmove(&inst->stSendBuf[clt][req].byte[2], 
              &inst->stRecvBuf[clt].byte[reqOffset + 2], sizeof(uint_var));
      /* (bytes 4,5) Response length from byte 6 onwards */
      length = 6;
      uint_var = SWAPUINT(length);
      memmove(&inst->stSendBuf[clt][req].byte[4], &uint_var, sizeof(uint_var));
      /* Slave unit: 1 byte */
      inst->stSendBuf[clt][req].byte[6] 
        = inst->stRecvBuf[clt].byte[reqOffset + 6];
      /* Function code: 1 byte */
      inst->stSendBuf[clt][req].byte[7] 
        = inst->stRecvBuf[clt].byte[reqOffset + 7];
      /* Starting address: 2 bytes */
      memmove( &inst->stSendBuf[clt][req].byte[8], 
               &inst->stRecvBuf[clt].byte[reqOffset + 8], 
               2);
      /* Value: 2 bytes */
      memmove( &inst->stSendBuf[clt][req].byte[10], 
               &inst->stRecvBuf[clt].byte[reqOffset + 10], 
               2);
      /* holds the send byte for the TCPSend */
      inst->stSendBuf[clt][req].uiSendByte = (HEADER_LEN + length);
    } 
    else 
    { 
      create_exception_response( inst, 
                                 clt, 
                                 req, 
                                 reqOffset, 
                                 MB_ILLEGAL_DATA_ADDRESS);
    }
  } 
  else 
  { 
    create_exception_response( inst, 
                               clt, 
                               req, 
                               reqOffset, 
                               MB_ILLEGAL_DATA_VALUE);
  }
  /* holds the request length to check if more than one request in the 
         receive buffer */
  inst->stSendBuf[clt][req].uiReqLength 
    = (HEADER_LEN + REQ_LEN_WRITE_MULTIPLE_REGISTERS
                  + (write_multi_regs.usiByteNr));
  /*==========================================================================*/
  } /* write_multiple_registers */


/*============================================================================*/
void read_write_multiple_registers( tstMBT_SVars* inst, 
                                    USINT clt, 
                                    USINT req, 
                                    UINT reqOffset)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2009-dec-12 | H.Anderes   | creation
  ============================================================================*/
  {
  /* _LOCAL */
  t_multiple_read_write_request read_write_multi_regs;
  USINT su, usiByteNr;
  UINT  hreg;
  INT   int_var;
  UINT  uint_var;
  UINT  length;
  UINT  i;
  /* _DYNAMIC */
  /*==========================================================================*/
  inst->stSendBuf[clt][req].uiSendByte = 0;
  /* (byte 8, 9) read starting adress */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 8]), 
           sizeof(uint_var));
  read_write_multi_regs.uiReadAddr = SWAPUINT(uint_var);
  /* (byte 10, 11) quantity to read */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 10]), 
           sizeof(uint_var));
  read_write_multi_regs.uiReadQty = SWAPUINT(uint_var);
  /* (byte 12, 13) write starting adress */
  memmove( &uint_var, 
            &(inst->stRecvBuf[clt].byte[reqOffset + 12]), 
            sizeof(uint_var));
  read_write_multi_regs.uiWriteAddr = SWAPUINT(uint_var);
  /* (byte 14, 15) quantity to write */
  memmove( &uint_var, 
           &(inst->stRecvBuf[clt].byte[reqOffset + 14]), 
           sizeof(uint_var));
  read_write_multi_regs.uiWriteQty = SWAPUINT(uint_var);
  /* (byte 16) quantity of bytes */
  read_write_multi_regs.usiByteNr = inst->stRecvBuf[clt].byte[reqOffset + 16];
  su = inst->stRecvBuf[clt].byte[reqOffset + 6];
  if (    (read_write_multi_regs.uiWriteQty > 0) 
       && (read_write_multi_regs.uiWriteQty <= (*(inst->pData)).stUnit[su].uiNbrHoldingRegs)
       && (read_write_multi_regs.uiWriteQty <= MAX_HOLDING_REGISTER) 
       && (read_write_multi_regs.uiReadQty > 0)    
       && (read_write_multi_regs.uiWriteQty == (read_write_multi_regs.usiByteNr/2)) 
       && (read_write_multi_regs.uiReadQty <= MAX_HOLDING_REGISTER))
  {
    if (    ((read_write_multi_regs.uiWriteAddr + read_write_multi_regs.uiWriteQty) 
             <= (*(inst->pData)).stUnit[su].uiNbrHoldingRegs)
         && ((read_write_multi_regs.uiReadAddr + read_write_multi_regs.uiReadQty)
             <= (*(inst->pData)).stUnit[su].uiNbrHoldingRegs))
    {
      /* copy from recv buffer into slave data unit's holding register */
      for (i = 0; i < read_write_multi_regs.uiWriteQty; i++) 
      {
        hreg = read_write_multi_regs.uiWriteAddr + i;
        memmove( &int_var,
                 &inst->stRecvBuf[clt].byte[17+(i*2)], 
                 sizeof(int_var));
        (*(inst->pData)).stUnit[su].pHoldingRegs[hreg] 
          = (tHREG)(SWAPINT(int_var));
      }

      /* Create response to client */
      usiByteNr = read_write_multi_regs.uiReadQty * 2;
      
      memset( inst->stSendBuf[clt][req].byte, 
              0, 
              sizeof(inst->stSendBuf[clt][req].byte));
      /* Build 6 byte header with: (bytes 0,1) transaction id */
      memmove( &inst->stSendBuf[clt][req].byte[0], 
               &inst->stRecvBuf[clt].byte[reqOffset + 0], 
               sizeof(uint_var));
      /* (bytes 2,3) Protocol ID, always 0x0000 */
      memmove( &inst->stSendBuf[clt][req].byte[2], 
               &inst->stRecvBuf[clt].byte[reqOffset + 2], 
               sizeof(uint_var));
      /* (bytes 4,5) Response length from byte 6 onwards */
      length = 3 + usiByteNr;
      uint_var = SWAPUINT(length);
      memmove( &inst->stSendBuf[clt][req].byte[4], 
               &uint_var, 
               sizeof(uint_var));
      /* Slave unit: 1 byte */
      inst->stSendBuf[clt][req].byte[6] = su;
      /* Function code: 1 byte */
      inst->stSendBuf[clt][req].byte[7] 
        = inst->stRecvBuf[clt].byte[reqOffset + 7];
      /* Byte nr: 1 byte */
      inst->stSendBuf[clt][req].byte[8] = usiByteNr;
      /* Pile register data into inst->usiSendBuf */
      for (i = 0; i < read_write_multi_regs.uiReadQty; i++) 
      {
        hreg = read_write_multi_regs.uiReadAddr + i;
        if ((*(inst->pData)).stUnit[su].pHoldingRegs[hreg] > 0) 
        {
          int_var 
            = SWAPINT((INT)((*(inst->pData)).stUnit[su].pHoldingRegs[hreg]));
          memmove( &inst->stSendBuf[clt][req].byte[9 + (i*2)], 
                   &int_var, 
                   sizeof(int_var));
        } 
        else 
        {
          int_var = 0;
          memmove( &inst->stSendBuf[clt][req].byte[9 + (i*2)], 
                   &int_var, 
                   sizeof(int_var));
        }
      }
      /* holds the send byte for the TCPSend */
      inst->stSendBuf[clt][req].uiSendByte =  (HEADER_LEN + length);
    } 
    else 
    { 
      create_exception_response( inst, 
                                 clt, 
                                 req, 
                                 reqOffset, 
                                 MB_ILLEGAL_DATA_ADDRESS);
    }
  } 
  else 
  { 
    create_exception_response( inst, 
                               clt, 
                               req, 
                               reqOffset, 
                               MB_ILLEGAL_DATA_VALUE);
  }
  /* holds the request length to check if more than one request in the 
         receive buffer */
  inst->stSendBuf[clt][req].uiReqLength 
    = (HEADER_LEN + REQ_LEN_READ_WRITE_MULTIPLE_REGISTERS
                  + (read_write_multi_regs.usiByteNr));
  /*==========================================================================*/
  } /* write_multiple_registers */
  
  
/*============================================================================*/
void mberror(tstMBT_SVars* inst)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  -----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes    | creation
  ============================================================================*/
  {
  /* _LOCAL */
  STRING errstr[5+1];                        /* for status number */
  USINT  msize;                              /* for defensive programming, */
  /* _DYNAMIC */
  /*==========================================================================*/
  msize = sizeof(inst->szMsg) - 1; /* http://www.manpagez.com/man/3/strncat/ */

  memset(inst->szMsg, 0, MESS_LEN);
  switch (inst->uiStep)
  {
  /*-----------------------------------------------------------------------------
    DEBUG: fMBTStates state machine: OPEN PORT
  ------------------------------------------------------------------------------*/
  case OPEN_PORT:
    (void)strncat(inst->szMsg, "OPEN_PORT:", msize - strlen(inst->szMsg));
    (void)itoa(inst->stTcpOpen.status, (UDINT) &errstr);
    (void)strncat(inst->szMsg, errstr, msize - strlen(inst->szMsg));
    switch (inst->stTcpOpen.status)
    {
    case ERR_OK:
      (void)strncat(inst->szMsg, " port opened, using ident for slave", 
                    msize - strlen(inst->szMsg));
      /***********************************************************************/
      #ifdef _MBTCP_LOGGER_EVENT
      ERRxwarning( mbtEVENT_OPEN_PORT,
                   inst->stTcpOpen.ident,
                   "MBTCP Server: Open Port");
      #endif
      /***********************************************************************/
      break;
    case tcpERR_NOMORE_IDENTS:
      (void)strncat(inst->szMsg, " tcpERR_NOMORE_IDENTS available", 
                    msize - strlen(inst->szMsg));
      
      break;
    case tcpERR_ALREADY_EXIST:
      (void)strncat(inst->szMsg, " socket/port number already in use", 
                    msize - strlen(inst->szMsg));
      break;
    case tcpERR_SOCKET_CREATE:
      (void)strncat(inst->szMsg, 
                    " resource limit, failed to create new sockets", 
                    msize - strlen(inst->szMsg));
      break;
    case tcpERR_SOCKET_BIND:
      (void)strncat(inst->szMsg, " failed to bind port number or IP-address", 
                    msize - strlen(inst->szMsg));
      break;
    case tcpERR_INTERFACE:
      (void)strncat(inst->szMsg, " invalid interface address", 
                    msize - strlen(inst->szMsg));
      break;
    case tcpERR_SYSTEM:
      (void)strncat(inst->szMsg, " failed to set options on opened socket", 
                    msize - strlen(inst->szMsg));
      break;
    case ERR_FUB_ENABLE_FALSE:
      (void)strncat(inst->szMsg, " FUB not enabled", 
                    msize - strlen(inst->szMsg));
      break;
    case ERR_FUB_BUSY:
      (void)strncat(inst->szMsg, " FUB busy, trying again", 
                    msize - strlen(inst->szMsg));
      break;            
    default:
      (void)strncat(inst->szMsg, " unknown error", 
                    msize - strlen(inst->szMsg));
      break;
    }
    break;
  /*-----------------------------------------------------------------------------
    DEBUG: fMBTStates state machine: IOCTRL
  ------------------------------------------------------------------------------*/
  case IOCTL:
    (void)strncat(inst->szMsg, "IOCTL:", msize - strlen(inst->szMsg));
    (void)itoa(inst->stTcpIoctl.status, (UDINT) &errstr);
    (void)strncat(inst->szMsg, errstr, msize - strlen(inst->szMsg));
    /* verify status */
    switch (inst->stTcpIoctl.status)
    {
    case ERR_OK:
      (void)strncat(inst->szMsg, " status OK", 
                    msize - strlen(inst->szMsg));
      break;
    case ERR_FUB_BUSY:
      (void)strncat(inst->szMsg, " FUB busy, trying again", 
                    msize - strlen(inst->szMsg));
      break;
    case tcpERR_INVALID_IDENT:
      (void)strncat(inst->szMsg, " ident not available", 
                    msize - strlen(inst->szMsg));
      break;
    case tcpERR_PARAMETER:
      (void)strncat(inst->szMsg, " pData not set", 
                    msize - strlen(inst->szMsg));
      break;
    case tcpERR_INVALID_IOCTL:
      (void)strncat(inst->szMsg, " Invalid I/O control", 
                    msize - strlen(inst->szMsg));
      break;
    case ERR_FUB_ENABLE_FALSE:
      (void)strncat(inst->szMsg, " FUB not enabled", 
                    msize - strlen(inst->szMsg));
      break;
    default:
      (void)strncat(inst->szMsg, " unknown error", 
                    msize - strlen(inst->szMsg));
      break;
    }
    break;
  /*-----------------------------------------------------------------------------
    DEBUG: fMBTStates state machine: WAIT_REQUEST
  ------------------------------------------------------------------------------*/
  case WAIT_REQUEST:
    (void)strncat(inst->szMsg, 
                  "WAIT_REQUEST:inst->stTcpServer", 
                  msize - strlen(inst->szMsg));
    (void)itoa(inst->stTcpServer.status, (UDINT) &errstr);
    (void)strncat(inst->szMsg, errstr, msize - strlen(inst->szMsg));
    /* verify status */
    switch (inst->stTcpServer.status) 
    {
    case ERR_OK:
      (void)strncat(inst->szMsg, " status OK", 
                    msize - strlen(inst->szMsg));
      break;
    case ERR_FUB_BUSY:
      (void)strncat(inst->szMsg, " ERR_FUB_BUSY, waiting for Client/Master", 
                    msize - strlen(inst->szMsg));
      break;
    case tcpERR_INVALID_IDENT:
      (void)strncat(inst->szMsg, " invalid ident", 
                    msize - strlen(inst->szMsg));
      break;
    case tcpERR_NOMORE_IDENTS:
      (void)strncat(inst->szMsg, " tcpERR_NOMORE_IDENTS available", 
                    msize - strlen(inst->szMsg));
      break;
    case tcpERR_SOCKET_LISTEN:
      (void)strncat(inst->szMsg, " error listening to the socket", 
                    msize - strlen(inst->szMsg));
      /*************************************************************************/
      #ifdef _MBTCP_LOGGER_DEBUG
      ERRxwarning( mbtERR_WR_ERROR_SOCKET, 
                   inst->uiStep,
                   "MBTCP Server: Wait Request ERR_SOCKET");
      #endif 
      /*************************************************************************/              
      break;
    case tcpERR_SOCKET_ACCEPT:
      (void)strncat(inst->szMsg, " error accepting the socket", 
                    msize - strlen(inst->szMsg));
      /*************************************************************************/
      #ifdef _MBTCP_LOGGER_DEBUG
      ERRxwarning( mbtERR_WR_ERROR_SOCKET, 
                   inst->uiStep,
                   "MBTCP Server: Wait Request ERR_SOCKET");
      #endif 
      break;
    case ERR_FUB_ENABLE_FALSE:
      (void)strncat(inst->szMsg, " FUB not enabled", 
                    msize - strlen(inst->szMsg));
      break;
    default:
      (void)strncat(inst->szMsg, " unknown error", 
                    msize - strlen(inst->szMsg));
      break;
    }
    break;
  /*-----------------------------------------------------------------------------
    DEBUG: fMBTStates state machine: CLOSE_SLAVE
  ------------------------------------------------------------------------------*/
  case CLOSE_SLAVE:
    (void)strncat(inst->szMsg, 
                  "CLOSE_SLAVE:TCP_CLOSE:", msize - strlen(inst->szMsg));
    (void)itoa(inst->stTcpClose[0].status, (UDINT) &errstr);
    (void)strncat(inst->szMsg, errstr, msize - strlen(inst->szMsg));
    /* verfiy status */
    switch (inst->stTcpClose[0].status)
    {
    case ERR_OK:
      (void)strncat(inst->szMsg, " OK. Slave closed", 
                    msize - strlen(inst->szMsg));
      break;
    case ERR_FUB_BUSY:
      (void)strncat(inst->szMsg, " FUB_BUSY, Still trying...", 
                    msize - strlen(inst->szMsg));
      break;
    case tcpERR_INVALID_IDENT:
      (void)strncat(inst->szMsg, " INVALID_IDENT", 
                    msize - strlen(inst->szMsg));
       /*************************************************************************/
       #ifdef _MBTCP_LOGGER_EVENT
       ERRxwarning( mbtEVENT_CLOSE_PORT, 
                    inst->stTcpClose[0].ident,
                    "MBTCP Server: Close TcpOpen");
       /*************************************************************************/
       #endif
      break;
    case ERR_FUB_ENABLE_FALSE:
      (void)strncat(inst->szMsg, " FUB_ENABLE_FALSE", 
                    msize - strlen(inst->szMsg));
      break;
    default:
      (void)strncat(inst->szMsg, " unknown error", 
                    msize - strlen(inst->szMsg));
      break;
    }
    break;
  }
  /*==========================================================================*/
  } /* mberror */


/*============================================================================*/
void mberror_client(tstMBT_SVars* inst, USINT clt)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  -----------------------------------------------------------------------------
     1.00 | 2010-okt-19 | H.Anderes    | creation
  ============================================================================*/
  {
  /* _LOCAL */
  STRING errstr[5+1];                        /* for status number */
  USINT  msize;                              /* for defensive programming, */
  /* _DYNAMIC */
  /*==========================================================================*/
  msize = sizeof(inst->cltInfo[clt].szMsg) - 1; /* http://www.manpagez.com/man/3/strncat/ */

  memset(inst->cltInfo[clt].szMsg, 0, sizeof(inst->cltInfo[clt].szMsg));
  switch (inst->uiStepCltHandler[clt])
  {
  /*-----------------------------------------------------------------------------
    DEBUG: client_handler state machine: W4_REQUEST
  ------------------------------------------------------------------------------*/
  case enMBTCP_CLT_HANDLER_W4_REQUEST:
    (void)strncat( inst->cltInfo[clt].szMsg, 
                   "W4_REQUEST:", 
                   msize - strlen(inst->cltInfo[clt].szMsg)); 
    (void)itoa(inst->stTcpSend[clt].status, (UDINT) &errstr);
    (void)strncat( inst->cltInfo[clt].szMsg, 
                   errstr, 
                   msize - strlen(inst->cltInfo[clt].szMsg));
    /* verfiy status */               
    switch (inst->stTcpRecv[clt].status)
    {
    case ERR_OK:
      (void)strncat(inst->cltInfo[clt].szMsg, " status OK", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case ERR_FUB_BUSY:
      (void)strncat(inst->cltInfo[clt].szMsg, " FUB busy, trying again", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case tcpERR_NO_DATA:               
      (void)strncat(inst->cltInfo[clt].szMsg, " Waiting (NO_DATA)", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case tcpERR_INVALID_IDENT:
    case tcpERR_NOT_CONNECTED:
      (void)strncat( inst->cltInfo[clt].szMsg, 
                     " INVALID_IDENT, NOT_CONNECTED, disconnecting", 
                     msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case tcpERR_SYSTEM:
      (void)strncat( inst->cltInfo[clt].szMsg, 
                     " internal error while receiving", 
                     msize - strlen(inst->cltInfo[clt].szMsg)); 
      /*************************************************************************/
      #ifdef _MBTCP_LOGGER_DEBUG
      ERRxwarning( mbtERR_NOT_CONNECTED,
                   inst->cltInfo[clt].udiIdent,
                   "MBTCP Server: TCP Recv tcpERR_SYSTEM"); 
      #endif
      /*************************************************************************/
      break;
    /*-------------------------------------------------------------------------*/
    case ERR_FUB_ENABLE_FALSE:
       (void)strncat(inst->cltInfo[clt].szMsg, " FUB not enabled", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
       break; 
    /*-------------------------------------------------------------------------*/
    case tcpERR_NO_OOBDATA:
    case tcpERR_PARAMETER:
    case tcpERR_INVALID:
    default:
      (void)strncat(inst->cltInfo[clt].szMsg, " unknown error", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    }
    break;
  /*-----------------------------------------------------------------------------
    DEBUG: client_handler state machine: SEND_RESPONSE
  ------------------------------------------------------------------------------*/  
  case enMBTCP_CLT_HANDLER_SEND_RESPONSE:
    (void)strncat( inst->cltInfo[clt].szMsg, 
                   "SEND_RESPONSE:", 
                   msize - strlen(inst->cltInfo[clt].szMsg)); 
    (void)itoa(inst->stTcpSend[clt].status, (UDINT) &errstr);
    (void)strncat( inst->cltInfo[clt].szMsg, 
                   errstr, 
                   msize - strlen(inst->cltInfo[clt].szMsg));
    /* verify status */
    switch (inst->stTcpSend[clt].status)
    {
    case ERR_OK:
      (void)strncat(inst->cltInfo[clt].szMsg, " status OK", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case ERR_FUB_BUSY:
      (void)strncat(inst->cltInfo[clt].szMsg, " FUB busy, trying again", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case ERR_FUB_ENABLE_FALSE:
      (void)strncat(inst->cltInfo[clt].szMsg, " FUB not enabled", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case tcpERR_INVALID_IDENT:
      (void)strncat(inst->cltInfo[clt].szMsg, " ident not available", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case tcpERR_PARAMETER:
      (void)strncat(inst->cltInfo[clt].szMsg, " pData not set", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case tcpERR_SENTLEN:
      (void)strncat(inst->cltInfo[clt].szMsg, 
                    " length of data to send <> specified length", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case tcpERR_WOULDBLOCK:
      (void)strncat(inst->cltInfo[clt].szMsg, 
                    " data blocked out of socket's send buffer", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case tcpERR_NOT_CONNECTED:
      (void)strncat(inst->cltInfo[clt].szMsg, 
                    " connection closed by opposite side", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case tcpERR_SYSTEM:
      (void)strncat(inst->cltInfo[clt].szMsg, " internal error while sending", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      /************************************************************************/
      #ifdef _MBTCP_LOGGER_DEBUG
      ERRxwarning( mbtERR_NOT_CONNECTED,
                   inst->cltInfo[clt].udiIdent,
                   "MBTCP Server: Tcp Send tcpERR_SYSTEM"); 
      /************************************************************************/
      #endif
      break;
    default:
      (void)strncat(inst->cltInfo[clt].szMsg, " unknown error", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    }
    break;
  /*-----------------------------------------------------------------------------
    DEBUG: client_handler state machine: DISCONNECT
  ------------------------------------------------------------------------------*/ 
  case enMBTCP_CLT_HANDLER_DISCONNECT:
    (void)strncat( inst->cltInfo[clt].szMsg, 
                   "DISCONNECT:TCP_CLOSE:", 
                   msize - strlen(inst->cltInfo[clt].szMsg));
    (void)itoa(inst->stTcpClose[clt].status, (UDINT) &errstr);
    (void)strncat( inst->cltInfo[clt].szMsg, 
                   errstr, 
                   msize - strlen(inst->cltInfo[clt].szMsg));
    /* verfiy status */
    switch (inst->stTcpClose[clt].status)
    {
    case ERR_OK:
      (void)strncat(inst->cltInfo[clt].szMsg, " OK. Client connection closed", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      /************************************************************************/
      #ifdef _MBTCP_LOGGER_EVENT      
      ERRxwarning( mbtEVENT_CLOSE_CLIENT,
                   inst->stTcpClose[clt].ident,
                   "MBTCP Server: Close Client");
      #endif
      /************************************************************************/
      break;
    case ERR_FUB_BUSY:
      (void)strncat(inst->cltInfo[clt].szMsg, " FUB_BUSY, Still trying...", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case tcpERR_INVALID_IDENT:
      (void)strncat(inst->cltInfo[clt].szMsg, " INVALID_IDENT", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    case ERR_FUB_ENABLE_FALSE:
      (void)strncat(inst->cltInfo[clt].szMsg, " FUB_ENABLE_FALSE", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    default:
      (void)strncat(inst->cltInfo[clt].szMsg, " unknown error", 
                    msize - strlen(inst->cltInfo[clt].szMsg));
      break;
    }
    break;
  }
  /*==========================================================================*/
  } /* mberror */

/******************************************************************************
 * END OF CODE
 ******************************************************************************/
/*
Local Variables:
c-file-style: bsd
c-basic-offset: 2
comment-column: 45
End:
 */
