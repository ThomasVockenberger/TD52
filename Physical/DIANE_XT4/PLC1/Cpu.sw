<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5" />
  <TaskClass Name="Cyclic#6" />
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="prfmod$e" Source="" Memory="UserROM" Language="Binary" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="udbdef" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TCData" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="asnxdb1" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="asnxdb3" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="asnxdb2" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="User" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="ashwac" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Role" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="iomap" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arconfig" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="asfw" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="sysconf" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="ashwd" Source="" Memory="SystemROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="AmmBase" Source="Libraries.AmmBase.lby" Memory="UserROM" Language="IEC" Debugging="false" />
    <LibraryObject Name="AsString" Source="Libraries.AsString.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsTime" Source="Libraries.AsTime.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="BrSystem" Source="Libraries.BrSystem.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="DataObj" Source="Libraries.DataObj.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="FileIO" Source="Libraries.FileIO.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="JEW_LIB1" Source="Libraries.JEW_LIB1.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="JWASLIB2" Source="Libraries.JWASLIB2.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="JWASLIB3" Source="Libraries.JWASLIB3.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="LoopConR" Source="Libraries.LoopConR.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="LoopCont" Source="Libraries.LoopCont.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="Operator" Source="Libraries.Operator.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="Runtime" Source="Libraries.Runtime.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="standard" Source="Libraries.standard.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="SYS_LIB" Source="Libraries.SYS_LIB.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="UniAna_in" Source="Libraries.UniAna_in.lby" Memory="UserROM" Language="IEC" Debugging="false" Disabled="true" />
    <LibraryObject Name="UniDig_in" Source="Libraries.UniDig_in.lby" Memory="UserROM" Language="IEC" Debugging="false" Disabled="true" />
    <LibraryObject Name="UniXMLStri" Source="Libraries.UniXMLStri.lby" Memory="UserROM" Language="IEC" Debugging="true" Disabled="true" />
    <LibraryObject Name="CAN_Lib" Source="Libraries.CAN_Lib.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsXml" Source="Libraries.AsXml.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIecCon" Source="Libraries.AsIecCon.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="EngType" Source="Libraries.EngType.lby" Memory="UserROM" Language="IEC" Debugging="false" />
    <LibraryObject Name="OpMode" Source="Libraries.OpMode.lby" Memory="UserROM" Language="IEC" Debugging="false" />
    <LibraryObject Name="GeACtrLib" Source="Libraries.GeACtrLib.lby" Memory="UserROM" Language="IEC" Debugging="false" />
    <LibraryObject Name="AsArLog" Source="Libraries.AsArLog.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIO" Source="Libraries.AsIO.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIODiag" Source="Libraries.AsIODiag.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIOAcc" Source="Libraries.AsIOAcc.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsARCfg" Source="Libraries.AsARCfg.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="CTRL" Source="Libraries.CTRL.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="lSimPID4" Source="Libraries.lSimPID4.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="lSim3pCTR" Source="Libraries.lSim3pCTR.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="HALioBase" Source="Libraries.HALioBase.lby" Memory="UserROM" Language="IEC" Debugging="false" />
    <LibraryObject Name="DRV_mbus" Source="Libraries.DRV_mbus.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="dvframe" Source="Libraries.dvframe.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsTCP" Source="Libraries.AsTCP.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MBTCP" Source="Libraries.MBTCP.lby" Memory="UserROM" Language="ANSIC" BuildOptions="-O1" Debugging="false" />
    <LibraryObject Name="AsArProf" Source="Libraries.AsArProf.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsNxDpS" Source="Libraries.AsNxDpS.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsNxPnS" Source="Libraries.AsNxPnS.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="ModDiag" Source="Libraries.ModDiag.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="TPSA_lib" Source="Libraries.TPSA_lib.lby" Memory="UserROM" Language="IEC" Debugging="false" />
    <LibraryObject Name="ParaBase" Source="Libraries.ParaBase.lby" Memory="UserROM" Language="IEC" Debugging="false" />
    <LibraryObject Name="AsBrMath" Source="Libraries.AsBrMath.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="lSim6CTR" Source="Libraries.lSim6CTR.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="lLamCorr" Source="Libraries.lLamCorr.lby" Memory="UserROM" Language="ANSIC" Debugging="false" />
    <LibraryObject Name="ArEventLog" Source="Libraries.ArEventLog.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsBrStr" Source="Libraries.AsBrStr.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="J_IO_LIB" Source="Libraries.J_IO_LIB.lby" Memory="UserROM" Language="IEC" Debugging="false" />
    <LibraryObject Name="AsIOVib" Source="Libraries.AsIOVib.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsFltGen" Source="Libraries.AsFltGen.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="ArFirewall" Source="Libraries.ArFirewall.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsHW" Source="Libraries.AsHW.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="MpBackup" Source="Libraries.MpBackup.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpBase" Source="Libraries.MpBase.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsANSL" Source="Libraries.AsANSL.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="SfDomain" Source="Libraries.SfDomain.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsEPL" Source="Libraries.AsEPL.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="CONV_HEX" Source="EngineGeneral.Lib_EG.CONV_HEX.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="MpJ1939" Source="Libraries.MpJ1939.lby" Memory="UserROM" Language="Binary" Debugging="true" />
  </Libraries>
</SwConfiguration>