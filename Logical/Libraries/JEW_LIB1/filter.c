/***********************************************************************************
* Name      : filter.c
* Titel     : Filter mit PT1-Verhalten
* Version   : V1.0
* Datum     : 14.09.1998
*
* Uebergabe : In		INT		Eingangssignal
*			  Filter	SINT	Filterkonstante filter = T1 / T (T1 = Verzoegerung 1. Ordnung)
*
* Rueckgabe : Out	 	INT		Ausgangssignal
*
* History   :
*  V1.00	  14.09.1998,fw		erstellt
*  V1.20      21.12.1998,BK		Zeitkonstante im .h-File von SINT auf USINT
*  V1.70	  17.06.2002,WeitzerT	inc. plctypes entf.; bei jewlib1.h <> statt "" 
*  V1.91	  02.02.2022,Schmid		added Reset input
*
***********************************************************************************/
#include <jew_lib1.h>

void FILTER(FILTER_typ *fd)
{
	if (fd->Filter == 0)
		fd->Filter = 1;				/* Division durch 0 verhindern */
	
	if (fd->Reset)
		fd->temp_mw = fd->In * fd->Filter;
	else
		fd->temp_mw = fd->temp_mw + fd->In - fd->Out;
	
	fd->Out = (int)(fd->temp_mw/fd->Filter);
}
