

TYPE
	LamCtrPBC_DBG_Bus :  STRUCT   
		e_lam :  REAL; (*lambda deviation between set and estimation ()*)  
		u :  REAL; (*lambda controller PBC offset output ()*)  
		u_lim :  REAL; (*lambda controller PBC offset output limited  ()*)  
		up_LamCtr :  REAL; (*proportional part of the lambda controller PBC output ()*)  
		ui_LamCtr :  REAL; (*integral part of the lambda controller PBC output ()*)  
		uAW_LamCtr :  REAL; (*anti windup of the lambda controller PBC ()*)  
		u_PT1_smith :  REAL; (*signal after PT1 from smith predictor ()*)  
		u_delay_smith :  REAL; (*signal after delay from smith predictor ()*)  
		fb_smith :  REAL; (*feedback from smith predictor ()*)  
	END_STRUCT;

	LamCtrPBC_IN_Bus :  STRUCT   
		rLam_Set :  REAL; (*set lambda from high level controller (-)*)  
		rLam_PBC :  REAL; (*lambda estimated from in-cylinder data (-)*)  
		bReset :  BOOL; (*reset input of the lambda controller (-)*)  
	END_STRUCT;

	LamCtrPBC_OUT_Bus :  STRUCT   
		rLam_ref :  REAL; (*lambda reference for port injection opening duration calculation ()*)  
	END_STRUCT;

	LamCtrPBC_PARA_Bus :  STRUCT   
		rKp_LamCtr :  REAL; (*proportional gain for lambda controller PBC ()*)  
		rKi_LamCtr :  REAL; (*integral gain for lambda controller PBC ()*)  
		rKAW_LamCtr :  REAL; (*anti windup gain for lambda controller PBC ()*)  
		rulim_LamCtr_up :  REAL; (*upper limit for lambda controller PBC output ()*)  
		rulim_LamCtr_low :  REAL; (*lower limit for lambda controller PBC ()*)  
	END_STRUCT;

	LamCtrPBC_PERM_Bus :  STRUCT   
		iTd_smith_LamCtr :  SINT; (*delay time for smith predictor model ()*)  
		rTi_smith_LamCtr :  REAL; (*filter time for smith predictor model ()*)  
	END_STRUCT;

END_TYPE

TYPE
BlockIO_LamCtrPBC : STRUCT
	BusConversion_InsertedFor_BusOu : LamCtrPBC_DBG_Bus;
	BusInput1 : LamCtrPBC_PARA_Bus;
	BusInput : LamCtrPBC_IN_Bus;
	BusInput2 : LamCtrPBC_PERM_Bus;
	BusConversion_InsertedFor_Bus_b : LamCtrPBC_OUT_Bus;
	UnitDelay : UDINT;
END_STRUCT;
D_Work_LamCtrPBC : STRUCT
	Delay1_DSTATE : REAL;
	DiscreteTimeIntegrator_DSTATE : REAL;
	Delay_DSTATE : ARRAY[0..49] OF REAL;
	DiscreteTimeIntegrator_DSTATE_n : REAL;
	UnitDelay_DSTATE : UDINT;
	DiscreteTimeIntegrator_PrevRese : SINT;
	DiscreteTimeIntegrator_PrevRe_m : SINT;
	icLoad : USINT;
	icLoad_o : USINT;
	DiscreteTimeIntegrator_IC_LOADI : USINT;
END_STRUCT;
PrevZCSigStates_LamCtrPBC : STRUCT
	Delay1_Reset_ZCE : USINT;
END_STRUCT;
ConstBlockIO_LamCtrPBC : STRUCT
	DataTypeConversion3 : UDINT;
	Conversion : REAL;
END_STRUCT;
ExternalInputs_LamCtrPBC : STRUCT
	In : LamCtrPBC_IN_Bus;
	Para : LamCtrPBC_PARA_Bus;
	Perm : LamCtrPBC_PERM_Bus;
END_STRUCT;
ExternalOutputs_LamCtrPBC : STRUCT
	Out : LamCtrPBC_OUT_Bus;
	dbg : LamCtrPBC_DBG_Bus;
END_STRUCT;
tag_RTM_LamCtrPBC : STRUCT
	errorStatus : REFERENCE TO USINT;
	blockIO : REFERENCE TO BlockIO_LamCtrPBC;
	prevZCSigState : REFERENCE TO PrevZCSigStates_LamCtrPBC;
	inputs : REFERENCE TO ExternalInputs_LamCtrPBC;
	outputs : REFERENCE TO ExternalOutputs_LamCtrPBC;
	dwork : REFERENCE TO D_Work_LamCtrPBC;
END_STRUCT;
RT_MODEL_LamCtrPBC : tag_RTM_LamCtrPBC;
END_TYPE
TYPE
END_TYPE