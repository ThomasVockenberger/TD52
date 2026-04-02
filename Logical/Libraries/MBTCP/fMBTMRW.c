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
 * Filename:     fMBTMRW.c
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
void fMBTMRW(struct fMBTMRW* inst)
/*---------------------------------------------------------------------------
  Function:  
 
  Read/write individual values from/to coils and registers of given unit.
  The function code to use in member uiFcode of the passed structure is the 
  same as for Modbus (0x01..0x06). 
  
  History:

  Version | Date        | Author      | Description
  --------------------------------------------------------------------------
  1.00 | 2008-Oct-06 | H.Anderes    | creation
  ===========================================================================*/
{
  /* _LOCAL */
  /* _DYNAMIC */
  tstMBT_MVars* mbm;
  /*=========================================================================*/
  /* check if nil pointer */
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
    inst->uiStatus = ERR_FUB_BUSY;

    mbm->pData->actParam[0].usiFCode	  = inst->usiFCode;
    mbm->pData->actParam[0].usiUnit 	  = inst->usiUnit;
    mbm->pData->actParam[0].uiReadAddr  = inst->uiReadAddr;
    mbm->pData->actParam[0].uiReadQty 	= inst->uiReadQty;
    mbm->pData->actParam[0].uiWriteAddr = inst->uiWriteAddr;
    mbm->pData->actParam[0].uiWriteQty  = inst->uiWriteQty;
    
    if (inst->bPoll)
    {
      mbm->pData->actEnable[0].bCyclic 	= TRUE;
      mbm->pData->actEnable[0].bSingle 	= FALSE;
      mbm->pData->actParam[0].udiTimer 	= inst->udiPollPeriod;
    }
    else
    {
      mbm->pData->actEnable[0].bCyclic 	= FALSE;
      mbm->pData->actEnable[0].bSingle 	= TRUE;
      mbm->pData->actParam[0].udiTimer 	= 0;
    }
    
    switch(inst->usiFCode)
    {
    case MBT_READ_COILS:                     /* 0x01 */
    case MBT_READ_DISCRETE_INPUTS:           /* 0x02 */
       if (inst->uiReadQty > MAX_COILS)
         { inst->uiStatus = mbtERR_MAX_NBR_COILS; inst->bRecvOK = FALSE; goto END; }
      break;
    case MBT_READ_HOLDING_REGISTERS:         /* 0x03 */
    case MBT_READ_INPUT_REGISTERS:           /* 0x04 */
      if (inst->uiReadQty > MAX_REGISTER) //same value as Holding register
         { inst->uiStatus = mbtERR_MAX_NBR_REGISTER; inst->bRecvOK = FALSE; goto END; }
      break;
    case MBT_WRITE_SINGLE_COIL:              /* 0x05 */
    case MBT_WRITE_MULTIPLE_COILS:           /* 0x0F */
     if (inst->uiWriteQty > MAX_COILS)
         { inst->uiStatus = mbtERR_MAX_NBR_COILS; inst->bRecvOK = FALSE; goto END; }
      break;
    case MBT_WRITE_SINGLE_REGISTER:          /* 0x06 */
    case MBT_WRITE_MULTIPLE_REGISTERS:       /* 0x10 */
      if (inst->uiWriteQty > MAX_REGISTER)
        { inst->uiStatus = mbtERR_MAX_NBR_REGISTER; inst->bRecvOK = FALSE; goto END; }
      break;
    case MBT_READ_WRITE_MULTIPLE_REGISTER:  /* 0x17 */
      if (    (inst->uiWriteQty > MAX_REGISTER)
           || (inst->uiReadQty > MAX_REGISTER))
        { inst->uiStatus = mbtERR_MAX_NBR_REGISTER; inst->bRecvOK = FALSE; goto END; }
      break;
    default:
      { inst->uiStatus = mbtERR_ILLEGAL_FUNCTION; goto END; }
    }
     
          
    switch(inst->usiFCode)
    {
    case MBT_READ_COILS:                     /* 0x01 */
    case MBT_READ_DISCRETE_INPUTS:           /* 0x02 */
    case MBT_READ_HOLDING_REGISTERS:         /* 0x03 */
    case MBT_READ_INPUT_REGISTERS:           /* 0x04 */
      if(inst->puiReadVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; } 
      mbm->pData->actParam[0].puiReadVal = (UDINT) inst->puiReadVal;
      break;
    case MBT_WRITE_SINGLE_COIL:              /* 0x05 */
    case MBT_WRITE_MULTIPLE_COILS:           /* 0x0F */
    case MBT_WRITE_SINGLE_REGISTER:          /* 0x06 */
    case MBT_WRITE_MULTIPLE_REGISTERS:       /* 0x10 */
      if( inst->puiWriteVal == NULL)
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; } 
      mbm->pData->actParam[0].puiWriteVal = (UDINT) inst->puiWriteVal;
      break;
    case MBT_READ_WRITE_MULTIPLE_REGISTER:  /* 0x17 */
      if(    (inst->puiWriteVal == NULL)
          || (inst->puiReadVal == NULL))
        { inst->uiStatus = mbtERR_DATA_ADDRESS; goto END; } 
      mbm->pData->actParam[0].puiReadVal  = (UDINT) inst->puiReadVal;
      mbm->pData->actParam[0].puiWriteVal = (UDINT) inst->puiWriteVal;
      break;
    default:
      { inst->uiStatus = mbtERR_ILLEGAL_FUNCTION; goto END; }
    }

    inst->bRecvOK = mbm->bRecvOK; 
    inst->uiStatus = ERR_OK;
  }
END: ; /* do nothing */
  /*=========================================================================*/
} /* fMBTMRW */

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
