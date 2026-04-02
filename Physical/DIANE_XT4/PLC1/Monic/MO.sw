<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="IN_MO" Source="Monic.IN_MO.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="monic" Source="Monic.monic.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgMO" Source="Monic.MsgMO.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OUT_MO" Source="Monic.OUT_MO.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="caniniMo" Source="Monic.CAN.caniniMo.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParMO" Source="Monic.ParMO.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="cmsmonic" Source="Monic.CAN.cmsmonic.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="META_MO" Source="Monic.META_MO.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
</SwConfiguration>