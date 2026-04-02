
TYPE
	trafficLight_typ : 	STRUCT 
		usP5xLightRed : UINT; (*Color of the traffic light*)
		usP5xLightYellow : UINT; (*Color of the traffic light*)
		usP5xLightGreen : UINT; (*Color of the traffic light*)
	END_STRUCT;
	Cylinder : 	STRUCT 
		Selection : UINT;
		Data : ARRAY[0..24]OF UINT;
		Cyl : ARRAY[0..24]OF CylVal;
	END_STRUCT;
	CylVal : 	STRUCT 
		Exh_Temp : INT;
		Spark_IP : INT;
		Spark_HV : INT;
		Knock_Int : INT;
		Knock_mV : INT;
		Valve_mV : INT;
		Press_bar : INT;
	END_STRUCT;
	bargraphScal_typ : 	STRUCT 
		scScalEndValue : ARRAY[0..1]OF SINT; (*Start of the right limit area*)
		scScalStartValue : ARRAY[0..1]OF SINT; (*End of the left limit area*)
		scScalMaxDatapoint : ARRAY[0..1]OF SINT; (*Maximum value of the scale area*)
		scScalMinDatapoint : ARRAY[0..1]OF SINT; (*Minimum value of the scale area*)
		scBarValue : SINT; (*Value of the bargraph*)
		tShowBar : showBarColor_typ; (*Structur to show the OK-Bar (green) or the ERROR-Bar (red)*)
	END_STRUCT;
	showBarColor_typ : 	STRUCT 
		ucStatusBarAct : USINT; (* Statusdatapoint for the GREEN Avg. Bar *)
		ucStatusBarMax : USINT; (* Statusdatapoint for the RED Limit Max Bar *)
		ucStatusBarMin : USINT; (* Statusdatapoint for the BLUE Limit Min Bar *)
	END_STRUCT;
	bargraphLeftRight_typ : 	STRUCT 
		ucBarLeft : USINT; (*Value of the left bargraph*)
		ucBarRight : USINT; (*Value of the right bargraph*)
		scLimitLeft : SINT; (* Limitvalue to the left side *)
		scLimitRight : SINT; (* Limitvalue to the right side *)
		tShowBar : showBarLeftRight_typ; (*Structur to show the OK-Bar (green) or the ERROR-Bar (red)*)
	END_STRUCT;
	showBarLeftRight_typ : 	STRUCT 
		ucStatusBarLeftAct : USINT; (* Statusdatapoint for the GREEN Avg. Bar *)
		ucStatusBarRightAct : USINT; (* Statusdatapoint for the GREEN Avg. Bar *)
		ucStatusBarMax : USINT; (* Statusdatapoint for the RED Limit Max Bar *)
		ucStatusBarMin : USINT; (* Statusdatapoint for the BLUE Limit Min Bar *)
	END_STRUCT;
END_TYPE
