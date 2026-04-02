/***********************************************************************************
* Name      : gr_min_max.c
* Titel     : Maximal- and Minimum Grenzwertkontrolle mit Hysterese
* Version   : V1.3
* Datum     : 26.05.2015
*
* Uebergabe : In		INT		Eingangssignal
*			  Gw		INT		Grenzwert
*			  Hy_min	INT		Hysterese - Down limit 
*			  Hy_max	INT		Hysterese - Up Limit
*
* Rueckgabe : Q	 		INT		Ausgangssignal = 1 => Grenzwert ueberschritten
*
* History   :
*  V1.00	  28.05.2015,Walid Mari  Erstellt, basiert auf GR_MAXR library
*
***********************************************************************************/
#include <jew_lib1.h>

void GR_MIN_MAXR(GR_MIN_MAXR_typ *fd)
{
	if 		(fd->In >=( fd->Gw	+	fd->Hy_max))
		fd->Q = 1;
	else if (fd->In < (fd->Gw 	- 	fd->Hy_min))
		fd->Q = 0;
}
