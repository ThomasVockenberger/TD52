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
 * Filename:     fMBTSRW.c
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
 *    1.00 | 2008-sep-25 | H.Anderes    | creation
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
void fMBTSRW(struct fMBTSRW* inst)
/*---------------------------------------------------------------------------
  Function:  
  <header>
  <p>
   Read/write individual values from/to coils and registers of given unit. 
   The function code to use in member uiFcode of the passed structure is the 
   same as for Modbus (0x01..0x06) and two user defined functions (0x41,0x42). 
   See Modbus function codes.
  
  History:

  Version | Date        | Author      | Description
  --------------------------------------------------------------------------
  1.00 | 2008-sep-19 | H.Anderes    | creation
  1.01 | 2009-mar-03 | H.Anderes   | implementation FC15, FC16
  1.01 | 2009-dez-09 | H.Anderes   | implementation FC23, change FUB interface
  ===========================================================================*/
{
  /* _LOCAL */
  UINT u, i;
  UINT coil;
  UINT hreg;
  UINT ireg;
  /* _DYNAMIC */
  tstMBT_SVars* mbs;
  tCOIL* pCoilVal;
  tDINP* pDInpVal;
  tIREG* pIRegVal;
  tHREG* pHRegVal;
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

    u = inst->usiUnit;
    if (    (u >= mbs->pData->uiNbrUnits + mbs->pData->uiOffsetUnits) 
         || (u < mbs->pData->uiOffsetUnits))
      { inst->uiStatus = mbtERR_NBR_UNITS; goto END; }
       
    switch(inst->usiFCode)
    {
    /*------------------------------------------------------------------------
      READ: read coils
    -------------------------------------------------------------------------*/
    case MBT_READ_COILS:                     /* 0x01 */
      if (inst->puiReadVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }  
      pCoilVal = (tCOIL*) inst->puiReadVal;
      i = inst->uiReadAddr;
      if (i > mbs->pData->stUnit[u].uiNbrCoils)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }     
      if (    (inst->uiReadQty > 0) 
           && (inst->uiReadQty <= (*(mbs->pData)).stUnit[u].uiNbrCoils)) 
      {  
        if (    (inst->uiReadAddr + inst->uiReadQty) 
             <= (*(mbs->pData)).stUnit[u].uiNbrCoils) 
        {
          for (i = 0; i < inst->uiReadQty; i++) 
          {
            coil = inst->uiReadAddr + i; 
            if(((*(mbs->pData)).stUnit[u].pCoils[(i)] & (USINT)(0x01)))
              pCoilVal[(i)*2 + BYTE_OFFSET]  = (tCOIL) 1;
            else
              pCoilVal[(i)*2 + BYTE_OFFSET]  = (tCOIL) 0;
           }
        }
      }     
      break;
	   /*-------------------------------------------------------------------------
      READ: read discrete inputs
    --------------------------------------------------------------------------*/
    case MBT_READ_DISCRETE_INPUTS:           /* 0x02 */
     if (inst->puiReadVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }  
      pDInpVal = (tDINP*) inst->puiReadVal;
      i = inst->uiReadAddr;
      if (i > mbs->pData->stUnit[u].uiNbrDiscreteInputs)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }        
      if (   (inst->uiReadQty > 0) 
          && (inst->uiReadQty <= (*(mbs->pData)).stUnit[u].uiNbrDiscreteInputs)) 
      {  
        if (    (inst->uiReadAddr + inst->uiReadQty) 
             <= (*(mbs->pData)).stUnit[u].uiNbrDiscreteInputs) 
        {
          for (i = 0; i < inst->uiReadQty; i++) 
          {
            coil = inst->uiReadAddr + i; 
            if(((*(mbs->pData)).stUnit[u].pDiscreteInputs[(i)] & (USINT)(0x01)))
              pDInpVal[(i)*2 + BYTE_OFFSET]  = (tCOIL) 1;
            else
              pDInpVal[(i)*2 + BYTE_OFFSET]  = (tCOIL) 0;
           }
        }
      }         
      break;
	   /*--------------------------------------------------------------------------
      READ: read discrete inputs
    ---------------------------------------------------------------------------*/
    case MBT_READ_HOLDING_REGISTERS:         /* 0x03 */
      if (inst->puiReadVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }  
      pHRegVal = (tHREG*) inst->puiReadVal;
      i = inst->uiReadAddr;
      if (i > mbs->pData->stUnit[u].uiNbrHoldingRegs)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }
      if (    (inst->uiReadQty > 0) 
           && (inst->uiReadQty <= (*(mbs->pData)).stUnit[u].uiNbrHoldingRegs)) 
      {  
        if (    (inst->uiReadAddr + inst->uiReadQty) 
             <= (*(mbs->pData)).stUnit[u].uiNbrHoldingRegs) 
        {
          for (i = 0; i < inst->uiReadQty; i++) 
          {
            hreg = inst->uiReadAddr + i; 
            pHRegVal[(i)] = mbs->pData->stUnit[u].pHoldingRegs[hreg];  
          }
        }
      }        
      break;
	   /*--------------------------------------------------------------------------
      READ: read input registers
    ---------------------------------------------------------------------------*/
    case MBT_READ_INPUT_REGISTERS:           /* 0x04 */
      if (inst->puiReadVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }  
      pIRegVal = (tIREG*) inst->puiReadVal;
      i = inst->uiReadAddr;
      if (i > mbs->pData->stUnit[u].uiNbrInputRegs)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }
      if (    (inst->uiReadQty > 0) 
           && (inst->uiReadQty <= (*(mbs->pData)).stUnit[u].uiNbrInputRegs)) 
        {  
          if (    (inst->uiReadAddr + inst->uiReadQty) 
               <= (*(mbs->pData)).stUnit[u].uiNbrInputRegs) 
          {
            for (i = 0; i < inst->uiReadQty; i++) 
            {
              ireg = inst->uiReadAddr + i; 
              pIRegVal[(i)] = mbs->pData->stUnit[u].pInputRegs[ireg];  
            }
          }
        }        
      break;
	   /*--------------------------------------------------------------------------
      WRITE: write single coil
    ---------------------------------------------------------------------------*/
    case MBT_WRITE_SINGLE_COIL:              /* 0x05 */
     if (inst->puiWriteVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }  
      pCoilVal = (tCOIL*) inst->puiWriteVal+BYTE_OFFSET;
      i = inst->uiWriteAddr;
      if (i > mbs->pData->stUnit[u].uiNbrCoils)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }
      mbs->pData->stUnit[u].pCoils[i] = *pCoilVal;
      break;
	   /*--------------------------------------------------------------------------
      WRITE: write single register
    ---------------------------------------------------------------------------*/
    case MBT_WRITE_SINGLE_REGISTER:          /* 0x06 */
      if (inst->puiWriteVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }  
      pHRegVal = (tHREG*) inst->puiWriteVal;
      i = inst->uiWriteAddr;
   	  if (i > mbs->pData->stUnit[u].uiNbrHoldingRegs)
           { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }
       mbs->pData->stUnit[u].pHoldingRegs[i] = *pHRegVal;
 	    break;
	   /*--------------------------------------------------------------------------
      WRITE: write discrete inputs
    ---------------------------------------------------------------------------*/
 	  case BR_MBT_WRITE_DISCRETE_INPUTS:       /* 0x41 */
      if (inst->puiWriteVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }  
      pDInpVal = (tDINP*) inst->puiWriteVal;
      i = inst->uiWriteAddr;  
   	  if (i > mbs->pData->stUnit[u].uiNbrDiscreteInputs)
           { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }
      if (    (inst->uiWriteQty > 0) 
            && (inst->uiWriteQty <= (*(mbs->pData)).stUnit[u].uiNbrDiscreteInputs)) 
      {
        if (    (inst->uiWriteAddr + inst->uiWriteQty)
             <= (*(mbs->pData)).stUnit[u].uiNbrDiscreteInputs) 
        {
           for (i = 0; i < inst->uiWriteQty; i++) 
           {
             coil = inst->uiWriteAddr + i;
          
             if((pDInpVal[(i*2)+ BYTE_OFFSET] & (USINT)(0x01)))
                 (*(mbs->pData)).stUnit[u].pDiscreteInputs[coil] = (tCOIL) 1;
             else
                 (*(mbs->pData)).stUnit[u].pDiscreteInputs[coil] = (tCOIL) 0;
            }
        }
      }
 	    break;
	  	/*--------------------------------------------------------------------------
      WRITE: write input register
    ---------------------------------------------------------------------------*/ 	
 	  case BR_MBT_WRITE_INPUT_REGISTERS:        /* 0x42 */
      if (inst->puiWriteVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }  
      pIRegVal = (tIREG*) inst->puiWriteVal;
      i = inst->uiWriteAddr;
   	  if (i > mbs->pData->stUnit[u].uiNbrInputRegs)
           { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }   
      if (   (inst->uiWriteQty > 0) 
          && (inst->uiWriteQty <= (*(mbs->pData)).stUnit[u].uiNbrInputRegs)) 
       {
        if (   (inst->uiWriteAddr + inst->uiWriteQty) 
            <= (*(mbs->pData)).stUnit[u].uiNbrInputRegs) 
        {
          for (i = 0; i < inst->uiWriteQty; i++) 
          {
            ireg = inst->uiWriteAddr + i; 
            (*(mbs->pData)).stUnit[u].pInputRegs[ireg] = pIRegVal[(i)];          
          }
        }
      }
      break;
	  	/*-------------------------------------------------------------------------
      WRITE: write multiple coils
    --------------------------------------------------------------------------*/  
    case MBT_WRITE_MULTIPLE_COILS:           /* 0x0F */
      if (inst->puiWriteVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }  
      pCoilVal = (tCOIL*) inst->puiWriteVal;
      i = inst->uiWriteAddr;
      if (i > mbs->pData->stUnit[u].uiNbrCoils)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }
    		if (    (inst->uiWriteQty > 0) 
    	      && (inst->uiWriteQty <= (*(mbs->pData)).stUnit[u].uiNbrCoils)) 
    		{
  	    	if (    (inst->uiWriteAddr + inst->uiWriteQty)
  	         	<= (*(mbs->pData)).stUnit[u].uiNbrCoils) 
  	    	{
  	        for (i = 0; i < inst->uiWriteQty; i++) 
  	      		{
  	          coil = inst->uiWriteAddr + i;
            
  						     if((pCoilVal[(i)*2+BYTE_OFFSET]& (USINT)(0x01)))
  		          			(*(mbs->pData)).stUnit[u].pCoils[coil] = (tCOIL) 1;
  		        	else
  		          			(*(mbs->pData)).stUnit[u].pCoils[coil] = (tCOIL) 0;
  			       }
  		     }	    
    		}
		   break;
    /*--------------------------------------------------------------------------
      WRITE: write multiple register
    ---------------------------------------------------------------------------*/  
    case MBT_WRITE_MULTIPLE_REGISTERS:       /* 0x10 */
      if (inst->puiWriteVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }  
      pHRegVal = (tHREG*) inst->puiWriteVal;
      i = inst->uiWriteAddr;
      if (i > mbs->pData->stUnit[u].uiNbrHoldingRegs)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }
    		if (    (inst->uiWriteQty > 0) 
          	&& (inst->uiWriteQty <= (*(mbs->pData)).stUnit[u].uiNbrHoldingRegs)) 
      		{
    		   if (   (inst->uiWriteAddr + inst->uiWriteQty) 
    		       <= (*(mbs->pData)).stUnit[u].uiNbrHoldingRegs) 
    		   {
    		     for (i = 0; i < inst->uiWriteQty; i++) 
    		     {
    				     hreg = inst->uiWriteAddr + i; 
    		       (*(mbs->pData)).stUnit[u].pHoldingRegs[hreg] = pHRegVal[(i)];		        
    		     }
    		   }
    		}
	     break;		  
    /*--------------------------------------------------------------------------
      WRITE: read and write multiple register
    ---------------------------------------------------------------------------*/   
    case READ_WRITE_MULTIPLE_REGISTERS: 
      /*****************write multiple register ***************/
      if (inst->puiWriteVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }  
      pHRegVal = (tHREG*) inst->puiWriteVal;
      i = inst->uiWriteAddr;
      if (i > mbs->pData->stUnit[u].uiNbrHoldingRegs)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }
      if (    (inst->uiWriteQty > 0) 
           && (inst->uiWriteQty <= (*(mbs->pData)).stUnit[u].uiNbrHoldingRegs)) 
        {
          if (   (inst->uiWriteAddr + inst->uiWriteQty) 
              <= (*(mbs->pData)).stUnit[u].uiNbrHoldingRegs) 
          {
            for (i = 0; i < inst->uiWriteQty; i++) 
            {
              hreg = inst->uiWriteAddr + i; 
              (*(mbs->pData)).stUnit[u].pHoldingRegs[hreg] = pHRegVal[(i)];          
            }
          }
        }
      /*****************read multiple register ***************/
     if ( inst->puiReadVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }  
      pHRegVal = (tHREG*) inst->puiReadVal;
      i = inst->uiReadAddr;
      if (i > mbs->pData->stUnit[u].uiNbrHoldingRegs)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; }
      if (    (inst->uiReadQty > 0) 
           && (inst->uiReadQty <= (*(mbs->pData)).stUnit[u].uiNbrHoldingRegs)) 
        {  
          if (    (inst->uiReadAddr + inst->uiReadQty) 
               <= (*(mbs->pData)).stUnit[u].uiNbrHoldingRegs) 
          {
            for (i = 0; i < inst->uiReadQty; i++) 
            {
              hreg = inst->uiReadAddr + i; 
              pHRegVal[(i)] = mbs->pData->stUnit[u].pHoldingRegs[hreg];  
            }
          }
        }        
      break;
    default:
      { inst->uiStatus = mbtERR_ILLEGAL_FUNCTION; goto END; }
    }
    inst->uiStatus = ERR_OK;
  }
END: ; /* do nothing */
  /*=========================================================================*/
} /* fMBTSRW */



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
