<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="canmai" Source="KLS98.canmai.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="IN_KLS" Source="KLS98.IN_KLS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="kls_98" Source="KLS98.kls_98.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgKLS" Source="KLS98.MsgKLS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OUT_KLS" Source="KLS98.OUT_KLS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="EngTypeKL" Source="KLS98.EngTypeKL.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisKL" Source="KLS98.VisKL.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParKL" Source="KLS98.ParKL.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7">
    <Task Name="caniniKL" Source="KLS98.caniniKL.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_KL" Source="KLS98.META_KL.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="cmskls_1" Source="KLS98.cmskls_1.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="cmskls_2" Source="KLS98.cmskls_2.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="cmskls_3" Source="KLS98.cmskls_3.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="cmskls_4" Source="KLS98.cmskls_4.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
</SwConfiguration>