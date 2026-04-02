(*******************************************************************************
CUSTOMIZED: c_ctr 		reserve controller handling (init)

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
V4.11	27.01.2022	Perktold	impemented plant controller upgrade (AlwaysUseYRamp, KeepYManAtBlock both signals Std. TRUE)
		
Instructions for use:
--------------------
-
Outstandings:
------------
-

*******************************************************************************)

PROGRAM _INIT

	
	(*Parameter FACTORY DEFAULT VALUES *)
	(*for missing/new/not visualized parameter*)
	ParaFactoryDefault.tCtr_Cust1.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust1.t_min_pulse_up :=		10;
	ParaFactoryDefault.tCtr_Cust1.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust1.t_period_up :=		100;
	
	(*REG2*)
	ParaFactoryDefault.tCtr_Cust2.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust2.t_min_pulse_up :=		10;
	ParaFactoryDefault.tCtr_Cust2.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust2.t_period_up :=		100;
	
	(*REG3*)
	ParaFactoryDefault.tCtr_Cust3.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust3.t_min_pulse_up :=		10;
	ParaFactoryDefault.tCtr_Cust3.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust3.t_period_up :=		100;
	
	(*REG4*)
	ParaFactoryDefault.tCtr_Cust4.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust4.t_min_pulse_up :=		10;
	ParaFactoryDefault.tCtr_Cust4.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust4.t_period_up :=		100;
	
	(*REG5*)
	ParaFactoryDefault.tCtr_Cust5.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust5.t_min_pulse_up :=		10;
	ParaFactoryDefault.tCtr_Cust5.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust5.t_period_up :=		100;
	
	(*REG6*)
	ParaFactoryDefault.tCtr_Cust6.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust6.t_min_pulse_up :=		10;
	ParaFactoryDefault.tCtr_Cust6.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust6.t_period_up :=		100;
	
	(*REG7*)
	ParaFactoryDefault.tCtr_Cust7.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust7.t_min_pulse_up :=		10;
	ParaFactoryDefault.tCtr_Cust7.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust7.t_period_up :=		100;
	
	(*REG8*)
	ParaFactoryDefault.tCtr_Cust8.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust8.t_min_pulse_up :=		10;
	ParaFactoryDefault.tCtr_Cust8.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust8.t_period_up :=		100;
	
	(*REG41*)
	ParaFactoryDefault.tCtr_Cust41.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust41.t_min_pulse_up :=	10;
	ParaFactoryDefault.tCtr_Cust41.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust41.t_period_up :=		100;
	
	(*REG42*)
	ParaFactoryDefault.tCtr_Cust42.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust42.t_min_pulse_up :=	10;
	ParaFactoryDefault.tCtr_Cust42.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust42.t_period_up :=		100;
	
	(*REG43*)
	ParaFactoryDefault.tCtr_Cust43.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust43.t_min_pulse_up :=	10;
	ParaFactoryDefault.tCtr_Cust43.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust43.t_period_up :=		100;
	
	(*REG44*)
	ParaFactoryDefault.tCtr_Cust44.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust44.t_min_pulse_up :=	10;
	ParaFactoryDefault.tCtr_Cust44.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust44.t_period_up :=		100;
	
	(*REG45*)
	ParaFactoryDefault.tCtr_Cust45.t_min_pulse_down :=	10;
	ParaFactoryDefault.tCtr_Cust45.t_min_pulse_up :=	10;
	ParaFactoryDefault.tCtr_Cust45.t_period_down :=		100;
	ParaFactoryDefault.tCtr_Cust45.t_period_up :=		100;
	
	(*avoid status 12033 error*)
	IF Para.tCtr_Cust1.t_period_up = 0 		THEN Para.tCtr_Cust1.t_period_up := 100; 	END_IF	(*avoid status 12033 error*)
	IF Para.tCtr_Cust1.t_period_down = 0 	THEN Para.tCtr_Cust1.t_period_down := 100; 	END_IF
	IF Para.tCtr_Cust2.t_period_up = 0 		THEN Para.tCtr_Cust2.t_period_up := 100; 	END_IF
	IF Para.tCtr_Cust2.t_period_down = 0 	THEN Para.tCtr_Cust2.t_period_down := 100; 	END_IF
	IF Para.tCtr_Cust3.t_period_up = 0 		THEN Para.tCtr_Cust3.t_period_up := 100; 	END_IF
	IF Para.tCtr_Cust3.t_period_down = 0 	THEN Para.tCtr_Cust3.t_period_down := 100; 	END_IF
	IF Para.tCtr_Cust4.t_period_up = 0 		THEN Para.tCtr_Cust4.t_period_up := 100; 	END_IF
	IF Para.tCtr_Cust4.t_period_down = 0 	THEN Para.tCtr_Cust4.t_period_down := 100; 	END_IF
	IF Para.tCtr_Cust5.t_period_up = 0 		THEN Para.tCtr_Cust5.t_period_up := 100; 	END_IF
	IF Para.tCtr_Cust5.t_period_down = 0 	THEN Para.tCtr_Cust5.t_period_down := 100; 	END_IF
	IF Para.tCtr_Cust6.t_period_up = 0 		THEN Para.tCtr_Cust6.t_period_up := 100; 	END_IF
	IF Para.tCtr_Cust6.t_period_down = 0 	THEN Para.tCtr_Cust6.t_period_down := 100; 	END_IF
	IF Para.tCtr_Cust7.t_period_up = 0 		THEN Para.tCtr_Cust7.t_period_up := 100; 	END_IF
	IF Para.tCtr_Cust7.t_period_down = 0 	THEN Para.tCtr_Cust7.t_period_down := 100; 	END_IF
	IF Para.tCtr_Cust8.t_period_up = 0 		THEN Para.tCtr_Cust8.t_period_up := 100; 	END_IF
	IF Para.tCtr_Cust8.t_period_down = 0 	THEN Para.tCtr_Cust8.t_period_down := 100; 	END_IF	
	
	IF Para.tCtr_Cust41.t_period_up = 0 	THEN Para.tCtr_Cust41.t_period_up := 100; 	END_IF
	IF Para.tCtr_Cust41.t_period_down = 0 	THEN Para.tCtr_Cust41.t_period_down := 100;	END_IF	
	IF Para.tCtr_Cust42.t_period_up = 0 	THEN Para.tCtr_Cust42.t_period_up := 100; 	END_IF
	IF Para.tCtr_Cust42.t_period_down = 0 	THEN Para.tCtr_Cust42.t_period_down := 100; END_IF	
	IF Para.tCtr_Cust43.t_period_up = 0 	THEN Para.tCtr_Cust43.t_period_up := 100; 	END_IF
	IF Para.tCtr_Cust43.t_period_down = 0 	THEN Para.tCtr_Cust43.t_period_down := 100; END_IF	
	IF Para.tCtr_Cust44.t_period_up = 0 	THEN Para.tCtr_Cust44.t_period_up := 100; 	END_IF
	IF Para.tCtr_Cust44.t_period_down = 0 	THEN Para.tCtr_Cust44.t_period_down := 100; END_IF	
	IF Para.tCtr_Cust45.t_period_up = 0 	THEN Para.tCtr_Cust45.t_period_up := 100; 	END_IF
	IF Para.tCtr_Cust45.t_period_down = 0 	THEN Para.tCtr_Cust45.t_period_down := 100; END_IF	
	
	VIS2MM.tCtr_Cust1_In.AlwaysUseYRamp		:= TRUE;	(*If TRUE the Y signal will always limit the change rate via the according parameter | if FALSE the Y signal will jump in case the controller is disabled (blocked or set)*)
	VIS2MM.tCtr_Cust1_In.KeepYManAtBlock	:= TRUE;	(*If TRUE the controller will keep the Y-man value constant in case the controller is disabled (blocked or set) | If FALSE the blocked or set value will override the Y-man value*)
	VIS2MM.tCtr_Cust1_In.Y_min_cust			:= -1.0;	(*"customized" Y-Min at the current moment (The existing Y-Min parameter is the global minimum. To have an effect Y_min_cust needs to be > the parameter | -1.0 = function not used*)
	VIS2MM.tCtr_Cust1_In.Y_max_cust			:=  1.0;	(*"customized" Y-Max at the current moment (The existing Y-Max parameter is the global maximum. To have an effect Y_max_cust needs to be < the parameter | 1.0 = function not used*)
	VIS2MM.tCtr_Cust1_In.StepperMode		:= FALSE;	(* TRUE = use PWM-Mode (standard mode until 4.10) | FALSE = use continuous servo drive *)
	VIS2MM.tCtr_Cust2_In.AlwaysUseYRamp		:= TRUE;
	VIS2MM.tCtr_Cust2_In.KeepYManAtBlock	:= TRUE;
	VIS2MM.tCtr_Cust2_In.Y_min_cust			:= -1.0;
	VIS2MM.tCtr_Cust2_In.Y_max_cust			:=  1.0;
	VIS2MM.tCtr_Cust2_In.StepperMode		:= FALSE;
	VIS2MM.tCtr_Cust3_In.AlwaysUseYRamp		:= TRUE;
	VIS2MM.tCtr_Cust3_In.KeepYManAtBlock	:= TRUE;
	VIS2MM.tCtr_Cust3_In.Y_min_cust			:= -1.0;
	VIS2MM.tCtr_Cust3_In.Y_max_cust			:=  1.0;
	VIS2MM.tCtr_Cust3_In.StepperMode		:= FALSE;
	VIS2MM.tCtr_Cust4_In.AlwaysUseYRamp		:= TRUE;
	VIS2MM.tCtr_Cust4_In.KeepYManAtBlock	:= TRUE;
	VIS2MM.tCtr_Cust4_In.Y_min_cust			:= -1.0;
	VIS2MM.tCtr_Cust4_In.Y_max_cust			:=  1.0;
	VIS2MM.tCtr_Cust4_In.StepperMode		:= FALSE;

	VIS2MM.tCtr_Cust5_In.AlwaysUseYRamp		:= TRUE;
	VIS2MM.tCtr_Cust5_In.KeepYManAtBlock	:= TRUE;
	VIS2MM.tCtr_Cust5_In.Y_min_cust			:= -1.0;
	VIS2MM.tCtr_Cust5_In.Y_max_cust			:=  1.0;
	VIS2MM.tCtr_Cust5_In.StepperMode		:= FALSE;
	VIS2MM.tCtr_Cust6_In.AlwaysUseYRamp		:= TRUE;
	VIS2MM.tCtr_Cust6_In.KeepYManAtBlock	:= TRUE;
	VIS2MM.tCtr_Cust6_In.Y_min_cust			:= -1.0;
	VIS2MM.tCtr_Cust6_In.Y_max_cust			:=  1.0;
	VIS2MM.tCtr_Cust6_In.StepperMode		:= FALSE;
	VIS2MM.tCtr_Cust7_In.AlwaysUseYRamp		:= TRUE;
	VIS2MM.tCtr_Cust7_In.KeepYManAtBlock	:= TRUE;
	VIS2MM.tCtr_Cust7_In.Y_min_cust			:= -1.0;
	VIS2MM.tCtr_Cust7_In.Y_max_cust			:=  1.0;
	VIS2MM.tCtr_Cust7_In.StepperMode		:= FALSE;
	VIS2MM.tCtr_Cust8_In.AlwaysUseYRamp		:= TRUE;
	VIS2MM.tCtr_Cust8_In.KeepYManAtBlock	:= TRUE;
	VIS2MM.tCtr_Cust8_In.Y_min_cust			:= -1.0;
	VIS2MM.tCtr_Cust8_In.Y_max_cust			:=  1.0;
	VIS2MM.tCtr_Cust8_In.StepperMode		:= FALSE;

	VIS2MM.tCtr_Cust41_In.AlwaysUseYRamp	:= TRUE;
	VIS2MM.tCtr_Cust41_In.KeepYManAtBlock	:= TRUE;
	VIS2MM.tCtr_Cust41_In.Y_min_cust		:= -1.0;
	VIS2MM.tCtr_Cust41_In.Y_max_cust		:=  1.0;
	VIS2MM.tCtr_Cust41_In.StepperMode		:= FALSE;
	VIS2MM.tCtr_Cust42_In.AlwaysUseYRamp	:= TRUE;
	VIS2MM.tCtr_Cust42_In.KeepYManAtBlock	:= TRUE;
	VIS2MM.tCtr_Cust42_In.Y_min_cust		:= -1.0;
	VIS2MM.tCtr_Cust42_In.Y_max_cust		:=  1.0;
	VIS2MM.tCtr_Cust42_In.StepperMode		:= FALSE;
	VIS2MM.tCtr_Cust43_In.AlwaysUseYRamp	:= TRUE;
	VIS2MM.tCtr_Cust43_In.KeepYManAtBlock	:= TRUE;
	VIS2MM.tCtr_Cust43_In.Y_min_cust		:= -1.0;
	VIS2MM.tCtr_Cust43_In.Y_max_cust		:=  1.0;
	VIS2MM.tCtr_Cust43_In.StepperMode		:= FALSE;
	VIS2MM.tCtr_Cust44_In.AlwaysUseYRamp	:= TRUE;
	VIS2MM.tCtr_Cust44_In.KeepYManAtBlock	:= TRUE;
	VIS2MM.tCtr_Cust44_In.Y_min_cust		:= -1.0;
	VIS2MM.tCtr_Cust44_In.Y_max_cust		:=  1.0;
	VIS2MM.tCtr_Cust44_In.StepperMode		:= FALSE;

(* configure and asign structures for customizable controllers *) 

	(* configure and asign structures for customizable controllers *)
	xGeACtr_1(pParameter := ADR(Para.tCtr_Cust1), pInput := ADR(VIS2MM.tCtr_Cust1_In), pOutput := ADR(MM2VIS.tCtr_Cust1_Out));
	xGeACtr_2(pParameter := ADR(Para.tCtr_Cust2), pInput := ADR(VIS2MM.tCtr_Cust2_In), pOutput := ADR(MM2VIS.tCtr_Cust2_Out));
	xGeACtr_3(pParameter := ADR(Para.tCtr_Cust3), pInput := ADR(VIS2MM.tCtr_Cust3_In), pOutput := ADR(MM2VIS.tCtr_Cust3_Out));
	xGeACtr_4(pParameter := ADR(Para.tCtr_Cust4), pInput := ADR(VIS2MM.tCtr_Cust4_In), pOutput := ADR(MM2VIS.tCtr_Cust4_Out));

	xGeACtr_5(pParameter := ADR(Para.tCtr_Cust5), pInput := ADR(VIS2MM.tCtr_Cust5_In), pOutput := ADR(MM2VIS.tCtr_Cust5_Out));
	xGeACtr_6(pParameter := ADR(Para.tCtr_Cust6), pInput := ADR(VIS2MM.tCtr_Cust6_In), pOutput := ADR(MM2VIS.tCtr_Cust6_Out));
	xGeACtr_7(pParameter := ADR(Para.tCtr_Cust7), pInput := ADR(VIS2MM.tCtr_Cust7_In), pOutput := ADR(MM2VIS.tCtr_Cust7_Out));
	xGeACtr_8(pParameter := ADR(Para.tCtr_Cust8), pInput := ADR(VIS2MM.tCtr_Cust8_In), pOutput := ADR(MM2VIS.tCtr_Cust8_Out));
	
	xGeACtr_41(pParameter := ADR(Para.tCtr_Cust41), pInput := ADR(VIS2MM.tCtr_Cust41_In), pOutput := ADR(MM2VIS.tCtr_Cust41_Out));
	xGeACtr_42(pParameter := ADR(Para.tCtr_Cust42), pInput := ADR(VIS2MM.tCtr_Cust42_In), pOutput := ADR(MM2VIS.tCtr_Cust42_Out));
	xGeACtr_43(pParameter := ADR(Para.tCtr_Cust43), pInput := ADR(VIS2MM.tCtr_Cust43_In), pOutput := ADR(MM2VIS.tCtr_Cust43_Out));
	xGeACtr_44(pParameter := ADR(Para.tCtr_Cust44), pInput := ADR(VIS2MM.tCtr_Cust44_In), pOutput := ADR(MM2VIS.tCtr_Cust44_Out));
	xGeACtr_45(pParameter := ADR(Para.tCtr_Cust45), pInput := ADR(VIS2MM.tCtr_Cust45_In), pOutput := ADR(MM2VIS.tCtr_Cust45_Out));
	


END_PROGRAM

