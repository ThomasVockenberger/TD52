<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="IN_GD" Source="GasMeteringUnit.IN_GD.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="GMU" Source="GasMeteringUnit.GMU.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OUT_GD" Source="GasMeteringUnit.OUT_GD.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="canmaiGD" Source="GasMeteringUnit.canmaiGD.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="tecjet" Source="GasMeteringUnit.tecjet.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgGD" Source="GasMeteringUnit.MsgGD.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisGD" Source="GasMeteringUnit.VisGD.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="caninitGD" Source="GasMeteringUnit.caninitGD.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParGD" Source="GasMeteringUnit.ParGD.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="cmstec" Source="GasMeteringUnit.cmstec.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="META_GD" Source="GasMeteringUnit.META_GD.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OGD" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pgd" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>