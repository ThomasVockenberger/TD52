/***********************************************************************************
* Name      : uc_BitSet.c
* Titel     : Setzen einer Bit-Stelle eines unsigned char auf TRUE
* Version   : V1.0
* Datum     : 11.10.2001
*
* Uebergabe : In				USINT			Wert mit zu setzender Bit Stelle
*			: BitNr				USINT			Bit Stelle die gesetzt werden soll
*
* Rueckgabe : function			USINT			Wert mit gesetzter Bit Stelle
*
* History   :
*  V1.00	  11.10.2001,Fa			erstellt
*  V1.70	  17.06.2002,WeitzerT	bei jewlib1.h <> statt "" 
*
***********************************************************************************/
#include <jew_lib1.h>

unsigned char uc_BitSet(unsigned char In, unsigned char BitNr)
{
	return  ( In | (1 << BitNr));
}
