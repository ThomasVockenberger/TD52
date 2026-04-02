TYPE

END_TYPE
TYPE
BlockIO_MFB50Contr_Lib : STRUCT
	Divide : LREAL;
	LookupTableDynamic1 : LREAL;
	LookupTableDynamic2 : LREAL;
	p2sOut : LREAL;
	LookupTableDynamic1_m : LREAL;
	LookupTableDynamic : LREAL;
	Add1 : LREAL;
	T3HPout : LREAL;
	out : ARRAY[0..20] OF LREAL;
	up : ARRAY[0..20] OF LREAL;
	ui : ARRAY[0..20] OF LREAL;
	y_f : ARRAY[0..20] OF LREAL;
	y_median : LREAL;
	y_f_e : LREAL;
	DataTypeConversion : DINT;
	DataTypeConversion_o : DINT;
	LogicalOperator : BOOL;
END_STRUCT;
D_Work_MFB50Contr_Lib : STRUCT
	UnitDelay_DSTATE : LREAL;
	iState : ARRAY[0..20] OF LREAL;
	uState : ARRAY[0..20] OF LREAL;
	pState : ARRAY[0..20] OF LREAL;
	y_z : ARRAY[0..20] OF LREAL;
	y_f_z : ARRAY[0..20] OF LREAL;
	y_f_int : ARRAY[0..20] OF LREAL;
	y_z_l : LREAL;
	y_f_z_i : LREAL;
	Relay_Mode : BOOL;
	iState_not_empty : BOOL;
	uState_not_empty : BOOL;
	y_z_not_empty : BOOL;
	y_f_int_not_empty : BOOL;
	y_z_not_empty_p : BOOL;
END_STRUCT;
END_TYPE