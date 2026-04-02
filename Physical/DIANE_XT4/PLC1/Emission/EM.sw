<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="DefaultEM" Source="Emission.DefaultEM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="GeneralEM" Source="Emission.GeneralEM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="NOxSensor" Source="Emission.NOxSensor.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SCR_Cat" Source="Emission.SCR_Cat.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="EmissionMo" Source="Emission.EmissionMon.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SCR_UDC" Source="Emission.SCR_UDC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgEM" Source="Emission.MsgEM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="SCR_MBSlav" Source="Emission.SCR_MBSlave.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PermEM" Source="Emission.PermEM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ParEM" Source="Emission.ParEM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_EM" Source="Emission.META_EM.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="OEM" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="pem" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="lUDC" Source="Emission.Lib_EM.lUDC.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=UreaDosageContr -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D ONESTEPFCN=1 -D TERMFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=0 -D TID01EQ=0" Debugging="true" />
  </Libraries>
</SwConfiguration>