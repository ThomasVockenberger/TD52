<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1">
    <Task Name="OUT_EC_TC1" Source="EngineController.OUT_EC_TC1.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SPP_TC1" Source="EngineController.SPP_TC1.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2">
    <Task Name="IN_EngCtr" Source="EngineController.IN_EngCtr.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PVcheckNEW" Source="EngineController.PVcheckNEW.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SPP_EC" Source="EngineController.SPP_EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gen_EC_T2" Source="EngineController.gen_EC_T2.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="eng_ctr_EC" Source="EngineController.eng_ctr_EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Gen2_xt" Source="EngineController.Gen2_xt.prg" Memory="UserROM" Description="+ GEN2 controller" Language="IEC" Debugging="true" />
    <Task Name="WasteGate" Source="EngineController.WasteGate.prg" Memory="UserROM" Description="+ WG control Gen1 and interface Gen2" Language="IEC" Debugging="true" />
    <Task Name="gas_flow_E" Source="EngineController.gas_flow_EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="psi_cal" Source="EngineController.psi_cal.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="pi_bal_EC" Source="EngineController.pi_bal_EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="pi_ctr_EC" Source="EngineController.pi_ctr_EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="skip_zde" Source="EngineController.skip_zde.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PUSL" Source="EngineController.PUSL.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="FastStart" Source="EngineController.FastStart.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PFPDR" Source="EngineController.PFPDR.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ignpoint_E" Source="EngineController.ignpoint_EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="hum_pac_EC" Source="EngineController.hum_pac_EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="leanox_EC" Source="EngineController.leanox_EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="DirAirInj" Source="EngineController.DirAirInj.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="misf_det_E" Source="EngineController.misf_det_EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgEC1" Source="EngineController.MsgEC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="dyn_GR" Source="EngineController.dyn_GR.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="GR_GCB_cus" Source="EngineController.GR_GCB_cust.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PBC" Source="EngineController.PBC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SGas" Source="EngineController.Sondergas.SGas.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="GlowIGN" Source="EngineController.Sondergas.GlowIGN.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OUT_EngCtr" Source="EngineController.OUT_EngCtr.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="gen_EC_T5" Source="EngineController.gen_EC_T5.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="misf_ctr_E" Source="EngineController.misf_ctr_EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="exhaust_EC" Source="EngineController.exhaust_EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ESC" Source="EngineController.ESC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisEC" Source="EngineController.VisEC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gassort_in" Source="EngineController.gassort_int.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="PVcheck" Source="EngineController.PVcheck.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PermEC2" Source="EngineController.PermEC2.prg" Memory="UserROM" Description="+ Additional Engine Maps" Language="IEC" Debugging="true" />
    <Task Name="PermMap" Source="EngineController.PermMap.prg" Memory="UserROM" Description="+ Engine Maps and Counters" Language="IEC" Debugging="true" />
    <Task Name="ParEC" Source="EngineController.ParEC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_EC" Source="EngineController.META_EC.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OEC" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pec" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="lHiContr" Source="EngineController.Lib_EC.lHiContr.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="lHiGlob" Source="EngineController.Lib_EC.lHiGlob.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="lMFB50Cont" Source="EngineController.Lib_EC.lMFB50Cont.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="TEC" Source="EngineController.Lib_EC.TEC.lby" Memory="UserROM" Language="IEC" Debugging="false" />
    <LibraryObject Name="lSS" Source="EngineController.Lib_EC.lSS.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="lPFPDR" Source="EngineController.Lib_EC.lPFPDR.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=AC_PFPDR -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D ONESTEPFCN=1 -D TERMFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=0 -D TID01EQ=0" Debugging="false" />
    <LibraryObject Name="lIP_EGTCtr" Source="EngineController.Lib_EC.lIP_EGTCtr.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="lAI50toIT" Source="EngineController.Sondergas.lAI50toIT.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=AI50toIT_mdl -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D ONESTEPFCN=1 -D TERMFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=0 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=0 -D TID01EQ=0" Debugging="false" />
    <LibraryObject Name="lSimPIDx" Source="EngineController.Lib_EC.lSimPIDx.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=SimPIDBR6 -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D ONESTEPFCN=1 -D TERMFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=0 -D TID01EQ=0" Debugging="false" />
    <LibraryObject Name="lCoV" Source="EngineController.Sondergas.lCoV.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=CoV_24Cyl -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D ONESTEPFCN=1 -D TERMFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=0 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=0 -D TID01EQ=0" Debugging="false" />
    <LibraryObject Name="lGen2" Source="EngineController.Lib_EC.lGen2.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2021b\" BuildOptions="-lm -D MODEL=Gen2_ref -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D MODEL_HAS_DYNAMICALLY_LOADED_SFCNS=0 -D CLASSIC_INTERFACE=0 -D ALLOCATIONFCN=0 -D TID01EQ=0 -D TERMFCN=1 -D ONESTEPFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0" Debugging="false" />
    <LibraryObject Name="lFSync" Source="EngineController.Lib_EC.lFSync.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=FSync -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D RT -D USE_RTMODEL -D MAT_FILE=0 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=1 -D ONESTEPFCN=0 -D TERMFCN=1 -D MULTI_INSTANCE_CODE=0" Debugging="false" />
    <LibraryObject Name="lLX2" Source="EngineController.Lib_EC.lLX2.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=LX2 -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D ONESTEPFCN=1 -D TERMFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=0 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=0 -D TID01EQ=0 -O1" Debugging="false" />
    <LibraryObject Name="lLamStart" Source="EngineController.Lib_EC.lLamStart.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=LamStart -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D ONESTEPFCN=1 -D TERMFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=0 -D TID01EQ=0" Debugging="false" />
    <LibraryObject Name="lCPP_Int" Source="EngineController.Lib_EC.lCPP_Int.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=CPP_Int -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D ONESTEPFCN=1 -D TERMFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=0 -D TID01EQ=0" Debugging="false" />
    <LibraryObject Name="lDAI" Source="EngineController.Lib_EC.lDAI.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2021b\" BuildOptions="-lm -D MODEL=DAI -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D MODEL_HAS_DYNAMICALLY_LOADED_SFCNS=0 -D CLASSIC_INTERFACE=0 -D ALLOCATIONFCN=0 -D TID01EQ=0 -D TERMFCN=1 -D ONESTEPFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0 " Debugging="false" />
    <LibraryObject Name="lTExhMon" Source="EngineController.Lib_EC.lTExhMon.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=TExhMon -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D ONESTEPFCN=1 -D TERMFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=0 -D TID01EQ=0" Debugging="false" />
    <LibraryObject Name="lPCGVmon" Source="EngineController.Lib_EC.lPCGVmon.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2020a\" BuildOptions="-lm -D MODEL=PCGVmon -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D MODEL_HAS_DYNAMICALLY_LOADED_SFCNS=0 -D CLASSIC_INTERFACE=0 -D ALLOCATIONFCN=0 -D TID01EQ=0 -D TERMFCN=1 -D ONESTEPFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0" Debugging="false" />
    <LibraryObject Name="lFSyPrM" Source="EngineController.Lib_EC.lFSyPrM.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2020a\" BuildOptions="-lm -D MODEL=FSyPrM -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D MODEL_HAS_DYNAMICALLY_LOADED_SFCNS=0 -D CLASSIC_INTERFACE=0 -D ALLOCATIONFCN=0 -D TID01EQ=0 -D TERMFCN=1 -D ONESTEPFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0" Debugging="false" />
    <LibraryObject Name="lLamCtrPBC" Source="EngineController.Lib_EC.lLamCtrPBC.lby" Memory="UserROM" Description="+ Lambda Controller PBC" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2020a\" BuildOptions="-lm -D MODEL=LamCtrPBC -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D MODEL_HAS_DYNAMICALLY_LOADED_SFCNS=0 -D CLASSIC_INTERFACE=0 -D ALLOCATIONFCN=0 -D TID01EQ=0 -D TERMFCN=1 -D ONESTEPFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0 " Debugging="false" />
    <LibraryObject Name="lTrStRed" Source="EngineController.Lib_EC.lTrStRed.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2020a\" BuildOptions="-lm -D MODEL=FSyPrM -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D MODEL_HAS_DYNAMICALLY_LOADED_SFCNS=0 -D CLASSIC_INTERFACE=0 -D ALLOCATIONFCN=0 -D TID01EQ=0 -D TERMFCN=1 -D ONESTEPFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0" Debugging="false" />
    <LibraryObject Name="lSCRT_ss" Source="EngineController.Lib_EC.lSCRT_ss.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2020a\" BuildOptions="-lm -D MODEL=SCRT_ss -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D MODEL_HAS_DYNAMICALLY_LOADED_SFCNS=0 -D CLASSIC_INTERFACE=0 -D ALLOCATIONFCN=0 -D TID01EQ=0 -D TERMFCN=1 -D ONESTEPFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0" Debugging="false" />
    <LibraryObject Name="lGridStat" Source="EngineController.Lib_EC.lGridStat.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2021b\" BuildOptions="-lm -D MODEL=GridStat -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D MODEL_HAS_DYNAMICALLY_LOADED_SFCNS=0 -D CLASSIC_INTERFACE=0 -D ALLOCATIONFCN=0 -D TID01EQ=0 -D TERMFCN=1 -D ONESTEPFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0" Debugging="false" />
  </Libraries>
</SwConfiguration>