
{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK CONV_HEX (*Conversion from decimal to hexadecimal as a string*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		iCRC_Dec : {REDUND_UNREPLICABLE} UDINT; (*CRC as decimal value*)
	END_VAR
	VAR_OUTPUT
		szCRC_Hex : {REDUND_UNREPLICABLE} STRING[80]; (*CRC as hexadecimal value*)
	END_VAR
	VAR
		iCnt : {REDUND_UNREPLICABLE} UINT; (*Counter for CRC string conversion*)
		iRest_of_division : {REDUND_UNREPLICABLE} UDINT; (*Remaining part of division [INTEGER]*)
		szRest_of_division : {REDUND_UNREPLICABLE} STRING[80]; (*Remaining part of division [STRING]*)
	END_VAR
END_FUNCTION_BLOCK
