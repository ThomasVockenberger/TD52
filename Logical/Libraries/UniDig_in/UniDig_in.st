

(*** OLD! ONLY USED FOR TYPEDECLARATIONS. NO FUNCTIONS USED ANYMORE for digital channels.  ****)





(********************************************************************
 * COPYRIGHT -- INNIO Company, Zengerer
 ********************************************************************
 * Library: DigitalIn
 * File: DigIn.st
 * Author: ZengereS
 * Created: Jan 12, 2009
 ********************************************************************
 *
 * Description of library AnalogIn:
 ********************************************************************
 *  Function depending on ucInputType:
 *  ---------------------------------
 * 	THESE INPUT TYPES ARE AVAILABLE: 
 * 		 0=NO_OR_LINK: 					Channel status only set by visu parameter (default)
 * 		 1=OR Hardware Digital IN Nr:	Channel connected to predefined hardware input channel 
 *		 2=OR AI_LimitMax Nr:			Channel connected to Analog Input Limit
 *		 4=OR AI_LimitOptiMax Nr:		Channel connected to Analog Input Limit
 *		 8=OR AI_LimitOptiMin Nr:		Channel connected to Analog Input Limit
 * 	   128=OR UniversalDigtal Nr:		Channel connected to reuse other digital channel
 *
 ********************************************************************
 *  History:
 *  --------
 *	2009-02-08  V0.20	Zengerer	1.st type definition
 *	2019-11-13  V0.21	Zengerer	DUMMY LIB without any function; call to avoid compiler warning 5880
 *
 * LEGACY CODE- DO NOT USE IN NEW IMPLEMENTATIONS!
 *
 ********************************************************************)

FUNCTION_BLOCK dig_in		(*Eingang*)
	(* Dummy function, to avoid compiler warning 5880 *)
	slOutScaled ; 	(*Do Not Use- Internal Dummy*)
	ssInFiltered ; 	(*Do Not Use- Internal Dummy*)
	ucInputType ; 	(*Do Not Use- Internal Dummy*)
	
	(* remove library, when not longer needed for para tape compatibility. *)

END_FUNCTION_BLOCK

