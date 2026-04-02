(*******************************************************************************
CUSTOMIZED: c_dig.st - connection and processing of prepared digital I /O channels (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019  

Customized modifications: -
------------------------
 
History:
-------
V0.1	05-03-2002	Weitzer, generated from zaehler.c / V0.1
...
V4.02.0 24.06.2015	Zengerer cleanup

	
Instructions for use:
--------------------

  
Outstandings:
------------

*******************************************************************************)

PROGRAM _INIT
	
	(* ...	change or extend this init file customized, if needed.	*)																						bConnectYourBitHere;		(* this statements mark places all over the code, where you shoud replace it with your own variable names according to customer needs; but please leaf this single occurence unchanged for internal purposes*)




	bDigOut_Release_Default := TRUE; 	(*bDigOut_Release_Default = 1 == alle DO Kanäle sind vordefiniert als aktiv, 0= alle DO Parameter werden DISABELED als default*)


	(**********************************************)
	(*****      END OF CONFIGURATION AREA     *****)
	(**********************************************)
	(* NO CHANGES BEJOND THIS LINE! *)

	(*BETAversion, Abklärung fehlt noch*)	(*bDigOut_Release_Default = 1 == alle DO Kanäle sind vordefiniert als aktiv, 0= alle DO Parameter werden DISABELED als default*)
	FOR cnt := 1 TO 150 DO
		ParaFactoryDefault.bCustDigOut_Active[cnt]		:= bDigOut_Release_Default; 	(*set default parameter value only*)
	END_FOR

END_PROGRAM
