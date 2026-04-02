(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: MSCcsv
 * File: MSCcsv.fun
 * Author: 502423184
 * Created: May 18, 2015
 ********************************************************************
 * Implementation of Functions AND FUNCTION blocks OF library MSCcsv
 ********************************************************************)

(* saves the error bit data *)
FUNCTION_BLOCK ErrCnt_FUB
	IF bReset THEN
		tTS_First.Year	:=	0;
		tTS_First.Month	:=	0;
		tTS_First.Day	:=	0;
		tTS_First.Hour	:=	0;
		tTS_First.Minute:=	0;
		tTS_First.Second:=	0;
		tTS_Last.Year	:=	0;
		tTS_Last.Month	:=	0;
		tTS_Last.Day	:=	0;
		tTS_Last.Hour	:=	0;
		tTS_Last.Minute	:=	0;
		tTS_Last.Second	:=	0;
		iCnt			:=	0;
	ELSIF bError THEN
		IF iCnt = 0 THEN
			tTS_First	:=	tTS;
		END_IF		
		tTS_Last		:=	tTS;
		iCnt		:=	iCnt + 1;
	END_IF
	iNum_Cyl;
	Name;
END_FUNCTION_BLOCK
(* decimal stellen *)
FUNCTION DECI
	IF In < 10.0 THEN
		DECI :=	0;
	ELSIF In < 100.0 THEN
		DECI :=	1;
	ELSIF In < 1000.0 THEN
		DECI :=	2;
	ELSIF In < 10000.0 THEN
		DECI :=	3;
	ELSIF In < 100000.0 THEN
		DECI :=	4;
	ELSE
		DECI := 5;
	END_IF
END_FUNCTION

FUNCTION WRITE_TS					(* FORMAT: DD.MM.YYYY HH:MM:SS; OR N.A.;*)

	WRITE_TS := In.Month > 0;

	IF In.Month > 0 THEN	
						
		itoa(In.Day, ADR(szTemp));
		IF strlen(ADR(szTemp)) < 2  THEN 
			strcat(adrSTR, ADR('0'));
		END_IF
		strcat(adrSTR, ADR(szTemp));
	
		strcat(adrSTR, ADR('.'));
	
		itoa(In.Month, ADR(szTemp));
		IF strlen(ADR(szTemp)) < 2  THEN 
			strcat(adrSTR, ADR('0'));
		END_IF
		strcat(adrSTR, ADR(szTemp));
	
		strcat(adrSTR, ADR('.20'));
	
		itoa(In.Year, ADR(szTemp));
		IF strlen(ADR(szTemp)) < 2  THEN 
			strcat(adrSTR, ADR('0'));
		END_IF
		strcat(adrSTR, ADR(szTemp));
	
		strcat(adrSTR, ADR(' '));
	
		itoa(In.Hour, ADR(szTemp));	
		IF strlen(ADR(szTemp)) < 2  THEN 
			strcat(adrSTR, ADR('0'));
		END_IF
		strcat(adrSTR, ADR(szTemp));
	
		strcat(adrSTR, ADR(':'));
	
		itoa(In.Minute, ADR(szTemp));
		IF strlen(ADR(szTemp)) < 2  THEN 
			strcat(adrSTR, ADR('0'));
		END_IF
		strcat(adrSTR, ADR(szTemp));
	
		strcat(adrSTR, ADR(':'));
	
		itoa(In.Second, ADR(szTemp));
		IF strlen(ADR(szTemp)) < 2  THEN 
			strcat(adrSTR, ADR('0'));
		END_IF
		strcat(adrSTR, ADR(szTemp));
	ELSE
		strcat(adrSTR, ADR('N.A.'));	
	END_IF
	strcat(adrSTR, ADR(';'));
END_FUNCTION


(* converts a UDINT to a BOOL array[0..24] *)
FUNCTION UDINT_TO_BITS
	IF iNum_Cyl > 0 AND iNum_Cyl < 25 THEN
		UDINT_TO_BITS := UDINT_TO_BOOL(In AND REAL_TO_UDINT(2.0 ** (USINT_TO_REAL(iNum_Cyl)-1.0)));
	ELSE
		UDINT_TO_BITS := FALSE;
	END_IF
END_FUNCTION
(* converts a BOOL array[0..24] to a UDINT *)
FUNCTION BITS_TO_UDINT
	BITS_TO_UDINT := 0;
	FOR i:=1 TO iNum_Cyl DO
		BITS_TO_UDINT := BITS_TO_UDINT OR BOOL_TO_UDINT(Bits[i])* REAL_TO_UDINT(2.0 ** (USINT_TO_REAL(i)-1.0));
	END_FOR
