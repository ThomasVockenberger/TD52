(*******************************************************************************
CUSTOMIZED: c_dig.st - connection and processing of prepared digital I /O channels (cyclic)

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019     



Customized modifications: 
------------------------
 
History:
-------
V3.90	13.12.2012 Zengerer	NEW 
...
V4.02.0 24.06.2015 Zengerer 	cleanup
V4.03.0	18.12.2015 Zengerer 	Bugfix Version for missing VIS parameter: Set all DigOut as active
		09.05.2016 lettenb.		Para.bCustDigOut_Active[x] entfernt, weil nicht in visu ausgeführt
		03.06.2016 lettenb.		IN_CU.tCustDigIn[41-60].Di removed (doppelt codiert)
V4.04.0	16.06.2016 Weitzer		add CustDigIn[81..200]
V4.07.0 19.12.2018 Zengerer		add IN_CU.tCustDigIn_TC2[] with TaskClass2 .vvm
							 
Instructions for use:
--------------------
- connect (or replace) <bConnectYourBitHere> with plant specific variables
- mark used channels here, to avoid duplicate usage withhin one customer project

AVOID HARDCODED Para.xxx VALUES!
You MAYBE want to enter SOME factory default values in the INIT section, but ONLY TO THE Para_FactoryDefault.xxx STRUCTURE!
By this way the parameter values in Para.xxx would stay acessible according to XT4 parameter management process.

  
Outstandings:
------------


*********************************************************************************)

PROGRAM _CYCLIC

	(*********************************************************************************************************************************)



	(********************************************************)
	(*                                                      *)
	(*                 DIGITAL INPUT SECTION                *)
	(*                                                      *)
	(********************************************************)

