(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: OpMode
 * File: OpMode.st
 * Author: Waldhart, Graus
 * Created: November 29, 2011
 ********************************************************************
 * Implementation of library OpMode
 ********************************************************************
 This code is confidential and proprietary to the INNIO Company.
 It may not be used in any form, or reproduced in any manner, without the express
 written permission of the INNIO Company. 
 Copyright, INNIO Company, 2019 

 History:
 -------
 V0.01.0	29-11-2011	Waldhart,	generated
 V0.02.0	20-04-2012	Graus,		extension with outputs for sub- and degradation operation mode


*)

FUNCTION_BLOCK OpMode
	(* Reserve *)	

	(* Main Mode *)	
	iMainMode 	:= UDINT_TO_INT((in AND 16#00FF0000)/ 65535);
	Stop 		:= iMainMode = 10;	(* StopM *)
	Start 		:= iMainMode = 30;	(* StartM *)
	Idle 		:= iMainMode = 40;	(* LeerM *)
	NetP 		:= iMainMode = 50;	(* NetpM *)
	Island 		:= iMainMode = 60;	(* InselM *)
	
	(* Sub Mode *)	
	iSubMode 	:= UDINT_TO_INT((in AND 16#0000FF00)/ 256);
	
	(* Degradation Mode *)	
	iDegMode 	:= UDINT_TO_INT((in AND 16#0000FF00));

END_FUNCTION_BLOCK
