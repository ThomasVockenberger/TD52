/* Automation Studio generated header file */
/* Do not edit ! */

#ifndef _MODDIAG_
#define _MODDIAG_
#ifdef __cplusplus
extern "C" 
{
#endif

#include <bur/plctypes.h>

#ifdef _SG4
		#include "Runtime.h"
		#include "asstring.h"
		#include "sys_lib.h"
		#include "standard.h"
		#include "brsystem.h"
		#include "AsIO.h"
		#include "AsIODiag.h"
#endif
#ifdef _SG3
		#include "Runtime.h"
		#include "asstring.h"
		#include "sys_lib.h"
		#include "standard.h"
		#include "brsystem.h"
		#include "AsIO.h"
		#include "AsIODiag.h"
#endif
#ifdef _SGC
		#include "Runtime.h"
		#include "asstring.h"
		#include "sys_lib.h"
		#include "standard.h"
		#include "brsystem.h"
		#include "AsIO.h"
		#include "AsIODiag.h"
#endif

/* Constants */
#ifdef _REPLACE_CONST
 #define mdiagADDMODE_IGNORE_ADD_SYS_DP 8U
 #define mdiagADDMODE_IGNORE_CYCLIC_DP 4U
 #define mdiagADDMODE_MODERROR_IGNORE 1U
 #define mdiagADDMODE_SEARCH_NO_DP 2U
 #define mdiagENTRYMODE_LISTINDEX 0U
 #define mdiagENTRYMODE_PHYSADR 1U
 #define mdiagERR_DIFF_MODULE 60008U
 #define mdiagERR_FUB_BUSY 65535U
 #define mdiagERR_FUB_ENABLE_FALSE 65534U
 #define mdiagERR_ILL_DPNAME 60001U
 #define mdiagERR_ILL_DPNO 60011U
 #define mdiagERR_ILL_ENTRYMODE 60007U
 #define mdiagERR_ILL_IDENT 60004U
 #define mdiagERR_ILL_MODGRPINDEX 60003U
 #define mdiagERR_ILL_MODINDEX 60002U
 #define mdiagERR_ILL_NODENR 60005U
 #define mdiagERR_ILL_PVSMODE 60020U
 #define mdiagERR_ILL_SIZEDPHANDLE 60010U
 #define mdiagERR_ILL_SLOTNR 60006U
 #define mdiagERR_MODGRP_LIMIT 60101U
 #define mdiagERR_MODIDX_LIMIT 60100U
 #define mdiagERR_MODULE_NOT_FOUND 60000U
 #define mdiagERR_NO_DP_ON_MODULE 60009U
 #define mdiagERR_OK 0U
 #define mdiagERR_SIZE_DPNAME 60021U
 #define mdiagERR_SIZE_PVCONTEXT 60023U
 #define mdiagERR_SIZE_PVNAME 60022U
 #define mdiagINT_MODGRP_LIMIT 253U
 #define mdiagINT_MODIDX_LIMIT 253U
 #define mdiagINT_STRING_MEMOK "MEM_OK"
 #define mdiagMOD_DIFF_PLUGGED_CONFIG 4U
 #define mdiagMOD_ONLY_CONFIG 1U
 #define mdiagMOD_ONLY_PLUGGED 2U
 #define mdiagMOD_PLUGGED_CONFIG 3U
 #define mdiagPVSMODE_PVINFO_TO_DPNAME 0U
 #define mdiagPVSMODE_PVINFO_TO_DPNO 1U
 #define mdiagPVSMODE_PVINFO_TO_MODGRP 3U
 #define mdiagPVSMODE_PVINFO_TO_MODULE 2U
 #define mdiagPVSMODE_PVINFO_TO_SYSTEM 4U
 #define mdiagSMODTYPE_ALL 0U
 #define mdiagSMODTYPE_NO_SYSMOD 1U
 #define mdiagSTEP_CREATEINFO 10U
 #define mdiagSTEP_DISFORCING 3U
 #define mdiagSTEP_DISGLOBALFORCING 4U
 #define mdiagSTEP_DISPOSEINFO 14U
 #define mdiagSTEP_ENFORCING 2U
 #define mdiagSTEP_ERROR 101U
 #define mdiagSTEP_FINISHED 100U
 #define mdiagSTEP_GETIODPLIST 13U
 #define mdiagSTEP_GETIODPSTATUS 1U
 #define mdiagSTEP_GETNUMINFO 11U
 #define mdiagSTEP_GETPVINFO 1U
 #define mdiagSTEP_GETSERVICEDP_BM 5U
 #define mdiagSTEP_GETSERVICEDP_FW 4U
 #define mdiagSTEP_GETSERVICEDP_FWU 12U
 #define mdiagSTEP_GETSERVICEDP_FWUCT 13U
 #define mdiagSTEP_GETSERVICEDP_HW 3U
 #define mdiagSTEP_GETSERVICEDP_MCE 16U
 #define mdiagSTEP_GETSERVICEDP_MCECT 17U
 #define mdiagSTEP_GETSERVICEDP_MID 2U
 #define mdiagSTEP_GETSERVICEDP_MNC 14U
 #define mdiagSTEP_GETSERVICEDP_MNCCT 15U
 #define mdiagSTEP_GETSERVICEDP_MOO 6U
 #define mdiagSTEP_GETSERVICEDP_MOOCT 7U
 #define mdiagSTEP_GETSERVICEDP_NOI 8U
 #define mdiagSTEP_GETSERVICEDP_NOICT 9U
 #define mdiagSTEP_GETSERVICEDP_NOR 10U
 #define mdiagSTEP_GETSERVICEDP_NORCT 11U
 #define mdiagSTEP_GETSERVICEDP_SNR 1U
 #define mdiagSTEP_GETSTRINFO 12U
 #define mdiagSTEP_INIT 0U
 #define mdiagSTEP_SETFORCEVALUE 5U
 #define mdiagSTEP_TMPFREE 15U
#else
 #ifndef _GLOBAL_CONST
   #define _GLOBAL_CONST _WEAK const
 #endif
 _GLOBAL_CONST unsigned char mdiagADDMODE_IGNORE_ADD_SYS_DP;
 _GLOBAL_CONST unsigned char mdiagADDMODE_IGNORE_CYCLIC_DP;
 _GLOBAL_CONST unsigned char mdiagADDMODE_MODERROR_IGNORE;
 _GLOBAL_CONST unsigned char mdiagADDMODE_SEARCH_NO_DP;
 _GLOBAL_CONST unsigned char mdiagENTRYMODE_LISTINDEX;
 _GLOBAL_CONST unsigned char mdiagENTRYMODE_PHYSADR;
 _GLOBAL_CONST unsigned short mdiagERR_DIFF_MODULE;
 _GLOBAL_CONST unsigned short mdiagERR_FUB_BUSY;
 _GLOBAL_CONST unsigned short mdiagERR_FUB_ENABLE_FALSE;
 _GLOBAL_CONST unsigned short mdiagERR_ILL_DPNAME;
 _GLOBAL_CONST unsigned short mdiagERR_ILL_DPNO;
 _GLOBAL_CONST unsigned short mdiagERR_ILL_ENTRYMODE;
 _GLOBAL_CONST unsigned short mdiagERR_ILL_IDENT;
 _GLOBAL_CONST unsigned short mdiagERR_ILL_MODGRPINDEX;
 _GLOBAL_CONST unsigned short mdiagERR_ILL_MODINDEX;
 _GLOBAL_CONST unsigned short mdiagERR_ILL_NODENR;
 _GLOBAL_CONST unsigned short mdiagERR_ILL_PVSMODE;
 _GLOBAL_CONST unsigned short mdiagERR_ILL_SIZEDPHANDLE;
 _GLOBAL_CONST unsigned short mdiagERR_ILL_SLOTNR;
 _GLOBAL_CONST unsigned short mdiagERR_MODGRP_LIMIT;
 _GLOBAL_CONST unsigned short mdiagERR_MODIDX_LIMIT;
 _GLOBAL_CONST unsigned short mdiagERR_MODULE_NOT_FOUND;
 _GLOBAL_CONST unsigned short mdiagERR_NO_DP_ON_MODULE;
 _GLOBAL_CONST unsigned short mdiagERR_OK;
 _GLOBAL_CONST unsigned short mdiagERR_SIZE_DPNAME;
 _GLOBAL_CONST unsigned short mdiagERR_SIZE_PVCONTEXT;
 _GLOBAL_CONST unsigned short mdiagERR_SIZE_PVNAME;
 _GLOBAL_CONST unsigned short mdiagINT_MODGRP_LIMIT;
 _GLOBAL_CONST unsigned short mdiagINT_MODIDX_LIMIT;
 _GLOBAL_CONST plcstring mdiagINT_STRING_MEMOK[8];
 _GLOBAL_CONST unsigned char mdiagMOD_DIFF_PLUGGED_CONFIG;
 _GLOBAL_CONST unsigned char mdiagMOD_ONLY_CONFIG;
 _GLOBAL_CONST unsigned char mdiagMOD_ONLY_PLUGGED;
 _GLOBAL_CONST unsigned char mdiagMOD_PLUGGED_CONFIG;
 _GLOBAL_CONST unsigned char mdiagPVSMODE_PVINFO_TO_DPNAME;
 _GLOBAL_CONST unsigned char mdiagPVSMODE_PVINFO_TO_DPNO;
 _GLOBAL_CONST unsigned char mdiagPVSMODE_PVINFO_TO_MODGRP;
 _GLOBAL_CONST unsigned char mdiagPVSMODE_PVINFO_TO_MODULE;
 _GLOBAL_CONST unsigned char mdiagPVSMODE_PVINFO_TO_SYSTEM;
 _GLOBAL_CONST unsigned char mdiagSMODTYPE_ALL;
 _GLOBAL_CONST unsigned char mdiagSMODTYPE_NO_SYSMOD;
 _GLOBAL_CONST unsigned short mdiagSTEP_CREATEINFO;
 _GLOBAL_CONST unsigned short mdiagSTEP_DISFORCING;
 _GLOBAL_CONST unsigned short mdiagSTEP_DISGLOBALFORCING;
 _GLOBAL_CONST unsigned short mdiagSTEP_DISPOSEINFO;
 _GLOBAL_CONST unsigned short mdiagSTEP_ENFORCING;
 _GLOBAL_CONST unsigned short mdiagSTEP_ERROR;
 _GLOBAL_CONST unsigned short mdiagSTEP_FINISHED;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETIODPLIST;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETIODPSTATUS;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETNUMINFO;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETPVINFO;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_BM;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_FW;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_FWU;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_FWUCT;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_HW;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_MCE;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_MCECT;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_MID;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_MNC;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_MNCCT;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_MOO;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_MOOCT;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_NOI;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_NOICT;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_NOR;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_NORCT;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSERVICEDP_SNR;
 _GLOBAL_CONST unsigned short mdiagSTEP_GETSTRINFO;
 _GLOBAL_CONST unsigned short mdiagSTEP_INIT;
 _GLOBAL_CONST unsigned short mdiagSTEP_SETFORCEVALUE;
 _GLOBAL_CONST unsigned short mdiagSTEP_TMPFREE;
#endif




/* Datatypes and datatypes of function blocks */
typedef struct MDiagAddModuleInfo_typ
{	unsigned long BusModuleId;
	unsigned long ModeOfOperation;
	unsigned long ModeOfOperationChangeTime;
	unsigned long NrOfInits;
	unsigned long NrOfInitsChangeTime;
	unsigned long NrOfResets;
	unsigned long NrOfResetsChangeTime;
	unsigned long NrOfFwUpdates;
	unsigned long NrOfFwUpdatesChangeTime;
	unsigned long ModuleNoComm;
	unsigned long ModuleNoCommChangeTime;
	unsigned long ModuleCommError;
	unsigned long ModuleCommErrorChangeTime;
} MDiagAddModuleInfo_typ;

typedef struct MDiagDPData_typ
{	plcstring Name[33];
	plcstring ValueTextDec[13];
	plcstring ValueTextHex[13];
	plcstring ValueTextBin[45];
	unsigned long Value;
	unsigned long DefaultValue;
	unsigned long ForceValue;
	plcbit ForceOn;
	plcbit ForceNew;
	plcbit ForceActive;
	plcbit DPActive;
	unsigned char RealDatatype;
	unsigned char IOType;
} MDiagDPData_typ;

typedef struct MDiagInfoGeneralInternal_typ
{	plcstring Path[41];
	plcstring OrderCodeConfig[21];
	plcstring OrderCodePlug[21];
	plcstring Bussystem[11];
	unsigned char FamilyCode;
	unsigned char UseType;
	unsigned char State;
	unsigned char ModuleNo;
	plcstring HWModulName[41];
} MDiagInfoGeneralInternal_typ;

typedef struct MDiagInfoAddServiceDPIntern_typ
{	plcstring DP_BusModuleId[61];
	plcstring DP_ModeOfOperation[61];
	plcstring DP_ModeOfOperationChangeTime[61];
	plcstring DP_NrOfInits[61];
	plcstring DP_NrOfInitsChangeTime[61];
	plcstring DP_NrOfResets[61];
	plcstring DP_NrOfResetsChangeTime[61];
	plcstring DP_NrOfFwUpdates[61];
	plcstring DP_NrOfFwUpdatesChangeTime[61];
	plcstring DP_ModuleNoComm[61];
	plcstring DP_ModuleNoCommChangeTime[61];
	plcstring DP_ModuleCommError[61];
	plcstring DP_ModuleCommErrorChangeTime[61];
} MDiagInfoAddServiceDPIntern_typ;

typedef struct MDiagInfoServiceDPInternal_typ
{	plcstring DP_Serialnr[61];
	plcstring DP_ModuleID[61];
	plcstring DP_HWVariant[61];
	plcstring DP_FWVersion[61];
	struct MDiagInfoAddServiceDPIntern_typ AddServiceDP;
} MDiagInfoServiceDPInternal_typ;

typedef struct MDiagInfoCyclicDPInternal_typ
{	unsigned short NbDPs;
	plcstring DP_IOs[101][81];
} MDiagInfoCyclicDPInternal_typ;

typedef struct MDiagDataInternal_typ
{	struct MDiagInfoGeneralInternal_typ InfoGeneral;
	struct MDiagInfoServiceDPInternal_typ InfoServiceDP;
	struct MDiagInfoCyclicDPInternal_typ InfoCyclicDP;
} MDiagDataInternal_typ;

typedef struct MDiagErrAddInfo_typ
{	plcstring ErrorText[81];
} MDiagErrAddInfo_typ;

typedef struct MDiagModGrpInfoInternal_typ
{	unsigned long pMem;
	unsigned long MemLen;
} MDiagModGrpInfoInternal_typ;

typedef struct MDiagModGrpInfo_typ
{	unsigned short NbModules;
	unsigned short NodeNr;
	plcstring Name[21];
} MDiagModGrpInfo_typ;

typedef struct MDiagModInfo_typ
{	plcstring Name[41];
	plcstring Path[41];
	unsigned long SerialNr;
	unsigned long ModuleID;
	unsigned long HWVariant;
	unsigned long FWVersion;
	unsigned char SlotNr;
	unsigned char SubslotNr;
	unsigned char State;
	unsigned char NbDatapoints;
	plcstring NameConfigured[41];
	plcstring NamePlugged[41];
	struct MDiagAddModuleInfo_typ AddInfo;
} MDiagModInfo_typ;

typedef struct CreateSystemInfo
{
	/* VAR_INPUT (analog) */
	unsigned long SearchMode;
	unsigned char SearchModuleType;
	unsigned char AddModes;
	/* VAR_OUTPUT (analog) */
	unsigned short NbModuleGroups;
	unsigned long Ident;
	unsigned short Status;
	struct MDiagErrAddInfo_typ ErrAddInfo;
	/* VAR (analog) */
	unsigned short CreateInfoStep;
	unsigned short ErrorStep;
	unsigned short ErrorStatus;
	unsigned short WarningStatus;
	unsigned long Index;
	unsigned short InfoCode;
	plcstring DatenStr[81];
	struct MDiagInfoGeneralInternal_typ ActModule;
	struct MDiagInfoGeneralInternal_typ OldModule;
	plcstring TmpPathStr[81];
	plcstring TmpCmpPathStr[81];
	plcstring TmpDPStr[81];
	plcstring TmpDPPathStr[81];
	unsigned short PathChange;
	unsigned short MaxPathChange;
	unsigned short ModGrpCounter;
	unsigned short ModIdxCounter;
	unsigned short NbModules;
	unsigned short NbDPsTotal;
	unsigned short DPCounter;
	signed short ActSeperator;
	signed short NewSeperator;
	signed short FirstSeperator;
	signed short LastSeperator;
	unsigned long pMemModGrpInfoData;
	unsigned long MemLenModGrpInfoData;
	unsigned long MemOffsetModGrpInfoData;
	struct MDiagModGrpInfoInternal_typ* dynModGrpInfoData;
	unsigned long pTmpMemModDiagData;
	unsigned long TmpMemLenModDiagData;
	unsigned long TmpMemOffsetModDiagData;
	struct MDiagDataInternal_typ* dynModuleDiagData;
	unsigned short StatusTMPalloc;
	unsigned short StatusTMPfree;
	struct DiagCreateInfo DiagCreateInfo_0;
	struct DiagGetStrInfo DiagGetStrInfo_0;
	struct DiagGetNumInfo DiagGetNumInfo_0;
	struct DiagDisposeInfo DiagDisposeInfo_0;
	struct AsIOListDP AsIOListDP_0;
	unsigned short i;
	unsigned short j;
	unsigned char MDTest[10];
	unsigned long asdiagHARDWARE_MODULE_NAME;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR (digital) */
	plcbit EnEvaluation;
	plcbit NewModGrp;
	plcbit NewModule;
	plcbit ModGrpLimitReached;
	plcbit ModIdxLimitReached;
	plcbit ModuleFound;
	plcbit Shift;
	plcbit SafeLogicFound;
	plcbit zzEdge00000;
} CreateSystemInfo_typ;

typedef struct GetModuleGroupInfo
{
	/* VAR_INPUT (analog) */
	unsigned long Ident;
	unsigned short ModuleGroupIndex;
	/* VAR_OUTPUT (analog) */
	struct MDiagModGrpInfo_typ ModuleGroupInfo;
	unsigned short Status;
	/* VAR (analog) */
	unsigned long pMemModGrpInfoData;
	unsigned long MemOffsetModGrpInfoData;
	struct MDiagModGrpInfoInternal_typ* dynModGrpInfoData;
	struct MDiagDataInternal_typ* dynModuleDiagData;
	plcstring TmpPathStr[81];
	plcstring TmpNodeStr[81];
	signed short TmpNodeStrLen;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR (digital) */
	plcbit NodeNrFound;
} GetModuleGroupInfo_typ;

typedef struct GetModuleInfo
{
	/* VAR_INPUT (analog) */
	unsigned long Ident;
	unsigned short ModuleGroupIndex;
	unsigned short ModuleIndex;
	/* VAR_OUTPUT (analog) */
	struct MDiagModInfo_typ ModuleInfo;
	unsigned short Status;
	/* VAR (analog) */
	unsigned long pMemModGrpInfoData;
	unsigned long MemOffsetModGrpInfoData;
	unsigned long MemOffsetModDiagData;
	struct MDiagModGrpInfoInternal_typ* dynModGrpInfoData;
	struct MDiagDataInternal_typ* dynModuleDiagData;
	unsigned short NbModules;
	plcstring TmpPathStr[81];
	plcstring TmpSlotStr[81];
	signed short TmpSlotStrLen;
	unsigned short GetModInfoStep;
	struct AsIODPStatus AsIODPStatus_0;
	/* VAR_INPUT (digital) */
	plcbit Enable;
	/* VAR (digital) */
	plcbit SlotNrFound;
} GetModuleInfo_typ;

typedef struct DPHandler
{
	/* VAR_INPUT (analog) */
	unsigned long Ident;
	unsigned short ModuleGroupIndex;
	unsigned short ModuleIndex;
	unsigned char DPNo;
	unsigned long pDPHandleData;
	unsigned long SizeDPHandleData;
	unsigned long pGlobalForceOff;
	/* VAR_OUTPUT (analog) */
	unsigned short Status;
	/* VAR (analog) */
	unsigned short DPHandlerStep;
	unsigned long pMemModGrpInfoData;
	unsigned long MemOffsetModGrpInfoData;
	struct MDiagModGrpInfoInternal_typ* dynModGrpInfoData;
	struct MDiagDataInternal_typ* dynModuleDiagData;
	plcbit* dynGlobalForceOff;
	unsigned short NbModules;
	unsigned long MemOffsetModDiagData;
	unsigned short NbDPEntries;
	unsigned short DPCounter;
	unsigned short DPNoAbs;
	struct MDiagDPData_typ* dynDPData;
	unsigned long DPHandleDataOffset;
	unsigned char DPDataLengthBit;
	unsigned short i;
	signed short NewSeperator;
	signed short TmpStrPos;
	unsigned char TmpValue;
	plcstring TmpStr[81];
	plcstring TmpStrValueBin[81];
	plcstring TmpStrValueHex[81];
	struct AsIODPStatus AsIODPStatus_0;
	struct AsIOEnableForcing AsIOEnableForcing_0;
	struct AsIODisableForcing AsIODisableForcing_0;
	struct AsIOSetForceValue AsIOSetForceValue_0;
	struct AsIOGlobalDisableForcing AsIOGlobalDisableForcing_0;
	unsigned char EntryMode;
	/* VAR_INPUT (digital) */
	plcbit Enable;
} DPHandler_typ;

typedef struct GetPVInfo
{
	/* VAR_INPUT (analog) */
	unsigned long Ident;
	unsigned char PVSearchMode;
	unsigned long PVIndex;
	unsigned short ModuleGroupIndex;
	unsigned short ModuleIndex;
	unsigned char DPNo;
	unsigned long pDPName;
	unsigned long SizeDPName;
	unsigned long pPVName;
	unsigned long SizePVName;
	unsigned long pPVContext;
	unsigned long SizePVContext;
	/* VAR_OUTPUT (analog) */
	unsigned long PVAdress;
	unsigned char PVType;
	unsigned long PVIndexNext;
	unsigned char PVState;
	unsigned short Status;
	/* VAR (analog) */
	unsigned short PVInfoStep;
	unsigned long pMemModGrpInfoData;
	unsigned long MemOffsetModGrpInfoData;
	struct MDiagModGrpInfoInternal_typ* dynModGrpInfoData;
	struct MDiagDataInternal_typ* dynModuleDiagData;
	unsigned short NbModules;
	unsigned long MemOffsetModDiagData;
	unsigned char* TmpChar;
	struct AsIOPVInfo AsIOPVInfo_0;
	unsigned long TmpPVLen;
	unsigned short TmpPVDim;
	unsigned short StatusInt;
	plcstring TmpStr[81];
	signed short NewSeperator;
	unsigned char IntDPNo;
	unsigned short IntModIdx;
	unsigned short IntModGrpIdx;
	unsigned char IntPVIdx;
	/* VAR_INPUT (digital) */
	plcbit Enable;
} GetPVInfo_typ;



/* Prototyping of functions and function blocks */
void CreateSystemInfo(struct CreateSystemInfo* inst);
void GetModuleGroupInfo(struct GetModuleGroupInfo* inst);
void GetModuleInfo(struct GetModuleInfo* inst);
void DPHandler(struct DPHandler* inst);
void GetPVInfo(struct GetPVInfo* inst);
unsigned short ReleaseGroupMem(unsigned long pIdent);


#ifdef __cplusplus
};
#endif
#endif /* _MODDIAG_ */

