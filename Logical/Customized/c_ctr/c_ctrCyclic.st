(*******************************************************************************
CUSTOMIZED: c_ctr 		reserve controller handling (cyclic)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2022

Customized modifications: -
------------------------
 
History:
-------
		23.05.2012	Zengerer	generated, new
V4.02	09.09.2015	Zengerer	cleanup, prototype entry FOR documentation comments
V4.04	20.06.2016	Weitzer		add controller 41 .. 45
V4.05	23.01.2018	Perktold	added option for humitity control with ctr. 2
V4.11	27.01.2022	Perktold	impemented plant controller upgrade (2nd W_set, Gain Scheduling, Retrigger, cust. Ymin/max)
		31.01.2022	zengerer	extended controller items 41-45 ONLY FOR USE WITH HMI Extension Package!
		
Instructions FOR use:
--------------------
-
Outstandings:
------------
- ENTFERNEN: IF NOT bEnableTestBench THEN   (*NUR FÜR TPSS- Prüfstand...

*******************************************************************************)

PROGRAM _CYCLIC
																																		//	IF NOT bEnableTestBench THEN   (*Bit bEnableTestBench NUR FÜR TP- Prüfstand aktivieren*)

	(* customizable controller X 		*** PROTOTYPE EXAMPLE ***
	VIS2MM.tCtr_Cust1_In.enable			:= Para.bCtr_Cust1 AND TRUE;	* enable controller with parameter / AND connect additional enable bits here *
	VIS2MM.tCtr_Cust1_In.X				:= 0;							* connect actual controller value here  *
	VIS2MM.tCtr_Cust1_In.W_ext			:= 0;							* optional: connect external controller setpoint value here  *
	VIS2MM.tCtr_Cust1_In.W_ext_Active	:= FALSE;						* optional: connect activation of external setpoint here  *
	VIS2MM.tCtr_Cust1_In.W_set2_Active	:= FALSE;						* optional: connect signal to switch to 2nd internal setpoint here  * 
	VIS2MM.tCtr_Cust1_In.GainScheduling	:= 0.0;							* optional: connect Gain Scheduling signal here, limits [0.0-1.0] : 0.0 = use 100% of the standard PID-parameters | 1.0 = use 100% of the GainSched. PID Parameters | linear interpolation in between  *
	VIS2MM.tCtr_Cust1_In.Y_min_cust		:= -1.0;						* optional: "customized" Y-MIN at the current moment (The existing Y-MIN parameter is the global minimum. To have an effect Y_min_cust needs TO be > the parameter | -1.0 = FUNCTION NOT used *
	VIS2MM.tCtr_Cust1_In.Y_max_cust		:= 1.0;							* optional: "customized" Y-MAX at the current moment (The existing Y-MAX parameter is the global maximum. To have an effect Y_max_cust needs TO be < the parameter | 1.0 = FUNCTION NOT used *
	VIS2MM.tCtr_Cust1_In.Retrigger		:= FALSE;						* optional: a rising EDGE on this input signals the controller to retrigger - set W on X and force the integrator to the current Y  *
	VIS2MM.tCtr_Cust1_In.A;												* optional: feed forward Input *
		xGeACtr_1();	 *FUNCTION call*
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust1_Out.Y;			*connect actuator variable here*
	OUT_CU.tCtr_CustOut[1].Ao	:= 	OUT_CU.tCtr_Cust1_Out.Y;			*optional: direct hardware output connection with OUT_CU.tCtr_CustOut[x].Ao*
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust1_Out.Step_down;	*optional: connect actuator variable here for step controller mode*
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust1_Out.Step_up;		*optional: connect actuator variable here for step controller mode*
	
	OUT_CU.tCtr_Cust1_In		:= 	VIS2MM.tCtr_Cust1_In;				*forward controller inputs for possible use in other modules*
	OUT_CU.tCtr_Cust1_Out		:= 	MM2VIS.tCtr_Cust1_Out;				*forward controller outputs for possible use in other modules*
	Para.tCtr_Cust1;  													*stated here for watch only*

	******************************************************************************************************************************)


	(* customizable controller 1*)
	VIS2MM.tCtr_Cust1_In.enable			:= Para.bCtr_Cust1 AND TRUE;	
	VIS2MM.tCtr_Cust1_In.X				:= 0;							
	VIS2MM.tCtr_Cust1_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust1_In.W_ext_Active	:= FALSE;

	VIS2MM.tCtr_Cust1_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust1_In.GainScheduling	:= 0.0;
	VIS2MM.tCtr_Cust1_In.Y_min_cust		:= -1.0;
	VIS2MM.tCtr_Cust1_In.Y_max_cust		:= 1.0;
	VIS2MM.tCtr_Cust1_In.Retrigger		:= FALSE;
	VIS2MM.tCtr_Cust1_In.A;
						
	xGeACtr_1();	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust1_Out.Y;			
	OUT_CU.tCtr_CustOut[1].Ao	:= 	OUT_CU.tCtr_Cust1_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust1_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust1_Out.Step_up;		
	
	OUT_CU.tCtr_Cust1_In		:= 	VIS2MM.tCtr_Cust1_In;				
	OUT_CU.tCtr_Cust1_Out		:= 	MM2VIS.tCtr_Cust1_Out;				
	Para.tCtr_Cust1;  													

	(*******************************************************************************************************************************)
	(* customizable controller 2*)
	VIS2MM.tCtr_Cust2_In.enable			:= Para.bCtr_Cust2 AND TRUE;	
	VIS2MM.tCtr_Cust2_In.X				:= 0;							
	VIS2MM.tCtr_Cust2_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust2_In.W_ext_Active	:= FALSE;						
	VIS2MM.tCtr_Cust2_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust2_In.GainScheduling	:= 0.0;
	VIS2MM.tCtr_Cust2_In.Y_min_cust		:= -1.0;
	VIS2MM.tCtr_Cust2_In.Y_max_cust		:= 1.0;
	VIS2MM.tCtr_Cust2_In.Retrigger		:= FALSE;
	VIS2MM.tCtr_Cust2_In.A;

	xGeACtr_2;	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust2_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust2_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust2_Out.Step_up;		

	OUT_CU.tCtr_Cust2_In		:= 	VIS2MM.tCtr_Cust2_In;				
	OUT_CU.tCtr_Cust2_Out		:= 	MM2VIS.tCtr_Cust2_Out;				
	Para.tCtr_Cust2;  														

	(* OPTION to use CtrCust2 as boost temperature controller with humidity function JAPAN Option *)
	OUT_CU.bUseCtrCust2_4HumidityCtr	:= FALSE; (* <-- insert TRUE to use this option *)	
	OUT_CU.rCtr_Cust2_W_set				:= Para.tCtr_Cust2.W_set;
	(*******************************************************************************************************************************)
	(* customizable controller 3*)
	VIS2MM.tCtr_Cust3_In.enable			:= Para.bCtr_Cust3 AND TRUE;	
	VIS2MM.tCtr_Cust3_In.X				:= 0;							
	VIS2MM.tCtr_Cust3_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust3_In.W_ext_Active	:= FALSE;						
	VIS2MM.tCtr_Cust3_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust3_In.GainScheduling	:= 0.0;
	VIS2MM.tCtr_Cust3_In.Y_min_cust		:= -1.0;
	VIS2MM.tCtr_Cust3_In.Y_max_cust		:= 1.0;
	VIS2MM.tCtr_Cust3_In.Retrigger		:= FALSE;
	VIS2MM.tCtr_Cust3_In.A;

	xGeACtr_3;	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust3_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust3_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust3_Out.Step_up;		

	OUT_CU.tCtr_Cust3_In		:= 	VIS2MM.tCtr_Cust3_In;				
	OUT_CU.tCtr_Cust3_Out		:= 	MM2VIS.tCtr_Cust3_Out;				
	Para.tCtr_Cust3;  													

	(*******************************************************************************************************************************)
	(* customizable controller 4*)
	VIS2MM.tCtr_Cust4_In.enable			:= Para.bCtr_Cust4 AND TRUE;	
	VIS2MM.tCtr_Cust4_In.X				:= 0;							
	VIS2MM.tCtr_Cust4_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust4_In.W_ext_Active	:= FALSE;						
	VIS2MM.tCtr_Cust4_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust4_In.GainScheduling	:= 0.0;
	VIS2MM.tCtr_Cust4_In.Y_min_cust		:= -1.0;
	VIS2MM.tCtr_Cust4_In.Y_max_cust		:= 1.0;
	VIS2MM.tCtr_Cust4_In.Retrigger		:= FALSE;
	VIS2MM.tCtr_Cust4_In.A;

	xGeACtr_4;	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust4_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust4_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust4_Out.Step_up;		

	OUT_CU.tCtr_Cust4_In		:= 	VIS2MM.tCtr_Cust4_In;				
	OUT_CU.tCtr_Cust4_Out		:= 	MM2VIS.tCtr_Cust4_Out;				
	Para.tCtr_Cust4;  													

	(*******************************************************************************************************************************)
	(* customizable controller 5*)
	VIS2MM.tCtr_Cust5_In.enable			:= Para.bCtr_Cust5 AND TRUE;	
	VIS2MM.tCtr_Cust5_In.X				:= 0;							
	VIS2MM.tCtr_Cust5_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust5_In.W_ext_Active	:= FALSE;						
	VIS2MM.tCtr_Cust5_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust5_In.GainScheduling	:= 0.0;
	VIS2MM.tCtr_Cust5_In.Y_min_cust		:= -1.0;
	VIS2MM.tCtr_Cust5_In.Y_max_cust		:= 1.0;
	VIS2MM.tCtr_Cust5_In.Retrigger		:= FALSE;
	VIS2MM.tCtr_Cust5_In.A;

	xGeACtr_5;	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust5_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust5_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust5_Out.Step_up;		

	OUT_CU.tCtr_Cust5_In		:= 	VIS2MM.tCtr_Cust5_In;				
	OUT_CU.tCtr_Cust5_Out		:= 	MM2VIS.tCtr_Cust5_Out;				
	Para.tCtr_Cust5;  													

	(*******************************************************************************************************************************)
	(* customizable controller 6*)
	VIS2MM.tCtr_Cust6_In.enable			:= Para.bCtr_Cust6 AND TRUE;	
	VIS2MM.tCtr_Cust6_In.X				:= 0;							
	VIS2MM.tCtr_Cust6_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust6_In.W_ext_Active	:= FALSE;						
	VIS2MM.tCtr_Cust6_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust6_In.GainScheduling	:= 0.0;
	VIS2MM.tCtr_Cust6_In.Y_min_cust		:= -1.0;
	VIS2MM.tCtr_Cust6_In.Y_max_cust		:= 1.0;
	VIS2MM.tCtr_Cust6_In.Retrigger		:= FALSE;
	VIS2MM.tCtr_Cust6_In.A;

	xGeACtr_6;	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust6_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust6_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust6_Out.Step_up;		

	OUT_CU.tCtr_Cust6_In		:= 	VIS2MM.tCtr_Cust6_In;				
	OUT_CU.tCtr_Cust6_Out		:= 	MM2VIS.tCtr_Cust6_Out;				
	Para.tCtr_Cust6;  													

	(*******************************************************************************************************************************)
	(* customizable controller 7*)
	VIS2MM.tCtr_Cust7_In.enable			:= Para.bCtr_Cust7 AND TRUE;	
	VIS2MM.tCtr_Cust7_In.X				:= 0;							
	VIS2MM.tCtr_Cust7_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust7_In.W_ext_Active	:= FALSE;						
	VIS2MM.tCtr_Cust7_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust7_In.GainScheduling	:= 0.0;
	VIS2MM.tCtr_Cust7_In.Y_min_cust		:= -1.0;
	VIS2MM.tCtr_Cust7_In.Y_max_cust		:= 1.0;
	VIS2MM.tCtr_Cust7_In.Retrigger		:= FALSE;
	VIS2MM.tCtr_Cust7_In.A;

	xGeACtr_7;	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust7_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust7_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust7_Out.Step_up;		

	OUT_CU.tCtr_Cust7_In		:= 	VIS2MM.tCtr_Cust7_In;				
	OUT_CU.tCtr_Cust7_Out		:= 	MM2VIS.tCtr_Cust7_Out;				
	Para.tCtr_Cust7;  													

	(*******************************************************************************************************************************)
	(* customizable controller 8*)
	VIS2MM.tCtr_Cust8_In.enable			:= Para.bCtr_Cust8 AND TRUE;	
	VIS2MM.tCtr_Cust8_In.X				:= 0;							
	VIS2MM.tCtr_Cust8_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust8_In.W_ext_Active	:= FALSE;						
	VIS2MM.tCtr_Cust8_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust8_In.GainScheduling	:= 0.0;
	VIS2MM.tCtr_Cust8_In.Y_min_cust		:= -1.0;
	VIS2MM.tCtr_Cust8_In.Y_max_cust		:= 1.0;
	VIS2MM.tCtr_Cust8_In.Retrigger		:= FALSE;
	VIS2MM.tCtr_Cust8_In.A;

	xGeACtr_8;	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust8_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust8_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust8_Out.Step_up;		

	OUT_CU.tCtr_Cust8_In		:= 	VIS2MM.tCtr_Cust8_In;				
	OUT_CU.tCtr_Cust8_Out		:= 	MM2VIS.tCtr_Cust8_Out;				
	Para.tCtr_Cust8;  													

	(*******************************************************************************************************************************)
	(* customizable controller 41*)		(* extended controller items 41-45 ONLY FOR USE WITH HMI Extension Package!*)
	VIS2MM.tCtr_Cust41_In.enable		:= Para.bCtr_Cust41 AND TRUE;	
	VIS2MM.tCtr_Cust41_In.X				:= 0;							
	VIS2MM.tCtr_Cust41_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust41_In.W_ext_Active	:= FALSE;						
	VIS2MM.tCtr_Cust41_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust41_In.GainScheduling:= 0.0;
	VIS2MM.tCtr_Cust41_In.Y_min_cust	:= -1.0;
	VIS2MM.tCtr_Cust41_In.Y_max_cust	:= 1.0;
	VIS2MM.tCtr_Cust41_In.Retrigger		:= FALSE;
	VIS2MM.tCtr_Cust41_In.A;

	xGeACtr_41;	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust41_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust41_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust41_Out.Step_up;		

	OUT_CU.tCtr_Cust41_In		:= 	VIS2MM.tCtr_Cust41_In;				
	OUT_CU.tCtr_Cust41_Out		:= 	MM2VIS.tCtr_Cust41_Out;				
	Para.tCtr_Cust41;  
	
	(*******************************************************************************************************************************)
	(* customizable controller 42*)
	VIS2MM.tCtr_Cust42_In.enable		:= Para.bCtr_Cust42 AND TRUE;	
	VIS2MM.tCtr_Cust42_In.X				:= 0;							
	VIS2MM.tCtr_Cust42_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust42_In.W_ext_Active	:= FALSE;						
	VIS2MM.tCtr_Cust42_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust42_In.GainScheduling:= 0.0;
	VIS2MM.tCtr_Cust42_In.Y_min_cust	:= -1.0;
	VIS2MM.tCtr_Cust42_In.Y_max_cust	:= 1.0;
	VIS2MM.tCtr_Cust42_In.Retrigger		:= FALSE;
	VIS2MM.tCtr_Cust42_In.A;

	xGeACtr_42;	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust42_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust42_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust42_Out.Step_up;		

	OUT_CU.tCtr_Cust42_In		:= 	VIS2MM.tCtr_Cust42_In;				
	OUT_CU.tCtr_Cust42_Out		:= 	MM2VIS.tCtr_Cust42_Out;				
	Para.tCtr_Cust42;  
	
	(*******************************************************************************************************************************)
	(* customizable controller 43*)
	VIS2MM.tCtr_Cust43_In.enable		:= Para.bCtr_Cust43 AND TRUE;	
	VIS2MM.tCtr_Cust43_In.X				:= 0;							
	VIS2MM.tCtr_Cust43_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust43_In.W_ext_Active	:= FALSE;						
	VIS2MM.tCtr_Cust43_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust43_In.GainScheduling:= 0.0;
	VIS2MM.tCtr_Cust43_In.Y_min_cust	:= -1.0;
	VIS2MM.tCtr_Cust43_In.Y_max_cust	:= 1.0;
	VIS2MM.tCtr_Cust43_In.Retrigger		:= FALSE;
	VIS2MM.tCtr_Cust43_In.A;

	xGeACtr_43;	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust43_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust43_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust43_Out.Step_up;		

	OUT_CU.tCtr_Cust43_In		:= 	VIS2MM.tCtr_Cust43_In;				
	OUT_CU.tCtr_Cust43_Out		:= 	MM2VIS.tCtr_Cust43_Out;				
	Para.tCtr_Cust43;  
	
	(*******************************************************************************************************************************)
	(* customizable controller 44*)
	VIS2MM.tCtr_Cust44_In.enable		:= Para.bCtr_Cust44 AND TRUE;	
	VIS2MM.tCtr_Cust44_In.X				:= 0;							
	VIS2MM.tCtr_Cust44_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust44_In.W_ext_Active	:= FALSE;						
	VIS2MM.tCtr_Cust44_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust44_In.GainScheduling:= 0.0;
	VIS2MM.tCtr_Cust44_In.Y_min_cust	:= -1.0;
	VIS2MM.tCtr_Cust44_In.Y_max_cust	:= 1.0;
	VIS2MM.tCtr_Cust44_In.Retrigger		:= FALSE;
	VIS2MM.tCtr_Cust44_In.A;

	xGeACtr_44;	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust44_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust44_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust44_Out.Step_up;		

	OUT_CU.tCtr_Cust44_In		:= 	VIS2MM.tCtr_Cust44_In;				
	OUT_CU.tCtr_Cust44_Out		:= 	MM2VIS.tCtr_Cust44_Out;				
	Para.tCtr_Cust44;  
	
	(*******************************************************************************************************************************)
	(* customizable controller 45*)
	VIS2MM.tCtr_Cust45_In.enable		:= Para.bCtr_Cust45 AND TRUE;	
	VIS2MM.tCtr_Cust45_In.X				:= 0;							
	VIS2MM.tCtr_Cust45_In.W_ext			:= 0;							
	VIS2MM.tCtr_Cust45_In.W_ext_Active	:= FALSE;						
	VIS2MM.tCtr_Cust45_In.W_set2_Active	:= FALSE;
	VIS2MM.tCtr_Cust45_In.GainScheduling:= 0.0;
	VIS2MM.tCtr_Cust45_In.Y_min_cust	:= -1.0;
	VIS2MM.tCtr_Cust45_In.Y_max_cust	:= 1.0;
	VIS2MM.tCtr_Cust45_In.A;

	xGeACtr_45;	(*function call*)
	rReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust45_Out.Y;			
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust45_Out.Step_down;	
	bReplaceMeWithVarname		:= 	OUT_CU.tCtr_Cust45_Out.Step_up;		

	OUT_CU.tCtr_Cust45_In		:= 	VIS2MM.tCtr_Cust45_In;				
	OUT_CU.tCtr_Cust45_Out		:= 	MM2VIS.tCtr_Cust45_Out;				
	Para.tCtr_Cust45;  
	

END_PROGRAM
