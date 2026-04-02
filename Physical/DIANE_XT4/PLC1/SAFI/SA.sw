<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1">
    <Task Name="safi_spd" Source="SAFI.safi_spd.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="canmaiSA" Source="SAFI.CAN.canmaiSA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2">
    <Task Name="safi_gen" Source="SAFI.safi_gen.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="safi_mpm" Source="SAFI.safi_mpm.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="safi_kls" Source="SAFI.safi_kls.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CurveUpL" Source="SAFI.CurveUpL.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="IN_SA" Source="SAFI.IN_SA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="safi_mod" Source="SAFI.safi_mod.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="safi_cfg" Source="SAFI.safi_cfg.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="safi_hs" Source="SAFI.safi_hs.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="safi_ign" Source="SAFI.safi_ign.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="safi_pi" Source="SAFI.safi_pi.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="safi_dmr" Source="SAFI.safi_dmr.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="safi_vcd" Source="SAFI.safi_vcd.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgSA" Source="SAFI.MsgSA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OUT_SA" Source="SAFI.OUT_SA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="ParSA" Source="SAFI.ParSA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7">
    <Task Name="caniniSA" Source="SAFI.CAN.caniniSA.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#8">
    <Task Name="CAN_update" Source="SAFI.CAN.Updater.CAN_update.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <DataObjects>
    <DataObject Name="META_SA" Source="SAFI.META_SA.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sa_coil" Source="SAFI.DataSA.sa_coil.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sa_curr" Source="SAFI.DataSA.sa_curr.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sadmr24" Source="SAFI.CAN.sadmr24.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sagen24" Source="SAFI.CAN.sagen24.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="saign24" Source="SAFI.CAN.saign24.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sakls24" Source="SAFI.CAN.sakls24.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sapi24" Source="SAFI.CAN.sapi24.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sadmr1_12" Source="SAFI.CAN.sadmr1_12.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sagen1_12" Source="SAFI.CAN.sagen1_12.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="saign1_12" Source="SAFI.CAN.saign1_12.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sakls1_12" Source="SAFI.CAN.sakls1_12.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sapi1_12" Source="SAFI.CAN.sapi1_12.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sadmr13_24" Source="SAFI.CAN.sadmr13_24.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sagen13_24" Source="SAFI.CAN.sagen13_24.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="saign13_24" Source="SAFI.CAN.saign13_24.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sakls13_24" Source="SAFI.CAN.sakls13_24.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sapi13_24" Source="SAFI.CAN.sapi13_24.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sadmr1_10" Source="SAFI.CAN.sadmr1_10.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sagen1_10" Source="SAFI.CAN.sagen1_10.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="saign1_10" Source="SAFI.CAN.saign1_10.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sakls1_10" Source="SAFI.CAN.sakls1_10.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sapi1_10" Source="SAFI.CAN.sapi1_10.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sadmr11_20" Source="SAFI.CAN.sadmr11_20.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sagen11_20" Source="SAFI.CAN.sagen11_20.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="saign11_20" Source="SAFI.CAN.saign11_20.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sakls11_20" Source="SAFI.CAN.sakls11_20.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sapi11_20" Source="SAFI.CAN.sapi11_20.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sadmr1_8" Source="SAFI.CAN.sadmr1_8.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sagen1_8" Source="SAFI.CAN.sagen1_8.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="saign1_8" Source="SAFI.CAN.saign1_8.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sakls1_8" Source="SAFI.CAN.sakls1_8.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sapi1_8" Source="SAFI.CAN.sapi1_8.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sadmr9_16" Source="SAFI.CAN.sadmr9_16.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sagen9_16" Source="SAFI.CAN.sagen9_16.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="saign9_16" Source="SAFI.CAN.saign9_16.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sakls9_16" Source="SAFI.CAN.sakls9_16.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sapi9_16" Source="SAFI.CAN.sapi9_16.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sadmr1_6" Source="SAFI.CAN.sadmr1_6.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sagen1_6" Source="SAFI.CAN.sagen1_6.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="saign1_6" Source="SAFI.CAN.saign1_6.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sakls1_6" Source="SAFI.CAN.sakls1_6.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sapi1_6" Source="SAFI.CAN.sapi1_6.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sadmr7_12" Source="SAFI.CAN.sadmr7_12.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sagen7_12" Source="SAFI.CAN.sagen7_12.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="saign7_12" Source="SAFI.CAN.saign7_12.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sakls7_12" Source="SAFI.CAN.sakls7_12.dob" Memory="UserROM" Language="Simple" />
    <DataObject Name="sapi7_12" Source="SAFI.CAN.sapi7_12.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="safi_719" Source="SAFI.CAN.Updater.br_modules.safi_719.br" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="K773Prop" Source="SAFI.CAN.Updater.br_modules.K773Prop.br" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="K773Fpga" Source="SAFI.CAN.Updater.br_modules.K773Fpga.br" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="K773Ppc" Source="SAFI.CAN.Updater.br_modules.K773Ppc.br" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="D755Prop" Source="SAFI.CAN.Updater.br_modules.D755Prop.br" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="D755Fpga" Source="SAFI.CAN.Updater.br_modules.D755Fpga.br" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="D755Ppc" Source="SAFI.CAN.Updater.br_modules.D755Ppc.br" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="K21F2004" Source="SAFI.CAN.Updater.br_modules.K21F2004.br" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="SA3F3007" Source="SAFI.CAN.Updater.br_modules.SA3F3007.br" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OSA" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="safi" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="lSAFI_VCD" Source="SAFI.Lib_SA.lSAFI_VCD.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2020a\" BuildOptions="-lm -D MODEL=SAFI_VCD -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D MODEL_HAS_DYNAMICALLY_LOADED_SFCNS=0 -D CLASSIC_INTERFACE=0 -D ALLOCATIONFCN=0 -D TID01EQ=0 -D TERMFCN=1 -D ONESTEPFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0 " Debugging="false" />
  </Libraries>
</SwConfiguration>