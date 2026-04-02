<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="IN_Knck" Source="Knocking.IN_Knck.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Kn_knock" Source="Knocking.Kn_knock.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Knck_KLS98" Source="Knocking.Knck_KLS98.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Kn_safi_kl" Source="Knocking.Kn_safi_kls.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Kn_safi_dm" Source="Knocking.Kn_safi_dmr.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgKN" Source="Knocking.MsgKN.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OUT_Knck" Source="Knocking.OUT_Knck.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisKN" Source="Knocking.VisKN.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5" />
  <TaskClass Name="Cyclic#6">
    <Task Name="ParKN" Source="Knocking.ParKN.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_KN" Source="Knocking.META_KN.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OKN" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pkn" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="lMeNoiAL" Source="Knocking.Lib_KN.lMeNoiAL.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=MeNoiAL -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D ONESTEPFCN=1 -D TERMFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=0 -D TID01EQ=0" Debugging="false" />
  </Libraries>
</SwConfiguration>