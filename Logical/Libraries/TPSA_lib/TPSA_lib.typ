(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: TCC_intern
 * File: TCC_intern.typ
 * Author: WaldharM
 * Created: September 14, 2010
 ********************************************************************
 * Data types of library TCC_intern
 ********************************************************************)

TYPE
	_tXY_Stat : STRUCT
		tLn_Nom : _tLn;				(* Nominal line *)
		tLn_Set : _tLn;				(* Setpoint line *)
		tWin : _tWin;				(* window size *)
		tWPt : _tPt;				(* working point *)
	END_STRUCT;
	_tLn : STRUCT
		x : ARRAY [0..1] OF REAL;
		y : ARRAY [0..1] OF REAL;
	END_STRUCT;
	_tWin : STRUCT
		x : ARRAY [0..1] OF REAL;
		y : ARRAY [0..1] OF REAL;
	END_STRUCT;
	_tPt : STRUCT
		x : REAL;
		y : REAL;
	END_STRUCT;
	_tLL_Struct: STRUCT
		rPr_P2s_Ref_0kW : ARRAY [0..4] OF REAL;	(* Reference point 0kW (0), Reference for boost pressure [bar] - depending on the gas type *)
		tRef_a : ARRAY [0..4] OF _tLL_Pt_Struct; (* Reference point a   (1) - depending on the gas type *)
		tRef_b : ARRAY [0..4] OF _tLL_Pt_Struct; (* Reference point b   (2) - depending on the gas type *)
		tRef_c : ARRAY [0..4] OF _tLL_Pt_Struct; (* Reference point c   (3) - depending on the gas type *)
	END_STRUCT;
	_tLL_Pt_Struct: STRUCT
		rP_Eng : REAL;			(* Reference for engine power [kW] *)
		rN_Eng : REAL;			(* Reference for engine speed [rpm]  *)
		rPr_P2s : REAL;			(* Reference for boost pressure [bar]  *)
		rT_T2s : REAL;			(* Reference for mixture temperature [°C]  *)
	END_STRUCT;
END_TYPE
