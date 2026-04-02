TYPE

END_TYPE
TYPE
BlockIO_LambdaAdp : STRUCT
	Input1 : REAL;
	Input2 : REAL;
	Input3 : REAL;
	DifferenceInputs2 : REAL;
	MinMax : REAL;
	Input4 : BOOL;
	RelationalOperator2 : BOOL;
	RelationalOperator : BOOL;
	RelationalOperator1 : BOOL;
	bLambda_Corr_Act : BOOL;
END_STRUCT;
D_Work_LambdaAdp : STRUCT
	DelayInput2_DSTATE : REAL;
	UnitDelay_DSTATE : REAL;
	is_active_c1_LambdaAdp : USINT;
	is_c1_LambdaAdp : USINT;
	MAX_MODE : BOOL;
END_STRUCT;
END_TYPE