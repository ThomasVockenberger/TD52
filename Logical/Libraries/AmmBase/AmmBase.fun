
FUNCTION_BLOCK Msg (*AMM*)
	VAR_INPUT
		Num : UINT; (*alarm number*)
		Enable : BOOL; (*alarm enable*)
		Set : BOOL; (*alarm set*)
		PT : TIME; (*alarm delay*)
		Prio : UINT; (*alarm priority*)
		RiskClass : UINT; (*alarm riskclass*)
		Reset : BOOL; (*alarm reset*)
		LockReset : BOOL; (*alarm reset locked out*)
		AmmInAdr : UDINT;
		AmmOutAdr : UDINT;
	END_VAR
	VAR_OUTPUT
		Q : BOOL;
		Status : UINT;
		Test : BOOL; (*alarm test active*)
	END_VAR
	VAR
		xSR : SR;
		xTON : TON;
		bAlmTest : BOOL;
		MM2AB : REFERENCE TO MM2AmmBase;
		AB2MM : REFERENCE TO AmmBase2MM;
		bAdressErr : BOOL;
	END_VAR
	VAR CONSTANT
		FUB_Msg_InAdr_Err : UINT := 1111;
		FUB_Msg_OutAdr_Err : UINT := 2222;
	END_VAR
	VAR
		bRemoteReset : BOOL;
		AsArLogWrite_AMM : AsArLogWrite;
		AsArLogGetInfo_0 : AsArLogGetInfo;
		SetLog : BOOL;
		zzEdge00000 : BOOL;
	END_VAR
END_FUNCTION_BLOCK
