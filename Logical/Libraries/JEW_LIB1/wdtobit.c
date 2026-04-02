/***********************************************************************************
* Name      : WDtoBIT.c
* Titel     : Ein Word(2Byte) auf 16 Bits dekomprimieren
* Version   : V1.00
* Datum     : 09.11.1998
*
* Uebergabe : Word 		UINT	Kompriemiertes Ausgangsabbild
*
* Rueckgabe : Bit00		BOOL	Bit 00 des Eingangswortes
*			  Bit01		BOOL	Bit 01 des Eingangswortes
*			  Bit02		BOOL	Bit 02 des Eingangswortes
*			  Bit03		BOOL	Bit 03 des Eingangswortes
*			  Bit04		BOOL	Bit 04 des Eingangswortes
*			  Bit05		BOOL	Bit 05 des Eingangswortes
*			  Bit06		BOOL	Bit 06 des Eingangswortes
*			  Bit07		BOOL	Bit 07 des Eingangswortes
*			  Bit08		BOOL	Bit 08 des Eingangswortes
*			  Bit09		BOOL	Bit 09 des Eingangswortes
*			  Bit10		BOOL	Bit 10 des Eingangswortes
*			  Bit11		BOOL	Bit 11 des Eingangswortes
*			  Bit12		BOOL	Bit 12 des Eingangswortes
*			  Bit13		BOOL	Bit 13 des Eingangswortes
*			  Bit14		BOOL	Bit 14 des Eingangswortes
*			  Bit15		BOOL	Bit 15 des Eingangswortes
*
* History   :
*  V1.00	  09.11.1998,fw		erstellt
*  V1.70	  17.06.2002,WeitzerT	inc. plctypes entf.; bei jewlib1.h <> statt "" 
*
***********************************************************************************/
#include <jew_lib1.h>

void WDtoBIT(WDtoBIT_typ *fd)
{
	fd->Bit00 = (fd->Word) & 1;
	fd->Bit01 = (fd->Word>>1) & 1;
	fd->Bit02 = (fd->Word>>2) & 1;
	fd->Bit03 = (fd->Word>>3) & 1;
	fd->Bit04 = (fd->Word>>4) & 1;
	fd->Bit05 = (fd->Word>>5) & 1;
	fd->Bit06 = (fd->Word>>6) & 1;
	fd->Bit07 = (fd->Word>>7) & 1;
	fd->Bit08 = (fd->Word>>8) & 1;
	fd->Bit09 = (fd->Word>>9) & 1;
	fd->Bit10 = (fd->Word>>10) & 1;
	fd->Bit11 = (fd->Word>>11) & 1;
	fd->Bit12 = (fd->Word>>12) & 1;
	fd->Bit13 = (fd->Word>>13) & 1;
	fd->Bit14 = (fd->Word>>14) & 1;
	fd->Bit15 = (fd->Word>>15) & 1;
}
