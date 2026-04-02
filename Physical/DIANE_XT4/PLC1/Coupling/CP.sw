<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="MBRMaster" Source="Coupling.MBRMaster.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="GeneralCP" Source="Coupling.GeneralCP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ExtSelect" Source="Coupling.ExtSelect.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="inData" Source="Coupling.inData.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="outData" Source="Coupling.outData.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="couplctrl" Source="Coupling.couplctrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="coupling" Source="Coupling.coupling.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgCP" Source="Coupling.MsgCP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParCP" Source="Coupling.ParCP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_CP" Source="Coupling.META_CP.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="cfg_mbus" Source="Coupling.cfg_mbus.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OCP" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pcp" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>