(********************************************************************

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2021

Customized modifications: -
------------------------

History:
-------
V4.10	09-12-2020	Schmid,		initial version

Instructions for use:
--------------------
- Function can be used to check if an output variable is connected to the PLC
  
Outstandings: - 
------------

*******************************************************************************)
FUNCTION_BLOCK OutExist 

	IF EDGEPOS(enable) THEN			(* executed when enable triggered *)
		bSecondTry		:= FALSE;
		done			:= FALSE;
		bReadIOPVInfo	:= FALSE;
		pTempDatapoint	:= 0;
		brsstrcpy(ADR(sOutPVName), ADR(''));
	END_IF;
	
	IF NOT bSecondTry THEN
		(* create search string *)
		brsstrcpy(ADR(sPVfilter), ADR('/SourcePV='));
		IF pPVstring <> 0 THEN
			brsstrcpy(ADR(sPVstring), pPVstring);
		END_IF;
		brsstrcat(ADR(sPVfilter), ADR(sPVstring));
	END_IF;
	
	IF enable AND NOT done THEN
		(* get info on output variable from IOmap *)
		xAsIOFListDP.enable			:= NOT bReadIOPVInfo;
		xAsIOFListDP.pLastDatapoint	:= pLastDatapoint;
		xAsIOFListDP.flagsValue		:= 2#0000_0010_0010_0011;
		xAsIOFListDP.flagsMask		:= 2#0000_0011_0011_0011;
		xAsIOFListDP.pFilterString	:= ADR(sPVfilter);
		xAsIOFListDP();
	
		IF (xAsIOFListDP.status <> ERR_FUB_BUSY) AND xAsIOFListDP.enable THEN
			IF xAsIOFListDP.pDatapoint <> 0 THEN
				bReadIOPVInfo	:= TRUE;	(* datapoint found *)
				pTempDatapoint	:= xAsIOFListDP.pDatapoint;
			ELSE
				(* Second try with HalIO:: added to filter string *)
				brsstrcpy(ADR(sPVfilter), ADR('/SourcePV='));
				brsstrcpy(ADR(sPVstring), ADR('HalIO::'));
				IF pPVstring <> 0 THEN
					brsstrcat(ADR(sPVstring), pPVstring);
				END_IF;
				brsstrcat(ADR(sPVfilter), ADR(sPVstring));
				
				IF NOT bSecondTry AND NOT done THEN
					xAsIOFListDP();
				END_IF;
				
				bSecondTry := TRUE;
				
				IF xAsIOFListDP.status <> ERR_FUB_BUSY THEN
					IF xAsIOFListDP.pDatapoint <> 0 THEN
						bReadIOPVInfo	:= TRUE;	(* datapoint found *)
						pTempDatapoint	:= xAsIOFListDP.pDatapoint;
					ELSE
						(* no datapoint found *)
						exist			:= FALSE;
						pDatapoint		:= 0;
						brsstrcpy(ADR(sOutPVName), ADR(''));
						busy			:= FALSE;
						done			:= TRUE;
						bReadIOPVInfo	:= FALSE;
					END_IF;
				ELSE
					(* status busy *)
					busy			:= TRUE;
					done			:= FALSE;
					bReadIOPVInfo	:= FALSE;
				END_IF;
			END_IF;
			
		ELSIF (xAsIOFListDP.status = ERR_FUB_BUSY) THEN
			(* status busy *)
			busy			:= TRUE;
			done			:= FALSE;
			bReadIOPVInfo	:= FALSE;
		END_IF;
	
		(* Verify if found datapoint is correct *)
		xAsIOPVInfo.enable			:= bReadIOPVInfo;
		xAsIOPVInfo.index			:= 0;
		xAsIOPVInfo.pDatapoint		:= pTempDatapoint;
		xAsIOPVInfo();
		
		IF (xAsIOPVInfo.status <> ERR_FUB_BUSY) AND xAsIOPVInfo.enable THEN
			IF xAsIOPVInfo.pPvName <> 0 THEN
				IF strcmp(xAsIOPVInfo.pPvName, ADR(sPVstring)) = 0 THEN
					(* datapoint identical to search string *)
					exist		:= TRUE;
					pDatapoint	:= xAsIOFListDP.pDatapoint;
					brsstrcpy(ADR(sOutPVName), xAsIOPVInfo.pPvName);
				ELSE
					(* datapoint different to search string -> wrong datapoint found *)
					exist		:= FALSE;
					pDatapoint	:= 0;
					brsstrcpy(ADR(sOutPVName), ADR(''));
				END_IF;
			ELSE
				(* no name for datapoint found -> wrong datapoint found *)
				exist		:= FALSE;
				pDatapoint	:= 0;
				brsstrcpy(ADR(sOutPVName), ADR(''));
			END_IF;
			busy	:= FALSE;
			done	:= TRUE;
		ELSIF (xAsIOPVInfo.status = ERR_FUB_BUSY) THEN
			(* status busy *)
			busy	:= TRUE;
			done	:= FALSE;
		END_IF;
		
	ELSE
		(* disble FUBs after execution until retrigger via enable *)
		xAsIOFListDP.enable	:= FALSE;
		xAsIOPVInfo.enable	:= FALSE;
		bReadIOPVInfo		:= FALSE;
		pTempDatapoint		:= 0;
	END_IF;
	
END_FUNCTION_BLOCK
