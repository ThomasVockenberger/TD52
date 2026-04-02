(*********************************************************************************************
AGGR: static GridCode - custom task (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

- customized modification for generator protection

Customized modifications: -
------------------------
 
History:
-------
V4.09.0 28.11.2019	lettenb.  partly moved from task c_statGR for cycle time optimizing	

Instructions for use:
--------------------
- 
Outstandings:
-------------
*********************************************************************************************)

PROGRAM _CYCLIC


	(********************************************************************************************)
	(************************* protection test **************************************************)
	(********************************************************************************************)
    (* Protection Test 1 *)
    OUT_CU.tProtectionTest[1].Do := NOT   ((IN_CU.bMsg2801Set AND 	  IN_CU.bMMD_BB_AlarmTestOn)
										OR (IN_CU.bMsg1038Set AND NOT IN_CU.bMMD_BB_AlarmTestOn)
										OR (IN_CU.bMsg1143Set AND NOT IN_CU.bMMD_BB_AlarmTestOn)
										OR (IN_CU.bMsg1144Set AND NOT IN_CU.bMMD_BB_AlarmTestOn));

    (* Protection Test 2 *)
	OUT_CU.tProtectionTest[2].Do := NOT    (IN_CU.bMsg1109Set
	 									OR 	IN_CU.bMsg1110Set
										OR  IN_CU.bMsg1111Set
										OR  IN_CU.bMsg1126Set
										OR  IN_CU.bMsg1127Set
										OR  IN_CU.bMsg2277Set
										OR  IN_CU.bMsg2316Set);

	(* Protection Test 3 *)
	OUT_CU.tProtectionTest[3].Do := NOT   ((IN_CU.bMsg2934Set AND 	  IN_CU.bMMD_BB_AlarmTestOn)
										OR (IN_CU.bMsg1041Set AND NOT IN_CU.bMMD_BB_AlarmTestOn)
										OR (IN_CU.bMsg1042Set AND NOT IN_CU.bMMD_BB_AlarmTestOn)
										OR (IN_CU.bMsg1112Set AND NOT IN_CU.bMMD_BB_AlarmTestOn));

	(* block OUT_OP.tRel_Sync_Load.Do *)
	xTOF_Bloc_SY_ProtTest(IN:= NOT OUT_CU.tProtectionTest[1].Do OR NOT OUT_CU.tProtectionTest[2].Do OR NOT OUT_CU.tProtectionTest[3].Do, PT := T#1s);
	OUT_CU.bBloc_SY_ProtTest := xTOF_Bloc_SY_ProtTest.Q;



END_PROGRAM
