<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="IGGen" Source="Ignition.IGGen.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="2xzuend" Source="Ignition.2xzuend.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="Selftest" Source="Ignition.Selftest.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgIG" Source="Ignition.MsgIG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisIG" Source="Ignition.VisIG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParIG" Source="Ignition.ParIG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_IG" Source="Ignition.META_IG.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OIG" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pig" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>