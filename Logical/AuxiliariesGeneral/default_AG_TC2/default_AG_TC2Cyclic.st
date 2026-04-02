(*******************************************************************************
default		value set

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V4.03.0 03.11.2015	lettenb.	new für TC2
																																		
Instructions FOR use:
--------------------
Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC

	(* default TRUE setting for not existing Di's *)
	IN_AG.tEO_Level_Lo_TC2.Di		:=	IN_AG.tEO_Level_Lo_TC2.Di		OR	NOT IN_AG.tEO_Level_Lo_TC2.GoodQual;

	//	IN_AG.x.Di		:=	IN_AG.x.Di		OR	NOT IN_AG.x.GoodQual;

END_PROGRAM
