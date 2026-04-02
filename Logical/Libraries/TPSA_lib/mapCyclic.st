(*******************************************************************************
	AGGR: MAP_REAL18 characterisitc map - real 18x18 (FUB)
	
This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner, without the express
written permission of the INNIO Company.
Copyright, INNIO Company, 2019
	
- limitation of inputs
- detection of according area in x direction
- assignment of the z values for the according area
- linear interpolation in the according area


History:
-------
V1.00	14-12-2010	Graus, 	generated
V1.01	15-02-2011	Graus,	correction to avoid negativ array index 
							via max function with zero input

Instructions for use:
-----------------------

- linear interpolation of a characteristic map
- inputs: x, y: REAL
- outputs: z: REAL
- parameters:	X_PAR, Y_PAR: REAL		supporting points
				Z_PAR: REAL				values (order: [x(0)y(0), x(1)y(0), 
													... x(1)y(1), x(2)y(1), 
													... x(n-1)y(n), x(n)y(n)] )
				X_NUM, Y_NUM: INT		number of supporting points of the axis

- all specified supporting points have to be set strictly monotonic increasing
- no extrapolation outside of the range of the supporting points
- max. size of the map MAP_REAL12 is limited to 12x12
- size of map has to be specified by X_NUM and Y_NUM

Outstandings:
----------------

*******************************************************************************)

FUNCTION_BLOCK MAP_REAL18

	x := LIMIT(X_PAR[0], x, X_PAR[MAX(0, X_NUM - 1)]);		(* limitation of input / avoid extrapolation *)
	y := LIMIT(Y_PAR[0], y, Y_PAR[MAX(0, Y_NUM - 1)]);		(* limitation of input / avoid extrapolation *)

	FOR index := 0 TO X_NUM - 2 DO								(* detection of according area in x direction *)
		IF X_PAR[index] <= x AND x <= X_PAR[index + 1]   THEN	(* according area detected *)
			x_index := index;									(* assign index *)
			EXIT;												(* exit loop if detected *)
		END_IF;
	END_FOR;

	FOR index := 0 TO Y_NUM - 2 DO								(* detection of according area in y direction *)
		IF Y_PAR[index] <= y AND y <= Y_PAR[index + 1]   THEN	(* according area detected *)
			y_index := index;									(* assign index *)
			EXIT;												(* exit loop if detected *)
		END_IF;
	END_FOR;

	z1_tmp := Z_PAR[ X_NUM * y_index + x_index ];				(* assignment of the z values for the according area *)
	z2_tmp := Z_PAR[ X_NUM * y_index + x_index + 1 ];			(* assignment of the z values for the according area *)
	z3_tmp := Z_PAR[ X_NUM * (y_index + 1) + x_index ];			(* assignment of the z values for the according area *)
	z4_tmp := Z_PAR[ X_NUM * (y_index + 1) + x_index + 1 ];		(* assignment of the z values for the according area *)

	(* linear interpolation in the according area *)
	IF (X_PAR[x_index + 1] - X_PAR[x_index]) <> 0 THEN
		zx_intp1_tmp := ( z2_tmp - z1_tmp ) * ( (x - X_PAR[x_index]) / (X_PAR[x_index + 1] - X_PAR[x_index]) ) + z1_tmp;
		zx_intp2_tmp := ( z4_tmp - z3_tmp ) * ( (x - X_PAR[x_index]) / (X_PAR[x_index + 1] - X_PAR[x_index]) ) + z3_tmp;
	ELSE
		zx_intp1_tmp := z1_tmp;
		zx_intp2_tmp := z3_tmp;
	END_IF;
	IF (Y_PAR[y_index + 1] - Y_PAR[y_index]) <> 0 THEN
		z := ( zx_intp2_tmp - zx_intp1_tmp ) * ( (y - Y_PAR[y_index]) / (Y_PAR[y_index + 1] - Y_PAR[y_index]) ) + zx_intp1_tmp;
	ELSE
		z := zx_intp1_tmp;
	END_IF;


END_FUNCTION_BLOCK