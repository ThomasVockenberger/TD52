(*******************************************************************************
outData        copy data to OutData

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V3.90.0			17.07.2012	froehlichw	new
V3.90.1 		02.04.2013	Denk		OutData[] assigned with MM2VIS variables from other modules
V3.90.2 		16.08.2013	Denk		Interface comments aligned to English
V3.90.3 		21.11.2013	Denk		parts of task switched to Customized.c_coupl
V04.01.01.00	31.10.2014	Denk		Bugfix, IF425 logic changed. NOT bOMSS_Aut added
V04.05.06.00	13.04.2018	Zengerer	comments for retired msg datapoints

Instructions for use:
--------------------

Outstandings:
------------
- OutData[14: bData[12],bData[13], bData[14], bData[14] bezügl. der Reserve Messages checken. teilweise sind die nicht für ChargingUnit verwendet. (z.b. PortInjection)

(*******************************************************************************)

PROGRAM _CYCLIC

(*------------------------------------------------------------------------------------------
/* prepare buffer Outdata
/*----------------------------------------------------------------------------------------*)
	(*----------------------------------------------------------------------------------------*)
	(* OutData communication, Customized --> Coupling *)
	OutData := IN_CP.tCU2CP_OutData;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[0..13] ... compress and copy bMsg1001 to bMsg1224 *)
	srcAdr:= ADR(IN_CP.bMsg1001);
	dstAdr:= ADR(OutData);
	idxMin:= 0;
	idxMax:= 13;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[14] *)
	bData[0]:=  NOT bOMSS_Man AND NOT bOMSS_Aut;	(* IF425 Operation mode selector switch OFF *)
	bData[1]:= 	bOMSS_Man;							(* IF426 Operation mode selector switch MANUAL *)
	bData[2]:=  bOMSS_Aut;							(* IF427 Operation mode selector switch AUTOMATIC *)
	bData[3]:=  bOMSS_Test;							(* IF428 Operation mode selector switch TEST *)
	bData[4]:=  IN_CP.tGCB_On.Di;					(* IF429 Generator circuit breaker ON *)
	bData[5]:=  NOT IN_CP.tGCB_On.Di;				(* IF430 Generator circuit breaker OFF *)
	bData[6]:=  IN_CP.tEng_Run.Do;					(* IF431 Engine running ON *)
	bData[7]:=  NOT IN_CP.tEng_Run.Do;				(* IF432 Engine running OFF *)		
	bData[8]:=  IN_CP.tEng_Rdy_Rem.Do;				(* IF433 Ready for remote operation *)			
	bData[9]:=  NOT IN_CP.tEng_Rdy_Rem.Do;			(* IF434 Not Ready for remote operation *)	
	bData[10]:= IN_CP.tMCB_On.Di;					(* IF435 Mains circuit breaker ON *)
	bData[11]:= NOT IN_CP.tMCB_On.Di;				(* IF436 Mains circuit breaker OFF *)
	bData[12]:= IN_CP.bMsg2213 OR					(* IF437 general trip turbo charge unit *)		(* - from MM AuxiliariesGeneral*)
				IN_CP.bMsg2214 OR					(* IF437 general trip turbo charge unit *)		(*from MM SAFI  !vvm  V4.05.00! *)	
	            IN_CP.bMsg2215 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
	            IN_CP.bMsg2216 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
	            IN_CP.bMsg2217 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
	            IN_CP.bMsg2218 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
	            IN_CP.bMsg2219 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
	            IN_CP.bMsg2220 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
	            IN_CP.bMsg2221 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
	            IN_CP.bMsg2222 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
	            IN_CP.bMsg2223 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
	            IN_CP.bMsg2224 OR					(* IF437 general trip turbo charge unit *)		(*from MM AuxiliariesGeneral*)
	            IN_CP.bMsg2225 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
	            IN_CP.bMsg2226 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
				IN_CP.bMsg2227 OR					(* IF437 general trip turbo charge unit *)		(*from MM AuxiliariesGeneral*)
				IN_CP.bMsg2228 OR					(* IF437 general trip turbo charge unit *)		(*from MM AuxiliariesGeneral*)
				IN_CP.bMsg2229 OR					(* IF437 general trip turbo charge unit *)		(*from MM AuxiliariesGeneral*)
				IN_CP.bMsg2230 OR					(* IF437 general trip turbo charge unit *)		(*from MM AuxiliariesGeneral*)
				IN_CP.bMsg2231 OR					(* IF437 general trip turbo charge unit *)
				IN_CP.bMsg2232 OR					(* IF437 general trip turbo charge unit *)
	            IN_CP.bMsg2233 OR					(* IF437 general trip turbo charge unit *)
	            IN_CP.bMsg2234 OR					(* IF437 general trip turbo charge unit *)
	            IN_CP.bMsg2235 OR					(* IF437 general trip turbo charge unit *)
	            IN_CP.bMsg2236 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
	            IN_CP.bMsg2237 OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
	            IN_CP.bMsg2238 OR					(* IF437 general trip turbo charge unit *)		(*from MM AuxiliariesGeneral*)
				IN_CP.bMsg2239	OR					(* IF437 general trip turbo charge unit *)		(*from MM ChargingUnit*)
				IN_CP.bMsg2240	OR					(* IF437 general trip turbo charge unit *)
				IN_CP.bMsg2241	OR					(* IF437 general trip turbo charge unit *)
				IN_CP.bMsg2242	OR					(* IF437 general trip turbo charge unit *)
				IN_CP.bMsg2243	OR					(* IF437 general trip turbo charge unit *)
				IN_CP.bMsg2244	OR					(* IF437 general trip turbo charge unit *)
				IN_CP.bMsg2245	OR					(* IF437 general trip turbo charge unit *)
				IN_CP.bMsg2246	OR					(* IF437 general trip turbo charge unit *)		(*from MM GasTrain*)
				IN_CP.bMsg2247	OR					(* IF437 general trip turbo charge unit *)		(*from MM GasTrain*)
				IN_CP.bMsg2248	OR					(* IF437 general trip turbo charge unit *)		(*from MM GasTrain*)
				IN_CP.bMsg2249	OR					(* IF437 general trip turbo charge unit *)		(*from MM GasTrain*)
				IN_CP.bMsg2250	OR					(* IF437 general trip turbo charge unit *)		(*from MM GasTrain*)
				IN_CP.bMsg2251	OR					(* IF437 general trip turbo charge unit *)		(*from MM GasTrain*)
				IN_CP.bMsg2252	OR					(* IF437 general trip turbo charge unit *)		(*from MM EngineController: A2252: Port Injection opening duration is too high    !vvm  V4.05.00! *) 
				IN_CP.bMsg2253	OR					(* IF437 general trip turbo charge unit *)		(*from MM SAFI: Port Injection SPARE    !vvm  V4.05.00! *)
				IN_CP.bMsg2254	OR					(* IF437 general trip turbo charge unit *)		(*from MM SAFI: Port Injection *)
				IN_CP.bMsg2255	OR					(* IF437 general trip turbo charge unit *)		(*from MM SAFI: Port Injection *)
				IN_CP.bMsg2256	OR					(* IF437 general trip turbo charge unit *)		(*from MM SAFI: Port Injection *)
				IN_CP.bMsg2257	OR					(* IF437 general trip turbo charge unit *)		(*from MM GasTrain*)
				IN_CP.bMsg2258	OR					(* IF437 general trip turbo charge unit *)		(*from MM GasTrain*)
				IN_CP.bMsg2259;						(* IF437 general trip turbo charge unit *)
	bData[13]:= IN_CP.bMsg2514 OR					(* IF438 general warning turbo charge unit *)
	            IN_CP.bMsg2515 OR
	            IN_CP.bMsg2516 OR
	            IN_CP.bMsg2517 OR
	            IN_CP.bMsg2518 OR
	            IN_CP.bMsg2519 OR
	            IN_CP.bMsg2520 OR
	            IN_CP.bMsg2521 OR
	            IN_CP.bMsg2522 OR
	            IN_CP.bMsg2523 OR
	            IN_CP.bMsg2525 OR
	            IN_CP.bMsg2526 OR
	            IN_CP.bMsg2527 OR
	            IN_CP.bMsg2528 OR
	            IN_CP.bMsg2529 OR
	            IN_CP.bMsg2530 OR
	            IN_CP.bMsg2531 OR
	            IN_CP.bMsg2532 OR
	            IN_CP.bMsg2533 OR
	            IN_CP.bMsg2539 OR
	            IN_CP.bMsg2540 OR
	            IN_CP.bMsg2541 OR
	            IN_CP.bMsg2543 OR
	            IN_CP.bMsg2546 OR
	            IN_CP.bMsg2547 OR
	            IN_CP.bMsg2548 OR
	            IN_CP.bMsg2549 OR
	            IN_CP.bMsg2550 OR
	            IN_CP.bMsg2551 OR
	            IN_CP.bMsg2554 OR
	            IN_CP.bMsg2563 OR
	            IN_CP.bMsg2564 OR
	            IN_CP.bMsg2565 OR
	            IN_CP.bMsg2566;
	bData[14]:= IN_CP.bMsg3330	OR					(* IF439 Ignition system SAFI/MORIS: General trip (A3330 - A3345)*)
				IN_CP.bMsg3331	OR
				IN_CP.bMsg3332	OR
				IN_CP.bMsg3333	OR
				IN_CP.bMsg3334	OR
				IN_CP.bMsg3335	OR
				IN_CP.bMsg3336	OR
				IN_CP.bMsg3337	OR
				IN_CP.bMsg3338	OR
				IN_CP.bMsg3339	OR
				IN_CP.bMsg3340	OR		//OLD, not in use
				IN_CP.bMsg3341	OR
				IN_CP.bMsg3342	OR
				IN_CP.bMsg3343	OR
				IN_CP.bMsg3344	OR
				IN_CP.bMsg3345;
	bData[15]:= IN_CP.bMsg3530 OR					(* IF440 Ignition system SAFI/MORIS: General warning (W3530 - W3552) *)
	            IN_CP.bMsg3531 OR
	            IN_CP.bMsg3532 OR
	            IN_CP.bMsg3533 OR
	            IN_CP.bMsg3534 OR
	            IN_CP.bMsg3535 OR
	            IN_CP.bMsg3536 OR
	            IN_CP.bMsg3537 OR
	            IN_CP.bMsg3538 OR
	            IN_CP.bMsg3539 OR
	            IN_CP.bMsg3540 OR		//OLD, not in use
	            IN_CP.bMsg3541 OR
	            IN_CP.bMsg3542 OR
	            IN_CP.bMsg3543 OR
	            IN_CP.bMsg3544 OR
	            IN_CP.bMsg3545 OR
	            IN_CP.bMsg3546 OR
	            IN_CP.bMsg3547 OR
	            IN_CP.bMsg3548 OR
	            IN_CP.bMsg3549 OR
	            IN_CP.bMsg3550 OR
	            IN_CP.bMsg3551 OR
	            IN_CP.bMsg3552 OR
				IN_CP.bMsg3553;
	srcAdr:= ADR(bData);
	dstAdr:= ADR(OutData);
	idxMin:= 14;
	idxMax:= 14;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[16..22] ... compress and copy bMsg2001 to bMsg2112 *)
	srcAdr:= ADR(IN_CP.bMsg2001);
	dstAdr:= ADR(OutData);
	idxMin:= 16;
	idxMax:= 22;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[32..45] ... compress and copy bMsg3001 to bMsg3224 *)
	srcAdr:= ADR(IN_CP.bMsg3001);
	dstAdr:= ADR(OutData);
	idxMin:= 32;
	idxMax:= 45;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[46..51] ... compress and copy bMsg3301 to bMsg3396 *)
	srcAdr:= ADR(IN_CP.bMsg3301);
	dstAdr:= ADR(OutData);
	idxMin:= 46;
	idxMax:= 51;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[52..62] ... compress and copy bMsg3401 to bMsg3576 *)
	srcAdr:= ADR(IN_CP.bMsg3401);
	dstAdr:= ADR(OutData);
	idxMin:= 52;
	idxMax:= 62;
	CompressAndCopy;

END_PROGRAM
