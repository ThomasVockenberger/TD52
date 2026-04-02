/***********************************************************************************
* Name      : jwaslib2
* Titel     : Sonderfunktionen erstellt für Modulsteuerung
* Version   : V1.40
* Datum     : 18.02.2004
*
* History   :
*  V1.00	  23.12.1998,fw		erstellt
*  V1.20	  14.04.1999,fw		neue Funktionen, ueberarbeiten der alten Funktionen
*  V1.31	  24.09.2003,TEE/TW Einbindung in Librarymanager
*  V1.40	  18.02.2004,TEE/TW Neue Funktionsblock AlarmSequence unter amm_seq.c hinzugefügt
*  V1.50	  08.08.2017,FW Für GCC 4.1.2 adaptiert
*  V2.00    26.06.2018,FW, datatype changed from signed short to float in polygon FUBs
*
* Hinweis	: Bei der Strukturdefinition ist folgendes zu beachten:
* 				Alle nicht-boolschen Elemente eines FUB muessen vor den boolschen
*				Elementen in der Reihenfolge Input, Output, Statisch definiert werden.
*
***********************************************************************************/

#include <bur/plc.h>
#include <bur/plctypes.h>
#include <JWASLIB2.h>

/***********************************************************************************
* AND for data type ARRAY OF 16 BOOL
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	01-04-99	Thaler, generated from FB219
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
***********************************************************************************/
signed short and_16b(UDINT I1, UDINT I2, UDINT Q)
{
	signed short	x;
	BOOL *i1, *i2, *q;
	
	i1 = (BOOL*)I1;
	i2 = (BOOL*)I2;
	q = (BOOL*)Q;
	
	for (x=1; x<=16; x++)
		q[x] = i1[x] & i2[x];
	return 0;
}

