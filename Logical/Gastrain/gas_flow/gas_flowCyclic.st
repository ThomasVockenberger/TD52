(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: gas_flow
 * File: gas_flowCyclic.st
(*******************************************************************************
AGGR: calculation of gas flow for the gas inject valve  (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

- calculation of required gasflow for the gas inject valve in m^3/sec.
- calculation of speed and relativ turbo bypass dependent compensation 
- generate gas flow premissions
- safety checks like limit maximum gas flow and limit step change of gas flow
- check errors from the gas inject valve

Customized modifications: -
------------------------
 
History:
-------
V0.1	08-10-2001	Fahringer, generated from gasmenge.c V0.9
		20-02-2002	Fahringer, last modification	
V0.2	15-01-2003	Fahringer, handle ramps outside of bAdmitFlow loop
							   limit boost pressure between 0 and 32767
V0.3	25-03-2003	Fahringer, communication monitoring corrected
V0.4	28-03-2003  Fahringer, changed enable of lambda and lmin ramp
							   reset of TJ_GASN at no bAdmitFlow
							   changed try to send gasflow after 30 msec.
V0.5	20-10-2003	Fahringer, ulGasFlowN for each gas inject valve for
							   gas mixing with two gas inject valves,
							   change of monitoring for gas mixing
							   changed ramp of lmin to 10
							   transfer all CAN and CMS FUBs to caninit task
V0.6	22-04-2004	Fahringer  correct calucaltion of gasflow with 3 inject valves
V0.7	12-05-2004	Fahringer  send of gas density every one second
							   AmmSequence FUB´s for gas inject valve monitoring
V0.71	10-08-2004	Fahringer  new variable ucTJ_MECH for compatibility
V0.72	07-10-2004	Fahringer, change of lambda ramps in init up			
V0.73	07-02-2005  Weitzer,   change of turbo-bypass compensation in init up
							   limit gas flow to > 0 at engine run mode
							   deleted constant set of ssSetMix at gasart 1_2 or 3
V0.74	19-08-2005	Weitzer,   correct calculation for monitoring start limit
V0.75	19-09-2005	Weitzer,   CAN communiction error sequencing activated
V0.76	03-10-2005	Weitzer,   gas flow change bit array corrected error in V0.75
V0.77 	02-11-2005	Fahringer, changed reset of AMMSequence FUB´s
							   gas_flow monitoring set to ulGasFlowN[ucTecNr] > 1
							   gas_flow monitoring in dependance of active gas train
V0.80	13-03-2006	Weitzer,   turbo charger surge protection based on fast
							   gas pressure change
							   fix valve position to min for 4s after engine stop
V0.82	15-05-2007	Weitzer,   fix valve pos with closing of the gas valves
V0.83	04-12-2007	Waldhart,  cancelation of turbo-bypass compensation increased
							   constant for speed compensation will become a parameter
V0.84	08-02-2007	Waldhart,  advanced for LIVC controller
V0.84.1	28-02-2007	Waldhart,  divisor for turbo-bypass compensation increased
V0.85	20-01-2009	Waldhart,  overflow eliminated and gas ratio for mixing rectified
							   3099 Step of fuel gas volume too high (ulFlowDiff --> slFlowDiff resp. ulFlowDiffM --> slFlowDiffM)
							   new calculation of the limit for the maximum gas flow with a common calorific value 
V0.85.1	04-03-2011	Perktold,  adaption for glow ignition prevention 
V3.99	10-05-2012	Denk,	   generated from V0.85.1. All lines except #93-97 and #126–139 deleted

V04.03.00  04.11.2014 Denk		Porting J920 to XT4, IF condition Para.bGlowIgnPrevActive added 
V04.07.00  27.03.2019 Zengerer	add gas counter impulse prescaler - artificial pulse formed in 10ms task, for compatibility with existing counter in 100ms task bm3_nm3
V04.11.00  18.03.2022 Zuschnig  Rework of gas counter impulse prescaler


Instructions for use:
--------------------


Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC
	
	(* Gas mixing with two TECJET's *) 
	OUT_GT.bDualTJ := (Para.iNum_GT > 1) AND Para.bTJ_Exist;	

	(* limit speed of gas mixture change / preset mixture ratio in dependence of gassort *)
	IF Para.bTJ_Exist THEN
		IF OUT_GT.tGV1_Open.Do OR OUT_GT.tGV2_Open.Do THEN		
			bAdmitFlow	:= TRUE;		(* admit gasflow *)
		ELSE
			bAdmitFlow 	:= FALSE;		(* prevent gasflow *)
		END_IF;
	END_IF;

	IF NOT OUT_GT.bDualTJ THEN						
		OUT_GT.rGT_MixSet := 0;					(* set mixture to 0% of gas train 2 *)
		RAMPE_MixGas.enable := FALSE;			(* disable ramp fub *)
	ELSE
		RAMPE_MixGas.enable := bAdmitFlow;		(* enable ramp fub *)
	END_IF;

	IF Para.bGlowIgnPrevActive THEN
		RAMPE_MixGas.Rise := 17;				(* positive change of gas mixture 1,7%/second *)
		RAMPE_MixGas.Sink := 17;				(* positive change of gas mixture 1,7%/second *)	
	END_IF;

	RAMPE_MixGas.In := OUT_GT.rGT_MixSet;			
	RAMPE_MixGas();

	OUT_GT.rGT_RatioMix := LIMIT(0,RAMPE_MixGas.Out,1.0);	(* limit gas mixture rate between 0 and 100% *)
	
	(**********************)	
	(* Gas counter impulse prescaler *)
	R_TRIG_GasImp_Prescaler(CLK := IN_GT.tCnt_GasImp.Di);
	IF R_TRIG_GasImp_Prescaler.Q THEN
		IF Para.rGasImp_Prescaling < 1.0 THEN
			iGasImp_PrescalCount := iGasImp_PrescalCount + REAL_TO_DINT(Para.rGasImp_Prescaling * 10000000);
			IF iGasImp_PrescalCount >= 10000000 THEN 
				bGasImp_Prescaled := TRUE;
				iGasImp_PrescalCount := iGasImp_PrescalCount - 10000000;
			END_IF
		ELSE
			bGasImp_Prescaled := TRUE;
		END_IF;
//	ELSE
//		IF NOT IN_GT.tCnt_GasImp.Di THEN bGasImp_Prescaled := FALSE; END_IF	(* Do not clear the artificial generated pulse, until the real pulse is gone, to keep similar pulse duration behavior *) 
	END_IF
	
END_PROGRAM
