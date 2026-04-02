/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _ASNXDPS_
#define _ASNXDPS_
#ifdef __cplusplus
extern "C" 
{
#endif

#include <bur/plctypes.h>

#include <runtime.h>

#ifndef _IEC_CONST
#define _IEC_CONST _WEAK const
#endif

/* Constants */
#ifdef _REPLACE_CONST
 #define nxdpsMAX_DIAG_DATA_SIZE 238U
 #define nxdpsPOSITIVE_ACK 1
 #define nxdpsNEGATIVE_ACK 0
 #define nxdpsALARM_SPEC_ERR_DIS_SLOT_DIS 3U
 #define nxdpsALARM_SPEC_ERR_DIS_SLOT_OK 2U
 #define nxdpsALARM_SPEC_ERR_APP_SLOT_DIS 1U
 #define nxdpsALARM_SPEC_NO_DIFF 0U
 #define nxdpsALARM_UPDATE 6U
 #define nxdpsALARM_STATUS 5U
 #define nxdpsALARM_PLUG 4U
 #define nxdpsALARM_PULL 3U
 #define nxdpsALARM_PROCESS 2U
 #define nxdpsALARM_DIAGNOSTIC 1U
 #define nxdpsERR_NO_MORE_ENTRIES 34807U
 #define nxdpsERR_SUBSCRIBE_LISTENER 34806U
 #define nxdpsERR_MEMORY 34805U
 #define nxdpsERR_PARAMETER 34804U
 #define nxdpsERR_PROFIBUSDP_STACK 34803U
 #define nxdpsERR_TIMEOUT 34802U
 #define nxdpsERR_SEND_MESSAGE 34801U
 #define nxdpsERR_INVALID_DEVICE 34800U
#else
 _IEC_CONST unsigned long nxdpsMAX_DIAG_DATA_SIZE = 238U;
 _IEC_CONST plcbit nxdpsPOSITIVE_ACK = 1;
 _IEC_CONST plcbit nxdpsNEGATIVE_ACK = 0;
 _IEC_CONST unsigned char nxdpsALARM_SPEC_ERR_DIS_SLOT_DIS = 3U;
 _IEC_CONST unsigned char nxdpsALARM_SPEC_ERR_DIS_SLOT_OK = 2U;
 _IEC_CONST unsigned char nxdpsALARM_SPEC_ERR_APP_SLOT_DIS = 1U;
 _IEC_CONST unsigned char nxdpsALARM_SPEC_NO_DIFF = 0U;
 _IEC_CONST unsigned char nxdpsALARM_UPDATE = 6U;
 _IEC_CONST unsigned char nxdpsALARM_STATUS = 5U;
 _IEC_CONST unsigned char nxdpsALARM_PLUG = 4U;
 _IEC_CONST unsigned char nxdpsALARM_PULL = 3U;
 _IEC_CONST unsigned char nxdpsALARM_PROCESS = 2U;
 _IEC_CONST unsigned char nxdpsALARM_DIAGNOSTIC = 1U;
 _IEC_CONST unsigned short nxdpsERR_NO_MORE_ENTRIES = 34807U;
 _IEC_CONST unsigned short nxdpsERR_SUBSCRIBE_LISTENER = 34806U;
 _IEC_CONST unsigned short nxdpsERR_MEMORY = 34805U;
 _IEC_CONST unsigned short nxdpsERR_PARAMETER = 34804U;
 _IEC_CONST unsigned short nxdpsERR_PROFIBUSDP_STACK = 34803U;
 _IEC_CONST unsigned short nxdpsERR_TIMEOUT = 34802U;
 _IEC_CONST unsigned short nxdpsERR_SEND_MESSAGE = 34801U;
 _IEC_CONST unsigned short nxdpsERR_INVALID_DEVICE = 34800U;
#endif




/* Datatypes and datatypes of function blocks */
typedef struct nxdpsSetDiag
{
	/* VAR_INPUT (analog) */
	unsigned long pDevice;
	unsigned long pDiagData;
	unsigned long diagDataLen;
	/* VAR_OUTPUT (analog) */
	unsigned short status;
	unsigned long dpStatus;
	/* VAR (analog) */
	unsigned short _state;
	unsigned short _result;
	unsigned long _srcId;
	/* VAR_INPUT (digital) */
	plcbit enable;
	plcbit extDiag;
	plcbit extDiagOverflow;
} nxdpsSetDiag_typ;



/* Prototyping of functions and function blocks */
void nxdpsSetDiag(struct nxdpsSetDiag* inst);


#ifdef __cplusplus
};
#endif
#endif /* _ASNXDPS_ */

