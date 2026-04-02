<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="GeneralVI" Source="Visu.GeneralVI.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgVI" Source="Visu.MsgVI.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParVI" Source="Visu.ParVI.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PermVI" Source="Visu.PermVI.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8">
    <Task Name="IF_HMI_CP" Source="Visu.IF_HMI_CP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <DataObjects>
    <DataObject Name="META_VI" Source="Visu.META_VI.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OVI" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pvi" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>