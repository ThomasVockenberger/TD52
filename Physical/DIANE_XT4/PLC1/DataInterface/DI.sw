<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="Gnl_AG" Source="DataInterface.Gnl_AG.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.02.0" />
    <Task Name="Gnl_GT" Source="DataInterface.Gnl_GT.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.03.0" />
    <Task Name="Gnl_HC" Source="DataInterface.Gnl_HC.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.01.0" />
    <Task Name="Gnl_ME" Source="DataInterface.Gnl_ME.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.03.0" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="IN_DI" Source="DataInterface.IN_DI.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.02.0" />
    <Task Name="OUT_DI" Source="DataInterface.OUT_DI.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.02.0" />
    <Task Name="PermDI" Source="DataInterface.PermDI.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.02.0" />
    <Task Name="VIS2PermDI" Source="DataInterface.VIS2PermDI.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.03.0" />
    <Task Name="OpcVE" Source="DataInterface.OpcVE.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.02.0" />
    <Task Name="OpcAG" Source="DataInterface.OpcAG.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.01.0" />
    <Task Name="OpcCU" Source="DataInterface.OpcCU.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.03.0" />
    <Task Name="OpcEX" Source="DataInterface.OpcEX.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.02.0" />
    <Task Name="OpcGT" Source="DataInterface.OpcGT.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.03.0" />
    <Task Name="OpcHC" Source="DataInterface.OpcHC.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.02.0" />
    <Task Name="OpcME" Source="DataInterface.OpcME.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.03.0" />
    <Task Name="OpcMsg" Source="DataInterface.OpcMsg.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.02.0" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8">
    <Task Name="OpcMDE" Source="DataInterface.OpcMDE.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="1.02.0" />
  </TaskClass>
  <DataObjects>
    <DataObject Name="META_DI" Source="DataInterface.META_DI.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="di" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OPCdi" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>