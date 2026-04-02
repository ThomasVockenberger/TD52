(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: OpMode
 * File: OpMode.fun
 * Author: 105046866
 * Created: November 29, 2011
 ********************************************************************
 * Functions and function blocks of library OpMode
 ********************************************************************)

FUNCTION_BLOCK OpMode (*TODO: Add your comment here*)
	VAR_INPUT
		in : UDINT;
	END_VAR
	VAR_OUTPUT
		Stop : BOOL;
		Start : BOOL;
		Idle : BOOL;
		NetP : BOOL;
		Island : BOOL;
		iMainMode : INT; (*Index main mode*)
		iSubMode : INT; (*Index sub mode*)
		iDegMode : INT; (*Index degredation mode*)
	END_VAR
END_FUNCTION_BLOCK
