(*******************************************************************************
c_coupl	 			 Coupling IN/OUT data register

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2023

Customized modifications: -
------------------------
 
History:
-------
V3.90.0	20.11.2013	Denk		 generated, new
V3.90.1 07.02.2014	Zengerer	 IF741 +ff comments as customer OPC reference; IN_CU.InData2[0] used

V04.01.1	31.07.2014	Denk	 IF536 - IF539 factor 10 added
V04.03.0	16.01.2015	Denk	 Bugfix, IF658 IN_CU.rVol_GT factor 1000 deleted
			04.05.2015	Zengerer CUSTOMER BUS input values AND output values prepared on Modul Interfaces  -> See Para.rCustFactor_IF[663..741] 
			05.05.2015	Denk	 OPC handling part added for OPC DA values from VIS
			29.01.2016	Denk	 Bugfix, IF658 IN_CU.rVol_GT factor 10 and limit 15000 changed
V04.04.0	02.11.2016	lettenb. bResetRemBus added
V04.04.1	23.03.2017  Zengerer rPr_Ch_P2s_Avg  IF625	bost pressure UNIT CHANGED to 1/100bar according to IF docu - Poppe Norber
V04.06.0	05.07.2018	Perktold InData2.Bit14 and 15 reserved for (very) fast start preparation
V04.07.2	18.09.2019	Zengerer Bugfix counter MOD 32767 calculation IF536 - IF544
V04.11.0	17.03.2022	Zengerer OUT_CU.rCust_IF[742] to OUT_CU.rCust_IF[744] prepared
V04.12.0	26.08.2022	Zengerer IF626 Pos_GM_Set_Norm * 100 ChangedScaling from V4.12 on ->#810)
			16.01.2023	Perktold Message 1138 - Adaption with Issue#741
			14.03.2023	Zengerer Compatibility fix bOpt_Compatible_OpHoursFormat, to switch back to compatible OpHr Customer interface for plants operation mixed ><V4.07 engine versions (corr. calculation IF536 - IF544)
V4.13.00.00	19.09.2023	Zengerer remove ALL IN_CU.bMsgxxxx single bits and replace by array (Issue #1033, TKE enhancement) 
			08.12.2023	Denk	 Customer bus coupling with OPC UA
V04.14.0 	25.11.2024	Zengerer 32bit combined UDINT Counter compatibility Para.iOpt_Compatible_OpHoursFormat, to switch back between OpHr Customer interface options (<>V4.07 engine versions (corr. calculation IF536 - IF544)


Instructions for use:
--------------------
use Para.iOpt_Compatible_OpHoursFormat to select interface COMPATIBILITY OPTION for all 32bit counter values: IF536 to IF544
----------------------------------------------------------------------------------------------------------------------------
0 (default) -> for plants with adopted signed int logic ( HighWord*32767 + LowWord ) implemented on customer client (like in V4.07 to V4.13)  
1 replaces former bOpt_Compatible_OpHoursFormat = TRUE option, use only for plants with <V4.07 engine mix configurations and previous adopted compatible customer logic
2 optional behavior with 32bit counter = HighWord 16bit & LowWord 16bit (UNSIGNED, ignore sign bits)
			
Outstandings:
------------
- 

*******************************************************************)

PROGRAM _CYCLIC

	(*----------------------------------------------------------------------------------------*)
	(* Copy several interfaces to local variables *)
	iPr_ECWScalMax			:=	REAL_TO_INT(Para.rPr_ECWScalMax * 100);								(* See IF502 *)
	iPr_EngLubOilScalMax	:=	REAL_TO_INT(Para.rPr_EngLubOilScalMax * 100);						(* See IF504 *)
	iT_Gen_Wind_Act			:=  REAL_TO_INT(IN_CU.rT_Gen_Wind_Act * 10);							(* See IF606 *)
	iT_Gen_Wind_Act_L1		:= 	REAL_TO_INT(IN_CU.rT_Gen_Wind_Act_L1 * 10);							(* See IF606 *)
	iT_Gen_Wind_Act_L2		:= 	REAL_TO_INT(IN_CU.rT_Gen_Wind_Act_L2 * 10);							(* See IF607 *)
	iT_Gen_Wind_Act_L3		:= 	REAL_TO_INT(IN_CU.rT_Gen_Wind_Act_L3 * 10);							(* See IF608 *)
	iPos_GM_Set_Norm		:=	REAL_TO_INT(IN_CU.rPos_GM_Set_Norm * 1000);							(* See IF626 !ChangedScaling in V4.12 #810! *)
	iLam_Eng_LL_Set			:=	REAL_TO_INT(IN_CU.rLam_Eng_LL_Set * 1000);							(* See IF631 *)
		
	bOpt_Compatible_OpHoursFormat;// := FALSE;		(*OLD, do not use anymore, replaced by Para  (always FALSE. Set to TRUE in case engine is running together with other Jenbacher engines with SW version <4.07 only, 
//												to avoid upgrading existing customer plant interfaces implementation with client side correction calculation at counter IF536 - IF544 *)

	(*----------------------------------------------------------------
	/* #####################   OutData Register   ####################
	/* #######      PROFIBUS, PROFINET, MODBUS RTU/TCP       #########
	/* NOTE: Connect your variables here FOR customer bus system
	/*        
	/* #####################   		START		  #####################
	/*---------------------------------------------------------------*)

	(*----------------------------------------------------------------------------------------*)
	(* OutData[0..13] ... compress and copy bMsg1001 to bMsg1224 *)
	(* in module Coupling task outData *)

	(*----------------------------------------------------------------------------------------*)
	(* OutData[14] *)
	(* in module Coupling task outData *)

	(*----------------------------------------------------------------------------------------*)
	(* OutData[15] *)    
	bData[0]:=  IN_CU.bGCB_DemSy;				(* IF441 Demand synchronization generator circuit breaker  *)	
	bData[1]:=  IN_CU.bMCB_DemSy;				(* IF442 Demand synchronization mains circuit breaker  *)
	bData[2]:=  FALSE;							(* IF443 Spare *)
	bData[3]:=  IN_CU.tEng_Rdy_Rem.Do;			(* IF444 Ready for remote operation *)				
	bData[4]:=  IN_CU.bEng_Aux_Dem_CDR;			(* IF445 Engine auxiliaries demand*)				
	bData[5]:=  IN_CU.tGCB_On.Di;				(* IF446 Generator circuit breaker closed *)
	bData[6]:=  IN_CU.tMCB_On.Di;				(* IF447 Mains circuit breaker closed *)
	bData[7]:=  IN_CU.bEng_Dem;					(* IF448 Demand engine *)							
	bData[8]:=  IN_CU.tEng_Run.Do;				(* IF449 Engine running *)							
	bData[9]:=  bOMSS_Man;						(* IF450 Operation mode selector switch MANUAL *)
	bData[10]:= bOMSS_Aut;						(* IF451 Operation mode selector switch AUTOMATIC *)
	bData[11]:= bGnlTrip;						(* IF452 General TRIP *)
	bData[12]:= bGnlWarning;					(* IF453 General WARNING *)
	bData[13]:= FALSE;							(* IF454 Spare *)
	bData[14]:= IN_CU.tImp_OpHour.Do;			(* IF455 Impulse for operation hour counter *)		
	bData[15]:= IN_CU.bImp_Start;				(* IF456 Impulse for start counter *)				

	srcAdr:= ADR(bData);
	dstAdr:= ADR(OutData);
	idxMin:= 15;
	idxMax:= 15;
	CompressAndCopy;	

	(*----------------------------------------------------------------------------------------*)
	(* OutData[16..22] ... compress and copy bMsg2001 to bMsg2112 *)
	(* in module Coupling task outData *)

	(*----------------------------------------------------------------------------------------*)
	(* OutData[23] *)
	bData[0]:=  IN_CU.bMsg[2113];					(* IF2113 Spare *)
	bData[1]:=  IN_CU.bMsg[2114];					(* IF2114 Preheating pump failure *)
	bData[2]:=  IN_CU.bMsg[2115];					(* IF2115 Generator voltage regulator failure *)
	bData[3]:=  IN_CU.bMsg[2116];					(* IF2116 Dump radiator failure *)
	bData[4]:=  IN_CU.bMsg[2117];					(* IF2117 Charge cooler water pressure low *)
	bData[5]:=  IN_CU.bMsg[2118];					(* IF2118 Charge cooling water pump failure *)
	bData[6]:=  IN_CU.bMsg[2119];					(* IF2119 Charge cooler failure *)
	bData[7]:=  IN_CU.bMsg[2795] OR IN_CU.bMsg[2796] OR IN_CU.bMsg[2120];	(* IF2120 Engine room ventilation failure | Adaption with Issue#741*)
	bData[8]:=  IN_CU.bMsg[2501];					(* IF2501 Generator rotating diode failure *)
	bData[9]:=  IN_CU.bMsg[2571];					(* IF2571 Overvoltage protection auxiliaries supply failure *)
	bData[10]:= IN_CU.bMsg[2572];					(* IF2572 Failure uninterrupted power supply (UPS) *)
	bData[11]:= IN_CU.bMsg[2573];					(* IF2573 Overvoltage protection generator failure *)
	bData[12]:= IN_CU.bReady4FastStart;			(* IF562 Ready for fast start *)
	bData[13]:= IN_CU.bReady4VeryFastStart;		(* IF563 Ready for very fast start *)
	bData[14]:= FALSE;							(* IF... Reserve *)
	bData[15]:= FALSE;							(* IF... Reserve *)			

	srcAdr:= ADR(bData);
	dstAdr:= ADR(OutData);
	idxMin:= 23;
	idxMax:= 23;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[24] *)
	bData[0]:=  FALSE;(* Spare *)
	bData[1]:=  FALSE;(* Spare *)
	bData[2]:=  FALSE;(* Spare *)
	bData[3]:=  FALSE;(* Spare *)
	bData[4]:=  FALSE;(* Spare *)
	bData[5]:=  FALSE;(* Spare *)
	bData[6]:=  FALSE;(* Spare *)
	bData[7]:=  FALSE;(* Spare *)
	bData[8]:=  FALSE;(* Spare *)
	bData[9]:=  FALSE;(* Spare *)
	bData[10]:= FALSE;(* Spare *)
	bData[11]:= FALSE;(* Spare *)
	bData[12]:= FALSE;(* Spare *)
	bData[13]:= FALSE;(* Spare *)
	bData[14]:= FALSE;(* Spare *)
	bData[15]:= FALSE;(* Spare *)

	srcAdr:= ADR(bData);
	dstAdr:= ADR(OutData);
	idxMin:= 24;
	idxMax:= 24;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[25] *)
	bData[0]:=  FALSE;(* Spare *)
	bData[1]:=  FALSE;(* Spare *)
	bData[2]:=  FALSE;(* Spare *)
	bData[3]:=  FALSE;(* Spare *)
	bData[4]:=  FALSE;(* Spare *)
	bData[5]:=  FALSE;(* Spare *)
	bData[6]:=  FALSE;(* Spare *)
	bData[7]:=  FALSE;(* Spare *)
	bData[8]:=  FALSE;(* Spare *)
	bData[9]:=  FALSE;(* Spare *)
	bData[10]:= FALSE;(* Spare *)
	bData[11]:= FALSE;(* Spare *)
	bData[12]:= FALSE;(* Spare *)
	bData[13]:= FALSE;(* Spare *)
	bData[14]:= FALSE;(* Spare *)
	bData[15]:= FALSE;(* Spare *)

	srcAdr:= ADR(bData);
	dstAdr:= ADR(OutData);
	idxMin:= 25;
	idxMax:= 25;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[26] *)
	bData[0]:=  FALSE;(* Spare *)
	bData[1]:=  FALSE;(* Spare *)
	bData[2]:=  FALSE;(* Spare *)
	bData[3]:=  FALSE;(* Spare *)
	bData[4]:=  FALSE;(* Spare *)
	bData[5]:=  FALSE;(* Spare *)
	bData[6]:=  FALSE;(* Spare *)
	bData[7]:=  FALSE;(* Spare *)
	bData[8]:=  FALSE;(* Spare *)
	bData[9]:=  FALSE;(* Spare *)
	bData[10]:= FALSE;(* Spare *)
	bData[11]:= FALSE;(* Spare *)
	bData[12]:= FALSE;(* Spare *)
	bData[13]:= FALSE;(* Spare *)
	bData[14]:= FALSE;(* Spare *)
	bData[15]:= FALSE;(* Spare *)

	srcAdr:= ADR(bData);
	dstAdr:= ADR(OutData);
	idxMin:= 26;
	idxMax:= 26;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[27] *)
	bData[0]:=  FALSE;(* Spare *)
	bData[1]:=  FALSE;(* Spare *)
	bData[2]:=  FALSE;(* Spare *)
	bData[3]:=  FALSE;(* Spare *)
	bData[4]:=  FALSE;(* Spare *)
	bData[5]:=  FALSE;(* Spare *)
	bData[6]:=  FALSE;(* Spare *)
	bData[7]:=  FALSE;(* Spare *)
	bData[8]:=  FALSE;(* Spare *)
	bData[9]:=  FALSE;(* Spare *)
	bData[10]:= FALSE;(* Spare *)
	bData[11]:= FALSE;(* Spare *)
	bData[12]:= FALSE;(* Spare *)
	bData[13]:= FALSE;(* Spare *)
	bData[14]:= FALSE;(* Spare *)
	bData[15]:= FALSE;(* Spare *)

	srcAdr:= ADR(bData);
	dstAdr:= ADR(OutData);
	idxMin:= 27;
	idxMax:= 27;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[28] *)
	bData[0]:=  FALSE;(* Spare *)
	bData[1]:=  FALSE;(* Spare *)
	bData[2]:=  FALSE;(* Spare *)
	bData[3]:=  FALSE;(* Spare *)
	bData[4]:=  FALSE;(* Spare *)
	bData[5]:=  FALSE;(* Spare *)
	bData[6]:=  FALSE;(* Spare *)
	bData[7]:=  FALSE;(* Spare *)
	bData[8]:=  FALSE;(* Spare *)
	bData[9]:=  FALSE;(* Spare *)
	bData[10]:= FALSE;(* Spare *)
	bData[11]:= FALSE;(* Spare *)
	bData[12]:= FALSE;(* Spare *)
	bData[13]:= FALSE;(* Spare *)
	bData[14]:= FALSE;(* Spare *)
	bData[15]:= FALSE;(* Spare *)

	srcAdr:= ADR(bData);
	dstAdr:= ADR(OutData);
	idxMin:= 28;
	idxMax:= 28;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[29] *)
	bData[0]:=  FALSE;(* Spare *)
	bData[1]:=  FALSE;(* Spare *)
	bData[2]:=  FALSE;(* Spare *)
	bData[3]:=  FALSE;(* Spare *)
	bData[4]:=  FALSE;(* Spare *)
	bData[5]:=  FALSE;(* Spare *)
	bData[6]:=  FALSE;(* Spare *)
	bData[7]:=  FALSE;(* Spare *)
	bData[8]:=  FALSE;(* Spare *)
	bData[9]:=  FALSE;(* Spare *)
	bData[10]:= FALSE;(* Spare *)
	bData[11]:= FALSE;(* Spare *)
	bData[12]:= FALSE;(* Spare *)
	bData[13]:= FALSE;(* Spare *)
	bData[14]:= FALSE;(* Spare *)
	bData[15]:= FALSE;(* Spare *)

	srcAdr:= ADR(bData);
	dstAdr:= ADR(OutData);
	idxMin:= 29;
	idxMax:= 29;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[30] *)
	bData[0]:=  FALSE;							(* IF546 Spare *)
	bData[1]:=  FALSE;							(* IF547 Spare *)
	bData[2]:=  FALSE;							(* IF548 Spare *)
	bData[3]:=  FALSE;							(* IF549 Spare *)
	bData[4]:=  FALSE;							(* IF550 Spare *)
	bData[5]:=  FALSE;							(* IF551 Spare *)		
	bData[6]:=  FALSE;							(* IF552 Spare *)
	bData[7]:=  FALSE;							(* IF553 Spare *)
	bData[8]:=  FALSE;							(* IF554 Spare *)
	bData[9]:=  FALSE;							(* IF555 Spare *)
	bData[10]:= FALSE;							(* IF556 Spare *)
	bData[11]:= FALSE;							(* IF557 Spare *)
	bData[12]:= FALSE;							(* IF558 Spare *)
	bData[13]:= FALSE;							(* IF559 Spare *)			
	bData[14]:= FALSE;							(* IF560 Spare *)
	bData[15]:= FALSE;							(* IF561 Spare *)

	srcAdr:= ADR(bData);
	dstAdr:= ADR(OutData);
	idxMin:= 30;
	idxMax:= 30;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[31] *)
	bData[0]:=  FALSE;							(* IF591 Spare *)
	bData[1]:=  FALSE;							(* IF592 Spare *)
	bData[2]:=  FALSE;							(* IF593 Spare *)
	bData[3]:=  FALSE;							(* IF594 Spare *)
	bData[4]:=  FALSE;							(* IF595 Spare *)
	bData[5]:=  FALSE;							(* IF596 Spare *)
	bData[6]:=  FALSE;							(* IF597 Spare *)
	bData[7]:=  FALSE;							(* IF598 Spare *)
	bData[8]:=  xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[9]:=  xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[10]:= xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[11]:= xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[12]:= xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[13]:= xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[14]:= xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[15]:= xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)

	srcAdr:= ADR(bData);
	dstAdr:= ADR(OutData);
	idxMin:= 31;
	idxMax:= 31;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[32..45] ... compress and copy bMsg3001 to bMsg3224 *)
	(* in module Coupling task outData *)

	(*----------------------------------------------------------------------------------------*)
	(* OutData[46..51] ... compress and copy bMsg3301 to bMsg3396 *)
	(* in module Coupling task outData *)

	(*----------------------------------------------------------------------------------------*)
	(* OutData[52..62] ... compress and copy bMsg3401 to bMsg3576 *)
	(* in module Coupling task outData *)

	(*----------------------------------------------------------------------------------------*)
	(* OutData[63] *)
	bData[0]:=  FALSE;							(* IF... Spare *)
	bData[1]:=  FALSE;							(* IF... Spare *)
	bData[2]:=  FALSE;							(* IF... Spare *)
	bData[3]:=  FALSE;							(* IF... Spare *)
	bData[4]:=  FALSE;							(* IF... Spare *)
	bData[5]:=  FALSE;							(* IF... Spare *)
	bData[6]:=  FALSE;							(* IF... Spare *)
	bData[7]:=  FALSE;							(* IF... Spare *)
	bData[8]:=  xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[9]:=  xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[10]:= xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[11]:= xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[12]:= xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[13]:= xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[14]:= xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)
	bData[15]:= xTON_CLOCK_1.Q;					(* IF600 BUSALIVE signal *)

	srcAdr:= ADR(bData);
	dstAdr:= ADR(OutData);
	idxMin:= 63;
	idxMax:= 63;
	CompressAndCopy;

	(*----------------------------------------------------------------------------------------*)
	(* OutData[64..191] *)
	IF IN_CU.tGCB_On.Di THEN 
		OutData[64]:= REAL_TO_INT(IN_CU.rP_Act[1]);													(* IF500	active power				*)												
	ELSE
		OutData[64]:= 0;
	END_IF;
	OutData[65]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_ECW * 10),			1200);					(* IF501	jacket water temperature	*)
	OutData[66]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rPr_ECW * 100), 		iPr_ECWScalMax);		(* IF502	jacket water pressure		*)
	OutData[67]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EO * 10), 			1200);					(* IF503	oil temperature				*)
	OutData[68]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rPr_EngLubOil * 100), iPr_EngLubOilScalMax);	(* IF504	oil pressure				*)
	OutData[69]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EGaTC * 10), 		10000);					(* IF505	exh.gas temp.after engine	*)
	OutData[70]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EGaHE * 10), 		10000);					(* IF506	exh.gas temp.aft.heat exch. *)				
	OutData[71]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_PlateHE * 10), 	10000);					(* IF507	plate temp.exh.gas heat exc.*)
	OutData[72]:= LIMIT(0,			REAL_TO_INT(IN_CU.rT_EG_Avg), 			1000);					(* IF508	cyl.exh.gas temp.average v. *)
	OutData[73]:= LIMIT(0,			REAL_TO_INT(IN_CU.rT_HW_Re * 10), 		1200);					(* IF509	return water temperature	*)
	OutData[74]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_HW_Su * 10), 	  	2000);					(* IF510	supply water temperature	*)
	OutData[75]:= LIMIT(-999, 		REAL_TO_INT(IN_CU.rPF_Act[1] * 1000),	1000);					(* IF511	generator power factor		*)
	OutData[76]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rF_MMD[1] * 10), 		700);					(* IF512	generator frequency			*)
	IF IN_CU.tGCB_On.Di THEN
		OutData[77]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.rI_Avg[1]), 	  	  	32000);					(* IF513	gen.current average value	*)
	ELSE
		OutData[77]:= 0;
	END_IF;
	OutData[78]:= LIMIT(-32000,		REAL_TO_INT(IN_CU.rU_Avg[1]),	   	    32000);					(* IF514	gen.voltage average value	*)
	OutData[79]:= LIMIT(-32000,		value, 									32000);					(* IF515	spare						*)
	OutData[80]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[1]),		1000);					(* IF516	cyl. 1 exh.gas temp.		*)
	OutData[81]:= LIMIT(0,			REAL_TO_INT(IN_CU.rT_EPU_EG[2]),		1000);					(* IF517	cyl. 2 exh.gas temp.		*)
	OutData[82]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[3]),		1000);					(* IF518	cyl. 3 exh.gas temp.		*)
	OutData[83]:= LIMIT(0,	 		REAL_TO_INT(IN_CU.rT_EPU_EG[4]),		1000);					(* IF519	cyl. 4 exh.gas temp.		*)
	OutData[84]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[5]),		1000);					(* IF520	cyl. 5 exh.gas temp.		*)
	OutData[85]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[6]),		1000);					(* IF521	cyl. 6 exh.gas temp.		*)
	OutData[86]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[7]),		1000);					(* IF522	cyl. 7 exh.gas temp.		*)
	OutData[87]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[8]),		1000);					(* IF523	cyl. 8 exh.gas temp.		*)
	OutData[88]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[9]),		1000);					(* IF524	cyl. 9 exh.gas temp.		*)
	OutData[89]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[10]),		1000);					(* IF525	cyl.10 exh.gas temp.		*)
	OutData[90]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[11]),		1000);					(* IF526	cyl.11 exh.gas temp.		*)
	OutData[91]:= LIMIT(0,	 		REAL_TO_INT(IN_CU.rT_EPU_EG[12]),		1000);					(* IF527	cyl.12 exh.gas temp.		*)
	OutData[92]:= LIMIT(0,	 		REAL_TO_INT(IN_CU.rT_EPU_EG[13]),		1000);					(* IF528	cyl.13 exh.gas temp.		*)
	OutData[93]:= LIMIT(0,	 		REAL_TO_INT(IN_CU.rT_EPU_EG[14]),		1000);					(* IF529	cyl.14 exh.gas temp.		*)
	OutData[94]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[15]),		1000);					(* IF530	cyl.15 exh.gas temp.		*)
	OutData[95]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[16]),		1000);					(* IF531	cyl.16 exh.gas temp.		*)
	OutData[96]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[17]),		1000);					(* IF532	cyl.17 exh.gas temp.		*)
	OutData[97]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[18]),		1000);					(* IF533	cyl.18 exh.gas temp.		*)
	OutData[98]:= LIMIT(0,	 		REAL_TO_INT(IN_CU.rT_EPU_EG[19]),		1000);					(* IF534	cyl.19 exh.gas temp.		*)
	OutData[99]:= LIMIT(0, 			REAL_TO_INT(IN_CU.rT_EPU_EG[20]),		1000);					(* IF535	cyl.20 exh.gas temp.		*)


	
	//IF bOpt_Compatible_OpHoursFormat THEN Para.iOpt_Compatible_OpHoursFormat := 1; END_IF  (*OLD, do not use this bit anymore*)
	CASE Para.iOpt_Compatible_OpHoursFormat OF  (*select interface COMPATIBILITY OPTION: PARA[PARA[15081]  0=default option for plants with signed int customer logic (HW*32767+LW) *)
	2:  				(* using true 32bit logic (for mix with old XT - XT3 series):  -> 32bit counter (UNSIGNED) = HighWord UINT & LowWord UINT *)
		iP_WorkAct_H := UDINT_TO_UINT( REAL_TO_UDINT(ABS(IN_CU.rP_WorkAct[1])*10)    / 65536 );
		iP_WorkAct_L := UDINT_TO_UINT( REAL_TO_UDINT(ABS(IN_CU.rP_WorkAct[1])*10)  MOD 65536 );		
		brsmemcpy(ADR(OutData[100]), ADR(iP_WorkAct_H), 2);											(* IF536	bytecopy option UDINT TO INT   -total act.P  outp.high word	*) 
		brsmemcpy(ADR(OutData[101]), ADR(iP_WorkAct_L), 2);		    								(* IF537	bytecopy option UDINT TO INT   -total act.P  outp.low word	*) 

		iQ_WorkReac_H := UDINT_TO_UINT( REAL_TO_UDINT(ABS(IN_CU.rQ_WorkReac[1])*10)    / 65536 );
		iQ_WorkReac_L := UDINT_TO_UINT( REAL_TO_UDINT(ABS(IN_CU.rQ_WorkReac[1])*10)  MOD 65536 );		
		brsmemcpy(ADR(OutData[102]), ADR(iQ_WorkReac_H), 2);										(* IF538	bytecopy option UDINT TO DINT   -total react.Q outp.high word *)
		brsmemcpy(ADR(OutData[103]), ADR(iQ_WorkReac_L), 2);										(* IF539	bytecopy option UDINT TO DINT   -total react.Q outp.low word	*) 
		
		iCnt_OpHours_H := UDINT_TO_UINT(IN_CU.iCnt_OpHours    / 65536);
		iCnt_OpHours_L := UDINT_TO_UINT(IN_CU.iCnt_OpHours  MOD 65536);
		brsmemcpy(ADR(OutData[105]), ADR(iCnt_OpHours_H), 2); 										(* IF541	bytecopy option for direct UINT TO INT transfer   -oper.hours count.high word	*)
		brsmemcpy(ADR(OutData[106]), ADR(iCnt_OpHours_L), 2); 										(* IF542	bytecopy option for direct UINT TO INT transfer   -oper.hours count.low word	*) 
	
		iCnt_Starts_H := UDINT_TO_UINT(REAL_TO_UDINT(IN_CU.iCnt_Starts)    / 65536);
		iCnt_Starts_L := UDINT_TO_UINT(REAL_TO_UDINT(IN_CU.iCnt_Starts)  MOD 65536);
		brsmemcpy(ADR(OutData[107]), ADR(iCnt_Starts_H), 2); 										(* IF543	bytecopy option for direct UINT TO INT transfer   -start counter    high word	*)
		brsmemcpy(ADR(OutData[108]), ADR(iCnt_Starts_L), 2); 										(* IF544	bytecopy option for direct UINT TO INT transfer   - start counter    high word	*) 
	1:				(* COMPATIIBILITY OPTION 1 for Plants with <V4.07 engines and previous adoptet compatible customer logic *)	
		OutData[100]:= DINT_TO_INT(REAL_TO_DINT(IN_CU.rP_WorkAct[1]*10)    / 65536);			    (* IF536	COMPATIBILITY OPTION for Customisations < V4.7.x  -total act.  outp.high word	*) 
		OutData[101]:= DINT_TO_INT(REAL_TO_DINT(IN_CU.rP_WorkAct[1]*10)  MOD 65536);		    	(* IF537	COMPATIBILITY OPTION for Customisations < V4.7.x  -total act.  outp.low word	*) 
		OutData[102]:= DINT_TO_INT(REAL_TO_DINT(IN_CU.rQ_WorkReac[1]*10)   / 65536);				(* IF538	COMPATIBILITY OPTION for Customisations < V4.7.x  -total react.outp.high word 	*) 
		OutData[103]:= DINT_TO_INT(REAL_TO_DINT(IN_CU.rQ_WorkReac[1]*10) MOD 65536);				(* IF539	COMPATIBILITY OPTION for Customisations < V4.7.x  -total react.outp.low word	*) 
		
		OutData[105]:= DINT_TO_INT(IN_CU.iCnt_OpHours / 65536);										(* IF541	COMPATIBILITY OPTION for Customisations < V4.7.x  -oper.hours count.high word	*) 
		OutData[106]:= DINT_TO_INT(IN_CU.iCnt_OpHours MOD 65536);									(* IF542	COMPATIBILITY OPTION for Customisations < V4.7.x  -oper.hours count.low word	*) 
		OutData[107]:= DINT_TO_INT(IN_CU.iCnt_Starts / 65536);										(* IF543	COMPATIBILITY OPTION for Customisations < V4.7.x  -start counter    high word	*) 
		OutData[108]:= DINT_TO_INT(IN_CU.iCnt_Starts MOD 65536);									(* IF544	COMPATIBILITY OPTION for Customisations < V4.7.x  -start counter    high word	*) 
	ELSE		(* 0: (or undefined): DEFAULT OPTION for plants with 30bit customer logic (HW*32767+LW) (XT4 standard since V4.07, avoiding unintended negative value display)*)								
		OutData[100]:= DINT_TO_INT(REAL_TO_DINT(IN_CU.rP_WorkAct[1]*10)    / 32767);			    (* IF536	total P act. outp.high word (Counter reading = multiply IF536 by 3276,7Kwh and then add IF537/10 , to get KWh with 1 position after decimal point )	*) 
		OutData[101]:= DINT_TO_INT(REAL_TO_DINT(IN_CU.rP_WorkAct[1]*10)  MOD 32767);		    	(* IF537	total P act. outp.low word	*) 	
		OutData[102]:= DINT_TO_INT(REAL_TO_DINT(IN_CU.rQ_WorkReac[1]*10)   / 32767);				(* IF538	total React. outp.high word	(Counter reading = multiply IF538 by 3276,7KVAh and then add IF539/10 , to get KVAh with 1 position after decimal point ) *)	
		OutData[103]:= DINT_TO_INT(REAL_TO_DINT(IN_CU.rQ_WorkReac[1]*10) MOD 32767);				(* IF539	total act.  outp.low word	*) 

		OutData[105]:= DINT_TO_INT(IN_CU.iCnt_OpHours / 32767);										(* IF541	oper.hours count.high word	(Counter reading = multiply IF541 by 32767 and then add IF542 , to get counter ) *) 	
		OutData[106]:= DINT_TO_INT(IN_CU.iCnt_OpHours MOD 32767);									(* IF542	oper.hours count.low word	*) 	
		OutData[107]:= DINT_TO_INT(IN_CU.iCnt_Starts / 32767);										(* IF543	start counter    high word	(Counter reading = multiply IF543 by 32767 and then add IF544 , to get counter ) *) 	
		OutData[108]:= DINT_TO_INT(IN_CU.iCnt_Starts MOD 32767);									(* IF544	start counter    low word	*) 
	END_CASE
	

	OutData[104]:= REAL_TO_INT(IN_CU.rP_Set);														(* IF540	setpoint power control		*)

	OutData[109]:= LIMIT(-32000,	value,										32000);				(* IF545	spare						*)
	OutData[110]:= LIMIT(-32000,	value,							   	  		32000);				(* IF... 	spare						*)
	OutData[111]:= LIMIT(-32000,	value,									    32000);				(* IF...	spare						*)
	OutData[112]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rT_Ch_T2s_Avg * 10),		1200);				(* IF601	fuel mixture temperature	*)
	OutData[113]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rT_EGbCat * 10),			10000);				(* IF602	exh.gas temp.before cat.	*)
	OutData[114]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rT_EGaCat * 10),			10000);				(* IF603	exh.gas temp.after  cat.	*)
	OutData[115]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rT_Cat * 10),				10000);				(* IF604	catalyst temperature		*)
	OutData[116]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rU_Gen_Exc * 10),			1000);				(* IF605	gen.excitation voltage		*)
	IF Para.bT_Gen_Wind_Ena THEN
		OutData[117]:= LIMIT(	0,	iT_Gen_Wind_Act_L1, 						2000);				(* IF606	gen.winding temp.L1			*)
	ELSE
		OutData[117]:= LIMIT(	0,	iT_Gen_Wind_Act, 							2000);				(* IF606	gen.winding temp.L1			*)
	END_IF;
	OutData[118]:= LIMIT(0, 		iT_Gen_Wind_Act_L2,							2000);				(* IF607	gen.winding temp.L2			*)
	OutData[119]:= LIMIT(0, 		iT_Gen_Wind_Act_L3,							2000);				(* IF608	gen.winding temp.L3			*)
	OutData[120]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rT_Gen_Bear_A_Act * 10),	2000);				(* IF609	gen.bearing temp.(A)		*)
	OutData[121]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rT_Gen_Bear_B_Act * 10),	2000);				(* IF610	gen.bearing temp.(B)		*)
	OutData[122]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rN_EngAct), 				2100);				(* IF611	engine speed				*)
	OutData[123]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rU_L1N[1]), 				32000);				(* IF612	gen.voltage	L1-N			*)
	OutData[124]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rU_L2N[1]), 				32000);				(* IF613	gen.voltage	L2-N			*)
	OutData[125]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rU_L3N[1]), 				32000);				(* IF614	gen.voltage	L3-N			*)
	OutData[126]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rU_L1L2[1]), 				32000);				(* IF615	gen.voltage	L1-L2			*)
	OutData[127]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rU_L2L3[1]), 				32000);				(* IF616	gen.voltage	L2-L3			*)
	OutData[128]:= LIMIT(0, 		REAL_TO_INT(IN_CU.rU_L3L1[1]), 				32000);				(* IF617	gen.voltage	L3-L1			*)
	OutData[129]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.rP_Act[1]), 	  		 	32000);				(* IF618	gen.active power			*)
	OutData[130]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.rQ_Act[1]), 	 		  	32000);				(* IF619	gen.reactive power			*)
	OutData[131]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.rS_Act[1]),			    32000);				(* IF620	gen.apparent power			*)
	OutData[132]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.rI_L1[1]), 			    32000);				(* IF621	gen.current L1				*)		
	OutData[133]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.rI_L2[1]), 			    32000);				(* IF622	gen.current L2				*)
	OutData[134]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.rI_L3[1]), 			   	32000);				(* IF623	gen.current L3				*)
	OutData[135]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.rI_N[1]), 			   	32000);				(* IF624	gen.neutral current 		*)
	OutData[136]:= LIMIT(0,			REAL_TO_INT(IN_CU.rPr_Ch_P2s_Avg * 100),  	1200);				(* IF625	bost pressure	V4.4: UNIT CHANGED to 1/100bar 	 		*)
	OutData[137]:= LIMIT(0,			iPos_GM_Set_Norm, 							2000);				(* IF626	gas mixer position	 		*)
	OutData[138]:= LIMIT(0,			REAL_TO_INT(IN_CU.rPos_TV * 1000), 		 	1000);				(* IF627	throttle valve position	 	*)			
	OutData[139]:= LIMIT(0,			REAL_TO_INT(IN_CU.rPos_CBV * 1000), 		1000);				(* IF628	turbo charger byp.position 	*)
	OutData[140]:= LIMIT(0,			REAL_TO_INT(IN_CU.rT_EGbTC * 10), 			10000);				(* IF629	exh.gas temp.before turbo 	*)											
	OutData[141]:= LIMIT(0,			REAL_TO_INT(IN_CU.rEO_Level * 1000), 		1000);				(* IF630	oil level					*)
	OutData[142]:= LIMIT(1000,		iLam_Eng_LL_Set, 							2500);				(* IF631	lambda TECJET				*)
	OutData[143]:= LIMIT(-32000,	value,									  	32000);				(* IF632	spare						*)				
	OutData[144]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[1].Ai *10), 	32000);				(* IF633	customer spare Analog IN 1	*)
	OutData[145]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[2].Ai *10),	32000);				(* IF634	customer spare Analog IN 2	*)
	OutData[146]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[3].Ai *10),  	32000);				(* IF635	customer spare Analog IN 3	*)
	OutData[147]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[4].Ai *10), 	32000);				(* IF636	customer spare Analog IN 4	*)
	OutData[148]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[5].Ai *10), 	32000);				(* IF637	customer spare Analog IN 5	*)
	OutData[149]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[6].Ai *10), 	32000);				(* IF638	customer spare Analog IN 6	*)
	OutData[150]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[7].Ai *10), 	32000);				(* IF639	customer spare Analog IN 7	*)
	OutData[151]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[8].Ai *10), 	32000);				(* IF640	customer spare Analog IN 8	*)
	OutData[152]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[9].Ai *10), 	32000);				(* IF641	customer spare Analog IN 9	*)
	OutData[153]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[10].Ai *10), 	32000);				(* IF642	customer spare Analog IN 10	*)
	OutData[154]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[11].Ai *10),  	32000);				(* IF643	customer spare Analog IN 11	*)				
	OutData[155]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[12].Ai *10),  	32000);				(* IF644	customer spare Analog IN 12	*)	
	OutData[156]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[13].Ai *10),  	32000);				(* IF645	customer spare Analog IN 13	*)
	OutData[157]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[14].Ai *10),  	32000);				(* IF646	customer spare Analog IN 14	*)	
	OutData[158]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[15].Ai *10),  	32000);				(* IF647	customer spare Analog IN 15	*)
	OutData[159]:= LIMIT(-32000,	REAL_TO_INT(IN_CU.tCustAnaIn[16].Ai *10),  	32000);				(* IF648	customer spare Analog IN 16	*)
	OutData[160]:= LIMIT(0,			REAL_TO_INT(IN_CU.rT_AirER * 10), 			1200);				(* IF649	room temperature			*)
	OutData[161]:= LIMIT(0,			REAL_TO_INT(IN_CU.rPr_PCG * 100), 			1000);				(* IF650	pre chamber gas pressure	*)
	OutData[162]:= LIMIT(0,			REAL_TO_INT(IN_CU.rT_Ch_T1LP_Avg * 10), 	1200);  			(* IF651	charge temp. before LP TC	*) (* --> engine intake air) *)
	OutData[163]:= LIMIT(-500,		REAL_TO_INT(IN_CU.rPr_PC_Diff * 100), 		500);				(* IF652	pre chamber diff.pressure	*)
	OutData[164]:= LIMIT(0,			REAL_TO_INT(IN_CU.rGT_CH4 * 1000), 			1000);				(* IF653	CH4 content					*)
	OutData[165]:= LIMIT(0,			REAL_TO_INT(IN_CU.rPr_GT_Gas * 100), 		400);				(* IF654	gas pressure				*)
	OutData[166]:= LIMIT(-150,		REAL_TO_INT(IN_CU.rPr_GT_Suct * 100), 	 	0);					(* IF655	suction pressure			*)
	OutData[167]:= LIMIT(0,			REAL_TO_INT(IN_CU.rGT_O2 * 1000), 			2500);				(* IF656	O2 content					*)			
	OutData[168]:= LIMIT(0,			REAL_TO_INT(IN_CU.rT_GT * 10), 				1000);				(* IF657	gas temperature				*)
	OutData[169]:= LIMIT(0,			REAL_TO_INT(IN_CU.rVol_GT * 10), 			15000);				(* IF658	gas quantity				*)	
	OutData[170]:= LIMIT(0,			REAL_TO_INT(IN_CU.rT_HW_ReAfEC * 10), 		2000);				(* IF659	ret.wat.temp.after cooler	*)	
	OutData[171]:= LIMIT(0,			REAL_TO_INT(IN_CU.rT_EGaHE1 * 10), 			10000);				(* IF660	exh.gas temp.aft.heat exch.1*)
	OutData[172]:= LIMIT(0,			REAL_TO_INT(IN_CU.rT_EGaHE2 * 10), 			10000);				(* IF661	exh.gas temp.aft.heat exch.2*)
	OutData[173]:= LIMIT(-1000,		REAL_TO_INT(IN_CU.rT_AirOutdoor * 10),  	1000);				(* IF662	outdoor temperature			*)
	OutData[174]:= LIMIT(value,     						   		  	 -32000,32000);				(* IF663	spare						*)
	OutData[175]:= LIMIT(value,     						   			 -32000,32000);				(* IF664	spare						*)
	OutData[176]:= LIMIT(value,     						   			 -32000,32000);				(* IF665	spare						*)
	OutData[177]:= LIMIT(value,     						   			 -32000,32000);				(* IF666	spare						*)
	OutData[178]:= LIMIT(value,     						   		 	 -32000,32000);				(* IF667	spare						*)
	OutData[179]:= LIMIT(value,     						  			 -32000,32000);				(* IF668	spare						*)
	OutData[180]:= LIMIT(value,     						  			 -32000,32000);				(* IF669	spare						*)
	OutData[181]:= LIMIT(value,     						   		 	 -32000,32000);				(* IF670	spare						*)
	OutData[182]:= LIMIT(value,     						   			 -32000,32000);				(* IF671	spare						*)
	OutData[183]:= LIMIT(value,     						   			 -32000,32000);				(* IF672	spare						*)
	OutData[184]:= LIMIT(REAL_TO_INT(IN_CU.rT_EPU_EG[21]), 					 0, 1000);				(* IF673	cyl.21 exh.gas temp.		*)
	OutData[185]:= LIMIT(REAL_TO_INT(IN_CU.rT_EPU_EG[22]), 					 0, 1000);				(* IF674	cyl.22 exh.gas temp.		*)
	OutData[186]:= LIMIT(REAL_TO_INT(IN_CU.rT_EPU_EG[23]), 				 	 0, 1000);				(* IF675	cyl.23 exh.gas temp.		*)
	OutData[187]:= LIMIT(REAL_TO_INT(IN_CU.rT_EPU_EG[24]), 					 0, 1000);				(* IF676	cyl.24 exh.gas temp.		*)
	OutData[188]:= LIMIT(value,     						   	 		 -32000,32000);				(* IF677	spare						*)
	OutData[189]:= LIMIT(value,     						   			 -32000,32000);				(* IF678	spare						*)
	OutData[190]:= LIMIT(value,     						   			 -32000,32000);				(* IF679	spare						*)
	OutData[191]:= LIMIT(value,     						   			 -32000,32000);				(* IF680	spare						*)

	(*----------------------------------------------------------------
	/* #####################   OutData Register   ####################
	/* #######      PROFIBUS, PROFINET, MODBUS RTU/TCP       #########
	/*        
	/* #####################   		END			#####################
	/*---------------------------------------------------------------*)


	(*----------------------------------------------------------------
	/* #####################   InData Register   #####################
	/* #######      PROFIBUS, PROFINET, MODBUS RTU/TCP       #########
	/* NOTE: Connect your variables here FOR customer bus system
	/*        
	/* #####################   		START		 #####################
	/*---------------------------------------------------------------*)
	IF NOT Para.bOPC_Rcv_Ena THEN

		(*----------------------------------------------------------------------------------------*)	
		(* InData[0] *)
		xWDtoBIT_InData1.Word		:= INT_TO_UINT(IN_CU.InData1[0]);
		xWDtoBIT_InData1;
	
		(* xWDtoBIT_InData1.Bit00 is processed in module Coupling task inData *)(* IF701	Demand Module					*)
//		OUT_CU.bResetRemBus      := xWDtoBIT_InData1.Bit01;						(* IF702	Demand remote reset via field bus *)(* prepared for future *)
		bConnectYourVariableHere := xWDtoBIT_InData1.Bit01;						(* IF702	Demand spare 					*)
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit02;						(* IF703	Demand spare 					*)
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit03;						(* IF704	Demand spare 					*)					
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit04;						(* IF705	Demand spare 					*)
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit05;						(* IF706	Demand spare 					*)
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit06;						(* IF707	Demand spare 					*)
		(* xWDtoBIT_InData1.Bit07 is processed in module Coupling task inData *)(* IF708	BUSALIVE signal					*)								
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit08;						(* IF709	spare							*)
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit09;						(* IF710	spare							*)		
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit10;						(* IF711	spare							*)
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit11;						(* IF712	spare							*)		
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit12;						(* IF713	spare							*)
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit13;						(* IF714	spare							*)		
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit14; 					(* IF715	spare 						    *)	
		bConnectYourVariableHere :=	xWDtoBIT_InData1.Bit15;						(* IF716	spare							*)		
	
		(*----------------------------------------------------------------------------------------*)	
		(* InData[1] *)
		xWDtoBIT_InData2.Word		:= INT_TO_UINT(IN_CU.InData1[1]);
		xWDtoBIT_InData2;
	
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit00;						(* IFxxx 	spare							*)	
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit01;
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit02;
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit03;
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit04;
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit05;
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit06;
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit07;	
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit08;
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit09;
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit10;
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit11;
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit12;
		bConnectYourVariableHere := xWDtoBIT_InData2.Bit13;
		(* 	xWDtoBIT_InData2.Bit14 is processed in module Coupling task inData*)(* IF731	Demand preparation for very fast start *)	
		(* 	xWDtoBIT_InData2.Bit15 is processed in module Coupling task inData *)(* IF732	Demand preparation for fast start *)	
	
		(*----------------------------------------------------------------------------------------*)	
		(* InData[2] *)
		(* InData[2] is processed in module Coupling task inData *)				(* IF740	Set point for Generator power		*)
		
		(*----------------------------------------------------------------------------------------*)	
		(* InData[3]*)
		iConnectYourVariableHere := 		IN_CU.InData1[3];									(* IF741	Set point spare		= BUS_ANA1		*)										
		OUT_CU.rCust_IF[741] 	:=	INT_TO_REAL(IN_CU.InData1[3]) * Para.rCustFactor_IF[741] ;	(* IF741	Set point spare		= BUS_ANA1		*)										
		//MM2VIS.rCustVis[3] 	:= OUT_CU.rCust_IF[741] ;  //TO DO: activate, if necessary	
	
		(*----------------------------------------------------------------------------------------*)	
		(* InData[4]*)
		iConnectYourVariableHere := 		IN_CU.InData1[4];									(* IF742	Set point spare		= BUS_ANA2		*)										
		OUT_CU.rCust_IF[742] 	:=	INT_TO_REAL(IN_CU.InData1[4]) * Para.rCustFactor_IF[742] ;	(* IF742	Set point spare		= BUS_ANA2		*)										
		//MM2VIS.rCustVis[4] 	:= OUT_CU.rCust_IF[742] ;  //TO DO: activate, if necessary	
	
		(*----------------------------------------------------------------------------------------*)	
		(* InData[5]*)
		iConnectYourVariableHere := 		IN_CU.InData1[5];									(* IF743	Set point spare		= BUS_ANA3		*)										
		OUT_CU.rCust_IF[743] 	:=	INT_TO_REAL(IN_CU.InData1[5]) * Para.rCustFactor_IF[743] ;	(* IF743	Set point spare		= BUS_ANA3		*)										
		//MM2VIS.rCustVis[5] 	:= OUT_CU.rCust_IF[743] ;  //TO DO: activate, if necessary
	
		(*----------------------------------------------------------------------------------------*)	
		(* InData[6]*)
		iConnectYourVariableHere := 		IN_CU.InData1[6];									(* IF744	Set point spare		= BUS_ANA4		*)										
		OUT_CU.rCust_IF[744] 	:=	INT_TO_REAL(IN_CU.InData1[6]) * Para.rCustFactor_IF[744] ;	(* IF744	Set point spare		= BUS_ANA4		*)										
		//MM2VIS.rCustVis[6] 	:= OUT_CU.rCust_IF[744] ;  //TO DO: activate, if necessary
	
		(*----------------------------------------------------------------------------------------*)	
		(* InData[7]*)
		iConnectYourVariableHere :=			IN_CU.InData1[7];							(* IF745	Set point spare						*)
		OUT_CU.rCust_IF[745]; 	(*spare; add own function, if interface is used*) 
		(*----------------------------------------------------------------------------------------*)	
		(* InData[8]*)
		iConnectYourVariableHere := 		IN_CU.InData1[8];							(* IF746	Set point spare						*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* InData[9]*)
		iConnectYourVariableHere := 		IN_CU.InData1[9];							(* IF747	Set point spare						*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* InData[10]*)
		iConnectYourVariableHere := 		IN_CU.InData1[10];							(* IF748	Set point spare						*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* InData[11]*)
		iConnectYourVariableHere := 		IN_CU.InData1[11];							(* IF749	Set point spare						*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* InData[12]*)
		iConnectYourVariableHere := 		IN_CU.InData1[12];							(* IF750	Set point spare						*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* InData[13]*)
		iConnectYourVariableHere := 		IN_CU.InData1[13];							(* IF751	Set point spare						*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* InData[14]*)
		iConnectYourVariableHere := 		IN_CU.InData1[14];							(* IF752	Set point spare						*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* InData[15]*)
		iConnectYourVariableHere := 		IN_CU.InData1[15];							(* IF753	Set point spare						*)										
		OUT_CU.rCust_IF[753]; (*spare*)
(*		OUT_CU.rHum_GasIn_Abs 	 := 		INT_TO_REAL(IN_CU.InData1[15]) / 10;		(* IF753	absolute humidity gas [g H2O/kg dry gas	= BUS_ANA1		*)										
		 
	END_IF;

	(*----------------------------------------------------------------
	/* #####################   InData Register   #####################
	/* #######      PROFIBUS, PROFINET, MODBUS RTU/TCP       #########
	/*       
	/* #####################   		END			######################
	/*---------------------------------------------------------------*)



	(*----------------------------------------------------------------
	/* #####################   OutData Register   ####################
	/* ########################    OPC DA    #########################
	/* NOTE: Connect your variables here FOR customer bus system
	/*        
	/* #####################   		START		  ####################
	/*---------------------------------------------------------------*)
	
	(*----------------------------------------------------------------*)
	(* IF546 - IF561 spare BOOL variables  *)
	MM2VIS.bCustOPC[1]  := bConnectYourVariableHere;								(* IF546 Spare *)
	MM2VIS.bCustOPC[2]  := bConnectYourVariableHere;								(* IF547 Spare *)
	MM2VIS.bCustOPC[3]  := bConnectYourVariableHere;								(* IF548 Spare *)
	MM2VIS.bCustOPC[4]  := bConnectYourVariableHere;								(* IF549 Spare *)
	MM2VIS.bCustOPC[5]  := bConnectYourVariableHere;								(* IF550 Spare *)
	MM2VIS.bCustOPC[6]  := bConnectYourVariableHere;								(* IF551 Spare *)		
	MM2VIS.bCustOPC[7]  := bConnectYourVariableHere;								(* IF552 Spare *)
	MM2VIS.bCustOPC[8]  := bConnectYourVariableHere;								(* IF553 Spare *)
	MM2VIS.bCustOPC[9]  := bConnectYourVariableHere;								(* IF554 Spare *)
	MM2VIS.bCustOPC[10] := bConnectYourVariableHere;								(* IF555 Spare *)
	MM2VIS.bCustOPC[11] := bConnectYourVariableHere;								(* IF556 Spare *)
	MM2VIS.bCustOPC[12] := bConnectYourVariableHere;								(* IF557 Spare *)
	MM2VIS.bCustOPC[13] := bConnectYourVariableHere;								(* IF558 Spare *)
	MM2VIS.bCustOPC[14] := bConnectYourVariableHere;								(* IF559 Spare *)			
	MM2VIS.bCustOPC[15] := bConnectYourVariableHere;								(* IF560 Spare *)
	MM2VIS.bCustOPC[16] := bConnectYourVariableHere;								(* IF561 Spare *)
	
	(*----------------------------------------------------------------*)
	(* IF663 - IF680 spare REAL variables *)
	MM2VIS.rCustOPC[1]  := rConnectYourVariableHere;								(* IF663 Spare	*)
	MM2VIS.rCustOPC[2]  := rConnectYourVariableHere;								(* IF664 Spare	*)			
	MM2VIS.rCustOPC[3]  := rConnectYourVariableHere;								(* IF665 Spare	*)					
	MM2VIS.rCustOPC[4]  := rConnectYourVariableHere;								(* IF666 Spare	*)					
	MM2VIS.rCustOPC[5]  := rConnectYourVariableHere;								(* IF667 Spare	*)				
	MM2VIS.rCustOPC[6]  := rConnectYourVariableHere;								(* IF668 Spare	*)					
	MM2VIS.rCustOPC[7]  := rConnectYourVariableHere;								(* IF669 Spare	*)				
	MM2VIS.rCustOPC[8]  := rConnectYourVariableHere;								(* IF670 Spare	*)					
	MM2VIS.rCustOPC[9]  := rConnectYourVariableHere;								(* IF671 Spare	*)					
	MM2VIS.rCustOPC[10] := rConnectYourVariableHere;								(* IF672 Spare	*)					
	MM2VIS.rCustOPC[11] := IN_CU.rT_EPU_EG[21];										(* IF673 cyl.21 exh.gas temp.	*)
	MM2VIS.rCustOPC[12] := IN_CU.rT_EPU_EG[22];										(* IF674 cyl.22 exh.gas temp.	*)
	MM2VIS.rCustOPC[13] := IN_CU.rT_EPU_EG[23];										(* IF675 cyl.23 exh.gas temp.	*)
	MM2VIS.rCustOPC[14] := IN_CU.rT_EPU_EG[24];										(* IF676 cyl.24 exh.gas temp.	*)
	MM2VIS.rCustOPC[15] := rConnectYourVariableHere;								(* IF677 Spare	*)					
	MM2VIS.rCustOPC[16] := rConnectYourVariableHere;								(* IF678 Spare	*)					
	MM2VIS.rCustOPC[17] := rConnectYourVariableHere;								(* IF679 Spare	*)					
	MM2VIS.rCustOPC[18] := rConnectYourVariableHere;								(* IF680 Spare	*)					
	
	(*----------------------------------------------------------------
	/* #####################   OutData Register   ####################
	/* ########################    OPC DA    #########################
	/*        
	/* #####################   		 END		 #####################
	/*---------------------------------------------------------------*)


	(*----------------------------------------------------------------
	/* #####################   InData Register   #####################
	/* ########################    OPC DA    #########################
	/* NOTE: Connect your variables here FOR customer bus system
	/*          
	/* #####################   		START		 #####################
	/*---------------------------------------------------------------*)
	
	IF Para.bOPC_Rcv_Ena THEN		
		(*----------------------------------------------------------------------------------------*)
		(* IF702 - IF707 spare BOOL variables  *)
		(* is processed in module Coupling task inData *)					(* IF701	Demand Module	*)
		bConnectYourVariableHere := VIS2MM.bCustOPC[1];						(* IF702	Spare 			*)
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[2];						(* IF703	Spare 			*)
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[3];						(* IF704	Spare 			*)					
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[4];						(* IF705	Spare 			*)
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[5];						(* IF706	Spare			*)
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[6];						(* IF707	Spare 			*)
		(* is processed in module Coupling task inData *)					(* IF708	BUSALIVE signal	*)								
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[7];						(* IF709	Spare			*)
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[8];						(* IF710	Spare			*)		
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[9];						(* IF711	Spare			*)
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[10];					(* IF712	Spare			*)		
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[11];					(* IF713	Spare			*)
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[12];					(* IF714	Spare			*)		
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[13];					(* IF715	Spare			*)	
		bConnectYourVariableHere :=	VIS2MM.bCustOPC[14];					(* IF716	Spare			*)												
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF740 *)
		(* is processed in module Coupling task inData *)					(* IF740	Set point for Generator power *)
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF741 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[1];						(* IF741	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF742 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[2];						(* IF742	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF743 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[3];						(* IF743	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF744 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[4];						(* IF744	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF745 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[5];						(* IF745	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF746 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[6];						(* IF746	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF747 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[7];						(* IF747	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF748 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[8];						(* IF748	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF749 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[9];						(* IF749	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF750 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[10];					(* IF750	Set point spare *)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF751 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[11];					(* IF751	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF752 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[12];					(* IF752	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF753 *)
		rConnectYourVariableHere := VIS2MM.rCustOPC[13];					(* IF753	Set point spare	*)																		
		
	END_IF;

	(*----------------------------------------------------------------
	/* #####################   InData Register   #####################
	/* ########################    OPC DA    #########################
	/*       
	/* #####################   		END			#####################
	/*---------------------------------------------------------------*)
	
	
	(*----------------------------------------------------------------
	/* ########################    OPC UA    #########################
	/* NOTE: Connect your variables here FOR customer bus system
	/*        
	/* #####################   		START		  ####################
	/*---------------------------------------------------------------*)
	
	(* Buz1_Sys4_Plc3 *)
	(* Activation/Deactivation of user role Customer shall be with done with OPC UA Set method *)
	Para.bComm_OpcUa_Active;
	
	(* Copy all messages 0..9000 to OPC UA variable structure *)
	tEng2Cust.tMessages.bMsg := IN_CU.bMsg;
	
	(* IF433, IF434, IF441 - IF445, IF454 - IF456 no standard messages *)
	tEng2Cust.tMessages.bEng_Rdy_Rem := IN_CU.tEng_Rdy_Rem.Do;			(* IF433 Ready for remote operation *)
	tEng2Cust;															(* IF434 *)
	tEng2Cust.tMessages.bGCB_DemSy := IN_CU.bGCB_DemSy;					(* IF441 Demand synchronization generator circuit breaker  *)	
	tEng2Cust.tMessages.bMCB_DemSy := IN_CU.bMCB_DemSy;					(* IF442 Demand synchronization mains circuit breaker  *)
	tEng2Cust;															(* IF443 Spare *)
	tEng2Cust.tMessages.bEng_Rdy_Rem := IN_CU.tEng_Rdy_Rem.Do;			(* IF444 Ready for remote operation, ident to 433 *)				
	tEng2Cust.tMessages.bEng_Aux_Dem_CDR :=  IN_CU.bEng_Aux_Dem_CDR;	(* IF445 Engine auxiliaries demand *)			
	tEng2Cust;															(* IF454 Spare *)
	tEng2Cust.tMessages.bImp_OpHour:= IN_CU.tImp_OpHour.Do;				(* IF455 Impulse for operation hour counter *)		
	tEng2Cust.tMessages.bImp_Start := IN_CU.bImp_Start;					(* IF456 Impulse for start counter *)	
	
	
	(* IF500 - IF545 Standard interfaces *)
	IF IN_CU.tGCB_On.Di THEN 
		tEng2Cust.tValues.rP_Act[1] := IN_CU.rP_Act[1];			(* IF500	active power				*)												
	ELSE
		tEng2Cust.tValues.rP_Act[1] := 0;
	END_IF;
	tEng2Cust.tValues.rT_ECW := IN_CU.rT_ECW;					(* IF501	jacket water temperature	*)
	tEng2Cust.tValues.rPr_ECW := IN_CU.rPr_ECW;					(* IF502	jacket water pressure		*)
	tEng2Cust.tValues.rT_EO := IN_CU.rT_EO;						(* IF503	oil temperature				*)
	tEng2Cust.tValues.rPr_EngLubOil := IN_CU.rPr_EngLubOil; 	(* IF504	oil pressure				*)
	tEng2Cust.tValues.rT_EGaTC := IN_CU.rT_EGaTC;				(* IF505	exh.gas temp.after engine	*)
	tEng2Cust.tValues.rT_EGaHE := IN_CU.rT_EGaHE;				(* IF506	exh.gas temp.aft.heat exch. *)				
	tEng2Cust.tValues.rT_PlateHE := IN_CU.rT_PlateHE;			(* IF507	plate temp.exh.gas heat exc.*)
	tEng2Cust.tValues.rT_EG_Avg := IN_CU.rT_EG_Avg ;			(* IF508	cyl.exh.gas temp.average v. *)
	tEng2Cust.tValues.rT_HW_Re := IN_CU.rT_HW_Re;				(* IF509	return water temperature	*)
	tEng2Cust.tValues.rT_HW_Su := IN_CU.rT_HW_Su;				(* IF510	supply water temperature	*)
	tEng2Cust.tValues.rPF_Act[1] := IN_CU.rPF_Act[1];			(* IF511	generator power factor		*)
	tEng2Cust.tValues.rF_MMD[1] := IN_CU.rF_MMD[1];				(* IF512	generator frequency			*)
	IF IN_CU.tGCB_On.Di THEN
		tEng2Cust.tValues.rI_Avg[1] := IN_CU.rI_Avg[1];			(* IF513	gen.current average value	*)
	ELSE
		tEng2Cust.tValues.rI_Avg[1]:= 0;
	END_IF;
	tEng2Cust.tValues.rU_Avg[1] := IN_CU.rU_Avg[1];					(* IF514	gen.voltage average value	*)
	tEng2Cust.tValues;												(* IF515	spare						*)
	tEng2Cust.tValues.rT_EPU_EG[1] := IN_CU.rT_EPU_EG[1];			(* IF516	cyl. 1 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[2] := IN_CU.rT_EPU_EG[2];			(* IF517	cyl. 2 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[3] := IN_CU.rT_EPU_EG[3];			(* IF518	cyl. 3 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[4] := IN_CU.rT_EPU_EG[4];			(* IF519	cyl. 4 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[5] := IN_CU.rT_EPU_EG[5];			(* IF520	cyl. 5 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[6] := IN_CU.rT_EPU_EG[6];			(* IF521	cyl. 6 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[7] := IN_CU.rT_EPU_EG[7];			(* IF522	cyl. 7 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[8] := IN_CU.rT_EPU_EG[8];			(* IF523	cyl. 8 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[9] := IN_CU.rT_EPU_EG[9];			(* IF524	cyl. 9 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[10] := IN_CU.rT_EPU_EG[10];		(* IF525	cyl.10 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[11] := IN_CU.rT_EPU_EG[11];		(* IF526	cyl.11 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[12] := IN_CU.rT_EPU_EG[12];		(* IF527	cyl.12 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[13] := IN_CU.rT_EPU_EG[13];		(* IF528	cyl.13 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[14] := IN_CU.rT_EPU_EG[14];		(* IF529	cyl.14 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[15] := IN_CU.rT_EPU_EG[15];		(* IF530	cyl.15 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[16] := IN_CU.rT_EPU_EG[16];		(* IF531	cyl.16 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[17] := IN_CU.rT_EPU_EG[17];		(* IF532	cyl.17 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[18] := IN_CU.rT_EPU_EG[18];		(* IF533	cyl.18 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[19] := IN_CU.rT_EPU_EG[19];		(* IF534	cyl.19 exh.gas temp.		*)
	tEng2Cust.tValues.rT_EPU_EG[20] := IN_CU.rT_EPU_EG[20];		(* IF535	cyl.20 exh.gas temp.		*)
	tEng2Cust.tValues.rP_WorkAct[1] := IN_CU.rP_WorkAct[1];		(* IF536/IF537	total actual output		*)
	tEng2Cust.tValues.rQ_WorkReac[1] := IN_CU.rQ_WorkReac[1];	(* IF538/IF539	total reactive output	*)
	tEng2Cust.tValues.rP_Set := IN_CU.rP_Set;								(* IF540	setpoint power control		*)
	tEng2Cust.tValues.iCnt_OpHours:= IN_CU.iCnt_OpHours;					(* IF541	oper.hours count.			*)
	tEng2Cust.tValues.iCnt_Starts:= IN_CU.iCnt_Starts;						(* IF543	start counter 				*)
	tEng2Cust.tValues.iMaintenanceCount[1]:=  VIS2MM.iMaintenanceCount1;		(* IF544.1	Maintenance counter 1		*)
	tEng2Cust.tValues.iMaintenanceCount[2]:=  VIS2MM.iMaintenanceCount2;		(* IF544.2	Maintenance counter 2		*)
	tEng2Cust.tValues.iMaintenanceCount[3]:=  VIS2MM.iMaintenanceCount3;		(* IF544.3	Maintenance counter 3		*)
	tEng2Cust.tValues.iMaintenanceCount[4]:=  VIS2MM.iMaintenanceCount4;		(* IF544.4	Maintenance counter 4		*)
	tEng2Cust.tValues.iMaintenanceCount[5]:=  VIS2MM.iMaintenanceCount5;		(* IF544.5	Maintenance counter 5		*)
	tEng2Cust.tValues.iMaintenanceCount[6]:=  VIS2MM.iMaintenanceCount6;		(* IF544.6	Maintenance counter 6		*)
	tEng2Cust.tValues.iMaintenanceCount[7]:=  VIS2MM.iMaintenanceCount7;		(* IF544.7	Maintenance counter 7		*)
	tEng2Cust.tValues.iMaintenanceCount[8]:=  VIS2MM.iMaintenanceCount8;		(* IF544.8	Maintenance counter 8		*)
	tEng2Cust.tValues.iCount[1] := VIS2MM.iCount1;								(* IF545.1	Spare counter 1	*)
	tEng2Cust.tValues.iCount[2] := VIS2MM.iCount2;								(* IF545.2	Spare counter 2	*)
	tEng2Cust.tValues.iCount[3] := VIS2MM.iCount3;								(* IF545.3	Spare counter 3	*)
	tEng2Cust.tValues.iCount[4] := VIS2MM.iCount4;								(* IF545.4	Spare counter 4	*)
	tEng2Cust.tValues.iCount[5] := VIS2MM.iCount5;								(* IF545.5	Spare counter 5	*)
	tEng2Cust.tValues.iCount[6] := VIS2MM.iCount6;								(* IF545.6	Spare counter 6	*)
	tEng2Cust.tValues.iCount[7] := VIS2MM.iCount7;								(* IF545.7	Spare counter 7	*)
	tEng2Cust.tValues.iCount[8] := VIS2MM.iCount8;								(* IF545.8	Spare counter 8	*)
	tEng2Cust.tValues.iCount[9] := VIS2MM.iCount9;								(* IF545.9	Spare counter 9	*)
	tEng2Cust.tValues.iCount[10] := VIS2MM.iCount10;							(* IF545.10	Spare counter 10 *)
	
	(* IF546 - IF561 spare BOOL variables  *)
	tEng2Cust.tSpare.bCustDigOpcUa[1]  := bConnectYourVariableHere;								(* IF546 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[2]  := bConnectYourVariableHere;								(* IF547 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[3]  := bConnectYourVariableHere;								(* IF548 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[4]  := bConnectYourVariableHere;								(* IF549 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[5]  := bConnectYourVariableHere;								(* IF550 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[6]  := bConnectYourVariableHere;								(* IF551 Spare *)		
	tEng2Cust.tSpare.bCustDigOpcUa[7]  := bConnectYourVariableHere;								(* IF552 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[8]  := bConnectYourVariableHere;								(* IF553 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[9]  := bConnectYourVariableHere;								(* IF554 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[10] := bConnectYourVariableHere;								(* IF555 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[11] := bConnectYourVariableHere;								(* IF556 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[12] := bConnectYourVariableHere;								(* IF557 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[13] := bConnectYourVariableHere;								(* IF558 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[14] := bConnectYourVariableHere;								(* IF559 Spare *)			
	tEng2Cust.tSpare.bCustDigOpcUa[15] := bConnectYourVariableHere;								(* IF560 Spare *)
	tEng2Cust.tSpare.bCustDigOpcUa[16] := bConnectYourVariableHere;								(* IF561 Spare *)
	
	(* IF600 Keep alive signal *)
	tEng2Cust.tValues.bImpClock := xTON_CLOCK_1.Q;							(* IF600 Alive signal *);
	
	(* IF601 - IF662 Standard interfaces *)
	tEng2Cust.tValues.rT_Ch_T2s_Avg := IN_CU.rT_Ch_T2s_Avg;					(* IF601	fuel mixture temperature	*)
	tEng2Cust.tValues.rT_EGbCat := IN_CU.rT_EGbCat;							(* IF602	exh.gas temp.before cat.	*)
	tEng2Cust.tValues.rT_EGaCat := IN_CU.rT_EGaCat;							(* IF603	exh.gas temp.after  cat.	*)
	tEng2Cust.tValues.rT_Cat := IN_CU.rT_Cat;								(* IF604	catalyst temperature		*)
	tEng2Cust.tValues.rU_Gen_Exc := IN_CU.rU_Gen_Exc;						(* IF605	gen.excitation voltage		*)
	IF Para.bT_Gen_Wind_Ena THEN
		tEng2Cust.tValues.rT_Gen_Wind_Act_L1 := IN_CU.rT_Gen_Wind_Act_L1;	(* IF606	gen.winding temp.L1			*)
	ELSE
		tEng2Cust.tValues.rT_Gen_Wind_Act := IN_CU.rT_Gen_Wind_Act;			(* IF606	gen.winding temp.L1			*)
	END_IF;
	tEng2Cust.tValues.rT_Gen_Wind_Act_L2 := IN_CU.rT_Gen_Wind_Act_L2;		(* IF607	gen.winding temp.L2			*)
	tEng2Cust.tValues.rT_Gen_Wind_Act_L3 := IN_CU.rT_Gen_Wind_Act_L3;		(* IF608	gen.winding temp.L3			*)
	tEng2Cust.tValues.rT_Gen_Bear_A_Act :=IN_CU.rT_Gen_Bear_A_Act;			(* IF609	gen.bearing temp.(A)		*)
	tEng2Cust.tValues.rT_Gen_Bear_B_Act :=IN_CU.rT_Gen_Bear_B_Act;			(* IF610	gen.bearing temp.(B)		*)
	tEng2Cust.tValues.rN_EngAct :=IN_CU.rN_EngAct;							(* IF611	engine speed				*)
	tEng2Cust.tValues.rU_L1N[1] :=IN_CU.rU_L1N[1];							(* IF612	gen.voltageL1-N				*)
	tEng2Cust.tValues.rU_L2N[1] :=IN_CU.rU_L2N[1];							(* IF613	gen.voltageL2-N				*)
	tEng2Cust.tValues.rU_L3N[1] :=IN_CU.rU_L3N[1];							(* IF614	gen.voltageL3-N				*)
	tEng2Cust.tValues.rU_L1L2[1] :=IN_CU.rU_L1L2[1];						(* IF615	gen.voltageL1-L2			*)
	tEng2Cust.tValues.rU_L2L3[1] :=IN_CU.rU_L2L3[1];						(* IF616	gen.voltageL2-L3			*)
	tEng2Cust.tValues.rU_L3L1[1] :=IN_CU.rU_L3L1[1];						(* IF617	gen.voltageL3-L1			*)
	tEng2Cust.tValues.rP_Act[1] :=IN_CU.rP_Act[1];							(* IF618	gen.active power			*)
	tEng2Cust.tValues.rQ_Act[1] :=IN_CU.rQ_Act[1];							(* IF619	gen.reactive power			*)
	tEng2Cust.tValues.rS_Act[1] :=IN_CU.rS_Act[1];							(* IF620	gen.apparent power			*)
	tEng2Cust.tValues.rI_L1[1] :=IN_CU.rI_L1[1];							(* IF621	gen.current L1				*)
	tEng2Cust.tValues.rI_L2[1] :=IN_CU.rI_L2[1];							(* IF622	gen.current L2				*)
	tEng2Cust.tValues.rI_L3[1] :=IN_CU.rI_L3[1];							(* IF623	gen.current L3				*)
	tEng2Cust.tValues.rI_N[1] :=IN_CU.rI_N[1];								(* IF624	gen.neutral current 		*)
	tEng2Cust.tValues.rPr_Ch_P2s_Avg := IN_CU.rPr_Ch_P2s_Avg;				(* IF625	bost pressure	V4.4: UNIT CHANGED to 1/100bar 	 *)
	tEng2Cust.tValues.rPos_GM_Set_Norm := IN_CU.rPos_GM_Set_Norm;			(* IF626	gas mixer position	 		*)
	tEng2Cust.tValues.rPos_TV := IN_CU.rPos_TV;								(* IF627	throttle valve position	 	*)			
	tEng2Cust.tValues.rPos_CBV	:= IN_CU.rPos_CBV;							(* IF628	turbo charger byp.position 	*)
	tEng2Cust.tValues.rT_EGbTC := IN_CU.rT_EGbTC;							(* IF629	exh.gas temp.before turbo 	*)											
	tEng2Cust.tValues.rEO_Level := IN_CU.rEO_Level;							(* IF630	oil level					*)
	tEng2Cust.tValues.rLam_Eng_LL_Set := IN_CU.rLam_Eng_LL_Set;				(* IF631	lambda TECJET				*)
	tEng2Cust.tValues;														(* IF632	spare						*)	
	tEng2Cust.tValues.tCustAnaIn[1] := IN_CU.tCustAnaIn[1];				(* IF633	customer spare Analog IN 1	*)
	tEng2Cust.tValues.tCustAnaIn[2] := IN_CU.tCustAnaIn[2];				(* IF634	customer spare Analog IN 2	*)
	tEng2Cust.tValues.tCustAnaIn[3] := IN_CU.tCustAnaIn[3];				(* IF635	customer spare Analog IN 3	*)
	tEng2Cust.tValues.tCustAnaIn[4] := IN_CU.tCustAnaIn[4];				(* IF636	customer spare Analog IN 4	*)
	tEng2Cust.tValues.tCustAnaIn[5] := IN_CU.tCustAnaIn[5];				(* IF637	customer spare Analog IN 5	*)
	tEng2Cust.tValues.tCustAnaIn[6] := IN_CU.tCustAnaIn[6];				(* IF638	customer spare Analog IN 6	*)
	tEng2Cust.tValues.tCustAnaIn[7] := IN_CU.tCustAnaIn[7];				(* IF639	customer spare Analog IN 7	*)
	tEng2Cust.tValues.tCustAnaIn[8] := IN_CU.tCustAnaIn[8];				(* IF640	customer spare Analog IN 8	*)
	tEng2Cust.tValues.tCustAnaIn[9] := IN_CU.tCustAnaIn[9];				(* IF641	customer spare Analog IN 9	*)
	tEng2Cust.tValues.tCustAnaIn[10] := IN_CU.tCustAnaIn[10];				(* IF642	customer spare Analog IN 10	*)
	tEng2Cust.tValues.tCustAnaIn[11] := IN_CU.tCustAnaIn[11];				(* IF643	customer spare Analog IN 11	*)
	tEng2Cust.tValues.tCustAnaIn[12] := IN_CU.tCustAnaIn[12];				(* IF644	customer spare Analog IN 12	*)
	tEng2Cust.tValues.tCustAnaIn[13] := IN_CU.tCustAnaIn[13];				(* IF645	customer spare Analog IN 13	*)
	tEng2Cust.tValues.tCustAnaIn[14] := IN_CU.tCustAnaIn[14];				(* IF646	customer spare Analog IN 14	*)
	tEng2Cust.tValues.tCustAnaIn[15] := IN_CU.tCustAnaIn[15];				(* IF647	customer spare Analog IN 15	*)
	tEng2Cust.tValues.tCustAnaIn[16] := IN_CU.tCustAnaIn[16];				(* IF648	customer spare Analog IN 16	*)
	tEng2Cust.tValues.rT_AirER := IN_CU.rT_AirER;							(* IF649	room temperature			*)
	tEng2Cust.tValues.rPr_PCG := IN_CU.rPr_PCG;								(* IF650	pre chamber gas pressure	*)
	tEng2Cust.tValues.rT_Ch_T1LP_Avg := IN_CU.rT_Ch_T1LP_Avg;  				(* IF651	charge temp. before LP TC	*) (* --> engine intake air) *)
	tEng2Cust.tValues.rPr_PC_Diff := IN_CU.rPr_PC_Diff;						(* IF652	pre chamber diff.pressure	*)
	tEng2Cust.tValues.rGT_CH4 := IN_CU.rGT_CH4;								(* IF653	CH4 content					*)
	tEng2Cust.tValues.rPr_GT_Gas := IN_CU.rPr_GT_Gas;						(* IF654	gas pressure				*)
	tEng2Cust.tValues.rPr_GT_Suct := IN_CU.rPr_GT_Suct;						(* IF655	suction pressure			*)
	tEng2Cust.tValues.rGT_O2 := IN_CU.rGT_O2;								(* IF656	O2 content					*)			
	tEng2Cust.tValues.rT_GT := IN_CU.rT_GT;									(* IF657	gas temperature				*)
	tEng2Cust.tValues.rVol_GT := IN_CU.rVol_GT;								(* IF658	gas quantity				*)	
	tEng2Cust.tValues.rT_HW_ReAfEC := IN_CU.rT_HW_ReAfEC;					(* IF659	ret.wat.temp.after cooler	*)	
	tEng2Cust.tValues.rT_EGaHE1 := IN_CU.rT_EGaHE1;							(* IF660	exh.gas temp.aft.heat exch.1*)
	tEng2Cust.tValues.rT_EGaHE2 := IN_CU.rT_EGaHE2;							(* IF661	exh.gas temp.aft.heat exch.2*)
	tEng2Cust.tValues.rT_AirOutdoor := IN_CU.rT_AirOutdoor;					(* IF662	outdoor temperature			*)

	(* IF663 - IF680 spare REAL variables *)
	tEng2Cust.tSpare.rCustAnaOpcUa[1]  := rConnectYourVariableHere;								(* IF663 Spare	*)
	tEng2Cust.tSpare.rCustAnaOpcUa[2]  := rConnectYourVariableHere;								(* IF664 Spare	*)			
	tEng2Cust.tSpare.rCustAnaOpcUa[3]  := rConnectYourVariableHere;								(* IF665 Spare	*)					
	tEng2Cust.tSpare.rCustAnaOpcUa[4]  := rConnectYourVariableHere;								(* IF666 Spare	*)					
	tEng2Cust.tSpare.rCustAnaOpcUa[5]  := rConnectYourVariableHere;								(* IF667 Spare	*)				
	tEng2Cust.tSpare.rCustAnaOpcUa[6]  := rConnectYourVariableHere;								(* IF668 Spare	*)					
	tEng2Cust.tSpare.rCustAnaOpcUa[7]  := rConnectYourVariableHere;								(* IF669 Spare	*)				
	tEng2Cust.tSpare.rCustAnaOpcUa[8]  := rConnectYourVariableHere;								(* IF670 Spare	*)					
	tEng2Cust.tSpare.rCustAnaOpcUa[9]  := rConnectYourVariableHere;								(* IF671 Spare	*)					
	tEng2Cust.tSpare.rCustAnaOpcUa[10] := rConnectYourVariableHere;								(* IF672 Spare	*)					
	tEng2Cust.tSpare.rCustAnaOpcUa[11] := IN_CU.rT_EPU_EG[21];									(* IF673 cyl.21 exh.gas temp.	*)
	tEng2Cust.tSpare.rCustAnaOpcUa[12] := IN_CU.rT_EPU_EG[22];									(* IF674 cyl.22 exh.gas temp.	*)
	tEng2Cust.tSpare.rCustAnaOpcUa[13] := IN_CU.rT_EPU_EG[23];									(* IF675 cyl.23 exh.gas temp.	*)
	tEng2Cust.tSpare.rCustAnaOpcUa[14] := IN_CU.rT_EPU_EG[24];									(* IF676 cyl.24 exh.gas temp.	*)
	tEng2Cust.tSpare.rCustAnaOpcUa[15] := rConnectYourVariableHere;								(* IF677 Spare	*)					
	tEng2Cust.tSpare.rCustAnaOpcUa[16] := rConnectYourVariableHere;								(* IF678 Spare	*)					
	tEng2Cust.tSpare.rCustAnaOpcUa[17] := rConnectYourVariableHere;								(* IF679 Spare	*)					
	tEng2Cust.tSpare.rCustAnaOpcUa[18] := rConnectYourVariableHere;								(* IF680 Spare	*)	
					
	
	(* Control/Write variables *)
	IF Para.bComm_OpcUa_Active THEN		
		(*----------------------------------------------------------------------------------------*)
		(* IF702 - IF707 spare BOOL variables  *)
		OUT_CU.bBus_Dem_OpcUa    :=	tCust2Eng.tControl.bBus_Dem_OpcUa;			(* IF701	Demand Module	*)
		bConnectYourVariableHere := tCust2Eng.tSpare.bCustDigOpcUa[1];			(* IF702	Spare 			*)
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[2];			(* IF703	Spare 			*)
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[3];			(* IF704	Spare 			*)					
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[4];			(* IF705	Spare 			*)
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[5];			(* IF706	Spare			*)
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[6];			(* IF707	Spare 			*)
		OUT_CU.bBusPulse_OpcUa   :=	tCust2Eng.tControl.bBusPulse_OpcUa;			(* IF708	Alive signal	*)								
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[7];			(* IF709	Spare			*)
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[8];			(* IF710	Spare			*)		
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[9];			(* IF711	Spare			*)
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[10];			(* IF712	Spare			*)		
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[11];			(* IF713	Spare			*)
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[12];			(* IF714	Spare			*)		
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[13];			(* IF715	Spare			*)	
		bConnectYourVariableHere :=	tCust2Eng.tSpare.bCustDigOpcUa[14];			(* IF716	Spare			*)												
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF740 *)
		OUT_CU.rP_Set_OpcUa    	 :=	tCust2Eng.tControl.rP_Set_OpcUa;			(* IF740	Set point for Generator power *)
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF741 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[1];			(* IF741	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF742 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[2];			(* IF742	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF743 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[3];			(* IF743	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF744 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[4];			(* IF744	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF745 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[5];			(* IF745	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF746 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[6];			(* IF746	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF747 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[7];			(* IF747	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF748 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[8];			(* IF748	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF749 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[9];			(* IF749	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF750 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[10];			(* IF750	Set point spare *)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF751 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[11];			(* IF751	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF752 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[12];			(* IF752	Set point spare	*)										
		
		(*----------------------------------------------------------------------------------------*)	
		(* IF753 *)
		rConnectYourVariableHere := tCust2Eng.tSpare.rCustAnaOpcUa[13];			(* IF753	Set point spare	*)																		
		
	END_IF;

	(*----------------------------------------------------------------
	/* ########################    OPC UA    #########################
	/* NOTE: Connect your variables here FOR customer bus system
	/*        
	/* #####################   		END			######################
	/*---------------------------------------------------------------*)
	
	
	(*----------------------------------------------------------------------------------------*)
	(* OutData communication, Customized --> Coupling *)
	OUT_CU.tCU2CP_OutData := OutData;

	(*----------------------------------------------------------------------------------------*)
	(* Watchdog / generate BUSLIVE-signal *)
	xTON_CLOCK_1(IN := NOT xTON_CLOCK_2.Q, PT := T#10s);
	xTON_CLOCK_2(IN :=     xTON_CLOCK_1.Q, PT := T#10s);

END_PROGRAM
