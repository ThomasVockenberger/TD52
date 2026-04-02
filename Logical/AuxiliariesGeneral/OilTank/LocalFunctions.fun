
FUNCTION_BLOCK OilTank_Obj
	VAR_INPUT
		Type : {REDUND_UNREPLICABLE} INT; (* Tank type configuration *)
		Length : {REDUND_UNREPLICABLE} REAL; (*[m]*)
		WidthOrDiameter : {REDUND_UNREPLICABLE} REAL; (*[m]*)
		Height : {REDUND_UNREPLICABLE} REAL; (*[m]*)
		Sensor_level : {REDUND_UNREPLICABLE} REAL; (*[m]*)
		tVolumeTable : ARRAY[0..iVolTableArray_MAX] OF lcrCurveByPoints_TabEntry_type; (* Volume Table: [mm] vs. [Liter]*)
		iTablePoints : USINT;
		rV_MAX : REAL; (*[Liter]*)
	END_VAR
	VAR_OUTPUT
		Volume_Total_Liter : REAL; (*[Liter]*)
		Level_Act_height : REAL; (*[m]*)
		Volume_Act_Liter : REAL; (*[Liter]*)
		Volume_Act_pu : REAL; (*[pu]*)
	END_VAR
	VAR
		Radius : {REDUND_UNREPLICABLE} REAL := 0.0; (*[m]*)
		xTable : LCRCurveByPoints; (* *)
	END_VAR
END_FUNCTION_BLOCK
