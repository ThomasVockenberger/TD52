(*******************************************************************************
AGGR: custom IO channels	(cyclic)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2025

- list addidtional customized IO channels

Customized modifications: -
------------------------
 
History:
-------
V3.99	05-07-2012	Weitzer, 	generated FOR modular software	
V4.00	14-02-2014	Weitzer, 	change version number
V4.01	19-02-2015  Weitzer,	add error information strings from IOchannel task
V4.14	06-02-2025  Perktold, 	add possibility for customized mains settings for MMD1 and MMD2
								
Instructions FOR use:
--------------------
- list IO channels which are configured in the IOcgf.dat data module

Outstandings:
------------

*******************************************************************************)

PROGRAM _CYCLIC

	(* Error information strings *)

	szHalIOErrInfo1;
	szHalIOErrInfo2;
	szHalIOErrInfo3;





	(************************************************************)
	(************** BELOW HERE - JUST FOR EXPERTS ***************)
	(* if you ask yourself if you are an expert -> YOU ARE NOT! *)
	(************************************************************)

	(*********)
	(* MMD 1 *)
	(*********)

	(*MMD customized mains setting *)
	bMMD_Out68Cfg_cust[1]		:= FALSE;			(*1 = Activate the usage of bMMD_Out68Cfg_cust[1] for MMD 1 | 0 = (standard) use serial MMD 1 Output68Cfg *)
	Para_iMainsCfg[1]			:= LIMIT(0, 0, 2);	(*<--- define value here *)
	Para_iGenEarthCfg[1]		:= LIMIT(0, 0, 3);	(*<--- define value here *)
	Para_iBusEarthCfg[1]		:= LIMIT(0, 0, 3);	(*<--- define value here *)
	Para_iSynch1EarthCfg[1]		:= LIMIT(0, 0, 3);	(*<--- define value here *)
	Para_iSynch2EarthCfg[1]		:= LIMIT(0, 0, 3);	(*<--- define value here *)

	(* set customized configuration for Output68Cfg *)
	usMMD_Out68Cfg_cust[1].0	:= NOT Para.bGen3PhaseCircuit_Act[1];	(* BIT 00 - Generator mains configuration					*)
	usMMD_Out68Cfg_cust[1].1	:= FALSE;								(* BIT 01 - Reserved - DONT USE								*)
	usMMD_Out68Cfg_cust[1].2	:= NOT Para.bBus3PhaseCircuit_Act[1];	(* BIT 02 - Busbar configuration							*)
	usMMD_Out68Cfg_cust[1].3	:= FALSE;								(* BIT 03 - Reserved - DONT USE								*)
	usMMD_Out68Cfg_cust[1].4	:= Para_iMainsCfg[1].0;					(* BIT 04 - Mains voltage measurement config				*)
	usMMD_Out68Cfg_cust[1].5	:= Para_iMainsCfg[1].1;					(* BIT 05 - Mains voltage measurement config				*)
	usMMD_Out68Cfg_cust[1].6	:= FALSE;								(* BIT 06 - Reserved - DONT USE								*)
	usMMD_Out68Cfg_cust[1].7	:= FALSE;								(* BIT 07 - Reserved - DONT USE								*)
	usMMD_Out68Cfg_cust[1].8	:= Para_iGenEarthCfg[1].0;				(* BIT 08 - Generator voltage measurement - Earthing config	*)
	usMMD_Out68Cfg_cust[1].9	:= Para_iGenEarthCfg[1].1;				(* BIT 09 - Generator voltage measurement - Earthing config	*)
	usMMD_Out68Cfg_cust[1].10	:= Para_iBusEarthCfg[1].0;				(* BIT 10 - Busbar voltage measurement    - Earthing config *)
	usMMD_Out68Cfg_cust[1].11	:= Para_iBusEarthCfg[1].1;				(* BIT 11 - Busbar voltage measurement    - Earthing config *)
	usMMD_Out68Cfg_cust[1].12	:= Para_iSynch1EarthCfg[1].0;			(* BIT 12 - Synch(1) voltage measurement  - Earthing config *)
	usMMD_Out68Cfg_cust[1].13	:= Para_iSynch1EarthCfg[1].1;			(* BIT 13 - Synch(1) voltage measurement  - Earthing config	*)
	usMMD_Out68Cfg_cust[1].14	:= Para_iSynch2EarthCfg[1].0;			(* BIT 14 - Synch(2) voltage measurement  - Earthing config	*)
	usMMD_Out68Cfg_cust[1].15	:= Para_iSynch2EarthCfg[1].1;			(* BIT 15 - Synch(2) voltage measurement  - Earthing config	*)
		


	(*********)
	(* MMD 2 *)
	(*********)
							
	(* customized mains setting *)
	bMMD_Out68Cfg_cust[2]		:= FALSE;			(*1 = Activate the usage of bMMD_Out68Cfg_cust[2] for MMD 2 | 0 = (standard) use serial MMD 2 Output68Cfg *)
	Para_iMainsCfg[2]			:= LIMIT(0, 0, 2);	(*<--- define value here *)
	Para_iGenEarthCfg[2]		:= LIMIT(0, 0, 3);	(*<--- define value here *)
	Para_iBusEarthCfg[2]		:= LIMIT(0, 0, 3);	(*<--- define value here *)
	Para_iSynch1EarthCfg[2]		:= LIMIT(0, 0, 3);	(*<--- define value here *)
	Para_iSynch2EarthCfg[2]		:= LIMIT(0, 0, 3);	(*<--- define value here *)

	(* set customized configuration for Output68Cfg *)
	usMMD_Out68Cfg_cust[2].0	:= NOT Para.bGen3PhaseCircuit_Act[2];	(* BIT 00 - Generator mains configuration					*)
	usMMD_Out68Cfg_cust[2].1	:= FALSE;								(* BIT 01 - Reserved - DONT USE								*)
	usMMD_Out68Cfg_cust[2].2	:= NOT Para.bBus3PhaseCircuit_Act[2];	(* BIT 02 - Busbar configuration							*)
	usMMD_Out68Cfg_cust[2].3	:= FALSE;								(* BIT 03 - Reserved - DONT USE								*)
	usMMD_Out68Cfg_cust[2].4	:= Para_iMainsCfg[2].0;					(* BIT 04 - Mains voltage measurement config				*)
	usMMD_Out68Cfg_cust[2].5	:= Para_iMainsCfg[2].1;					(* BIT 05 - Mains voltage measurement config				*)
	usMMD_Out68Cfg_cust[2].6	:= FALSE;								(* BIT 06 - Reserved - DONT USE								*)
	usMMD_Out68Cfg_cust[2].7	:= FALSE;								(* BIT 07 - Reserved - DONT USE								*)
	usMMD_Out68Cfg_cust[2].8	:= Para_iGenEarthCfg[2].0;				(* BIT 08 - Generator voltage measurement - Earthing config	*)
	usMMD_Out68Cfg_cust[2].9	:= Para_iGenEarthCfg[2].1;				(* BIT 09 - Generator voltage measurement - Earthing config	*)
	usMMD_Out68Cfg_cust[2].10	:= Para_iBusEarthCfg[2].0;				(* BIT 10 - Busbar voltage measurement    - Earthing config *)
	usMMD_Out68Cfg_cust[2].11	:= Para_iBusEarthCfg[2].1;				(* BIT 11 - Busbar voltage measurement    - Earthing config *)
	usMMD_Out68Cfg_cust[2].12	:= Para_iSynch1EarthCfg[2].0;			(* BIT 12 - Synch(1) voltage measurement  - Earthing config *)
	usMMD_Out68Cfg_cust[2].13	:= Para_iSynch1EarthCfg[2].1;			(* BIT 13 - Synch(1) voltage measurement  - Earthing config	*)
	usMMD_Out68Cfg_cust[2].14	:= Para_iSynch2EarthCfg[2].0;			(* BIT 14 - Synch(2) voltage measurement  - Earthing config	*)
	usMMD_Out68Cfg_cust[2].15	:= Para_iSynch2EarthCfg[2].1;			(* BIT 15 - Synch(2) voltage measurement  - Earthing config	*)
										

END_PROGRAM

