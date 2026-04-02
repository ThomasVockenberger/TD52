(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: ECB_Test
 * File: ECB_Test.st
 * Author: 502423184
 * Created: January 12, 2018
 ********************************************************************
 * Implementation of program ECB_Test
 ********************************************************************)

PROGRAM _INIT

	(** INIT: Disable PBC_Buffer Task *)
	bECB_Buffer_Test	:=	TRUE;

	(** Bit Names **)
	Buffer.Bits[0].used	:=	8;
	Buffer.Bits[1].used	:=	0;
	Buffer.Bits[0].Info[0].Name			:=	'GCB_ON';
	Buffer.Bits[0].Info[1].Name			:=	'Trip_1';
	Buffer.Bits[0].Info[2].Name			:=	'Trip_2';
	Buffer.Bits[0].Info[3].Name			:=	'Trip_3';
	Buffer.Bits[0].Info[4].Name			:=	'GrC_VoltageLow';
	Buffer.Bits[0].Info[5].Name			:=	'GrC_SpeedChange';
	Buffer.Bits[0].Info[6].Name			:=	'GrC_CurrentChange';
	Buffer.Bits[0].Info[7].Name			:=	'FS_IPOffs_Trip';
	Buffer.Bits[1].Info[0].Name			:=	'';
	Buffer.Bits[1].Info[1].Name			:=	'';
	Buffer.Bits[1].Info[2].Name			:=	'';
	Buffer.Bits[1].Info[3].Name			:=	'';

	(** Bit Pattern Names **)
	Buffer.pattern[0].Name		:=	 'PBCNegVoltCheck_';
	Buffer.pattern[1].Name		:=	 'PBCNegPresCheck_';
	Buffer.pattern[2].Name		:=	 'PBCPresSlopeCheck_';
	Buffer.pattern[3].Name		:=	 'PBCSlowDriftCheck_';
	Buffer.pattern[4].Name		:=	 'PBCMemBurst_';
	Buffer.pattern[5].Name		:=	 'PBCSensError_';
	Buffer.pattern[6].Name		:=	 'GlowIgn_';
	Buffer.pattern[7].Name		:=	 'Misfire_I_';
	Buffer.pattern[8].Name		:=	 'Misfire_II_';
	Buffer.pattern[9].Name		:=	 'SkipFire_';
	Buffer.pattern[10].Name		:=	 'LimpHome_';
	Buffer.pattern[11].Name		:=	 'LimpHomeExt_';
	Buffer.pattern[12].Name		:=	 '';
	Buffer.pattern[13].Name		:=	 '';
	Buffer.pattern[14].Name		:=	 '';
	Buffer.pattern[15].Name		:=	 '';
	Buffer.pattern[16].Name		:=	 '';

	Buffer.iCnt_pattern			:=	15;

	(** ui16 Names, Conversions, Signs and Units *)
	iCnt	:=	0;
	FOR iSet:=0 TO 304 BY 16 DO
		Buffer.ui16[iSet].Name 	:=	'Ign_Timing_';		Buffer.ui16[iSet].Co := 100;	Buffer.ui16[iSet].Signed := 1;	Buffer.ui16[iSet].Unit := '°CA';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=1 TO 305 BY 16 DO
		Buffer.ui16[iSet].Name := 'Knck_Intgr_';		Buffer.ui16[iSet].Co := 10;		Buffer.ui16[iSet].Signed := 1;	Buffer.ui16[iSet].Unit := '%';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=2 TO 306 BY 16 DO
		Buffer.ui16[iSet].Name := 'U_Ign_';				Buffer.ui16[iSet].Co := 1;		Buffer.ui16[iSet].Signed := 0;	Buffer.ui16[iSet].Unit := 'kV';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=3 TO 307 BY 16 DO
		Buffer.ui16[iSet].Name := 'PI_Duration_';		Buffer.ui16[iSet].Co := 100;	Buffer.ui16[iSet].Signed := 0;	Buffer.ui16[iSet].Unit := '°CA';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=4 TO 308 BY 16 DO
		Buffer.ui16[iSet].Name := 'PI_Dur_Map_Offs_';	Buffer.ui16[iSet].Co := 1000;	Buffer.ui16[iSet].Signed := 1;	Buffer.ui16[iSet].Unit := '%';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=6 TO 310 BY 16 DO
		Buffer.ui16[iSet].Name := 'Pr_Knock_';			Buffer.ui16[iSet].Co := 100;	Buffer.ui16[iSet].Signed := 0;	Buffer.ui16[iSet].Unit := 'bar';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=7 TO 311 BY 16 DO
		Buffer.ui16[iSet].Name := 'Pr_Knock_Filt_';		Buffer.ui16[iSet].Co := 100;	Buffer.ui16[iSet].Signed := 0;	Buffer.ui16[iSet].Unit := 'bar';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=8 TO 312 BY 16 DO
		Buffer.ui16[iSet].Name := 'Pr_Peak_';			Buffer.ui16[iSet].Co := 100;	Buffer.ui16[iSet].Signed := 0;	Buffer.ui16[iSet].Unit := 'bar';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=9 TO 313 BY 16 DO
		Buffer.ui16[iSet].Name := 'Pr_Peak_Filt_';		Buffer.ui16[iSet].Co := 100;	Buffer.ui16[iSet].Signed := 0;	Buffer.ui16[iSet].Unit := 'bar';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=10 TO 314 BY 16 DO
		Buffer.ui16[iSet].Name := 'Pr_IMEP_';			Buffer.ui16[iSet].Co := 100;	Buffer.ui16[iSet].Signed := 0;	Buffer.ui16[iSet].Unit := 'bar';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=11 TO 315 BY 16 DO
		Buffer.ui16[iSet].Name := 'Pr_49bfTDC_';		Buffer.ui16[iSet].Co := 100;	Buffer.ui16[iSet].Signed := 0;	Buffer.ui16[iSet].Unit := 'bar';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=12 TO 316 BY 16 DO
		Buffer.ui16[iSet].Name := 'Pr_49afTDC_';		Buffer.ui16[iSet].Co := 100;	Buffer.ui16[iSet].Signed := 0;	Buffer.ui16[iSet].Unit := 'bar';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=13 TO 317 BY 16 DO
		Buffer.ui16[iSet].Name := 'MFBvar_';			Buffer.ui16[iSet].Co := 100;	Buffer.ui16[iSet].Signed := 1;	Buffer.ui16[iSet].Unit := '°CA';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	0;
	FOR iSet:=14 TO 318 BY 16 DO
		Buffer.ui16[iSet].Name := 'Pr_Knock_Lim_';		Buffer.ui16[iSet].Co := 100;	Buffer.ui16[iSet].Signed := 0;	Buffer.ui16[iSet].Unit := 'bar';
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));		strcat(ADR(Buffer.ui16[iSet].Name), ADR(strCnt));
	END_FOR

	Buffer.iCnt_ui16			:=	326;


	(** ui16_H Names, Conversions, Signs and Units *)
	Buffer.ui16_H[0].Name := 'N_Eng';			Buffer.ui16_H[0].Co := 10;		Buffer.ui16_H[0].Signed := 0;	Buffer.ui16_H[0].Unit := 'rpm';
	Buffer.ui16_H[1].Name := 'P_Set';			Buffer.ui16_H[1].Co	:= 1;		Buffer.ui16_H[1].Signed := 0;	Buffer.ui16_H[1].Unit := 'kW';
	Buffer.ui16_H[2].Name := 'P_Act';			Buffer.ui16_H[2].Co := 1;		Buffer.ui16_H[2].Signed	:= 1;	Buffer.ui16_H[2].Unit := 'kW';
	Buffer.ui16_H[3].Name := 'Q_Act';			Buffer.ui16_H[3].Co := 1;		Buffer.ui16_H[3].Signed	:= 1;	Buffer.ui16_H[3].Unit := 'kVAr';
	Buffer.ui16_H[4].Name := 'U_L1L2';			Buffer.ui16_H[4].Co := 1;		Buffer.ui16_H[4].Signed	:= 1;	Buffer.ui16_H[4].Unit := 'V';
	Buffer.ui16_H[5].Name := 'U_L2L3';			Buffer.ui16_H[5].Co := 1;		Buffer.ui16_H[5].Signed	:= 1;	Buffer.ui16_H[5].Unit := 'V';
	Buffer.ui16_H[6].Name := 'U_L3L1';			Buffer.ui16_H[6].Co := 1;		Buffer.ui16_H[6].Signed	:= 1;	Buffer.ui16_H[6].Unit := 'V';
	Buffer.ui16_H[7].Name := 'I_L1';			Buffer.ui16_H[7].Co := 1;		Buffer.ui16_H[7].Signed	:= 1;	Buffer.ui16_H[7].Unit := 'A';
	Buffer.ui16_H[8].Name := 'I_L2';			Buffer.ui16_H[8].Co := 1;		Buffer.ui16_H[8].Signed	:= 1;	Buffer.ui16_H[8].Unit := 'A';
	Buffer.ui16_H[9].Name := 'I_L3';			Buffer.ui16_H[9].Co := 1;		Buffer.ui16_H[9].Signed	:= 1;	Buffer.ui16_H[9].Unit := 'A';
	Buffer.ui16_H[10].Name := 'Frequency';		Buffer.ui16_H[10].Co := 1000;	Buffer.ui16_H[10].Signed := 0;	Buffer.ui16_H[10].Unit := 'Hz';
	Buffer.ui16_H[11].Name := 'CosPhi';			Buffer.ui16_H[11].Co := 100;	Buffer.ui16_H[11].Signed := 1;	Buffer.ui16_H[11].Unit := '';
	Buffer.ui16_H[12].Name := 'Lambda_Set';		Buffer.ui16_H[12].Co := 1000;	Buffer.ui16_H[12].Signed := 0;	Buffer.ui16_H[12].Unit := '';
	Buffer.ui16_H[13].Name := 'Pr_Leanox_Set';	Buffer.ui16_H[13].Co := 1000;	Buffer.ui16_H[13].Signed := 0;	Buffer.ui16_H[13].Unit := '';
	Buffer.ui16_H[14].Name := 'N_TCHP_A';		Buffer.ui16_H[14].Co := 0.1;	Buffer.ui16_H[14].Signed := 0;	Buffer.ui16_H[14].Unit := 'rpm';
	Buffer.ui16_H[15].Name := 'N_TCHP_B';		Buffer.ui16_H[15].Co := 0.1;	Buffer.ui16_H[15].Signed := 0;	Buffer.ui16_H[15].Unit := 'rpm';
	Buffer.ui16_H[16].Name := 'N_TCLP_A';		Buffer.ui16_H[16].Co := 0.1;	Buffer.ui16_H[16].Signed := 0;	Buffer.ui16_H[16].Unit := 'rpm';
	Buffer.ui16_H[17].Name := 'N_TCLP_B';		Buffer.ui16_H[17].Co := 0.1;	Buffer.ui16_H[17].Signed := 0;	Buffer.ui16_H[17].Unit := 'rpm';
	Buffer.ui16_H[18].Name := 'Pr_GR_Act';		Buffer.ui16_H[18].Co := 1000;	Buffer.ui16_H[18].Signed := 0;	Buffer.ui16_H[18].Unit := 'bar';
	Buffer.ui16_H[19].Name := 'Pr_GR_Set';		Buffer.ui16_H[19].Co := 1000;	Buffer.ui16_H[19].Signed := 0;	Buffer.ui16_H[19].Unit := 'bar';
	Buffer.ui16_H[20].Name := 'Pr_PC_Act';		Buffer.ui16_H[20].Co := 1000;	Buffer.ui16_H[20].Signed := 0;	Buffer.ui16_H[20].Unit := 'bar';
	Buffer.ui16_H[21].Name := 'Pr_PC_Set';		Buffer.ui16_H[21].Co := 1000;	Buffer.ui16_H[21].Signed := 0;	Buffer.ui16_H[21].Unit := 'bar';
	Buffer.ui16_H[22].Name := 'Pr_Crank_Case';	Buffer.ui16_H[22].Co := 1000;	Buffer.ui16_H[22].Signed := 1;	Buffer.ui16_H[22].Unit := 'mbar';
	Buffer.ui16_H[23].Name := 'Pos_CBV_Set';	Buffer.ui16_H[23].Co := 1000;	Buffer.ui16_H[23].Signed := 0;	Buffer.ui16_H[23].Unit := '';
	Buffer.ui16_H[24].Name := 'Pos_CBV_Act_A1';	Buffer.ui16_H[24].Co := 1000;	Buffer.ui16_H[24].Signed := 0;	Buffer.ui16_H[24].Unit := '';
	Buffer.ui16_H[25].Name := 'Pos_CBV_Act_B1';	Buffer.ui16_H[25].Co := 1000;	Buffer.ui16_H[25].Signed := 0;	Buffer.ui16_H[25].Unit := '';
	Buffer.ui16_H[26].Name := 'Pos_WG_Set';		Buffer.ui16_H[26].Co := 1000;	Buffer.ui16_H[26].Signed := 0;	Buffer.ui16_H[26].Unit := '';
	Buffer.ui16_H[27].Name := 'Pos_WG_Act_A';	Buffer.ui16_H[27].Co := 1000;	Buffer.ui16_H[27].Signed := 0;	Buffer.ui16_H[27].Unit := '';
	Buffer.ui16_H[28].Name := 'Pos_WG_Act_B';	Buffer.ui16_H[28].Co := 1000;	Buffer.ui16_H[28].Signed := 0;	Buffer.ui16_H[28].Unit := '';
	Buffer.ui16_H[29].Name := 'Pr_P1HP_A';		Buffer.ui16_H[29].Co := 1000;	Buffer.ui16_H[29].Signed := 0;	Buffer.ui16_H[29].Unit := 'bar';
	Buffer.ui16_H[30].Name := 'Pr_P1HP_B';		Buffer.ui16_H[30].Co := 1000;	Buffer.ui16_H[30].Signed := 0;	Buffer.ui16_H[30].Unit := 'bar';
	Buffer.ui16_H[31].Name := 'Pr_P2s_A';		Buffer.ui16_H[31].Co := 1000;	Buffer.ui16_H[31].Signed := 0;	Buffer.ui16_H[31].Unit := 'bar';
	Buffer.ui16_H[32].Name := 'Pr_P2s_B';		Buffer.ui16_H[32].Co := 1000;	Buffer.ui16_H[32].Signed := 0;	Buffer.ui16_H[32].Unit := 'bar';
	Buffer.ui16_H[33].Name := 'Pr_P3HP_A';		Buffer.ui16_H[33].Co := 1000;	Buffer.ui16_H[33].Signed := 0;	Buffer.ui16_H[33].Unit := 'bar';
	Buffer.ui16_H[34].Name := 'Pr_P3HP_B';		Buffer.ui16_H[34].Co := 1000;	Buffer.ui16_H[34].Signed := 0;	Buffer.ui16_H[34].Unit := 'bar';
	Buffer.ui16_H[35].Name := 'Pr_P3LP_A';		Buffer.ui16_H[35].Co := 1000;	Buffer.ui16_H[35].Signed := 0;	Buffer.ui16_H[35].Unit := 'bar';
	Buffer.ui16_H[36].Name := 'Pr_P3LP_B';		Buffer.ui16_H[36].Co := 1000;	Buffer.ui16_H[36].Signed := 0;	Buffer.ui16_H[36].Unit := 'bar';
	Buffer.ui16_H[37].Name := 'Pr_P4LP_A';		Buffer.ui16_H[37].Co := 1000;	Buffer.ui16_H[37].Signed := 0;	Buffer.ui16_H[37].Unit := 'bar';
	Buffer.ui16_H[38].Name := 'Pr_P4LP_B';		Buffer.ui16_H[38].Co := 1000;	Buffer.ui16_H[38].Signed := 0;	Buffer.ui16_H[38].Unit := 'bar';
	Buffer.ui16_H[39].Name := 'Pr_ECW';			Buffer.ui16_H[39].Co := 1000;	Buffer.ui16_H[39].Signed := 0;	Buffer.ui16_H[39].Unit := 'bar';
	Buffer.ui16_H[40].Name := 'Pr_EO';			Buffer.ui16_H[40].Co := 1000;	Buffer.ui16_H[40].Signed := 0;	Buffer.ui16_H[40].Unit := 'bar';
	Buffer.ui16_H[41].Name := 'NOx_Sensor_1';	Buffer.ui16_H[41].Co := 1;		Buffer.ui16_H[41].Signed := 0;	Buffer.ui16_H[41].Unit := '';
	Buffer.ui16_H[42].Name := 'NOx_Sensor_2';	Buffer.ui16_H[42].Co := 1;		Buffer.ui16_H[42].Signed := 0;	Buffer.ui16_H[42].Unit := '';
	Buffer.ui16_H[43].Name := 'O2_Sensor_1';	Buffer.ui16_H[43].Co := 1;		Buffer.ui16_H[43].Signed := 0;	Buffer.ui16_H[43].Unit := '';
	Buffer.ui16_H[44].Name := 'O2_Sensor_2';	Buffer.ui16_H[44].Co := 1;		Buffer.ui16_H[44].Signed := 0;	Buffer.ui16_H[44].Unit := '';
	Buffer.ui16_H[45].Name := '';				Buffer.ui16_H[45].Co := 0;		Buffer.ui16_H[45].Signed := 0;	Buffer.ui16_H[45].Unit := '';
	Buffer.ui16_H[46].Name := '';				Buffer.ui16_H[46].Co := 0;		Buffer.ui16_H[46].Signed := 0;	Buffer.ui16_H[46].Unit := '';

	Buffer.iCnt_ui16_H	:=	44;


	(** ui16_L Names, Conversions, Signs and Units *)
	FOR iSet:=0 TO 56 DO
		Buffer.ui16_low[iSet].Signed	:= 0;
		Buffer.ui16_low[iSet].Unit		:= '°C';
		Buffer.ui16_low[iSet].Co		:=	100;
	END_FOR

	Buffer.ui16_low[0].Name := 'T_T2s';
	Buffer.ui16_low[1].Name := 'T_T3HP_A';		Buffer.ui16_low[1].Co := 10;	(* nur EG temps mit Conversion 10 *)
	Buffer.ui16_low[2].Name := 'T_T3HP_B';		Buffer.ui16_low[2].Co := 10;
	Buffer.ui16_low[3].Name := 'T_T3LP_A';		Buffer.ui16_low[3].Co := 10;
	Buffer.ui16_low[4].Name := 'T_T3LP_B';		Buffer.ui16_low[4].Co := 10;
	Buffer.ui16_low[5].Name := 'T_EG_LimMax';	Buffer.ui16_low[5].Co := 10;

	iCnt	:=	0; (* zyl 1 bis 11 *)
	FOR iSet:=6 TO 36 BY 3 DO
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));
		Buffer.ui16_low[iSet].Name		:= 'T_EG_Cyl_';		strcat(ADR(Buffer.ui16_low[iSet].Name), ADR(strCnt));
		Buffer.ui16_low[iSet+1].Name	:= 'T_CBearing_';	strcat(ADR(Buffer.ui16_low[iSet+1].Name), ADR(strCnt));
		Buffer.ui16_low[iSet+2].Name	:= 'T_MBearing_';	strcat(ADR(Buffer.ui16_low[iSet+2].Name), ADR(strCnt));
	END_FOR
	iCnt	:=	11;	(* zyl 12 bis 20 *)
	FOR iSet:=39 TO 55 BY 2 DO
		iCnt := iCnt +1;	itoa(iCnt,ADR(strCnt));
		Buffer.ui16_low[iSet].Name		:= 'T_EG_Cyl_';		strcat(ADR(Buffer.ui16_low[iSet].Name), ADR(strCnt));
		Buffer.ui16_low[iSet+1].Name	:= 'T_CBearing_';	strcat(ADR(Buffer.ui16_low[iSet+1].Name), ADR(strCnt));
	END_FOR

	Buffer.ui16_low[57].Name := '';	Buffer.ui16_low[57].Co := 0;	Buffer.ui16_low[57].Signed := 0;	Buffer.ui16_low[57].Unit := '';

	Buffer.iCnt_ui16_low		:=	56;

