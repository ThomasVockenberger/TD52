

FUNCTION_BLOCK SS_Cust   
	VAR_INPUT
		ssMethodType :  SINT;   
		in :  tSS_In_Cust; (**)  
	END_VAR
	VAR_OUTPUT
		out :  tSS_Out_Cust; (**)  
	END_VAR
	VAR
		bur_BlockIO_AC_SS_Cust :  BlockIO_AC_SS_Cust;   
		bur_D_Work_AC_SS_Cust :  D_Work_AC_SS_Cust;   
		bur_ExternalOutputs_AC_SS_Cust :  ExternalOutputs_AC_SS_Cust;   
		bur_AC_SS_Cust :  tag_RTM_AC_SS_Cust;   
	END_VAR
END_FUNCTION_BLOCK

FUNCTION_BLOCK SS   
	VAR_INPUT
		ssMethodType :   SINT;   
		in :   tSS_In; (**)  
	END_VAR
	VAR_OUTPUT
		dbg :   tSS_Out; (**)  
		iAbs :   USINT; (*binary data absolute deviation in limits*)  
		iRel :   USINT; (*binary data relative deviation in limits*)  
	END_VAR
	VAR
		bur_BlockIO_AC_SS :   BlockIO_AC_SS;   
		bur_D_Work_AC_SS :   D_Work_AC_SS;   
		bur_ExternalOutputs_AC_SS :   ExternalOutputs_AC_SS;   
		bur_AC_SS :   tag_RTM_AC_SS;   
	END_VAR
END_FUNCTION_BLOCK

