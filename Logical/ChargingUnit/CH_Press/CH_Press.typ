
TYPE
	Pr_Ch : 	STRUCT  (*Charge pressure*)
		Value : REAL; (*Charge pressure analog input value*)
		Tag : STRING[80]; (*Charge pressure P&ID tag*)
		GoodQual : BOOL; (*Charge pressure signal good quality*)
		ParaExist : BOOL; (*Charge pressure parameter active*)
	END_STRUCT;
END_TYPE
