 TYPE

END_TYPE
TYPE
	D_Work_HiContr : STRUCT
		
		DiscreteTimeIntegrator_DSTATE : REAL;
		DiscreteTimeIntegrator_DSTATE_e : REAL;
		DiscreteTimeIntegrator_DSTATE_c : REAL;
		TappedDelaysetasN_cyc_X : ARRAY[0..99] OF REAL;
		DiscreteTimeIntegrator_DSTATE_n : REAL;
		DiscreteTimeIntegrator_PrevRese : SINT;
		DiscreteTimeIntegrator_PrevRe_f : SINT;
		DiscreteTimeIntegrator_PrevRe_c : SINT;
		DiscreteTimeIntegrator_PrevRe_n : SINT;
		Relay1_Mode : BOOL;
		Relay_Mode : BOOL;
	END_STRUCT;


	
	
	 BlockIO_HiContr : STRUCT
		
		Input17 : REAL;
		DiscreteTimeIntegrator : REAL;
		Input13 : REAL;
		Switch2 : REAL;
		Input11 : REAL;
		Input14 : REAL;
		DiscreteTimeIntegrator_d : REAL;
		Switch2_e : REAL;
		DiscreteTimeIntegrator_l : REAL;
		Input11_h : REAL;
		Input7 : REAL;
		Divide : REAL;
		Sqrt : REAL;
		Input8 : REAL;
		Input9 : REAL;
		Input10 : REAL;
		Switch2_k : REAL;
		Input19 : REAL;
		DiscreteTimeIntegrator_dl : REAL;
		Input16 : REAL;
		Input18 : REAL;
		Input21 : REAL;
		Input6 : REAL;
		GIPowGainPnom100cyclesevents : REAL;
		Input5 : REAL;
		Input4 : REAL;
		Input1 : REAL;
		Input12 : REAL;
		Input2 : REAL;
		Input20 : REAL;
		Input3 : REAL;
		Switch2_a : REAL;
		Switch4 : REAL;
		Input3_g : REAL;
		Input5_c : BOOL;
		Input9_a : BOOL;
		Input7_c : BOOL;
		Input10_h : BOOL;
		Input1_h : BOOL;
		Input20_o : BOOL;
		Input4_d : BOOL;
		Input2_g : BOOL;
		Input6_a : BOOL;
		Compare : BOOL;
		LogicalOperator13 : BOOL;
		Input12_e : BOOL;
		LogicalOperator2 : BOOL;
		Input8_f : BOOL;
		LogicalOperator7 : BOOL;
		LogicalOperator8 : BOOL;
	END_STRUCT;

END_TYPE