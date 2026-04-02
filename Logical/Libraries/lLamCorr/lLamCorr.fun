FUNCTION_BLOCK lLamCorr
  VAR_INPUT
    ssMethodType: SINT;
  END_VAR  VAR_INPUT
        rN_Set : REAL := 1500.0000000000; (*speed set value [rpm]*)
  END_VAR
  VAR_INPUT
        rP_Nom : REAL := 4400.0000000000; (*nominal power [KW]*)
  END_VAR
  VAR_INPUT
        rN_Delta_Lim : REAL := 0.0099999998; (*delta speed limit when engine speed is recovered, normed*)
  END_VAR
  VAR_INPUT
        rP_Rot_Norm_Lam_Trig : REAL := 0.0199999996; (*rotational power trigger value for lambda adaption, normed*)
  END_VAR
  VAR_INPUT
        rP_Rot_Norm_Lambda_Gain : REAL := 1.0000000000; (*gain value to convert nomed rotational power to delta lambda value for lambda adaption*)
  END_VAR
  VAR_INPUT
        rLam_OffsLimit_pos : REAL; (*pos limitation of dynamic lambda offset*)
  END_VAR
  VAR_INPUT
        rLam_Ramp_Grad : REAL := 0.2500000000; (*neg limitation of dynamic lambda offset*)
  END_VAR
  VAR_INPUT
        bLambda_Corr_Enable : BOOL := FALSE; (*enable function of lambda correction*)
  END_VAR
  VAR_INPUT
        rP_Rot : REAL; (*rotational power*)
  END_VAR
  VAR_INPUT
        rN_Eng : REAL; (*engine speed [rpm]*)
  END_VAR
  VAR_INPUT
        rLam_OffsLimit_Neg : REAL; (*engine speed [rpm]*)
  END_VAR
  VAR_OUTPUT
        rLambda_Corr : REAL; (*Lambda adaption value*)
  END_VAR
  VAR_OUTPUT
        bLambda_Freeze : BOOL := FALSE; (*Lambda adaption value*)
  END_VAR
  VAR_OUTPUT
        rP_Rot_Max : REAL; (*maximum value for rotational power, used for calibration*)
  END_VAR
  VAR_OUTPUT
        bN_Delta_Act : BOOL := FALSE; (*Debug Output*)
  END_VAR
  VAR_OUTPUT
        bP_Rot_Lambda_Act : BOOL := FALSE; (*Debug Output*)
  END_VAR
  VAR_OUTPUT
        bN_Delta_Neg : BOOL := FALSE; (*Debug Output*)
  END_VAR
	VAR
		bur_BlockIO_LambdaAdp : BlockIO_LambdaAdp;
	END_VAR
	VAR
		bur_D_Work_LambdaAdp : D_Work_LambdaAdp;
	END_VAR
END_FUNCTION_BLOCK