<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1">
    <Task Name="gcbTC1" Source="Synchronization.gcbTC1.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2">
    <Task Name="mainsTC2" Source="Synchronization.mainsTC2.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="default_SY" Source="Synchronization.default_SY.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="general_SY" Source="Synchronization.general_SY.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="TBMode" Source="Synchronization.TBMode.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="sy_in" Source="Synchronization.sy_in.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgSY" Source="Synchronization.MsgSY.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="mains" Source="Synchronization.mains.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gcb" Source="Synchronization.gcb.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="mcb" Source="Synchronization.mcb.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="summary" Source="Synchronization.summary.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="loadshedd" Source="Synchronization.loadshedd.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="de_excit" Source="Synchronization.de_excit.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="blackstart" Source="Synchronization.blackstart.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="LV_GCB" Source="Synchronization.LV_GCB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="sy_out" Source="Synchronization.sy_out.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="vis_SY" Source="Synchronization.vis_SY.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="PermSY" Source="Synchronization.PermSY.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ParSY" Source="Synchronization.ParSY.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_SY" Source="Synchronization.META_SY.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OSY" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="psy" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>