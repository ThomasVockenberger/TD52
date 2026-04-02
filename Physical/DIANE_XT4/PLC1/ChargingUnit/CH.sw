<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="CH_Temp" Source="ChargingUnit.CH_Temp.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CH_Press" Source="ChargingUnit.CH_Press.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="GeneralCH" Source="ChargingUnit.GeneralCH.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="DefaultCH" Source="ChargingUnit.DefaultCH.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CH_SpeedTC" Source="ChargingUnit.CH_SpeedTC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CH_dpAirIn" Source="ChargingUnit.CH_dpAirIn.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgCH" Source="ChargingUnit.MsgCH.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParCH" Source="ChargingUnit.ParCH.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_CH" Source="ChargingUnit.META_CH.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="pch" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OCH" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>