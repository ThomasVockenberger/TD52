<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="default_VE" Source="Ventilation.default_VE.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="general_VE" Source="Ventilation.general_VE.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Vent_ER" Source="Ventilation.Vent_ER.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="T_InAirER" Source="Ventilation.T_InAirER.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="T_AirER" Source="Ventilation.T_AirER.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_InlLou" Source="Ventilation.Ctr_InlLou.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_CircLo" Source="Ventilation.Ctr_CircLou.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_OutLRT" Source="Ventilation.Ctr_OutLRT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_OutLRD" Source="Ventilation.Ctr_OutLRDP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_ER" Source="Ventilation.Ctr_ER.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_OutVRT" Source="Ventilation.Ctr_OutVRT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_OutVRD" Source="Ventilation.Ctr_OutVRDP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgVE" Source="Ventilation.MsgVE.prg" Memory="UserROM" Description="messages" Language="IEC" Debugging="true" />
    <Task Name="vis_VE" Source="Ventilation.vis_VE.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParVE" Source="Ventilation.ParVE.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_VE" Source="Ventilation.META_VE.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OVE" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pve" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>