(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Library: MBTCP
 * File: MBTCP.fun
 * Author: B&R
 * Created: September 04, 2008
 ********************************************************************
 * Functions and function blocks of library MBTCP
 ********************************************************************)
(*Configures a Modbus over TCP slave (server) and provides a Modbus slave ID. fMBTSOpen() should be called in the INIT section of a task prior to fMBTSlave(). See also fMBTSClose() to close the slave in the EXIT section. This slave can then be read from, or written to, by fMBTMaster() or widely available Modbus over TCP programs.Hosts up to 127 Modbus units, each unit contains set of size-adjustable coils, discrete inputs, input registers, and holding registers. <a href="../MBTCP Slave/MBTCP Slave.html"> See Modbus Slave/Server for more information</a>*)

FUNCTION_BLOCK fMBTSOpen
	VAR_INPUT
		bEnable : BOOL; (*Enables the function block*)
		uiPort : UINT; (*TCP port number (default = 502) *)
		uiNbrCoils : UINT; (*Number of read-write binary coils*)
		uiNbrDiscreteInputs : UINT; (*Number of read-only binary discrete inputs *)
		uiNbrInputRegs : UINT; (*Number of read-only 16-bit input registers *)
		uiNbrHoldingRegs : UINT; (*Number of read-write 16-bit holding registers *)
		uiOffsetUnits : UINT; (*Offset of Modbus units. *)
		uiNbrUnits : UINT; (*Number of Modbus units. If external array are used this parameter has to be set to 1*)
		pbCoil : REFERENCE TO BOOL; (*Coil mapping, given as array of BOOL. Must be set to 0 if internal mapping is used*)
		pbDInp : REFERENCE TO BOOL; (*Discrete input mapping, given as array of BOOL. Must be set to 0 if internal mapping is used*)
		puiIReg : REFERENCE TO UINT; (*Input register mapping, given as array of UINT. Must be set to 0 if internal mapping is used*)
		puiHReg : REFERENCE TO UINT; (*Holding register mapping, given as array of UINT. Must be set to 0 if internal mapping is used*)
	END_VAR
	VAR_OUTPUT
		uiNbrAllocUnits : UINT; (*Number of actaully allocated units *)
		udiIdent : UDINT; (*Ident (pointer to memory area holding Modbus server structure)*)
		uiStatus : UINT; (*Status 0 for OK, otherwise <a href="../../Data types and constants/Constants.html"> Error Number </a>*)
	END_VAR
END_FUNCTION_BLOCK
(*Modbus/TCP slave (server) function. fMBTSlave() should be called in the CYCLIC section of a task after being configured by fMBTSOpen(). The server is closed by fMBTSClose(). This server can be read from or written to by fMBTMaster() or widely available Modbus over TCP programs. <a href="../MBTCP Slave/MBTCP Slave.html"> See Modbus Slave/Server for more information</a>*)

