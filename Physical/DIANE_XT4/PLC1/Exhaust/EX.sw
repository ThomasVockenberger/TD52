<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1">
    <Task Name="Pr_EG_TC1" Source="Exhaust.Pr_EG_TC1.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="default_EX" Source="Exhaust.default_EX.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="general_EX" Source="Exhaust.general_EX.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="EG_Scav" Source="Exhaust.EG_Scav.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="EG_VaCo" Source="Exhaust.EG_VaCo.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="codinox" Source="Exhaust.codinox.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgEX" Source="Exhaust.MsgEX.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="vis_EX" Source="Exhaust.vis_EX.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PermEX" Source="Exhaust.PermEX.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParEX" Source="Exhaust.ParEX.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_EX" Source="Exhaust.META_EX.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OEX" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pex" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="exhaust" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>