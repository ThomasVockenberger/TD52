<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="default_OP" Source="Opstate.default_OP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="op_state" Source="Opstate.op_state.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="powersel" Source="Opstate.powersel.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="speedsel" Source="Opstate.speedsel.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="MsgOP" Source="Opstate.MsgOP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisOP" Source="Opstate.VisOP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParOP" Source="Opstate.ParOP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PermOP" Source="Opstate.PermOP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_OP" Source="Opstate.META_OP.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OOP" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pop" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>