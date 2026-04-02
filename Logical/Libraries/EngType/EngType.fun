(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: EngType
 * File: EngType.fun
 * Author: 105046866
 * Created: February 14, 2012
 ********************************************************************
 * Functions and function blocks of library EngType
 ********************************************************************)

FUNCTION_BLOCK EngType (*TODO: Add your comment here*)
	VAR_INPUT
		Motortype : UINT; (*Motortype of the module*)
		IgnType : UINT; (*SAFI specific fire/misfire order*)
	END_VAR
	VAR_OUTPUT
		Type2 : BOOL; (*Engine type2*)
		Type3 : BOOL; (*Engine type3*)
		Type4 : BOOL; (*Engine type4*)
		Type6 : BOOL; (*Engine type6*)
		Type9 : BOOL; (*Engine type9*)
		Type16 : BOOL; (*Engine typeX6 (Diesel)*)
		FireOrder : ARRAY[0..24] OF USINT; (*Engine ignition fire order*)
		MisfireOrder : ARRAY[0..24] OF UDINT; (*Engine ignition misfire order*)
		SkipfireOrder : ARRAY[0..24] OF UDINT; (*Engine skipfire order*)
		Type : USINT; (*Module series*)
		NumberOfTeeth : UINT; (*Number of starter ring gear teeth *)
		IgnDistance : USINT; (*Ignition timing diff. row A to B *)
		TimingSeq : USINT; (*Ignition system timing sequence*)
		NumberOfCylinder : USINT; (*Number of cylinders*)
		ERR_INVALID_MOTORTYPE : BOOL; (*Error because of invalid motortype*)
		DistanceAB : UINT; (*Ignition distance between cylinder row A to B in 1/10°*)
		DistanceBA : UINT; (*Ignition distance between cylinder row B to A in 1/10°*)
		Stroke : UINT;
		Bore : UINT;
		Con_Rod : UINT;
	END_VAR
	VAR
		usZahnzahlOld : UINT;
		bSAFI_Act : BOOL := 0;
		bSAFIIgn_Act : BOOL := 0;
		usMotorTyp : UINT := 1;
		usIgnType : UINT;
	END_VAR
END_FUNCTION_BLOCK
