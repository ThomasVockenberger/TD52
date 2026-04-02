(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: VisGT
 * File: VisGTInit.st
 * Author: 105051626
 * Created: July 05, 2012
 ********************************************************************
 * Implementation of program VisGT
 ********************************************************************)

PROGRAM _INIT


	(*Predefine gastype 1, if nothing else is selected*)
	IF VIS2MM.iIdx_SelGasTyp = 0 THEN 
		VIS2MM.iIdx_SelGasTyp	:= 1;
	END_IF


END_PROGRAM

