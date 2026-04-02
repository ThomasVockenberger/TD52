(* Conversion from decimal to hexadecimal as a string *)

FUNCTION_BLOCK CONV_HEX

	szCRC_Hex			:= '';
	szRest_of_division	:= '';
	iCnt				:= 8;

	WHILE iCnt <> 0 DO
		iRest_of_division	:= iCRC_Dec MOD 16;
		iCRC_Dec			:= iCRC_Dec  /  16;
		iCnt				:= iCnt - 1;
	
		CASE iRest_of_division OF
			0..9:	itoa(iRest_of_division, ADR(szRest_of_division));	(* write int_value to the string *)
			10:		szRest_of_division	:= 'A'; 
			11:		szRest_of_division	:= 'B';  
			12:		szRest_of_division	:= 'C'; 
			13:		szRest_of_division	:= 'D';  
			14:		szRest_of_division	:= 'E';  
			15:		szRest_of_division	:= 'F';  
		END_CASE
	
		strcat(ADR(szRest_of_division), ADR(szCRC_Hex));				(* put second string "szCRC_Hex" to end of first one *)
		strcpy(ADR(szCRC_Hex), ADR(szRest_of_division));    			(* copy "szRest_of_division" into "szCRC_Hex" *)
	END_WHILE

END_FUNCTION_BLOCK
