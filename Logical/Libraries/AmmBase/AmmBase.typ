
TYPE
	MM2AmmBase : 	STRUCT 
		bGnlTrip1 : BOOL;
		bGnlTrip2 : BOOL;
		bGnlTrip3 : BOOL;
		bTriptype1 : BOOL;
		bTriptype2 : BOOL;
		bTriptype3 : BOOL;
		bGnlWarning : BOOL;
		iMsg : ARRAY[0..9999]OF USINT;
	END_STRUCT;
	AmmBase2MM : 	STRUCT 
		bResetTrip : BOOL;
		bResetWarning : BOOL;
		bGnlTrip1 : BOOL;
		bGnlTrip2 : BOOL;
		bGnlTrip3 : BOOL;
		bGnlWarning : BOOL;
		bResetRiskClass0 : BOOL;
		bResetRiskClass1 : BOOL;
		bResetRiskClass2 : BOOL;
		bResetRiskClass3 : BOOL;
		bResetRiskClass4 : BOOL;
		iNumAlmTest : UDINT;
	END_STRUCT;
END_TYPE