END_FUNCTION
(* writes a REAL to a STRING ending with ; *)
FUNCTION WRITE_REAL
	IF rInput < 0.0 THEN
		strcat(adrSTR, ADR('-'));
	END_IF
	iInput1		:=	REAL_TO_DINT(ABS(rInput) * (10 ** USINT_TO_REAL(ucNachkomma)));
	iInput2		:=	iInput1 MOD REAL_TO_DINT(10 ** USINT_TO_REAL(ucNachkomma));
	iInput1		:=	(iInput1 - iInput2)/REAL_TO_DINT(10 ** USINT_TO_REAL(ucNachkomma));
	itoa(iInput1, ADR(szVorkomma));
	strcat(adrSTR, ADR(szVorkomma));
	IF ucNachkomma	<>	0 THEN
		itoa(ABS(iInput2), ADR(szNachkomma));
		strcat(adrSTR, ADR('.'));
		FOR iInput1 := 0 TO USINT_TO_DINT(ucNachkomma) - 1 DO
			IF UINT_TO_DINT(strlen(ADR(szNachkomma))) < USINT_TO_DINT(ucNachkomma) - iInput1 THEN
				strcat(adrSTR, ADR('0'));
			END_IF
		END_FOR		
		strcat(adrSTR, ADR(szNachkomma));
	END_IF
	strcat(adrSTR, ADR(';'));
	WRITE_REAL	:=	TRUE;
END_FUNCTION
(* writes a DINT to a STRING ending with ; *)
FUNCTION WRITE_DINT
	itoa(iInput, ADR(szVorkomma));
	strcat(adrSTR, ADR(szVorkomma));
	strcat(adrSTR, ADR(';'));
	WRITE_DINT	:=	TRUE;
END_FUNCTION
(* writes a STRING to a STRING ending with ; *)
FUNCTION WRITE_STRING
	strcat(adrSTR, adrInput);
	strcat(adrSTR, ADR(';'));
	WRITE_STRING	:=	TRUE;
END_FUNCTION
(* writes a BIT to a STRING ending with ; *)
FUNCTION WRITE_BIT
	IF BIT THEN
		strcat(adrSTR, ADR('1;'));
	ELSE
		strcat(adrSTR, ADR('0;'));
	END_IF
	WRITE_BIT	:=	TRUE;
END_FUNCTION
(* save strcat *)
FUNCTION save_strcat
	length		:=	UINT_TO_UDINT(strlen(pSrc));
	IF pDest_Start + length < pDest + pDest_Size AND pDest_Start >= pDest THEN
		save_strcat	:=	memcpy(pDest_Start, pSrc, length + 1) - 1;
	ELSE
		save_strcat	:=	0;
	END_IF
END_FUNCTION
(* finds the median in an array 0-24 *)
FUNCTION MED_VAL
	Size	:=	LIMIT(1, Size, 24);
	Sort	:=	In;
	FOR i := 2 TO Size DO
		j := i;
		WHILE j >= 2 AND Sort[j-1] > Sort[j] DO
			rTemp		:=	Sort[j-1];
			Sort[j-1]	:=	Sort[j];
			Sort[j] 	:=	rTemp;
			j			:=	j - 1;
		END_WHILE
	END_FOR
	IF INT_TO_BOOL(Size MOD 2) THEN
		MED_VAL := Sort[(Size+1)/2];
	ELSE
		MED_VAL := (Sort[Size/2] + Sort[Size/2+1])/2;
	END_IF	
END_FUNCTION
(* finds the maximum in an array 0-24 *)
FUNCTION MAX_VAL
	Size	:=	LIMIT(1, Size, 24);
	MAX_VAL	:=	In[1];
	FOR i:= 2 TO Size DO
		MAX_VAL	:=	MAX(MAX_VAL, In[i]);
	END_FOR
END_FUNCTION
(* finds the minimum in an array 0-24 *)
FUNCTION MIN_VAL
	Size	:=	LIMIT(1, Size, 24);
	MIN_VAL	:=	In[1];
	FOR i:= 2 TO Size DO
		MIN_VAL	:=	MIN(MIN_VAL, In[i]);
	END_FOR
