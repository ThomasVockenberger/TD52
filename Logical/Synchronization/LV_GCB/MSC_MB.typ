(********************************************************************
 * COPYRIGHT -- INNIO, MSC
 ********************************************************************
 * Library: MSC_MB
 * File: MSC_MB.typ
 * Author: Hohensinner Michael
 * Created: April 29, 2021
 ********************************************************************
 * Functions and function blocks of library MSC_MB
 ********************************************************************)

TYPE
	MB_Reg_Definition : {REDUND_UNREPLICABLE} 	STRUCT 
		iFC : {REDUND_UNREPLICABLE} USINT; (*Modbus command function code*)
		iLen : {REDUND_UNREPLICABLE} UINT; (*Modbus command length*)
		iOffs : {REDUND_UNREPLICABLE} UINT; (*Modbus command offset*)
		pDest : {REDUND_UNREPLICABLE} UDINT; (*Destination adress*)
		iBitOffs : {REDUND_UNREPLICABLE} USINT; (*Destination Bit offset*)
		iWordOffs : {REDUND_UNREPLICABLE} USINT; (*Destination word offset to get destination adress*)
	END_STRUCT;
	MB_Reg_Interface : 	STRUCT 
		bExec : BOOL; (*Modbus command execution*)
		bData : ARRAY[0.._MB_BIN_MAX]OF BOOL; (*Modbus command binary data*)
		iData : ARRAY[0.._MB_REG_MAX]OF UINT; (*Modbus command 2Byte data*)
		iStatus : UINT; (*Modbus command status*)
	END_STRUCT;
	MB_Reg_Line : 	STRUCT 
		tDef : {REDUND_UNREPLICABLE} MB_Reg_Definition; (*Modbus command definition*)
		tIF : MB_Reg_Interface; (*Modbus command execution and data*)
	END_STRUCT;
	MB_Reg_Slaves : 	STRUCT 
		bSkip : {REDUND_UNREPLICABLE} BOOL; (*Skips slave is TRUE*)
		sName : {REDUND_UNREPLICABLE} STRING[100]; (*Name of slave*)
		iMaster : {REDUND_UNREPLICABLE} USINT; (*Master identification*)
		iInfo : {REDUND_UNREPLICABLE} USINT; (*Slave information*)
		iAdr : {REDUND_UNREPLICABLE} USINT; (*Station number of slave*)
		tLine : ARRAY[0.._MB_CMD_MAX]OF MB_Reg_Line; (*Modbus command and data*)
	END_STRUCT;
	MBS_Config : {REDUND_UNREPLICABLE} 	STRUCT 
		sDevice : {REDUND_UNREPLICABLE} STRING[40]; (*Device adress*)
		sMode : {REDUND_UNREPLICABLE} STRING[40]; (*Modbus mode*)
		iID : {REDUND_UNREPLICABLE} USINT; (*Modbus ID of slave*)
		pInStat : {REDUND_UNREPLICABLE} UDINT; (*Pointer to input status*)
		pInReg : {REDUND_UNREPLICABLE} UDINT; (*Pointer to input register*)
		pHoldReg : {REDUND_UNREPLICABLE} UDINT; (*Pointer to holding register*)
		pCoilStat : {REDUND_UNREPLICABLE} UDINT; (*Pointer to coil status*)
		iTimeOut : {REDUND_UNREPLICABLE} UINT; (*Timeout after X ms*)
	END_STRUCT;
	MBM_Config : {REDUND_UNREPLICABLE} 	STRUCT 
		sDevice : {REDUND_UNREPLICABLE} STRING[50]; (*Device adress*)
		sMode : {REDUND_UNREPLICABLE} STRING[40]; (*Modbus mode*)
		sFile : {REDUND_UNREPLICABLE} STRING[40]; (*Dataobject name*)
		bASCII : {REDUND_UNREPLICABLE} BOOL; (*If true ASCII mode is enabled*)
		iTimeOut : {REDUND_UNREPLICABLE} UINT; (*Timeout after X ms*)
		iID : {REDUND_UNREPLICABLE} USINT; (*Master identification number*)
	END_STRUCT;
	MB_Commands : {REDUND_UNREPLICABLE} 	STRUCT 
		bOpen : {REDUND_UNREPLICABLE} BOOL; (*Opens modbus communication to the slaves*)
		bClose : {REDUND_UNREPLICABLE} BOOL; (*Closes modbus communication to the slaves*)
		bAckn : {REDUND_UNREPLICABLE} BOOL; (*Acknowledges modbus communication errors*)
	END_STRUCT;
	MB_State_Enum : 
		(
		_MB_DEFAULT,
		_MB_OPEN,
		_MB_RUN,
		_MB_CLOSE,
		_MB_START,
		_MB_CREATE,
		_MB_CONFIG,
		_MB_INFO,
		_MB_DELETE,
		_MB_DONE,
		_MB_WAIT,
		_MB_ERROR
		);
	LV_GCB : 
		(
		_GCB_INIT,
		_GCB_TRY_ABB,
		_GCB_TRY_SE,
		_GCB_IDLE,
		_GCB_WAIT,
		_GCB_CALC,
		_GCB_CLEAR,
		_ABB_LOAD,
		_ABB_READ,
		_ABB_SAVE_OPEN,
		_ABB_SAVE_DATA,
		_ABB_SAVE_CLOSE,
		_SE_LOAD,
		_SE_READ,
		_SE_SAVE_CHECK,
		_SE_SAVE_CLOSE_OLD,
		_SE_SAVE_OPEN,
		_SE_SAVE_ID,
		_SE_SAVE_DATA1,
		_SE_SAVE_DATA2,
		_SE_SAVE_DATA3,
		_SE_SAVE_APPLY,
		_SE_SAVE_CLOSE,
		_SE_SAVE_CLOSE_CHECK
		);
END_TYPE
