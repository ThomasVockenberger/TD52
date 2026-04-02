(********************************************************************
 * COPYRIGHT -- INNIO Company, Zengerer
 ********************************************************************
 * Library: AnalogIn
 * File: AnalogIn.st
 * Author: ZengereS
 * Created: December 04, 2007
 ********************************************************************
 *
 * Description of library AnalogIn:
 ********************************************************************
 *  Function depending on ucInputType:
 *  ---------------------------------
 * 		 0=AI_NO_SCALING: 		(Temperature) Inputs  NO SCALING, NO CLAMPING (PT100 or Thermocouples on ATxx- Units, read in 1/10°C)
 *
 * 	THESE INPUT TYPES ARE CLAMPED: (ssScalMin < ssOut < ssScalMax)
 * 		 1=AI_FixedFactor10:	Temperature inputs (PT100, KTY..... WITH FIXED x10 SCALING TO 1°C; CLAMPED 
 *		 2=AI_MA_INPUT:			+-20mA input (-32768 to 32767Digits) scaled to ScalMin-ScalMax; CLAMPED
 *		 3=AI_0-20MA_INPUT:		0-20mA input (0-32767Digits) scaled to ScalMin-ScalMax; CLAMPED
 *		 4=AI_4_20MA_INPUT:		4-20mA input (6554-32767Digits) scaled to ScalMin-ScalMax; CLAMPED
  *		 5=AI_0_5V_INPUT:		0-5V input (0-16364Digits) scaled to ScalMin-ScalMax; CLAMPED		(NEW)	
 * 		 9=AI_NO_SCALING, CLAMPED: (Temperature) Inputs  NO SCALING (PT100 or Thermocouples on ATxx- Units, read in 1/10°C) ; CLAMPED BETWEEN ScalMin and ScalMax
 *
 *	THESE INPUT TYPES ARE ALLSO AVAILABLE WITHOUT CLAMPING: (ssScalMin <> ssOut <> ssScalMax)
 * 		11=AI_FixedFactor10:	NO CLAMPING Temperature inputs (PT100, KTY..... WITH FIXED x10 SCALING TO 1°C (usage not recommendet)
 *		12=AI_MA_INPUT:			NO CLAMPING +-20mA input (-32768 to 32767Digits) scaled to ScalMin-ScalMax    (usage not recommendet))
 *		13=AI_0-20MA_INPUT:		NO CLAMPING 0-20mA input (0-32767Digits) scaled to ScalMin-ScalMax
 *		14=AI_4_20MA_INPUT:		NO CLAMPING 4-20mA input (6554-32767Digits) scaled to ScalMin-ScalMax
 *		15=AI_0_5V_INPUT:		0-5V input (0-16364Digits) scaled to ScalMin-ScalMax	
 *
 *	!scNrOfDecimal WORKS AS MULTIPLIER FOR THE SCALED VALUE BY SHIFTING THE DECIMAL POINT!
 *
 *	DEFINE OUTPUT CHANNELS WITH THESE TYPE CODES: (same sScalMin and ssScalMax are applied to Output signal) (NEESDS EXTERNAL CODE PARTS!)
 * 		11=AI_0-20MA_INPUT:		0-20mA output (0-32767Digits) scaled from channel signal ScalMin-ScalMax (input behavior typ 0, if HW input stays connected!)
 *		24=AI_4_20MA_OUTPUT:	4-20mA output (6554-32767Digits) scaled from channel signal ScalMin-ScalMax (input behavior typ 0, if HW in connected!)
 *
 *
 *  SPECIAL CODES FOR 'usANDLinkNum' (Numbers 1 to 250 are reserved for the channel numbers to add another channel value)
 *		 253=RawManualValue:		Enter MANUAL RAW VALUE in ssManualValue for overriding input
 *		 254=AddManualValue:		Enter MANUAL ADD VALUE in ssManualValue as addition summand to the scaled output 
 *		 255=UseManualValue:		Enter MANUAL OVERRIDE VALUE in ssManualValue for direct output
 *
 *	Limit activation with ucOtionBits:
 *  	bErrOptiMin	:= activation with ucOptionBits = 1 
 *		bErrOptiMax := activation with ucOptionBits = 2
 *		bErrMin		:= activation with ucOptionBits = 4
 *		bErrMax		:= activation with ucOptionBits = 8
 *		bErrMINMIN	:= activation with ucOptionBits = 16
 *		bErrMAXMAX	:= activation with ucOptionBits = 32
 
 *  	bErrSignal	:= DEactivation with ucOptionBits = 64   (MEASUREMENT SIGNAL DETECTION-> ALARM)
 *
 ********************************************************************
 *  History:
 *  --------
 *	2008-09-10  V0.20	Zengerer	added scaling calculations
 *	2008-09-11  V0.21	Zengerer	added Helper Structure for old SG3- visu
 *	2008-09-30  V0.22	Zengerer	added texts and color changing
 *	2008-09-30  V0.23	Zengerer	added Input Types 10-14 for unclamped values wihout limitation between Min/Max scaling
 *	2008-10-22  V0.30	Zengerer	CHANGED CONFIGTYPE: scNrOfDecimal instead of ucNrOfDecimal
 *	2009-05-22	V0.40	Zengerer	Limit activation with OtionBits masking
 *	2009-06-22	V0.42	Zengerer	Limit OptionBits update
 *  2010-06-04  V0.50	Zengerer	NAMETEXT expanded to 32 CHARACTERS; ssManualValue and usANDLinkNum new introduced in datatype 
  *	2009-11-25	V0.50	Zengerer	0-5V Inputtype added
 *	2010-06-22	V0.51	Zengerer	predefined system value in 'usANDLinkNum' removed here, externaly realised
 *	2010-06-22	V0.52	Zengerer	additional infotext for output types (output handling externaly realised)
 *	2010-06-22	V0.60	Zengerer	Manual override of RAW value! with linkCode 253
 *	2013-10-31	V0.70	Zengerer	FILTER type as local implemented function to cancel dependency on JEW_LIB1 
 *  2013-11-11  V0.71	Zengerer	Filter function reverted-  has to stay in task 
*
* LEGACY CODE- DO NOT USE IN NEW IMPLEMENTATIONS!
*
 ********************************************************************)

FUNCTION_BLOCK ana_in		(*Analogeingang oder Temperatureingang*)
	
	
	IF tAnaInPERMEM.bEnable THEN					(*1=enable input*)
		(*get InputType from parameterstructure: types 1-9 are clamped to min/max EU, types 11-19 are proceedet like 1-9, but without clamping*)
		IF tAnaInPERMEM.ucInputType >9 AND tAnaInPERMEM.ucInputType <19 THEN
			ucInputType	:= tAnaInPERMEM.ucInputType -10;					(*Internal use: input type only from 0-8*)
		ELSE
			ucInputType	:= tAnaInPERMEM.ucInputType ;						(*Internal use: input type only from 0-8*)
			IF tAnaInPERMEM.ucInputType = 9 THEN ucInputType := 0; END_IF	(*Internal use: input type only from 0-8*)
		END_IF

	
		(*Statustext output*)
		CASE ucInputType OF
			0:		(*AI_NO_SCALING '1234567890123456'*)
					szOutState	:= 	'UnscaledIn(Temp)';				
	 		1:		(*AI_AI_FixedFactor10     *)
					szOutState	:= 	'Temp.Input X°C';			
			2:		(*AI_-10+10V_INPUT*)
					szOutState	:= 	'+-10V Input OK';				
			3:		(*AI_0-20MA_INPUT*)
					szOutState	:= 	'0-20mA OK';
			4:		(*AI_4_20MA_INPUT*)
					szOutState	:= 	'4-20mA OK';
			5:		(*AI_0_5V_INPUT*)
					szOutState	:= 	'+5V Input';
			9:		(*AI_NO_SCALING '1234567890123456'*)
					szOutState	:= 	'Unscaled Clamped';	
	 		11:		(*AI_AI_FixedFactor10     *)
					szOutState	:= 	'Temp.Inp.NoClamp';			
			12:		(*AI_-10+10V_INPUT*)
					szOutState	:= 	'+-10V In.NoClamp';				
			13:		(*AI_0-20MA_INPUT*)
					szOutState	:= 	'0-20mA NoClamp';
			14:		(*AI_4_20MA_INPUT*)
					szOutState	:= 	'4-20mA NoClamp';	
			15:		(*AI_0_5V_INPUT*)
					szOutState	:= 	'+5V Inp. NoClamp';	
			23:		(*AI_0-20MA_OUTPUT*)
					szOutState	:= 	'0-20mA OUTPUT OK';
			24:		(*AI_4-20MA_OUTPUT*)
					szOutState	:= 	'4-20mA OUTPUT OK';																						
		ELSE		(*CASE_ELSE*)
					szOutState	:= 	'NoTypeInfo'; 
		END_CASE

		
		(*Manual override of RAW value! with linkCode 253 (watch external code allso!*)
		IF tAnaInPERMEM.usANDLinkNum =253 THEN	
			ssIn := tAnaInPERMEM.ssManualValue;   
		 	szOutState	:= 	'MANUAL RAW VALUE'; 
		END_IF	


		(*SIGNAL FAILURE DETECTION*)
		CASE ucInputType OF
			0:		(*AI_NO_SCALING:  (Temperature inputs PT100, Termocouples == 1/10°C from ATxx Units WITHOUT SCALING *)
				tAna_inErrors.bErrSignal := (ssIn < LIM_PT100_MIN OR ssIn > LIM_PT100_MAX);			
			1:		(*AI_AI_FixedFactor10:  (temperature) inputs WITH x10 SCALING to convert to 1°C*)
				tAna_inErrors.bErrSignal := ((ssIn/10) < LIM_PT100_MIN OR (ssIn/10) > LIM_PT100_MAX);			
		    2:		(*AI_-10+10V_INPUT*)
				tAna_inErrors.bErrSignal := FALSE;   (*NO SIGNAL CHECK!*)  (* (ssIn < LIM_MA_MIN) *OR ssIn > LIM_MA_MAX); *)
			3:		(*AI_0_20MA_INPUT*)
				tAna_inErrors.bErrSignal := (ssIn < LIM_0_20MA_MIN); (*OR ssIn > LIM_0_20MA_MAX);*)			
			4:		(*AI_4_20MA_INPUT*)
				tAna_inErrors.bErrSignal := (ssIn < LIM_4_20MA_MIN); (*OR ssIn > LIM_4_20MA_MAX);*)
			5:		(*AI_0_5V_INPUT*)
				tAna_inErrors.bErrSignal := (ssIn < LIM_0_5V_MIN OR ssIn > LIM_0_5V_MAX);	
			9:		(*AI_NO_SCALING, clamped*)
				tAna_inErrors.bErrSignal := (ssIn < LIM_PT100_MIN OR ssIn > LIM_PT100_MAX);								
		ELSE		(*CASE_ELSE*)
				tAna_inErrors.bErrSignal := FALSE;
				
		END_CASE	

	
		(*INPUT SIGNAL FILTER*)
		FILTER_0(In := ssIn, Filter := UINT_TO_USINT(tAnaInPERMEM.usSetFilterValue) );			(*FILTER type local implementedr function to cancel dependency on JEW_LIB1 *)

		IF tAna_inErrors.bErrSignal  THEN
			ssInFiltered := DINT_TO_INT(FILTER_0.Out);
		ELSE
			ssInFiltered := ssIn;		(*unfiltered, to shorten reaction time on signal newstart *)
		END_IF


		(*INPUT SCALING*)	
		CASE ucInputType OF
			0:		(*AI_PT100_NO_SCALING*)	
					slOutScaled		:= 	INT_TO_DINT( ssInFiltered );			
	 		1:		(*AI_AI_FixedFactor10*)
					slOutScaled		:= 	INT_TO_DINT( ssInFiltered ) / 10 ;
			2:		(*AI_-10+10V_INPUT*)
					slOutScaled		:=  (INT_TO_DINT(ssInFiltered) + 32768 ) * (tAnaInPERMEM.ssScalMax - tAnaInPERMEM.ssScalMin) / (32767*2) + tAnaInPERMEM.ssScalMin ;
			3:		(*AI_0-20MA_INPUT*)
					slOutScaled		:= 	(INT_TO_DINT(ssInFiltered)         ) * (tAnaInPERMEM.ssScalMax - tAnaInPERMEM.ssScalMin) / 32768 + tAnaInPERMEM.ssScalMin ;
			4:		(*AI_4_20MA_INPUT*)
					slOutScaled		:=  (INT_TO_DINT(ssInFiltered) - 6554  ) * (tAnaInPERMEM.ssScalMax - tAnaInPERMEM.ssScalMin) / (32768-6554) + tAnaInPERMEM.ssScalMin ;
			5:		(*AI_0_5V_INPUT*)
					slOutScaled		:= 	(INT_TO_DINT(ssInFiltered)         ) * (tAnaInPERMEM.ssScalMax - tAnaInPERMEM.ssScalMin) / 16383 + tAnaInPERMEM.ssScalMin ;			(*scaling 100% = only 50% of electrical max+ to use a +-10V input*)				
			9:		(*AI_PT100_NO_SCALING, clamped*)	
					slOutScaled		:= 	INT_TO_DINT( ssInFiltered );					
		ELSE		(*CASE_ELSE*)
					slOutScaled		:= 	0;
		END_CASE

		(*INPUT CLAMPING on Min-Max scaling parameters*)	
		IF tAnaInPERMEM.ucInputType > 0 AND tAnaInPERMEM.ucInputType < 10 THEN	(*all input types with codenumber 1-9 get their output values clamped*)
			IF slOutScaled < tAnaInPERMEM.ssScalMin	THEN slOutScaled := tAnaInPERMEM.ssScalMin;	END_IF
			IF slOutScaled > tAnaInPERMEM.ssScalMax	THEN slOutScaled := tAnaInPERMEM.ssScalMax;	END_IF   
		END_IF


		(*OPTION: Calculate combined value of this and another channel*)
		IF tAnaInPERMEM.usANDLinkNum > 0 AND tAnaInPERMEM.usANDLinkNum < 251 THEN
  			(*tAnaInPERMEM.usANDLinkNum; *)  					  	(*!!!	EXTERN realisiert   !!!*)
		 	szOutState	:= 	'Channel x Val.ad'; 		
		END_IF		
		
		(*Add manual value optional with linkCode 254 *)
		IF tAnaInPERMEM.usANDLinkNum =254 THEN	
			slOutScaled := slOutScaled + tAnaInPERMEM.ssManualValue;   
		 	szOutState	:= 	'Manualvalue add.'; 				
		END_IF
		(*Manual override! with linkCode 255*)
		IF tAnaInPERMEM.usANDLinkNum =255 THEN	
			slOutScaled := tAnaInPERMEM.ssManualValue;   
		 	szOutState	:= 	'Manual Override'; 
		END_IF	



		(*INPUT CLAMPING ONCE MORE FOR ADDED VALUES*)	
		IF tAnaInPERMEM.ucInputType > 0 AND tAnaInPERMEM.ucInputType < 10 THEN	(*all input types with codenumber 1-9 get their output values clamped*)
			IF slOutScaled < tAnaInPERMEM.ssScalMin	THEN slOutScaled := tAnaInPERMEM.ssScalMin;	END_IF
			IF slOutScaled > tAnaInPERMEM.ssScalMax	THEN slOutScaled := tAnaInPERMEM.ssScalMax;	END_IF   
		END_IF

	


		(*OUTPUT TO INTEGER Variable*)
		ssOut 	:= DINT_TO_INT( slOutScaled );
		IF slOutScaled < -32768		THEN ssOut := -32768;	END_IF		(* (just to be sure...) *)
		IF slOutScaled > 32767		THEN ssOut := 32767; 	END_IF   	(* (just to be sure...) *)
			
		(*		ssOutMod 	:= MOD(ssInFiltered,10);   ALT *)
		
	
		(*LIMITS*)		
		(*Limit activation with OtionBits masking:  NOT AND=0 (XOR) *)
			tAna_inErrors.bErrOptiMin	:= 	(NOT( (tAnaInPERMEM.ucOptionBits AND 1) =0) ) 		AND (ssOut < tAnaInPERMEM.ssSetPointOptiMin);
  			tAna_inErrors.bErrMin		:= 	(NOT( (tAnaInPERMEM.ucOptionBits AND 4) =0) )		AND (ssOut < tAnaInPERMEM.ssSetPointMin);
  			tAna_inErrors.bErrMINMIN	:= 	(NOT( (tAnaInPERMEM.ucOptionBits AND 16)=0) )		AND (ssOut < tAnaInPERMEM.ssSetPointMINMIN);
			tAna_inErrors.bErrOptiMax	:= 	(NOT( (tAnaInPERMEM.ucOptionBits AND 2) =0) )		AND (ssOut > tAnaInPERMEM.ssSetPointOptiMax);
			tAna_inErrors.bErrMax		:= 	(NOT( (tAnaInPERMEM.ucOptionBits AND 8) =0) )		AND (ssOut > tAnaInPERMEM.ssSetPointMax);
			tAna_inErrors.bErrMAXMAX	:= 	(NOT( (tAnaInPERMEM.ucOptionBits AND 32)=0) )		AND (ssOut > tAnaInPERMEM.ssSetPointMAXMAX);


			(*Statustext Messages for Limits    				'12345678901234'   *)
			IF tAna_inErrors.bErrOptiMin		THEN szOutState	:= 	'<OptiMin exc. '; 	END_IF				
			IF tAna_inErrors.bErrMin 			THEN szOutState	:= 	'<Min Limit    '; 	END_IF
			IF tAna_inErrors.bErrMINMIN 		THEN szOutState	:= 	'<MINMIN Limit!'; 	END_IF
			IF tAna_inErrors.bErrOptiMax		THEN szOutState	:= 	'>OptiMax exc. '; 	END_IF			
			IF tAna_inErrors.bErrMax 			THEN szOutState	:= 	'>Max Limit    '; 	END_IF
			IF tAna_inErrors.bErrMAXMAX 		THEN szOutState	:= 	'>MAXMAX Limit!'; 	END_IF

		
		(*Check limit values valid?*)
		(*	IF 	tAnaInPERMEM.bOptSupervice AND*)
   			IF	(NOT( (tAnaInPERMEM.ucOptionBits AND 8)=1 ))	AND			(*Optionsbit für ErrMINMIN ausmaskieren*)
				(NOT( (tAnaInPERMEM.ucOptionBits AND 64)=1 ))	AND			(*Optionsbit für ErrMAXMAX ausmaskieren*)
   				(tAnaInPERMEM.ssSetPointMINMIN = 0) AND
   				(tAnaInPERMEM.ssSetPointMAXMAX <= tAnaInPERMEM.ssSetPointMINMIN) 
			THEN
				tAna_inErrors.bErrMINMIN	:= FALSE;
				tAna_inErrors.bErrMAXMAX	:= FALSE;
				szOutState	:= 	'LimitsNotValid';
			END_IF
				

		IF tAna_inErrors.bErrSignal  THEN	szOutState	:= 	'OutOfRange'; END_IF


		(*failed signal check sets output to 'errorvalue' *)
		IF tAna_inErrors.bErrSignal AND NOT (tAnaInPERMEM.usANDLinkNum =255) THEN
			ssOut		:= -9999;