END_PROGRAM


PROGRAM _CYCLIC


(** 1: is PBCMem enabled? *)
IF bPBC_Mem_Ena THEN

(** 6: save data to buffer? @control *)
	IF 	bPBC_NewData AND bPBC_Record THEN

(** 6.1: save the time *)
		Buffer.timer[iCnt_Cycle]	:= tiStamp;
(* _______________________________________________________ FAKE BITS _______________________________________________________ *)

		Buffer.Bits[0].ucData[iCnt_Cycle]	:=	1;
		Buffer.Bits[1].ucData[iCnt_Cycle]	:=	0;
		FOR iSet:= 1 TO 16 DO
			Buffer.pattern[iSet].BitPattern[iCnt_Cycle]	:=	INT_TO_UDINT(iCnt_Cycle) + INT_TO_UDINT(iCnt_Cycle)*1000;
		END_FOR

(* _______________________________________________________ FAKE PATTERNS _______________________________________________________ *)

	iCnt_Cycle10	:=	LIMIT(0,iCnt_Cycle/10,100);

	iCnt := 0;	FOR iSet:=0 TO 304 BY 16 DO			Buffer.ui16[iSet].Data[iCnt_Cycle] := 1914;			END_FOR
	iCnt := 0;	FOR iSet:=1 TO 305 BY 16 DO			Buffer.ui16[iSet].Data[iCnt_Cycle] := 43;			END_FOR
	iCnt := 0;	FOR iSet:=2 TO 306 BY 16 DO			Buffer.ui16[iSet].Data[iCnt_Cycle] := 15;			END_FOR
	iCnt := 0;	FOR iSet:=3 TO 307 BY 16 DO			Buffer.ui16[iSet].Data[iCnt_Cycle] := 6210;			END_FOR
	iCnt := 0;	FOR iSet:=4 TO 308 BY 16 DO			Buffer.ui16[iSet].Data[iCnt_Cycle] := 1492;			END_FOR
