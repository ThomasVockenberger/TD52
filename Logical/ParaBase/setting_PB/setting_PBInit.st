(*******************************************************************************
settings			meta module settings 

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019
 
Customized modifications: -
------------------------
 
History:
-------
V0.1	17.09.2012	Zengerer	new
V4.03	30.10.2015	Zengerer	bForceModuleMandatory_KN := TRUE
		
Instructions for use:
--------------------
cofiguration storage for some basic system checks

Outstandings:
------------


(*******************************************************************************)
PROGRAM _INIT
												(* old_var:		comment:												unit:	def:	min:	max:	read:	write:	*)	
	Para.iEng_Motortype;		(*	:=	412;	(* x			Para engine motortype									n/a		920		208		920		10		50		*)	
	
	(* Configure optional Factory Default Values here, if no datamodule exists on a new/empti controller *)
	ParaFactoryDefault.bSaveParaAllowedDespiteDownload :=	TRUE;
	ParaFactoryDefault.bIgnoreParaSetupOk_TR := 			TRUE;
	ParaFactoryDefault.ReplaceMeWithYourParameter :=		54321;	(*Demo value, no function*)
	
										   

	(* Configure MANDATORY Metamodules here HARDCODED *)
	bForceModuleMandatory_AB := TRUE;
	bForceModuleMandatory_AG;
	bForceModuleMandatory_CH;
	bForceModuleMandatory_CP;
	bForceModuleMandatory_CU;	
	bForceModuleMandatory_EC := TRUE;
	bForceModuleMandatory_EG;
	bForceModuleMandatory_EM;				(*Exhaust Monitoring, new*)
	bForceModuleMandatory_EX;
	bForceModuleMandatory_GC;
	bForceModuleMandatory_GD;
	bForceModuleMandatory_GM;
	bForceModuleMandatory_GR; (*prepared*)
	bForceModuleMandatory_GT;
	bForceModuleMandatory_HA := TRUE;
	bForceModuleMandatory_HC;
	bForceModuleMandatory_IC;
	bForceModuleMandatory_IG;
	bForceModuleMandatory_KL;
	bForceModuleMandatory_KN := TRUE;
	bForceModuleMandatory_MO;
	bForceModuleMandatory_OP := TRUE;
	bForceModuleMandatory_PB := TRUE;
	bForceModuleMandatory_SA;
	bForceModuleMandatory_SY;
	bForceModuleMandatory_TR;
	bForceModuleMandatory_VE;
	bForceModuleMandatory_VI;

	//CANCELLED: AUSLESEN DIESER INFO AUS MODUL- METAINFO FILE? 	

	IN_PB.tAlarmB2PB.bResetTrip; 	(*Fehlt noch: Amm- Anbindung der ParaBase- eigenen Alarme*)
	OUT_PB.tPB2AB.bGnlWarning;		(*Fehlt noch: Amm- Anbindung der ParaBase- eigenen Alarme*)
	
		
END_PROGRAM


