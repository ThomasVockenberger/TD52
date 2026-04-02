<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1">
    <Task Name="SpeedIC" Source="ICxx.SpeedIC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2">
    <Task Name="ICGen" Source="ICxx.ICGen.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SEMIC" Source="ICxx.SEMIC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="IN_IC" Source="ICxx.IN_IC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ignition" Source="ICxx.ignition.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgIC" Source="ICxx.MsgIC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisIC" Source="ICxx.VisIC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OUT_IC" Source="ICxx.OUT_IC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="caniniIc" Source="ICxx.CAN.caniniIc.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParIC" Source="ICxx.ParIC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8">
    <Task Name="IC_Updater" Source="ICxx.CAN.IC_Updater.prg" Memory="UserROM" Description="+ IC firmware updater" Language="IEC" Debugging="true" />
  </TaskClass>
  <DataObjects>
    <DataObject Name="META_IC" Source="ICxx.META_IC.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="IC_Coil" Source="ICxx.DataIC.IC_Coil.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="IC_Curr" Source="ICxx.DataIC.IC_Curr.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="cmsign" Source="ICxx.CAN.cmsign.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="picxx" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OICxx" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="SEMIC_25" Source="ICxx.CAN.SEMIC_25.br" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>