FUNCTION_BLOCK fMBTSlave
	VAR_INPUT
		bEnable : BOOL; (*Enables the function block*)
		udiIdent : UDINT; (*Ident, as provided in instfMBTSOpen.udiIdent *)
		tiRecvDelay : TIME; (*Time to wait before disconnecting a non-responding client (master)*)
	END_VAR
	VAR_OUTPUT
		usiClientNbr : UINT; (*How many clients (masters) are connected *)
		usiClientServed : USINT; (*Client (master) currently served *)
		tiRecvElapsed : TIME; (*Time spent waiting for response from Master *)
		usiUnit : USINT; (*Server unit read or written *)
		usiClientIP : STRING[18]; (*Client (master) IP address *)
		usiMBFuncCode : USINT; (*Modbus function code *)
		uiSentDataLen : UINT; (*Length of data sent *)
		szMsg : STRING[100]; (*Debug Message*)
		stTcpServerStatus : UINT; (*Status from the TCPServer function*)
		udiRecvCnt : UDINT; (*Counter receive data*)
		udiSendCnt : UDINT; (*Counter Send Data*)
		usiOpenRetries : USINT; (*Port open Retries*)
		CltInfo : ARRAY[0..4] OF tstclient_info; (*Client Info (IP-Adresse, Port, Ident)*)
		uiStep : UINT; (*Current step executed by the Slave's state machine*)
		uiStatus : UINT; (*Status 0 for OK, otherwise <a href="../../Data types and constants/Constants.html"> Error Number </a>*)
	END_VAR
END_FUNCTION_BLOCK
(*Terminates a Modbus/TCP slave (server) and releases allocated memory. fMBTSClose() should be called in the EXIT section of a task. See also fMBTSOpen() and fMBTSlave().*)

FUNCTION_BLOCK fMBTSClose
	VAR_INPUT
		bEnable : BOOL; (*Enables the function block*)
		udiIdent : UDINT; (*Ident, as provided in instfMBTSOpen.udiIdent *)
	END_VAR
	VAR_OUTPUT
		uiStatus : UINT; (*Status 0 for OK, otherwise <a href="../../Data types and constants/Constants.html"> Error Number </a>*)
	END_VAR
END_FUNCTION_BLOCK
(*Read/write individual values from/to coils and registers of given unit. The function code to use in member uiFcode of the passed structure is the same as for Modbus (0x01..0x06,0x0F,0x10,0x17) and two user defined functions (0x41,0x42). *)

FUNCTION_BLOCK fMBTSRW
	VAR_INPUT
		bEnable : BOOL; (*Enables the function block*)
		udiIdent : UDINT; (*Ident, as provided in instfMBTSOpen.udiIdent *)
		usiFCode : USINT; (*Modbus function code, see <a href="../../Data types and constants/Constants.html">constants</a>*)
		usiUnit : USINT; (*Unit to access*)
		uiReadAddr : UINT; (*Element in coil or register for read access*)
		uiReadQty : UINT; (*Quantity of coils/regs to read*)
		puiReadVal : REFERENCE TO UINT; (*Requested read value, pointer to UINT*)
		uiWriteAddr : UINT; (*Element in coil or register for write access*)
		uiWriteQty : UINT; (*Quantity of coils/regs to write*)
		puiWriteVal : REFERENCE TO UINT; (*Requested write value, pointer to UINT*)
	END_VAR
	VAR_OUTPUT
		uiStatus : UINT; (*Status 0 for OK, otherwise <a href="../../Data types and constants/Constants.html"> Error Number </a>*)
	END_VAR
END_FUNCTION_BLOCK
(*Initialize the slave's data units (coils and registers) with values. Coils and Discrete Inputs are initialized with 0, 1, 0... Input registers are filled with 1000, 1001, 1002... Holding registers are initialized with 0, 1, 2... *)

FUNCTION_BLOCK fMBTSFill
	VAR_INPUT
		bEnable : BOOL; (*Enables the function block*)
		udiIdent : UDINT; (*Ident, as provided in instfMBTSOpen.udiIdent *)
	END_VAR
	VAR_OUTPUT
		uiStatus : UINT; (*Status 0 for OK, otherwise <a href="../../Data types and constants/Constants.html"> Error Number </a>*)
	END_VAR
END_FUNCTION_BLOCK
(*Allocates memory and pre-configures Modbus TCP Master. fMBTMOpen() should be called in the INIT section of a task prior to fMBTMaster(). See also fMBTMClose() to close the master in the task's EXIT section. The master connects to the Modbus TCP slave available at the IP address provided by szSlvIPAddr. *)

FUNCTION_BLOCK fMBTMOpen
	VAR_INPUT
		bEnable : BOOL; (*Enables the function block*)
		szSlvIPAddr : STRING[18]; (*Slave's IP address *)
		uiPort : UINT; (*TCP port number (default = 502) *)
		uiRecvTimeout : UINT; (*Timeout to wait for answer from Slave prior to sending new request (default = 500 s) *)
	END_VAR
	VAR_OUTPUT
		udiIdent : UDINT; (*Ident (pointer to memory area holding Modbus Master structure)*)
		uiStatus : UINT; (*Status 0 for OK, otherwise <a href="../../Data types and constants/Constants.html"> Error Number </a>*)
	END_VAR
END_FUNCTION_BLOCK
(*Modbus/TCP master (client) function. fMBTMaster() should be called in the CYCLIC section of a task after being configured by fMBTMOpen(). The master is closed by fMBTMClose(). This master writes to or reads from a slave running fMBTSlave() or other widely available Modbus over TCP slave programs. *)

FUNCTION_BLOCK fMBTMaster
	VAR_INPUT
		bEnable : BOOL; (*Enables the function block*)
		udiIdent : UDINT; (*Ident, as provided in instfMBTMOpen.udiIdent *)
	END_VAR
	VAR_OUTPUT
		uiStep : UINT; (*Step executed by Master. Useful to monitor execution. *)
		uiTxID : UINT; (*Transaction ID *)
		usiMBFuncCode : USINT; (*Modbus function code *)
		szMsg : STRING[100]; (*Status from the TCPClient functions*)
		usiRxByteCnt : USINT; (*Number of bytes received from slave. See response byte count in Modbus protocol. *)
		uiStatus : UINT; (*Status 0 for OK, otherwise <a href="../../Data types and constants/Constants.html"> Error Number </a>*)
	END_VAR
END_FUNCTION_BLOCK
(*Terminates a Modbus/TCP master (client) and releases allocated memory. fMBTMClose() should be called in the EXIT section of a task. See also fMBTMOpen() and fMBTMaster(). *)

FUNCTION_BLOCK fMBTMClose
	VAR_INPUT
		bEnable : BOOL; (*Enables the function block*)
		udiIdent : UDINT; (*Ident, as provided in instfMBTMOpen.udiIdent *)
	END_VAR
	VAR_OUTPUT
		uiStatus : UINT; (*Status 0 for OK, otherwise <a href="../../Data types and constants/Constants.html"> Error Number </a>*)
	END_VAR
END_FUNCTION_BLOCK
(*Read/write individual values from/to coils and registers of given unit. The function code to use in member uiFcode of the passed structure is the same as for Modbus (0x01..0x06,0x0F,0x10,0x17).*)

FUNCTION_BLOCK fMBTMRW
	VAR_INPUT
		bEnable : BOOL; (*Enables the function block*)
		udiIdent : UDINT; (*Ident from fMBTMOpen*)
		usiFCode : USINT; (*Modbus function code, see <a href="../../Data types and constants/Constants.html">constants</a>*)
		usiUnit : USINT; (*Slave unit*)
		uiReadAddr : UINT; (*Element in coil or register for read access*)
		uiReadQty : UINT; (*Quantity of coils/regs to read*)
		puiReadVal : REFERENCE TO UINT; (*Requested read value, pointer to UINT*)
		uiWriteAddr : UINT; (*Element in coil or register for write access*)
		uiWriteQty : UINT; (*Quantity of coils/regs to write*)
		puiWriteVal : REFERENCE TO UINT; (*Requested write value, pointer to UINT*)
		bPoll : BOOL; (*Poll slave repeatedly (0 = single request)*)
		udiPollPeriod : UDINT; (*Polling period in ms*)
	END_VAR
	VAR_OUTPUT
		bRecvOK : BOOL; (*Confirms requested data was sent by slave*)
		uiStatus : UINT; (*Status 0 for OK, otherwise <a href="../../Data types and constants/Constants.html"> Error Number </a>*)
	END_VAR
END_FUNCTION_BLOCK