/*******************************************************************************
* AND NOT for data type ARRAY OF 16 BOOL
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	01-04-99	Thaler, generated from FB220
*		13-04-99	Thaler, name changed
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short andnt_16b(UDINT I1, UDINT I2N, UDINT Q)
{
	signed short	x;
	BOOL *i1, *i2n, *q;
	
	i1 = (BOOL*)I1;
	i2n = (BOOL*)I2N;
	q = (BOOL*)Q;
	
	for (x=1; x<=16; x++)
		q[x] = i1[x] & !i2n[x];
	return 0;
}

/*******************************************************************************
* Compress an ARRAY OF 16 BOOL
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	01-04-99	Thaler, generated from FB192
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short compr_16b(UDINT IN, UDINT Q)
{
	signed short	a, x;
	BOOL	*in, *q;

	in = (BOOL*)IN;
	q = (BOOL*)Q;
	
	for (x=1; x<=16; x++)
		q[x] = 0;
	
	a = 1;
	
	for (x=1; x<=16; x++)
	{
		if (in[x])
		{
			q[a] = 1;
			a++;
		}
	}
	return 0;
}

/*******************************************************************************
* Type conversion with min- / max-limitation
* Copyright 1998 - 1999 Jenbacher AG
* 
* History:
* -------
* V0.1	31-03-99	Thaler, generated from FB200
*		13-04-99	Thaler, name changed
* V0.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short i32_t_i16(signed long IN)
{
	signed long	mn = -32768;
	signed long	mx = 32767;
	
	if (IN < mn)
		IN = mn;
	else if (IN > mx)
		IN = mx;
	
	return (short)(IN);
}

/*******************************************************************************
* Max input channel of an ARRAY OF 16 DINT, result as BOOL
* Copyright 1998 - 1999 Jenbacher AG
* 
* History:
* -------
* V0.1	01-04-99	Thaler, generated from FB207
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short max_16di(UDINT EN, UDINT IN, UDINT Q)
{
	signed short	x;
	signed short	b = 0;
	signed long		d = 0x80000000;
	BOOL	*en, *q;
	DINT	*in;
	
	en = (BOOL*)EN;
	in = (DINT*)IN;
	q = (BOOL*)Q;
	
	for (x=1; x<=16; x++)
		q[x] = 0;

	for (x=1; x<=16; x++)
	{
		if (en[x])
		{
			if (in[x] >= d)
			{
				d = in[x];
				b = x;
			}
		}
	}
	
	q[b] = 1;
	return 0;
}

/*******************************************************************************
* Max input channel of an ARRAY OF 16 BOOL, result as BOOL
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	01-04-99	Thaler, generated
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short max_b_16b(UDINT IN, UDINT Q)
{
	signed short	x;
	BOOL	*in, *q;
	
	in = (BOOL*)IN;
	q = (BOOL*)Q;
	
	for (x=1; x<=16; x++)
		q[x] = 0;
	
	x = 16;
	while ((in[x]==0) && (x!=0))
		x--;

	if (x)
		q[x] = 1;
	return 0;
}

/*******************************************************************************
* Max input channel of an ARRAY OF 16 BOOL, result as INT
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	16-11-98	Thaler, generated from FB222
*		02-04-99	Thaler, name of VAR_INPUT modified
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short max_i_16b(UDINT IN)
{
	signed short	x;
	signed short	MAX_I_16b = 0;
	BOOL	*in;
	
	in = (BOOL*)IN;
	
	for (x=1; x<=16; x++)
	{
		if (in[x])
		{
			MAX_I_16b = x;
		}
	}
	return MAX_I_16b;
}
/*******************************************************************************
* Min input channel of an ARRAY OF 16 DINT, result as BOOL
* Copyright 1998 - 1999 Jenbacher AG
* 
* History:
* -------
* V0.1	01-04-99	Thaler, generated from FB207
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short min_16di(UDINT EN, UDINT IN, UDINT Q)
{
	signed short	x;
	signed short	b = 0;
	signed long		d = 0x7FFFFFFF;
	BOOL	*en, *q;
	DINT	*in;
	
	en = (BOOL*)EN;
	in = (DINT*)IN;
	q = (BOOL*)Q;
	
	for (x=1; x<=16; x++)
		q[x] = 0;

	for (x=1; x<=16; x++)
	{
		if (en[x])
		{
			if (in[x] <= d)
			{
				d = in[x];
				b = x;
			}
		}
	}
	
	q[b] = 1;
	return 0;
}

/*******************************************************************************
* Min input channel of an ARRAY OF 16 BOOL, result as BOOL
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	01-04-99	Thaler, generated from FB191
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short min_b_16b(UDINT IN, UDINT Q)
{
	signed short	x;
	BOOL	*in, *q;
	
	in = (BOOL*)IN;
	q = (BOOL*)Q;
	
	for (x=1; x<=16; x++)
		q[x] = 0;
	
	for (x=1; x<=16; x++)
	{
		if (in[x])
		{
			q[x] = 1;
			break;
		}
	}
	return 0;
}

/*******************************************************************************
* Min input channel of an ARRAY OF 16 BOOL, result as INT
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	16-11-98	Thaler, generated from FB222
*		02-04-99	Thaler, name of VAR_INPUT modified
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short min_i_16b(UDINT IN)
{
	signed short	x;
	signed short	MIN_I_16b = 0;
	BOOL	*in;
	
	in = (BOOL*)IN;
	
	for (x=1; x<=16; x++)
	{
		if (in[x])
		{
			MIN_I_16b = x;
			break;
		}
	}
	return MIN_I_16b;
}

/*******************************************************************************
* NOT for data type ARRAY OF 16 BOOL
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	01-04-99	Thaler, generated
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short not_16b(UDINT IN, UDINT Q)
{
	signed short	x;
	BOOL	*in, *q;
	
	in = (BOOL*)IN;
	q = (BOOL*)Q;
	
	for (x=1; x<=16; x++)
		q[x] = !in[x];
	return 0;
}

/*******************************************************************************
* OR for data type ARRAY OF 16 BOOL
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	01-04-99	Thaler, generated
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short or_16b(UDINT I1, UDINT I2, UDINT Q)
{
	signed short	x;
	BOOL *i1, *i2, *q;
	
	i1 = (BOOL*)I1;
	i2 = (BOOL*)I2;
	q = (BOOL*)Q;
	
	for (x=1; x<=16; x++)
		q[x] = i1[x] | i2[x];
	return 0;
}

/*******************************************************************************
* OR NOT for data type ARRAY OF 16 BOOL
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	02-04-99	Thaler, generated
*		13-04-99	Thaler, name changed
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short ornt_16b(UDINT I1, UDINT I2N, UDINT Q)
{
	signed short	x;
	BOOL *i1, *i2n, *q;
	
	i1 = (BOOL*)I1;
	i2n = (BOOL*)I2N;
	q = (BOOL*)Q;
	
	for (x=1; x<=16; x++)
		q[x] = i1[x] | !i2n[x];
	return 0;
}

/*******************************************************************************
* Characteristic: polygon with 2 angles, high_limitation , low_limitation
*                 conditions: x1 < x2
*            
*          y |
*            |
*         y2 +          .****
*            |        .
*            |      .
*         y1 + ****
*            |
*            +----+------+----
*                 x1     x2  x
*
* Copyright 1998 - 1999 Jenbacher AG
* 
* History:
* -------
* V0.1	07-04-99	Thaler, generated from FB230
*		13-04-99	Thaler, name changed
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
* V2.00 26-06-2018  FW, datatypes of function changed from signed short to float
*
* Outstandings:
* ------------
*
*******************************************************************************/
float polyg_2hl(float x, UDINT coord)
{
	float		xL, xH, yL, yH, y;
	float		a, d;
	signed long		mn = -32768;
	signed long		mx = 32767;
	coordinate_5	*COORD;
	
	COORD = (coordinate_5*)coord;
	
	xL = COORD->x1;
	xH = COORD->x2;
	yL = COORD->y1;
	yH = COORD->y2;
	
	if (x <= xL)
		y = yL;
	else if (x >= xH)
		y = yH;
	else
	{
		a = (yH - yL) * (x - xL);
		if (xH != xL)
			d = yL + a / (xH - xL);
		else
			d = yL;
		/* min/max limitation */
		if (d < mn)
			d = mn;
		else if (d > mx)
			d = mx;

		y = d;
	}
	return y;
}

