FUNCTION_BLOCK HiGlob
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        SkipToPowRedGain : REAL; (*Gain for skipped cylinders leading to power reduction [%Pnom/%skippedcylinder], default = 1*)
  END_VAR
  VAR_INPUT
        KPredPmaxLim : REAL; (*Gain for gobal power reduction depending on Pmax limitation [%Pnom/events*100cycles], default = 0.1*)
  END_VAR
  VAR_INPUT
        KITPmaxLim : REAL; (*Gain for global IT retardment depending on Pmax limitation [CAD/events*100cycles], default = 0.01*)
  END_VAR
  VAR_INPUT
        ZcylEng : INT; (*Number of engine cylinders, default = 20*)
  END_VAR
  VAR_INPUT
        NCylPmaxTh : INT; (*Threshold for number of cylinders being in Pmax limits before power reduction, default = 10*)
  END_VAR
  VAR_INPUT
        EngStopErrAck : BOOL := FALSE; (*Engine has stopped and errors were acknowledged on Diane*)
  END_VAR
  VAR_INPUT
        PmaxLimPowTh : REAL; (*Threshold for Pmax limitation integrator before power reduction [events/100cycles], default = 500*)
  END_VAR
  VAR_INPUT
        PmaxLimContrEn : BOOL := FALSE; (*Pmax limit control is enabled*)
  END_VAR
  VAR_INPUT
        TdownPmax : REAL; (*Integrator emptying time constant [s], default = 100*)
  END_VAR
  VAR_INPUT
        TupPmax : REAL; (*Integrator filling time constant for ignition retardment in case of Pmax limits reached, default = 1*)
  END_VAR
  VAR_INPUT
        ITPmaxLimMax : REAL; (*Max IT retardment in case of Pmax limitation [CAD], default = 5*)
  END_VAR
  VAR_INPUT
        PmaxLimReachGlob : INT; (*Number of cylinders were Pmax limit was reached*)
  END_VAR
  VAR_INPUT
        PredPmaxLimMax : REAL; (*Max power reduction in case of Pmax limitation [% of Pnom], below engine shut down, default = 50*)
  END_VAR
  VAR_INPUT
        SkipCylNr : INT; (*Number of cylinders being skipped*)
  END_VAR
  VAR_OUTPUT
        SkipCountOut : REAL; (*Skip counter output []*)
  END_VAR
  VAR_INPUT
        SkipRefRedLimMax : REAL; (*Maximum value for power reference reduction due to skip fired cylinders [%Pnom], default = 100*)
  END_VAR
  VAR_INPUT
        MaxCylSkipBefPowRed : REAL; (*Maximum percentage of skipped cylinders before power reduction starts, default = 10*)
  END_VAR
  VAR_INPUT
        MaxSkipDurBefRefRed : REAL; (*Maximum duration with skip-fired cylinders until power reduction [cycles], default = 1e4*)
  END_VAR
  VAR_INPUT
        SkipCountLimMax : REAL; (*Maximum value of skip counter [cycles], default = 1e5, must be always higher than MaxSkipDurBefRefRed*)
  END_VAR
  VAR_INPUT
        SkipRefRedLimMin : REAL; (*Minimum value for power reference reduction due to skip fired cylinders [%Pnom], default = 50*)
  END_VAR
  VAR_OUTPUT
        RefPowUpLim : REAL; (*Upper limit of reference power set in Diane [% Pnom]*)
  END_VAR
  VAR_INPUT
        PowRedCylMax : REAL; (*Maximum power reduction from all cylinders*)
  END_VAR
  VAR_INPUT
        MaxSkipDurBefStop : REAL; (*Maximum duration for overall steady skip-fired operation and reduced ref power limit until engine shut down [s], default = 1e6*)
  END_VAR
  VAR_INPUT
        SkipOvCountLimMax : REAL; (*Maximum value of overall skip-fire counter*)
  END_VAR
  VAR_INPUT
        MaxCylSkipBefStop : REAL; (*Maximum percentage of skipped cylinders before engine shut down, default = 50*)
  END_VAR
  VAR_OUTPUT
        EngShutDwn : BOOL := FALSE; (*Engine shut down command Prio 2 []*)
  END_VAR
  VAR_OUTPUT
        PowRefRedFin : REAL; (*Final global power reduction from hierarchic control [% Pnom]*)
  END_VAR
  VAR_OUTPUT
        ITGlobOffsetPmax : REAL; (*Global ignition timing retardment from Pmax controll [CAD]*)
  END_VAR
  VAR_OUTPUT
        PowRefRedGlob : REAL; (*Global power reduction from hierarchic control [% Pnom]*)
  END_VAR
  VAR_OUTPUT
        LEANOXCor : REAL; (*LEANOX correction factor due to skipfire []*)
  END_VAR
  VAR_INPUT
        TSkipCount : REAL; (*Should be 1*)
  END_VAR
  VAR_INPUT
        TSkipCount1 : REAL; (*Should be 1*)
  END_VAR
	VAR
		bur_HiGlob_DWork : D_Work_HiGlob;
	END_VAR
	VAR
		bur_HiGlob_B : BlockIO_HiGlob;
	END_VAR
END_FUNCTION_BLOCK