(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: TEC
 * File: convert.st
 * Author: CaksM
 * Created: Dec 09, 2015
 *******************************************************************)

FUNCTION TIME_TO_SEC

	TIME_TO_SEC := TIME_TO_REAL(in)/1000.0;

END_FUNCTION

FUNCTION Bank_AB
	IF bA AND bB THEN
		Bank_AB		:=	(A + B) / 2.0;
	ELSIF bA THEN
		Bank_AB		:=	A;
	ELSIF bB THEN
		Bank_AB		:=	B;
	ELSE
		Bank_AB		:=	0;
	END_IF
END_FUNCTION

FUNCTION Bank_A
	IF bA THEN
		Bank_A		:=	A;
	ELSIF bB THEN
		Bank_A		:=	B;
	ELSE
		Bank_A		:=	0;
	END_IF
END_FUNCTION

FUNCTION Bank_B
	IF bB THEN
		Bank_B		:=	B;
	ELSIF bA THEN
		Bank_B		:=	A;
	ELSE
		Bank_B		:=	0;
	END_IF
END_FUNCTION