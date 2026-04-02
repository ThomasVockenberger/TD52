/*****************************************************************************
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
 * Filename:     fMBTSlave.c
 * 
 * Function:     module-description
 *
 * Dependencies: description of all dependencies
 *
 *****************************************************************************
 * History:
 *
 * Version | Date        | Author      | Description
 * --------------------------------------------------------------------------
 *    1.00 | 2008-sep-19 | H.Anderes   | creation
 *****************************************************************************/

/*****************************************************************************
 * includes
 *****************************************************************************/
/* ansi-c import */
/* system import */
/* user defined import */
#include "MBTCP.h"
#include "MBTSlave.h"

/*****************************************************************************
 * type definitions
 *****************************************************************************/

/*****************************************************************************
 * functions
 *****************************************************************************/
/*===========================================================================*/
void fMBTSlave(struct fMBTSlave* inst)
/*----------------------------------------------------------------------------
  Function:  

  Modbus/TCP slave (server) function. fMBTSlave() should be called in
  the CYCLIC section of a task after being configured by
  fMBTSOpen(). The server is closed by fMBTSClose(). This server can
  be read from or written to by fMBTMaster() or widely available
  Modbus over TCP programs. 
 
  History:

  Version | Date        | Author      | Description
  --------------------------------------------------------------------------
  1.00    | 2008-sep-19 | H.Anderes   | creation
  2.00    | 2010-okt-04 | H.Anderes   | refactory
  ===========================================================================*/
{
  /* _LOCAL */
  /* _DYNAMIC */
  tstMBT_SVars* mbs;
  UINT i;
  /*=========================================================================*/
  /* check if nil pointer */
  if (inst == NULL || inst->udiIdent == 0)
  {
    inst->uiStatus = mbtERR_NULL_POINTER;
    goto END;
  } 
  mbs = (tstMBT_SVars *) inst->udiIdent;

  if (inst->bEnable < TRUE)
  {
    inst->uiStatus = ERR_FUB_ENABLE_FALSE;
  }
  else
  {
    mbs->bEnable = inst->bEnable;
    for(i = 0; i < MAX_CLIENT; i++)          /* timeout setting */
    {
      if (inst->tiRecvDelay > 0)
      {
        mbs->TOFRecv[i].PT = inst->tiRecvDelay;
      }
      else
      {
        mbs->TOFRecv[i].PT = TIMEOUT_MS;
      }
    }
    /* call  fMBTSStates() */
    fMBTSStates(mbs);
  
    /* copy internal to the fub interface */
    inst->uiStatus          = mbs->uiStatus;
    inst->uiStep            = mbs->uiStep;   
    inst->usiClientNbr      = mbs->usiCltNr;    
    inst->usiClientServed   = mbs->usiCltServed;  
    inst->tiRecvElapsed     = mbs->TOFRecv[mbs->usiCltServed].ET; /* timeout */
    strcpy(inst->usiClientIP, mbs->cltInfo[mbs->usiCltServed].szIp_addr); 
    inst->usiUnit           = mbs->stRecvBuf[mbs->usiCltServed].byte[6];    
    inst->usiMBFuncCode     = mbs->stRecvBuf[mbs->usiCltServed].byte[7]; 
   	strcpy(inst->szMsg, mbs->szMsg);
   	inst->stTcpServerStatus = mbs->stTcpServer.status;
   	inst->usiOpenRetries    = mbs->usiOpenRetries;
   	inst->udiRecvCnt        = mbs->udiRecvCnt;
   	inst->udiSendCnt        = mbs->udiSendCnt;
    /* get client information for debugging */
    for(i = 0; i < MAX_CLIENT; i++)          
    {
    	 inst->CltInfo[i].udiIdent = mbs->cltInfo[i].udiIdent;
    	 inst->CltInfo[i].usiPort = mbs->cltInfo[i].usiPort; 
      strcpy(inst->CltInfo[i].szIp_addr,mbs->cltInfo[i].szIp_addr);
      strcpy(inst->CltInfo[i].szMsg,mbs->cltInfo[i].szMsg);
    }
  }

END: ; /* do nothing */
  /*=========================================================================*/
} /* fMBTSlave */

/*****************************************************************************
 * END OF CODE
 *****************************************************************************/
/*
  Local Variables:
  c-file-style: bsd
  c-basic-offset: 2
  comment-column: 45
  End:
*/
