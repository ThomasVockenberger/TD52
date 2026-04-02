(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: 
 * File: GeACtr.st
 * Author: maierm
 * Created: May 22, 2012
 *******************************************************************)


(* ******************************************************************
 * History:
 * 
 * V0.10.0		22-05-2012 maierm, 	generated
 * V0.10.1		21-06-2012 maierm, 	set clamp at line 102 
 *								  	tProcPar.valid commented
 *								   	line 321 simplified - if / else
 *									was not necessary
 * V0.20.0		22-04-2013 maierm,	Datatype tParameter.Kp_manualAdjust, tParameter.Tn_manualAdjust and tParameter.Tv_manualAdjust  
 *									changed to REAL, scaling included:
 *										tInput.Y_man 				==> tInput.Y_man * SCALE_PERCENT
 *										tInput.Y_set 				==> tInput.Y_set * SCALE_PERCENT
 *										tInput.A	 				==> tInput.A * SCALE_PERCENT
 *										tOutput.Y	 				==> rY / SCALE_PERCENT			
 *										tOutput.e	 				==> xLCRPID.e / SCALE_PERCENT
 *										tOutput.Tn_tune 			==> tProcPar.Tn_tune * SCALE_TIME
 *										tOutput.Tv_tune 			==> tProcPar.Tv_tune * SCALE_TIME
 *										tParameter.Y_min   			==> tParameter.Y_min * SCALE_PERCENT
 *										tParameter.Y_max   			==> tParameter.Y_max * SCALE_PERCENT
 *										tParameter.dY_max  			==> tParameter.dY_max * SCALE_PERCENT
 *										tParameter.Y_block 			==> tParameter.Y_block * SCALE_PERCENT
 *										tParameter.Tn	   			==> tParameter.Tn / SCALE_TIME
 *										tParameter.Tv	   			==> tParameter.Tv / SCALE_TIME
 *										tParameter.Kp_manualAdjust 	==> tParameter.Kp_manualAdjust * SCALE_PERCENT
 *										tParameter.Tn_manualAdjust  ==> tParameter.Tn_manualAdjust * SCALE_PERCENT
 *										tParameter.Tv_manualAdjust 	==> tParameter.Tv_manualAdjust * SCALE_PERCENT
 *										tParameter.t_min_pulse_up 	==> tParameter.t_min_pulse_up / SCALE_TIME
 *										tParameter.t_period_up 		==> tParameter.t_period_up / SCALE_TIME
 *										tParameter.t_min_pulse_down ==> tParameter.t_min_pulse_down / SCALE_TIME
 *										tParameter.t_period_down 	==> tParameter.t_period_down / SCALE_TIME
 * V0.30.0		11-06-2013 maierm, 	comment format changed,
 *								   	corrected bug in part "input pwm up" and "input pwm down" - 
 *								   	instead of bSafe2 was bSafe1 written - correct is bSafe2,
 *								   	changed rYmin to tParameter.Y_min in part "reset tuning or pid error",
 *								   	changed rYmax to tParameter.Y_max in part "reset tuning or pid error", 
 *								   	set X to W for one cycle at enable of the fub 
 * V0.40.0		27-06-2013 maierm, 	status of LCRPWM_up and LCRPWM_down has the lowest priority,
 *								   	instead of manuel mode, Input.Y_man is always following Output.Y,
 *								   	setting the internal I - component of the LCRPIDTune FUB directly to the new Y_min and Y_max limits
 * V0.50.0		28.06.2013 maierm, 	tInput.enable = FALSE sets the LCRPID to manual mode. LCRPID and LCRPIDTune is always running
 * V0.60.0		03.07.2013 Tinello,	Change tOutput.e  ==> Difference between W and X
 * V0.60.1		03.09.2013 maierm, 	bug at the feature "setting the internal I - component of the LCRPIDTune..." removed (Comparison
 *								   	between scaled and not scaled value) 	
 * V0.60.2		02.12.2013 Tinello,	If Y_Min = Y_Max -> automatic adjustment of Y_Min and Y_Max
 *									automatic limitation of Y_Min and Y_Max to -100% to 100%
 * V0.60.3		24.09.2016 Fahring,	set tAddPar.Kfbk = 1.0 to activate anti wind up protection
									set tAddPar.Tf_Tv = 0.1 / default value 
 * V0.60.4		11.01.2017 Tinello,	Setpoint ramp changed from stage per second to linear ramp according to used cycle time
 * V0.70.0		25.01.2022 Perktold,Parameters: added W_set2, and GeinScheduling PID values; deleted "_manualAdjust" Parameters
									added Inputs: 	W_set2_Active, Retrigger, GainScheduling, Y_min_cust, Y_max_cust, AlwaysUseYRamp, KeepYManAtBlock
									added Outputs: 	Y_min_act, Y_max_act, Kp_act, Tn_act, Tv_act, Yp, Yi, Yd, BlockAutoTune, Show_PID_act
									LCRPWM replaced by LCRContinServo for sept_up/down output computation
 ****************************************************************************************************************************************************)

						
