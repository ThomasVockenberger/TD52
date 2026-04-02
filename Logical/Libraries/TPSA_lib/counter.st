(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: TPSA_lib
 * File: counter.st
 * Author: CaksM
 * Created: Sept 23, 2014
 *******************************************************************)

FUNCTION_BLOCK COUNTER50


	IF EDGEPOS(in) AND NOT reset THEN
		(* setze Zeitstemperl *)
		ti[iCnt]	:=		clock_ms();			
		(* suche vergleichs Zähler *)
		IF iCnt - iNum_Max < 0 THEN
			iCmp	:=	iCnt - iNum_Max + iCnt_Max + 1;
		ELSE
			iCmp	:=	iCnt - iNum_Max;
		END_IF
		(* setze Ausgang *)
		IF 	TIME_TO_DINT(ti[iCmp]) <> 0	AND ti[iCnt] - ti[iCmp] < ti_Max AND iNum_Max <> 0 THEN	
			out := 	TRUE;
		ELSE
			out	:=	FALSE;
		END_IF
		(* erhoehe Zähler *)
		IF iCnt >= iCnt_Max	THEN				//erhöhe Zähler
			iCnt			:=	0;
		ELSE
			iCnt			:=	iCnt	+	1;
		END_IF
	ELSIF reset THEN
		(* setze alle variablen zurueck *)
		FOR iCnt := 0 TO iCnt_Max DO
			ti[iCnt]	:=		T#0s;	
		END_FOR
		out		:=	FALSE;
		iCnt	:=	0;
		iCmp	:=	0;
	ELSIF out THEN
		IF 	TIME_TO_DINT(ti[iCmp]) <> 0	AND clock_ms() - ti[iCmp] < ti_Max AND iNum_Max <> 0 THEN	
			out := 	TRUE;
		ELSE
			out	:=	FALSE;
		END_IF
	END_IF

END_FUNCTION_BLOCK

FUNCTION_BLOCK COUNTER100


	IF EDGEPOS(in) AND NOT reset THEN
		(* setze Zeitstemperl *)
		ti[iCnt]	:=		clock_ms();			
		(* suche vergleichs Zähler *)
		IF iCnt - iNum_Max < 0 THEN
			iCmp	:=	iCnt - iNum_Max + iCnt_Max + 1;
		ELSE
			iCmp	:=	iCnt - iNum_Max;
		END_IF
		(* setze Ausgang *)
		IF 	TIME_TO_DINT(ti[iCmp]) <> 0	AND ti[iCnt] - ti[iCmp] < ti_Max AND iNum_Max <> 0 THEN	
			out := 	TRUE;
		ELSE
			out	:=	FALSE;
		END_IF
		(* erhoehe Zähler *)
		IF iCnt >= iCnt_Max	THEN				//erhöhe Zähler
			iCnt			:=	0;
		ELSE
			iCnt			:=	iCnt	+	1;
		END_IF
	ELSIF reset THEN
		(* setze alle variablen zurueck *)
		FOR iCnt := 0 TO iCnt_Max DO
			ti[iCnt]	:=		T#0s;	
		END_FOR
		out		:=	FALSE;
		iCnt	:=	0;
		iCmp	:=	0;
	ELSIF out THEN
		IF 	TIME_TO_DINT(ti[iCmp]) <> 0	AND clock_ms() - ti[iCmp] < ti_Max AND iNum_Max <> 0 THEN	
			out := 	TRUE;
		ELSE
			out	:=	FALSE;
		END_IF
	END_IF

END_FUNCTION_BLOCK