(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: perm_map
 * File: perm_map.typ
 * Author: WaldharM
 * Created: April 05, 2011
 ********************************************************************
 * Local data types of program perm_map
 ********************************************************************)

TYPE
	_Data_Bits : 	STRUCT 
		ucData : ARRAY[0..iBufferSize]OF USINT;
		used : USINT;
		Info : ARRAY[0..7]OF _Data_BitsName;
	END_STRUCT;
	_Data_BitsName : 	STRUCT 
		Name : STRING[NameSize];
	END_STRUCT;
	_Data_BitPattern : 	STRUCT 
		Name : STRING[NameSize];
		BitPattern : ARRAY[0..iBufferSize]OF UDINT;
	END_STRUCT;
	_Data_ui16_low : 	STRUCT 
		Unit : STRING[UnitSize];
		Name : STRING[NameSize];
		Signed : BOOL;
		Co : REAL;
		Data : ARRAY[0..iBufferSize10]OF UINT;
	END_STRUCT;
	_Data_ui16 : 	STRUCT 
		Unit : STRING[UnitSize];
		Name : STRING[NameSize];
		Signed : BOOL;
		Co : REAL;
		Data : ARRAY[0..iBufferSize]OF UINT;
	END_STRUCT;
	_Data_ui16_H : 	STRUCT 
		Unit : STRING[UnitSize];
		Name : STRING[NameSize];
		Signed : BOOL;
		Co : REAL;
		Hi : ARRAY[0..iBufferSize]OF UINT;
		Lo : ARRAY[0..iBufferSize]OF UINT;
	END_STRUCT;
	_TrigMode : 	STRUCT 
		Name : STRING[NameSize];
		iRemain : INT;
		bEvent : BOOL;
	END_STRUCT;
	_Data_ui16_TCB : 	STRUCT 
		Unit : STRING[UnitSize];
		Name : STRING[NameSize];
		Format : USINT;
		Co : REAL;
		Data : ARRAY[0..iTCB_BufferSize]OF UINT;
	END_STRUCT;
	_TCB_Buffer : 	STRUCT 
		timer : ARRAY[0..iTCB_BufferSize]OF TIME;
		iCnt_ui16 : UINT;
		TrigMode : ARRAY[0..iTCB_MaxTrig]OF _TrigMode;
		ui16 : ARRAY[0..iTCB_Max]OF _Data_ui16_TCB;
	END_STRUCT;
	_ECB_Buffer : 	STRUCT 
		timer : ARRAY[0..iBufferSize]OF TIME;
		iCnt_ui16_low : INT;
		iCnt_ui16 : INT;
		iCnt_ui16_H : INT;
		iCnt_HS : INT;
		iCnt_H : INT;
		iCnt_H12 : INT;
		iCnt_pattern : INT;
		Bits : ARRAY[0..iBits_Max]OF _Data_Bits; (*1*)
		pattern : ARRAY[0..iPC_Max]OF _Data_BitPattern; (*12*)
		ui16_low : ARRAY[0..iSC_Max]OF _Data_ui16_low; (*61*)
		ui16_H : ARRAY[0..iTC_Max]OF _Data_ui16_H; (*51*)
		ui16 : ARRAY[0..iEC_Max]OF _Data_ui16; (*220*)
		Header12 : ARRAY[0..iH12_Max]OF _Data_Header12; (*6*)
		HeaderS : ARRAY[0..iHS_Max]OF _Data_HeaderS; (*8*)
		Header : ARRAY[0..iH_Max]OF _Data_Header; (*16*)
		TrigMode : ARRAY[0..iECB_MaxTrig]OF _TrigMode;
	END_STRUCT;
	_Data_Header12 : 	STRUCT 
		Name : STRING[NameSize];
		Unit : STRING[UnitSize];
		Co : USINT;
		Value : ARRAY[0..12]OF REAL;
	END_STRUCT;
	_Data_HeaderS : 	STRUCT 
		Name : STRING[NameSize];
		Value : STRING[31];
	END_STRUCT;
	_Data_Header : 	STRUCT 
		Name : STRING[NameSize];
		Unit : STRING[UnitSize];
		Co : USINT;
		Value : REAL;
	END_STRUCT;
	_Buffer_Pos : 	STRUCT 
		N_Eng : UINT;
		P_Set : UINT;
		P_Act : UINT;
		Q_Act : UINT;
		U_L1L2 : UINT;
		U_L2L3 : UINT;
		U_L3L1 : UINT;
		I_L1 : UINT;
		I_L2 : UINT;
		I_L3 : UINT;
		Freq : UINT;
		CosPhi : UINT;
		Lam_Set : UINT;
		Pr_Leanox_Set : UINT;
		N_TCHP_A : UINT;
		N_TCHP_B : UINT;
		N_TCLP_A : UINT;
		N_TCLP_B : UINT;
		Pr_GR_Act : UINT;
		Pr_GR_Set : UINT;
		Pr_PC_Act : UINT;
		Pr_PC_Set : UINT;
		Pr_PCGT : UINT;
		Pr_Crank_Case : UINT;
		Pos_TV_Set : UINT;
		Pos_TV_Act_A1 : UINT;
		Pos_TV_Act_B1 : UINT;
		Pos_CBV_Set : UINT;
		Pos_CBV_Act_A1 : UINT;
		Pos_CBV_Act_B1 : UINT;
		Pr_P1HP_A : UINT;
		Pr_P1HP_B : UINT;
		Pr_P2s_A : UINT;
		Pr_P2s_B : UINT;
		Pr_P3HP_A : UINT;
		Pr_P3HP_B : UINT;
		Pr_P3LP_A : UINT;
		Pr_P3LP_B : UINT;
		Pr_P4LP_A : UINT;
		Pr_P4LP_B : UINT;
		Pr_P2s : UINT;
		Pr_P2 : UINT;
		Vdot_TJ : ARRAY[0..6]OF UINT;
		Pos_TJ : ARRAY[0..6]OF UINT;
		Pr_diff_TJ : ARRAY[0..6]OF UINT;
		CA_Ign_Timing : ARRAY[0..24]OF UINT;
		U_Ign : ARRAY[0..24]OF UINT;
		N_SAFI : ARRAY[0..24]OF UINT;
		CA_PI_Dur : ARRAY[0..24]OF UINT;
		CA_PI_Dur_Map : ARRAY[0..24]OF UINT;
		CA_PI_Dur_PID : ARRAY[0..24]OF UINT;
		CC_Gradient : ARRAY[0..24]OF UINT;
		Pr_Knock : ARRAY[0..24]OF UINT;
		Pr_CPP_Filt : ARRAY[0..24]OF UINT;
		Pr_CPP : ARRAY[0..24]OF UINT;
		Pr_IMEP : ARRAY[0..24]OF UINT;
		Pr_49bfTDC : ARRAY[0..24]OF UINT;
		Pr_49afTDC : ARRAY[0..24]OF UINT;
		Misf_Int : ARRAY[0..24]OF UINT;
		CA_MFBvar : ARRAY[0..24]OF UINT;
		T_T2s : UINT;
		T_T3HP_A : UINT;
		T_T3HP_B : UINT;
		T_T3LP_A : UINT;
		T_T3LP_B : UINT;
		T_EG_Cyl : ARRAY[0..24]OF UINT;
		T_CBearing : ARRAY[0..24]OF UINT;
		T_MBearing : ARRAY[0..13]OF UINT;
		PBCCompLineCheck : UINT;
		PBCNegVoltCheck : UINT;
		PBCNegPresCheck : UINT;
		PBCPresSlopeCheck : UINT;
		PBCMemBurst : UINT;
		PBCSensError : UINT;
		GlowIgn : UINT;
		Misfire_I : UINT;
		Misfire_II : UINT;
		CPSSat : UINT;
		SkipFire : UINT;
		LimpHome : UINT;
		LimpHomeRKS : UINT;
		Pr_Knock_Lim : ARRAY[0..24]OF UINT;
		Pr_Knock_Filt : ARRAY[0..24]OF UINT;
		Pr_ECW : UINT;
		Pr_EO : UINT;
		Bal_State : UINT;
		Knck_Intgr : ARRAY[0..24]OF UINT;
		Bal_Dur_SC : UINT;
		Bal_PMaxOffs_SC : UINT;
		PBCSlowDriftCheck : UINT;
		T_EG_LimMax : UINT;
		Pos_WG_Set : UINT;
		Pos_WG_Act_A : UINT;
		Pos_WG_Act_B : UINT;
		Pos_TV_Act : UINT;
		IHR : ARRAY[0..24] OF UINT;
		Lam_PBC : UINT;
		Lam_LamCtrPBC_ref : UINT;
	END_STRUCT;
END_TYPE
