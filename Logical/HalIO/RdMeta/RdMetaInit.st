(*******************************************************************************
AGGR: read META file data (init)

This code is confidential AND proprietary to the INNIO Company.
It may NOT be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019

- read out data module information

Customized modifications: -
------------------------
 
History:
-------
V3.99	27-01-2014	Weitzer, generated FOR modular software
V4.00	14-02-2014	Weitzer, change version number
V4.03	27-02-2014	Weitzer, add read out of Engine Version
V4.07	22-03-2017	Schmid,	 bugfix memcpy length
								
Instructions FOR use:
--------------------
- 

Outstandings:
------------

*******************************************************************************)

PROGRAM _INIT

	
	(* read out module info from data modul *)
		
	(* read data module data *)
	szMetaDataFile := 'META_HA';
	DatObjInfo_META(enable := 1, pName := ADR(szMetaDataFile));
	IF DatObjInfo_META.status = 0 THEN
		IF DatObjInfo_META.len < SIZEOF(ucMetaDataRaw) THEN	
			DatObjRead_META(enable := 1, ident := DatObjInfo_META.ident, Offset := 0, pDestination := ADR(ucMetaDataRaw), len := DatObjInfo_META.len);
			pm_Error := pm_Error + DatObjRead_META.status;
		ELSE
			DatObjRead_META(enable := 1, ident := DatObjInfo_META.ident, Offset := 0, pDestination := ADR(ucMetaDataRaw), len := SIZEOF(ucMetaDataRaw));
			pm_Error := pm_Error + DatObjRead_META.status;
		END_IF;		
	END_IF;
	(* delete string terminations *)
	FOR ssCount := 0 TO (SIZEOF(ucMetaDataRaw)-1) DO
		IF ucMetaDataRaw[ssCount] = 0 THEN
			FOR ssCount2 := ssCount TO (SIZEOF(ucMetaDataRaw)-2) DO				(*korr.*)
				ucMetaDataRaw[ssCount2] := ucMetaDataRaw[ssCount2+1];
			END_FOR;
		END_IF;	
	END_FOR;	
	(* copy char array to string *)
	memcpy(ADR(szMetaDataRaw), ADR(ucMetaDataRaw),  SIZEOF(szMetaDataRaw));

	
	(*readout of META Data *)
	(***********************)
	
	(* init text offsets*)
	ssIndex := 0; ssIndex2 := 0; ssIndex3 := 0; ssIndex4 := 0;
	
	
	(* get ORDER ID *)
	
	(* locate offset of start key word *)	
	szSnippet := '<ORDER>';
	ssIndex :=	 FIND(szMetaDataRaw, szSnippet) + strlen(ADR(szSnippet)) - 1;
	(* locate offset of stop key word *)	
	szSnippet := '</ORDER>';	
	ssIndex2 := FIND(szMetaDataRaw, szSnippet) - 1;
	(* copy ORDER ID string *)
	IF ssIndex <> 0 AND ssIndex2 <> 0 AND ssIndex2 > ssIndex AND (SIZEOF(Para.szOrderID) > (ssIndex2 - ssIndex)) THEN
		memset(ADR(Para.szOrderID),0,SIZEOF(Para.szOrderID));
		memcpy(ADR(Para.szOrderID), (ADR(szMetaDataRaw) + ssIndex) ,  (ssIndex2 - ssIndex));
	END_IF;					

	(* get ENGINE MOTORVERSION number *)
	
	(* locate offset of start key word *)	
	szSnippet := '<ENGINE_TYPE>';
	ssIndex3 :=	 FIND(szMetaDataRaw, szSnippet) + strlen(ADR(szSnippet)) - 1;			
	(* locate offset of stop key word *)	
	szSnippet := '</ENGINE_TYPE>';	
	ssIndex4 := FIND(szMetaDataRaw, szSnippet) - 1;
	(* copy ENGINE MOTORVERSION string *)	
	IF ssIndex3 <> 0 AND ssIndex4 <> 0 AND ssIndex4 > ssIndex3 AND (SIZEOF(Para.szOrderID) > (ssIndex4 - ssIndex3)) THEN
		memset(ADR(szMetaDataPart),0,SIZEOF(szMetaDataPart));
		memcpy(ADR(szMetaDataPart), (ADR(szMetaDataRaw) + ssIndex3) ,  (ssIndex4 - ssIndex3));
	END_IF;					
	Para.iEng_Motortype := DINT_TO_INT(atoi(ADR(szMetaDataPart)));


	(* get ENGINE MOTORTYPE number *)
	
	(* locate offset of start key word *)	
	szSnippet := '<ENGINE_VERSION>';
	ssIndex5 :=	 FIND(szMetaDataRaw, szSnippet) + strlen(ADR(szSnippet)) - 1;			
	(* locate offset of stop key word *)	
	szSnippet := '</ENGINE_VERSION>';	
	ssIndex6 := FIND(szMetaDataRaw, szSnippet) - 1;
	(* copy ENGINE MOTORTYPE string *)	
	IF ssIndex5 <> 0 AND ssIndex4 <> 0 AND ssIndex6 > ssIndex5 AND (SIZEOF(Para.szEng_Motorversion) > (ssIndex6 - ssIndex5)) THEN
		memset(ADR(Para.szEng_Motorversion),0,SIZEOF(Para.szEng_Motorversion));
		memcpy(ADR(Para.szEng_Motorversion), (ADR(szMetaDataRaw) + ssIndex5) ,  (ssIndex6 - ssIndex5));
	END_IF;

END_PROGRAM