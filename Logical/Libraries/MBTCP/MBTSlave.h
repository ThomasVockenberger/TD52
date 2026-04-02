/*****************************************************************************
 * Copyright:    B&R Industrie-Automation AG
 *
 * Project:      Library MBTCP
 *
 * Target:       B&R-PCC
 *
 * AR-Version:   B 2.01
 *
 * AS-Version:   V 3.0.71.16.SP01
 *
 * Filename:     MBTSlave.h
 * 
 * Function:     module-description
 *
 * Dependencies: description of all dependencies
 *
 *****************************************************************************
 * History:
 *
 * Version | Date        | Author      | Description
 * --------------------------------------------------------------------------
 *    1.00 | 2008-sep-19 | H.Anderes    | creation
 *****************************************************************************/

/*****************************************************************************
 * includes
 *****************************************************************************/
#ifndef MBTSLAVE_H_
#define MBTSLAVE_H_
 
 
/* ansi-c import */
#include <string.h>
/* system import */
#include <bur/plc.h>                         /* IEC data types */
#include <asstring.h>
#include <astcp.h>
#include <convert.h>
#include <sys_lib.h>
#include <standard.h>                        /* used for POF() timer */
/* user defined import */
#include "MBTCP.h"


/*#define _MBTCP_LOGGER_DEBUG*/ /* if defined, errors are logged into the logger */ 
/*#define _MBTCP_LOGGER_EVENT*/ /* if defined, events are logged into the logger */ 
 

#ifdef __i386__
#define SWAPUINT        swapUINT
#define SWAPINT         swapINT
#define BYTE_OFFSET     0
#else
#define SWAPUINT
#define SWAPINT
#define BYTE_OFFSET     1
#endif

/*****************************************************************************
 * constants / macros
 *****************************************************************************/
#define NELEMS(array)           (sizeof(array) / sizeof(array[0]))
#define FALSE           0
#define TRUE            1

/* length of the request */
#define REQ_LEN_READ_COILS                      6
#define REQ_LEN_READ_DISCRETE_INPUTS            6
#define REQ_LEN_READ_HOLDING_REGISTERS          6
#define REQ_LEN_READ_INPUT_REGISTERS            6
#define REQ_LEN_WRITE_SINGLE_COIL               6
#define REQ_LEN_WRITE_SINGLE_REGISTER           6
#define REQ_LEN_WRITE_MULTIPLE_COILS            7
#define REQ_LEN_WRITE_MULTIPLE_REGISTERS        7
#define REQ_LEN_READ_WRITE_MULTIPLE_REGISTERS   11

#define MAX_COILS            2000
#define MAX_DISCRETE_INPUTS  2000
#define MAX_HOLDING_REGISTER 127
#define MAX_INPUT_REGISTER   127
/*****************************************************************************
 * type definitions
 *****************************************************************************/
/*
 * STEP values
 */
enum {
  MBCONF                = 1,
  INIT                  = 5,
  DISABLE               = 65534,
  OPEN_PORT             = 10,
  IOCTL                 = 15,
  WAIT_REQUEST          = 30,
  IOCTL_CLIENT          = 35,
  CLOSE_SLAVE           = 111,
  FATAL_ERROR0          = 240,
  FATAL_ERROR1          = 241,
  FATAL_ERROR2          = 242,
  FATAL_ERROR3          = 243,
  FATAL_ERROR4          = 244,
  FATAL_ERROR5          = 245,
  FATAL_ERROR6          = 246,
  FATAL_ERROR7          = 247,
  FATAL_ERROR8          = 248,
  FINAL_ERROR			        = 249
};

/*
 * Client Handler STEP values
 */
enum {
  enMBTCP_CLT_HANDLER_W4_REQUEST      = 0,
  enMBTCP_CLT_HANDLER_SEND_RESPONSE   = 1,
  enMBTCP_CLT_HANDLER_DISCONNECT      = 2
};

/* Booleans, switches
 */
enum {
  EXIT_FAILURE          = 1,
  ON                    = 0xFF00,
  OFF                   = 0x0000  
};

/* Dimensions
 */
