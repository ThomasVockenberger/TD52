(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: gas_zust
 * File: gas_zustInit.st
 * Author: 105051626
 * Created: May 10, 2012
*******************************************************************)
PROGRAM _INIT

(* Initialization for low pass filter initialization *)
	xLCRPT1_FA_SPEC_GAS.enable := TRUE;
	xLCRPT1_FA_SPEC_GAS.t      := 0.255;
	xLCRPT1_FA_SPEC_GAS.set    := FALSE;	

END_PROGRAM

