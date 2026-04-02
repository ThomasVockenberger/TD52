 TYPE

END_TYPE
TYPE
	D_Work_Sim6CTR : STRUCT
		
		Integrator_DSTATE : REAL;
		Filter_DSTATE : REAL;
		UnitDelay_DSTATE : REAL;
		UnitDelay_DSTATE_e : REAL;
		UD_DSTATE : REAL;
		Delay_DSTATE : ARRAY[0..9] OF REAL;
		UnitDelay_DSTATE_n : REAL;
		Integrator_DSTATE_i : REAL;
		Filter_DSTATE_e : REAL;
		UnitDelay2_DSTATE : BOOL;
		is_active_c1_Sim6CTR : USINT;
		is_c1_Sim6CTR : USINT;
		is_Standard : USINT;
		is_LoadDrop : USINT;
	END_STRUCT;


	
	
	 BlockIO_Sim6CTR : STRUCT
		
		Input11 : REAL;
		Input1 : REAL;
		Input9 : REAL;
		Input3 : REAL;
		Input5 : REAL;
		Modeswitch : REAL;
		Input13 : REAL;
		Input12 : REAL;
		Switch : REAL;
		Diff : REAL;
		Input2 : REAL;
		Add1 : REAL;
		Input14 : REAL;
		Input6 : REAL;
		Input8 : REAL;
		Modeswitch_a : REAL;
		Input4 : REAL;
		Input7 : REAL;
		Control_State : INT;
		Input10 : BOOL;
		RelationalOperator1 : BOOL;
		Compare : BOOL;
		RelationalOperator : BOOL;
		Lock_TV : BOOL;
		bLoadDrop : BOOL;
		Open4CBP : BOOL;
	END_STRUCT;

END_TYPE