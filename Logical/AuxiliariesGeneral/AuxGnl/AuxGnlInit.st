(***************************************************************************
AuxGnl			auxiliaries general, different outputs  

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V0.1	10.07.1998 Pa			erstellt
 		24.11.1998 Pa			korrekturlesung
V170	08.03.2002 LH			Anforderung Netzstartgerät
 								Anforderung Entregung
 								Anforderung Lastabwurf
V180	21.03.2003 LH			Zuschaltung COSPHI-Regler geändert
V206	22.06.2004 LH			Freigabe Gemischregler über Parameter
V2071c	20.09.2005 LH			neu: Generator ohne Spannung
 								neu: Freigabe Spannungsanwahl LS-Generator
V2072	16.11.2005 LH			Grenzwert Generatorspannung auf Prozent Nennspannung bezogen
V190	14.04.2004 LH			Anforderung Lastabwurf angepasst
 		06.06.2006 LH			neu: Spannungsverstellung Generator
V2102	22.11.2006 LH			Lastabwurf durch Anforderung P-Reduktion im Inselbetrieb
 								GW Generatorspannung: 12,5% --> 30,0%
V212	16.10.2006 LH			Anpassungen für ESY-NEU
V220	19.02.2007 LH			E_LSHK nur noch für GSY aktiv
 								neu: Anforderung Heizwasserpumpe
 								neu: Quittierung Warnung
 		23.03.2007 LH			Aktivierung LSHK für CUN1 AvK-Generator (Plattner)
 		20.04.2007 LH			Eingabe Generator-Nennspannung --> settings 
 		11.05.2007 LH			keine Entregung mehr beim Abstellvorgang (Kruckenhauser)
V2201	04.06.2007 LH			Anforderung Heizwasserpumpe --> Heizwasserpumpe EIN
V2225	23.04.2008 LH			Erweiterungen für Pakistan
V2.34.0	14.10.2008 lettenb.		generator deexcitation A_ENTR: M_GEN_PT added
V2.50.0	28.01.2009 lettenb.		M_MMD_OL added
								DO_DMND_LS: M_BTRB added for PAK
V2.60.0	07.08.2009 lettenb.		FA_A_QUITT from VISA added
V3.10.0	07.08.2009 lettenb.		A_COSPHI: PAK removed (country specific selection removed/steiger joh.)
								FG_KT: AN_RLT_M added (demand cooling tower/steiger/pfister)
V3.20.0	30.09.2010 maier(BuR)	M_GSEIN replaced with GCB_ON
								NS_EIN replaced with MCB_ON
		07.12.2010 lettenb.		DO_A_QUITT, DO_W_QUITT moved to task reset
		07.02.2011				FG_HGV, FG_HGV_ext release main gas valve added (moved from task biogas)
V3.99.0 18.03.2013 pankajrodey	Logic for OUT_AG.tMainsStartDevDem.Do (demand mains start device) moved 
								from this task to EleStart task
V4.03.0 29.07.2015 plattner		condensor pump added
		07.08.2015 Denk			Manual operating auxiliaries control functionality added
		04.12.2015 lettenb.		OUT_AG.tGearPump_Dem.Do added (gruber)
V4.04.0 05.10.2016 Stary        added manual operating mode for engine room air outlet ventilation frequency converter setpoint (xManAuxCtr[17])
		15.11.2016 Stary		bugfix: used rER_OutlV_FC_Set instead of rER_OutlV_FC_Set_Man
V4.05.0 20.09.2017 Messner		Active Cooling Program added
V4.05.1	14.02.2018 Messner		Starter battery voltage monitoring
V4.07.0	09.08.2018 Schmid		2nd low temperature charge cooling circuit added
		08.01.2019 Schmid		redundant pump control added
		22.02.2019 Schmid		ManAuxCtr for hydraulic pre-heating added
		18.03.2019 Schmid		change to redundant pump control logic - new naming convention, new warning texts
		26.04.2019 Schmid		A1031 safety loop emergency stop push button AND A1054 fire alarm split on HW side - adaptations to preserve prior functionality
V4.09.0	05.07.2019 Schmidt		added failed TC post-cooling detection/counter
V4.10.0	20.08.2020 Schmid		bugfix failed TC post-cooling detection/counter - prevent double counting of events
		16.12.2020 Schmid		Battery test (starter and buffer batteries) function added
		23.12.2020 Schmid		ManAuxCtr for prelubrication pump added
V4.11.0	17.12.2021 Schmid		control battery check extension
V4.11.1	08.02.2022 Schmid		bugfixes control battery check extension


Instructions for use:
--------------------
 - acc. network comments  

Outstandings:
------------
***************************************************************************)

PROGRAM _INIT
	
	(* initialize index variable *)
	iNr_CtrlBat_Used			:= 0;
	iIdx_CtrlBat_UnderTest		:= 0;

END_PROGRAM
