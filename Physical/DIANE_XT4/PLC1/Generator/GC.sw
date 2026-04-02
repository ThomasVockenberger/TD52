<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="MMUEarthFa" Source="Generator.MMUEarthFault.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="defaultGC" Source="Generator.defaultGC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="general_GC" Source="Generator.general_GC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="oilskid" Source="Generator.oilskid.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gwt" Source="Generator.gwt.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ereg" Source="Generator.ereg.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="pf_cust" Source="Generator.pf_cust.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="pf_ctr" Source="Generator.pf_ctr.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="v_ctr" Source="Generator.v_ctr.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_GenPF" Source="Generator.Ctr_GenPF.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_Q" Source="Generator.Ctr_Q.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gen_aux" Source="Generator.gen_aux.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisGC" Source="Generator.VisGC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgGC" Source="Generator.MsgGC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="PermGC" Source="Generator.PermGC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ParGC" Source="Generator.ParGC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_GC" Source="Generator.META_GC.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="pgc" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OGC" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>