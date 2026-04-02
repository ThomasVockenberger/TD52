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
 * Filename:     MBTMaster.h
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
 *    1.00 | 2008-Sep-30 | H.Anderes    | creation
 *****************************************************************************/

/*****************************************************************************
 * includes
 *****************************************************************************/
#ifndef MBTMASTER_H_
#define MBTMASTER_H_
/* ansi-c import */
#include <string.h>
/* system import */
#include <bur/plc.h>                         /* IEC data types */
#include <asstring.h>
#include <brsystem.h>
#include <astcp.h>
#include <convert.h>
#include <sys_lib.h>
/* user defined import */
#include "MBTCP.h"

/*#define _MBTCP_LOGGER_DEBUG*/    /* if defined, errors are logged into the logger */ 
/*#define _MBTCP_LOGGER_EVENT*/    /* if defined, events are logged into the logger */ 

#ifdef __i386__
#define SWAPUINT        swapUINT
#define SWAPINT         swapINT
#else
#define SWAPUINT
#define SWAPINT
#endif

/*****************************************************************************
 * constants / macros
 *****************************************************************************/
#define NELEMS(array)           (sizeof(array) / sizeof(array[0]))
/* Booleans, switches
 */
enum {
  FALSE                   = 0,
  TRUE                    = 1,
  EXIT_FAILURE            = 1,
  ON                      = 0xFF00,
  OFF                     = 0x0000  
};

#define MAX_COILS    2000
#define MAX_REGISTER 127
/*****************************************************************************
 * type definitions
 *****************************************************************************/
/* STEP values
 */
enum {
  INIT                    = 0,
  WAIT_SERVER             = 5,
  OPEN_PORT               = 10,
  IOCTL                   = 15,
  WAIT_CONNECTION         = 20,
  WAIT_REQUEST            = 30,
  SEND_ANSWER             = 40,
  SEND_REQUEST            = 50,
  WAIT_ANSWER             = 60,
  CLOSE_PORT              = 70,
  FATAL_ERROR0            = 240,
  FATAL_ERROR1            = 241,
  FATAL_ERROR2            = 242,
  FATAL_ERROR3            = 243,
  FATAL_ERROR4            = 244,
  FATAL_ERROR5            = 245,
  FATAL_ERROR6            = 246,
  FATAL_ERROR7            = 247,
  FATAL_ERROR8            = 248,
  FATAL_ERROR9            = 249,
  FATAL_ERROR10           = 250,
  FATAL_ERROR             = 251,
  FINAL_ERROR			  = 252,
  
  DISABLE                 = 65534,
  BUSY                    = 65535
};

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
/* Dimensions
 */
enum {
  MBT_SLAVE_PORT        = 502,
  MAX_OPEN_RETRIES      = 3,
  RECV_TIMEOUT_DFLT     = 500,               /* default timeout */
  IPADDR_L              = 18,
  MAX_NBR_REQUESTS      = 5,                 /* was 20 */
  MAX_BUFFER_LEN        = 1200,/*128,*/
  MESS_LEN              = 100,               /* error message length */
};

/* Datatypes */
typedef struct MBTMasterActionParam_typ
{
  USINT usiFCode;
  USINT usiUnit;
  UINT  uiReadAddr;
  UINT  uiReadQty;
  UDINT puiReadVal;
  UINT  uiWriteAddr;
  UINT  uiWriteQty;
  UDINT puiWriteVal;
  UDINT udiTimer;
} MBTMasterActionParam_typ;

typedef struct MBTMasterActionEnable_typ
{
  BOOL bCyclic;
  BOOL bSingle;
} MBTMasterActionEnable_typ;

typedef struct tstMBT_MData
{
  MBTMasterActionEnable_typ actEnable[MAX_NBR_REQUESTS];
  MBTMasterActionParam_typ actParam[MAX_NBR_REQUESTS];
} tstMBT_MData;


typedef struct
{
  BOOL                  bEnable;
  STRING                slvIPAddr[IPADDR_L];
  UINT                  uiPort;
  UINT                  uiRecvTimeout;
  UDINT                 udiCycleTime;
  tstMBT_MData*         pData;
  UINT                  uiStep;
  TcpOpen_typ           stTcpOpen;
  TcpIoctl_typ          stTcpIoctl;
  TcpClient_typ         stTcpClient;
  TcpSend_typ           stTcpSend;
  TcpRecv_typ           stTcpRecv;
  TcpClose_typ          stTcpClose;
  USINT                 usiLastReq;
  UDINT                 udiRecvTimer;
  UDINT                 udiSendTimer[MAX_NBR_REQUESTS];
  USINT                 usiSendBuf[MAX_BUFFER_LEN];
  USINT                 usiRecvBuf[MAX_BUFFER_LEN];
  BOOL                  bRecvOK;
  UINT                  uiStatus;
  UINT                  uiTxID;
  UDINT                 udiWrongMsg;
  STRING                szMsg[MESS_LEN];
  tcpLINGER_typ         mLinger;
  USINT                 usiOpenRetries;
  USINT                 usiSendCnt;
} tstMBT_MVars;

/*****************************************************************************
 * functions protoytpes
 ****************************************************************************/
void  fMBTMStates(tstMBT_MVars* inst);
UINT create_request_to_server(tstMBT_MVars*   inst,
                               tstMBT_MData*   config,
                               USINT           usiOp,
                               USINT*          usiSendBuf,
                               UINT            uiTxID);
USINT analyze_answer_from_server(tstMBT_MVars* inst, 
                                 tstMBT_MData* config,
                                 USINT         usiOp,
                                 USINT*        usiRecvBuf,
                                 UINT          uiTxID);

/****************************************************************************
 * END OF CODE
 ****************************************************************************/
/*
Local Variables:
c-file-style: bsd
c-basic-offset: 2
comment-column: 45
End:
 */
#endif /* MBTMASTER_H_ */
