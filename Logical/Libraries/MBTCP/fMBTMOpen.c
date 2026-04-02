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
 * Filename:     fMBTMOpen.c
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
 *    1.00 | 2008-Oct-01 | H.Anderes    | creation
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
/*==========================================================================*/
void fMBTMOpen(struct fMBTMOpen* inst)
/*---------------------------------------------------------------------------
  Function:  
 
  Allocates memory and pre-configures Modbus TCP Master. 
  fMBTMOpen() should be called in the INIT section of a task prior 
  to fMBTMaster(). See also fMBTMClose() to close the master in the 
  task's EXIT section. The master connects to the Modbus TCP slave 
  available at the IP address provided by szSlvIPAddr.

  History:

  Version | Date        | Author      | Description
  ---------------------------------------------------------------------------
     1.00 | 2008-Oct-01 | H.Anderes    | creation
  ===========================================================================*/
  {
  /* _LOCAL */
  UINT astatus = 0;
  RTInfo_typ stRTInfo;
  UDINT udiCycleTime;

  /* _DYNAMIC */  
  tstMBT_MVars *mbm;
  tstMBT_MData *pData;
  
  /*=========================================================================*/
  if (inst == NULL)
  {
    inst->uiStatus = mbtERR_NULL_POINTER;
    goto END;
  }
  if (inst->bEnable < TRUE)
  {
    inst->uiStatus = ERR_FUB_ENABLE_FALSE;
  }   
  else
  {
    inst->uiStatus = ERR_FUB_BUSY;
    if (inst->szSlvIPAddr == NULL)
    {
      inst->uiStatus = mbtERR_IP_ADRESS;
      goto END;
    }

    astatus = TMP_alloc(sizeof(tstMBT_MVars), (void**)&mbm);
    if (astatus > 0) { inst->uiStatus = astatus; goto END; }
    memset(mbm, 0, sizeof(tstMBT_MVars));
    astatus = TMP_alloc(sizeof(tstMBT_MData), (void**)&pData); 
    if (astatus > 0) { inst->uiStatus = astatus; goto END; }
    memset(pData, 0, sizeof(tstMBT_MData)); 
    mbm->pData = pData;

    stRTInfo.enable = TRUE;
    RTInfo(&stRTInfo);
    udiCycleTime = (UDINT)(stRTInfo.cycle_time / 1000);
    stRTInfo.enable = FALSE;
    /* call RTInfo() */
    RTInfo(&stRTInfo);

    if (inst->uiPort < 1)
    { 
      inst->uiPort = MBT_SLAVE_PORT;
    }
    if (inst->uiRecvTimeout < 1)
    {
      inst->uiRecvTimeout = RECV_TIMEOUT_DFLT;
    }
    
    memmove(&(mbm->slvIPAddr),&(inst->szSlvIPAddr), IPADDR_L); 
    mbm->uiPort 	      = inst->uiPort;
    mbm->udiCycleTime	 = udiCycleTime;
    mbm->uiRecvTimeout = inst->uiRecvTimeout;
    mbm->uiStep		      = INIT;

    inst->udiIdent = (UDINT) mbm;  
    if (inst->uiStatus == ERR_FUB_BUSY)         /* alloc OK */ 
    { 
      inst->uiStatus = ERR_OK; 
    } 
  }
  END: ; /* do nothing */
  /*=========================================================================*/
  } /* fMBTMOpen */

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
