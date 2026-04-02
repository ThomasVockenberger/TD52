(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: TPSA_lib
 * File: rmedian.st
 * Author: WaldharM
 * Created: March 14, 2012
 *******************************************************************)

FUNCTION_BLOCK RMEDIAN24
	anzahl := LIMIT(0,anzahl,24);
	FOR i := 2 TO anzahl DO
		j := i;
		WHILE j >= 2 AND in[j-1] > in[j] DO
			rDummy := in[j-1];
			in[j-1] := in[j];
			in[j] 	:= rDummy;
			j := j-1;
		END_WHILE
	END_FOR

	IF INT_TO_BOOL(anzahl MOD 2) THEN	// ungerade
		median := in[(anzahl+1)/2];
	ELSE 					//gerade
		median := (in[anzahl/2] + in[anzahl/2+1])/2;
	END_IF	
END_FUNCTION_BLOCK