TYPE

END_TYPE
TYPE
BlockIO_SimPIDBR6 : STRUCT
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
	Input11 : REAL;
	Input8 : REAL;
	Input9 : USINT;
	Input7 : USINT;
	Input5 : BOOL;
	Input1 : BOOL;
END_STRUCT;
D_Work_SimPIDBR6 : STRUCT
	Integrator_DSTATE : REAL;
	Filter_DSTATE : REAL;
	Integrator_IC_LOADING : USINT;
	Filter_IC_LOADING : USINT;
END_STRUCT;
END_TYPE