(* 5 fehlt *)
	iCnt := 0;	FOR iSet:=6 TO 310 BY 16 DO			Buffer.ui16[iSet].Data[iCnt_Cycle] := 166;			END_FOR
	iCnt := 0;	FOR iSet:=7 TO 311 BY 16 DO			Buffer.ui16[iSet].Data[iCnt_Cycle] := 166;			END_FOR
	iCnt := 0;	FOR iSet:=8 TO 312 BY 16 DO			Buffer.ui16[iSet].Data[iCnt_Cycle] := 15816;		END_FOR
	iCnt := 0;	FOR iSet:=9 TO 313 BY 16 DO			Buffer.ui16[iSet].Data[iCnt_Cycle] := 15816;		END_FOR
	iCnt := 0;	FOR iSet:=10 TO 314 BY 16 DO		Buffer.ui16[iSet].Data[iCnt_Cycle] := 2611;			END_FOR
	iCnt := 0;	FOR iSet:=11 TO 315 BY 16 DO		Buffer.ui16[iSet].Data[iCnt_Cycle] := 2233;			END_FOR
	iCnt := 0;	FOR iSet:=12 TO 316 BY 16 DO		Buffer.ui16[iSet].Data[iCnt_Cycle] := 5914;			END_FOR
	iCnt := 0;	FOR iSet:=13 TO 317 BY 16 DO		Buffer.ui16[iSet].Data[iCnt_Cycle] := 1000;			END_FOR
	iCnt := 0;	FOR iSet:=14 TO 318 BY 16 DO		Buffer.ui16[iSet].Data[iCnt_Cycle] := 2233;			END_FOR
	iCnt := 0;	FOR iSet:=15 TO 319 BY 16 DO		Buffer.ui16[iSet].Data[iCnt_Cycle] := 65293;		END_FOR
	iCnt := 0;	FOR iSet:=16 TO 320 BY 16 DO		Buffer.ui16[iSet].Data[iCnt_Cycle] := 166;			END_FOR


	Buffer.ui16_H[0].Hi[iCnt_Cycle] := 10000;		Buffer.ui16_H[0].Lo[iCnt_Cycle] := 9990;
	Buffer.ui16_H[1].Hi[iCnt_Cycle] := 10380;		Buffer.ui16_H[1].Lo[iCnt_Cycle] := 10340;
	Buffer.ui16_H[2].Hi[iCnt_Cycle] := 10434;		Buffer.ui16_H[2].Lo[iCnt_Cycle] := 10428;
	Buffer.ui16_H[3].Hi[iCnt_Cycle] := 26;			Buffer.ui16_H[3].Lo[iCnt_Cycle] := 34;
	Buffer.ui16_H[4].Hi[iCnt_Cycle] := 10621;		Buffer.ui16_H[4].Lo[iCnt_Cycle] := 10622;
	Buffer.ui16_H[5].Hi[iCnt_Cycle] := 10621;		Buffer.ui16_H[5].Lo[iCnt_Cycle] := 10622;
	Buffer.ui16_H[6].Hi[iCnt_Cycle] := 10621;		Buffer.ui16_H[6].Lo[iCnt_Cycle] := 10622;
	Buffer.ui16_H[7].Hi[iCnt_Cycle] := 568;			Buffer.ui16_H[7].Lo[iCnt_Cycle] := 569;
	Buffer.ui16_H[8].Hi[iCnt_Cycle] := 568;			Buffer.ui16_H[8].Lo[iCnt_Cycle] := 568;
	Buffer.ui16_H[9].Hi[iCnt_Cycle] := 574;			Buffer.ui16_H[9].Lo[iCnt_Cycle] := 571;
	Buffer.ui16_H[10].Hi[iCnt_Cycle] := 50000;		Buffer.ui16_H[10].Lo[iCnt_Cycle] := 49990;
	Buffer.ui16_H[11].Hi[iCnt_Cycle] := 100;		Buffer.ui16_H[11].Lo[iCnt_Cycle] := 100;
	Buffer.ui16_H[12].Hi[iCnt_Cycle] := 1973;		Buffer.ui16_H[12].Lo[iCnt_Cycle] := 1973;
	Buffer.ui16_H[13].Hi[iCnt_Cycle] := 7630;		Buffer.ui16_H[13].Lo[iCnt_Cycle] := 7630;
	Buffer.ui16_H[14].Hi[iCnt_Cycle] := 2760;		Buffer.ui16_H[14].Lo[iCnt_Cycle] := 2763;
	Buffer.ui16_H[15].Hi[iCnt_Cycle] := 2753;		Buffer.ui16_H[15].Lo[iCnt_Cycle] := 2753;
	Buffer.ui16_H[16].Hi[iCnt_Cycle] := 2625;		Buffer.ui16_H[16].Lo[iCnt_Cycle] := 2596;
	Buffer.ui16_H[17].Hi[iCnt_Cycle] := 2594;		Buffer.ui16_H[17].Lo[iCnt_Cycle] := 2594;
	Buffer.ui16_H[18].Hi[iCnt_Cycle] := 8815;		Buffer.ui16_H[18].Lo[iCnt_Cycle] := 8818;
	Buffer.ui16_H[19].Hi[iCnt_Cycle] := 8853;		Buffer.ui16_H[19].Lo[iCnt_Cycle] := 8853;
	Buffer.ui16_H[20].Hi[iCnt_Cycle] := 5369;		Buffer.ui16_H[20].Lo[iCnt_Cycle] := 5369;
	Buffer.ui16_H[21].Hi[iCnt_Cycle] := 6851;		Buffer.ui16_H[21].Lo[iCnt_Cycle] := 6851;
	Buffer.ui16_H[22].Hi[iCnt_Cycle] := 62867;		Buffer.ui16_H[22].Lo[iCnt_Cycle] := 62987;
	Buffer.ui16_H[23].Hi[iCnt_Cycle] := 28;			Buffer.ui16_H[23].Lo[iCnt_Cycle] := 28;
	Buffer.ui16_H[24].Hi[iCnt_Cycle] := 29;			Buffer.ui16_H[24].Lo[iCnt_Cycle] := 28;
	Buffer.ui16_H[25].Hi[iCnt_Cycle] := 26;			Buffer.ui16_H[25].Lo[iCnt_Cycle] := 25;
	Buffer.ui16_H[26].Hi[iCnt_Cycle] := 478;		Buffer.ui16_H[26].Lo[iCnt_Cycle] := 478;
	Buffer.ui16_H[27].Hi[iCnt_Cycle] := 487;		Buffer.ui16_H[27].Lo[iCnt_Cycle] := 486;
	Buffer.ui16_H[28].Hi[iCnt_Cycle] := 488;		Buffer.ui16_H[28].Lo[iCnt_Cycle] := 488;
	Buffer.ui16_H[29].Hi[iCnt_Cycle] := 3210;		Buffer.ui16_H[29].Lo[iCnt_Cycle] := 3213;
	Buffer.ui16_H[30].Hi[iCnt_Cycle] := 3236;		Buffer.ui16_H[30].Lo[iCnt_Cycle] := 3233;
	Buffer.ui16_H[31].Hi[iCnt_Cycle] := 6732;		Buffer.ui16_H[31].Lo[iCnt_Cycle] := 6733;
	Buffer.ui16_H[32].Hi[iCnt_Cycle] := 6662;		Buffer.ui16_H[32].Lo[iCnt_Cycle] := 6662;
	Buffer.ui16_H[33].Hi[iCnt_Cycle] := 4605;		Buffer.ui16_H[33].Lo[iCnt_Cycle] := 4621;
	Buffer.ui16_H[34].Hi[iCnt_Cycle] := 4675;		Buffer.ui16_H[34].Lo[iCnt_Cycle] := 4675;
	Buffer.ui16_H[35].Hi[iCnt_Cycle] := 2864;		Buffer.ui16_H[35].Lo[iCnt_Cycle] := 2873;
	Buffer.ui16_H[36].Hi[iCnt_Cycle] := 2879;		Buffer.ui16_H[36].Lo[iCnt_Cycle] := 2870;
	Buffer.ui16_H[37].Hi[iCnt_Cycle] := 1026;		Buffer.ui16_H[37].Lo[iCnt_Cycle] := 1029;
	Buffer.ui16_H[38].Hi[iCnt_Cycle] := 1021;		Buffer.ui16_H[38].Lo[iCnt_Cycle] := 1017;
	Buffer.ui16_H[39].Hi[iCnt_Cycle] := 2147;		Buffer.ui16_H[39].Lo[iCnt_Cycle] := 2128;
	Buffer.ui16_H[40].Hi[iCnt_Cycle] := 5797;		Buffer.ui16_H[40].Lo[iCnt_Cycle] := 5794;
	Buffer.ui16_H[41].Hi[iCnt_Cycle] := 216;		Buffer.ui16_H[41].Lo[iCnt_Cycle] := 216;
	Buffer.ui16_H[42].Hi[iCnt_Cycle] := 219;		Buffer.ui16_H[42].Lo[iCnt_Cycle] := 219;
	Buffer.ui16_H[43].Hi[iCnt_Cycle] := 0;			Buffer.ui16_H[43].Lo[iCnt_Cycle] := 0;
	Buffer.ui16_H[44].Hi[iCnt_Cycle] := 0;			Buffer.ui16_H[44].Lo[iCnt_Cycle] := 0;
	Buffer.ui16_H[45].Hi[iCnt_Cycle] := 0;			Buffer.ui16_H[45].Lo[iCnt_Cycle] := 0;
	Buffer.ui16_H[46].Hi[iCnt_Cycle] := 0;			Buffer.ui16_H[46].Lo[iCnt_Cycle] := 0;


	Buffer.ui16_low[0].Data[iCnt_Cycle10] := 7545;	
	Buffer.ui16_low[1].Data[iCnt_Cycle10] := 5366;
	Buffer.ui16_low[2].Data[iCnt_Cycle10] := 5366;
	Buffer.ui16_low[3].Data[iCnt_Cycle10] := 4577;
	Buffer.ui16_low[4].Data[iCnt_Cycle10] := 4605;
	Buffer.ui16_low[5].Data[iCnt_Cycle10] := 6000;

	FOR iSet:=6 TO 36 BY 3 DO
		Buffer.ui16_low[iSet].Data[iCnt_Cycle10]	:= 52900;		(* 6,9,12 bis 36 *)
		Buffer.ui16_low[iSet+1].Data[iCnt_Cycle10]	:= 10100;		(* 7,10,13 bis 37 *)
		Buffer.ui16_low[iSet+2].Data[iCnt_Cycle10]	:= 10120;		(* 8,11,14 bis 38 *)
	END_FOR
	FOR iSet:=39 TO 55 BY 2 DO
		Buffer.ui16_low[iSet].Data[iCnt_Cycle10]	:= 52900;		(* 39,41,43 bis 55 *)
		Buffer.ui16_low[iSet+1].Data[iCnt_Cycle10]	:= 10100;		(* 40,42,44 bis 56 *)
	END_FOR

	Buffer.ui16_low[57].Data[iCnt_Cycle10] := 0;


(* ________________________________________________________________________ TEST ____________________________________ *)

		bPBC_NewData	:=	FALSE;

(** 6.6: increase cycle counter *)
		iCnt_Cycle := (iCnt_Cycle +1) MOD iBufferSize;
	END_IF



	bWarn_Buffer	:=	iTC_Max = INT_TO_UINT(Buffer.iCnt_ui16_H) OR
						iEC_Max = INT_TO_UINT(Buffer.iCnt_ui16) OR
						iSC_Max = INT_TO_UINT(Buffer.iCnt_ui16_low) OR
						iPC_Max = INT_TO_UINT(Buffer.iCnt_pattern);

END_IF

END_PROGRAM

PROGRAM _EXIT

	(** EXIT: Enable PBC_Buffer Task *)
	bECB_Buffer_Test	:=	FALSE;

END_PROGRAM