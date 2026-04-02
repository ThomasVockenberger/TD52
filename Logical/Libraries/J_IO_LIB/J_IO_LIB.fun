(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: OutExist
 * File: OutExist.fun
 * Author: Schmid
 * Created: December 09, 2020
 ********************************************************************
 * Functions and function blocks of library OutExist
 ********************************************************************)

FUNCTION_BLOCK OutExist
	VAR_INPUT
		enable : BOOL;
		pPVstring : UDINT;
		pLastDatapoint : UDINT;
	END_VAR
	VAR_OUTPUT
		exist : BOOL;
		busy : BOOL;
		done : BOOL;
		pDatapoint : UDINT;
		sOutPVName : STRING[50];
	END_VAR
	VAR
		bSecondTry : BOOL;
		xAsIOFListDP : AsIOFListDP;
		xAsIOPVInfo : AsIOPVInfo;
		sPVstring : STRING[50];
		sPVfilter : STRING[60];
		bReadIOPVInfo : BOOL;
		pTempDatapoint : UDINT;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK
