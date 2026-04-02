<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="default_A1" Source="AuxiliariesGeneral.default_AG_TC2.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Cnt_EO" Source="AuxiliariesGeneral.Cnt_EO.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="default_AG" Source="AuxiliariesGeneral.default_AG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="general_AG" Source="AuxiliariesGeneral.general_AG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgAG" Source="AuxiliariesGeneral.MsgAG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Horn" Source="AuxiliariesGeneral.Horn.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Aux_3" Source="AuxiliariesGeneral.Aux_3.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Aux_4" Source="AuxiliariesGeneral.Aux_4.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Aux_6" Source="AuxiliariesGeneral.Aux_6.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Aux_9" Source="AuxiliariesGeneral.Aux_9.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="AuxRelEngO" Source="AuxiliariesGeneral.AuxRelEngOp.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="EleStart" Source="AuxiliariesGeneral.EleStart.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="AirStart" Source="AuxiliariesGeneral.AirStart.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="blowby" Source="AuxiliariesGeneral.blowby.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_CC" Source="AuxiliariesGeneral.Ctr_CC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="AuxGnl" Source="AuxiliariesGeneral.AuxGnl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Pr_EO" Source="AuxiliariesGeneral.Pr_EO.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="T_EO_AG" Source="AuxiliariesGeneral.T_EO_AG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="TrP_red" Source="AuxiliariesGeneral.TrP_red.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_EOVal" Source="AuxiliariesGeneral.Ctr_EOVal.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_EOVal_" Source="AuxiliariesGeneral.Ctr_EOVal_LT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_ECW" Source="AuxiliariesGeneral.Ctr_ECW.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="FiltUnit" Source="AuxiliariesGeneral.FiltUnit.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Vis_AG" Source="AuxiliariesGeneral.Vis_AG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParAG" Source="AuxiliariesGeneral.ParAG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PermAG" Source="AuxiliariesGeneral.PermAG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OilQsens" Source="AuxiliariesGeneral.OilQsens.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OilTank" Source="AuxiliariesGeneral.OilTank.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OilFill" Source="AuxiliariesGeneral.OilFill.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_AG" Source="AuxiliariesGeneral.META_AG.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OAG" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pag" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>