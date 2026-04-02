<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Exception" />
  <TaskClass Name="Cyclic#1" />
  <TaskClass Name="Cyclic#2">
    <Task Name="IN_CBM" Source="CBM.IN_CBM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PBC_Contro" Source="CBM.PBCMemV2.PBC_Control.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PBC_Buffer" Source="CBM.PBCMemV2.PBC_Buffer.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Stat10ms" Source="CBM.Statistic.Stat10ms.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ErrCnt" Source="CBM.Statistic.ErrCnt.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="GnrlCBM" Source="CBM.GnrlCBM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="TCB_Buffer" Source="CBM.PBCMemV2.TCB_Buffer.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4" />
  <TaskClass Name="Cyclic#5">
    <Task Name="Stat100ms" Source="CBM.Statistic.Stat100ms.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="VisCBM" Source="CBM.VisCBM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="MsgCB" Source="CBM.MsgCB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="PBC_Obj" Source="CBM.PBCMemV2.PBC_Obj.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Stat_Obj" Source="CBM.Statistic.Stat_Obj.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ParCB" Source="CBM.ParCB.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PermCBM" Source="CBM.PermCBM.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <DataObjects>
    <DataObject Name="META_CB" Source="CBM.META_CB.dob" Memory="UserROM" Language="Simple" />
  </DataObjects>
  <Libraries>
    <LibraryObject Name="MSCcsv" Source="CBM.Lib.MSCcsv.lby" Memory="UserROM" Language="IEC" Debugging="false" />
    <LibraryObject Name="lGEN2diag" Source="CBM.Lib.lGEN2diag.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=G2Fdiag -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D ONESTEPFCN=1 -D TERMFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=0 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=0 -D TID01EQ=0 " Debugging="false" />
    <LibraryObject Name="lFricIMEP" Source="CBM.Lib.lFricIMEP.lby" Memory="UserROM" Language="ANSIC" AdditionalIncludeDirectories="\Logical\Libraries\MATLAB_includes\R2012b\" BuildOptions="-lm -D MODEL=J920_fric -D NUMST=1 -D NCSTATES=0 -D HAVESTDIO -D ONESTEPFCN=1 -D TERMFCN=1 -D MAT_FILE=0 -D MULTI_INSTANCE_CODE=1 -D INTEGER_CODE=0 -D MT=0 -D CLASSIC_INTERFACE=0 -D TID01EQ=0" Debugging="false" />
  </Libraries>
</SwConfiguration>