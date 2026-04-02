<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="statGR_cur" Source="Grid.statGR_curves.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="statGR_Q" Source="Grid.statGR_Q.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="statGR_P" Source="Grid.statGR_P.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgGR" Source="Grid.MsgGR.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ERDF" Source="Grid.ERDF.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisGR" Source="Grid.VisGR.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParGR" Source="Grid.ParGR.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_GR" Source="Grid.META_GR.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OGM" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pgm" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pgr" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="PT2_LIB" Source="Grid.Lib_GR.PT2_LIB.lby" Memory="UserROM" Language="IEC" Debugging="false" />
  </Libraries>
</SwConfiguration>