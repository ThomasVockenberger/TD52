<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="Spec_GM" Source="Gasmixer.Spec_GM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="GeneralGM" Source="Gasmixer.GeneralGM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="GM_control" Source="Gasmixer.GM_control.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgGM" Source="Gasmixer.MsgGM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParGM" Source="Gasmixer.ParGM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_GM" Source="Gasmixer.META_GM.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OGM" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pgm" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>