enum {
  MBT_SLAVE_PORT        = 502,
  MAX_OPEN_RETRIES      = 3,
  MBT_MAX_UNITS         = 300,
  NUNITS_DEF            = 1,             /* default num of Modbus units */
  OFFSET_NUNITS_DEF		   = 0,             /* default offset of Modnus units */
  MAX_CLIENT_REQUEST    = 5, 
  MAX_CLIENT            = 5,
  MAX_CLOSE_LOOPS       = 1000,
  TIMEOUT_MS            = 1500,          /* receive TOF delay, in ms */
  MAX_RECV_BUFFER_LEN   = 1500,          /* was 128, max protocol = 260 bytes * 5 (Requests)*/
  MAX_SEND_BUFFER_LEN   = 300,           /* was 128, max protocol = 260 bytes */
  IPADDR_L              = 18,
  MESS_LEN              = 100,           /* error message length */
  HEADER_LEN            = 6,             /* Modbus header (MBAP) length */
  MIN_FRAME_LEN         = HEADER_LEN + 2 /* see analyze_req_from_client() */
};
/* MIN_FRAME_LEN = 
   6 bytes for HEADER_LEN, Modbus Application Protocol (MBAP) header:
     bytes 0,1: transaction ID, incremented by client at every request
     bytes 2,3: protocol ID: 0x00 00 for ModbusTCP
     bytes 4,5: number of bytes in message to follow (0 to 252 bytes)
   1 byte:  server/slave unit ID (compulsory value)
   1 byte:  function code as defined in Modbus standard
   See also: http://www.scorpioncontrols.com/info/modbustcp.htm
             http://www.simplymodbus.ca/TCP.htm
             http://www.digitalbond.com/wiki/index.php/Modbus_TCP
             Page 5 of Modbus Application Protocol spec. V1.1b
*/

/* Modbus function codes
 */
enum {
  READ_COILS                            = 0x01,
  READ_DISCRETE_INPUTS                  = 0x02,
  READ_HOLDING_REGISTERS                = 0x03,
  READ_INPUT_REGISTERS                  = 0x04,
  WRITE_SINGLE_COIL                     = 0x05,
  WRITE_SINGLE_REGISTER                 = 0x06,
  WRITE_MULTIPLE_COILS                  = 0x0F,
  WRITE_MULTIPLE_REGISTERS              = 0x10,
  READ_WRITE_MULTIPLE_REGISTERS         = 0x17
};

/* Modbus protocol exception codes
 */
enum {
  MB_ILLEGAL_FUNCTION                   = 0x01,
  MB_ILLEGAL_DATA_ADDRESS               = 0x02,
  MB_ILLEGAL_DATA_VALUE                 = 0x03,
  MB_SLAVE_DEVICE_FAILURE               = 0x04,
  MB_ACKNOWLEDGE                        = 0x05,
  MB_SLAVE_DEVICE_BUSY                  = 0x06,
  MB_MEMORY_PARITY_ERROR                = 0x08,
  MB_GATEWAY_PATH_UNAVAILABLE           = 0x0A,
  MB_GATEWAY_TARGET_DEV_FAILED_RESPOND  = 0x0B
};

enum {
  mbtERR_NUM_BASE       = 50000 /* Modbus exceptions get added to this value */ 
};

typedef struct
{
  UINT  uiTxID;
  UINT  uiProtocolID;
  UINT  length;
  USINT usiUnit;
  USINT usiFCode;
} t_client_request;

typedef struct
{
  UINT  uiAddr;              /* starting address */
  UINT  uiQty;               /* quantity of coils, registers, etc. */
} t_read_request;

typedef struct
{
  UINT  uiAddr;              /* starting address */
  UINT  uiVal;
} t_single_write_request;

typedef struct
{
  UINT  uiAddr;
  UINT  uiQty;
  USINT usiByteNr;
} t_multiple_write_request;

typedef struct
{
  UINT  uiReadAddr;
  UINT  uiReadQty;
  UINT  uiWriteAddr;
  UINT  uiWriteQty;
  USINT usiByteNr;
} t_multiple_read_write_request;


typedef BOOL tCOIL;
typedef BOOL tDINP;
typedef UINT tIREG;
typedef UINT tHREG;

typedef struct
{
  UINT uiNbrCoils;
  UINT uiNbrDiscreteInputs;
  UINT uiNbrInputRegs;
  UINT uiNbrHoldingRegs;
  BOOL bCoilsExtern;
  BOOL bDiscreteInputsExtern;
  BOOL bInputRegsExtern;
  BOOL bHoldingRegsExtern; 
  tCOIL *pCoils;
  tDINP *pDiscreteInputs;
  tIREG *pInputRegs;
  tHREG *pHoldingRegs;
} tstMBT_SUnit;

