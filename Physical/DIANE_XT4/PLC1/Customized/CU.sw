<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="c_cnt" Source="Customized.c_cnt.prg" Memory="UserROM" Description="Counter Task to handle customizable counters (10ms TC#2 = &lt;50Hz)" Language="IEC" Debugging="true" />
    <Task Name="c_statGR_T" Source="Customized.c_statGR_TC2.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="XComMap10" Source="Customized.PlantCom.c_PlantComMap10ms.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="c_modIF" Source="Customized.c_modIF.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_ana" Source="Customized.c_ana.prg" Memory="UserROM" Description="spare analog in-/outputs, usage is to be defined hardcoded" Language="IEC" Debugging="true" />
    <Task Name="c_scal" Source="Customized.c_scal.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_dig" Source="Customized.c_dig.prg" Memory="UserROM" Description="Digital I/O Task to handle prepared customizable digital signals" Language="IEC" Debugging="true" />
    <Task Name="c_par" Source="Customized.c_par.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_ctr" Source="Customized.c_ctr.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_red" Source="Customized.c_red.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_set" Source="Customized.c_set.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_aux" Source="Customized.c_aux.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_spare1" Source="Customized.c_spare1.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_spare2" Source="Customized.c_spare2.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_spare3" Source="Customized.c_spare3.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_mns" Source="Customized.c_mns.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_fc" Source="Customized.c_fc.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_statGR" Source="Customized.c_statGR.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_coupl" Source="Customized.c_coupl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="c_clutch_C" Source="Customized.c_clutch_CAN.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ran_Intern" Source="Customized.Cust_Internals.ran_Internal.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgCU" Source="Customized.MsgCU.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgCUInter" Source="Customized.Cust_Internals.MsgCUInternal.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisCU" Source="Customized.VisCU.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BaseVers" Source="Customized.Cust_Internals.BaseVers.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="XComMap100" Source="Customized.PlantCom.c_PlantComMap100ms.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParCU" Source="Customized.Cust_Internals.ParCU.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PermCU" Source="Customized.Cust_Internals.PermCU.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_CU" Source="Customized.META_CU.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="aeprot" Source="Customized.aeprot.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OCU" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pcu" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>