/*******************************************************************************
* Characteristic: polygon with 3 angles, high_limitation, low_limitation
*                 conditions: x1 < x2 < x3
*
*          y |               
*            |             
*         y3 +          .****
*         :  |        .
*         :  |      .
*         y1 + ****
*            |
*            +----+------+----
*                 x1 ... x3  x
*
* Copyright 1998 - 1999 Jenbacher AG
* 
* History:
* -------
* V0.1	07-04-99	Thaler, generated from FB43
*		13-04-99	Thaler, name changed
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
* V2.00 26-06-2018  FW, datatypes of function changed from signed short to float
*
* Outstandings:
* ------------
*
*******************************************************************************/
float polyg_3hl(float x, UDINT coord)
{
	float			xL, xH, yL, yH, y;
	float			a, d;
	signed long		mn = -32768;
	signed long		mx = 32767;
	coordinate_5	*COORD;
	
	COORD = (coordinate_5*)coord;
	
	if (x >= COORD->x2)
	{
		xL = COORD->x2;
		xH = COORD->x3;
		yL = COORD->y2;
		yH = COORD->y3;
	}
	else
	{
		xL = COORD->x1;
		xH = COORD->x2;
		yL = COORD->y1;
		yH = COORD->y2;
	}
	
	if (x <= xL)
		y = yL;
	else if (x >= xH)
		y = yH;
	else
	{
		a = (yH - yL) * (x - xL);
		if (xH != xL)
			d = yL + a / (xH - xL);
		else
			d = yL;
		/* min/max limitation */
		if (d < mn)
			d = mn;
		else if (d > mx)
			d = mx;

		y = d;
	}
	return y;
}

