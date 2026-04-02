(********************************************************************
 * COPYRIGHT -- INNIO Company, Zengerer
 ********************************************************************
 * Library: AnalogIn
 * File: AnalogIn.typ
 * Author: ZengereS
 * Created: December 04, 2007
 ********************************************************************
 * Data types of library AnalogIn
 ********************************************************************)

TYPE
	tDigInPERMEM_typ : 	STRUCT 
		bEnable : BOOL; (*0 disables channel function and all depending alarms*)
		szChannelName : STRING[32]; (*Optional Text for Visualisation*)
		szHardware : STRING[16]; (*Optional Text for Visualisation (Input or Output Hardwarename)*)
		ucInputType : USINT; (*can be set or will be default: 0=only with visu parameter on/off, 1=OR hardware input, 2=OR ....*)
		bManualOn : BOOL; (*TRUE= set output TRUE (with TON and messages as configured), 0=output depending on ucInputType*)
		bManualBlock : BOOL; (*TRUE= set output FALSE (with TOF and messages as configured), 0= output depending on ucInputType*)
		usORLinkNum : UINT; (*Optional link channel source number for OR- logic*)
		usANDLinkNum : UINT; (*Optional digital link channel source number for AND logic*)
		ulSetTONTime : UDINT; (*Optional TON Delay time*)
		ulSetTOFTime : UDINT; (*Optional TOF Delay time*)
		ucButtonLevel : USINT; (*minimum user level required for button/ channel actions*)
		ucOptionBits : USINT; (*Optional enabling bits: 1=OnWarn, 2=OnAlarm, 4=OffWarn, 8=OffAlarm, 16=CounterLimitWarn*)
		ulCounterLimit : UDINT; (*Optional Eventcounter Limit; !Enable bOptAlarmOn or WarnOn to use!*)
		ulCounter : UDINT; (*Optional Eventcounter Limit; !Enable bOptAlarmOn or WarnOn to use!*)
	END_STRUCT;
	tDigIn_SG3helper_typ : 	STRUCT 
		ucStatus : USINT; (*True/ False... State for TextAdvanced*)
		usSetState : USINT; (*True/ False... State for TextAdvanced INPUT*)
		usHideButtonOn : USINT; (*Visibility of Button: 1=hide*)
		usHideButtonOff : USINT; (*Visibility of Button: 1=hide*)
	END_STRUCT;
	tDigInErrors_typ : 	STRUCT 
		bErrOnAlarm : BOOL; (*status: value is on*)
		bErrOnWarn : BOOL; (*status: value is above Max level*)
		bErrOffWarn : BOOL; (*status: value is off*)
		bErrOffAlarm : BOOL; (*status: value is below MinMin level*)
		bOnMessage : BOOL;
		bOffMessage : BOOL;
	END_STRUCT;
END_TYPE

(*Insert your comment here.*)
(*Insert your comment here.*)
