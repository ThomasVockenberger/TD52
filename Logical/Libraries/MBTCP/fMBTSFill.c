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
 * Filename:     fMBTSFill.c
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
 *    1.00 | 2008-sep-19 | H.Anderes    | creation
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
void fMBTSFill(struct fMBTSFill* inst)
/*---------------------------------------------------------------------------
  Function:  
 
  Initialize the slave's data units (coils and registers) with
  values. Coils and Discrete Inputs are initialized with 0, 1,
  0... Input registers are filled with 1000, 1001, 1002... Holding
  registers are initialized with 0, 1, 2...
   
  History:

  Version | Date        | Author      | Description
  --------------------------------------------------------------------------
     1.00 | 2008-sep-19 | H.Anderes    | creation
  ===========================================================================*/
  {
  /* _LOCAL */
  UINT u, i, imax;
  /* _DYNAMIC */
  tstMBT_SVars* mbs;
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
    inst->uiStatus = ERR_FUB_BUSY;

    for (u = mbs->pData->uiOffsetUnits; u < (mbs->pData->uiNbrUnits + mbs->pData->uiOffsetUnits); u++)    
    {    
      imax = mbs->pData->stUnit[u].uiNbrCoils;    
      for (i = 0; i < imax; i++) {     
        mbs->pData->stUnit[u].pCoils[i] = 0;     
        mbs->pData->stUnit[u].pCoils[i] = (tCOIL)(i & 0x0001);     
      }     
      imax = mbs->pData->stUnit[u].uiNbrDiscreteInputs;     
      for (i = 0; i < imax; i++) {     
        mbs->pData->stUnit[u].pDiscreteInputs[i] = 0;     
        mbs->pData->stUnit[u].pDiscreteInputs[i] = (tDINP)(i & 0x0001);     
      }     
      imax = mbs->pData->stUnit[u].uiNbrInputRegs;     
      for (i = 0; i < imax; i++) {     
        mbs->pData->stUnit[u].pInputRegs[i] = (tIREG)(1000 + i);     
      }     
      imax = mbs->pData->stUnit[u].uiNbrHoldingRegs;     
      for (i = 0; i < imax; i++) {     
        mbs->pData->stUnit[u].pHoldingRegs[i] = (tHREG)(i);     
      }     
    }    
    mbs->bEnable = TRUE;
    inst->uiStatus = ERR_OK;
  }
  END: ; /* do nothing */
  /*=========================================================================*/
  } /* fMBTSFill */

/*****************************************************************************
 * END OF CODE
 *****************************************************************************/
