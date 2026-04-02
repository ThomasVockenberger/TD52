(********************************************************************
 * COPYRIGHT -- INNIO Company, Zengerer
 ********************************************************************
 * Library: AnalogIn
 * File: AnalogIn.typ
 * Author: ZengereS
 * Created: December 04, 2007
*  V1.1 2010-06-20
 ********************************************************************
 * Data types of library AnalogIn
 ********************************************************************)

TYPE
	tAnaInPERMEM_typ : 	STRUCT 
		bEnable : BOOL; (*0 disables input function and all depending alarms*)
		ucInputType : USINT; (*can be set or will be default: temp. x10 °C, if not used*)
		ssScalMin : INT; (*min. engineering units at lower end of input range; not necessary for temp.*)
		ssScalMax : INT; (*min. engineering units at lower end of input range; not necessary for temp.*)
		usSetFilterValue : UINT; (*Optional signal filtering: 0=no Filter, 64000=max. input damping*)
		bOptSupervice : BOOL; (*Set to 1, if SIGNAL ERROR or MINMIN or MAXMAX will trigger ALARM (PRIO3)*)
		ssSetPointMAXMAX : INT; (*Optional limit value (for warning+ possible alarm shutdown)*)
		ssSetPointMax : INT; (*Optional limit value (for warning message)*)
		ssSetPointOptiMax : INT; (*Optional limit value*)
		ssSetPointOpti : INT; (*Optional limit value*)
		ssSetPointOptiMin : INT; (*Optional limit value*)
		ssSetPointMin : INT; (*Optional limit value (for warning message)*)
		ssSetPointMINMIN : INT; (*Optional limit value (for warning+ possible alarm shutdown)*)
		tiSetMaxMaxTime : TIME; (*Optional Delay time for Max and MAXMAX Alarms*)
		tiSetMinMinTime : TIME; (*Optional Delay time for Min and MINMIN Alarms*)
		scNrOfDecimal : SINT; (*No of digits after decimal point on display or real output*)
		szHardware : STRING[16]; (*Optional Text for Visualisation*)
		szChannelName : STRING[32]; (*Optional Text for Visualisation*)
		szUnit : STRING[6]; (*Optional Text for Visualisation*)
		ucOptionBits : USINT; (*Message enabling bitfield: 0=all imit messages are disabeled*)
		ssManualValue : INT; (*Optional used Value for manual override(255) or add to channelvalue (254)...*)
		usANDLinkNum : UINT; (*Cannel Number to add value (or 255 for manual override)*)
	END_STRUCT;
	tAnaInHelper_typ : 	STRUCT 
		ucStatus : USINT; (*outputs 0,if input is enabled and 1 to hide disabled inputs*)
		ucStatus0Digits : USINT; (*outputs 0, if no digit after decimal point is selected*)
		ucStatus1Digits : USINT; (*outputs 0, if 1 digit after decimal point is selected*)
		ucStatus2Digits : USINT; (*outputs 0, if 2 digits after decimal point is selected*)
		ucStatus3Digits : USINT; (*outputs 0, if 3 digit after decimal point is selected*)
		ucStatus4Digits : USINT; (*outputs 0, if 4 digit after decimal point is selected*)
	END_STRUCT;
	tAnaInErrors_typ : 	STRUCT 
		bErrMAXMAX : BOOL; (*status: value is above MaxMax level*)
		bErrOptiMax : BOOL; (*status: value is above OptiMax level*)
		bErrMax : BOOL; (*status: value is above Max level*)
		bErrOptiMin : BOOL; (*status: value is below OptiMin level*)
		bErrMin : BOOL; (*status: value is below Min level*)
		bErrMINMIN : BOOL; (*status: value is below MinMin level*)
		bErrSignal : BOOL; (*digital error output (Signal Error or MAXMAX/MINMIN exceedet)*)
	END_STRUCT;
END_TYPE
