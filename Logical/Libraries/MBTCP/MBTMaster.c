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
 * Filename:     MBTMaster.c
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
 *    1.00 | 2008-Sep-30 | H.Anderes   | creation
 *    2.00 | 2010-okt-04 | H.Anderes   | refactory
 *    5.00 | 2021-may-07 | W.Froehlich | set correct FUB state fMBTSClose.uiStatus
 *****************************************************************************/

/******************************************************************************
 * includes
 *****************************************************************************/
/* ansi-c import */
/* system import */
/* user defined import */
#include "MBTMaster.h"

/******************************************************************************
 * functions
 ******************************************************************************/
/*============================================================================*/
void fMBTMStates(tstMBT_MVars* inst)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
  1.00    | 2008-sep-30 | H.Anderes    | creation
  2.00    | 2010-okt-04 | H.Anderes   | refactory
  ============================================================================*/
{
  /* _LOCAL */
  UINT uiFatalErrNum;
  USINT i, usiOp;                            /* usiOp: number of operations */
  USINT recv_status;
  /* _DYNAMIC */
  /*==========================================================================*/
  /* check if a null pointer is passed to the fub */
  if (inst == NULL) 
  {
    return;
  }    
  /*--------------------------------------------------------------------------------
    state machine : Modbus TCP Master
  ---------------------------------------------------------------------------------*/
  switch(inst->uiStep) 
  {
  /*-----------------------------------------------------------------------------
    INIT: initialize TcpSend and TCPRecv
  ------------------------------------------------------------------------------*/
  case INIT:
    inst->stTcpSend.pData   = (UDINT)inst->usiSendBuf;
    inst->stTcpRecv.pData   = (UDINT)inst->usiRecvBuf; 
    inst->stTcpRecv.datamax = MAX_BUFFER_LEN;
    inst->uiStep            = DISABLE;
    /* FALL THROUGH */ 
  /*-----------------------------------------------------------------------------
    DISBALE: waits until the fub is enabled
  ------------------------------------------------------------------------------*/
  case DISABLE:
    if(inst->bEnable) 
    {
      inst->uiStep = OPEN_PORT;
    }
    break;
  /*-----------------------------------------------------------------------------
    OPEN: opens a TCP - socket
  ------------------------------------------------------------------------------*/
  case OPEN_PORT:
    inst->stTcpOpen.enable = 1;
    inst->stTcpOpen.port   = 0;
    /* call TcpOpen() */
    TcpOpen(&inst->stTcpOpen);
    /* verfiy status */
    switch (inst->stTcpOpen.status)
    {
    /*-------------------------------------------------------------------------*/
    case ERR_OK:
      inst->stTcpClient.enable     = 1;
      inst->stTcpClient.ident      = inst->stTcpOpen.ident;
      inst->stTcpClient.pServer    = (UDINT)inst->slvIPAddr;
      inst->stTcpClient.portserv   = inst->uiPort;
      inst->stTcpSend.ident        = inst->stTcpOpen.ident;
      inst->stTcpRecv.ident        = inst->stTcpOpen.ident;
      inst->uiStep                 = IOCTL;
      /************************************************************************/
      #ifdef _MBTCP_LOGGER_EVENT
	     ERRxwarning( mbtEVENT_OPEN_PORT, 
                   inst->stTcpOpen.ident,
                   "MBTCP Client: Open Port");
      #endif
      /************************************************************************/
      break;
    /*-------------------------------------------------------------------------*/
    case ERR_FUB_BUSY:
      /* do nothing */
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
    /* set linger that the connection is not abort immediately */
    inst->mLinger.lOnOff     = 0;
    inst->mLinger.lLinger    = 0;
     /* initialize fub */
    inst->stTcpIoctl.enable 	= 1;
    inst->stTcpIoctl.ident	  = inst->stTcpOpen.ident;
    inst->stTcpIoctl.ioctl 	 = tcpSO_LINGER_SET;	
    inst->stTcpIoctl.pData	  = (UDINT)&inst->mLinger;
    inst->stTcpIoctl.datalen	= sizeof(tcpLINGER_typ);
    /* call  TcpIoctl()n */
    TcpIoctl(&inst->stTcpIoctl);
    /* verify status */
    switch (inst->stTcpIoctl.status)
    {
    /*-------------------------------------------------------------------------*/
    case ERR_OK:
      inst->usiOpenRetries = 0;      /* we reset prior to next step */
      inst->uiStep         = WAIT_CONNECTION;
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
        /************************************************************************/
        #ifdef _MBTCP_LOGGER_DEBUG
		      ERRxwarning( mbtERR_OPEN_RETRIES_IOC,
                     inst->stTcpOpen.ident,
                     "MBTCP Client: OPEN Retries IOCTL");
        #endif
        /************************************************************************/                  
      }
      else
      {
        inst->uiStep = FATAL_ERROR1;
      }
      break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_PARAMETER:
      inst->uiStatus = inst->stTcpIoctl.status;
      inst->uiStep   = CLOSE_PORT;
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
    WAIT: waits until a connection to a TCP Server is acc
  ------------------------------------------------------------------------------*/
  case WAIT_CONNECTION:
    inst->stTcpClient.enable = 1;
    /* call TcpClient() */
    TcpClient(&inst->stTcpClient);
    /* verify status */
    switch (inst->stTcpClient.status)
    {
    /*-------------------------------------------------------------------------*/
    case ERR_OK:
      inst->uiStep = SEND_REQUEST;	  
      break;
    /*-------------------------------------------------------------------------*/
    case ERR_FUB_BUSY:
      /* do nothing */
	     strcpy( inst->szMsg, 
              "WAIT_CONNECTION:TcpClient: Wait Connection");
      break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_INVALID:
   	  inst->uiStep = CLOSE_PORT;
      /*************************************************************************/
      #ifdef _MBTCP_LOGGER_DEBUG
   	  ERRxwarning( tcpERR_INVALID, 
                   inst->stTcpClient.ident,
                   "MBTCP Client: Wait connecction; Invalid ");
      #endif
      /*************************************************************************/
      break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_ALREADY_CONNECTED:
      inst->uiStep = CLOSE_PORT;
      /*************************************************************************/
      #ifdef _MBTCP_LOGGER_DEBUG
	     ERRxwarning( tcpERR_ALREADY_CONNECTED,
                             inst->stTcpClient.ident,
                             "MBTCP Client: Wait connecction; Already connected");
      #endif
      /*************************************************************************/
      break;
    /*-------------------------------------------------------------------------*/
    case tcpERR_SYSTEM:
    case ERR_FUB_ENABLE_FALSE:
    default:
      inst->uiStep = FATAL_ERROR3;
      break;
    }
    break;
  /*-----------------------------------------------------------------------------
    CREATE: creates the request
  ------------------------------------------------------------------------------*/
  case SEND_REQUEST:
    if (inst->bEnable) 
    {
      inst->bRecvOK = FALSE;
      /* cycle through list of Modbus operations for MAX_NBR_REQUESTS times */
      for (i = inst->usiLastReq + 1; 
           i < (MAX_NBR_REQUESTS + inst->usiLastReq + 1); 
           i++) 
      {
        usiOp = i % MAX_NBR_REQUESTS;
        if ((*(inst->pData)).actEnable[usiOp].bSingle) 
        {
          inst->udiSendTimer[usiOp] = 
            (*(inst->pData)).actParam[usiOp].udiTimer;
        }
        if ( (((*(inst->pData)).actEnable[usiOp].bCyclic)
              || ((*(inst->pData)).actEnable[usiOp].bSingle)))
        {
          if (inst->udiSendTimer[usiOp] 
              >= (*(inst->pData)).actParam[usiOp].udiTimer) 
          {
            inst->usiLastReq = usiOp;
            inst->uiStep = SEND_REQUEST + 1;
            inst->uiTxID++;
            inst->stTcpSend.datalen = 
                create_request_to_server((tstMBT_MVars*)(inst),
                                       (tstMBT_MData*)(inst->pData),
                                       usiOp, 
                                       inst->usiSendBuf, 
                                       inst->uiTxID);
            inst->udiSendTimer[usiOp] = 0;
            break;
          } 
          else 
          {
            inst->udiSendTimer[usiOp] += inst->udiCycleTime;
          }
        } 
        else 
        {
          inst->udiSendTimer[usiOp] 
            = (*(inst->pData)).actParam[usiOp].udiTimer;
        }
      }
    } 
    else 
    {
      inst->uiStep = CLOSE_PORT;
    }
    break;
  /*-----------------------------------------------------------------------------
    SEND: sends the created request to the server/slave
  ------------------------------------------------------------------------------*/
  case SEND_REQUEST + 1:
    if (inst->bEnable)
    {
      inst->stTcpSend.enable = 1;
      /* call TcpSend() */
      TcpSend(&inst->stTcpSend);
      /* verfiy status */
      switch (inst->stTcpSend.status)
      {
      /*-------------------------------------------------------------------------*/
      case ERR_OK:
        inst->usiSendCnt   = 0;
        inst->udiRecvTimer = 0;
        inst->uiStep       = WAIT_ANSWER;
        break;
      /*-------------------------------------------------------------------------*/
      case ERR_FUB_BUSY:
	       /* do nothing */
		      strcpy( inst->szMsg, 
                "SEND_REQUEST + 1:TcpSend: ERR_FUB_BUSY");
	  	    break;
      /*-------------------------------------------------------------------------*/
      case tcpERR_WOULDBLOCK:
         /* send again */
         /************************************************************************/
         #ifdef _MBTCP_LOGGER_DEBUG
  	      ERRxwarning( tcpERR_WOULDBLOCK, 
                      inst->stTcpClient.ident,
                      "MBTCP Client: Wouldblock");
         #endif
         /***********************************************************************/
   	   	break;
      /*-------------------------------------------------------------------------*/
      case tcpERR_SENTLEN:
        /* send length not ok. send again */
        /************************************************************************/
        #ifdef _MBTCP_LOGGER_DEBUG
        ERRxwarning( tcpERR_SENTLEN,
                     inst->stTcpClient.ident,
                     "MBTCP Client: Send lenght not Ok");
        #endif
        /************************************************************************/		
        break;
      /*------------------------------------------------------------------------*/
      case tcpERR_NOT_CONNECTED:
        inst->uiStep = CLOSE_PORT;
        /************************************************************************/
        #ifdef _MBTCP_LOGGER_DEBUG
		      ERRxwarning( tcpERR_NOT_CONNECTED,
                     inst->stTcpClient.ident,
                     "MBTCP Client: Not connected");
        #endif
        /************************************************************************/
        break;
      /*-------------------------------------------------------------------------*/
      case tcpERR_INVALID_IDENT:
      case tcpERR_PARAMETER:
      case tcpERR_SYSTEM:
      default:
        inst->uiStep = FATAL_ERROR4;
        break;
      }
    }
    else
    {
      inst->uiStep = CLOSE_PORT;
    }
    break;
  /*-----------------------------------------------------------------------------
    WAIT: waits until a response is received or a timeout occured
  ------------------------------------------------------------------------------*/   
  case WAIT_ANSWER:
    if (inst->bEnable)
    {
      inst->udiRecvTimer += inst->udiCycleTime;
      if (inst->udiRecvTimer >= inst->uiRecvTimeout)
      {
        /* send again after timeout */
        inst->uiStep = SEND_REQUEST;
        /************************************************************************/
        #ifdef _MBTCP_LOGGER_DEBUG
		      ERRxwarning( mbtERR_TIMEOUT, 
                     inst->stTcpClient.ident, 
                     "MBTCP Client: Receive Timeout");
        #endif
        /************************************************************************/
        break;
      }
      inst->stTcpRecv.enable = 1;
      /* call TcpRecv() */
      TcpRecv(&(inst->stTcpRecv));
      /* verfiy status */
      switch (inst->stTcpRecv.status)
      {
      /*-------------------------------------------------------------------------*/
      case ERR_OK:
        if (inst->stTcpRecv.recvlen > 8) 
        {
          recv_status = 
            analyze_answer_from_server((tstMBT_MVars*)(inst),
                                       (tstMBT_MData*)(inst->pData), 
                                       inst->usiLastReq, 
                                       inst->usiRecvBuf, 
                                       inst->uiTxID);
        }
        else
        {
          recv_status = 1;
        }
        if(recv_status)
		      {
           inst->udiWrongMsg++;
           /**********************************************************************/
           #ifdef _MBTCP_LOGGER_DEBUG
 		        ERRxwarning( mbtERR_RESPONSE, 
                        inst->stTcpRecv.ident,
                        "MBTCP Client: Response not Ok");
           #endif
           /**********************************************************************/
                        
        }
        else
        { 
          (*(inst->pData)).actEnable[inst->usiLastReq].bSingle = 0;
        } 
        inst->uiStep = SEND_REQUEST;
        break;
      /*-------------------------------------------------------------------------*/
      case ERR_FUB_BUSY:
      case ERR_FUB_ENABLE_FALSE:
      case tcpERR_NO_DATA:
        /* do nothing */
		      strcpy(inst->szMsg, "WAIT_ANSWER:TcpClient: tcpERR_NO_DATA");
        break;
      /*-------------------------------------------------------------------------*/
      case tcpERR_NOT_CONNECTED:
        inst->uiStep = SEND_REQUEST;
		      strcpy(inst->szMsg, "WAIT_ANSWER:TcpClient: tcpERR_NOT_CONNECTED");
        break;
      /*-------------------------------------------------------------------------*/
      case tcpERR_INVALID_IDENT:
      case tcpERR_PARAMETER:
      case tcpERR_INVALID:
      case tcpERR_NO_OOBDATA:
      case tcpERR_SYSTEM:
      default:
        inst->uiStep = FATAL_ERROR5;
        break;
      }
    }
    else
    {
      inst->uiStep = CLOSE_PORT;
    }
    break;
  /*-----------------------------------------------------------------------------
    CLOSE: closes the TCP - Socket
  ------------------------------------------------------------------------------*/   
  case CLOSE_PORT:
    inst->stTcpClose.enable = 1;
    inst->stTcpClose.ident  = inst->stTcpOpen.ident;
    /*
      inst->stTcpClose.how    = tcpSHUT_RD | tcpSHUT_WR;
    */
    inst->stTcpClose.how    = 0;
    /* call TcpClose() */
    TcpClose(&inst->stTcpClose);
    /* verfiy status */
    switch (inst->stTcpClose.status)
    {
    /*-------------------------------------------------------------------------*/  
    case ERR_OK:
      inst->uiStep = DISABLE;
      /*************************************************************************/
      #ifdef _MBTCP_LOGGER_DEBUG
	     ERRxwarning( mbtEVENT_CLOSE_PORT,
                   inst->stTcpClose.ident,
                   "MBTCP Client: Close Port");
      #endif
      /*************************************************************************/
      break;
    /*-------------------------------------------------------------------------*/  
    case ERR_FUB_BUSY:
      /* do nothing */
      break;
    /*-------------------------------------------------------------------------*/  
    case tcpERR_INVALID_IDENT:
      inst->uiStep = WAIT_CONNECTION;
      break;
    /*-------------------------------------------------------------------------*/  
    case ERR_FUB_ENABLE_FALSE:
    default:
      inst->uiStep = FATAL_ERROR6;
      break;
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
	  default:
		   uiFatalErrNum = 7; break;		
	  }
	   /*************************************************************************/
    #ifdef _MBTCP_LOGGER_DEBUG
   	ERRxwarning( mbtERR_FATAL_ERROR,
                 uiFatalErrNum,
                 "MBTCP Client: FATAL ERROR State Machine");
    #endif
    /*************************************************************************/
   	inst->uiStep = FINAL_ERROR;
    break;
	
  case FINAL_ERROR:
  	/*Do nothing until Reboot RPS*/
  	break;
  }
}


/*============================================================================*/
UINT create_request_to_server(tstMBT_MVars* inst,
                               tstMBT_MData* config,
                               USINT         usiOp,
                               USINT*        usiSendBuf,
                               UINT          uiTxID)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-30 | H.Anderes    | creation
  ============================================================================*/
{
  UINT  uint_var, data_len, i;
  INT  int_var;
  UINT  value;
  UINT  val;
 /*==========================================================================*/
  data_len = 0;

  memset(usiSendBuf, 0, MAX_BUFFER_LEN);
  /* Transaction id: 2 bytes */
  uint_var = SWAPUINT(uiTxID);
  memmove(&usiSendBuf[0], &uint_var, sizeof(uint_var));
  /* Protocol id: 2 bytes */
  uint_var = 0;
  memmove(&usiSendBuf[2], &uint_var, sizeof(uint_var));
  /* Length: 2 bytes */
  /* Unit: 1 byte */
  usiSendBuf[6] = (*config).actParam[usiOp].usiUnit;
  
  switch((*config).actParam[usiOp].usiFCode) 
  {
  /*-------------------------------------------------------------------------
      READ: read coils
  --------------------------------------------------------------------------*/
  case READ_COILS:
    /* Function code: 1 byte */
    usiSendBuf[7] = READ_COILS;
    /* Starting address: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiReadAddr);
    memmove(&usiSendBuf[8], &uint_var, sizeof(uint_var));
    /* Coils number: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiReadQty);
    memmove(&usiSendBuf[10], &uint_var, sizeof(uint_var));
    /* Data len */
    data_len = 6;
    inst->bRecvOK = FALSE;
    break;
  /*-------------------------------------------------------------------------
      READ: read discrete inputs
  --------------------------------------------------------------------------*/
  case READ_DISCRETE_INPUTS:
    /* Function code: 1 byte */
    usiSendBuf[7] = READ_DISCRETE_INPUTS;
    /* Starting address: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiReadAddr);
    memmove(&usiSendBuf[8], &uint_var, sizeof(uint_var));
    /* Inputs number: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiReadQty);
    memmove(&usiSendBuf[10], &uint_var, sizeof(uint_var));
    /* Data len */
    data_len = 6;
    inst->bRecvOK = FALSE;
    break;
  /*-------------------------------------------------------------------------
      READ: read holding registers
  --------------------------------------------------------------------------*/
  case READ_HOLDING_REGISTERS:
    /* Function code: 1 byte */
    usiSendBuf[7] = READ_HOLDING_REGISTERS;
    /* Starting address: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiReadAddr);
    memmove(&usiSendBuf[8], &uint_var, sizeof(uint_var));
    /* Holding registers number: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiReadQty);
    memmove(&usiSendBuf[10], &uint_var, sizeof(uint_var));
    /* Data len */
    data_len = 6;
    inst->bRecvOK = FALSE;
    break;
  /*-------------------------------------------------------------------------
      READ: read input registers
  --------------------------------------------------------------------------*/
  case READ_INPUT_REGISTERS:
    /* Function code: 1 byte */
    usiSendBuf[7] = READ_INPUT_REGISTERS;
    /* Starting address: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiReadAddr);
    memmove(&usiSendBuf[8], &uint_var, sizeof(uint_var));
    /* Input registers number: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiReadQty);
    memmove(&usiSendBuf[10], &uint_var, sizeof(uint_var));
    /* Data len */
    data_len = 6;
    inst->bRecvOK = FALSE;
    break;
  /*-------------------------------------------------------------------------
      WRITE: write single coil
  --------------------------------------------------------------------------*/
  case WRITE_SINGLE_COIL:
    /* Function code: 1 byte */
    usiSendBuf[7] = WRITE_SINGLE_COIL;
    /* Starting address: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiWriteAddr);
    memmove(&usiSendBuf[8], &uint_var, sizeof(uint_var));
    /* Value: 2 bytes */
    memmove(&val, (UINT *)((*config).actParam[usiOp].puiWriteVal), sizeof(UINT));
    if ((BOOL)(val)) 
      value = ON;
    else
      value = OFF;
    int_var = SWAPUINT(value);
    memmove(&usiSendBuf[10], &int_var, sizeof(int_var));
    /* Data len */
    data_len = 6;
    inst->bRecvOK = FALSE;
    break;
  /*-------------------------------------------------------------------------
      WRITE: write single register
  --------------------------------------------------------------------------*/
  case WRITE_SINGLE_REGISTER:
    /* Function code: 1 byte */
    usiSendBuf[7] = WRITE_SINGLE_REGISTER;
    /* Starting address: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiWriteAddr);
    memmove(&usiSendBuf[8], &uint_var, sizeof(uint_var));
    /* Value: 2 bytes */
    memmove(&val, (UINT *)(*config).actParam[usiOp].puiWriteVal, sizeof(UINT));
    value = (UINT)(val);
    uint_var = SWAPUINT(value);
    memmove(&usiSendBuf[10], &uint_var, sizeof(uint_var));
    /* Data len */
    data_len = 6;
    inst->bRecvOK = FALSE;
    break;
  /*-------------------------------------------------------------------------
      WRITE: write multiple coils
  --------------------------------------------------------------------------*/
  case WRITE_MULTIPLE_COILS:
    /* Function code: 1 byte */
    usiSendBuf[7] = WRITE_MULTIPLE_COILS;
    /* Starting address: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiWriteAddr);
    memmove(&usiSendBuf[8], &uint_var, sizeof(uint_var));
    /* Quantity: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiWriteQty);
    memmove(&usiSendBuf[10], &uint_var, sizeof(uint_var));
    /* Byte count: 1 byte */
    /* Number of usiSendBuf bytes needed to contain data */
    /* less than 8 binary digits: 1 byte */
    if ( (*config).actParam[usiOp].uiWriteQty % 8)
      usiSendBuf[12] = ((*config).actParam[usiOp].uiWriteQty / 8) + 1;
    else      /* more than 8 binary digits: quantity / 8 bytes */
      usiSendBuf[12] = (*config).actParam[usiOp].uiWriteQty / 8;
    /* Coil value: x byte */
    for (i = 0; i < (*config).actParam[usiOp].uiWriteQty; i++) 
    {
      memmove(&val, 
              (UINT *)((*config).actParam[usiOp].puiWriteVal  +  i * sizeof(UINT)),
              sizeof(UINT));
      if ((BOOL)(val))
        usiSendBuf[13 + (i/8)] 
          = usiSendBuf[13 + (i/8)] | (USINT)(0x01 << (i%8));
      else
        usiSendBuf[13 + (i/8)] 
          = usiSendBuf[13 + (i/8)] & (USINT)~(0x01 << (i%8));
    }
    /* Data len */
    data_len = 7 + usiSendBuf[12];
    inst->bRecvOK = FALSE;
    break;
  /*-------------------------------------------------------------------------
      WRITE: write multiple registers
  --------------------------------------------------------------------------*/
  case WRITE_MULTIPLE_REGISTERS:
    /* Function code: 1 byte */
    usiSendBuf[7] = WRITE_MULTIPLE_REGISTERS;
    /* Starting address: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiWriteAddr);
    memmove(&usiSendBuf[8], &uint_var, sizeof(uint_var));
    /* Quantity: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiWriteQty);
    memmove(&usiSendBuf[10], &uint_var, sizeof(uint_var));
    /* Byte count: 1 byte */
    usiSendBuf[12] = (*config).actParam[usiOp].uiWriteQty * 2;
    /* Coil value: x byte */
    for(i = 0; i < (*config).actParam[usiOp].uiWriteQty; i++)
    {
      value = ((INT*)((*config).actParam[usiOp].puiWriteVal))[i];
      int_var = SWAPINT(value);
      memmove(&usiSendBuf[13 + (i*2)], &int_var, sizeof(int_var));
    }
    /* Data len */
    data_len = 7 + usiSendBuf[12];
    inst->bRecvOK = FALSE;
    break;
  /*-------------------------------------------------------------------------
     READ WRITE:read  write multiple registers
  --------------------------------------------------------------------------*/  
  case READ_WRITE_MULTIPLE_REGISTERS:
    /* Function code: 1 byte */
    usiSendBuf[7] = READ_WRITE_MULTIPLE_REGISTERS;
    /* Read starting address: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiReadAddr);
    memmove(&usiSendBuf[8], &uint_var, sizeof(uint_var));
    /* Read quantity: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiReadQty);
    memmove(&usiSendBuf[10], &uint_var, sizeof(uint_var));
    /* Write starting address: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiWriteAddr);
    memmove(&usiSendBuf[12], &uint_var, sizeof(uint_var));
    /* write quantity: 2 bytes */
    uint_var = SWAPUINT((*config).actParam[usiOp].uiWriteQty);
    memmove(&usiSendBuf[14], &uint_var, sizeof(uint_var));
    /* Byte count: 1 byte */
    usiSendBuf[16] = (*config).actParam[usiOp].uiWriteQty * 2;
    /* Coil value: x byte */
    for(i = 0; i < (*config).actParam[usiOp].uiWriteQty; i++)
    {
      value = ((INT*)((*config).actParam[usiOp].puiWriteVal))[i];
      int_var = SWAPINT(value);
      memmove(&usiSendBuf[17 + (i*2)], &int_var, sizeof(int_var));
    }
    /* Data len */
    data_len = 11 + usiSendBuf[16];
    inst->bRecvOK = FALSE;
    break;
  default:
    break;
  }
  /* Length: 2 bytes */
  uint_var = SWAPUINT(data_len);
  memmove(&usiSendBuf[4], &uint_var, sizeof(uint_var));

  return (6 + data_len);
}



 /*==========================================================================*/
USINT analyze_answer_from_server(tstMBT_MVars* inst, 
                                 tstMBT_MData* config,
                                 USINT         usiOp,
                                 USINT*        usiRecvBuf,
                                 UINT          uiTxID)
/*----------------------------------------------------------------------------
  Function:  
  
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-30 | H.Anderes   | creation
     2.00 | 2010-okt-04 | H.Anderes   | refactory
  ============================================================================*/
{
  INT   int_var;
  UINT  uint_var, recv_tr_id, protocol_id, length, uiQty,i;
  USINT unit, function_code;
  UINT  coil_val, di_val;         /* was UDINT */
  /*==========================================================================*/

  coil_val = 0;
  di_val   = 0;
  /* (byte 0,1)  transition is */
  memmove(&uint_var, &(usiRecvBuf[0]), sizeof(uint_var));
  recv_tr_id = SWAPUINT(uint_var);
  /* (byte 2,3)  protocol id */
  memmove(&uint_var, &(usiRecvBuf[2]), sizeof(uint_var));
  protocol_id = SWAPUINT(uint_var);
  /* (byte 4,5)  length */
  memmove(&uint_var, &(usiRecvBuf[4]), sizeof(uint_var));
  length = SWAPUINT(uint_var);
  /* (byte 4,5)  length */
  unit = usiRecvBuf[6];
  /* (byte 7 ) function code */
  function_code = usiRecvBuf[7];

  if (    (recv_tr_id == uiTxID)
       && (protocol_id == 0)
       && (length > 0)
       && (function_code  < 0x80) )  
  {
  	
    switch(function_code) 
    {
    /*-------------------------------------------------------------------------
      READ: read coils
    --------------------------------------------------------------------------*/
    case READ_COILS:
      /* Quantity: 1 byte */
      uiQty = usiRecvBuf[8];
      if (uiQty > MAX_COILS)
      {
        uiQty = MAX_COILS;
      }
      /* Coil value: x bytes */
      /* uiQty is number of bytes received */
      for (i = 0;(i < uiQty*8) && (i < (*config).actParam[usiOp].uiReadQty); i++) {
        coil_val = (UINT)(usiRecvBuf[9 + (i/8)] & (USINT)(0x01 << (i%8)));
        if ((BOOL)(coil_val))
          ((INT*)((*config).actParam[usiOp].puiReadVal))[i] = 1;
        else
          ((INT*)((*config).actParam[usiOp].puiReadVal))[i] = 0;
      }
      inst->bRecvOK = TRUE;
      break;
    /*-------------------------------------------------------------------------
      READ: read discrete inputs
    --------------------------------------------------------------------------*/
    case READ_DISCRETE_INPUTS:
      /* Quantity: 1 byte */
      uiQty = usiRecvBuf[8];
      if (uiQty > MAX_COILS)
      {
        uiQty = MAX_COILS;
      }
      /* Coil value: x byte */
      /* quantity is number of bytes received */
      for(i = 0; (i < uiQty*8) && (i < (*config).actParam[usiOp].uiReadQty); i++) {
        di_val = (UINT)(usiRecvBuf[9 + (i/8)] & (USINT)(0x01 << (i%8)));
         if ((BOOL)(di_val)) 
           ((INT*)((*config).actParam[usiOp].puiReadVal))[i] = 1;
         else 
           ((INT*)((*config).actParam[usiOp].puiReadVal))[i] = 0;
      }
      inst->bRecvOK = TRUE; 
      break;
    /*-------------------------------------------------------------------------
      READ: read hoding registers
    --------------------------------------------------------------------------*/
    case READ_HOLDING_REGISTERS:
      /* Quantity: 1 byte */
       uiQty = usiRecvBuf[8] / 2;
       if (uiQty > MAX_REGISTER)
       {
         uiQty = MAX_REGISTER;
       }
      /* Coil value: x byte */
      for(i = 0; i < uiQty; i++) {
        memmove(&int_var, &usiRecvBuf[9 + (i*2)], sizeof(int_var));
        ((INT*)((*config).actParam[usiOp].puiReadVal))[i] = SWAPINT(int_var);
      }
      inst->bRecvOK = TRUE;  
      break;
    /*-------------------------------------------------------------------------
      READ: read input registers
    --------------------------------------------------------------------------*/
    case READ_INPUT_REGISTERS:
      /* Quantity: 1 byte */
      uiQty = usiRecvBuf[8] / 2;
      if (uiQty > MAX_REGISTER)
      {
        uiQty = MAX_REGISTER;
      }
      /* Coil value: x byte */
      for(i = 0; i < uiQty; i++) {
        memmove(&int_var, &usiRecvBuf[9 + (i*2)], sizeof(int_var));
        ((INT*)((*config).actParam[usiOp].puiReadVal))[i] = SWAPINT(int_var);
      }
      inst->bRecvOK = TRUE; 
      break;
    /*-------------------------------------------------------------------------
      READ: read write multiple registers
    --------------------------------------------------------------------------*/  
    case READ_WRITE_MULTIPLE_REGISTERS:
      /* Quantity: 1 byte */
      uiQty = usiRecvBuf[8] / 2;
      if (uiQty > MAX_REGISTER)
      {
        uiQty = MAX_REGISTER;
      }
      /* Coil value: x byte */
      for(i = 0; i < uiQty; i++) {
        memmove(&int_var, &usiRecvBuf[9 + (i*2)], sizeof(int_var));
        ((INT*)((*config).actParam[usiOp].puiReadVal))[i] = SWAPINT(int_var);
      }
      inst->bRecvOK = TRUE; 
      break;
      
    default:
      inst->bRecvOK = TRUE;
      break;
    }
  } 
  else 
  { /* if (    (recv_tr_id == uiTxID)
            && (protocol_id == 0)
            && (length > 0)
            && (function_code  < 0x80) ) */
    /*************************************************************************/
    #ifdef _MBTCP_LOGGER_DEBUG
    if(protocol_id != 0)
    {
		    ERRxwarning( mbtERR_PROTOCOL_ID, 
                   inst->stTcpRecv.ident,
                   "MBTCP Client: Protocol ID != 0");
    }
	   if(length == 0)
    {
		    ERRxwarning( mbtERR_RESPONSE,
                   inst->stTcpRecv.ident,
                   "MBTCP Client: Response lenght == 0");
    }
	   if(function_code  > 0x80)
    {
		    ERRxwarning( mbtERR_RESPONSE, 
                    inst->stTcpRecv.ident,
                    "MBTCP Client: function_code  > 0x80");
    }
    #endif
    /*************************************************************************/
  	
    return EXIT_FAILURE;
  }

  return ERR_OK;
}


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