END_FUNCTION
(* finds the position of the maximum in an array 0-24 *)
FUNCTION MAX_POS
	Size	:=	LIMIT(1, Size, 24);
	rTemp	:=	In[1];
	MAX_POS	:=	1;
	FOR i:= 2 TO Size DO
		IF rTemp < In[i] THEN
			rTemp	:=	In[i];
			MAX_POS	:=	i;
		END_IF
	END_FOR
END_FUNCTION
(* finds the average value in an array 0-24 *)
FUNCTION AVG_VAL
	Size	:=	LIMIT(1, Size, 24);
	AVG_VAL	:=	In[1];
	FOR i:= 2 TO Size DO
		AVG_VAL	:=	AVG_VAL + In[i];
	END_FOR
	AVG_VAL	:=	AVG_VAL / USINT_TO_REAL(Size);
END_FUNCTION
(* finds the position of the maximum in an array 0-100 *)
FUNCTION MAX_POS_ADR
	Size		:=	LIMIT(0, Size, 100);
	In1			:=	memcpy(ADR(rTemp),ADR(In),4);
	MAX_POS_ADR	:=	0;
	FOR i:= 1 TO Size DO
		In1 := memcpy(ADR(rTemp1),ADR(In1),4);
		IF rTemp < rTemp1 THEN
			rTemp		:=	rTemp1;
			MAX_POS_ADR	:=	i;
		END_IF
	END_FOR
END_FUNCTION
(* time to real in seconds *)
FUNCTION TIME_TO_REAL_S
	TIME_TO_REAL_S	:=	TIME_TO_REAL(In)/1000.0;
END_FUNCTION
(* time to real in minutes *)
FUNCTION TIME_TO_REAL_M
	TIME_TO_REAL_M	:=	TIME_TO_REAL_S(In)/60.0;
END_FUNCTION
(* time to real in hours *)
FUNCTION TIME_TO_REAL_H
	TIME_TO_REAL_H	:=	TIME_TO_REAL_S(In)/3600.0;
END_FUNCTION

FUNCTION WRITE_YYYY
	strcat(adrFile, ADR('20'));
	itoa(xtRealTime.year, ADR(szCopyCat));		//Jahr
	strcpy(adrFile, ADR(szCopyCat));
	WRITE_YYYY	:=	0;
END_FUNCTION
FUNCTION WRITE_MM
	itoa(xtRealTime.month, ADR(szCopyCat));		//Monat
	IF strlen(ADR(szCopyCat)) < 2  THEN 
		strcat(adrFile, ADR('0'));
	END_IF
	strcat(adrFile, ADR(szCopyCat));
	WRITE_MM	:=	0;
END_FUNCTION
FUNCTION WRITE_DD
	itoa(xtRealTime.day, ADR(szCopyCat));		//Tag
	IF strlen(ADR(szCopyCat)) < 2  THEN 
		strcat(adrFile, ADR('0'));
	END_IF
	strcat(adrFile, ADR(szCopyCat));
	WRITE_DD	:=	0;
END_FUNCTION
FUNCTION WRITE_HH
	itoa(xtRealTime.hour, ADR(szCopyCat));		//Stunde
	IF strlen(ADR(szCopyCat)) < 2  THEN 
		strcat(adrFile, ADR('0'));
	END_IF
	strcat(adrFile, ADR(szCopyCat));
	WRITE_HH	:=	0;
END_FUNCTION
FUNCTION WRITE_mm
	itoa(xtRealTime.minute, ADR(szCopyCat));	//Minute
	IF strlen(ADR(szCopyCat)) < 2  THEN 
		strcat(adrFile, ADR('0'));
	END_IF
	strcat(adrFile, ADR(szCopyCat));
	WRITE_mm	:=	0;
END_FUNCTION
FUNCTION WRITE_YYYYMMDD
	WRITE_YYYY(adrFile,xtRealTime);
	WRITE_MM(adrFile,xtRealTime);
	WRITE_DD(adrFile,xtRealTime);
	WRITE_YYYYMMDD	:=	0;
END_FUNCTION
FUNCTION WRITE_HHmm
	WRITE_HH(adrFile,xtRealTime);
	WRITE_mm(adrFile,xtRealTime);
	WRITE_HHmm	:=	0;
END_FUNCTION
FUNCTION WRITE_Date
	WRITE_YYYYMMDD(adrFile,xtRealTime);
	strcat(adrFile, ADR('_'));
	WRITE_HHmm(adrFile,xtRealTime);
	WRITE_Date	:=	0;
END_FUNCTION