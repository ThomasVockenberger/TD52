/***********************************************************************************
* Name      : uc_BitClr.c
* Titel     : Setzen einer Bit-Stelle eines unsigned char auf FALSE
* Version   : V1.0
* Datum     : 15.10.2001
*
* Uebergabe : In				USINT			Wert mit zu setzender Bit Stelle
*			: BitNr				USINT			Bit Stelle die gesetzt werden soll
*
* Rueckgabe : function			USINT			Wert mit gesetzter Bit Stelle
*
* History   :
*  V1.00	  15.10.2001,Fa			erstellt
*  V1.70	  17.06.2002,WeitzerT	bei jewlib1.h <> statt "" 
*
***********************************************************************************/
#include <jew_lib1.h>

unsigned char uc_BitClr(unsigned char In, unsigned char BitNr)
{
	return  (In & (~(1 << BitNr)));
}