(*			ssOutModulo	:= -9999; 	*)
		END_IF
		IF tAnaInPERMEM.usANDLinkNum =255 THEN	szOutState	:= 	'Manual Override!'; 	END_IF 	(*this messagetext has priotity and overrides the one before!*)
	
		(*Quittierung...*)
			bInQuit;
		(* 	bOutErr		:= FALSE;
		(*FEHLT NOCH!!!*)
	
	
		(*Config Mode*)
		(*FEHLT NOCH!!!*)
		(*bConfigModeActive;*)

	ELSE						(* else to .bEnable: 0=disables all input functions*)
		ssOut		:= 0;
		ssOutModulo	:= 0; 	
		rOut		:= 0;
		tAna_inErrors.bErrSignal 	:= 	FALSE;  	
		tAna_inErrors.bErrMAXMAX	:= 	FALSE;
		tAna_inErrors.bErrMax		:= 	FALSE;
		tAna_inErrors.bErrOptiMax	:= 	FALSE;			
		tAna_inErrors.bErrOptiMin	:= 	FALSE;
		tAna_inErrors.bErrMin		:= 	FALSE;
		tAna_inErrors.bErrMINMIN	:= 	FALSE;		
		szOutState	:= 	'DISABELED'; 


	END_IF
	
	(*Alternative: output as scaled real value*)
(*OLD	CASE tAnaInPERMEM.scNrOfDecimal  OF
			-1:		(**)
(*					rOut			:= INT_TO_REAL(ssOutScaled) *10 ;
			0:		
(*					rOut			:= INT_TO_REAL(ssOutScaled);
			1:		(**)
(*					rOut			:= INT_TO_REAL(ssOutScaled) /10 ;
			2:		(**)
(*					rOut			:= INT_TO_REAL(ssOutScaled) /100 ;
			3:		(**)
(*					rOut			:= INT_TO_REAL(ssOutScaled) /1000 ;
			4:		(**)
(*					rOut			:= INT_TO_REAL(ssOutScaled) /10000 ;
	ELSE		(*CASE_ELSE*)
(*					rOut			:= 0 ;
	END_CASE		(**)

		rOut		:= DINT_TO_REAL(slOutScaled)  * EXPT(10 , -tAnaInPERMEM.scNrOfDecimal) ;  (* ...*10^(-NrOfDecimal) VORSICHT: NICHT IEC1131 -Konform!!*)


END_FUNCTION_BLOCK



(******************************************************************************)
(******************************************************************************)
(******************************************************************************)


FUNCTION_BLOCK ana_in_SG3helper		(*stellt mit Informationen aus ana_in zusäzlichen Statusausgängen für alte SG3- Visu zur Verfügung*)

		(*outputs for local paneldisplay*)
(*OLD*		CASE ucInputType OF
(*	 		0:		(*AI_NO_SCALING*)
(*					ssOutRaw		:= 	DINT_TO_INT( LIMIT( (INT_TO_DINT(ssInRaw)   * 32767  / 2000 )    , 0, 32767) ); (*scale 0-200°C to full display range*)
(*			1:		(*AI_PT100_NO_SCALING*)	
(*					ssOutRaw		:= 	DINT_TO_INT( LIMIT( (INT_TO_DINT(ssInRaw)   * 32767  / 2000 )    , 0, 32767) ); (*scale 0-200°C to full display range*)
(*			2:		(*AI_-10+10V_INPUT*)
(*					ssOutRaw		:= 	LIMIT( ABS( ssInRaw )  	, 0, 32767);
(*			3:		(*AI_0-20MA_INPUT*)
(*					ssOutRaw		:= 	LIMIT( ssInRaw  		, 0, 32767);
(*			4:		(*AI_4_20MA_INPUT*)
(*					ssOutRaw		:= 	LIMIT( ssInRaw  		, 0, 32767);
(*		ELSE
(*					ssOutRaw		:= 	LIMIT( ssInRaw  		, 0, 32767);
(*		END_CASE
(*\OLD*)
	(*	ssOutRaw		:= 	REAL_TO_INT( LOG( INT_TO_REAL(ssInRaw) / 100 ) * 13000 );		(*logarythmic bargraph scaling*)
	(*	ssOutRaw		:= 	REAL_TO_INT( LN( INT_TO_REAL(ssInRaw) ) * 3150 );		(*logarythmic bargraph scaling*)
		ssOutRaw		:= 	REAL_TO_INT( SQRT( INT_TO_REAL(ssInRaw) ) * 181 );		(*exponential bargraph scaling*)


		(*OPTIONAL: outputs scaled for local paneldisplay with fixed 3 digits after decimal*)	
		CASE tAnaInPERMEM.scNrOfDecimal  OF
	 		0:		
					slOut			:= DINT_TO_INT(ssIn) * 1000;
			1:		(**)
					slOut			:= DINT_TO_INT(ssIn) * 100 ;
			2:		(**)
					slOut			:= DINT_TO_INT(ssIn) * 10;
			3:		(**)
					slOut			:= DINT_TO_INT(ssIn) * 1;
			4:		(**)
					slOut			:= DINT_TO_INT(ssIn) / 10;
					
		ELSE		(*CASE_ELSE*)
					slOut			:= 0 ;
		END_CASE
	
	
	(*SG3 VISU: HELPER OUTPUTS to activate displays and change colors*)
 	tAnaInHelper.ucStatus	:= 93;														(* blue and INvisible (set 1-bit == uneven decimal colornumber)*)
	IF  tAnaInPERMEM.bEnable	 THEN 
 		tAnaInHelper.ucStatus	:= 10;													(* green and visible (no 1-bit! == only even decimal numbers)*)
		IF 	tAna_inErrors.bErrOptiMax OR tAna_inErrors.bErrOptiMin	THEN  	tAnaInHelper.ucStatus := 142; END_IF	(* (ligth)green and visible (no 1-bit!*)
		IF 	tAna_inErrors.bErrMax OR tAna_inErrors.bErrMin			THEN  	tAnaInHelper.ucStatus := 040; END_IF	(* yellow and visible (no 1-bit!*)
		IF 	tAna_inErrors.bErrMAXMAX OR tAna_inErrors.bErrMINMIN	THEN  	tAnaInHelper.ucStatus := 050; END_IF	(* red and visible (no 1-bit!*)
  		IF 	tAna_inErrors.bErrSignal								THEN  	tAnaInHelper.ucStatus := 038; END_IF	(* red and visible (no 1-bit!*)
		IF ssInRaw < - 4											THEN	tAnaInHelper.ucStatus := 246; END_IF	(* NEGATIVE RAW VALUES showed liggthblue and visible (no 1-bit!*)


	(*SG3 VISU: HELPER OUTPUTS to activate displays with different No of digits after decimal point*)		
		CASE tAnaInPERMEM.scNrOfDecimal OF
	 		0:		
					tAnaInHelper.ucStatus0Digits := 0;
					tAnaInHelper.ucStatus1Digits := 1;
					tAnaInHelper.ucStatus2Digits := 1;
					tAnaInHelper.ucStatus3Digits := 1;
					tAnaInHelper.ucStatus4Digits := 1;
	 		1:		
					tAnaInHelper.ucStatus0Digits := 1;
					tAnaInHelper.ucStatus1Digits := 0;
					tAnaInHelper.ucStatus2Digits := 1;
					tAnaInHelper.ucStatus3Digits := 1;
					tAnaInHelper.ucStatus4Digits := 1;
	 		2:		
					tAnaInHelper.ucStatus0Digits := 1;
					tAnaInHelper.ucStatus1Digits := 1;
					tAnaInHelper.ucStatus2Digits := 0;
					tAnaInHelper.ucStatus3Digits := 1;
					tAnaInHelper.ucStatus4Digits := 1;
	 		3:		
					tAnaInHelper.ucStatus0Digits := 1;
					tAnaInHelper.ucStatus1Digits := 1;
					tAnaInHelper.ucStatus2Digits := 1;
					tAnaInHelper.ucStatus3Digits := 0;
					tAnaInHelper.ucStatus4Digits := 1;				
	 		4:		
					tAnaInHelper.ucStatus0Digits := 1;
					tAnaInHelper.ucStatus1Digits := 1;
					tAnaInHelper.ucStatus2Digits := 1;
					tAnaInHelper.ucStatus3Digits := 1;
					tAnaInHelper.ucStatus4Digits := 0;
		END_CASE

	ELSE	(*hide displays...*)
 			tAnaInHelper.ucStatus	:= 1;	
			
			tAnaInHelper.ucStatus0Digits := 1;
			tAnaInHelper.ucStatus1Digits := 1;
			tAnaInHelper.ucStatus2Digits := 1;
			tAnaInHelper.ucStatus3Digits := 1;
			tAnaInHelper.ucStatus4Digits := 1;				
	END_IF
 
 
 
 		
END_FUNCTION_BLOCK
