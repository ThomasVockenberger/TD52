FUNCTION_BLOCK CoV
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_OUTPUT
        CoV : ARRAY[0..24] OF REAL; (**)
  END_VAR
  VAR_OUTPUT
        Avg : ARRAY[0..24] OF REAL; (**)
  END_VAR
  VAR_OUTPUT
        Std : ARRAY[0..24] OF REAL; (**)
  END_VAR
  VAR_INPUT
        In : ARRAY[0..24] OF REAL; (**)
  END_VAR
	VAR
		bur_BlockIO_CoV_24Cyl : BlockIO_CoV_24Cyl;
	END_VAR
	VAR
		bur_D_Work_CoV_24Cyl : D_Work_CoV_24Cyl;
	END_VAR
END_FUNCTION_BLOCK