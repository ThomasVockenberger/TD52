<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1">
    <Task Name="VibMonEG" Source="EngineGeneral.VibMonEG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2" />
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="GeneralEG" Source="EngineGeneral.GeneralEG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="DefaultEG" Source="EngineGeneral.DefaultEG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="slowdownT" Source="EngineGeneral.slowdownT.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="barometric" Source="EngineGeneral.barometric.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MainBearin" Source="EngineGeneral.MainBearing.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ConRoMon" Source="EngineGeneral.ConRoMon.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IdleFric" Source="EngineGeneral.IdleFric.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgEG" Source="EngineGeneral.MsgEG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="Safety_PLC" Source="EngineGeneral.Safety_PLC.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PUscuffDet" Source="EngineGeneral.PUscuffDet.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ParEG" Source="EngineGeneral.ParEG.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_EG" Source="EngineGeneral.META_EG.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="peg" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OEG" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="lPUscuff" Source="EngineGeneral.Lib_EG.lPUscuff.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2020a\" BuildOptions="-lm -D MODEL=PUscuff -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D MODEL_HAS_DYNAMICALLY_LOADED_SFCNS=0 -D CLASSIC_INTERFACE=0 -D ALLOCATIONFCN=0 -D TID01EQ=0 -D TERMFCN=1 -D ONESTEPFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0" Debugging="false" />
  </Libraries>
</SwConfiguration>