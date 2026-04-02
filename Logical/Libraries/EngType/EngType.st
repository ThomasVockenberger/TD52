(********************************************************************

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2024

Customized modifications: -
------------------------

History:
-------
V0.1	16-10-2002	Fahringer, generated from leanox.c V1.2
		11-03-2003	Weitzer,   last modification (IC100)
V0.11	29-09-2003	Weitzer,   boost pressure mA scaling corrected
V0.12   08-10-2003	Fahrigner, boost pressure mA scaling corrected
V0.20	23-02-2007	Weitzer,   converting engineering units to analog outputs
V0.21	30-01-2008	Weitzer,   P2 sensor - monitoring measurement signal
V0.30	07-02-2008	Weitzer,   engine type J624 added
V0.31	11-03-2009	Weitzer,   MISFIRE order corrected for SAFI system
V0.40	22-06-2010	Weitzer,   engine type J920 added 
V3.90	21-02-2012	Denk,      generated from io_scalCyclic.st 
V9.91	08-05-2014	Zengerer   X616 customized version for Series6 Diesel engine X616
V4.04	07-11-2016	Denk,  	   Con_Rod value type9 changed. 425 --> 800
V4.04.1	17-07-2017	Gwiggner,  bugfix for additional checking of ignition type
V4.11	21-06-2021	Kafka,	   add skip fire pattern for port injection engines
V4.13	08-11-2023	Andre,	   add J424 engine type. Add skip fire pattern for J624.

Instructions for use:
--------------------
- Engine specific variables are setted in this function block
  
Outstandings: - 
------------

*******************************************************************************)

