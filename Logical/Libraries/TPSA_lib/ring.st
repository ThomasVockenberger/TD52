(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: TPSA_lib
 * File: ring.st
 * Author: CaksM
 * Created: Okt 22, 2014
 *******************************************************************)

FUNCTION_BLOCK RING500_R

	IF reset THEN
		//setzte alles zurück
		FOR iCnt:=1 TO 500 DO
			rBuffer[iCnt]	:=	0;
		END_FOR
		iCnt	:=	1;
		out		:=	0;
	ELSE
		//für den ersten start:
		iCnt		:=	LIMIT(1, iCnt, 500);
	
		//limitiere gegen bereichsverletzung
		iCnt_Max	:=	LIMIT(1, iCnt_Max, 500);
		
		//schreibe in den buffer:
		rBuffer[iCnt]	:=	in;
		
		//gehe zum ältesten element
		IF iCnt < iCnt_Max THEN
			iCnt 			:=	iCnt + 1;
		ELSE
			iCnt 			:=	1;
		END_IF
	
		//lese aus den buffer:
		out					:=	rBuffer[iCnt];
	END_IF

END_FUNCTION_BLOCK

FUNCTION_BLOCK RING1000_R

	IF reset THEN
		//setzte alles zurück
		FOR iCnt:=1 TO 1000 DO
			rBuffer[iCnt]	:=	0;
		END_FOR
		iCnt	:=	1;
		out		:=	0;
	ELSE
		//für den ersten start:
		iCnt		:=	LIMIT(1, iCnt, 1000);
	
		//limitiere gegen bereichsverletzung
		iCnt_Max	:=	LIMIT(1, iCnt_Max, 1000);
		
		//schreibe in den buffer:
		rBuffer[iCnt]	:=	in;
		
		//gehe zum ältesten element
		IF iCnt < iCnt_Max THEN
			iCnt 			:=	iCnt + 1;
		ELSE
			iCnt 			:=	1;
		END_IF
	
		//lese aus den buffer:
		out					:=	rBuffer[iCnt];
	END_IF

END_FUNCTION_BLOCK