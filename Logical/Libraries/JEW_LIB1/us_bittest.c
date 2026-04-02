/***********************************************************************************
* Name      : us_BitTest.c
* Titel     : Prüfen einer Bit-Stelle eines unsigned short auf TRUE
* Version   : V1.0
* Datum     : 15.09.2001
*
* Uebergabe : In				UINT			Wert mit zu püfender Bit Stelle
*			: BitNr				USINT			Bit Stelle die geprüft werden soll
*
* Rueckgabe : function			BOOL			FALSE = Bitstelle ist FALSE 
*												TRUE  = Bitstelle ist TRUE
*
* History   :
*  V1.00	  15.09.2001,Fa			erstellt
*  V1.70	  17.06.2002,WeitzerT	bei jewlib1.h <> statt "" 
*
***********************************************************************************/
#include <jew_lib1.h>

plcbit us_BitTest(unsigned short In, unsigned char BitNr)
{
	return  ((In >> BitNr) & 1) != 0;
}
