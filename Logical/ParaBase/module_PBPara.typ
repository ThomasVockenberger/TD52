(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: ParaBase
 * File: ParaBase.typ
 * Author: zengeres
 * Created: September 14, 2012
 ********************************************************************
 * Para Data type of package ParaBase
  ********************************************************************)

TYPE
	Para_PB : 	STRUCT  (*Para sorting is ok, but add new tags preferably at the end of the para structure*)
		ReplaceMeWithYourParameter : REAL := 1000.0; (*THIS IS JUST A DEMO DATAPOINT! !NOT ON VISU!*)
		iEng_Motortype : INT; (*Para motortype*) (*OldName: new PV; Cycle: 5;*)
		bIgnoreParaSetupOk : BOOL; (*True= allow engine operation without parameter OK*)
		bIgnoreParaSetupOk_AB : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11901;*)
		bIgnoreParaSetupOk_AG : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11902;*)
		bIgnoreParaSetupOk_CH : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11903;*)
		bIgnoreParaSetupOk_CP : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11904;*)
		bIgnoreParaSetupOk_CU : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11905;*)
		bIgnoreParaSetupOk_EC : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11906;*)
		bIgnoreParaSetupOk_EG : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11907;*)
		bIgnoreParaSetupOk_EX : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11908;*)
		bIgnoreParaSetupOk_GC : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11909;*)
		bIgnoreParaSetupOk_GD : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11910;*)
		bIgnoreParaSetupOk_GM : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11911;*)
		bIgnoreParaSetupOk_GR : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11927;*)
		bIgnoreParaSetupOk_GT : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11912;*)
		bIgnoreParaSetupOk_HA : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11913;*)
		bIgnoreParaSetupOk_HC : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11914;*)
		bIgnoreParaSetupOk_IC : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11915;*)
		bIgnoreParaSetupOk_IG : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11916;*)
		bIgnoreParaSetupOk_KL : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11917;*)
		bIgnoreParaSetupOk_KN : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11918;*)
		bIgnoreParaSetupOk_MO : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11919;*)
		bIgnoreParaSetupOk_OP : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11920;*)
		bIgnoreParaSetupOk_PB : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11921;*)
		bIgnoreParaSetupOk_SA : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11922;*)
		bIgnoreParaSetupOk_SY : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11923;*)
		bIgnoreParaSetupOk_TR : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11924;*)
		bIgnoreParaSetupOk_VE : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11925;*)
		bIgnoreParaSetupOk_VI : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11926;*)
		bIgnoreParaSetupOk_28 : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11928;*)
		bIgnoreParaSetupOk_TB : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11929;*)
		bIgnoreParaSetupOk_OL : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: 11930;*)
		bSaveParaAllowedWithoutSysRun : BOOL; (*True=allow Parameter saving allso if SysRun- bit is missing*) (*OldName: new PV; *)
		bSaveParaAllowedDespiteDownload : BOOL; (*True=allow Parameter saving allso if a DLD- bit is set*) (*OldName: new PV; *)
		bBlockSysRunBit : BOOL; (*True= lock the bBlockSysRun- Signal to FALSE for all modules (for test operation only) !NOT ON VISU!*) (*OldName: new PV; *)
		bDebugShowModuleCount : BOOL; (*true= show module order number, false=ascii module code !NOT ON VISU!*) (*OldName: new PV; *)
		zz_V4_0_ParaVersionEnd : REAL := 4.03; (*! ADD NEW PARAMETER ONLY BELOW THIS LINE ! This is the end of base version parameter and has to stay unchanged. DO NOT CHANGE SORT ORDER of Para!*) (* OldName: new PV; Cycle: 5; *)
		bIgnoreParaSetupOk_EM : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: ;*)
		bIgnoreParaSetupOk_CB : BOOL; (*True= allow engine operation without OK from this module*) (*OldName: new PV; Cyclic: 5; ParaID: ;*)
		iParaBaseExtensionAdress : UDINT; (*prepared; debug only*) (*OldName: new PV; *)
		iParaBaseExtensionCommand : UDINT; (*prepared; debug only*) (*OldName: new PV; *)
	END_STRUCT;
END_TYPE
