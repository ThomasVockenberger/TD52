(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: JWASLIB2
 * File: JWASLIB2.typ
 * Author: 105051626
 * Created: February 04, 2014
 ********************************************************************
 * Data types of library JWASLIB2
 ********************************************************************)

TYPE
	coordinate_5 : 	STRUCT 
		x1 : REAL;
		x2 : REAL;
		x3 : REAL;
		x4 : REAL;
		x5 : REAL;
		y1 : REAL;
		y2 : REAL;
		y3 : REAL;
		y4 : REAL;
		y5 : REAL;
	END_STRUCT;
	IntegralElement : 	STRUCT 
		In : REAL;
		In_internal : REAL;
		In_ref : REAL;
		mode : INT;
		Ki_plus : REAL;
		Ki_minus : REAL;
		dOut_plus : REAL;
		dOut_minus : REAL;
		dOut_max_p : REAL;
		dOut_max_m : REAL;
		Out_min : REAL;
		Out_max : REAL;
		Out_internal : REAL;
		Out : REAL;
	END_STRUCT;
	IntegralController : 	STRUCT 
		enable : BOOL;
		x : REAL;
		w : REAL;
		w_ref : REAL;
		mode : INT;
		deadband : REAL;
		Ki_plus : REAL;
		Ki_minus : REAL;
		dy_plus : REAL;
		dy_minus : REAL;
		dy_max_p : REAL;
		dy_max_m : REAL;
		y_block : REAL;
		y_min : REAL;
		y_max : REAL;
		y_invers : BOOL;
		y_internal : REAL;
		y : REAL;
	END_STRUCT;
END_TYPE
