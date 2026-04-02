/***********************************************************************************
* Name      : uc_BitTest.c
* Titel     : Prüfen einer Bit-Stelle eines unsigned char auf TRUE
* Version   : V1.0
* Datum     : 05.09.2001
*
* Uebergabe : In				USINT			Wert mit zu püfender Bit Stelle
*			: BitNr				USINT			Bit Stelle die geprüft werden soll
*
* Rueckgabe : function			BOOL			FALSE = Bitstelle ist FALSE 
*												TRUE  = Bitstelle ist TRUE
*
* History   :
*  V1.00	  05.09.2001,Fa			erstellt
*  V1.70	  17.06.2002,WeitzerT	bei jewlib1.h <> statt "" 
*
***********************************************************************************/
#include <jew_lib1.h>

plcbit uc_BitTest(unsigned char In, unsigned char BitNr)
{
	return  ((In >> BitNr) & 1) != 0;
}
