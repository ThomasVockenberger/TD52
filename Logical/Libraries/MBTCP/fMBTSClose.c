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
 * Filename:     fMBTSClose.c
 * 
 * Function:     module-description
 *
 * Dependencies: description of all dependencies
 *
 *****************************************************************************
 * History:
 *
 * Version | Date        | Author      | Description
 * ---------------------------------------------------------------------------
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
void fMBTSClose(struct fMBTSClose* inst)
/*----------------------------------------------------------------------------
  Function:  
 
  Terminates a Modbus/TCP slave (server) and releases allocated
  memory.  fMBTSClose() should be called in the EXIT section of a
  task. See also fMBTSOpen() and fMBTSlave().

  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes    | creation
     5.00 | 2021-may-07 | W.Froehlich  | set correct FUB state fMBTSClose.uiStatus from ERR_FUB_BUSY to ERR_OK
  ===========================================================================*/
{
  /* _LOCAL */
  UINT u, c, fstatus = 0;
  USINT usiClientNr;
  /* _DYNAMIC */
  tstMBT_SVars* mbs;
  /*=========================================================================*/
  /* check if nil pointer */
  if (inst == NULL || inst->udiIdent == 0)
  {
    inst->uiStatus = mbtERR_NULL_POINTER;
	   goto END;
  }
  mbs = (tstMBT_SVars *)inst->udiIdent;

  if (inst->bEnable < TRUE)
  {
    inst->uiStatus = ERR_FUB_ENABLE_FALSE;
  }
  else
  {
		/* set correct FUB state fMBTSClose.uiStatus from ERR_FUB_BUSY to ERR_OK */
    inst->uiStatus = ERR_OK;
    
    /* disconnect all clients and close slave's port */
    mbs->uiStep = CLOSE_SLAVE;
    usiClientNr = mbs->usiCltNr;
    /* call fMBTSStates() */ 
    fMBTSStates(mbs);  /* internal main state machine */
    c = 0;
    while (    (mbs->bClosing > 0) 
            && (c < MAX_CLOSE_LOOPS))
    {
      fMBTSStates(mbs);
      c++;
    }
      
    
    for (u = 0; u < mbs->pData->uiNbrUnits; u++) 
    {  
      if (mbs->pData->stUnit[0].bCoilsExtern == FALSE)
      {    
        fstatus = TMP_free(mbs->pData->stUnit[u].uiNbrCoils * sizeof(tCOIL),    
                             (void**)(mbs->pData->stUnit[u].pCoils));  
        if (fstatus > 0)  
        {
          inst->uiStatus = fstatus;
          ERRxwarning(fstatus, 0, 
                      (STRING*)"fMBTSClose: failed to TMP_free pCoils");
          goto END;  /* EXIT_FAILURE; */
        }
      }
      
      if (mbs->pData->stUnit[0].bDiscreteInputsExtern == FALSE)
      {
        fstatus = 
          TMP_free(mbs->pData->stUnit[u].uiNbrDiscreteInputs * sizeof(tDINP),
                   (void**)(mbs->pData->stUnit[u].pDiscreteInputs));  
        if (fstatus > 0)
        {
          inst->uiStatus = fstatus;  
          ERRxwarning(fstatus, 0,
                      (STRING*)"fMBTSClose: failed to TMP_free pDiscreteInputs");
          goto END;  /* EXIT_FAILURE; */
        }
      }
      
      if (mbs->pData->stUnit[0].bInputRegsExtern == FALSE)
      {
        fstatus = TMP_free(mbs->pData->stUnit[u].uiNbrInputRegs * sizeof(tIREG),
                           (void**)(mbs->pData->stUnit[u].pInputRegs));  
        if (fstatus > 0)  
        { 
          inst->uiStatus = fstatus;  
          ERRxwarning(fstatus, 0,  
                      (STRING*)"fMBTSClose: failed to TMP_free pInputRegs");  
          goto END;  /* EXIT_FAILURE; */
        }
      }
      
      if (mbs->pData->stUnit[0].bHoldingRegsExtern == FALSE)
      {
        fstatus = TMP_free(mbs->pData->stUnit[u].uiNbrHoldingRegs * sizeof(tHREG),
                           (void**)(mbs->pData->stUnit[u].pHoldingRegs));  
        if (fstatus > 0)  
        { 
          inst->uiStatus = fstatus;  
          ERRxwarning(fstatus, 0,  
                      (STRING*)"fMBTSClose: failed to TMP_free pHoldingRegs");  
          goto END;  /* EXIT_FAILURE; */
        }
      }
    }  

    fstatus = TMP_free(sizeof(tstMBT_SData), (void**)mbs->pData); 
    if (fstatus > 0)  
    { 
      inst->uiStatus = fstatus;  
      ERRxwarning(fstatus, 0, 
                  (STRING*)"fMBTSClose: failed to TMP_free pData");  
        goto END;  /* EXIT_FAILURE; */
    }  
    fstatus = TMP_free(sizeof(tstMBT_SVars), (void**)mbs); 
		inst->udiIdent = 0;
    if (fstatus > 0)  
    { 
      inst->uiStatus = fstatus;  
      ERRxwarning(fstatus, 0, (STRING*)"fMBTSClose: failed to TMP_free mbs");  
      goto END;  /* EXIT_FAILURE; */
    }  
  }
  END: ; /* do nothing */
  /*=========================================================================*/
  } /* fMBTSClose */

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
