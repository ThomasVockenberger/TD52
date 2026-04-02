FUNCTION_BLOCK HiContr
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        MFGainSkipTdown : REAL; (*Gain for MF integrator deloading time in case of skip-fire*)
  END_VAR
  VAR_INPUT
        GIGain : REAL; (*Gain for glow ignition acting on port injection [%*100cycles/events]*)
  END_VAR
  VAR_INPUT
        WCScaling : REAL; (*Scaling relative to Pmax at full load for weak combustion acting on Pmax stability layer offset in optimizer [%/bar]*)
  END_VAR
  VAR_INPUT
        GIPowGain : REAL; (*Gain for glow ignition acting on power reduction [%Pnom*100cycles/events]*)
  END_VAR
  VAR_INPUT
        MFThSkipOn : REAL; (*Threshold for misfire acting on skip fire [events/100cycles]*)
  END_VAR
  VAR_INPUT
        MFThSkipOff : REAL; (*Threshold for skip fire disabling [events/100cycles]*)
  END_VAR
  VAR_INPUT
        PmaxLimReaHys : REAL; (*Hysteresis for detection bit of Pmax limits reached [bar]*)
  END_VAR
  VAR_INPUT
        MFGain : REAL; (*Gain for misfire acting on port injection [%*100cycles /events]*)
  END_VAR
  VAR_INPUT
        WCGain : REAL; (*Gain for weak combustion acting on Pmax stability layer offset in optimizer [bar*100cycles /events]*)
  END_VAR
  VAR_INPUT
        GIThPIDUR : REAL; (*Threshold for glow ignition acting on port injection [events/100cycles]*)
  END_VAR
  VAR_INPUT
        EngStopErrAck : BOOL := FALSE; (*Error acknowledged after engine stopped [boolean]*)
  END_VAR
  VAR_INPUT
        GIContrEnable : BOOL := FALSE; (*Glow ignition control enabled [boolean]*)
  END_VAR
  VAR_INPUT
        GIPIDURLimMin : REAL; (*Minimum limit for glow ignition acting on port injection [%ofPIDURglobal]*)
  END_VAR
  VAR_OUTPUT
        PIDUROffsetGI : REAL; (*PIDUR offset from glow ignition [% PIDUR global]*)
  END_VAR
  VAR_INPUT
        MFPIDURLimMax : REAL; (*Maximum limit for misfire acting on port injection [%PIDURglobal]*)
  END_VAR
  VAR_INPUT
        MFThPIDUR : REAL; (*Threshold for misfire acting on port injection duration [events/100cycles]*)
  END_VAR
  VAR_INPUT
        MFContrEnable : BOOL := FALSE; (*Misfire control enabled [boolean]*)
  END_VAR
  VAR_OUTPUT
        PIDUROffsetMF : REAL; (*PIDUR offset from misfire [% PIDUR global]*)
  END_VAR
  VAR_OUTPUT
        MFIntOut : REAL; (*Misfire integrator output [events/100 cycles]*)
  END_VAR
  VAR_OUTPUT
        WCIntOut : REAL; (*Weak combustion integrator output [events/100 cycles]*)
  END_VAR
  VAR_OUTPUT
        GIIntOut : REAL; (*Glow ignition integrator output [events/100 cycles]*)
  END_VAR
  VAR_INPUT
        PmaxLimContrEnable : BOOL := FALSE; (*Pmax limit control enabled [boolean]*)
  END_VAR
  VAR_INPUT
        PmaxLimDiane : REAL; (*Pmax limit parameter from Diane [bar]*)
  END_VAR
  VAR_INPUT
        PmaxSDLimMar : REAL; (*Margin to Pmax Shutdown Limit [bar]*)
  END_VAR
  VAR_INPUT
        PmaxStdevFact : REAL; (*Pmax standard deviation factor []*)
  END_VAR
  VAR_INPUT
        PmaxContrGain : REAL; (*Pmax controller gain [%PIDUR/bar]*)
  END_VAR
  VAR_INPUT
        PmaxContrLimMin : REAL; (*Minimum PIDUR offset set by Pmax limiting controller [%PIDUR]*)
  END_VAR
  VAR_OUTPUT
        PIDUROffsetPmax : REAL; (*Pmax limit controller output [% PIDUR global]*)
  END_VAR
  VAR_INPUT
        GIThSkipReset : REAL; (*Reset threshold for glow ignition acting on skip-fire [events/100cycles]*)
  END_VAR
  VAR_OUTPUT
        GICountOut : REAL; (*Glow ignition counter output [counts]*)
  END_VAR
  VAR_OUTPUT
        PmaxAv : REAL; (*Pmax moving average [bar]*)
  END_VAR
  VAR_OUTPUT
        PmaxStd : REAL; (*Pmax moving standard deviation [bar]*)
  END_VAR
  VAR_INPUT
        WCThPmax : REAL; (*Threshold for weak combustion acting on Pmax stability layer offset in optimizer [events/100cycles]*)
  END_VAR
  VAR_INPUT
        GIThSkip : REAL; (*Threshold for glow ignition acting on skip-fire [events/100cycles]*)
  END_VAR
  VAR_INPUT
        GIThCount : REAL; (*Threshold for number of task cycles showing glow ignition to activate power reduction [number of task cycles]*)
  END_VAR
  VAR_INPUT
        Misfire2 : BOOL := FALSE; (*Late misfire [boolean]*)
  END_VAR
  VAR_INPUT
        Misfire1 : BOOL := FALSE; (*Early misfire [boolean]*)
  END_VAR
  VAR_INPUT
        SensSignFault : BOOL := FALSE; (*Sensor signal fault [boolean]*)
  END_VAR
  VAR_INPUT
        TGICount : REAL; (*Glow ignition upwards integration time [combustion cycles]*)
  END_VAR
  VAR_INPUT
        TdownGI : REAL; (*Glow ignition downwards integration time [combustion cycles]*)
  END_VAR
  VAR_INPUT
        GlowIgn : BOOL := FALSE; (*Glow ignition [boolean]*)
  END_VAR
  VAR_INPUT
        TupGI : REAL; (*Glow ignition upwards integration time [combustion cycles]*)
  END_VAR
  VAR_INPUT
        TdownMF : REAL; (*Misfire downwards integration time [combustion cycles]*)
  END_VAR
  VAR_INPUT
        WCPmaxLimMax : REAL; (*Maximum limit for weak combustion acting on Pmax stability layer offset in optimizer [%ofPmax]*)
  END_VAR
  VAR_INPUT
        TupWC : REAL; (*Weak combustion upwards integration time [combustion cycles]*)
  END_VAR
  VAR_INPUT
        TupMF : REAL; (*Misfire upwards integration time [combustion cycles]*)
  END_VAR
  VAR_INPUT
        TdownWC : REAL; (*Weak combustion downwards integration time [combustion cycles]*)
  END_VAR
  VAR_INPUT
        KnockCountMeasAct : BOOL := FALSE; (*Knock countermeasures currently active [boolean]*)
  END_VAR
  VAR_INPUT
        SkipCylExt : BOOL := FALSE; (*External skip-fire command*)
  END_VAR
  VAR_INPUT
        WCContrEnable : BOOL := FALSE; (*Weak combustion control enabled [boolean]*)
  END_VAR
  VAR_OUTPUT
        FaultMFSign : BOOL := FALSE; (*Faulty misfire detection*)
  END_VAR
  VAR_OUTPUT
        MFB50Freeze : BOOL := FALSE; (*Command to freeze MFB50% controller*)
  END_VAR
  VAR_OUTPUT
        OptPIDFreeze : BOOL := FALSE; (*Command to freeze optimizer PIDs*)
  END_VAR
  VAR_OUTPUT
        PIDUROffsetCyl : REAL; (*PI duration offset for cylinder*)
  END_VAR
  VAR_OUTPUT
        PmaxStabLayOffset : REAL; (*Pmax stability layer offset [% Pmax]*)
  END_VAR
  VAR_OUTPUT
        PmaxLimReached : BOOL := FALSE; (*Pmax limit reached*)
  END_VAR
  VAR_OUTPUT
        SkipCyl : BOOL := FALSE; (*Cylinder to be skipped*)
  END_VAR
  VAR_OUTPUT
        PowRedCyl : REAL; (*Power reduction for cylinder*)
  END_VAR
  VAR_INPUT
        Pmax : REAL; (*Peak firing pressure average [bar]*)
  END_VAR
	VAR
		bur_HiContr_DWork : D_Work_HiContr;
	END_VAR
	VAR
		bur_HiContr_B : BlockIO_HiContr;
	END_VAR
END_FUNCTION_BLOCK