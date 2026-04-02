TYPE
	D_Work_Sim3pCTR : STRUCT
		
		UnitDelay_DSTATE : REAL;
		is_active_c1_Sim3pCTR : USINT;
		is_c1_Sim3pCTR : USINT;
		is_enabled : USINT;
		is_manual_ramp : USINT;
		is_normal : USINT;
		is_inverse : USINT;
	END_STRUCT;


	
	
	 BlockIO_Sim3pCTR : STRUCT
		
		Input9 : REAL;
		Input1 : REAL;
		Input2 : REAL;
		Input3 : REAL;
		Input4 : REAL;
		Input5 : REAL;
		Input6 : REAL;
		Input8 : REAL;
		Input10 : REAL;
		Input11 : REAL;
		Switch2 : REAL;
		state : INT;
		Input : BOOL;
		Input7 : BOOL;
		Input14 : BOOL;
		Input12 : BOOL;
		Input13 : BOOL;
		RelationalOperator : BOOL;
		RelationalOperator1 : BOOL;
	END_STRUCT;

END_TYPE