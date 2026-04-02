(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: pb4_6
 * File: pb4_6Init.st
 * Author: 105051626
 * Created: July 04, 2012
 *******************************************************************)

PROGRAM _INIT

	// This is to ensure a first call to the function before it is called within the cyclic code
	xR_TRIG_FA_FL_PUFF.CLK := OUT_GT.bDeflagrationPrct;
	xR_TRIG_FA_FL_PUFF();
	
	xTP_DiffPC_LimLo_Switch.PT := T#5s;

END_PROGRAM