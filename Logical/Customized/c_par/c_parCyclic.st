(*******************************************************************************
CUSTOMIZED: c_par 			customized reserve parameters 1-200

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V3.20.0	02.03.2011 lettenb.	new, old default-settings removed
...
V4.00.0	08.05.2014 Zengerer ?hit? to int with optional factory default values 
V4.02.0 24.06.2015 Zengerer cleanup
V4.04.0	20.06.2016 Weitzer	add reserve parameter 71..200
V4.11.0	31.01.2022 Zengerer	array preparation for import HMI Extensions 201..500

Instructions for use:
--------------------
- define customized use of reserve parameters here
- mark used channels here, to avoid duplicate usage withhin one customer project

AVOID HARDCODED Para.xxx VALUES!
You MAYBE want to enter SOME factory default values, but ONLY TO THE Para_FactoryDefault.xxx STRUCTURE!
By this way the parameter values in Para.xxx would stay acessible according to XT4 parameter management process.

***********************************************
further use for TP only! 
***********************************************

Outstandings:
------------
	Para.iCtr_Mns_Options := REAL_TO_INT(Para.rCust_SparePara[72]) ;		ToDO: remove, when parameter gets availabel on VIS 


*******************************************************************************)
PROGRAM _CYCLIC


	Para.rCust_SparePara[1]	;	(*MARK USAGE HERE, to avoid duplicate usage*)	(*  =   SPS_REZP1 *)
	OUT_CU.rCust_SparePara[1];	(*para values get copied to module OUT interface, to allow possible usage in other modules also. Edit other´s module .vvm accordingly, if needed. *)

	Para.rCust_SparePara[2]	; 													(*  =   SPS_REZP2 *)
	OUT_CU.rCust_SparePara[2];													(*  =	SPS_REZP2 *)
	
	Para.rCust_SparePara[3]	;  													(*  =	SPS_REZP3 *)
	OUT_CU.rCust_SparePara[3];													(*  =	SPS_REZP3 *)

	Para.rCust_SparePara[4]	;													(*  =   SPS_REZP4*)
	OUT_CU.rCust_SparePara[4];													(*  =	SPS_REZP4 *)
	
	Para.rCust_SparePara[5]	; 													(*  =   SPS_REZP5*)
	OUT_CU.rCust_SparePara[5];													(*  =	SPS_REZP5 *)
	
	Para.rCust_SparePara[6]	;  													(*  =	SPS_REZP6*)
	OUT_CU.rCust_SparePara[6];													(*  =	SPS_REZP6 *)
	
	Para.rCust_SparePara[7]	;  													(*  =	SPS_REZP7*)
	OUT_CU.rCust_SparePara[7] ;													(*  =	SPS_REZP7 *)
	
	Para.rCust_SparePara[8]	;   												(*  =	SPS_REZP8*)
	OUT_CU.rCust_SparePara[8] ;													(*  =	SPS_REZP8 *)
	
	Para.rCust_SparePara[9]		;  												(*  =	SPS_REZP9*)
	OUT_CU.rCust_SparePara[9] 	;												(*  =	SPS_REZP9 *)
	
	Para.rCust_SparePara[10]	;  												(*  =	SPS_REZP10*)
	OUT_CU.rCust_SparePara[10]	;												(*  =	SPS_REZP10 *)
	
	(*------------------------------------------------------------------*)
	Para.rCust_SparePara[11] 	;	(*  =	SPS_REZP11 *)
	OUT_CU.rCust_SparePara[11]	;	(*  =	SPS_REZP11 *)
	
	Para.rCust_SparePara[12]	;	(*  =	SPS_REZP12 *)
	OUT_CU.rCust_SparePara[12]	;	(*  =	SPS_REZP12 *)
	
	Para.rCust_SparePara[13]	;	(*  =	SPS_REZP13 *)	
	OUT_CU.rCust_SparePara[13]	;	(*  =	SPS_REZP13 *)
	
	Para.rCust_SparePara[14]	;	(*  =	SPS_REZP14 *)	
	OUT_CU.rCust_SparePara[14]	;	(*  =	SPS_REZP14 *)
	
	Para.rCust_SparePara[15]	;	(*  =	SPS_REZP15 *)
	OUT_CU.rCust_SparePara[15]	;	(*  =	SPS_REZP15 *)
	
	Para.rCust_SparePara[16]	;	(*  =	SPS_REZP16 *)	
	OUT_CU.rCust_SparePara[16]	;	(*  =	SPS_REZP16 *)
	
	Para.rCust_SparePara[17]	;	(*  =	SPS_REZP17 *)	
	OUT_CU.rCust_SparePara[17]	;	(*  =	SPS_REZP17 *)
	
	Para.rCust_SparePara[18]	;	(*  =	SPS_REZP18 *)
	OUT_CU.rCust_SparePara[18]	;	(*  =	SPS_REZP18 *)
	
	Para.rCust_SparePara[19]	;	(*  =	SPS_REZP19 *)	
	OUT_CU.rCust_SparePara[19]	;	(*  =	SPS_REZP19 *)
	
	Para.rCust_SparePara[20]	;	(*  =	SPS_REZP20 *)
	OUT_CU.rCust_SparePara[20]	;	(*  =	SPS_REZP20 *)
	
	(*------------------------------------------------------------------*)
	Para.rCust_SparePara[21]	;	(*  =	SPS_REZP21*)	
	OUT_CU.rCust_SparePara[21] ;	(*  =	SPS_REZP21; *)
	
	Para.rCust_SparePara[22]	;	(*  =	SPS_REZP22*)	
	OUT_CU.rCust_SparePara[22] ;	(*  =	SPS_REZP22; *)
	
	Para.rCust_SparePara[23]	;	(*  =	SPS_REZP23*)	
	OUT_CU.rCust_SparePara[23] ;	(*  =	SPS_REZP23; *)
	
	Para.rCust_SparePara[24]	;	(*  =	SPS_REZP24*)
	OUT_CU.rCust_SparePara[24] ;	(*  =	SPS_REZP24; *)
	
	Para.rCust_SparePara[25]	;	(*  =	SPS_REZP25*)
	OUT_CU.rCust_SparePara[25] ;	(*  =	SPS_REZP25; *)
	
	Para.rCust_SparePara[26]	;	(*  =	SPS_REZP26*)	
	OUT_CU.rCust_SparePara[26] ;	(*  =	SPS_REZP26; *)
	
	Para.rCust_SparePara[27]	;	(*  =	SPS_REZP27*)	
	OUT_CU.rCust_SparePara[27] ;	(*  =	SPS_REZP27; *)
	
	Para.rCust_SparePara[28]	;	(*  =	SPS_REZP28*)	
	OUT_CU.rCust_SparePara[28] ;	(*  =	SPS_REZP28; *)
	
	Para.rCust_SparePara[29]	;	(*  =	SPS_REZP29*)	
	OUT_CU.rCust_SparePara[29] ;	(*  =	SPS_REZP29; *)
	
	OUT_CU.rCust_SparePara[30] ;	(*  =	SPS_REZP30; *)
	
	(*------------------------------------------------------------------*)
	Para.rCust_SparePara[31]	;	(*  =	SPS_REZP31*)	
	OUT_CU.rCust_SparePara[31] ;	(*  =	SPS_REZP31; *)
	
	Para.rCust_SparePara[32]	;	(*  =	SPS_REZP32*)	
	OUT_CU.rCust_SparePara[32] ;	(*  =	SPS_REZP32; *)
	
	Para.rCust_SparePara[33]	;	(*  =	SPS_REZP33*)
	OUT_CU.rCust_SparePara[33] ;	(*  =	SPS_REZP33; *)
	
	Para.rCust_SparePara[34]	;	(*  =	SPS_REZP34*)	
	OUT_CU.rCust_SparePara[34] ;	(*  =	SPS_REZP34; *)
	
	Para.rCust_SparePara[35]	;	(*  =	SPS_REZP35*)
	OUT_CU.rCust_SparePara[35] ;	(*  =	SPS_REZP35; *)
	
	Para.rCust_SparePara[36]	;	(*  =	SPS_REZP36*)	
	OUT_CU.rCust_SparePara[36] ;	(*  =	SPS_REZP36; *)
	
	Para.rCust_SparePara[37]	;	(*  =	SPS_REZP37*)	
	OUT_CU.rCust_SparePara[37] ;	(*  =	SPS_REZP37; *)
	
	Para.rCust_SparePara[38]	;	(*  =	SPS_REZP38*)	
	OUT_CU.rCust_SparePara[38] ;	(*  =	SPS_REZP38; *)
	
	Para.rCust_SparePara[39]	;	(*  =	SPS_REZP39*)	
	OUT_CU.rCust_SparePara[39] ;	(*  =	SPS_REZP39; *)
	
	Para.rCust_SparePara[40]	;	(*  =	SPS_REZP40*)	
	OUT_CU.rCust_SparePara[40] ;	(*  =	SPS_REZP40; *)
	
	(*------------------------------------------------------------------*)
	Para.rCust_SparePara[41]	;	(*  =	SPS_REZP41*)	
	OUT_CU.rCust_SparePara[41] ;	(*  =	SPS_REZP41; *)
	
	Para.rCust_SparePara[42]	;	(*  =	SPS_REZP42*)	
	OUT_CU.rCust_SparePara[42] ;	(*  =	SPS_REZP42; *)
	
	Para.rCust_SparePara[43]	;	(*  =	SPS_REZP43*)	
	OUT_CU.rCust_SparePara[43] ;	(*  =	SPS_REZP43; *)
	
	Para.rCust_SparePara[44]	;	(*  =	SPS_REZP44*)	
	OUT_CU.rCust_SparePara[44] ;	(*  =	SPS_REZP44; *)
	
	Para.rCust_SparePara[45]	;	(*  =	SPS_REZP45*)	
	OUT_CU.rCust_SparePara[45] ;	(*  =	SPS_REZP45; *)
	
	Para.rCust_SparePara[46]	;	(*  =	SPS_REZP46*)	
	OUT_CU.rCust_SparePara[46] ;	(*  =	SPS_REZP46; *)
	
	Para.rCust_SparePara[47]	;	(*  =	SPS_REZP47*)	
	OUT_CU.rCust_SparePara[47] ;	(*  =	SPS_REZP47; *)
	
	Para.rCust_SparePara[48]	;	(*  =	SPS_REZP48*)
	OUT_CU.rCust_SparePara[48] ;	(*  =	SPS_REZP48; *)
	
	Para.rCust_SparePara[49]	;	(*  =	SPS_REZP49*)	
	OUT_CU.rCust_SparePara[49] ;	(*  =	SPS_REZP49; *)
	
	Para.rCust_SparePara[50]	;	(*  =	SPS_REZP50*)	
	OUT_CU.rCust_SparePara[50] ;	(*  =	SPS_REZP50; *)
	
	(*------------------------------------------------------------------*)
	Para.rCust_SparePara[51]	;	(*  =	SPS_REZP51*)
	OUT_CU.rCust_SparePara[51] ;	(*  =	SPS_REZP51; *)
	
	Para.rCust_SparePara[52]	;	(*  =	SPS_REZP52*)
	OUT_CU.rCust_SparePara[52] ;	(*  =	SPS_REZP52; *)
	
	Para.rCust_SparePara[53]	;	(*  =	SPS_REZP53*)
	OUT_CU.rCust_SparePara[53] ;	(*  =	SPS_REZP53; *)
	
	Para.rCust_SparePara[54]	;	(*  =	SPS_REZP54*)
	OUT_CU.rCust_SparePara[54] ;	(*  =	SPS_REZP54; *)
	
	Para.rCust_SparePara[55]	;	(*  =	SPS_REZP55*)
	OUT_CU.rCust_SparePara[55] ;	(*  =	SPS_REZP55; *)
	
	Para.rCust_SparePara[56]	;	(*  =	SPS_REZP56*)
	OUT_CU.rCust_SparePara[56] ;	(*  =	SPS_REZP56; *)
	
	Para.rCust_SparePara[57]	;	(*  =	SPS_REZP57*)
	OUT_CU.rCust_SparePara[57] ;	(*  =	SPS_REZP57; *)
	
	Para.rCust_SparePara[58]	;	(*  =	SPS_REZP58*)
	OUT_CU.rCust_SparePara[58] ;	(*  =	SPS_REZP58; *)
	
	Para.rCust_SparePara[59]	;	(*  =	SPS_REZP59*)
	OUT_CU.rCust_SparePara[59] ;	(*  =	SPS_REZP59; *)
	
	Para.rCust_SparePara[60]	;	(*  =	SPS_REZP60*)
	OUT_CU.rCust_SparePara[60] ;	(*  =	SPS_REZP60; *)
	
	(*------------------------------------------------------------------*)
	Para.rCust_SparePara[61]	;	(*  =	SPS_REZP61*)
	OUT_CU.rCust_SparePara[61] ;	(* = 	ssResPara61 *)
	
	Para.rCust_SparePara[62]	;	(*  =	SPS_REZP62*)
	OUT_CU.rCust_SparePara[62] ;	(* = 	ssResPara62 *)
	
	Para.rCust_SparePara[63]	;	(*  =	SPS_REZP63*)
	OUT_CU.rCust_SparePara[63] ;	(* = 	ssResPara63 *)
	
	Para.rCust_SparePara[64]	;	(*  =	SPS_REZP64*)
	OUT_CU.rCust_SparePara[64] ;	(* = 	ssResPara64 *)
	
	Para.rCust_SparePara[65]	;	(*  =	SPS_REZP65*)
	OUT_CU.rCust_SparePara[65] ;	(* = 	ssResPara65 *)
	
	Para.rCust_SparePara[66]	;	(*  =	SPS_REZP66*)
	OUT_CU.rCust_SparePara[66] ;	(* = 	ssResPara66 *)
	
	Para.rCust_SparePara[67]	;	(*  =	SPS_REZP67*)
	OUT_CU.rCust_SparePara[67] ;	(* = 	ssResPara67 *)
	
	Para.rCust_SparePara[68]	;	(*  =	SPS_REZP68*)
	OUT_CU.rCust_SparePara[68] ;	(* = 	ssResPara68 *)
	
	Para.rCust_SparePara[69]	;	(*  =	SPS_REZP69 *)
	OUT_CU.rCust_SparePara[69] ;	(* = 	ssResPara69 *)
	
	Para.rCust_SparePara[70]	;	(*  =	SPS_REZP70 *)
	OUT_CU.rCust_SparePara[70] ;	(* = 	ssResPara70 *)

	(*---------------------------------------------------------------------------------------*)
	(* END OF PRECONFIGURED VISUALISATION DATA POINS on standard engines, up to Vis Rev. 4.x *)
	(*---------------------------------------------------------------------------------------*)
	Para.rCust_SparePara[71];		(*  = SPS_REZP	71	***USED*** *)
	OUT_CU.rCust_SparePara[71];		(*  = ssResPara	71	*)

	Para.rCust_SparePara[72];		(*  = SPS_REZP	72  ***USED*** *)
	OUT_CU.rCust_SparePara[72];		(*  = ssResPara	72	*)

	Para.rCust_SparePara[73];		(*  = SPS_REZP	73	***USED*** *)
	OUT_CU.rCust_SparePara[73];		(*  = ssResPara	73	*)

	Para.rCust_SparePara[74];		(*  = SPS_REZP	74	*)
	OUT_CU.rCust_SparePara[74];		(*  = ssResPara	74	*)

	Para.rCust_SparePara[75];		(*  = SPS_REZP	75	*)
	OUT_CU.rCust_SparePara[75];		(*  = ssResPara	75	*)

	Para.rCust_SparePara[76];		(*  = SPS_REZP	76	*)
	OUT_CU.rCust_SparePara[76];		(*  = ssResPara	76	*)

	Para.rCust_SparePara[77];		(*  = SPS_REZP	77	*)
	OUT_CU.rCust_SparePara[77];		(*  = ssResPara	77	*)

	Para.rCust_SparePara[78];		(*  = SPS_REZP	78	*)
	OUT_CU.rCust_SparePara[78];		(*  = ssResPara	78	*)

	Para.rCust_SparePara[79];		(*  = SPS_REZP	79	*)
	OUT_CU.rCust_SparePara[79];		(*  = ssResPara	79	*)

	Para.rCust_SparePara[80];		(*  = SPS_REZP	80	*)
	OUT_CU.rCust_SparePara[80];		(*  = ssResPara	80	*)

	(*------------------------------------------------------------------*)
	Para.rCust_SparePara[81];		(*  = SPS_REZP	81	*)
	OUT_CU.rCust_SparePara[81];		(*  = ssResPara	81	*)

	Para.rCust_SparePara[82];		(*  = SPS_REZP	82	*)
	OUT_CU.rCust_SparePara[82];		(*  = ssResPara	82	*)

	Para.rCust_SparePara[83];		(*  = SPS_REZP	83	*)
	OUT_CU.rCust_SparePara[83];		(*  = ssResPara	83	*)

	Para.rCust_SparePara[84];		(*  = SPS_REZP	84	*)
	OUT_CU.rCust_SparePara[84];		(*  = ssResPara	84	*)

	Para.rCust_SparePara[85];		(*  = SPS_REZP	85	*)
	OUT_CU.rCust_SparePara[85];		(*  = ssResPara	85	*)

	Para.rCust_SparePara[86];		(*  = SPS_REZP	86	*)
	OUT_CU.rCust_SparePara[86];		(*  = ssResPara	86	*)

	Para.rCust_SparePara[87];		(*  = SPS_REZP	87	*)
	OUT_CU.rCust_SparePara[87];		(*  = ssResPara	87	*)

	Para.rCust_SparePara[88];		(*  = SPS_REZP	88	*)
	OUT_CU.rCust_SparePara[88];		(*  = ssResPara	88	*)

	Para.rCust_SparePara[89];		(*  = SPS_REZP	89	*)
	OUT_CU.rCust_SparePara[89];		(*  = ssResPara	89	*)

	Para.rCust_SparePara[90];		(*  = SPS_REZP	90	*)
	OUT_CU.rCust_SparePara[90];		(*  = ssResPara	90	*)

	(*------------------------------------------------------------------*)
	Para.rCust_SparePara[91];		(*  = SPS_REZP	91	*)
	OUT_CU.rCust_SparePara[91];		(*  = ssResPara	91	*)

	Para.rCust_SparePara[92];		(*  = SPS_REZP	92	*)
	OUT_CU.rCust_SparePara[92];		(*  = ssResPara	92	*)

	Para.rCust_SparePara[93];		(*  = SPS_REZP	93	*)
	OUT_CU.rCust_SparePara[93];		(*  = ssResPara	93	*)

	Para.rCust_SparePara[94];		(*  = SPS_REZP	94	*)
	OUT_CU.rCust_SparePara[94];		(*  = ssResPara	94	*)

	Para.rCust_SparePara[95];		(*  = SPS_REZP	95	*)
	OUT_CU.rCust_SparePara[95];		(*  = ssResPara	95	*)

	Para.rCust_SparePara[96];		(*  = SPS_REZP	96	*)
	OUT_CU.rCust_SparePara[96];		(*  = ssResPara	96	*)

	Para.rCust_SparePara[97];		(*  = SPS_REZP	97	*)
	OUT_CU.rCust_SparePara[97];		(*  = ssResPara	97	*)

	Para.rCust_SparePara[98];		(*  = SPS_REZP	98	*)
	OUT_CU.rCust_SparePara[98];		(*  = ssResPara	98	*)

	Para.rCust_SparePara[99];		(*  = SPS_REZP	99	*)
	OUT_CU.rCust_SparePara[99];		(*  = ssResPara	99	*)

	Para.rCust_SparePara[100];		(*  = SPS_REZP	100	*)
	OUT_CU.rCust_SparePara[100];	(*  = ssResPara	100	*)

	(*------------------------------------------------------------------*)
	Para.rCust_SparePara[101];		(*  = SPS_REZP	101	*)
	OUT_CU.rCust_SparePara[101];	(*  = ssResPara	101	*)

	Para.rCust_SparePara[102];		(*  = SPS_REZP	102	*)
	OUT_CU.rCust_SparePara[102];	(*  = ssResPara	102	*)

	Para.rCust_SparePara[103];		(*  = SPS_REZP	103	*)
	OUT_CU.rCust_SparePara[103];	(*  = ssResPara	103	*)

	Para.rCust_SparePara[104];		(*  = SPS_REZP	104	*)
	OUT_CU.rCust_SparePara[104];	(*  = ssResPara	104	*)

	Para.rCust_SparePara[105];		(*  = SPS_REZP	105	*)
	OUT_CU.rCust_SparePara[105];	(*  = ssResPara	105	*)

	Para.rCust_SparePara[106];		(*  = SPS_REZP	106	*)
	OUT_CU.rCust_SparePara[106];	(*  = ssResPara	106	*)

	Para.rCust_SparePara[107];		(*  = SPS_REZP	107	*)
	OUT_CU.rCust_SparePara[107];	(*  = ssResPara	107	*)

	Para.rCust_SparePara[108];		(*  = SPS_REZP	108	*)
	OUT_CU.rCust_SparePara[108];	(*  = ssResPara	108	*)

	Para.rCust_SparePara[109];		(*  = SPS_REZP	109	*)
	OUT_CU.rCust_SparePara[109];	(*  = ssResPara	109	*)

	Para.rCust_SparePara[110];		(*  = SPS_REZP	110	*)
	OUT_CU.rCust_SparePara[110];	(*  = ssResPara	110	*)

	(*------------------------------------------------------------------*)
	Para.rCust_SparePara[111];		(*  = SPS_REZP	111	*)
	OUT_CU.rCust_SparePara[111];	(*  = ssResPara	111	*)

	Para.rCust_SparePara[112];		(*  = SPS_REZP	112	*)
	OUT_CU.rCust_SparePara[112];	(*  = ssResPara	112	*)

	Para.rCust_SparePara[113];		(*  = SPS_REZP	113	*)
	OUT_CU.rCust_SparePara[113];	(*  = ssResPara	113	*)

	Para.rCust_SparePara[114];		(*  = SPS_REZP	114	*)
	OUT_CU.rCust_SparePara[114];	(*  = ssResPara	114	*)

	Para.rCust_SparePara[115];		(*  = SPS_REZP	115	*)
	OUT_CU.rCust_SparePara[115];	(*  = ssResPara	115	*)

	Para.rCust_SparePara[116];		(*  = SPS_REZP	116	*)
	OUT_CU.rCust_SparePara[116];	(*  = ssResPara	116	*)

	Para.rCust_SparePara[117];		(*  = SPS_REZP	117	*)
	OUT_CU.rCust_SparePara[117];	(*  = ssResPara	117	*)

	Para.rCust_SparePara[118];		(*  = SPS_REZP	118	*)
	OUT_CU.rCust_SparePara[118];	(*  = ssResPara	118	*)

	Para.rCust_SparePara[119];		(*  = SPS_REZP	119	*)
	OUT_CU.rCust_SparePara[119];	(*  = ssResPara	119	*)

	Para.rCust_SparePara[120];		(*  = SPS_REZP	120	*)
	OUT_CU.rCust_SparePara[120];	(*  = ssResPara	120	*)

	(*------------------------------------------------------------------*)	
	Para.rCust_SparePara[121];		(*  = SPS_REZP	121	*)
	OUT_CU.rCust_SparePara[121];	(*  = ssResPara	121	*)

	Para.rCust_SparePara[122];		(*  = SPS_REZP	122	*)
	OUT_CU.rCust_SparePara[122];	(*  = ssResPara	122	*)

	Para.rCust_SparePara[123];		(*  = SPS_REZP	123	*)
	OUT_CU.rCust_SparePara[123];	(*  = ssResPara	123	*)

	Para.rCust_SparePara[124];		(*  = SPS_REZP	124	*)
	OUT_CU.rCust_SparePara[124];	(*  = ssResPara	124	*)

	Para.rCust_SparePara[125];		(*  = SPS_REZP	125	*)
	OUT_CU.rCust_SparePara[125];	(*  = ssResPara	125	*)

	Para.rCust_SparePara[126];		(*  = SPS_REZP	126	*)
	OUT_CU.rCust_SparePara[126];	(*  = ssResPara	126	*)

	Para.rCust_SparePara[127];		(*  = SPS_REZP	127	*)
	OUT_CU.rCust_SparePara[127];	(*  = ssResPara	127	*)

	Para.rCust_SparePara[128];		(*  = SPS_REZP	128	*)
	OUT_CU.rCust_SparePara[128];	(*  = ssResPara	128	*)

	Para.rCust_SparePara[129];		(*  = SPS_REZP	129	*)
	OUT_CU.rCust_SparePara[129];	(*  = ssResPara	129	*)

	Para.rCust_SparePara[130];		(*  = SPS_REZP	130	*)
	OUT_CU.rCust_SparePara[130];	(*  = ssResPara	130	*)

	(*------------------------------------------------------------------*)	
	Para.rCust_SparePara[131];		(*  = SPS_REZP	131	*)
	OUT_CU.rCust_SparePara[131];	(*  = ssResPara	131	*)

	Para.rCust_SparePara[132];		(*  = SPS_REZP	132	*)
	OUT_CU.rCust_SparePara[132];	(*  = ssResPara	132	*)

	Para.rCust_SparePara[133];		(*  = SPS_REZP	133	*)
	OUT_CU.rCust_SparePara[133];	(*  = ssResPara	133	*)

	Para.rCust_SparePara[134];		(*  = SPS_REZP	134	*)
	OUT_CU.rCust_SparePara[134];	(*  = ssResPara	134	*)

	Para.rCust_SparePara[135];		(*  = SPS_REZP	135	*)
	OUT_CU.rCust_SparePara[135];	(*  = ssResPara	135	*)

	Para.rCust_SparePara[136];		(*  = SPS_REZP	136	*)
	OUT_CU.rCust_SparePara[136];	(*  = ssResPara	136	*)

	Para.rCust_SparePara[137];		(*  = SPS_REZP	137	*)
	OUT_CU.rCust_SparePara[137];	(*  = ssResPara	137	*)

	Para.rCust_SparePara[138];		(*  = SPS_REZP	138	*)
	OUT_CU.rCust_SparePara[138];	(*  = ssResPara	138	*)

	Para.rCust_SparePara[139];		(*  = SPS_REZP	139	*)
	OUT_CU.rCust_SparePara[139];	(*  = ssResPara	139	*)

	Para.rCust_SparePara[140];		(*  = SPS_REZP	140	*)
	OUT_CU.rCust_SparePara[140];	(*  = ssResPara	140	*)

	(*------------------------------------------------------------------*)	
	Para.rCust_SparePara[141];		(*  = SPS_REZP	141	*)
	OUT_CU.rCust_SparePara[141];	(*  = ssResPara	141	*)

	Para.rCust_SparePara[142];		(*  = SPS_REZP	142	*)
	OUT_CU.rCust_SparePara[142];	(*  = ssResPara	142	*)

	Para.rCust_SparePara[143];		(*  = SPS_REZP	143	*)
	OUT_CU.rCust_SparePara[143];	(*  = ssResPara	143	*)

	Para.rCust_SparePara[144];		(*  = SPS_REZP	144	*)
	OUT_CU.rCust_SparePara[144];	(*  = ssResPara	144	*)

	Para.rCust_SparePara[145];		(*  = SPS_REZP	145	*)
	OUT_CU.rCust_SparePara[145];	(*  = ssResPara	145	*)

	Para.rCust_SparePara[146];		(*  = SPS_REZP	146	*)
	OUT_CU.rCust_SparePara[146];	(*  = ssResPara	146	*)

	Para.rCust_SparePara[147];		(*  = SPS_REZP	147	*)
	OUT_CU.rCust_SparePara[147];	(*  = ssResPara	147	*)

	Para.rCust_SparePara[148];		(*  = SPS_REZP	148	*)
	OUT_CU.rCust_SparePara[148];	(*  = ssResPara	148	*)

	Para.rCust_SparePara[149];		(*  = SPS_REZP	149	*)
	OUT_CU.rCust_SparePara[149];	(*  = ssResPara	149	*)

	Para.rCust_SparePara[150];		(*  = SPS_REZP	150	*)
	OUT_CU.rCust_SparePara[150];	(*  = ssResPara	150	*)

	(*------------------------------------------------------------------*)	
	Para.rCust_SparePara[151];		(*  = SPS_REZP	151	*)
	OUT_CU.rCust_SparePara[151];	(*  = ssResPara	151	*)

	Para.rCust_SparePara[152];		(*  = SPS_REZP	152	*)
	OUT_CU.rCust_SparePara[152];	(*  = ssResPara	152	*)

	Para.rCust_SparePara[153];		(*  = SPS_REZP	153	*)
	OUT_CU.rCust_SparePara[153];	(*  = ssResPara	153	*)

	Para.rCust_SparePara[154];		(*  = SPS_REZP	154	*)
	OUT_CU.rCust_SparePara[154];	(*  = ssResPara	154	*)

	Para.rCust_SparePara[155];		(*  = SPS_REZP	155	*)
	OUT_CU.rCust_SparePara[155];	(*  = ssResPara	155	*)

	Para.rCust_SparePara[156];		(*  = SPS_REZP	156	*)
	OUT_CU.rCust_SparePara[156];	(*  = ssResPara	156	*)

	Para.rCust_SparePara[157];		(*  = SPS_REZP	157	*)
	OUT_CU.rCust_SparePara[157];	(*  = ssResPara	157	*)

	Para.rCust_SparePara[158];		(*  = SPS_REZP	158	*)
	OUT_CU.rCust_SparePara[158];	(*  = ssResPara	158	*)

	Para.rCust_SparePara[159];		(*  = SPS_REZP	159	*)
	OUT_CU.rCust_SparePara[159];	(*  = ssResPara	159	*)

	Para.rCust_SparePara[160];		(*  = SPS_REZP	160	*)
	OUT_CU.rCust_SparePara[160];	(*  = ssResPara	160	*)

	(*------------------------------------------------------------------*)	
	Para.rCust_SparePara[161];		(*  = SPS_REZP	161	*)
	OUT_CU.rCust_SparePara[161];	(*  = ssResPara	161	*)

	Para.rCust_SparePara[162];		(*  = SPS_REZP	162	*)
	OUT_CU.rCust_SparePara[162];	(*  = ssResPara	162	*)

	Para.rCust_SparePara[163];		(*  = SPS_REZP	163	*)
	OUT_CU.rCust_SparePara[163];	(*  = ssResPara	163	*)

	Para.rCust_SparePara[164];		(*  = SPS_REZP	164	*)
	OUT_CU.rCust_SparePara[164];	(*  = ssResPara	164	*)

	Para.rCust_SparePara[165];		(*  = SPS_REZP	165	*)
	OUT_CU.rCust_SparePara[165];	(*  = ssResPara	165	*)

	Para.rCust_SparePara[166];		(*  = SPS_REZP	166	*)
	OUT_CU.rCust_SparePara[166];	(*  = ssResPara	166	*)

	Para.rCust_SparePara[167];		(*  = SPS_REZP	167	*)
	OUT_CU.rCust_SparePara[167];	(*  = ssResPara	167	*)

	Para.rCust_SparePara[168];		(*  = SPS_REZP	168	*)
	OUT_CU.rCust_SparePara[168];	(*  = ssResPara	168	*)

	Para.rCust_SparePara[169];		(*  = SPS_REZP	169	*)
	OUT_CU.rCust_SparePara[169];	(*  = ssResPara	169	*)

	Para.rCust_SparePara[170];		(*  = SPS_REZP	170	*)
	OUT_CU.rCust_SparePara[170];	(*  = ssResPara	170	*)

	(*------------------------------------------------------------------*)	
	Para.rCust_SparePara[171];		(*  = SPS_REZP	171	*)
	OUT_CU.rCust_SparePara[171];	(*  = ssResPara	171	*)

	Para.rCust_SparePara[172];		(*  = SPS_REZP	172	*)
	OUT_CU.rCust_SparePara[172];	(*  = ssResPara	172	*)

	Para.rCust_SparePara[173];		(*  = SPS_REZP	173	*)
	OUT_CU.rCust_SparePara[173];	(*  = ssResPara	173	*)

	Para.rCust_SparePara[174];		(*  = SPS_REZP	174	*)
	OUT_CU.rCust_SparePara[174];	(*  = ssResPara	174	*)

	Para.rCust_SparePara[175];		(*  = SPS_REZP	175	*)
	OUT_CU.rCust_SparePara[175];	(*  = ssResPara	175	*)

	Para.rCust_SparePara[176];		(*  = SPS_REZP	176	*)
	OUT_CU.rCust_SparePara[176];	(*  = ssResPara	176	*)

	Para.rCust_SparePara[177];		(*  = SPS_REZP	177	*)
	OUT_CU.rCust_SparePara[177];	(*  = ssResPara	177	*)

	Para.rCust_SparePara[178];		(*  = SPS_REZP	178	*)
	OUT_CU.rCust_SparePara[178];	(*  = ssResPara	178	*)

	Para.rCust_SparePara[179];		(*  = SPS_REZP	179	*)
	OUT_CU.rCust_SparePara[179];	(*  = ssResPara	179	*)

	Para.rCust_SparePara[180];		(*  = SPS_REZP	180	*)
	OUT_CU.rCust_SparePara[180];	(*  = ssResPara	180	*)

	(*------------------------------------------------------------------*)
	Para.rCust_SparePara[181];		(*  = SPS_REZP	181	*)
	OUT_CU.rCust_SparePara[181];	(*  = ssResPara	181	*)

	Para.rCust_SparePara[182];		(*  = SPS_REZP	182	*)
	OUT_CU.rCust_SparePara[182];	(*  = ssResPara	182	*)

	Para.rCust_SparePara[183];		(*  = SPS_REZP	183	*)
	OUT_CU.rCust_SparePara[183];	(*  = ssResPara	183	*)

	Para.rCust_SparePara[184];		(*  = SPS_REZP	184	*)
	OUT_CU.rCust_SparePara[184];	(*  = ssResPara	184	*)

	Para.rCust_SparePara[185];		(*  = SPS_REZP	185	*)
	OUT_CU.rCust_SparePara[185];	(*  = ssResPara	185	*)

	Para.rCust_SparePara[186];		(*  = SPS_REZP	186	*)
	OUT_CU.rCust_SparePara[186];	(*  = ssResPara	186	*)

	Para.rCust_SparePara[187];		(*  = SPS_REZP	187	*)
	OUT_CU.rCust_SparePara[187];	(*  = ssResPara	187	*)

	Para.rCust_SparePara[188];		(*  = SPS_REZP	188	*)
	OUT_CU.rCust_SparePara[188];	(*  = ssResPara	188	*)

	Para.rCust_SparePara[189];		(*  = SPS_REZP	189	*)
	OUT_CU.rCust_SparePara[189];	(*  = ssResPara	189	*)

	Para.rCust_SparePara[190];		(*  = SPS_REZP	190	*)
	OUT_CU.rCust_SparePara[190];	(*  = ssResPara	190	*)

	(*------------------------------------------------------------------*)	
	Para.rCust_SparePara[191];		(*  = SPS_REZP	191	*)
	OUT_CU.rCust_SparePara[191];	(*  = ssResPara	191	*)

	Para.rCust_SparePara[192];		(*  = SPS_REZP	192	*)
	OUT_CU.rCust_SparePara[192];	(*  = ssResPara	192	*)

	Para.rCust_SparePara[193];		(*  = SPS_REZP	193	*)
	OUT_CU.rCust_SparePara[193];	(*  = ssResPara	193	*)

	Para.rCust_SparePara[194];		(*  = SPS_REZP	194	*)
	OUT_CU.rCust_SparePara[194];	(*  = ssResPara	194	*)

	Para.rCust_SparePara[195];		(*  = SPS_REZP	195	*)
	OUT_CU.rCust_SparePara[195];	(*  = ssResPara	195	*)

	Para.rCust_SparePara[196];		(*  = SPS_REZP	196	*)
	OUT_CU.rCust_SparePara[196];	(*  = ssResPara	196	*)

	Para.rCust_SparePara[197];		(*  = SPS_REZP	197	*)
	OUT_CU.rCust_SparePara[197];	(*  = ssResPara	197	*)

	Para.rCust_SparePara[198];		(*  = SPS_REZP	198	*)
	OUT_CU.rCust_SparePara[198];	(*  = ssResPara	198	*)

	Para.rCust_SparePara[199];		(*  = SPS_REZP	199	*)
	OUT_CU.rCust_SparePara[199];	(*  = ssResPara	199	*)

	Para.rCust_SparePara[200];		(*  = SPS_REZP	200	*)
	OUT_CU.rCust_SparePara[200];	(*  = ssResPara	200	*)


	(*------------------------------------------------------------------*)

		
	(***********************************************
	END OF CONFIGURATION AREA
	***********************************************)
	(* NO CHANGES BEJOND THIS LINE! *)

//	OUT_CU.rCust_SparePara := 		Para.rCust_SparePara     ;	(* DONT DO THIS ANY MORE since different array size is possible with HMI Extention import in V4.11  *)
	iOut_SparePara_Size := SIZEOF(OUT_CU.rCust_SparePara)/ SIZEOF(OUT_CU.rCust_SparePara[0]) -1 ;
	FOR n := 0 TO iOut_SparePara_Size DO
		OUT_CU.rCust_SparePara[n] := 		Para.rCust_SparePara[n]     ;	(* Copy all parameter values to Module OUT interface for possible reuse in other modules  *)
	END_FOR
	
END_PROGRAM
