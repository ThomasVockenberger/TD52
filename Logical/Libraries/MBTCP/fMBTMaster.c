/****************************************************************************
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
 * Filename:     fMBTMaster.c
 * 
 * Function:     module-description
 *
 * Dependencies: description of all dependencies
 *
 ****************************************************************************
 * History:
 *
 * Version | Date        | Author      | Description
 * --------------------------------------------------------------------------
 *    1.00 | 2008-Oct-03 | H.Anderes    | creation
 *****************************************************************************/

/*****************************************************************************
 * includes
 *****************************************************************************/
/* ansi-c import */
/* system import */
/* user defined import */
#include "MBTCP.h"
#include "MBTMaster.h"

/*****************************************************************************
 * type definitions
 *****************************************************************************/

/*****************************************************************************
 * functions
 *****************************************************************************/
/*===========================================================================*/
void fMBTMaster(struct fMBTMaster* inst)
/*---------------------------------------------------------------------------
  Function:  
 
  Modbus/TCP master (client) function. fMBTMaster() 
  should be called in the CYCLIC section of a task after being 
  configured by fMBTMOpen(). The master is closed by fMBTMClose(). 
  This master writes to or reads from a slave running fMBTSlave() or 
  other widely available Modbus over TCP slave programs.
 
  History:

  Version | Date        | Author      | Description
  --------------------------------------------------------------------------
  1.00    | 2008-Oct-03 | H.Anderes    | creation
  ===========================================================================*/
{
  /* _LOCAL */
  /* _DYNAMIC */
  tstMBT_MVars *mbm;
  /*=========================================================================*/
  if (inst == NULL)
  {
    inst->uiStatus = mbtERR_NULL_POINTER;
    goto END;
  }
  mbm = (tstMBT_MVars *) inst->udiIdent;

  if (inst->bEnable < TRUE)
  {
    inst->uiStatus = ERR_FUB_ENABLE_FALSE;
  }
  else
  {

    mbm->bEnable = inst->bEnable;
    /* call fMBTMStates */ 
    fMBTMStates(mbm);

    inst->uiStep        = mbm->uiStep;
    inst->uiTxID        = mbm->uiTxID;
    inst->usiMBFuncCode = mbm->usiRecvBuf[7];
    inst->usiRxByteCnt  = mbm->usiRecvBuf[8];
	   strcpy(inst->szMsg,mbm->szMsg);
    inst->uiStatus      = mbm->uiStatus;
}

END: ; /* do nothing */
  /*=========================================================================*/
} /* fMBTMaster */

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
