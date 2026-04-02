<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="default_HC" Source="HeatingCooling.default_HC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="general_HC" Source="HeatingCooling.general_HC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BHV" Source="HeatingCooling.BHV.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Cnt_P_Heat" Source="HeatingCooling.Cnt_P_Heat.prg" Memory="UserROM" Language="IEC" Debugging="true" Version="4.02.0" />
    <Task Name="Ctr_ChC" Source="HeatingCooling.Ctr_ChC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_ChC_T1" Source="HeatingCooling.Ctr_ChC_T1HP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_ChCV" Source="HeatingCooling.Ctr_ChCV.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_ChCHP" Source="HeatingCooling.Ctr_ChCHP.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_HWRe" Source="HeatingCooling.Ctr_HWRe.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_EC" Source="HeatingCooling.Ctr_EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_HWSu" Source="HeatingCooling.Ctr_HWSu.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_CDSu" Source="HeatingCooling.Ctr_CDSu.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ChC_Seq" Source="HeatingCooling.ChC_Seq.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="EC" Source="HeatingCooling.EC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="EC_Seq" Source="HeatingCooling.EC_Seq.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ChC" Source="HeatingCooling.ChC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Pr_ECW" Source="HeatingCooling.Pr_ECW.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="T_CD" Source="HeatingCooling.T_CD.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="T_ECW" Source="HeatingCooling.T_ECW.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="T_EO" Source="HeatingCooling.T_EO.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="T_HW" Source="HeatingCooling.T_HW.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="T_AirOutdo" Source="HeatingCooling.T_AirOutdoor.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="T_Ch" Source="HeatingCooling.T_Ch.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="vis_HC" Source="HeatingCooling.vis_HC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgHC" Source="HeatingCooling.MsgHC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="PermHC" Source="HeatingCooling.PermHC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ParHC" Source="HeatingCooling.ParHC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_HC" Source="HeatingCooling.META_HC.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="par_Hc" Source="" Memory="UserROM" Language="Binary" />
    <DataObject Name="par_hc_B" Source="" Memory="UserROM" Language="Binary" />
    <DataObject Name="par_HC" Source="" Memory="UserROM" Language="Binary" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OHC" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="phc" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="heatingcoo" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>