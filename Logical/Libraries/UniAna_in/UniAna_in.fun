(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: AnalogIn
 * File: AnalogIn.fun
 * Author: ZengereS
 * Created: December 04, 2007
 ********************************************************************
 * Functions and function blocks of library AnalogIn
 ********************************************************************)

FUNCTION_BLOCK ana_in
	VAR_INPUT
		ssIn : INT; (*Analog input from hardware*)
		bInQuit : BOOL; (*quitt error messages input*)
		tAnaInPERMEM : tAnaInPERMEM_typ; (*Assign Variable to Permanent Memory!*)
	END_VAR
	VAR_OUTPUT
		ssOut : INT; (*compatible OLD integer scaled analoge value*)
		ssOutModulo : INT; (*modulo of scaled value, if >0 digits after . selected in parameter*)
		rOut : REAL; (*altenative output as scaled real value*)
		szOutState : STRING[16]; (*status output in clear text for visualisation*)
		tAna_inErrors : tAnaInErrors_typ; (*statusbits for error indication*)
	END_VAR
	VAR
		slOutScaled : DINT; (*Do Not Use- Internal use only*)
		ssInFiltered : INT; (*Do Not Use- Internal use only*)
		ucInputType : USINT; (*Do Not Use- Internal use only*)
		FILTER_0 : xUniAnaFilter;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK ana_in_SG3helper
	VAR_INPUT
		ssInRaw : INT; (*Analog input from hardware*)
		ssIn : INT; (*OPTIONAL: scaled analog input from output of scaling function*)
		tAna_inErrors : tAnaInErrors_typ; (*statusbits for error indication*)
		tAnaInPERMEM : tAnaInPERMEM_typ; (*Assign Variable to Permanent Memory!*)
	END_VAR
	VAR_OUTPUT
		ssOutRaw : INT; (*scaled analoge value,*)
		slOut : DINT; (*OPTIONAL: scaled analoge value FOR FIXED 3DIGITS AFTER DECIMAL DISPLAY*)
		tAnaInHelper : tAnaInHelper_typ; (*helper bits data type, especialy for older SG3- visualisation*)
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK xUniAnaFilter (* filter with PT1 behaivior and DINT in/output *)
	VAR_INPUT
		In : DINT;
		Filter : UINT;
	END_VAR
	VAR_OUTPUT
		Out : DINT;
	END_VAR
	VAR
		mw : DINT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK xUniAnaFilterR (* filter with PT1 behaivior and REAL in/output *)
	VAR_INPUT
		In : REAL;
		Filter : UINT;
	END_VAR
	VAR_OUTPUT
		Out : REAL;
	END_VAR
	VAR
		mw : REAL;
	END_VAR
END_FUNCTION_BLOCK
