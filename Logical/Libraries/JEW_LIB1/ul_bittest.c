/***********************************************************************************
* Name      : ul_BitTest.c
* Titel     : Prüfen einer Bit-Stelle eines unsigned long auf TRUE
* Version   : V1.0
* Datum     : 09.12.2022
*
* Uebergabe : In				UDINT			Wert mit zu püfender Bit Stelle
*			: BitNr				USINT			Bit Stelle die geprüft werden soll
*
* Rueckgabe : function			BOOL			FALSE = Bitstelle ist FALSE 
*												TRUE  = Bitstelle ist TRUE
*
* History   :
* V1.0	09.12.2022	Andre,	Created based on us_BitTest.c
*
***********************************************************************************/
#include <jew_lib1.h>

plcbit ul_BitTest(unsigned long In, unsigned char BitNr)
{
	return  ((In >> BitNr) & 1) != 0;
}
