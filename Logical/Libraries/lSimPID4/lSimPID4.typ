 TYPE

END_TYPE
TYPE
	D_Work_SimPID4 : STRUCT
		
		Integrator_DSTATE : REAL;
		Filter_DSTATE : REAL;
		Integrator_IC_LOADING : USINT;
		Filter_IC_LOADING : USINT;
	END_STRUCT;


	
	
	 BlockIO_SimPID4 : STRUCT
		
		Input10 : REAL;
		Input6 : REAL;
		Input4 : REAL;
		Input : REAL;
		Gain : REAL;
		Input2 : REAL;
		Integrator : REAL;
		Input3 : REAL;
		FilterCoefficient : REAL;
		Saturation : REAL;
		Modeswitch : REAL;
		Input8 : REAL;
		Input9 : USINT;
		Input7 : USINT;
		Input5 : BOOL;
		Input1 : BOOL;
	END_STRUCT;

END_TYPE