//	(* Reservedigitaleingang x *)									(* (KONFIGURATIONSBEISPIEL)*)
//	(* reserve digital input x *)									(* (CONFIGURATION EXAMPLE) *)
//	(***************************)
//	bConnectYourBitHere		:= IN_CU.tCustDigIn[x].Di;		(*Anpassen entsprechend Kundenanforderung*)	 			(* change 'bConnectYourBitHere' customized *)
//							   IN_CU.tCustDigIn_TC2[x].Di; 	(*reminder: for fast counter inputs in TC#2 tasks use IN_CU.tCustDigIn_TC2[] directly!   *)
//	OUT_CU.bCustDigIn[x]	:= IN_CU.tCustDigIn[x].Di;		(*Vorbereitete OUT- Modulschnittst. (braucht .vvm)*)	(* modul OUT interface is prepared for possible usage of this input value in other modules	(edit other module´s .vvm, if necessary)*)
//	MM2VIS.bCustDigIn[x]	:= IN_CU.tCustDigIn[x].Di;		(*Dies Variabele iat für die VIS Verwendung vorber.*)	(* prepared for VIS	usage *)

	(* reserve digital input 1 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[1].Di;
							   IN_CU.tCustDigIn_TC2[1].Di; 	(*reminder: for fast counter inputs in TC#2 tasks use IN_CU.tCustDigIn_TC2[] directly!  (V4.07) *)
	OUT_CU.bCustDigIn[1]	:= IN_CU.tCustDigIn[1].Di;		(*stated here only once as reminder, processing is done in loop*)		
	MM2VIS.bCustDigIn[1]	:= IN_CU.tCustDigIn[1].Di;		(*stated here only once as reminder, processing is done in loop*)	
	(* reserve digital input 2 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[2].Di;
	(* reserve digital input 3 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[3].Di;
	(* reserve digital input 4 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[4].Di;

	(* reserve digital input 5 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[5].Di;
	(* reserve digital input 6 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[6].Di;
	(* reserve digital input 7 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[7].Di;
	(* reserve digital input 8 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[8].Di;

	(* reserve digital input 9 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[9].Di;
	(* reserve digital input 10 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[10].Di;
	(* reserve digital input 11 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[11].Di;
	(* reserve digital input 12 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[12].Di;

	(* reserve digital input 13 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[13].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[14].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[15].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[16].Di;

	(* reserve digital input 17 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[17].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[18].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[19].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[20].Di;

	(* reserve digital input 21 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[21].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[22].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[23].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[24].Di;


	(* reserve digital input 25 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[25].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[26].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[27].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[28].Di;

	(* reserve digital input 29 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[29].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[30].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[31].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[32].Di;

	(* reserve digital input 33 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[33].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[34].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[35].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[36].Di;


	(* reserve digital input 37 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[37].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[38].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[39].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[40].Di;

	(* reserve digital input 41 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[41].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[42].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[43].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[44].Di;

	(* reserve digital input 45 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[45].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[46].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[47].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[48].Di;


	(* reserve digital input 49 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[49].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[50].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[51].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[52].Di;

	(* reserve digital input 53 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[53].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[54].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[55].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[56].Di;

	(* reserve digital input 57 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[57].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[58].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[59].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[60].Di;

	(* reserve digital input 61 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[61].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[62].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[63].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[64].Di;


	(* reserve digital input 65 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[65].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[66].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[67].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[68].Di;

	(* reserve digital input 69 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[69].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[70].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[71].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[72].Di;

	(* reserve digital input 73 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[73].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[74].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[75].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[76].Di;

	(* reserve digital input 77 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[77].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[78].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[79].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[80].Di;
	
	(* reserve digital input 81 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[81].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[82].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[83].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[84].Di;

	(* reserve digital input 85 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[85].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[86].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[87].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[88].Di;
	
	(* reserve digital input 89 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[89].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[90].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[91].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[92].Di;
	
	(* reserve digital input 93 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[93].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[94].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[95].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[96].Di;
	
	(* reserve digital input 97 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[97].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[98].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[99].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[100].Di;
	
	(* reserve digital input 101 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[101].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[102].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[103].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[104].Di;
	
	(* reserve digital input 105 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[105].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[106].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[107].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[108].Di;
	
	(* reserve digital input 109 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[109].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[110].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[111].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[112].Di;
	
	(* reserve digital input 113 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[113].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[114].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[115].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[116].Di;
	
	(* reserve digital input 117 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[117].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[118].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[119].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[120].Di;
	
	(* reserve digital input 121 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[121].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[122].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[123].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[124].Di;
	
	(* reserve digital input 125 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[125].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[126].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[127].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[128].Di;
	
	(* reserve digital input 129 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[129].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[130].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[131].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[132].Di;
	
	(* reserve digital input 133 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[133].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[134].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[135].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[136].Di;
	
	(* reserve digital input 137 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[137].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[138].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[139].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[140].Di;
	
	(* reserve digital input 141 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[141].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[142].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[143].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[144].Di;
	
	(* reserve digital input 145 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[145].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[146].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[147].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[148].Di;
	
	(* reserve digital input 149 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[149].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[150].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[151].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[152].Di;
	
	(* reserve digital input 153 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[153].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[154].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[155].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[156].Di;
	
	(* reserve digital input 157 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[157].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[158].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[159].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[160].Di;
	
	(* reserve digital input 161 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[161].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[162].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[163].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[164].Di;
	
	(* reserve digital input 165 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[165].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[166].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[167].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[168].Di;
	
	(* reserve digital input 169 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[169].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[170].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[171].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[172].Di;
	
	(* reserve digital input 173 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[173].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[174].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[175].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[176].Di;
	
	(* reserve digital input 177 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[177].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[178].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[179].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[180].Di;
	
	(* reserve digital input 181 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[181].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[182].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[183].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[184].Di;
	
	(* reserve digital input 185 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[185].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[186].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[187].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[188].Di;
	
	(* reserve digital input 189 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[189].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[190].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[191].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[192].Di;
	
	(* reserve digital input 193 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[193].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[194].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[195].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[196].Di;
	
	(* reserve digital input 197 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[197].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[198].Di;
	bConnectYourBitHere		:= IN_CU.tCustDigIn[199].Di;
	
	(* reserve digital input 200 *)
	bConnectYourBitHere		:= IN_CU.tCustDigIn[200].Di;
	OUT_CU.bCustDigIn[200]	:= IN_CU.tCustDigIn[200].Di;												(*stated here as array size check only*)
	MM2VIS.bCustDigIn[200]	:= IN_CU.tCustDigIn[200].Di;												(*stated here as array size check only*)



	(*********************************************************************************************************************************)



//VORSCHLAG NEU:
	(********************************************************)
	(*                                                      *)
	(*                DIGITAL OUTPUT SECTION                *)
	(*                                                      *)
	(********************************************************)												bConnectYourBitHere		:= NOT bDigOut_Release_Default; 	(*please keep this line unchanged for debugging purpose. This keeps DO´s shut off per default*)


//	(* Reservedigitalausgang x *)								(* (KONFIGURATIONSBEISPIEL) *)
//	(* reserve digital output X *)								(* (CONFIGURATION EXAMPLE)  *)
//	(***************************)
//	OUT_CU.tCustDigOut[x].Do :=								   NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;	(*Anpassen entsprechend Kundenanforderung*)			(* change customized *)
//																 		|					+-------------------(*hier eigene Variable einsetzen*)					(* change 'bConnectYourBitHere' customized *)
//																		+---------------------------------------(*hier NOT AUS bzw. Abstellung nicht vergessen*)	(* change E-Stop or alarm stop condition customized *)
//											
//																							+-------------------(*Möglichkeit zur Anbindung Handbedienbene mit IN_CU.tManAuxCtr.bAuxCust[x] *)	(* change customized *)
//	MM2VIS.bCustDigOut[x]	:= OUT_CU.tCustDigOut[x].Do;														(*Dies Variabele iat für VIS Verwendung vorber.*)	(* change 'bConnectYourBitHere' customized *)


	(* reserve digital output 1 *)
	OUT_CU.tCustDigOut[1].Do :=		NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;	
	(* reserve digital output 2 *)
	OUT_CU.tCustDigOut[2].Do :=		NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	(* reserve digital output 3 *)
//	OUT_CU.tCustDigOut[3].Do :=		NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
	(* reserve digital output 4 *)
	OUT_CU.tCustDigOut[4].Do :=		NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;



	(* reserve digital output 5 *)
	OUT_CU.tCustDigOut[5].Do :=		NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;	
	(* reserve digital output 6 *)
//	OUT_CU.tCustDigOut[6].Do :=		NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
	(* reserve digital output 7 *)
	OUT_CU.tCustDigOut[7].Do :=		NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	(* reserve digital output 8 *)
	OUT_CU.tCustDigOut[8].Do :=		NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;


	(* reserve digital output 9 *)
	OUT_CU.tCustDigOut[9].Do :=		NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[10].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[11].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[12].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;

	(* reserve digital output 13 *)
	OUT_CU.tCustDigOut[13].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[14].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[15].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
//	OUT_CU.tCustDigOut[16].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)

	(* reserve digital output 17 *)
//	OUT_CU.tCustDigOut[17].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[18].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[19].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[20].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)

	(* reserve digital output 21 *)
//	OUT_CU.tCustDigOut[21].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[22].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[23].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
	OUT_CU.tCustDigOut[24].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;

	(* reserve digital output 25 *)
	OUT_CU.tCustDigOut[25].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
//	OUT_CU.tCustDigOut[26].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[27].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[28].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)

	(* reserve digital output 31 *)
//	OUT_CU.tCustDigOut[29].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[30].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
	OUT_CU.tCustDigOut[31].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[32].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;

	(* reserve digital output 33 *)
	OUT_CU.tCustDigOut[33].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[34].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
//	OUT_CU.tCustDigOut[35].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[36].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)

	(* reserve digital output 37 *)
//	OUT_CU.tCustDigOut[37].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[38].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[39].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[40].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)

	(* reserve digital output 41 *)
//	OUT_CU.tCustDigOut[41].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[42].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[43].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[44].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)

	(* reserve digital output 45 *)
//	OUT_CU.tCustDigOut[45].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[46].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
	OUT_CU.tCustDigOut[47].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
//	OUT_CU.tCustDigOut[48].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)

	(* reserve digital output 49 *)
//	OUT_CU.tCustDigOut[49].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
//	OUT_CU.tCustDigOut[50].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 	(*VSofti*)
	OUT_CU.tCustDigOut[51].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[52].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;

	(* reserve digital output 53 *)
	OUT_CU.tCustDigOut[53].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[54].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[55].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[56].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;

	(* reserve digital output 57 *)
	OUT_CU.tCustDigOut[57].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[58].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[59].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[60].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;

	(* reserve digital output 61 *)
	OUT_CU.tCustDigOut[61].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[62].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[63].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[64].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;

	(* reserve digital output 65 *)
	OUT_CU.tCustDigOut[65].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[66].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[67].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[68].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;

	(* reserve digital output 69 *)
	OUT_CU.tCustDigOut[69].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[70].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[71].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[72].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	(* reserve digital output 73 *)
	OUT_CU.tCustDigOut[73].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[74].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[75].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[76].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	(* reserve digital output 77 *)
	OUT_CU.tCustDigOut[77].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[78].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[79].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[80].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	(* reserve digital output 81 *)
	OUT_CU.tCustDigOut[81].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[82].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[83].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[84].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	(* reserve digital output 85 *)
	OUT_CU.tCustDigOut[85].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[86].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[87].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[88].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	(* reserve digital output 89 *)
	OUT_CU.tCustDigOut[89].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[90].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[91].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[92].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	(* reserve digital output 93 *)
	OUT_CU.tCustDigOut[93].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[94].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[95].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[96].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	(* reserve digital output 97 *)
	OUT_CU.tCustDigOut[97].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[98].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[99].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[100].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	(* reserve digital output 101 *)
	OUT_CU.tCustDigOut[101].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[102].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[103].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[104].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	(* reserve digital output 105 *)
	OUT_CU.tCustDigOut[105].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[106].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[107].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[108].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	(* reserve digital output 109 *)
	OUT_CU.tCustDigOut[109].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[110].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[111].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[112].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	(* reserve digital output 113 *)
	OUT_CU.tCustDigOut[113].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[114].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[115].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[116].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	(* reserve digital output 117 *)
	OUT_CU.tCustDigOut[117].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[118].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[119].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	OUT_CU.tCustDigOut[120].Do :=	NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ;
	
	
	(**********************************************)
	(*****      END OF CONFIGURATION AREA     *****)
	(**********************************************)

	(*+++++ NO CHANGES BEJOND THIS LINE! +++++++++*)
	
	(* prepard copy process *)
	FOR cnt := 1 TO 200 DO
		(*forward value to module output for use in other modules*)
		OUT_CU.bCustDigIn[cnt]	:= IN_CU.tCustDigIn[cnt].Di;	(* prepared for possible usage in other modules *)
	END_FOR
	(* prepard copy process *)
	FOR cnt := 1 TO 150 DO
		(*forward value to module output for use in other modules*)
		OUT_CU.bCustDigOut[cnt] := OUT_CU.tCustDigOut[cnt].Do;	(* Copy to DO structure; bCustDigOut is also prepared for possible usage in other modules *)
	END_FOR

	(*forward value to visualisation output*)
	MM2VIS.bCustDigIn :=		OUT_CU.bCustDigIn		;	
	MM2VIS.bCustDigOut :=		OUT_CU.bCustDigOut		;	(*Fehlt noch*)

		
	(*Bugfix Version for missing VIS parameter: Set all DigOut as active*)
	//	TON_DigOut.IN := ( IN_CU.tPB2MM.bSys_Run  AND bDigOut_Release_Default );
//	TON_DigOut(PT := T#10s);
//	R_TRIG_DigOut(CLK:=TON_DigOut.Q);
	IF bDigOut_Release_Default THEN	 //IF	bBugfix_CustDigOut_Active THEN
		FOR cnt := 1 TO 150 DO
		(*Bugfix *)   Para.bCustDigOut_Active[cnt]		:= bDigOut_Release_Default; 	(*set parameter value directly*)
		END_FOR
	END_IF
	
END_PROGRAM
