(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: TCC_intern
 * File: TCC_intern.fun
 * Author: WaldharM
 * Created: September 14, 2010
 ********************************************************************
 * Functions and function blocks of library TCC_intern
 ********************************************************************)

FUNCTION_BLOCK MAP_REAL18
	VAR_INPUT
		X_PAR : ARRAY[0..18] OF REAL;
		Y_PAR : ARRAY[0..25] OF REAL;
		Z_PAR : ARRAY[0..475] OF REAL;
		x : REAL;
		y : REAL;
		X_NUM : INT;
		Y_NUM : INT;
	END_VAR
	VAR_OUTPUT
		z : REAL;
	END_VAR
	VAR
		index : INT;
		x_index : INT;
		y_index : INT;
		zx_intp1_tmp : REAL;
		zx_intp2_tmp : REAL;
		z1_tmp : REAL;
		z2_tmp : REAL;
		z3_tmp : REAL;
		z4_tmp : REAL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK MEDIAN24
	VAR_INPUT
		anzahl : USINT;
		in : ARRAY[0..24] OF INT;
	END_VAR
	VAR_OUTPUT
		median : INT;
	END_VAR
	VAR
		i : USINT;
		j : USINT;
		ssDummy : INT;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK RMEDIAN24
	VAR_INPUT
		anzahl : USINT;
		in : ARRAY[0..24] OF REAL;
	END_VAR
	VAR_OUTPUT
		median : REAL;
	END_VAR
	VAR
		i : USINT;
		j : USINT;
		rDummy : REAL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK RING500_R
	VAR_INPUT
		in : REAL;
		iCnt_Max : INT;
		reset : BOOL;
	END_VAR
	VAR_OUTPUT
		out : REAL;
	END_VAR
	VAR
		iCnt : INT;
		rBuffer : ARRAY[0..500] OF REAL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK RING1000_R
	VAR_INPUT
		in : REAL;
		iCnt_Max : INT;
		reset : BOOL;
	END_VAR
	VAR_OUTPUT
		out : REAL;
	END_VAR
	VAR
		iCnt : INT;
		rBuffer : ARRAY[0..1000] OF REAL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK COUNTER50
	VAR_INPUT
		in : BOOL;
		iNum_Max : SINT;
		ti_Max : TIME;
		reset : BOOL;
	END_VAR
	VAR_OUTPUT
		out : BOOL;
	END_VAR
	VAR
		iCmp : SINT;
		iCnt : SINT;
	END_VAR
	VAR CONSTANT
		iCnt_Max : SINT := 50;
	END_VAR
	VAR
		ti : ARRAY[0..50] OF TIME;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK COUNTER100
	VAR_INPUT
		in : BOOL;
		iNum_Max : SINT;
		ti_Max : TIME;
		reset : BOOL;
	END_VAR
	VAR_OUTPUT
		out : BOOL;
	END_VAR
	VAR
		iCmp : SINT;
		iCnt : SINT;
	END_VAR
	VAR CONSTANT
		iCnt_Max : SINT := 100;
	END_VAR
	VAR
		ti : ARRAY[0..100] OF TIME;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK PRed (* Power reduction function block *)
	VAR_INPUT
		iAdr_P_Type : UDINT; (* address of actual Load reduction type *)
		iAdr_P_Set : UDINT; (* address of actual normalized load reduction *)
		iAdr_P_Set_Max : UDINT; (* address of all load reductions*)
		rP_Red : REAL; (* normalized load reduction *)
		iType : INT; (* load reduction type *)
		PT : TIME; (* time off delay for Q *)
		bEna : BOOL; (* enable block *)
		bParaSetupOk_2s : BOOL; (* Para setup OK *)
	END_VAR
	VAR_OUTPUT
		Q : BOOL; (* reduction active *)
	END_VAR
	VAR
		rP_Set_Act : REAL;
		iType_Act : INT;
		xTOF : TOF;
		rP_Set_Max : REAL;
	END_VAR
END_FUNCTION_BLOCK
