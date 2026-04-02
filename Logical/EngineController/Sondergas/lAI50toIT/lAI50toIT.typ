TYPE

END_TYPE
TYPE
BlockIO_AI50toIT_mdl : STRUCT
	Input16 : ARRAY[0..24] OF REAL;
	Input5 : REAL;
	Input8 : ARRAY[0..24] OF REAL;
	Input3 : ARRAY[0..24] OF REAL;
	Input4 : REAL;
	DiscreteTimeIntegrator : ARRAY[0..24] OF REAL;
	Product2 : ARRAY[0..24] OF REAL;
	Product1 : ARRAY[0..24] OF REAL;
	Integrator : ARRAY[0..24] OF REAL;
	Product4 : ARRAY[0..24] OF REAL;
	Switch2 : ARRAY[0..24] OF REAL;
	Modeswitch : ARRAY[0..24] OF REAL;
	Input1 : REAL;
	Input9 : ARRAY[0..24] OF REAL;
	Input2 : REAL;
END_STRUCT;
D_Work_AI50toIT_mdl : STRUCT
	DiscreteTimeIntegrator_DSTATE : ARRAY[0..24] OF REAL;
	Integrator_DSTATE : ARRAY[0..24] OF REAL;
	Filter_DSTATE : ARRAY[0..24] OF REAL;
	DiscreteTimeIntegrator_PrevRese : SINT;
END_STRUCT;
ExternalInputs_AI50toIT_mdl : STRUCT
	AI50act : ARRAY[0..24] OF REAL;
	AI50offset_knck : ARRAY[0..24] OF REAL;
END_STRUCT;
ExternalOutputs_AI50toIT_mdl : STRUCT
	IToffset : ARRAY[0..24] OF REAL;
	ITsat : ARRAY[0..24] OF REAL;
	AI50err : ARRAY[0..24] OF REAL;
END_STRUCT;
END_TYPE