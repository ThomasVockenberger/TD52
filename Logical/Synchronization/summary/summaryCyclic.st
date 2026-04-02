(*******************************************************************************
SY: 	summary 	

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without the express written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V1.10	12-01-2006	Lettenbichler, new
V1.11	16-03-2006	lettenbichler, customer gcb[0] added
V2.12	24.04.06/LH	adapted for esy new
		11.11.06/LH	revised after Para.bMSy test
V2.50.1 20.07.2009	lettenb.	any_gcb_opf_bb: OUT_SY.tGCB_OPF.Do added(temp.solution)
V2.60.0 13.08.2009	lettenb.	any_gcb_opf_bb: OUT_SY.tGCB_OPF.Do removed(temp.solution)				

Instructions for use:
--------------------

Outstandings:
------------
*******************************************************************************)
PROGRAM _CYCLIC	
	
	IF	Para.bSyActive THEN
		(*----------------------------------------------------------------------------*)
		other_gcb_on		:=	gcb.other_gcb_on	OR	ccb.on;			(* other gcb closed - busbar *)
		any_gcb_on_bb		:=	gcb.on				OR	other_gcb_on;	(* any   gcb closed - busbar *)
	
		other_gcb_off		:=	ccb.off	AND gcb.all_other_gcb_off;		(* other gcb opened - busbar *)
		all_gcb_off_bb		:=	gcb.off	AND	other_gcb_off;				(* all   gcb opened - busbar *)
	
		(*----------------------------------------------------------------------------*)
		any_eng_oper_and_gcb_on_bb	:= (ccb.eng_oper	AND	ccb.on)		(* any engine operating with closed gcb - busbar *)
									OR (gcb.eng_oper	AND	gcb.on);
	
		(*----------------------------------------------------------------------------*)
		OUT_SY.bOtherGenParallel	:=	gcb.other_gen_parallel 			(* any engine demanded and gcb on - busbar *)
									OR (ccb.eng_demanded	AND	ccb.on);
	
		(*----------------------------------------------------------------------------*)
		any_eng_run_bb		:=	gcb.eng_run	OR	ccb.eng_run;			(* any engine running - busbar *)
		no_eng_run_bb		:=	NOT	any_eng_run_bb;						(* no engine runing   - busbar *)
		
		(*----------------------------------------------------------------------------*)
		(* summary gcb alarms *)
		any_gcb_psf_bb		:=	gcb.alm_psf OR ccb.alm_psf;				(* any gcb position signal failure - busbar *)
		any_gcb_opf_bb		:=	gcb.alm_opf OR ccb.alm_opf;				(* any gcb opening failure         - busbar *)
		any_gcb_alarm_bb 	:=	gcb.alarm   OR ccb.alarm;				(* any gcb alarm                   - busbar *)
	
		(*----------------------------------------------------------------------------*)
	
	END_IF;

END_PROGRAM
