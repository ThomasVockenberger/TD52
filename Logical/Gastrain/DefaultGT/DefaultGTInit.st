(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Program: DefaultGT
 * File: DefaultGTInit.st
 * Author: 105046866
 * Created: September 18, 2012
 ********************************************************************
 * Implementation of program DefaultGT
 ********************************************************************)

PROGRAM _INIT

	(* Internal setting *)
	bTestEnabled := FALSE;
	
	(* V4.07 Para defaults against missing values at upgrade engines *)
	ParaFactoryDefault.iGasTrain_Type 			:= 1;
	ParaFactoryDefault.iGasTrain_Upstream_Type	:= 0;
	ParaFactoryDefault.rGasImp_Prescaling		:= 1;

END_PROGRAM