/*******************************************************************************
* Characteristic: polygon with 5 angles, low_limitation
*                 conditions: x1 < x2 < x3 < x4 < x5
*            
*          y |              .
*            |            .
*         y5 +          .
*         :  |        .
*         :  |      .
*         y1 + ****
*            |
*            +----+------+----
*                 x1 ... x5  x
*
* Copyright 1998 - 1999 Jenbacher AG
* 
* History:
* -------
* V0.1	07-04-99	Thaler, generated from FB42
*		13-04-99	Thaler, name changed
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
* V2.00 26-06-2018  FW, datatypes of function changed from signed short to float
*
* Outstandings:
* ------------
*
*******************************************************************************/
float polyg_5l(float x, UDINT coord)
{
	float			xL, xH, yL, yH, y;
	float			a, d;
	signed long		mn = -32768;
	signed long		mx = 32767;
	coordinate_5	*COORD;
	
	COORD = (coordinate_5*)coord;
	
	if (x >= COORD->x4)
	{
		xL = COORD->x4;
		xH = COORD->x5;
		yL = COORD->y4;
		yH = COORD->y5;
	}
	else if (x >= COORD->x3 && x < COORD->x4)
	{
		xL = COORD->x3;
		xH = COORD->x4;
		yL = COORD->y3;
		yH = COORD->y4;
	}
	else if (x >= COORD->x2 && x < COORD->x3)
	{
		xL = COORD->x2;
		xH = COORD->x3;
		yL = COORD->y2;
		yH = COORD->y3;
	}
	else
	{
		xL = COORD->x1;
		xH = COORD->x2;
		yL = COORD->y1;
		yH = COORD->y2;
	}
	
	if (x <= xL)
		y = yL;
	else
	{
		a = (yH - yL) * (x - xL);
		if (xH != xL)
			d = yL + a / (xH - xL);
		else
			d = yL;
		/* min/max limitation */
		if (d < mn)
			d = mn;
		else if (d > mx)
			d = mx;

		y = d;
	}
	return y;
}

/*******************************************************************************
* Sum across an ARRAY OF 16 BOOL
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	16-11-98	Thaler, generated from FB206
*		02-04-99	Thaler, name of VAR_INPUT modified
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short sum_16b(UDINT IN)
{
	signed short	x;
	signed short	SUM_16b = 0;
	BOOL	*in;
	
	in = (BOOL*)IN;
	
	for (x=1; x<=16; x++)
	{
		if (in[x])
		{
			SUM_16b = SUM_16b + 1;
		}
	}
	return SUM_16b;
}

/*******************************************************************************
* XOR for data type ARRAY OF 16 BOOL
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	01-04-99	Thaler, generated
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short xor_16b(UDINT I1, UDINT I2, UDINT Q)
{
	signed short	x;
	BOOL *i1, *i2, *q;
	
	i1 = (BOOL*)I1;
	i2 = (BOOL*)I2;
	q = (BOOL*)Q;
	
	for (x=1; x<=16; x++)
		q[x] = i1[x] ^ i2[x];
	return 0;
}

/*******************************************************************************
* XOR NOT for data type ARRAY OF 16 BOOL
* Copyright 1998 - 1999 Jenbacher Werke AG
* 
* History:
* -------
* V0.1	02-04-99	Thaler, generated
*		13-04-99	Thaler, name changed
* V1.50 08-08-2017  FW, adapted for GCC 4.1.2
*
* Outstandings:
* ------------
*
*******************************************************************************/
signed short xornt_16b(UDINT I1, UDINT I2N, UDINT Q)
{
	signed short	x;
	BOOL *i1, *i2n, *q;
	
	i1 = (BOOL*)I1;
	i2n = (BOOL*)I2N;
	q = (BOOL*)Q;
	
	for (x=1; x<=16; x++)
		q[x] = i1[x] ^ !i2n[x];
	return 0;
}
