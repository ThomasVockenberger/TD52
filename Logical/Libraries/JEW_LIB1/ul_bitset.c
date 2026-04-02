/***********************************************************************************
* Name      : ul_BitSet.c
* Titel     : Setzen einer Bit-Stelle eines unsigned long auf TRUE
* Version   : V1.0
* Datum     : 17.10.2022
*
* Uebergabe : In				UDINT			Wert mit zu setzender Bit Stelle
*			: BitNr				USINT			Bit Stelle die gesetzt werden soll
*
* Rueckgabe : function			UDINT			Wert mit gesetzter Bit Stelle
*
* History   :
*  V1.00	  17.10.2022 Racero, Guillermo     Created based on us_BitSet.c    
*
***********************************************************************************/
#include <jew_lib1.h>

unsigned long ul_BitSet(unsigned long In, unsigned char BitNr)
{
	return  ( In | (1 << BitNr));
}
