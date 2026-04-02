/***********************************************************************************
* Name      : gr_min.c
* Titel     : Minimal-Grenzwertkontrolle mit Hysterese
* Version   : V1.3
* Datum     : 28.09.1999
*
* Uebergabe : In		INT		Eingangssignal
*			  Gw		INT		Grenzwert
*			  Hy		INT		Hysterese
*
* Rueckgabe : Q	 		INT		Ausgangssignal = 1 => Grenzwert unterschritten
*
* History   :
*  V1.00	  14.09.1998,fw			erstellt
*  V1.30      28.09.1999,BrunnerK	Vergleichsoperanden wurden geaendert
*  V1.70	  17.06.2002,WeitzerT	inc. plctypes entf.; bei jewlib1.h <> statt "" 
*
***********************************************************************************/
#include <jew_lib1.h>

void GR_MIN(GR_MIN_typ *fd)
{
	if (fd->In <= fd->Gw)
		fd->Q = 1;
	else if (fd->In > (fd->Gw + fd->Hy))
		fd->Q = 0;
}
