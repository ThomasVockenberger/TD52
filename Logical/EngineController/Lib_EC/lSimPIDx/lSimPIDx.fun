FUNCTION_BLOCK fSimPIDx
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        P : REAL; (*Proportional Gain*)
  END_VAR
  VAR_INPUT
        I : REAL; (*Integral Gain*)
  END_VAR
  VAR_INPUT
        D : REAL; (*Differential Gain*)
  END_VAR
  VAR_INPUT
        N : REAL; (*Filter Coefficient*)
  END_VAR
  VAR_INPUT
        wxmax : LREAL; (*Maximum Input*)
  END_VAR
  VAR_INPUT
        wxmin : LREAL; (*Minimum Input*)
  END_VAR
  VAR_INPUT
        umax : REAL; (*Upper Output Saturation Level*)
  END_VAR
  VAR_INPUT
        umin : REAL; (*Lower Output Saturation Level*)
  END_VAR
  VAR_INPUT
        Kt : REAL; (*Tracking Gain*)
  END_VAR
  VAR_INPUT
        deadband : LREAL; (*Deadband*)
  END_VAR
  VAR_INPUT
        mode : USINT; (*Mode*)
  END_VAR
  VAR_INPUT
        u_man : REAL; (*Manual Value*)
  END_VAR
  VAR_INPUT
        a : REAL; (*Feedforward Value*)
  END_VAR
  VAR_INPUT
        invert : BOOL := FALSE; (*Invert*)
  END_VAR
  VAR_INPUT
        w : REAL; (*Reference Value*)
  END_VAR
  VAR_INPUT
        x : REAL; (*Actual Value*)
  END_VAR
  VAR_INPUT
        reset : BOOL := FALSE; (*Reset*)
  END_VAR
  VAR_INPUT
        I0 : REAL; (*I Integrator Reset*)
  END_VAR
  VAR_INPUT
        D0 : REAL; (*D Integrator Reset (Filter)*)
  END_VAR
  VAR_OUTPUT
        u : REAL; (*Controller Output*)
  END_VAR
  VAR_OUTPUT
        up : REAL; (*Proportional Output*)
  END_VAR
  VAR_OUTPUT
        ui : REAL; (*Integral Output*)
  END_VAR
  VAR_OUTPUT
        ud : REAL; (*Differential Output*)
  END_VAR
  VAR_OUTPUT
        u_tr : REAL; (*Tracking Output*)
  END_VAR
  VAR_INPUT
        e_int : REAL; (*external input for integral control*)
  END_VAR
  VAR_INPUT
        fbk_mode : USINT; (*Anti Windup Feedback Mode*)
  END_VAR
  VAR_INPUT
        u_fbk : REAL; (*External Anti Windup Feedback Value*)
  END_VAR
	VAR
		bur_BlockIO_SimPIDBR6 : BlockIO_SimPIDBR6;
	END_VAR
	VAR
		bur_D_Work_SimPIDBR6 : D_Work_SimPIDBR6;
	END_VAR
END_FUNCTION_BLOCK