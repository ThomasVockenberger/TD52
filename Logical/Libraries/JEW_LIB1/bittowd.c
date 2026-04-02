/***********************************************************************************
* Name      : BITtoWD.c
* Titel     : 16 Bits auf ein Word(2Byte) komprimieren
* Version   : V1.00
* Datum     : 09.11.1998
*
* Uebergabe : Bit00		BOOL	Bit 00 des Ausgangswortes
*			  Bit01		BOOL	Bit 01 des Ausgangswortes
*			  Bit02		BOOL	Bit 02 des Ausgangswortes
*			  Bit03		BOOL	Bit 03 des Ausgangswortes
*			  Bit04		BOOL	Bit 04 des Ausgangswortes
*			  Bit05		BOOL	Bit 05 des Ausgangswortes
*			  Bit06		BOOL	Bit 06 des Ausgangswortes
*			  Bit07		BOOL	Bit 07 des Ausgangswortes
*			  Bit08		BOOL	Bit 08 des Ausgangswortes
*			  Bit09		BOOL	Bit 09 des Ausgangswortes
*			  Bit10		BOOL	Bit 10 des Ausgangswortes
*			  Bit11		BOOL	Bit 11 des Ausgangswortes
*			  Bit12		BOOL	Bit 12 des Ausgangswortes
*			  Bit13		BOOL	Bit 13 des Ausgangswortes
*			  Bit14		BOOL	Bit 14 des Ausgangswortes
*			  Bit15		BOOL	Bit 15 des Ausgangswortes
*
* Rueckgabe : Word 		UINT	Kompriemiertes Eingangsabbild
*
* History   :
*  V1.00	  09.11.1998,fw			erstellt
*  V1.70	  17.06.2002,WeitzerT	inc. plctypes entf.; bei jewlib1.h <> statt "" 
*
***********************************************************************************/
#include <jew_lib1.h>

void BITtoWD(BITtoWD_typ *fd)
{
	fd->Word = fd->Bit15;
	fd->Word = ((fd->Word)<<1) + fd->Bit14;
	fd->Word = ((fd->Word)<<1) + fd->Bit13;
	fd->Word = ((fd->Word)<<1) + fd->Bit12;
	fd->Word = ((fd->Word)<<1) + fd->Bit11;
	fd->Word = ((fd->Word)<<1) + fd->Bit10;
	fd->Word = ((fd->Word)<<1) + fd->Bit09;
	fd->Word = ((fd->Word)<<1) + fd->Bit08;
	fd->Word = ((fd->Word)<<1) + fd->Bit07;
	fd->Word = ((fd->Word)<<1) + fd->Bit06;
	fd->Word = ((fd->Word)<<1) + fd->Bit05;
	fd->Word = ((fd->Word)<<1) + fd->Bit04;
	fd->Word = ((fd->Word)<<1) + fd->Bit03;
	fd->Word = ((fd->Word)<<1) + fd->Bit02;
	fd->Word = ((fd->Word)<<1) + fd->Bit01;
	fd->Word = ((fd->Word)<<1) + fd->Bit00;
}