FUNCTION_BLOCK EngType
	
	(* Two possibilities to activate SAFI specific fire/misfire order *)
	bSAFI_Act		:= (IgnType=1);		
	bSAFIIgn_Act	:= (IgnType=1);		
	
	(* Reset of engine series specific values *)
	Type2	:=	FALSE;
	Type3	:=	FALSE;
	Type4	:=	FALSE;
	Type6	:=	FALSE;
	Type9	:=	FALSE;
	Type16	:=	FALSE;		(*X616*)

	(* Set of engine series specific values *)
	IF Motortype < 300 THEN	
		Type2 := TRUE;
		Stroke 	:= 145;
		Bore	:= 135;
			
	ELSIF Motortype < 400 THEN	
		Type3 := TRUE;
		Stroke 	:= 170;
		Bore	:= 135;
	ELSIF Motortype < 600 THEN
		Type4	:= TRUE;
		Stroke 	:= 185;
		Bore	:= 145;
		Con_Rod	:= 320;
			
	ELSIF (Motortype < 900	OR	
		   Motortype >1600)	THEN	
		Type6 	:= TRUE;
		Type16	:= TRUE;		(*X616*)
		Stroke 	:= 220;
		Bore	:= 190;
		Con_Rod := 425;
			
	ELSE
		Type9	:= TRUE;
		Stroke 	:= 350;
		Bore	:= 310;
		Con_Rod := 800;	
			
	END_IF;
	
	(* calculate number of cylinders *)
	NumberOfCylinder	:= UINT_TO_USINT(Motortype MOD 100);
	
	(* determinate engine series, number of cylinders, firing order, timing seqence and ignition distance *)
	IF (Motortype <> usMotorTyp) OR (IgnType <> usIgnType) THEN			(* check for changed engine type and ignition type*)
		usIgnType := IgnType;
		usMotorTyp := Motortype;
		usZahnzahlOld := 0;					(* for initialize speed measurement *)
		FireOrder[9]  := 0;					(* predefine firing order *)				
		FireOrder[10] := 0;
		FireOrder[11] := 0;
		FireOrder[12] := 0;
		FireOrder[13] := 0;
		FireOrder[14] := 0;
		FireOrder[15] := 0;
		FireOrder[16] := 0;
		FireOrder[17] := 0;
		FireOrder[18] := 0;
		FireOrder[19] := 0;
		FireOrder[20] := 0;
		FireOrder[21] := 0;
		FireOrder[22] := 0;
		FireOrder[23] := 0;
		FireOrder[24] := 0;
	
		MisfireOrder[9]  := 0;				(* predefine misfire order *)
		MisfireOrder[10] := 0;
		MisfireOrder[11] := 0;
		MisfireOrder[12] := 0;
		MisfireOrder[13] := 0;
		MisfireOrder[14] := 0;
		MisfireOrder[15] := 0;
		MisfireOrder[16] := 0;
		MisfireOrder[17] := 0;
		MisfireOrder[18] := 0;
		MisfireOrder[19] := 0;
		MisfireOrder[20] := 0;
		MisfireOrder[21] := 0;
		MisfireOrder[22] := 0;
		MisfireOrder[23] := 0;
		MisfireOrder[24] := 0;
		
		SkipfireOrder[0] := 0;				(* predefine skip fire order *)
		SkipfireOrder[1] := 0;
		SkipfireOrder[2] := 0;
		SkipfireOrder[3] := 0;
		SkipfireOrder[4] := 0;
		SkipfireOrder[5] := 0;
		SkipfireOrder[6] := 0;
		SkipfireOrder[7] := 0;
		SkipfireOrder[8] := 0;
		SkipfireOrder[9]  := 0;
		SkipfireOrder[10] := 0;
		SkipfireOrder[11] := 0;
		SkipfireOrder[12] := 0;
		SkipfireOrder[13] := 0;
		SkipfireOrder[14] := 0;
		SkipfireOrder[15] := 0;
		SkipfireOrder[16] := 0;
		SkipfireOrder[17] := 0;
		SkipfireOrder[18] := 0;
		SkipfireOrder[19] := 0;
		SkipfireOrder[20] := 0;
		SkipfireOrder[21] := 0;
		SkipfireOrder[22] := 0;
		SkipfireOrder[23] := 0;
		SkipfireOrder[24] := 0;
		
		ERR_INVALID_MOTORTYPE := 0; 			(* reset FB error *)	
		
		CASE Motortype OF
		(* engine J208 *)
		208 : 	usMotorTyp 		:= Motortype;				
				Type 			:= 2;				(* engine series 2 *)
				NumberOfTeeth 	:= 162;				(* teeth number of starter ring gear *)
				IgnDistance   	:= 90;				(* ignition distance *)
				DistanceAB 		:= 900;				
				DistanceBA 		:= 900;
				
				FireOrder[1] := 1;					(* firing order *)
				FireOrder[2] := 6;
				FireOrder[3] := 2;
				FireOrder[4] := 4;
				FireOrder[5] := 8;
				FireOrder[6] := 3;
				FireOrder[7] := 7;
				FireOrder[8] := 5;
	
				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1] := 2#00000000000000000000000010000000;	(* cylinder 12 switched off *)
					MisfireOrder[2] := 2#00000000000000000000000010001000;	(* cylinder 12 and 6 switched off *)
					MisfireOrder[3] := 2#00000000000000000000000011001000;	(* cylinder 12 to 11 and 6 switched off *)
					MisfireOrder[4] := 2#00000000000000000000000011001100;	(* cylinder 12 to 11 and 6 to 5  switched off *)
					MisfireOrder[5] := 2#00000000000000000000000011101100;	(* cylinder 12 to 10 and 6 to 5 switched off *)
					MisfireOrder[6] := 2#00000000000000000000000011101110;	(* cylinder 12 to 10 and 6 to 4 switched off *)
					MisfireOrder[7] := 2#00000000000000000000000011111110;	(* cylinder 12 to  9 and 6 to 4 switched off *)
					MisfireOrder[8] := 2#00000000000000000000000011111111;	(* cylinder 12 to  9 and 6 to 3 switched off *)
				ELSE
					MisfireOrder[1] := 16#00000010;	(* cylinder 8 switched off *)
					MisfireOrder[2] := 16#00000050;	(* cylinder 8-7 switched off *)
					MisfireOrder[3] := 16#00000052;	(* cylinder 8-6 switched off *)
					MisfireOrder[4] := 16#000000D2;	(* cylinder 8-5 switched off *)
					MisfireOrder[5] := 16#000000DA;	(* cylinder 8-4 switched off *)
					MisfireOrder[6] := 16#000000FA;	(* cylinder 8-3 switched off *)
					MisfireOrder[7] := 16#000000FE;	(* cylinder 8-2 switched off *)
					MisfireOrder[8] := 16#000000FF;	(* cylinder 8-1 switched off *)
				END_IF
				
				
		(* engine J212 *)
		212 : 	usMotorTyp 		:= Motortype;		
				Type 			:= 2;				(* engine series 2		*)
				NumberOfTeeth 	:= 164;				(* teeth number of starter ring gear 		*)
				IgnDistance 	:= 50;				(* ignition distance 	*)
				TimingSeq 		:= 21;				(* timing sequence 		*)
				DistanceAB 		:= 500;				
				DistanceBA 		:= 700;
								
				FireOrder[1]  := 1;					(* firing order 		*)
				FireOrder[2]  := 8;
				FireOrder[3]  := 5;
				FireOrder[4]  := 10;
				FireOrder[5]  := 3;
				FireOrder[6]  := 7;
				FireOrder[7]  := 6;
				FireOrder[8]  := 11;
				FireOrder[9]  := 2;
				FireOrder[10] := 9;
				FireOrder[11] := 4;
				FireOrder[12] := 12;

				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000000000000000100000000000;	(* cylinder 12 switched off *)
					MisfireOrder[2]  := 2#00000000000000000000100000100000;	(* cylinder 12 and 6 switched off *)
					MisfireOrder[3]  := 2#00000000000000000000110000100000;	(* cylinder 12 to 11 and 6 switched off *)
					MisfireOrder[4]  := 2#00000000000000000000110000110000;	(* cylinder 12 to 11 and 6 to 5  switched off *)
					MisfireOrder[5]  := 2#00000000000000000000111000110000;	(* cylinder 12 to 10 and 6 to 5 switched off *)
					MisfireOrder[6]  := 2#00000000000000000000111000111000;	(* cylinder 12 to 10 and 6 to 4 switched off *)
					MisfireOrder[7]  := 2#00000000000000000000111100111000;	(* cylinder 12 to  9 and 6 to 4 switched off *)
					MisfireOrder[8]  := 2#00000000000000000000111100111100;	(* cylinder 12 to  9 and 6 to 3 switched off *)
					MisfireOrder[9]  := 2#00000000000000000000111110111100;	(* cylinder 12 to  8 and 6 to 3 switched off *)
					MisfireOrder[10] := 2#00000000000000000000111110111110;	(* cylinder 12 to  8 and 6 to 2 switched off *)
					MisfireOrder[11] := 2#00000000000000000000111111111110;	(* cylinder 12 to  7 and 6 to 2 switched off *)
					MisfireOrder[12] := 2#00000000000000000000111111111111;	(* cylinder 12 to  7 and 6 to 1 switched off *)
				ELSE	
					MisfireOrder[1]  := 16#00000800;	(* cylinder 12 switched off *)
					MisfireOrder[2]  := 16#00000840;	(* cylinder 12, 6 switched off *)
					MisfireOrder[3]  := 16#000008C0;	(* cylinder 12-11, 6 switched off *)
					MisfireOrder[4]  := 16#000008C4;	(* cylinder 12-11, 6-5 switched off *)
					MisfireOrder[5]  := 16#000008CC;	(* cylinder 12-10, 6-5 switched off *)
					MisfireOrder[6]  := 16#00000CCC;	(* cylinder 12-10, 6-4 switched off *)
					MisfireOrder[7]  := 16#00000ECC;	(* cylinder 12-9, 6-4 switched off *)
					MisfireOrder[8]  := 16#00000EDC;	(* cylinder 12-9, 6-3 switched off *)
					MisfireOrder[9]  := 16#00000EDE;	(* cylinder 12-8, 6-3 switched off *)
					MisfireOrder[10] := 16#00000FDE;	(* cylinder 12-8, 6-2 switched off *)
					MisfireOrder[11] := 16#00000FFE;	(* cylinder 12-7, 6-2 switched off *)
					MisfireOrder[12] := 16#00000FFF;	(* cylinder 12-1 switched off *)
				END_IF
				
				
		(* engine J216 *)	
		216 :	usMotorTyp 		:= Motortype; 
				Type 			:= 2;				(* engine series 2		*)
				NumberOfTeeth 	:= 164;				(* teeth number of starter ring gear 		*)
				IgnDistance 	:= 20;				(* ignition distance 	*)
				TimingSeq 		:= 23;				(* timing sequence 		*)
				DistanceAB 		:= 200; 		
				DistanceBA 		:= 700;
				
				FireOrder[1]  := 1;					(* firing order 		*)
				FireOrder[2]  := 13;
				FireOrder[3]  := 5;
				FireOrder[4]  := 15;
				FireOrder[5]  := 7;
				FireOrder[6]  := 11;
				FireOrder[7]  := 3;
				FireOrder[8]  := 16;
				FireOrder[9]  := 8;
				FireOrder[10] := 12;
				FireOrder[11] := 4;
				FireOrder[12] := 10;
				FireOrder[13] := 2;
				FireOrder[14] := 14;
				FireOrder[15] := 6;
				FireOrder[16] := 9;

				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000000000001000000000000000;	(* cylinder 16 switched off *)
					MisfireOrder[2]  := 2#00000000000000001000000010000000;	(* cylinder 16 and 8 switched off *)
					MisfireOrder[3]  := 2#00000000000000001100000010000000;	(* cylinder 16 to 15 and 8 switched off *)
					MisfireOrder[4]  := 2#00000000000000001100000011000000;	(* cylinder 16 to 15 and 8 to 7  switched off *)
					MisfireOrder[5]  := 2#00000000000000001110000011000000;	(* cylinder 16 to 14 and 8 to 7 switched off *)
					MisfireOrder[6]  := 2#00000000000000001110000011100000;	(* cylinder 16 to 14 and 8 to 6 switched off *)
					MisfireOrder[7]  := 2#00000000000000001111000011100000;	(* cylinder 16 to 13 and 8 to 6 switched off *)
					MisfireOrder[8]  := 2#00000000000000001111000011110000;	(* cylinder 16 to 13 and 8 to 5 switched off *)
					MisfireOrder[9]  := 2#00000000000000001111100011110000;	(* cylinder 16 to 12 and 8 to 5 switched off *)
					MisfireOrder[10] := 2#00000000000000001111100011111000;	(* cylinder 16 to 12 and 8 to 4 switched off *)
					MisfireOrder[11] := 2#00000000000000001111110011111000;	(* cylinder 16 to 11 and 8 to 4 switched off *)
					MisfireOrder[12] := 2#00000000000000001111110011111100;	(* cylinder 16 to 11 and 8 to 3 switched off *)
					MisfireOrder[13] := 2#00000000000000001111111011111100;	(* cylinder 16 to 10 and 8 to 3 switched off *)
					MisfireOrder[14] := 2#00000000000000001111111011111110;	(* cylinder 16 to 10 and 8 to 2 switched off *)
					MisfireOrder[15] := 2#00000000000000001111111111111110;	(* cylinder 16 to  9 and 8 to 2 switched off *)
					MisfireOrder[16] := 2#00000000000000001111111111111111;	(* cylinder 20 to  9 and 8 to 1 switched off *)
				ELSE
					MisfireOrder[1]  := 16#00000080;	(* cylinder 16 switched off *)
					MisfireOrder[2]  := 16#00000180;	(* cylinder 16, 8 switched off *)
					MisfireOrder[3]  := 16#00000188;	(* cylinder 16-15, 8 switched off *)
					MisfireOrder[4]  := 16#00000198;	(* cylinder 16-15, 8-7 switched off *)
					MisfireOrder[5]  := 16#00002198;	(* cylinder 16-14, 8-7 switched off *)
					MisfireOrder[6]  := 16#00006198;	(* cylinder 16-14, 8-6 switched off *)
					MisfireOrder[7]  := 16#0000619A;	(* cylinder 16-13, 8-6 switched off *)
					MisfireOrder[8]  := 16#0000619E;	(* cylinder 16-13, 8-5 switched off *)
					MisfireOrder[9]  := 16#0000639E;	(* cylinder 16-12, 8-5 switched off *)
					MisfireOrder[10] := 16#0000679E;	(* cylinder 16-12, 8-4 switched off *)
					MisfireOrder[11] := 16#000067BE;	(* cylinder 16-11, 8-4 switched off *)
					MisfireOrder[12] := 16#000067FE;	(* cylinder 16-11, 8-3 switched off *)
					MisfireOrder[13] := 16#00006FFE;	(* cylinder 16-10, 8-3 switched off *)
					MisfireOrder[14] := 16#00007FFE;	(* cylinder 16-10, 8-2 switched off *)
					MisfireOrder[15] := 16#0000FFFE;	(* cylinder 16-9, 8-2 switched off *)
					MisfireOrder[16] := 16#0000FFFF;	(* cylinder 16-1 switched off *)
				END_IF
				
				
		(* engine J312 *)
		312 : 	usMotorTyp 		:= Motortype;
				Type 			:= 3;			(* engine series 3 		*)
				NumberOfTeeth 	:= 164;			(* teeth number of starter ring gear 		*)
				IgnDistance 	:= 50;			(* ignition distance 	*)
				TimingSeq 		:= 21;			(* timing sequence 		*)
				DistanceAB 		:= 500;				
				DistanceBA 		:= 700;
				
				FireOrder[1]  := 1;				(* firing order 		*)
				FireOrder[2]  := 8;
				FireOrder[3]  := 5;
				FireOrder[4]  := 10;
				FireOrder[5]  := 3;
				FireOrder[6]  := 7;
				FireOrder[7]  := 6;
				FireOrder[8]  := 11;
				FireOrder[9]  := 2;
				FireOrder[10] := 9;
				FireOrder[11] := 4;
				FireOrder[12] := 12;

				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000000000000000100000000000;	(* cylinder 12 switched off *)
					MisfireOrder[2]  := 2#00000000000000000000100000100000;	(* cylinder 12 and 6 switched off *)
					MisfireOrder[3]  := 2#00000000000000000000110000100000;	(* cylinder 12 to 11 and 6 switched off *)
					MisfireOrder[4]  := 2#00000000000000000000110000110000;	(* cylinder 12 to 11 and 6 to 5  switched off *)
					MisfireOrder[5]  := 2#00000000000000000000111000110000;	(* cylinder 12 to 10 and 6 to 5 switched off *)
					MisfireOrder[6]  := 2#00000000000000000000111000111000;	(* cylinder 12 to 10 and 6 to 4 switched off *)
					MisfireOrder[7]  := 2#00000000000000000000111100111000;	(* cylinder 12 to  9 and 6 to 4 switched off *)
					MisfireOrder[8]  := 2#00000000000000000000111100111100;	(* cylinder 12 to  9 and 6 to 3 switched off *)
					MisfireOrder[9]  := 2#00000000000000000000111110111100;	(* cylinder 12 to  8 and 6 to 3 switched off *)
					MisfireOrder[10] := 2#00000000000000000000111110111110;	(* cylinder 12 to  8 and 6 to 2 switched off *)
					MisfireOrder[11] := 2#00000000000000000000111111111110;	(* cylinder 12 to  7 and 6 to 2 switched off *)
					MisfireOrder[12] := 2#00000000000000000000111111111111;	(* cylinder 12 to  7 and 6 to 1 switched off *)
				ELSE	
					MisfireOrder[1]  := 16#00000800;	(* cylinder 12 switched off *)
					MisfireOrder[2]  := 16#00000840;	(* cylinder 12, 6 switched off *)
					MisfireOrder[3]  := 16#000008C0;	(* cylinder 12-11, 6 switched off *)
					MisfireOrder[4]  := 16#000008C4;	(* cylinder 12-11, 6-5 switched off *)
					MisfireOrder[5]  := 16#000008CC;	(* cylinder 12-10, 6-5 switched off *)
					MisfireOrder[6]  := 16#00000CCC;	(* cylinder 12-10, 6-4 switched off *)
					MisfireOrder[7]  := 16#00000ECC;	(* cylinder 12-9, 6-4 switched off *)
					MisfireOrder[8]  := 16#00000EDC;	(* cylinder 12-9, 6-3 switched off *)
					MisfireOrder[9]  := 16#00000EDE;	(* cylinder 12-8, 6-3 switched off *)
					MisfireOrder[10] := 16#00000FDE;	(* cylinder 12-8, 6-2 switched off *)
					MisfireOrder[11] := 16#00000FFE;	(* cylinder 12-7, 6-2 switched off *)
					MisfireOrder[12] := 16#00000FFF;	(* cylinder 12-1 switched off *)
				END_IF
		
		
		(* engine J412 *)
		412 : 	usMotorTyp 		:= Motortype;
				Type 			:= 4;			(* engine series 4		*)
				NumberOfTeeth 	:= 174;			(* teeth number of starter ring gear 		*)
				IgnDistance 	:= 50;			(* ignition distance 	*)
				TimingSeq 		:= 21;			(* timing sequence 		*)
				DistanceAB 		:= 500;				
				DistanceBA 		:= 700;
				
				FireOrder[1]  := 1;				(* firing order 		*)
				FireOrder[2]  := 8;
				FireOrder[3]  := 5;
				FireOrder[4]  := 10;
				FireOrder[5]  := 3;
				FireOrder[6]  := 7;
				FireOrder[7]  := 6;
				FireOrder[8]  := 11;
				FireOrder[9]  := 2;
				FireOrder[10] := 9;
				FireOrder[11] := 4;
				FireOrder[12] := 12;

				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000000000000000100000000000;	(* cylinder 12 switched off *)
					MisfireOrder[2]  := 2#00000000000000000000100000100000;	(* cylinder 12 and 6 switched off *)
					MisfireOrder[3]  := 2#00000000000000000000110000100000;	(* cylinder 12 to 11 and 6 switched off *)
					MisfireOrder[4]  := 2#00000000000000000000110000110000;	(* cylinder 12 to 11 and 6 to 5  switched off *)
					MisfireOrder[5]  := 2#00000000000000000000111000110000;	(* cylinder 12 to 10 and 6 to 5 switched off *)
					MisfireOrder[6]  := 2#00000000000000000000111000111000;	(* cylinder 12 to 10 and 6 to 4 switched off *)
					MisfireOrder[7]  := 2#00000000000000000000111100111000;	(* cylinder 12 to  9 and 6 to 4 switched off *)
					MisfireOrder[8]  := 2#00000000000000000000111100111100;	(* cylinder 12 to  9 and 6 to 3 switched off *)
					MisfireOrder[9]  := 2#00000000000000000000111110111100;	(* cylinder 12 to  8 and 6 to 3 switched off *)
					MisfireOrder[10] := 2#00000000000000000000111110111110;	(* cylinder 12 to  8 and 6 to 2 switched off *)
					MisfireOrder[11] := 2#00000000000000000000111111111110;	(* cylinder 12 to  7 and 6 to 2 switched off *)
					MisfireOrder[12] := 2#00000000000000000000111111111111;	(* cylinder 12 to  7 and 6 to 1 switched off *)
				ELSE	
					MisfireOrder[1]  := 16#00000800;	(* cylinder 12 switched off *)
					MisfireOrder[2]  := 16#00000840;	(* cylinder 12, 6 switched off *)
					MisfireOrder[3]  := 16#000008C0;	(* cylinder 12-11, 6 switched off *)
					MisfireOrder[4]  := 16#000008C4;	(* cylinder 12-11, 6-5 switched off *)
					MisfireOrder[5]  := 16#000008CC;	(* cylinder 12-10, 6-5 switched off *)
					MisfireOrder[6]  := 16#00000CCC;	(* cylinder 12-10, 6-4 switched off *)
					MisfireOrder[7]  := 16#00000ECC;	(* cylinder 12-9, 6-4 switched off *)
					MisfireOrder[8]  := 16#00000EDC;	(* cylinder 12-9, 6-3 switched off *)
					MisfireOrder[9]  := 16#00000EDE;	(* cylinder 12-8, 6-3 switched off *)
					MisfireOrder[10] := 16#00000FDE;	(* cylinder 12-8, 6-2 switched off *)
					MisfireOrder[11] := 16#00000FFE;	(* cylinder 12-7, 6-2 switched off *)
					MisfireOrder[12] := 16#00000FFF;	(* cylinder 12-1 switched off *)
				END_IF
				
				
		(* engine 316 *)
		316 : 	usMotorTyp 		:= Motortype;
				Type 			:= 3;			(* engine series 3		*)
				NumberOfTeeth 	:= 164;			(* teeth number of starter ring gear 		*)
				IgnDistance 	:= 20;			(* ignition distance 	*)
				TimingSeq 		:= 23;			(* timing sequence 		*)
				DistanceAB 		:= 200; 			
				DistanceBA 		:= 700;
				
				FireOrder[1]  := 1;				(* firing order 		*)
				FireOrder[2]  := 13;
				FireOrder[3]  := 5;
				FireOrder[4]  := 15;
				FireOrder[5]  := 7;
				FireOrder[6]  := 11;
				FireOrder[7]  := 3;
				FireOrder[8]  := 16;
				FireOrder[9]  := 8;
				FireOrder[10] := 12;
				FireOrder[11] := 4;
				FireOrder[12] := 10;
				FireOrder[13] := 2;
				FireOrder[14] := 14;
				FireOrder[15] := 6;
				FireOrder[16] := 9;
				
				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000000000001000000000000000;	(* cylinder 16 switched off *)
					MisfireOrder[2]  := 2#00000000000000001000000010000000;	(* cylinder 16 and 8 switched off *)
					MisfireOrder[3]  := 2#00000000000000001100000010000000;	(* cylinder 16 to 15 and 8 switched off *)
					MisfireOrder[4]  := 2#00000000000000001100000011000000;	(* cylinder 16 to 15 and 8 to 7  switched off *)
					MisfireOrder[5]  := 2#00000000000000001110000011000000;	(* cylinder 16 to 14 and 8 to 7 switched off *)
					MisfireOrder[6]  := 2#00000000000000001110000011100000;	(* cylinder 16 to 14 and 8 to 6 switched off *)
					MisfireOrder[7]  := 2#00000000000000001111000011100000;	(* cylinder 16 to 13 and 8 to 6 switched off *)
					MisfireOrder[8]  := 2#00000000000000001111000011110000;	(* cylinder 16 to 13 and 8 to 5 switched off *)
					MisfireOrder[9]  := 2#00000000000000001111100011110000;	(* cylinder 16 to 12 and 8 to 5 switched off *)
					MisfireOrder[10] := 2#00000000000000001111100011111000;	(* cylinder 16 to 12 and 8 to 4 switched off *)
					MisfireOrder[11] := 2#00000000000000001111110011111000;	(* cylinder 16 to 11 and 8 to 4 switched off *)
					MisfireOrder[12] := 2#00000000000000001111110011111100;	(* cylinder 16 to 11 and 8 to 3 switched off *)
					MisfireOrder[13] := 2#00000000000000001111111011111100;	(* cylinder 16 to 10 and 8 to 3 switched off *)
					MisfireOrder[14] := 2#00000000000000001111111011111110;	(* cylinder 16 to 10 and 8 to 2 switched off *)
					MisfireOrder[15] := 2#00000000000000001111111111111110;	(* cylinder 16 to  9 and 8 to 2 switched off *)
					MisfireOrder[16] := 2#00000000000000001111111111111111;	(* cylinder 20 to  9 and 8 to 1 switched off *)
				ELSE
					MisfireOrder[1]  := 16#00000080;	(* cylinder 16 switched off *)
					MisfireOrder[2]  := 16#00000180;	(* cylinder 16, 8 switched off *)
					MisfireOrder[3]  := 16#00000188;	(* cylinder 16-15, 8 switched off *)
					MisfireOrder[4]  := 16#00000198;	(* cylinder 16-15, 8-7 switched off *)
					MisfireOrder[5]  := 16#00002198;	(* cylinder 16-14, 8-7 switched off *)
					MisfireOrder[6]  := 16#00006198;	(* cylinder 16-14, 8-6 switched off *)
					MisfireOrder[7]  := 16#0000619A;	(* cylinder 16-13, 8-6 switched off *)
					MisfireOrder[8]  := 16#0000619E;	(* cylinder 16-13, 8-5 switched off *)
					MisfireOrder[9]  := 16#0000639E;	(* cylinder 16-12, 8-5 switched off *)
					MisfireOrder[10] := 16#0000679E;	(* cylinder 16-12, 8-4 switched off *)
					MisfireOrder[11] := 16#000067BE;	(* cylinder 16-11, 8-4 switched off *)
					MisfireOrder[12] := 16#000067FE;	(* cylinder 16-11, 8-3 switched off *)
					MisfireOrder[13] := 16#00006FFE;	(* cylinder 16-10, 8-3 switched off *)
					MisfireOrder[14] := 16#00007FFE;	(* cylinder 16-10, 8-2 switched off *)
					MisfireOrder[15] := 16#0000FFFE;	(* cylinder 16-9, 8-2 switched off *)
					MisfireOrder[16] := 16#0000FFFF;	(* cylinder 16-1 switched off *)
				END_IF
		
		
		(* engine 416 *)
		416 : 	usMotorTyp 		:= Motortype;
				Type 			:= 4;			(* engine series 4		*)
				NumberOfTeeth 	:= 174;			(* teeth number of starter ring gear 		*)
				IgnDistance 	:= 20;			(* ignition distance 	*)
				TimingSeq 		:= 23;			(* timing sequence 		*)
				DistanceAB 		:= 200; 			
				DistanceBA 		:= 700;
				
				FireOrder[1]  := 1;				(* firing order 		*)
				FireOrder[2]  := 13;
				FireOrder[3]  := 5;
				FireOrder[4]  := 15;
				FireOrder[5]  := 7;
				FireOrder[6]  := 11;
				FireOrder[7]  := 3;
				FireOrder[8]  := 16;
				FireOrder[9]  := 8;
				FireOrder[10] := 12;
				FireOrder[11] := 4;
				FireOrder[12] := 10;
				FireOrder[13] := 2;
				FireOrder[14] := 14;
				FireOrder[15] := 6;
				FireOrder[16] := 9;
				
				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000000000001000000000000000;	(* cylinder 16 switched off *)
					MisfireOrder[2]  := 2#00000000000000001000000010000000;	(* cylinder 16 and 8 switched off *)
					MisfireOrder[3]  := 2#00000000000000001100000010000000;	(* cylinder 16 to 15 and 8 switched off *)
					MisfireOrder[4]  := 2#00000000000000001100000011000000;	(* cylinder 16 to 15 and 8 to 7  switched off *)
					MisfireOrder[5]  := 2#00000000000000001110000011000000;	(* cylinder 16 to 14 and 8 to 7 switched off *)
					MisfireOrder[6]  := 2#00000000000000001110000011100000;	(* cylinder 16 to 14 and 8 to 6 switched off *)
					MisfireOrder[7]  := 2#00000000000000001111000011100000;	(* cylinder 16 to 13 and 8 to 6 switched off *)
					MisfireOrder[8]  := 2#00000000000000001111000011110000;	(* cylinder 16 to 13 and 8 to 5 switched off *)
					MisfireOrder[9]  := 2#00000000000000001111100011110000;	(* cylinder 16 to 12 and 8 to 5 switched off *)
					MisfireOrder[10] := 2#00000000000000001111100011111000;	(* cylinder 16 to 12 and 8 to 4 switched off *)
					MisfireOrder[11] := 2#00000000000000001111110011111000;	(* cylinder 16 to 11 and 8 to 4 switched off *)
					MisfireOrder[12] := 2#00000000000000001111110011111100;	(* cylinder 16 to 11 and 8 to 3 switched off *)
					MisfireOrder[13] := 2#00000000000000001111111011111100;	(* cylinder 16 to 10 and 8 to 3 switched off *)
					MisfireOrder[14] := 2#00000000000000001111111011111110;	(* cylinder 16 to 10 and 8 to 2 switched off *)
					MisfireOrder[15] := 2#00000000000000001111111111111110;	(* cylinder 16 to  9 and 8 to 2 switched off *)
					MisfireOrder[16] := 2#00000000000000001111111111111111;	(* cylinder 20 to  9 and 8 to 1 switched off *)
				ELSE
					MisfireOrder[1]  := 16#00000080;	(* cylinder 16 switched off *)
					MisfireOrder[2]  := 16#00000180;	(* cylinder 16, 8 switched off *)
					MisfireOrder[3]  := 16#00000188;	(* cylinder 16-15, 8 switched off *)
					MisfireOrder[4]  := 16#00000198;	(* cylinder 16-15, 8-7 switched off *)
					MisfireOrder[5]  := 16#00002198;	(* cylinder 16-14, 8-7 switched off *)
					MisfireOrder[6]  := 16#00006198;	(* cylinder 16-14, 8-6 switched off *)
					MisfireOrder[7]  := 16#0000619A;	(* cylinder 16-13, 8-6 switched off *)
					MisfireOrder[8]  := 16#0000619E;	(* cylinder 16-13, 8-5 switched off *)
					MisfireOrder[9]  := 16#0000639E;	(* cylinder 16-12, 8-5 switched off *)
					MisfireOrder[10] := 16#0000679E;	(* cylinder 16-12, 8-4 switched off *)
					MisfireOrder[11] := 16#000067BE;	(* cylinder 16-11, 8-4 switched off *)
					MisfireOrder[12] := 16#000067FE;	(* cylinder 16-11, 8-3 switched off *)
					MisfireOrder[13] := 16#00006FFE;	(* cylinder 16-10, 8-3 switched off *)
					MisfireOrder[14] := 16#00007FFE;	(* cylinder 16-10, 8-2 switched off *)
					MisfireOrder[15] := 16#0000FFFE;	(* cylinder 16-9, 8-2 switched off *)
					MisfireOrder[16] := 16#0000FFFF;	(* cylinder 16-1 switched off *)
				END_IF


		(* engine 320 *)
		320 : 	usMotorTyp 		:= Motortype;
				Type 			:= 3;			(* engine series 3		*)
				NumberOfTeeth 	:= 164;			(* teeth number of starter ring gear 		*)
 				IgnDistance 	:= 2;			(* ignition distance 	*)
				TimingSeq 		:= 147;			(* timing sequence 	*)
				DistanceAB 		:= 20;			
				DistanceBA 		:= 700;
				
				FireOrder[1]  := 1;				(* firing order 	*)
				FireOrder[2]  := 17;
				FireOrder[3]  := 7;
				FireOrder[4]  := 13;
				FireOrder[5]  := 3;
				FireOrder[6]  := 19;
				FireOrder[7]  := 9;
				FireOrder[8]  := 15;
				FireOrder[9]  := 5;
				FireOrder[10] := 20;
				FireOrder[11] := 10;
				FireOrder[12] := 14;
				FireOrder[13] := 4;
				FireOrder[14] := 18;
				FireOrder[15] := 8;
				FireOrder[16] := 12;
				FireOrder[17] := 2;
				FireOrder[18] := 16;
				FireOrder[19] := 6;
				FireOrder[20] := 11;
	
				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000000010000000000000000000;	(* cylinder 20 switched off *)
					MisfireOrder[2]  := 2#00000000000010000000001000000000;	(* cylinder 20 and 10 switched off *)
					MisfireOrder[3]  := 2#00000000000011000000001000000000;	(* cylinder 20 to 19 and 10 switched off *)
					MisfireOrder[4]  := 2#00000000000011000000001100000000;	(* cylinder 20 to 19 and 10 to 9  switched off *)
					MisfireOrder[5]  := 2#00000000000011100000001100000000;	(* cylinder 20 to 18 and 10 to 9 switched off *)
					MisfireOrder[6]  := 2#00000000000011100000001110000000;	(* cylinder 20 to 18 and 10 to 8 switched off *)
					MisfireOrder[7]  := 2#00000000000011110000001110000000;	(* cylinder 20 to 17 and 10 to 8 switched off *)
					MisfireOrder[8]  := 2#00000000000011110000001111000000;	(* cylinder 20 to 17 and 10 to 7 switched off *)
					MisfireOrder[9]  := 2#00000000000011111000001111000000;	(* cylinder 20 to 16 and 10 to 7 switched off *)
					MisfireOrder[10] := 2#00000000000011111000001111100000;	(* cylinder 20 to 16 and 10 to 6 switched off *)
					MisfireOrder[11] := 2#00000000000011111100001111100000;	(* cylinder 20 to 15 and 10 to 6 switched off *)
					MisfireOrder[12] := 2#00000000000011111100001111110000;	(* cylinder 20 to 15 and 10 to 5 switched off *)
					MisfireOrder[13] := 2#00000000000011111110001111110000;	(* cylinder 20 to 14 and 10 to 5 switched off *)
					MisfireOrder[14] := 2#00000000000011111110001111111000;	(* cylinder 20 to 14 and 10 to 4 switched off *)
					MisfireOrder[15] := 2#00000000000011111111001111111000;	(* cylinder 20 to 13 and 10 to 4 switched off *)
					MisfireOrder[16] := 2#00000000000011111111001111111100;	(* cylinder 20 to 13 and 10 to 3 switched off *)
					MisfireOrder[17] := 2#00000000000011111111101111111100;	(* cylinder 20 to 12 and 10 to 3 switched off *)
					MisfireOrder[18] := 2#00000000000011111111101111111110;	(* cylinder 20 to 12 and 10 to 2 switched off *)
					MisfireOrder[19] := 2#00000000000011111111111111111110;	(* cylinder 20 to 11 and 10 to 2 switched off *)
					MisfireOrder[20] := 2#00000000000011111111111111111111;	(* cylinder 20 to 11 and 10 to 1 switched off *)
				ELSE
					MisfireOrder[1]  := 16#00000200;	(* cylinder 20 switched off *)
					MisfireOrder[2]  := 16#00000600;	(* cylinder 20, 10 switched off *)
					MisfireOrder[3]  := 16#00000620;	(* cylinder 20-19, 10 switched off *)
					MisfireOrder[4]  := 16#00000660;	(* cylinder 20-19, 10-9 switched off *)
					MisfireOrder[5]  := 16#00002660;	(* cylinder 20-18, 10-9 switched off *)
					MisfireOrder[6]  := 16#00006660;	(* cylinder 20-18, 10-8 switched off *)
					MisfireOrder[7]  := 16#00006662;	(* cylinder 20-17, 10-8 switched off *)
					MisfireOrder[8]  := 16#00006666;	(* cylinder 20-17, 10-7 switched off *)
					MisfireOrder[9]  := 16#00026666;	(* cylinder 20-16, 10-7 switched off *)
					MisfireOrder[10] := 16#00066666;	(* cylinder 20-16, 10-6 switched off *)
					MisfireOrder[11] := 16#000666E6;	(* cylinder 20-15, 10-6 switched off *)
					MisfireOrder[12] := 16#000667E6;	(* cylinder 20-15, 10-5 switched off *)
					MisfireOrder[13] := 16#00066FE6;	(* cylinder 20-14, 10-5 switched off *)
					MisfireOrder[14] := 16#00067FE6;	(* cylinder 20-14, 10-4 switched off *)
					MisfireOrder[15] := 16#00067FEE;	(* cylinder 20-13, 10-4 switched off *)
					MisfireOrder[16] := 16#00067FFE;	(* cylinder 20-13, 10-3 switched off *)
					MisfireOrder[17] := 16#0006FFFE;	(* cylinder 20-12, 10-3 switched off *)
					MisfireOrder[18] := 16#0007FFFE;	(* cylinder 20-12, 10-2 switched off *)
					MisfireOrder[19] := 16#000FFFFE;	(* cylinder 20-11, 10-2 switched off *)
					MisfireOrder[20] := 16#000FFFFF;	(* cylinder 20-1 switched off *)
				END_IF
				
				
		(* engine 420 *)
		420 : 	usMotorTyp 		:= Motortype;
				Type 			:= 4;			(* engine series 4		*)
				NumberOfTeeth 	:= 174;			(* teeth number of starter ring gear 		*)
				IgnDistance 	:= 2;			(* ignition distance 	*)
				TimingSeq 		:= 147;			(* timing sequence 	*)
				DistanceAB 		:= 20;			
				DistanceBA 		:= 700;
				
				FireOrder[1]  := 1;				(* firing order 	*)
				FireOrder[2]  := 17;
				FireOrder[3]  := 7;
				FireOrder[4]  := 13;
				FireOrder[5]  := 3;
				FireOrder[6]  := 19;
				FireOrder[7]  := 9;
				FireOrder[8]  := 15;
				FireOrder[9]  := 5;
				FireOrder[10] := 20;
				FireOrder[11] := 10;
				FireOrder[12] := 14;
				FireOrder[13] := 4;
				FireOrder[14] := 18;
				FireOrder[15] := 8;
				FireOrder[16] := 12;
				FireOrder[17] := 2;
				FireOrder[18] := 16;
				FireOrder[19] := 6;
				FireOrder[20] := 11;
	
				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000000010000000000000000000;	(* cylinder 20 switched off *)
					MisfireOrder[2]  := 2#00000000000010000000001000000000;	(* cylinder 20 and 10 switched off *)
					MisfireOrder[3]  := 2#00000000000011000000001000000000;	(* cylinder 20 to 19 and 10 switched off *)
					MisfireOrder[4]  := 2#00000000000011000000001100000000;	(* cylinder 20 to 19 and 10 to 9  switched off *)
					MisfireOrder[5]  := 2#00000000000011100000001100000000;	(* cylinder 20 to 18 and 10 to 9 switched off *)
					MisfireOrder[6]  := 2#00000000000011100000001110000000;	(* cylinder 20 to 18 and 10 to 8 switched off *)
					MisfireOrder[7]  := 2#00000000000011110000001110000000;	(* cylinder 20 to 17 and 10 to 8 switched off *)
					MisfireOrder[8]  := 2#00000000000011110000001111000000;	(* cylinder 20 to 17 and 10 to 7 switched off *)
					MisfireOrder[9]  := 2#00000000000011111000001111000000;	(* cylinder 20 to 16 and 10 to 7 switched off *)
					MisfireOrder[10] := 2#00000000000011111000001111100000;	(* cylinder 20 to 16 and 10 to 6 switched off *)
					MisfireOrder[11] := 2#00000000000011111100001111100000;	(* cylinder 20 to 15 and 10 to 6 switched off *)
					MisfireOrder[12] := 2#00000000000011111100001111110000;	(* cylinder 20 to 15 and 10 to 5 switched off *)
					MisfireOrder[13] := 2#00000000000011111110001111110000;	(* cylinder 20 to 14 and 10 to 5 switched off *)
					MisfireOrder[14] := 2#00000000000011111110001111111000;	(* cylinder 20 to 14 and 10 to 4 switched off *)
					MisfireOrder[15] := 2#00000000000011111111001111111000;	(* cylinder 20 to 13 and 10 to 4 switched off *)
					MisfireOrder[16] := 2#00000000000011111111001111111100;	(* cylinder 20 to 13 and 10 to 3 switched off *)
					MisfireOrder[17] := 2#00000000000011111111101111111100;	(* cylinder 20 to 12 and 10 to 3 switched off *)
					MisfireOrder[18] := 2#00000000000011111111101111111110;	(* cylinder 20 to 12 and 10 to 2 switched off *)
					MisfireOrder[19] := 2#00000000000011111111111111111110;	(* cylinder 20 to 11 and 10 to 2 switched off *)
					MisfireOrder[20] := 2#00000000000011111111111111111111;	(* cylinder 20 to 11 and 10 to 1 switched off *)
				ELSE
					MisfireOrder[1]  := 16#00000200;	(* cylinder 20 switched off *)
					MisfireOrder[2]  := 16#00000600;	(* cylinder 20, 10 switched off *)
					MisfireOrder[3]  := 16#00000620;	(* cylinder 20-19, 10 switched off *)
					MisfireOrder[4]  := 16#00000660;	(* cylinder 20-19, 10-9 switched off *)
					MisfireOrder[5]  := 16#00002660;	(* cylinder 20-18, 10-9 switched off *)
					MisfireOrder[6]  := 16#00006660;	(* cylinder 20-18, 10-8 switched off *)
					MisfireOrder[7]  := 16#00006662;	(* cylinder 20-17, 10-8 switched off *)
					MisfireOrder[8]  := 16#00006666;	(* cylinder 20-17, 10-7 switched off *)
					MisfireOrder[9]  := 16#00026666;	(* cylinder 20-16, 10-7 switched off *)
					MisfireOrder[10] := 16#00066666;	(* cylinder 20-16, 10-6 switched off *)
					MisfireOrder[11] := 16#000666E6;	(* cylinder 20-15, 10-6 switched off *)
					MisfireOrder[12] := 16#000667E6;	(* cylinder 20-15, 10-5 switched off *)
					MisfireOrder[13] := 16#00066FE6;	(* cylinder 20-14, 10-5 switched off *)
					MisfireOrder[14] := 16#00067FE6;	(* cylinder 20-14, 10-4 switched off *)
					MisfireOrder[15] := 16#00067FEE;	(* cylinder 20-13, 10-4 switched off *)
					MisfireOrder[16] := 16#00067FFE;	(* cylinder 20-13, 10-3 switched off *)
					MisfireOrder[17] := 16#0006FFFE;	(* cylinder 20-12, 10-3 switched off *)
					MisfireOrder[18] := 16#0007FFFE;	(* cylinder 20-12, 10-2 switched off *)
					MisfireOrder[19] := 16#000FFFFE;	(* cylinder 20-11, 10-2 switched off *)
					MisfireOrder[20] := 16#000FFFFF;	(* cylinder 20-1 switched off *)
				END_IF		
				
				
		(* engine 424 *)
		424 : 	usMotorTyp 		:= Motortype;
				Type 			:= 4;			(* engine series 4		*)
				NumberOfTeeth 	:= 195;			(* teeth number of starter ring gear 		*)
				TimingSeq 		:= 255;			(* timing sequence - not known so far *)
				DistanceAB 		:= 500;			
				DistanceBA 		:= 700;
				
				FireOrder[1]  	:= 1;			(* firing order 	*)
				FireOrder[2]  	:= 7;
				FireOrder[3]  	:= 14;
				FireOrder[4]  	:= 20;
				FireOrder[5]  	:= 2;
				FireOrder[6]  	:= 8;
				FireOrder[7]  	:= 15;
				FireOrder[8]  	:= 21;
				FireOrder[9]  	:= 4;
				FireOrder[10] 	:= 9;
				FireOrder[11] 	:= 18;
				FireOrder[12] 	:= 24;
				FireOrder[13] 	:= 6;
				FireOrder[14] 	:= 12;
				FireOrder[15] 	:= 17;
				FireOrder[16] 	:= 23;
				FireOrder[17] 	:= 5;
				FireOrder[18] 	:= 11;
				FireOrder[19] 	:= 16;
				FireOrder[20] 	:= 22;
				FireOrder[21] 	:= 3;
				FireOrder[22] 	:= 10;
				FireOrder[23] 	:= 13;
				FireOrder[24] 	:= 19;
	
				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000100000000000000000000000;	(* cylinder 24 switched off *)
					MisfireOrder[2]  := 2#00000000100000000000100000000000;	(* cylinder 24 and 12 switched off *)
					MisfireOrder[3]  := 2#00000000110000000000100000000000;	(* cylinder 24 to 23 and 12 switched off *)
					MisfireOrder[4]  := 2#00000000110000000000110000000000;	(* cylinder 24 to 23 and 12 to 11  switched off *)
					MisfireOrder[5]  := 2#00000000111000000000110000000000;	(* cylinder 24 to 22 and 12 to 11 switched off *)
					MisfireOrder[6]  := 2#00000000111000000000111000000000;	(* cylinder 24 to 22 and 12 to 10 switched off *)
					MisfireOrder[7]  := 2#00000000111100000000111000000000;	(* cylinder 24 to 21 and 12 to 10 switched off *)
					MisfireOrder[8]  := 2#00000000111100000000111100000000;	(* cylinder 24 to 21 and 12 to  9 switched off *)
					MisfireOrder[9]  := 2#00000000111110000000111100000000;	(* cylinder 24 to 20 and 12 to  9 switched off *)
					MisfireOrder[10] := 2#00000000111110000000111110000000;	(* cylinder 24 to 20 and 12 to  8 switched off *)
					MisfireOrder[11] := 2#00000000111111000000111110000000;	(* cylinder 24 to 19 and 12 to  8 switched off *)
					MisfireOrder[12] := 2#00000000111111000000111111000000;	(* cylinder 24 to 19 and 12 to  7 switched off *)
					MisfireOrder[13] := 2#00000000111111100000111111000000;	(* cylinder 24 to 18 and 12 to  7 switched off *)
					MisfireOrder[14] := 2#00000000111111100000111111100000;	(* cylinder 24 to 18 and 12 to  6 switched off *)
					MisfireOrder[15] := 2#00000000111111110000111111100000;	(* cylinder 24 to 17 and 12 to  6 switched off *)
					MisfireOrder[16] := 2#00000000111111110000111111110000;	(* cylinder 24 to 17 and 12 to  5 switched off *)
					MisfireOrder[17] := 2#00000000111111111000111111110000;	(* cylinder 24 to 16 and 12 to  5 switched off *)
					MisfireOrder[18] := 2#00000000111111111000111111111000;	(* cylinder 24 to 16 and 12 to  4 switched off *)
					MisfireOrder[19] := 2#00000000111111111100111111111000;	(* cylinder 24 to 15 and 12 to  4 switched off *)
					MisfireOrder[20] := 2#00000000111111111100111111111100;	(* cylinder 24 to 15 and 12 to  3 switched off *)
					MisfireOrder[21] := 2#00000000111111111110111111111100;	(* cylinder 24 to 14 and 12 to  3 switched off *)
					MisfireOrder[22] := 2#00000000111111111110111111111110;	(* cylinder 24 to 14 and 12 to  2 switched off *)
					MisfireOrder[23] := 2#00000000111111111111111111111110;	(* cylinder 24 to 13 and 12 to  2 switched off *)
					MisfireOrder[24] := 2#00000000111111111111111111111111;	(* cylinder 24 to 13 and 12 to  1 switched off *)
				ELSE
					MisfireOrder[1]  := 16#00000800;	(* cylinder 24 switched off *)
					MisfireOrder[2]  := 16#00002800;	(* cylinder 24 and 12 switched off *)
					MisfireOrder[3]  := 16#0000A800;	(* cylinder 24 to 23 and 12 switched off *)
					MisfireOrder[4]  := 16#0002A800;	(* cylinder 24 to 23 and 12 to 11  switched off *)
					MisfireOrder[5]  := 16#000AA800;	(* cylinder 24 to 22 and 12 to 11 switched off *)
					MisfireOrder[6]  := 16#002AA800;	(* cylinder 24 to 22 and 12 to 10 switched off *)
					MisfireOrder[7]  := 16#002AA880;	(* cylinder 24 to 21 and 12 to 10 switched off *)
					MisfireOrder[8]  := 16#002AAA80;	(* cylinder 24 to 21 and 12 to  9 switched off *)
					MisfireOrder[9]  := 16#002AAA88;	(* cylinder 24 to 20 and 12 to  9 switched off *)
					MisfireOrder[10] := 16#002AAAA8;	(* cylinder 24 to 20 and 12 to  8 switched off *)
					MisfireOrder[11] := 16#00AAAAA8;	(* cylinder 24 to 19 and 12 to  8 switched off *)
					MisfireOrder[12] := 16#00AAAAAA;	(* cylinder 24 to 19 and 12 to  7 switched off *)
					MisfireOrder[13] := 16#00AAAEAA;	(* cylinder 24 to 18 and 12 to  7 switched off *)
					MisfireOrder[14] := 16#00AABEAA;	(* cylinder 24 to 18 and 12 to  6 switched off *)
					MisfireOrder[15] := 16#00AAFEAA;	(* cylinder 24 to 17 and 12 to  6 switched off *)
					MisfireOrder[16] := 16#00ABFEAA;	(* cylinder 24 to 17 and 12 to  5 switched off *)
					MisfireOrder[17] := 16#00AFFEAA;	(* cylinder 24 to 16 and 12 to  5 switched off *)
					MisfireOrder[18] := 16#00AFFFAA;	(* cylinder 24 to 16 and 12 to  4 switched off *)
					MisfireOrder[19] := 16#00AFFFEA;	(* cylinder 24 to 15 and 12 to  4 switched off *)
					MisfireOrder[20] := 16#00BFFFEA;	(* cylinder 24 to 15 and 12 to  3 switched off *)
					MisfireOrder[21] := 16#00BFFFEE;	(* cylinder 24 to 14 and 12 to  3 switched off *)
					MisfireOrder[22] := 16#00BFFFFE;	(* cylinder 24 to 14 and 12 to  2 switched off *)
					MisfireOrder[23] := 16#00FFFFFE;	(* cylinder 24 to 13 and 12 to  2 switched off *)
					MisfireOrder[24] := 16#00FFFFFF;	(* cylinder 24 to 13 and 12 to  1 switched off *)
				END_IF;
		
		
		(* engine 612 *)
		612 : 	usMotorTyp 		:= Motortype;
				Type 			:= 6;				(* engine series 6		*)
				NumberOfTeeth 	:= 269;				(* Zähnezahl des Starterzahnkranzes 		*)
				IgnDistance 	:= 60;				(* ignition distance	*)
				TimingSeq 		:= 4;				(* timing sequence 		*)
				DistanceAB		:= 600;			
				DistanceBA		:= 600;
				
				FireOrder[1]  := 1;					(* firing order 		*)
				FireOrder[2]  := 8;
				FireOrder[3]  := 5;
				FireOrder[4]  := 10;
				FireOrder[5]  := 3;
				FireOrder[6]  := 7;
				FireOrder[7]  := 6;
				FireOrder[8]  := 11;
				FireOrder[9]  := 2;
				FireOrder[10] := 9;
				FireOrder[11] := 4;
				FireOrder[12] := 12;

				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000000000000000100000000000;	(* cylinder 12 switched off *)
					MisfireOrder[2]  := 2#00000000000000000000100000100000;	(* cylinder 12 and 6 switched off *)
					MisfireOrder[3]  := 2#00000000000000000000110000100000;	(* cylinder 12 to 11 and 6 switched off *)
					MisfireOrder[4]  := 2#00000000000000000000110000110000;	(* cylinder 12 to 11 and 6 to 5  switched off *)
					MisfireOrder[5]  := 2#00000000000000000000111000110000;	(* cylinder 12 to 10 and 6 to 5 switched off *)
					MisfireOrder[6]  := 2#00000000000000000000111000111000;	(* cylinder 12 to 10 and 6 to 4 switched off *)
					MisfireOrder[7]  := 2#00000000000000000000111100111000;	(* cylinder 12 to  9 and 6 to 4 switched off *)
					MisfireOrder[8]  := 2#00000000000000000000111100111100;	(* cylinder 12 to  9 and 6 to 3 switched off *)
					MisfireOrder[9]  := 2#00000000000000000000111110111100;	(* cylinder 12 to  8 and 6 to 3 switched off *)
					MisfireOrder[10] := 2#00000000000000000000111110111110;	(* cylinder 12 to  8 and 6 to 2 switched off *)
					MisfireOrder[11] := 2#00000000000000000000111111111110;	(* cylinder 12 to  7 and 6 to 2 switched off *)
					MisfireOrder[12] := 2#00000000000000000000111111111111;	(* cylinder 12 to  7 and 6 to 1 switched off *)
				ELSE
					MisfireOrder[1]  := 16#00000800;	(* cylinder 12 switched off *)
					MisfireOrder[2]  := 16#00000840;	(* cylinder 12, 6 switched off *)
					MisfireOrder[3]  := 16#000008C0;	(* cylinder 12-11, 6 switched off *)
					MisfireOrder[4]  := 16#000008C4;	(* cylinder 12-11, 6-5 switched off *)
					MisfireOrder[5]  := 16#000008CC;	(* cylinder 12-10, 6-5 switched off *)
					MisfireOrder[6]  := 16#00000CCC;	(* cylinder 12-10, 6-4 switched off *)
					MisfireOrder[7]  := 16#00000ECC;	(* cylinder 12-9, 6-4 switched off *)
					MisfireOrder[8]  := 16#00000EDC;	(* cylinder 12-9, 6-3 switched off *)
					MisfireOrder[9]  := 16#00000EDE;	(* cylinder 12-8, 6-3 switched off *)
					MisfireOrder[10] := 16#00000FDE;	(* cylinder 12-8, 6-2 switched off *)
					MisfireOrder[11] := 16#00000FFE;	(* cylinder 12-7, 6-2 switched off *)
					MisfireOrder[12] := 16#00000FFF;	(* cylinder 12-1 switched off *)
				END_IF
		
		
				SkipfireOrder[0]	:= 8;	(* avoid overrun of the conditional instruction *)
				SkipfireOrder[1] 	:= 1;
				SkipfireOrder[2]	:= 10;
				SkipfireOrder[3]	:= 6;
				SkipfireOrder[4] 	:= 9;
				SkipfireOrder[5] 	:= 5;
				SkipfireOrder[6] 	:= 7;
				SkipfireOrder[7] 	:= 2;
				SkipfireOrder[8] 	:= 12;
				SkipfireOrder[9] 	:= 3;
				SkipfireOrder[10] 	:= 11;
				SkipfireOrder[11] 	:= 4;
				SkipfireOrder[12] 	:= 8;
		
		(* engine 616 *)
		616 : 	usMotorTyp 		:= Motortype;
				Type 			:= 6;				(* engine series 6		*)
				NumberOfTeeth 	:= 269;				(* teeth number of starter ring gear 		*)
				IgnDistance 	:= 30;				(* ignition distance 	*)
				TimingSeq 		:= 13;				(* timing sequence 		*)
				DistanceAB 		:= 300;			
				DistanceBA 		:= 600;
				
				FireOrder[1]  := 1;					(* firing order 		*)
				FireOrder[2]  := 14;
				FireOrder[3]  := 6;
				FireOrder[4]  := 10;
				FireOrder[5]  := 2;
				FireOrder[6]  := 13;
				FireOrder[7]  := 5;
				FireOrder[8]  := 16;
				FireOrder[9]  := 8;
				FireOrder[10] := 11;
				FireOrder[11] := 3;
				FireOrder[12] := 15;
				FireOrder[13] := 7;
				FireOrder[14] := 12;
				FireOrder[15] := 4;
				FireOrder[16] := 9;

				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000000000001000000000000000;	(* cylinder 16 switched off *)
					MisfireOrder[2]  := 2#00000000000000001000000010000000;	(* cylinder 16 and 8 switched off *)
					MisfireOrder[3]  := 2#00000000000000001100000010000000;	(* cylinder 16 to 15 and 8 switched off *)
					MisfireOrder[4]  := 2#00000000000000001100000011000000;	(* cylinder 16 to 15 and 8 to 7  switched off *)
					MisfireOrder[5]  := 2#00000000000000001110000011000000;	(* cylinder 16 to 14 and 8 to 7 switched off *)
					MisfireOrder[6]  := 2#00000000000000001110000011100000;	(* cylinder 16 to 14 and 8 to 6 switched off *)
					MisfireOrder[7]  := 2#00000000000000001111000011100000;	(* cylinder 16 to 13 and 8 to 6 switched off *)
					MisfireOrder[8]  := 2#00000000000000001111000011110000;	(* cylinder 16 to 13 and 8 to 5 switched off *)
					MisfireOrder[9]  := 2#00000000000000001111100011110000;	(* cylinder 16 to 12 and 8 to 5 switched off *)
					MisfireOrder[10] := 2#00000000000000001111100011111000;	(* cylinder 16 to 12 and 8 to 4 switched off *)
					MisfireOrder[11] := 2#00000000000000001111110011111000;	(* cylinder 16 to 11 and 8 to 4 switched off *)
					MisfireOrder[12] := 2#00000000000000001111110011111100;	(* cylinder 16 to 11 and 8 to 3 switched off *)
					MisfireOrder[13] := 2#00000000000000001111111011111100;	(* cylinder 16 to 10 and 8 to 3 switched off *)
					MisfireOrder[14] := 2#00000000000000001111111011111110;	(* cylinder 16 to 10 and 8 to 2 switched off *)
					MisfireOrder[15] := 2#00000000000000001111111111111110;	(* cylinder 16 to  9 and 8 to 2 switched off *)
					MisfireOrder[16] := 2#00000000000000001111111111111111;	(* cylinder 20 to  9 and 8 to 1 switched off *)
				ELSE
					MisfireOrder[1]  := 16#00000080;	(* cylinder 16 switched off *)
					MisfireOrder[2]  := 16#00000180;	(* cylinder 16, 8 switched off *)
					MisfireOrder[3]  := 16#00000980;	(* cylinder 16-15, 8 switched off *)
					MisfireOrder[4]  := 16#00001980;	(* cylinder 16-15, 8-7 switched off *)
					MisfireOrder[5]  := 16#00001982;	(* cylinder 16-14, 8-7 switched off *)
					MisfireOrder[6]  := 16#00001986;	(* cylinder 16-14, 8-6 switched off *)
					MisfireOrder[7]  := 16#000019A6;	(* cylinder 16-13, 8-6 switched off *)
					MisfireOrder[8]  := 16#000019E6;	(* cylinder 16-13, 8-5 switched off *)
					MisfireOrder[9]  := 16#000039E6;	(* cylinder 16-12, 8-5 switched off *)
					MisfireOrder[10] := 16#000079E6;	(* cylinder 16-12, 8-4 switched off *)
					MisfireOrder[11] := 16#00007BE6;	(* cylinder 16-11, 8-4 switched off *)
					MisfireOrder[12] := 16#00007FE6;	(* cylinder 16-11, 8-3 switched off *)
					MisfireOrder[13] := 16#00007FEE;	(* cylinder 16-10, 8-3 switched off *)
					MisfireOrder[14] := 16#00007FFE;	(* cylinder 16-10, 8-2 switched off *)
					MisfireOrder[15] := 16#0000FFFE;	(* cylinder 16-9, 8-2 switched off *)
					MisfireOrder[16] := 16#0000FFFF;	(* cylinder 16-1 switched off *)
				END_IF
	
				
				SkipfireOrder[0]	:= 12;	(* avoid overrun of the conditional instruction *)
				SkipfireOrder[1] 	:= 1;
				SkipfireOrder[2]	:= 16;
				SkipfireOrder[3]	:= 4;
				SkipfireOrder[4] 	:= 13;
				SkipfireOrder[5] 	:= 7;
				SkipfireOrder[6] 	:= 10;
				SkipfireOrder[7] 	:= 3;
				SkipfireOrder[8] 	:= 14;
				SkipfireOrder[9] 	:= 8;
				SkipfireOrder[10] 	:= 9;
				SkipfireOrder[11] 	:= 2;
				SkipfireOrder[12] 	:= 15;
				SkipfireOrder[13] 	:= 6;
				SkipfireOrder[14] 	:= 11;
				SkipfireOrder[15] 	:= 5;
				SkipfireOrder[16] 	:= 12;
			
		(* engine X616 Diesel*)
		1616 : 	usMotorTyp 		:= Motortype;
			//	Type 			:= 16;				(* engine series (X)6	X616	*)
				Type 			:= 6;				(* engine series (X)6	X616	*)
				NumberOfTeeth 	:= 0;//269;			(* teeth number of starter ring gear 		*)
				IgnDistance 	:= 0;//30;			(* ignition distance 	*)
				TimingSeq 		:= 0;//13;			(* timing sequence 		*)
				DistanceAB 		:= 0;//300;			
				DistanceBA 		:= 0;//600;
				
				FireOrder[1]  := 0;					(* firing order: NO igniion in X616 testbench 6 system 		*)
				FireOrder[2]  := 0;
				FireOrder[3]  := 0;
				FireOrder[4]  := 0;
				FireOrder[5]  := 0;
				FireOrder[6]  := 0;
				FireOrder[7]  := 0;
				FireOrder[8]  := 0;
				FireOrder[9]  := 0;
				FireOrder[10] := 0;
				FireOrder[11] := 0;
				FireOrder[12] := 0;
				FireOrder[13] := 0;
				FireOrder[14] := 0;
				FireOrder[15] := 0;
				FireOrder[16] := 0;

				(* NO Misfire in X616 testbench 6 system  *)
					MisfireOrder[1]  := 0;
					MisfireOrder[2]  := 0;
					MisfireOrder[3]  := 0;
					MisfireOrder[4]  := 0;
					MisfireOrder[5]  := 0;
					MisfireOrder[6]  := 0;
					MisfireOrder[7]  := 0;
					MisfireOrder[8]  := 0;
					MisfireOrder[9]  := 0;
					MisfireOrder[10] := 0;
					MisfireOrder[11] := 0;
					MisfireOrder[12] := 0;
					MisfireOrder[13] := 0;
					MisfireOrder[14] := 0;
					MisfireOrder[15] := 0;
					MisfireOrder[16] := 0;


	
		(* engine 620 *)
		620 : 	usMotorTyp 		:= Motortype;
				Type 			:= 6;				(* engine series 6		*)
				NumberOfTeeth 	:= 269;				(* teeth number of starter ring gear *)
				IgnDistance 	:= 12;				(* ignition distance 		*)
				TimingSeq 		:= 63;				(* timing sequence 	*)
				DistanceAB 		:= 120;				
				DistanceBA 		:= 600;
				
				FireOrder[1]  := 1;					(* firing order 	*)
				FireOrder[2]  := 14;
				FireOrder[3]  := 4;
				FireOrder[4]  := 18;
				FireOrder[5]  := 8;
				FireOrder[6]  := 12;
				FireOrder[7]  := 2;
				FireOrder[8]  := 15;
				FireOrder[9]  := 5;
				FireOrder[10] := 20;
				FireOrder[11] := 10;
				FireOrder[12] := 17;
				FireOrder[13] := 7;
				FireOrder[14] := 13;
				FireOrder[15] := 3;
				FireOrder[16] := 19;
				FireOrder[17] := 9;
				FireOrder[18] := 16;
				FireOrder[19] := 6;
				FireOrder[20] := 11;
	
				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000000010000000000000000000;	(* cylinder 20 switched off *)
					MisfireOrder[2]  := 2#00000000000010000000001000000000;	(* cylinder 20 and 10 switched off *)
					MisfireOrder[3]  := 2#00000000000011000000001000000000;	(* cylinder 20 to 19 and 10 switched off *)
					MisfireOrder[4]  := 2#00000000000011000000001100000000;	(* cylinder 20 to 19 and 10 to 9  switched off *)
					MisfireOrder[5]  := 2#00000000000011100000001100000000;	(* cylinder 20 to 18 and 10 to 9 switched off *)
					MisfireOrder[6]  := 2#00000000000011100000001110000000;	(* cylinder 20 to 18 and 10 to 8 switched off *)
					MisfireOrder[7]  := 2#00000000000011110000001110000000;	(* cylinder 20 to 17 and 10 to 8 switched off *)
					MisfireOrder[8]  := 2#00000000000011110000001111000000;	(* cylinder 20 to 17 and 10 to 7 switched off *)
					MisfireOrder[9]  := 2#00000000000011111000001111000000;	(* cylinder 20 to 16 and 10 to 7 switched off *)
					MisfireOrder[10] := 2#00000000000011111000001111100000;	(* cylinder 20 to 16 and 10 to 6 switched off *)
					MisfireOrder[11] := 2#00000000000011111100001111100000;	(* cylinder 20 to 15 and 10 to 6 switched off *)
					MisfireOrder[12] := 2#00000000000011111100001111110000;	(* cylinder 20 to 15 and 10 to 5 switched off *)
					MisfireOrder[13] := 2#00000000000011111110001111110000;	(* cylinder 20 to 14 and 10 to 5 switched off *)
					MisfireOrder[14] := 2#00000000000011111110001111111000;	(* cylinder 20 to 14 and 10 to 4 switched off *)
					MisfireOrder[15] := 2#00000000000011111111001111111000;	(* cylinder 20 to 13 and 10 to 4 switched off *)
					MisfireOrder[16] := 2#00000000000011111111001111111100;	(* cylinder 20 to 13 and 10 to 3 switched off *)
					MisfireOrder[17] := 2#00000000000011111111101111111100;	(* cylinder 20 to 12 and 10 to 3 switched off *)
					MisfireOrder[18] := 2#00000000000011111111101111111110;	(* cylinder 20 to 12 and 10 to 2 switched off *)
					MisfireOrder[19] := 2#00000000000011111111111111111110;	(* cylinder 20 to 11 and 10 to 2 switched off *)
					MisfireOrder[20] := 2#00000000000011111111111111111111;	(* cylinder 20 to 11 and 10 to 1 switched off *)
				ELSE
					MisfireOrder[1]  := 16#00000200;	(* cylinder 20 switched off *)
					MisfireOrder[2]  := 16#00000600;	(* cylinder 20, 10 switched off *)
					MisfireOrder[3]  := 16#00008600;	(* cylinder 20-19, 10 switched off *)
					MisfireOrder[4]  := 16#00018600;	(* cylinder 20-19, 10-9 switched off *)
					MisfireOrder[5]  := 16#00018608;	(* cylinder 20-18, 10-9 switched off *)
					MisfireOrder[6]  := 16#00018618;	(* cylinder 20-18, 10-8 switched off *)
					MisfireOrder[7]  := 16#00018E18;	(* cylinder 20-17, 10-8 switched off *)
					MisfireOrder[8]  := 16#00019E18;	(* cylinder 20-17, 10-7 switched off *)
					MisfireOrder[9]  := 16#00039E18;	(* cylinder 20-16, 10-7 switched off *)
					MisfireOrder[10] := 16#00079E18;	(* cylinder 20-16, 10-6 switched off *)
					MisfireOrder[11] := 16#00079E98;	(* cylinder 20-15, 10-6 switched off *)
					MisfireOrder[12] := 16#00079F98;	(* cylinder 20-15, 10-5 switched off *)
					MisfireOrder[13] := 16#00079F9A;	(* cylinder 20-14, 10-5 switched off *)
					MisfireOrder[14] := 16#00079F9E;	(* cylinder 20-14, 10-4 switched off *)
					MisfireOrder[15] := 16#0007BF9E;	(* cylinder 20-13, 10-4 switched off *)
					MisfireOrder[16] := 16#0007FF9E;	(* cylinder 20-13, 10-3 switched off *)
					MisfireOrder[17] := 16#0007FFBE;	(* cylinder 20-12, 10-3 switched off *)
					MisfireOrder[18] := 16#0007FFFE;	(* cylinder 20-12, 10-2 switched off *)
					MisfireOrder[19] := 16#000FFFFE;	(* cylinder 20-11, 10-2 switched off *)
					MisfireOrder[20] := 16#000FFFFF;	(* cylinder 20-1 switched off *)
				END_IF;
		
		
				SkipfireOrder[0]	:= 17;	(* avoid overrun of the conditional instruction *)
				SkipfireOrder[1] 	:= 1;
				SkipfireOrder[2]	:= 20;
				SkipfireOrder[3]	:= 6;
				SkipfireOrder[4] 	:= 15;
				SkipfireOrder[5] 	:= 9;
				SkipfireOrder[6] 	:= 12;
				SkipfireOrder[7] 	:= 3;
				SkipfireOrder[8] 	:= 18;
				SkipfireOrder[9] 	:= 7;
				SkipfireOrder[10] 	:= 14;
				SkipfireOrder[11] 	:= 10;
				SkipfireOrder[12] 	:= 11;
				SkipfireOrder[13] 	:= 5;
				SkipfireOrder[14] 	:= 16;
				SkipfireOrder[15] 	:= 2;
				SkipfireOrder[16] 	:= 19;
				SkipfireOrder[17] 	:= 8;
				SkipfireOrder[18] 	:= 13;
				SkipfireOrder[19] 	:= 4;
				SkipfireOrder[20] 	:= 17;		
		
		(* engine 624 *)
		624 : 	usMotorTyp 		:= Motortype;
				Type 			:= 6;			(* engine series 6		*)
				NumberOfTeeth 	:= 269;			(* teeth number of starter ring gear *)
				TimingSeq 		:= 255;			(* timing sequence - not known so far *)
				DistanceAB		:= 600;			
				DistanceBA		:= 600;
				
				FireOrder[1]  	:= 1;			(* firing order 	*)
				FireOrder[2]  	:= 7;
				FireOrder[3]  	:= 17;
				FireOrder[4]  	:= 20;
				FireOrder[5]  	:= 5;
				FireOrder[6]  	:= 11;
				FireOrder[7]  	:= 16;
				FireOrder[8]  	:= 21;
				FireOrder[9]  	:= 3;
				FireOrder[10] 	:= 10;
				FireOrder[11] 	:= 18;
				FireOrder[12] 	:= 24;
				FireOrder[13] 	:= 6;
				FireOrder[14] 	:= 12;
				FireOrder[15] 	:= 14;
				FireOrder[16] 	:= 23;
				FireOrder[17] 	:= 2;
				FireOrder[18] 	:= 8;
				FireOrder[19] 	:= 15;
				FireOrder[20] 	:= 22;
				FireOrder[21] 	:= 4;
				FireOrder[22] 	:= 9;
				FireOrder[23] 	:= 13;
				FireOrder[24] 	:= 19;

				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000100000000000000000000000;	(* cylinder 24 switched off *)
					MisfireOrder[2]  := 2#00000000100000000000100000000000;	(* cylinder 24 and 12 switched off *)
					MisfireOrder[3]  := 2#00000000110000000000100000000000;	(* cylinder 24 to 23 and 12 switched off *)
					MisfireOrder[4]  := 2#00000000110000000000110000000000;	(* cylinder 24 to 23 and 12 to 11  switched off *)
					MisfireOrder[5]  := 2#00000000111000000000110000000000;	(* cylinder 24 to 22 and 12 to 11 switched off *)
					MisfireOrder[6]  := 2#00000000111000000000111000000000;	(* cylinder 24 to 22 and 12 to 10 switched off *)
					MisfireOrder[7]  := 2#00000000111100000000111000000000;	(* cylinder 24 to 21 and 12 to 10 switched off *)
					MisfireOrder[8]  := 2#00000000111100000000111100000000;	(* cylinder 24 to 21 and 12 to  9 switched off *)
					MisfireOrder[9]  := 2#00000000111110000000111100000000;	(* cylinder 24 to 20 and 12 to  9 switched off *)
					MisfireOrder[10] := 2#00000000111110000000111110000000;	(* cylinder 24 to 20 and 12 to  8 switched off *)
					MisfireOrder[11] := 2#00000000111111000000111110000000;	(* cylinder 24 to 19 and 12 to  8 switched off *)
					MisfireOrder[12] := 2#00000000111111000000111111000000;	(* cylinder 24 to 19 and 12 to  7 switched off *)
					MisfireOrder[13] := 2#00000000111111100000111111000000;	(* cylinder 24 to 18 and 12 to  7 switched off *)
					MisfireOrder[14] := 2#00000000111111100000111111100000;	(* cylinder 24 to 18 and 12 to  6 switched off *)
					MisfireOrder[15] := 2#00000000111111110000111111100000;	(* cylinder 24 to 17 and 12 to  6 switched off *)
					MisfireOrder[16] := 2#00000000111111110000111111110000;	(* cylinder 24 to 17 and 12 to  5 switched off *)
					MisfireOrder[17] := 2#00000000111111111000111111110000;	(* cylinder 24 to 16 and 12 to  5 switched off *)
					MisfireOrder[18] := 2#00000000111111111000111111111000;	(* cylinder 24 to 16 and 12 to  4 switched off *)
					MisfireOrder[19] := 2#00000000111111111100111111111000;	(* cylinder 24 to 15 and 12 to  4 switched off *)
					MisfireOrder[20] := 2#00000000111111111100111111111100;	(* cylinder 24 to 15 and 12 to  3 switched off *)
					MisfireOrder[21] := 2#00000000111111111110111111111100;	(* cylinder 24 to 14 and 12 to  3 switched off *)
					MisfireOrder[22] := 2#00000000111111111110111111111110;	(* cylinder 24 to 14 and 12 to  2 switched off *)
					MisfireOrder[23] := 2#00000000111111111111111111111110;	(* cylinder 24 to 13 and 12 to  2 switched off *)
					MisfireOrder[24] := 2#00000000111111111111111111111111;	(* cylinder 24 to 13 and 12 to  1 switched off *)
				ELSE
					MisfireOrder[1]  := 16#00000800;	(* cylinder 24 switched off *)
					MisfireOrder[2]  := 16#00002800;	(* cylinder 24 and 12 switched off *)
					MisfireOrder[3]  := 16#0000A800;	(* cylinder 24 to 23 and 12 switched off *)
					MisfireOrder[4]  := 16#0000A820;	(* cylinder 24 to 23 and 12 to 11  switched off *)
					MisfireOrder[5]  := 16#0008A820;	(* cylinder 24 to 22 and 12 to 11 switched off *)
					MisfireOrder[6]  := 16#0008AA20;	(* cylinder 24 to 22 and 12 to 10 switched off *)
					MisfireOrder[7]  := 16#0008AAA0;	(* cylinder 24 to 21 and 12 to 10 switched off *)
					MisfireOrder[8]  := 16#0028AAA0;	(* cylinder 24 to 21 and 12 to  9 switched off *)
					MisfireOrder[9]  := 16#0028AAA8;	(* cylinder 24 to 20 and 12 to  9 switched off *)
					MisfireOrder[10] := 16#002AAAA8;	(* cylinder 24 to 20 and 12 to  8 switched off *)
					MisfireOrder[11] := 16#00AAAAA8;	(* cylinder 24 to 19 and 12 to  8 switched off *)
					MisfireOrder[12] := 16#00AAAAAA;	(* cylinder 24 to 19 and 12 to  7 switched off *)
					MisfireOrder[13] := 16#00AAAEAA;	(* cylinder 24 to 18 and 12 to  7 switched off *)
					MisfireOrder[14] := 16#00AABEAA;	(* cylinder 24 to 18 and 12 to  6 switched off *)
					MisfireOrder[15] := 16#00AABEAE;	(* cylinder 24 to 17 and 12 to  6 switched off *)
					MisfireOrder[16] := 16#00AABEBE;	(* cylinder 24 to 17 and 12 to  5 switched off *)
					MisfireOrder[17] := 16#00AABEFE;	(* cylinder 24 to 16 and 12 to  5 switched off *)
					MisfireOrder[18] := 16#00BABEFE;	(* cylinder 24 to 16 and 12 to  4 switched off *)
					MisfireOrder[19] := 16#00BEBEFE;	(* cylinder 24 to 15 and 12 to  4 switched off *)
					MisfireOrder[20] := 16#00BEBFFE;	(* cylinder 24 to 15 and 12 to  3 switched off *)
					MisfireOrder[21] := 16#00BEFFFE;	(* cylinder 24 to 14 and 12 to  3 switched off *)
					MisfireOrder[22] := 16#00BFFFFE;	(* cylinder 24 to 14 and 12 to  2 switched off *)
					MisfireOrder[23] := 16#00FFFFFE;	(* cylinder 24 to 13 and 12 to  2 switched off *)
					MisfireOrder[24] := 16#00FFFFFF;	(* cylinder 24 to 13 and 12 to  1 switched off *)
				END_IF;
		
		
				SkipfireOrder[0]  	:= 20;	(* avoid overrun of the conditional instruction *)
				SkipfireOrder[1] 	:= 1;
				SkipfireOrder[2]	:= 24;
				SkipfireOrder[3]	:= 7;
				SkipfireOrder[4] 	:= 18;
				SkipfireOrder[5] 	:= 11;
				SkipfireOrder[6] 	:= 14;
				SkipfireOrder[7] 	:= 4;
				SkipfireOrder[8] 	:= 21;
				SkipfireOrder[9] 	:= 10;
				SkipfireOrder[10] 	:= 15;
				SkipfireOrder[11] 	:= 6;
				SkipfireOrder[12] 	:= 19;
				SkipfireOrder[13] 	:= 12;
				SkipfireOrder[14] 	:= 13;
				SkipfireOrder[15] 	:= 3;
				SkipfireOrder[16] 	:= 22;
				SkipfireOrder[17] 	:= 8;
				SkipfireOrder[18] 	:= 17;
				SkipfireOrder[19] 	:= 2;
				SkipfireOrder[20] 	:= 23;
				SkipfireOrder[21] 	:= 9;
				SkipfireOrder[22] 	:= 16;
				SkipfireOrder[23] 	:= 5;
				SkipfireOrder[24] 	:= 20;
		
		(* engine 920 *)
		920 : 	usMotorTyp 		:= Motortype;
				Type 			:= 9;				(* engine series 9 *)
				NumberOfTeeth   := 398;				(* teeth number of starter ring gear *)
				IgnDistance 	:= 22;				(* ignition distance *)
				TimingSeq 		:= 255;				(* timing sequence - not known so far *)
				DistanceAB 		:= 220;				
				DistanceBA 		:= 500;
				
				FireOrder[1]  :=  1;				(* firing order *)
				FireOrder[2]  := 17;
				FireOrder[3]  :=  7;
				FireOrder[4]  := 13;
				FireOrder[5]  :=  3;
				FireOrder[6]  := 19;
				FireOrder[7]  :=  9;
				FireOrder[8]  := 15;
				FireOrder[9]  :=  5;
				FireOrder[10] := 20;
				FireOrder[11] := 10;
				FireOrder[12] := 14;
				FireOrder[13] :=  4;
				FireOrder[14] := 18;
				FireOrder[15] :=  8;
				FireOrder[16] := 12;
				FireOrder[17] :=  2;
				FireOrder[18] := 16;
				FireOrder[19] :=  6;
				FireOrder[20] := 11;
	
				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1]  := 2#00000000000010000000000000000000;	(* cylinder 20 switched off *)
					MisfireOrder[2]  := 2#00000000000010000000001000000000;	(* cylinder 20 and 10 switched off *)
					MisfireOrder[3]  := 2#00000000000011000000001000000000;	(* cylinder 20 to 19 and 10 switched off *)
					MisfireOrder[4]  := 2#00000000000011000000001100000000;	(* cylinder 20 to 19 and 10 to 9  switched off *)
					MisfireOrder[5]  := 2#00000000000011100000001100000000;	(* cylinder 20 to 18 and 10 to 9 switched off *)
					MisfireOrder[6]  := 2#00000000000011100000001110000000;	(* cylinder 20 to 18 and 10 to 8 switched off *)
					MisfireOrder[7]  := 2#00000000000011110000001110000000;	(* cylinder 20 to 17 and 10 to 8 switched off *)
					MisfireOrder[8]  := 2#00000000000011110000001111000000;	(* cylinder 20 to 17 and 10 to 7 switched off *)
					MisfireOrder[9]  := 2#00000000000011111000001111000000;	(* cylinder 20 to 16 and 10 to 7 switched off *)
					MisfireOrder[10] := 2#00000000000011111000001111100000;	(* cylinder 20 to 16 and 10 to 6 switched off *)
					MisfireOrder[11] := 2#00000000000011111100001111100000;	(* cylinder 20 to 15 and 10 to 6 switched off *)
					MisfireOrder[12] := 2#00000000000011111100001111110000;	(* cylinder 20 to 15 and 10 to 5 switched off *)
					MisfireOrder[13] := 2#00000000000011111110001111110000;	(* cylinder 20 to 14 and 10 to 5 switched off *)
					MisfireOrder[14] := 2#00000000000011111110001111111000;	(* cylinder 20 to 14 and 10 to 4 switched off *)
					MisfireOrder[15] := 2#00000000000011111111001111111000;	(* cylinder 20 to 13 and 10 to 4 switched off *)
					MisfireOrder[16] := 2#00000000000011111111001111111100;	(* cylinder 20 to 13 and 10 to 3 switched off *)
					MisfireOrder[17] := 2#00000000000011111111101111111100;	(* cylinder 20 to 12 and 10 to 3 switched off *)
					MisfireOrder[18] := 2#00000000000011111111101111111110;	(* cylinder 20 to 12 and 10 to 2 switched off *)
					MisfireOrder[19] := 2#00000000000011111111111111111110;	(* cylinder 20 to 11 and 10 to 2 switched off *)
					MisfireOrder[20] := 2#00000000000011111111111111111111;	(* cylinder 20 to 11 and 10 to 1 switched off *)
				ELSE
					MisfireOrder[1]  := 16#00000200;	(* cylinder 20 switched off *)
					MisfireOrder[2]  := 16#00000600;	(* cylinder 20, 10 switched off *)
					MisfireOrder[3]  := 16#00008600;	(* cylinder 20-19, 10 switched off *)
					MisfireOrder[4]  := 16#00018600;	(* cylinder 20-19, 10-9 switched off *)
					MisfireOrder[5]  := 16#00018608;	(* cylinder 20-18, 10-9 switched off *)
					MisfireOrder[6]  := 16#00018618;	(* cylinder 20-18, 10-8 switched off *)
					MisfireOrder[7]  := 16#00018E18;	(* cylinder 20-17, 10-8 switched off *)
					MisfireOrder[8]  := 16#00019E18;	(* cylinder 20-17, 10-7 switched off *)
					MisfireOrder[9]  := 16#00039E18;	(* cylinder 20-16, 10-7 switched off *)
					MisfireOrder[10] := 16#00079E18;	(* cylinder 20-16, 10-6 switched off *)
					MisfireOrder[11] := 16#00079E98;	(* cylinder 20-15, 10-6 switched off *)
					MisfireOrder[12] := 16#00079F98;	(* cylinder 20-15, 10-5 switched off *)
					MisfireOrder[13] := 16#00079F9A;	(* cylinder 20-14, 10-5 switched off *)
					MisfireOrder[14] := 16#00079F9E;	(* cylinder 20-14, 10-4 switched off *)
					MisfireOrder[15] := 16#0007BF9E;	(* cylinder 20-13, 10-4 switched off *)
					MisfireOrder[16] := 16#0007FF9E;	(* cylinder 20-13, 10-3 switched off *)
					MisfireOrder[17] := 16#0007FFBE;	(* cylinder 20-12, 10-3 switched off *)
					MisfireOrder[18] := 16#0007FFFE;	(* cylinder 20-12, 10-2 switched off *)
					MisfireOrder[19] := 16#000FFFFE;	(* cylinder 20-11, 10-2 switched off *)
					MisfireOrder[20] := 16#000FFFFF;	(* cylinder 20-1 switched off *)
				END_IF;				
  
				SkipfireOrder[0]	:= 11; 	(* avoid overrun of the conditional instruction *)
				SkipfireOrder[1]	:= 2;
				SkipfireOrder[2]	:= 18;
				SkipfireOrder[3]	:= 10;
				SkipfireOrder[4]	:= 15;
				SkipfireOrder[5]	:= 3;
				SkipfireOrder[6]	:= 17;
				SkipfireOrder[7]	:= 6;
				SkipfireOrder[8]	:= 12;
				SkipfireOrder[9] 	:= 4;
				SkipfireOrder[10]	:= 20;
				SkipfireOrder[11]	:= 9;
				SkipfireOrder[12]	:= 13;
				SkipfireOrder[13]	:= 1;
				SkipfireOrder[14]	:= 16;
				SkipfireOrder[15]	:= 8;
				SkipfireOrder[16]	:= 14;
				SkipfireOrder[17]	:= 5;
				SkipfireOrder[18]	:= 19;
				SkipfireOrder[19]	:= 7;
				SkipfireOrder[20]	:= 11;	
  
  		(* in case of invalid engine series *)
		ELSE	
				ERR_INVALID_MOTORTYPE   := 1;	(* set FB error *)
				usMotorTyp  			:= 208;		(* set to 208 for setting engine 208 parameter *)
				Type 					:= 2;		(* engine series 2		*)
				NumberOfTeeth 			:= 162;		(* teeth number of starter ring gear 		*)
				IgnDistance 			:= 90;		(* ignition distance	*)
				
				FireOrder[1] := 1;					(* firing order 		*)
				FireOrder[2] := 6;
				FireOrder[3] := 2;
				FireOrder[4] := 4;
				FireOrder[5] := 8;
				FireOrder[6] := 3;
				FireOrder[7] := 7;
				FireOrder[8] := 5;
	
				(* Misfire order depanding of SAFI of other ignition system *)
				IF bSAFI_Act AND bSAFIIgn_Act THEN
					MisfireOrder[1] := 2#00000000000000000000000010000000;	(* cylinder 12 switched off *)
					MisfireOrder[2] := 2#00000000000000000000000010001000;	(* cylinder 12 and 6 switched off *)
					MisfireOrder[3] := 2#00000000000000000000000011001000;	(* cylinder 12 to 11 and 6 switched off *)
					MisfireOrder[4] := 2#00000000000000000000000011001100;	(* cylinder 12 to 11 and 6 to 5  switched off *)
					MisfireOrder[5] := 2#00000000000000000000000011101100;	(* cylinder 12 to 10 and 6 to 5 switched off *)
					MisfireOrder[6] := 2#00000000000000000000000011101110;	(* cylinder 12 to 10 and 6 to 4 switched off *)
					MisfireOrder[7] := 2#00000000000000000000000011111110;	(* cylinder 12 to  9 and 6 to 4 switched off *)
					MisfireOrder[8] := 2#00000000000000000000000011111111;	(* cylinder 12 to  9 and 6 to 3 switched off *)
				ELSE
					MisfireOrder[1] := 16#00000010;	(* cylinder 8 switched off *)
					MisfireOrder[2] := 16#00000050;	(* cylinder 8-7 switched off *)
					MisfireOrder[3] := 16#00000052;	(* cylinder 8-6 switched off *)
					MisfireOrder[4] := 16#000000D2;	(* cylinder 8-5 switched off *)
					MisfireOrder[5] := 16#000000DA;	(* cylinder 8-4 switched off *)
					MisfireOrder[6] := 16#000000FA;	(* cylinder 8-3 switched off *)
					MisfireOrder[7] := 16#000000FE;	(* cylinder 8-2 switched off *)
					MisfireOrder[8] := 16#000000FF;	(* cylinder 8-1 switched off *)
				END_IF
		END_CASE;
		
	END_IF;
		
END_FUNCTION_BLOCK
