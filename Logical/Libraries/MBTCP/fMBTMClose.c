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
 * Filename:     fMBTMClose.c
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
void fMBTMClose(struct fMBTMClose* inst)
/*---------------------------------------------------------------------------
  Function:  
  
  Terminates a Modbus/TCP master (client) and releases allocated memory. 
  fMBTMClose() should be called in the EXIT section of a task. 
  See also fMBTMOpen() and fMBTMaster(). 
 
  History:

  Version | Date        | Author      | Description
  --------------------------------------------------------------------------
  1.00 | 2008-Oct-03 | H.Anderes    | creation
  5.00 | 2021-may-07 | W.Froehlich  | set correct FUB state fMBTMClose.uiStatus from ERR_FUB_BUSY to ERR_OK
  ===========================================================================*/
{
  /* _LOCAL */
  UINT fstatus = 0;
  USINT i;
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
		/* set correct FUB state fMBTSClose.uiStatus from ERR_FUB_BUSY to ERR_OK */
    inst->uiStatus = ERR_OK;

    /* disconnect from slave */
    mbm->uiStep = CLOSE_PORT;
    for (i = 0; i < 2; i++)                  /* 2 iterations needed */
      fMBTMStates(mbm);
    
    fstatus = TMP_free(sizeof(tstMBT_MData), (void**)mbm->pData); 
    if (fstatus > 0)  
    { 
      inst->uiStatus = fstatus;  
      ERRxwarning(fstatus, 0, (STRING*)"fMBTMClose: failed to TMP_free pData");  
        goto END;
    }  
    fstatus = TMP_free(sizeof(tstMBT_MVars), (void**)mbm); 
    if (fstatus > 0)  
    { 
      inst->uiStatus = fstatus;  
      ERRxwarning(fstatus, 0, (STRING*)"fMBTMClose: failed to TMP_free mbm");  
      goto END;
    }  
  }

END: ; /* do nothing */
  /*=========================================================================*/
} /* fMBTMClose */

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
