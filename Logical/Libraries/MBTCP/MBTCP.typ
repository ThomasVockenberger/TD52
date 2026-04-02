(********************************************************************
 * COPYRIGHT -- Bernecker + Rainer
 ********************************************************************
 * Library: MBTCP
 * File: MBTCP.typ
 * Author: B&R
 * Created: September 04, 2008
 ********************************************************************
 * Data types of library MBTCP
 ********************************************************************)
(*Client informationen*)

TYPE
	tstclient_info : 	STRUCT  (*Client information*)
		udiIdent : UDINT; (*Client Indentifier*)
		usiPort : USINT; (*Client Port*)
		szIp_addr : STRING[18]; (*Client IP- Adresse*)
		szMsg : STRING[100]; (*Client Message*)
	END_STRUCT;
END_TYPE
