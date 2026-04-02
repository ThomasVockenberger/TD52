<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1">
    <Task Name="IOchannel1" Source="HalIO.IOchannelEval.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IO_Custom" Source="HalIO.IO_Custom.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IOchannel" Source="HalIO.IOchannel.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2">
    <Task Name="IOchannel2" Source="HalIO.IOchannelEval.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="caninitHA" Source="HalIO.CAN.caninitHA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CAN_NOx_WG" Source="HalIO.CAN.CAN_NOx_WG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CAN_Conrod" Source="HalIO.CAN.CAN_Conrod.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CAN_OQS" Source="HalIO.CAN.CAN_OQS.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="xComMapIn2" Source="HalIO.PlantCommunication.xComMapIn10ms.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="xComIO2" Source="HalIO.PlantCommunication.xComIO10ms.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="xComMapOu2" Source="HalIO.PlantCommunication.xComMapOut10ms.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="IN_HA" Source="HalIO.IN_HA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IOchannel5" Source="HalIO.IOchannelEval.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MMUsync1" Source="HalIO.MMUsync1.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MMUsync2" Source="HalIO.MMUsync2.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="cancheckHA" Source="HalIO.CAN.cancheckHA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gm_X20SM_H" Source="HalIO.gm_X20SM_HA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="modFilt" Source="HalIO.modFilt.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgHA" Source="HalIO.MsgHA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="mod_chk" Source="HalIO.mod_chk.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="xComMapIn5" Source="HalIO.PlantCommunication.xComMapIn100ms.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="xComCfg" Source="HalIO.PlantCommunication.XComCfg.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="xComHmi" Source="HalIO.PlantCommunication.XComHmi.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="xComIO5" Source="HalIO.PlantCommunication.xComIO100ms.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="xComMapOu5" Source="HalIO.PlantCommunication.xComMapOut100ms.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OUT_HA" Source="HalIO.OUT_HA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="IOchannel6" Source="HalIO.IOchannelEval.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ParHA" Source="HalIO.ParHA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7">
    <Task Name="IOchannelP" Source="HalIO.IOchannelPara.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BSOD_chk" Source="HalIO.BSOD_chk.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#8">
    <Task Name="RdMeta" Source="HalIO.RdMeta.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="mod_list" Source="HalIO.mod_list.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <DataObjects>
    <DataObject Name="META_HA" Source="HalIO.META_HA.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="cmsinit" Source="HalIO.CAN.cmsinit.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="IOcfg" Source="HalIO.IOcfg.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OHA" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pha" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="halio" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>