(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: gas_flow
 * File: gas_flowInit.st
 * Author: 105046866
 * Created: May 10, 2012
 ********************************************************************
 * Implementation of program gas_flow
 ********************************************************************)

PROGRAM _INIT

	(* parameter for limit speed of gas mixture change *)
	RAMPE_MixGas.Rise	:= 10.0;		(* positive change of gas mixture 1%/ second	*)
	RAMPE_MixGas.Sink	:= 10.0;		(* negative change of gas mixture 1%/ second	*)
	RAMPE_MixGas.TC_Time:= 10;			(* FUB is working in 10 millisecond task		*)

END_PROGRAM

