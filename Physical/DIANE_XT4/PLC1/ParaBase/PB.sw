<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="setting_PB" Source="ParaBase.setting_PB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="general_PB" Source="ParaBase.general_PB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ParaMaster" Source="ParaBase.ParaMaster.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisVersion" Source="ParaBase.VisVersion.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Checkmap" Source="ParaBase.Checkmap.prg" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <Task Name="MsgPB" Source="ParaBase.MsgPB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParPB" Source="ParaBase.ParPB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PermPB" Source="ParaBase.PermPB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PermCntChe" Source="ParaBase.PermCntCheck.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_PB" Source="ParaBase.META_PB.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="ppb" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OPB" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="ppa" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>