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
 * Filename:     fMBTSOpen.c
 * 
 * Function:     module-description
 *
 * Dependencies: description of all dependencies
 *
 ******************************************************************************
 * History:
 *
 * Version | Date        | Author       | Description
 * ----------------------------------------------------------------------------
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
void fMBTSOpen(struct fMBTSOpen* inst)
/*----------------------------------------------------------------------------
  Function:  

  Configures a Modbus over TCP slave (server) and provides a Modbus
  slave ID. fMBTSOpen() should be called in the INIT section of a task
  prior to fMBTSlave(). See also fMBTSClose() to close the slave in
  the EXIT section. This slave can then be read from, or written to,
  by fMBTMaster() or widely available Modbus over TCP programs.
 
  History:

  Version | Date        | Author      | Description
  ----------------------------------------------------------------------------
  1.00    | 2008-sep-19 | H.Anderes   | creation
  1.01    | 2009-dez-03 | H.Anderes   | external structures
  ===========================================================================*/
{
  /* _LOCAL */
  UINT astatus    = 0;
  UINT i, u       = 0;
  BOOL extMapping = 0;
  /* _DYNAMIC */  
  tstMBT_SVars *mbs;
  tstMBT_SData *pData;
  tCOIL *pCoils;
  tDINP *pDiscreteInputs;
  tIREG *pInputRegs; 
  tHREG *pHoldingRegs;
  /*=========================================================================*/
  if (inst == NULL)
  {
    inst->uiStatus = mbtERR_NULL_POINTER;
    goto END;
  }
  if (inst->bEnable < TRUE)
  {
    inst->uiNbrAllocUnits = 0;
    inst->uiStatus = ERR_FUB_ENABLE_FALSE;
  }
  else
  {
    inst->uiStatus = ERR_FUB_BUSY;
    if (inst->uiPort < 1) 
      inst->uiPort = MBT_SLAVE_PORT;
	  
    if (inst->uiNbrUnits < 1) 
      inst->uiNbrUnits = NUNITS_DEF;
	  
   	if(inst->uiOffsetUnits > 255)
   	 { inst->uiStatus = mbtERR_NBR_UNITS; goto END; }
	 				
   	if((inst->uiOffsetUnits + inst->uiNbrUnits) > 256)
   	 { inst->uiStatus = mbtERR_NBR_UNITS; goto END; }
     
    astatus = TMP_alloc(sizeof(tstMBT_SVars), (void**)&mbs);
    if (astatus > 0) { inst->uiStatus = astatus; goto END; }
    memset(mbs, 0, sizeof(tstMBT_SVars));  
    astatus = TMP_alloc(sizeof(tstMBT_SData), (void**)&pData); 
    if (astatus > 0) { inst->uiStatus = astatus; goto END; }
    memset(pData, 0, sizeof(tstMBT_SData)); 
    mbs->pData = pData;

    /* allocate memory for coils and registers
     */
    mbs->pData->uiNbrUnits 		 = inst->uiNbrUnits;
    mbs->pData->uiOffsetUnits = inst->uiOffsetUnits;
  
    inst->uiNbrAllocUnits = 0;           /* num of allocated units */
  
   /* check if the mapping type is valid */
   if (   (inst->pbCoil  == NULL)
       && (inst->pbDInp  == NULL)
       && (inst->puiIReg == NULL)
       && (inst->puiHReg == NULL))
   {
     extMapping = FALSE;   
   }
   else 
   {
     extMapping = TRUE;
   }

    for (u = inst->uiOffsetUnits; u < (inst->uiNbrUnits + inst->uiOffsetUnits); u++)        
    {    
      if (    (inst->pbCoil == NULL)
           && (inst->uiNbrCoils > 0))
      {      
        astatus = TMP_alloc(inst->uiNbrCoils * sizeof(tCOIL), 
                            (void **) &pCoils);
        if (astatus > 0) { inst->uiStatus = astatus; goto END; }
        memset((tCOIL *) pCoils, 0, 
               inst->uiNbrCoils * sizeof(tCOIL)); 
        mbs->pData->stUnit[u].pCoils = (tCOIL *) pCoils; 
        mbs->pData->stUnit[u].uiNbrCoils = inst->uiNbrCoils;
      }
      else if (    (inst->pbCoil != NULL)
                && (inst->uiNbrCoils > 0))
      {
        mbs->pData->stUnit[u].pCoils       = (tCOIL *) inst->pbCoil;
        mbs->pData->stUnit[u].uiNbrCoils   = inst->uiNbrCoils;
        mbs->pData->stUnit[0].bCoilsExtern = TRUE;
      }

      if (    (inst->pbDInp == NULL)
           && (inst->uiNbrDiscreteInputs > 0))
      {  
        astatus = TMP_alloc(inst->uiNbrDiscreteInputs * sizeof(tDINP),  
                            (void **) &pDiscreteInputs); 
        if (astatus > 0) { inst->uiStatus = astatus; goto END; }
        memset((tDINP *) pDiscreteInputs, 0, 
               inst->uiNbrDiscreteInputs * sizeof(tDINP)); 
        mbs->pData->stUnit[u].pDiscreteInputs = (tDINP *) pDiscreteInputs; 
        mbs->pData->stUnit[u].uiNbrDiscreteInputs = inst->uiNbrDiscreteInputs;
      }
      else
      {
        mbs->pData->stUnit[u].pDiscreteInputs        = (tDINP *)  inst->pbDInp;
        mbs->pData->stUnit[u].uiNbrDiscreteInputs    = inst->uiNbrDiscreteInputs;
        mbs->pData->stUnit[0].bDiscreteInputsExtern  = TRUE;
      }
            
      if (    (inst->puiIReg == NULL)
           && (inst->uiNbrInputRegs > 0))
      {
        astatus = TMP_alloc(inst->uiNbrInputRegs * sizeof(tIREG),  
                            (void **) &pInputRegs); 
        if (astatus > 0) { inst->uiStatus = astatus; goto END; }
        memset((tIREG *) pInputRegs, 0, 
               inst->uiNbrInputRegs * sizeof(tIREG)); 
        mbs->pData->stUnit[u].pInputRegs = (tIREG *) pInputRegs;
        mbs->pData->stUnit[u].uiNbrInputRegs = inst->uiNbrInputRegs;
      }
      else
      {
        mbs->pData->stUnit[u].pInputRegs        = (tIREG *)  inst->puiIReg;
        mbs->pData->stUnit[u].uiNbrInputRegs    = inst->uiNbrInputRegs;
        mbs->pData->stUnit[0].bInputRegsExtern  = TRUE;
      }
      
      if (    (inst->puiHReg == NULL)
           && (inst->uiNbrHoldingRegs > 0))
      {
        astatus = TMP_alloc(inst->uiNbrHoldingRegs * sizeof(tHREG),  
                            (void **) &pHoldingRegs); 
        if (astatus > 0) { inst->uiStatus = astatus; goto END; }
        memset((tHREG *) pHoldingRegs, 0, 
               inst->uiNbrHoldingRegs * sizeof(tHREG)); 
        mbs->pData->stUnit[u].pHoldingRegs = (tHREG *) pHoldingRegs; 
        mbs->pData->stUnit[u].uiNbrHoldingRegs = inst->uiNbrHoldingRegs;
      }
      else
      {
        mbs->pData->stUnit[u].pHoldingRegs        = (tHREG *) inst->puiHReg; 
        mbs->pData->stUnit[u].uiNbrHoldingRegs    = inst->uiNbrHoldingRegs;
        mbs->pData->stUnit[0].bHoldingRegsExtern  = TRUE;
      }

      inst->uiNbrAllocUnits = inst->uiNbrAllocUnits + 1;
      
      /* if external mapping is used, only one mapping is allowed */
      if (extMapping == TRUE)
      {
        break; 
      }
    }      

    mbs->uiPort       = inst->uiPort;
    mbs->uiStep       = INIT;
    mbs->uiReturnStep = INIT;
    mbs->usiCltNr = 0;
    
    for (i = 0; i < MAX_CLIENT; i++)
    {  
      mbs->TOFRecv[i].IN = TRUE;                       /* reset timer */  
      TOF(&(mbs->TOFRecv[i]));  
    }

    inst->udiIdent = (UDINT) mbs;  
    if (inst->uiStatus == ERR_FUB_BUSY)                 /* alloc OK */ 
    { 
      inst->uiNbrAllocUnits = inst->uiNbrAllocUnits; 
      inst->uiStatus = ERR_OK; 
    } 
  }
END: ; /* do nothing */
  /*=========================================================================*/
} /* fMBTSOpen */

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
