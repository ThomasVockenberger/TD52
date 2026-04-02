/***********************************************************************************
* Name      : us_BitClr.c
* Titel     : Setzen einer Bit-Stelle eines unsigned short auf FALSE
* Version   : V1.0
* Datum     : 15.10.2001
*
* Uebergabe : In				UINT			Wert mit zu setzender Bit Stelle
*			: BitNr				USINT			Bit Stelle die gesetzt werden soll
*
* Rueckgabe : function			UINT			Wert mit gesetzter Bit Stelle
*
* History   :
*  V1.00	  15.10.2001,Fa			erstellt
*  V1.70	  17.06.2002,WeitzerT	bei jewlib1.h <> statt "" 
*
***********************************************************************************/
#include <jew_lib1.h>

unsigned short us_BitClr(unsigned short In, unsigned char BitNr)
{
	return  (In & (~(1 << BitNr)));
}
