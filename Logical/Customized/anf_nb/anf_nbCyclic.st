(*******************************************************************************
anf_nb 			customized engine demand depending of griddemand power setpoints

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V3.90.0	??-??-2012 ?pankayrodney?  	converted from LD	
V3.90.1	14-12-2012 Zengerer			rework, renaming of some varnames according to naming convention	
V3.91	14.02.2013 zengerer			datatypes changed to real...
V3.92	05.07.2013 zengerer			new interface OUT_CU.rP_MainsImport
V4.03.0	05.07.2013 zengerer			Bugfix: remove predefined reserve parameter numbers to avoid unintended task activation 
!ALT! TASK NICHT MEHR VERWENDEN- - -> c_mns
		
Instructions for use:
--------------------
OUT_CU.bEngDSS_Mains  (==ANF_NB) generated depending on utility demand signals


Outstandings:
------------
!ALT! TASK NICHT MEHR VERWENDEN- - -> c_mns


	

*******************************************************************************)
PROGRAM _INIT

	(*	OLD TASK - DO NOT USE ANYMORE! *)

	(*Functionality MOVED TO TASK c_mms *)



END_PROGRAM

