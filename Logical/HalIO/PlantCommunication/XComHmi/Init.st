(*******************************************************************************
Hmi Logic for the Plant Communication Diagnostics and Forcing screen

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2024

Customized modifications: -
------------------------
 
History:
-------
V4.14.0	26.11.2024	Astner	Created Task

						
Instructions for use: -
--------------------

Outstandings:
------------

*******************************************************************************)

PROGRAM _INIT
	
	tHmiDiag.iAnaSigCntE2E := iAnaArrayMaxAll + 1;
	tHmiDiag.iDigSigCntE2E := iDigArrayMaxAll + 1;
	tHmiDiag.iAnaSigCntE2M := iAnaArrayMaxAll + 1;
	tHmiDiag.iDigSigCntE2M := iDigArrayMaxAll + 1;
	tHmiDiag.iDiagTableSize := 16;
	 
END_PROGRAM