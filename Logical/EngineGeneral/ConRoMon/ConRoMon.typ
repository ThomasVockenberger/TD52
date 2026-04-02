
TYPE
	_ConRodMon : 	STRUCT 
		Address : USINT;
		IndexLo : USINT;
		IndexHi : USINT;
		Cylinder : USINT;
		Data : INT;
		Unused : INT;
	END_STRUCT;
	_CBearing_Sig : 	STRUCT 
		Act : ARRAY[0..10]OF INT;
	END_STRUCT;
END_TYPE