typedef struct
{
  UINT uiNbrUnits;
  UINT uiOffsetUnits;
  tstMBT_SUnit stUnit[MBT_MAX_UNITS];
} tstMBT_SData;


 typedef struct recv_buff_typ 
 { 
   USINT byte[MAX_RECV_BUFFER_LEN]; 
 } recv_buff_typ; 

 typedef struct send_buff_typ 
 { 
   USINT byte[MAX_SEND_BUFFER_LEN];
   UINT  uiTxID;
   UINT  uiSendByte;
   UINT  uiReqLength;     
 } send_buff_typ; 

typedef struct 
{ 
  BOOL                 bEnable; 
  tstMBT_SData*        pData; 
  UINT                 uiStep; 
  UINT                 uiReturnStep; 
  USINT                usiCltNr;     /* how many clients connected */ 
  USINT                usiCltServed; /* client currently served */ 
  tstclient_info       cltInfo[MAX_CLIENT]; 
  USINT                cltAddr[IPADDR_L]; 
  UINT                 uiPort; 
  TcpOpen_typ          stTcpOpen; 
  TcpIoctl_typ         stTcpIoctl; 
  TcpServer_typ        stTcpServer; 
  TcpSend_typ          stTcpSend[MAX_CLIENT]; 
  TcpRecv_typ          stTcpRecv[MAX_CLIENT]; 
  TcpClose_typ         stTcpClose[MAX_CLIENT]; 
  TOF_typ              TOFRecv[MAX_CLIENT];
  send_buff_typ        stSendBuf[MAX_CLIENT][MAX_CLIENT_REQUEST];
  USINT                usiReqIdx[MAX_CLIENT_REQUEST];
  recv_buff_typ        stRecvBuf[MAX_CLIENT]; /* all request are received in one buffer */ 
  USINT                usiNbrReq;
  UINT                 uiStatus; 
  STRING               szMsg[MESS_LEN];
  BOOL                 bClosing;
  tcpLINGER_typ        sLinger;
  UINT                 uiStepCltHandler[MAX_CLIENT];
  /*Additional Data*/ 
  USINT				            usiOpenRetries;
  UDINT				            udiRecvCnt;
  UDINT				            udiSendCnt;	
  UINT				             uiOffsetUnits;
} tstMBT_SVars; 


/*****************************************************************************
 * functions protoytpes
 ****************************************************************************/
UINT arr_alloc                    (UDINT size, UDINT* p_reg);
UINT fMBTSStates                  (tstMBT_SVars* inst);
UINT add_client                   (tstMBT_SVars* inst);
void remove_client                (tstMBT_SVars* inst, USINT client);
void recv_client                  (tstMBT_SVars* inst, UINT i);
void send_response                (tstMBT_SVars* inst, UINT i);
void disconnect_client            (tstMBT_SVars* inst, UINT i);
void client_handler               (tstMBT_SVars* inst);
UINT analyze_req_from_client      (tstMBT_SVars* inst, USINT client);
void create_exception_response    (tstMBT_SVars* inst, USINT client, USINT req, UINT reqOffset, USINT excode);
void read_discrete_inputs         (tstMBT_SVars* inst, USINT client, USINT req, UINT reqOffset);
void read_coils                   (tstMBT_SVars* inst, USINT client, USINT req, UINT reqOffset);
void read_holding_registers       (tstMBT_SVars* inst, USINT client, USINT req, UINT reqOffset);
void read_input_registers         (tstMBT_SVars* inst, USINT client, USINT req, UINT reqOffset);
void write_single_coil            (tstMBT_SVars* inst, USINT client, USINT req, UINT reqOffset);
void write_single_register        (tstMBT_SVars* inst, USINT client, USINT req, UINT reqOffset);
void write_multiple_coils         (tstMBT_SVars* inst, USINT client, USINT req, UINT reqOffset);
void write_multiple_registers     (tstMBT_SVars* inst, USINT client, USINT req, UINT reqOffset);
void read_write_multiple_registers(tstMBT_SVars* inst, USINT clt, USINT req, UINT reqOffset);
void mberror                      (tstMBT_SVars* inst);
void mberror_client               (tstMBT_SVars* inst, USINT clt);
void exit (void) __attribute__ ((__noreturn__));

/*****************************************************************************
 * END OF CODE
 *****************************************************************************/
/*
Local Variables:
c-file-style: bsd
c-basic-offset: 2
comment-column: 45
End:
 */
#endif /* MBTSLAVE_H_ */