FUNCTION_BLOCK GeACtr
	
	(* ******************************** *)
	(*				ACCESS				*)
	(* ******************************** *)
	
	tParameter ACCESS pParameter; 								(* parameter from user *)
	tInput 	   ACCESS pInput;	  								(* input from user *)
	tOutput    ACCESS pOutput;	 								(* output from user *)
	tProcPar   ACCESS ADR(xLCRPIDTune.processPar);				(* Kp, Tn, Tv from LCRPIDTune *)	
	

	(* ************************************************ *)
	(*	enable / auto / man / safe1 / safe2 / Retrigger	*)
	(* ************************************************ *)
	
	xR_TRIG_enable(CLK := tInput.enable);						(* generate rising trigger at enable*)
	bAuto  := tInput.enable AND NOT(tInput.Y_man_Active);		(* automatic *)
	bMan   := tInput.enable AND tInput.Y_man_Active;			(* manual *)
	bSafe1 := NOT(tInput.enable) AND NOT(tInput.Y_set_Active);	(* 1st safe - Y_block *)
	bSafe2 := NOT(tInput.enable) AND tInput.Y_set_Active;		(* 2nd safe - Y_set *)
	xR_TRIG_Retrigger(CLK := tInput.Retrigger);					(* generate rising trigger at retrigger*)
	
	
	(* ******************************** *)
	(*				  W					*)
	(* ******************************** *)
	
	tParameter.W_set := LIMIT(tParameter.W_min, tParameter.W_set, tParameter.W_max);	(* limit W from visu *)	
	tParameter.W_set2 := LIMIT(tParameter.W_min, tParameter.W_set2, tParameter.W_max);	(* limit W from visu *)	
	
	IF tInput.W_ext_Active 	THEN rWSet := tInput.W_ext; 					(* W from external *)
						 	ELSE 
								IF tInput.W_set2_Active THEN
									rWSet := tParameter.W_set2;				(* W from visu - second internal set point*)
								ELSE
									rWSet := tParameter.W_set;				(* W from visu *)
								END_IF
							END_IF	
	
	xLCRRamp_WSet.enable 	:= TRUE;
	xLCRRamp_WSet.dy_up 	:= tParameter.dW_up;							(* ramp up:   value/s *)
	xLCRRamp_WSet.dy_down 	:= tParameter.dW_down;							(* ramp down: value/s *)
	xLCRRamp_WSet.y_min 	:= tParameter.W_min;							(* limit W actual *)
	xLCRRamp_WSet.y_max 	:= tParameter.W_max;							(* limit W actual *)
	xLCRRamp_WSet.y_set 	:= tInput.X;									(* set X to W at enable of fub or retriggering *)
	xLCRRamp_WSet.set 		:= xR_TRIG_enable.Q OR xR_TRIG_Retrigger.Q;		(* activate set in case of retriggering or at enable of fub *)
	xLCRRamp_WSet(x 		:= rWSet);

	rW := LIMIT(tParameter.W_min, xLCRRamp_WSet.y, tParameter.W_max);		(* limit W *)	
	tOutput.W 	:= rW; 														(* W actual *)

	
	(* ******************************** *)
	(*	 Y_min / Y_max (error 12037)	*)
	(* ******************************** *)
	
	IF (tParameter.Y_min <> rYMinOld) AND (tParameter.Y_min > tParameter.Y_max) THEN		(* Limit Y_min parameter to Y_max if Y_min > Y_max*)
		tParameter.Y_min := tParameter.Y_max;
	END_IF
	IF (tParameter.Y_max <> rYMaxOld) AND (tParameter.Y_max < tParameter.Y_min) THEN		(* Limit Y_max parameter to Y_min if Y_max < Y_min*)
		tParameter.Y_max := tParameter.Y_min;
	END_IF
	
	IF (tParameter.Y_max > Y_MAX  			OR												(* create error 12037 manually because of a bug in V2.80.1 *)
		tParameter.Y_min < Y_MIN 			OR
		tParameter.Y_max < tParameter.Y_min) 
	THEN
		rYMax := 0;	 																		(* set Ymax to 0 *)	
		rYMin := 0;  																		(* set Ymin to 0 *)
	ELSE
		rYMax := LIMIT(-1.0, MAX(MIN(tParameter.Y_max, tInput.Y_max_cust), MAX(tParameter.Y_min, tInput.Y_min_cust)), 1.0) * SCALE_PERCENT;	(* include Y_min_cust & Y_max_cust *)
		rYMin := LIMIT(-1.0, MIN(MAX(tParameter.Y_min, tInput.Y_min_cust), MIN(tParameter.Y_max, tInput.Y_max_cust)), 1.0) * SCALE_PERCENT;	(* include Y_min_cust & Y_max_cust *)
	END_IF

	IF rYMax = rYMin THEN																	(* in case Ymax = Ymin set them 0.01 appart *)
		IF rYMax >= 0 THEN	rYMin := rYMax - 0.01; 	END_IF
		IF rYMax < 0 THEN	rYMax := rYMin + 0.01; 	END_IF
	END_IF	

	(* put the resulting YMin & YMax to the output structure *)
	tOutput.Y_max_act	:=	rYMax / SCALE_PERCENT;
	tOutput.Y_min_act	:=	rYMin / SCALE_PERCENT;

	(* If Y_min or Y_max is changed, the internal I - component of the LCRPIDTune FUB ran through the whole range to the new Y_min and 
	(* Y_max limits. This behavior is optimised by setting the internal I - component of the LCRPIDTune FUB directly to the new Y_min and 
	(* Y_max limits *)
	IF (rYMin <> rYMinintOld OR rYMax <> rYMaxintOld) THEN
		pYi1 ACCESS ADR(xLCRPIDTune.internal_data.Yi1); 									(* internal I - component can't be changed directly *)  

		IF 	  (tOutput.Y <= (rYMin / SCALE_PERCENT)) THEN	pYi1 := rYMin;					(* set the internal I - component directly *)
		ELSIF (tOutput.Y >= (rYMax / SCALE_PERCENT)) THEN	pYi1 := rYMax;	END_IF			(* set the internal I - component directly *)
	END_IF

	IF xR_TRIG_Retrigger.Q OR xR_TRIG_enable.Q THEN											(* in case of retriggering or at enable of fub     *)
		pYi1 ACCESS ADR(xLCRPIDTune.internal_data.Yi1); 									(* access the internal integrator value of the CTR *)
		pYi1 := tOutput.Y * SCALE_PERCENT;													(* set the integrator to represent the last Y      *)
	END_IF;
	
	
	(* ******************************** *)
	(*				Tuning				*)
	(* ******************************** *)
	
	(* limit gain scheduling input from 0 to 1*)
	tInput.GainScheduling	:= LIMIT(0.0, tInput.GainScheduling, 1.0);	

	(* Generate Output for VISU to decide if Parameters or actual PID-values are shown *)
	IF (tInput.GainScheduling >= 0.01) THEN
		tOutput.Show_PID_act	:= TRUE;		(* not show PID-paramters - show actual PID-values instead *)
	ELSE
		tOutput.Show_PID_act	:= FALSE;		(* show PID-paramters *)
	END_IF;

	(* De-/Activation of the Auto Tune function *)
	IF 	(xLCRPIDTune.status = 65534) 	OR		(* Auto Tune inactive (eg. Controller not enabled) *)
		(tInput.GainScheduling >= 0.01)	OR 		(* Gain Scheduling active - don't show parameters - show actual values instead *)
		NOT tInput.enable				OR		(* Controller nor enabled *)
		bMan									(* Controller running in manual mode *)
	THEN
		tInput.Tune_start 		:= FALSE;		(* reset *)
		tOutput.BlockAutoTune	:= TRUE;		(* lock VISU Button for AUTO Tune *)
	ELSE
		tOutput.BlockAutoTune	:= FALSE;		(* unlock VISU Button for AUTO Tune *)
	END_IF;

	(* tuning enable *)
	bTune_enable := TRUE;
	
	(* start *)
	IF (tInput.Tune_start = TRUE AND bAuto = TRUE AND usTune_status = 0) THEN (* user start *)
		bTune_active        := TRUE; 					(* tuning started *)
		bTunePIOld			:= tInput.Tune_PI;  		(* store *)
		bTunePIDOld			:= tInput.Tune_PID; 		(* store *)
		xLCRPIDTune.request := xTunReq(tInput.Tune_PI, tInput.Tune_PID, tInput.Tune_quality, tParameter.invert); (* calculate tuning request *)
	END_IF
	tInput.Tune_start 		:= FALSE;	(* reset *)
	
	(* stop *)
	IF (tInput.Tune_stop = TRUE 										OR 		(* user stop *)
		EDGENEG(bAuto) = TRUE											OR  	(* fub enable = FALSE OR manual = TRUE *)
		tAddPar.invert <> tParameter.invert 							OR  	(* invert parameter changed *)
		(xLCRPIDTune.status >= 12025 AND xLCRPIDTune.status <> 65534)) 			(* error happened *)
	THEN
		xLCRPIDTune.request := LCRPID_TUNE_REQU_OFF; 							(* deactivate tuning *)
		usTune_status       := 0; 												(* reset *)
		bTune_save 		    := FALSE; 											(* tuning stopped *)
		bTune_active        := FALSE; 											(* tuning stopped *)
		
		IF (xLCRPIDTune.status >= 12025 AND xLCRPIDTune.status <> 65534) THEN	(* tuning error *) 	
			usTune_status := xLCRPIDTune.status;								(* error status *)	
			IF (xLCRPIDTune.status = 12039)	THEN
				usTune_status := xLCRPIDTune.addInfo;							(* show additional info *)	
			ELSIF (xLCRPIDTune.status = 31564) THEN
				xResErr(ADR(bTune_enable), xLCRPIDTune.status);					(* reset enable after error *) 						
			END_IF
		END_IF
	END_IF
	tInput.Tune_stop := FALSE;			(* reset *)
	
	(* store tuning parameter *)
	IF (tInput.Tune_takeover = TRUE) THEN 						(* get tuning parameter every time *)
		bTune_save 	  		:= FALSE; 							(* tuning save closed *)
		usTune_status 		:= 0;	    						(* set status - no error / tuning finished / parameter saved *)
		tParameter.Kp 		:= tOutput.Kp_tune;
		tParameter.Tn 		:= tOutput.Tn_tune; 
		tParameter.Tv 		:= tOutput.Tv_tune;
	END_IF
	tInput.Tune_takeover	:= FALSE; 	(* reset *)
	
	(* set ctrl parameter *)
	IF (bTune_active = FALSE AND bTune_save = TRUE) THEN 		(* no tuning / tuning parameter not set *)
		IF (bTunePIOld = TRUE AND bTunePIDOld = FALSE) THEN 	(* PI - tuning *)
			tProcPar.Tv_tune := 0;		(* delete D *)
		ELSIF (bTunePIOld = FALSE AND bTunePIDOld = FALSE) THEN (* P - tuning *)
			tProcPar.Tn_tune := 0;		(* delete I *)
			tProcPar.Tv_tune := 0;		(* delete D *)
		END_IF
		tOutput.Kp_tune := tProcPar.Kp_tune; 			  		(* fub to tune parameter *) 
		tOutput.Tn_tune := tProcPar.Tn_tune * SCALE_TIME; 		(* fub to tune parameter *)
		tOutput.Tv_tune := tProcPar.Tv_tune * SCALE_TIME; 		(* fub to tune parameter *)	 

	ELSIF (bTune_active = FALSE AND bTune_save = FALSE) THEN 	(* no tuning and parameter set *)
		tProcPar.valid   := TRUE; 										(* necessary for the LCRPIDTune(). Kp_tune, Tn_tune and Tv_tune *)
																		(* are "valid" and can be used from the FUB 					*)
		(* Interpolate PID-Parameters via Gain Scheduling *)
		tProcPar.Kp_tune :=  (1.0 - tInput.GainScheduling) * tParameter.Kp + tInput.GainScheduling * tParameter.Kp_GainScheduling; 						(* parameter to fub *)
		tProcPar.Tn_tune := ((1.0 - tInput.GainScheduling) * tParameter.Tn + tInput.GainScheduling * tParameter.Tn_GainScheduling) / SCALE_TIME; 		(* parameter to fub *)
		tProcPar.Tv_tune := ((1.0 - tInput.GainScheduling) * tParameter.Tv + tInput.GainScheduling * tParameter.Tv_GainScheduling) / SCALE_TIME; 	 	(* parameter to fub *)  
		IF xR_TRIG_Retrigger.Q OR xR_TRIG_enable.Q THEN
			tProcPar.Tv_tune := 0;
		END_IF;
	END_IF
		
	(* tuning status *) 
	IF (bTune_active = FALSE AND bTune_save = TRUE) THEN	
		usTune_status := 1; 									(* set status - tuning finished, but not closed *)
	ELSIF (bTune_active = TRUE) THEN	
		usTune_status := 2;										(* set status - tuning active *)
	END_IF
					
	(* parameter *)
	xLCRPIDTune.enable 			:= bTune_enable;
	xLCRPIDTune.Y_min  			:= rYMin;
	xLCRPIDTune.Y_max  			:= rYMax;
	xLCRPIDTune.X_min  			:= tInput.X_min;
	xLCRPIDTune.X_max  			:= tInput.X_max;
	xLCRPIDTune.P_manualAdjust 	:= 0;
	xLCRPIDTune.I_manualAdjust 	:= 0;
	xLCRPIDTune.D_manualAdjust 	:= 0;
	
	(* additional parameter *)
	tAddPar.dY_max      		:= tParameter.dY_max * SCALE_PERCENT;	
	tAddPar.deadband    		:= tParameter.deadband;
	tAddPar.d_mode      		:= LCRPID_D_MODE_E;
	tAddPar.invert	    		:= tParameter.invert;
	tAddPar.Kfbk				:= 1.0;
	tAddPar.Tf_Tv				:= 0.1;
	xLCRPIDTune.pAddPar 		:= ADR(tAddPar);	 (* additional parameter *)
	
	(* reset valid *)
	IF (EDGEPOS(bTune_active) = TRUE) THEN 	(* new tuning *)
		tProcPar.valid 			:= FALSE;  	(* reset necessary at new tuning - otherwise ctrl fub is immediately finished *)	
	END_IF
		
	xLCRPIDTune();

	(* put the resulting PID-values to the output structure *)
	tOutput.Kp_act	:= tProcPar.Kp_tune;
	tOutput.Tn_act	:= tProcPar.Tn_tune * SCALE_TIME;
	tOutput.Tv_act	:= tProcPar.Tv_tune * SCALE_TIME;

	
	(* store during tuning the parameters from the visu to the internal structure (if user changed it during the tuning) *)
	IF (bTune_active = TRUE AND xLCRPIDTune.state < LCRPID_TUNE_STATE_RESET_CNTL) THEN
		tProcPar.Kp_tune 	  := tParameter.Kp; 			 (* parameter to fub *)
		tProcPar.Tn_tune 	  := tParameter.Tn / SCALE_TIME; (* parameter to fub *)
		tProcPar.Tv_tune 	  := tParameter.Tv / SCALE_TIME; (* parameter to fub *)
	END_IF
	
	(* set parameter after enable = TRUE (LCRPID sets parameter to 0 / 0.5 aso. after enable = TRUE) *)
	IF (EDGEPOS(tInput.enable) = TRUE) THEN
		tProcPar.valid   	  := TRUE; 		   				 (* valid necessary that controller use the parameters - after enable = TRUE *)
		tProcPar.Kp_tune 	  := tParameter.Kp; 			 (* parameter to fub *)
		tProcPar.Tn_tune 	  := tParameter.Tn / SCALE_TIME; (* parameter to fub *)
		tProcPar.Tv_tune 	  := tParameter.Tv / SCALE_TIME; (* parameter to fub *)
	END_IF

	(* tuning finished *)
	IF (bTune_active = TRUE AND xLCRPIDTune.state = LCRPID_TUNE_STATE_FINISHED) THEN
		xLCRPIDTune.request   := LCRPID_TUNE_REQU_OFF; 		(* deactivate tuning *)
		bTune_save 		      := TRUE;  					(* save parameter *)
		bTune_active          := FALSE; 					(* tuning finished *)
		
		(* error 12041 manually *)
		IF (tProcPar.valid = FALSE AND rW <> rWOld) THEN	(* set status 12041 manually because of a bug in V2.80.1 *)
			rWOld 		      := rW;
			bTune_save        := FALSE;
			usTune_status     := 12041;
		END_IF
	END_IF
	
	(* error 12041 manually *)
	IF (bTune_active = FALSE) THEN
		rWOld := rW;
	END_IF
	
	(* ******************************** *)
	(*				PID					*)
	(* ******************************** *)
	
	(* error *)	
	IF (xLCRPID.status >= 12025 AND xLCRPID.status <> 65534) THEN	 (* error happened *)
		usPID_status := xLCRPID.status;	 			(* show error number *)						
	ELSE
		usPID_status := 0;
	END_IF
	
	(* Y manual *)
	IF (bSafe1 = TRUE) THEN											(* first safe value *)
		IF tInput.KeepYManAtBlock THEN								(* prevent overriding of tInput.Y_man *)
			xLCRPID.Y_man:= tParameter.Y_block * SCALE_PERCENT;		(* write Y_block value to LCRPID directly *)
		ELSE
			tInput.Y_man := tParameter.Y_block;						(* override Y_man with Y_block value*)
		END_IF;
		xLCRPID.mode := LCRPID_MODE_MAN_JOLTFREE;					(* PID manual mode *)
	END_IF
	
	IF (bSafe2 = TRUE) THEN 										(* second safe value *)
		IF tInput.KeepYManAtBlock THEN								(* prevent overriding of tInput.Y_man *)
			xLCRPID.Y_man:= tInput.Y_set * SCALE_PERCENT;			(* write Y_set value to LCRPID directly *)
		ELSE
			tInput.Y_man := tInput.Y_set;							(* override Y_man with Y_set value*)
		END_IF
		xLCRPID.mode := LCRPID_MODE_MAN_JOLTFREE;					(* PID manual mode *)
	END_IF
	
	IF (bAuto = TRUE) THEN											(* automatic mode *)	
		tInput.Y_man := tOutput.Y;									(* in automatic mode Y_man is following Y *)							
		xLCRPID.Y_man:= tInput.Y_man * SCALE_PERCENT;				(* write Y_man value to LCRPID directly *)
		xLCRPID.mode := LCRPID_MODE_AUTO;							(* PID automatic mode *)		
	END_IF
	
	IF (bMan = TRUE) THEN																	(* manual mode *)			
		tInput.Y_man := LIMIT(rYMin / SCALE_PERCENT, tInput.Y_man, rYMax / SCALE_PERCENT);	(* limit Y manual from visu *)				
		xLCRPID.Y_man := tInput.Y_man * SCALE_PERCENT;										//Y_man for LCRPID acc Y_man
		xLCRPID.mode := LCRPID_MODE_MAN_JOLTFREE;											(* PID manual mode *)
	END_IF
	
	IF NOT tInput.KeepYManAtBlock THEN
		xLCRPID.Y_man 	 := tInput.Y_man * SCALE_PERCENT;									(* transfer Y_man value to LCRPID *)
	END_IF;
	
	(* parameter *)
	xLCRPID.enable 	 := TRUE;
	xLCRPID.ident  	 := xLCRPIDTune.ident;
	xLCRPID.Y_max  	 := rYMax; 
	xLCRPID.Y_min  	 := rYMin;
	xLCRPID.A	   	 := tInput.A * SCALE_PERCENT;
	xLCRPID.W 		 := rW;		   					(* W *)
	xLCRPID.X 		 := tInput.X;  					(* X *)
	xLCRPID();
	
	rY 		  		 := xLCRPID.Y;					(* Y FuB *) 
	tOutput.e 		 := xLCRPID.X - xLCRPID.W;		(* Error = X - W *)

	(* ******************************** *)
	(*				  Y 				*)
	(* ******************************** *)
	
	(* change of request *)	
	IF ((EDGEPOS(bTune_active) = TRUE) OR 							(* set Y to Y old after start of tuning *)	
		(EDGENEG(bTune_active) = TRUE AND bTune_save = FALSE)) 		(* set Y to Y old after tuning stop 	*)	
	THEN
		rY := rYOld;	(* Y decreases minimal for one cycle after start of tuning and cancel of tuning	*)
					   	(* - set Y to YOld for one cycle compensate this decrease 						*)		
	END_IF
	rYOld := rY;
		
	(* first safe value *)
	IF (bSafe1 = TRUE) THEN	
		rY := tParameter.Y_block * SCALE_PERCENT;	(* Y_block *)
	END_IF
	
	(* second safe value *)
	IF (bSafe2 = TRUE) THEN 
		rY := tInput.Y_set * SCALE_PERCENT;			(* Y_set *)
	END_IF

	(* additional ramp at the end of the controller to prohibit step changes on Y *)
	xLCRRamp_Y.enable 	:= TRUE;
	xLCRRamp_Y.dy_up 	:= tParameter.dY_max;			(* ramp up:   value/s *)
	xLCRRamp_Y.dy_down 	:= tParameter.dY_max;			(* ramp down: value/s *)
	xLCRRamp_Y.y_min 	:= -1.0;						(* limit Y actual - full range *)
	xLCRRamp_Y.y_max 	:=  1.0;						(* limit Y actual - full range *)
	xLCRRamp_Y.y_set 	:= rY / SCALE_PERCENT;
	xLCRRamp_Y.set 		:= NOT tInput.AlwaysUseYRamp;	(* possibility to deactivate the ramp *)
	xLCRRamp_Y(x 		:= (rY / SCALE_PERCENT));

	tOutput.Y := xLCRRamp_Y.y; 				(* Y to output *)	

	(* transfer all parts of Y to the tOutput structure *)
	tOutput.Yp		:= xLCRPID.Yp / SCALE_PERCENT;
	tOutput.Yi		:= xLCRPID.Yi / SCALE_PERCENT;
	tOutput.Yd		:= xLCRPID.Yd / SCALE_PERCENT;

	(* ******************************** *)
	(*				PWM					*)
	(* ******************************** *)
	IF tInput.StepperMode THEN
		(* PWM Up *)
		(* enable *)
		bPWM_up_enable := tInput.enable;		(* activate *)
		xResChg(ADR(bPWM_up_enable), tParameter.t_min_pulse_up / SCALE_TIME, xLCRPWM_up.t_min_pulse);		(* reset enable if t_min_pulse 
																											   changed *) 
		(* parameter *)
		xLCRPWM_up.enable 	   := bPWM_up_enable; 	
		xLCRPWM_up.max_value   := rYMax;
		xLCRPWM_up.min_value   := xCalMid(rYMin, rYMax);		(* calculate middle of Y_max / Y_min range *)
		xLCRPWM_up.t_min_pulse := tParameter.t_min_pulse_up / SCALE_TIME;
		xLCRPWM_up.t_period	   := tParameter.t_period_up / SCALE_TIME;
		
		(* input PWM Up *)
		IF (bSafe1 = TRUE OR bSafe2 = TRUE OR bMan = TRUE) 		(* Y_block / Y_set / Y_man *)
		THEN
			xLCRPWM_up.x := xCalMid(rYMin, rYMax); 				(* restrict input to middle of Y_max / Y_min range *) 		
		ELSE
			xLCRPWM_up.x := rY; 								(* actual value *)
		END_IF
		
		xLCRPWM_up();
		
		
		(* PWM Down *)
		(* enable *)
		bPWM_down_enable := tInput.enable;		(* activate *)
		xResChg(ADR(bPWM_down_enable), tParameter.t_min_pulse_down / SCALE_TIME, xLCRPWM_down.t_min_pulse);	(* reset enable if t_min_pulse 
																											   changed *) 
		(* parameter *)
		xLCRPWM_down.enable 	 := bPWM_down_enable; 	
		xLCRPWM_down.max_value   := xCalMid(rYMin, rYMax);		(* calculate middle of Y_max / Y_min range *)
		xLCRPWM_down.min_value   := rYMin;  
		xLCRPWM_down.t_min_pulse := tParameter.t_min_pulse_down / SCALE_TIME;
		xLCRPWM_down.t_period	 := tParameter.t_period_down / SCALE_TIME;
		
		(* input PWM Down *)
		IF (bSafe1 = TRUE OR bSafe2 = TRUE OR bMan = TRUE) 		(* Y_block / Y_set / Y_man *)
		THEN
			xLCRPWM_down.x := xCalMid(rYMin, rYMax); 			(* restrict input to middle of Y_max / Y_min range *) 		
		ELSE
			xLCRPWM_down.x := rY;								(* actual value *)	
		END_IF
		
		xLCRPWM_down();
		
		
		(* PWM Up / PWM Down *)
		(* common status for PWM Up and PWM Down *)
		IF 	  (xLCRPWM_up.status   >= 12025) THEN	usPWM_status := xLCRPWM_up.status;
		ELSIF (xLCRPWM_down.status >= 12025) THEN	usPWM_status := xLCRPWM_down.status;
											 ELSE	usPWM_status := 0;				 		END_IF
			
		(* output only if PWM Up and PWM Down has no error *)
		IF (usPWM_status = 0) THEN
			tOutput.Step_up   := xLCRPWM_up.pulse;
			tOutput.Step_down := NOT(xLCRPWM_down.pulse); 	(* invert necessary *)
		ELSE
			tOutput.Step_up   := FALSE;	
			tOutput.Step_down := FALSE;
		END_IF
		
	ELSE  // tInput.StepperMode = FALSE

		(* ******************************** *)
		(*     continuous servo drive   	*)
		(* ******************************** *)
	
		(* Enable servo drive *)
		xLCRContinServo.enable        := tInput.enable;
		
		(* Parameters for continuous servo drive *)
		xLCRContinServo.max_value     := tOutput.Y_max_act;
		xLCRContinServo.min_value     := tOutput.Y_min_act;
		xLCRContinServo.t_impulse     := (tParameter.t_min_pulse_up / 1000) ;
		IF tParameter.dY_max <> 0 THEN
			xLCRContinServo.t_change_up   := (1 / tParameter.dY_max) * (tOutput.Y_max_act - tOutput.Y_min_act);
			xLCRContinServo.t_change_down := (1 / tParameter.dY_max) * (tOutput.Y_max_act - tOutput.Y_min_act);
		END_IF;
		
		(* Continuous servo drive *)
		xLCRContinServo.x   := tOutput.Y;
		xLCRContinServo();										(* LCRContinServo function block call *)
	
		(* Copy up and down to controller output *)
		tOutput.Step_up 		:= xLCRContinServo.up;
		tOutput.Step_down 		:= xLCRContinServo.down;
	END_IF;
	
	(* ******************************** *)
	(*		reset status LCRPIDTune		*)
	(* ******************************** *)	

	(* reset tuning or pid error *)
	IF (tParameter.Kp   			<> rKpOld  				OR
		tParameter.Tn 	 			<> rTnOld  				OR
		tParameter.Tv   			<> rTvOld  				OR
		tParameter.Y_min 			<> rYMinOld 			OR
		tParameter.Y_max 			<> rYMaxOld 			OR
		rYMinintOld					<> rYMin				OR
		rYMaxintOld					<> rYMax				OR	
		tInput.X_min     			<> rXMinOld 			OR
		tInput.X_max     			<> rXMaxOld 			OR
		tParameter.deadband 		<> rDeadbandOld			OR
		tParameter.dY_max			<> rDYMaxOld)
	THEN 
		IF (usTune_status >= 12025 AND usTune_status <> 65534) THEN	
			usTune_status := 0;	(* reset tune status after error *)
		END_IF			
	END_IF

	rKpOld   			:= tParameter.Kp; (* restore *) 
	rTnOld   			:= tParameter.Tn;
	rTvOld   			:= tParameter.Tv;
	rYMinOld 			:= tParameter.Y_min;
	rYMaxOld 			:= tParameter.Y_max;
	rYMinintOld			:= rYMin;
	rYMaxintOld			:= rYMax;	
	rXMinOld 			:= tInput.X_min;
	rXMaxOld 			:= tInput.X_max;
	rDeadbandOld      	:= tParameter.deadband; 
	rDYMaxOld		  	:= tParameter.dY_max;

	(* ******************************** *)
	(*				Status				*)
	(* ******************************** *)
	
	tOutput.Active := tInput.enable;
	
	IF (tInput.enable = TRUE) THEN	(* fub enable *)	
	
		IF 	  (xChkStat(usPID_status)  = TRUE) THEN	tOutput.status := usPID_status;		(* LCRPID state *)
		ELSIF (xChkStat(usTune_status) = TRUE) THEN tOutput.status := usTune_status;	(* LCRTune state *)
		ELSIF (xChkStat(usPWM_status)  = TRUE) THEN tOutput.status := usPWM_status; 	(* LCRPWM_up AND LCRPWM_down state *)
											   ELSE tOutput.status := 0;
		END_IF

	ELSE							(* fub disable *)
		usTune_status  := 0;		(* reset *)
		usPID_status   := 0;
		usPWM_status   := 0;
		bTune_active   := FALSE;
		bTune_save     := FALSE;
		tOutput.status := 65534;	(* status enable = FALSE *)
	END_IF
	
END_FUNCTION_BLOCK
