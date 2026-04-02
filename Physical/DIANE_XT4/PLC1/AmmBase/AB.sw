<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="default_AB" Source="AmmBase.default_AB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="general_AB" Source="AmmBase.general_AB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="AmmGnl" Source="AmmBase.AmmGnl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="reset" Source="AmmBase.reset.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgAB" Source="AmmBase.MsgAB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="vis_AB" Source="AmmBase.vis_AB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="AmmGnlTC5" Source="AmmBase.AmmGnlTC5.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParAB" Source="AmmBase.ParAB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_AB" Source="AmmBase.META_AB.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OAB" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pab" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>