/******************************************************************************
 * Copyright:    B&R Industrie-Automation AG
 *
 * Project:      Library MBTCP
 *
 * Target:       B&R-PCC
 *
 * Filename:     Convert.c
 * 
 * Function:     module-description
 *
 * Dependencies: description of all dependencies
 *
 ******************************************************************************
 * History:
 *
 * Version | Date        | Author       | Description
 * ----------------------------------------------------------------------------
 *    1.00 | 2012-aug-03 | H.Anderes    | creation
 *****************************************************************************/

/*****************************************************************************
 * includes
 *****************************************************************************/
/* ansi-c import */
/* system import */
#include <bur/plctypes.h>
/* user defined import */
#include "Convert.h"

INT swapINT (INT wInputValue)
{
 return (wInputValue << 8) + (USINT)(wInputValue >> 8);
}

UINT swapUINT (UINT wInputValue)
{
 return (wInputValue << 8) + (USINT)(wInputValue >> 8);
}

/*****************************************************************************
 * END OF CODE
 *****************************************************************************/
