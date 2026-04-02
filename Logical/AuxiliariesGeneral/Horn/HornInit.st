(*******************************************************************************
horn		sound alarm

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
V0.1	03.07.1998 Pa			erstellt
		24.11.1998 Pa			Korrekturlesung
V1.70	14.03.2002 LH			HUPE / SUMMER
V2.073b	26.04.2006 ThJ			Evacuation
V2.33	15.07.2008 ThJ			3-colour signalling
V2.50	12.03.2009 ThJ			3-colour signalling expanded
V2.50.1	06.07.2009 ThJ			EVAC_HORN additionally from not stored signals
V3.10.0	17.02.2010 lettenb.		QUITT_WA -> E_QUITT (remote reset)
V4.10.0	07.12.2020 Schmid		reset horn off button from vis, CO alarm added to Evacuation
						
Instructions for use:
--------------------
Outstandings:
------------

*******************************************************************************)
PROGRAM _INIT

	xHorn_Active.enable				:= TRUE;
	xHorn_Active.pPVstring			:= ADR('HalIO::Horn');
	xHorn_Active();
	
	xHorn_Warning_Active.enable		:= TRUE;
	xHorn_Warning_Active.pPVstring	:= ADR('HalIO::Horn_Warning');
	xHorn_Warning_Active();
	
	xHorn_Trip_Active.enable		:= TRUE;
	xHorn_Trip_Active.pPVstring		:= ADR('HalIO::Horn_Trip');
	xHorn_Trip_Active();

END_PROGRAM
