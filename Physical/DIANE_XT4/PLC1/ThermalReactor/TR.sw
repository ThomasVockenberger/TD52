<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="GeneralTR" Source="ThermalReactor.GeneralTR.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="reac_set" Source="ThermalReactor.reac_set.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="reactor" Source="ThermalReactor.reactor.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_TR_4" Source="ThermalReactor.Ctr_TR_4.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisTR" Source="ThermalReactor.VisTR.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgTR" Source="ThermalReactor.MsgTR.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParTR" Source="ThermalReactor.ParTR.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PermTR" Source="ThermalReactor.PermTR.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_TR" Source="ThermalReactor.META_TR.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="ptr" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>