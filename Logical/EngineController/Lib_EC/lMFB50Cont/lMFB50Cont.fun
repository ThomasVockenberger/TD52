FUNCTION_BLOCK MFB50Contr
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        MapPoP2sx : ARRAY[0..1] OF LREAL := [2(1000.0000000000)]; (*p2s values for map in [mbar]*)
  END_VAR
  VAR_INPUT
        MFB50GlobRefExt : LREAL := 5.0000000000; (*Global reference for MFB50 in [CADafTDC]*)
  END_VAR
  VAR_INPUT
        MFB50MedianEn : BOOL := FALSE; (*Switch to decide between different MFB50 references [boolean], 0 = global reference, 1 = median *)
  END_VAR
  VAR_INPUT
        MapPoP2sy : ARRAY[0..1] OF LREAL := [2(0.5000000000)]; (*proportional gain values for map in [CADbfTDC / CADafTDC]*)
  END_VAR
  VAR_INPUT
        MapIoP2sx : ARRAY[0..1] OF LREAL := [2(1000.0000000000)]; (*p2s values for map in [mbar]*)
  END_VAR
  VAR_INPUT
        MapIoP2sy : ARRAY[0..1] OF LREAL := [2(1.0000000000)]; (*integral gain values for map in [CADbfTDC / s / CADafTDC]*)
  END_VAR
  VAR_INPUT
        MapMFB50oT3HPx : ARRAY[0..1] OF LREAL := [2(20.0000000000)]; (*T3HP values for map in [°C]*)
  END_VAR
  VAR_INPUT
        MapMFB50oT3HPy : ARRAY[0..1] OF LREAL := [2(4.0000000000)]; (*MFB50 offset values for map in [CADafTDC]*)
  END_VAR
  VAR_INPUT
        MapMFB50oP2sx : ARRAY[0..1] OF LREAL := [2(1000.0000000000)]; (*p2s values for map in [mbar]*)
  END_VAR
  VAR_INPUT
        MapMFB50oP2sy : ARRAY[0..1] OF LREAL := [2(4.0000000000)]; (*MFB50 offset values for map in [CADafTDC]*)
  END_VAR
  VAR_INPUT
        freezeAllCyl : ARRAY[0..20] OF BOOL := [21(FALSE)]; (*freeze all PI controller outputs and integrators [boolean]*)
  END_VAR
  VAR_INPUT
        uMax : LREAL := 5.0000000000; (*Max limit for IT offset in (CADbfTDC)*)
  END_VAR
  VAR_INPUT
        resetAllCyl : ARRAY[0..20] OF BOOL := [21(FALSE)]; (*reset PI controller of cylinder if = true [boolean]*)
  END_VAR
  VAR_INPUT
        I0AllCyl : ARRAY[0..20] OF LREAL; (*if reset = 1 PI controller of cylinder will be reset to this value [CADbfTDC]*)
  END_VAR
  VAR_INPUT
        MFB50RefOffsetAllCyl : ARRAY[0..20] OF LREAL; (*External offset on reference MFB50 for each cylinder in [CADafTDC]*)
  END_VAR
  VAR_INPUT
        isSkipAllCyl : ARRAY[0..20] OF BOOL := [21(FALSE)]; (*indicator if cylinder is skipped [boolean]*)
  END_VAR
  VAR_INPUT
        isKnockITRetAllCyl : ARRAY[0..20] OF BOOL := [21(FALSE)]; (*indicator if ignition timing on cylinder is retarded due to knock [boolean]*)
  END_VAR
  VAR_INPUT
        isSensFailAllCyl : ARRAY[0..20] OF BOOL := [21(FALSE)]; (*indicator if sensor failure was detected on cylinder [boolean]*)
  END_VAR
  VAR_INPUT
        isITRetLimpHomeAllCyl : ARRAY[0..20] OF BOOL := [21(FALSE)]; (*indicator if ignition timing on cylinder is retarded due to knock [boolean]*)
  END_VAR
  VAR_INPUT
        isFastStart : BOOL := FALSE; (*indicator if fast start is possible [boolean]*)
  END_VAR
  VAR_INPUT
        EngOpState : INT; (*Engine operation state [integer], states 1-5*)
  END_VAR
  VAR_INPUT
        p2s_A : LREAL; (*boost pressure reading bank A in [mbar] *)
  END_VAR
  VAR_INPUT
        uMin : LREAL := -5.0000000000; (*Min limit for IT offset in (CADbfTDC)*)
  END_VAR
  VAR_INPUT
        p2s_B : LREAL; (*boost pressure reading bank B in [mbar]*)
  END_VAR
  VAR_INPUT
        T3HP_A : LREAL; (*Temperature measurement between HP and LP turbines bank A in [°C]*)
  END_VAR
  VAR_INPUT
        T3HP_B : LREAL; (*Temperature measurement between HP and LP turbines bank B in [°C]*)
  END_VAR
  VAR_INPUT
        isLVRT : BOOL := FALSE; (*Indicates LVRT event, impulse for a certain time*)
  END_VAR
  VAR_INPUT
        engSpeed : LREAL := 1000.0000000000; (*engine speed in [rpm]*)
  END_VAR
  VAR_INPUT
        MFB50ActAllCyl : ARRAY[0..20] OF LREAL; (*MFB50 actual value for each cylinder in [CADaFTDC]*)
  END_VAR
  VAR_INPUT
        MFB50EnPowTh : LREAL := 25.0000000000; (*Load threshold for MFB50 control release in [% of  nom load]*)
  END_VAR
  VAR_INPUT
        PelAct : LREAL; (*Actual filtered electric load [% of  nom load]*)
  END_VAR
  VAR_INPUT
        LoadEnabled : BOOL := FALSE; (*If 1, MFB50 control is enabled above load threshold*)
  END_VAR
  VAR_INPUT
        deadbandPos : LREAL; (*Deadband for positive values (CADafTDC)*)
  END_VAR
  VAR_INPUT
        deadbandNeg : LREAL; (*Deadband for negative values (CADafTDC)*)
  END_VAR
  VAR_INPUT
        T1_PT1 : LREAL := 1.0000000000; (*First order time constant for PT1 filter in [s]*)
  END_VAR
  VAR_INPUT
        init_PT1 : ARRAY[0..20] OF LREAL; (*Initial values for PT1 filter for each cylinder in [CADafTDC]*)
  END_VAR
  VAR_INPUT
        MFB50ContrEn : BOOL := TRUE; (*activate MFB50 control if = 1 [boolean], if 0, main control code will not be executed (case loop)*)
  END_VAR
  VAR_INPUT
        MFB50EnSpdTh : LREAL := 500.0000000000; (*speed threshold for MFB50 control release in [rpm]*)
  END_VAR
  VAR_OUTPUT
        MFB50RefGlobP2s : LREAL; (*Reference offset for MFB50 depend on P2s [CADafTDC]*)
  END_VAR
  VAR_OUTPUT
        T3HPout : LREAL := 40.0000000000; (*T3HP value input to MFB50 offset map in [mbar]*)
  END_VAR
  VAR_OUTPUT
        MFB50RefGlobT3HP : LREAL; (*Reference offset for MFB50 depend on T3HP [CADafTDC]*)
  END_VAR
  VAR_OUTPUT
        p2sOut : LREAL := 1000.0000000000; (*p2s value input to MFB50 offset map in [mbar]*)
  END_VAR
  VAR_OUTPUT
        P : LREAL; (*Proportional gain of MFB50 controller*)
  END_VAR
  VAR_OUTPUT
        I : LREAL; (*Integral gain of MFB50 controller*)
  END_VAR
  VAR_OUTPUT
        freezeCyl : BOOL := FALSE; (*cylinder freeze of current calculation ( cyl 1-20)*)
  END_VAR
  VAR_OUTPUT
        cyl : DINT := 1; (*cylinder of current calculation [1-20]*)
  END_VAR
  VAR_OUTPUT
        ITOffsetAllCyl_u : ARRAY[0..20] OF LREAL; (*MFB50 controller output u: IT-offset in [CADbfTDC]*)
  END_VAR
  VAR_OUTPUT
        ITOffsetAllCyl_up : ARRAY[0..20] OF LREAL; (*MFB50 controller proportional output up: IT-offset in [CADbfTDC]*)
  END_VAR
  VAR_OUTPUT
        ITOffsetAllCyl_ui : ARRAY[0..20] OF LREAL; (*MFB50 controller integral output ui: IT-offset in [CADbfTDC]*)
  END_VAR
  VAR_OUTPUT
        clock : DINT; (*MFB50 controller output u: IT-offset in [CADbfTDC]*)
  END_VAR
  VAR_OUTPUT
        MFB50RefGlob : LREAL; (*Global reference for MFB50 in [CADafTDC]*)
  END_VAR
  VAR_OUTPUT
        MFB50ActFiltAllCyl : ARRAY[0..20] OF LREAL; (*Filtered MFB50 actual value in [CADafTDC]*)
  END_VAR
  VAR_OUTPUT
        MFB50MedianFilt : LREAL; (*Filtered Median of MFB50 in [CADafTDC]*)
  END_VAR
  VAR_OUTPUT
        MFB50Median : LREAL; (*Median of MFB50 in [CADafTDC]*)
  END_VAR
  VAR_OUTPUT
        Tcycle : LREAL := 0.1200000000; (*Combustion cycle time in [s]*)
  END_VAR
  VAR_OUTPUT
        ACversion : LREAL := 1.0000000000; (*Autocode version (manually set in Simulink)*)
  END_VAR
	VAR
		bur_BlockIO_MFB50Contr_Lib : BlockIO_MFB50Contr_Lib;
	END_VAR
	VAR
		bur_D_Work_MFB50Contr_Lib : D_Work_MFB50Contr_Lib;
	END_VAR
END_FUNCTION_BLOCK