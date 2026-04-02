<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="DefaultGT" Source="Gastrain.DefaultGT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gas_flow" Source="Gastrain.gas_flow.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gas_train" Source="Gastrain.gas_train.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gas_rail" Source="Gastrain.gas_rail.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="puffmini" Source="Gastrain.puffmini.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="DefaultGT1" Source="Gastrain.DefaultGT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CommonGT" Source="Gastrain.CommonGT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gasline1_4" Source="Gastrain.gasline1_4.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="pb4_6" Source="Gastrain.pb4_6.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="vkgverd" Source="Gastrain.vkgverd.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="pb5" Source="Gastrain.pb5.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="spec_gas" Source="Gastrain.spec_gas.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gasum" Source="Gastrain.gasum.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gasum_st" Source="Gastrain.gasum_st.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gas_zust" Source="Gastrain.gas_zust.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="bm3_nm3" Source="Gastrain.bm3_nm3.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="gmv_ber" Source="Gastrain.gmv_ber.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="pb7" Source="Gastrain.pb7.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="biogas" Source="Gastrain.biogas.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Ctr_GC" Source="Gastrain.Ctr_GC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisGT" Source="Gastrain.VisGT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgGT" Source="Gastrain.MsgGT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="PermGT" Source="Gastrain.PermGT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PermGT2" Source="Gastrain.PermGT2.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ParGT" Source="Gastrain.ParGT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_GT" Source="Gastrain.META_GT.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OGT" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pgt" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
</SwConfiguration>