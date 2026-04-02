/***********************************************************************************
* Name      : bh.c
* Titel     : Betriebsstundengenerierung
* Version   : V1.10
* Datum     : 17.05.2002
*
* Uebergabe : enable			BOOL			Betriebsstundengenerierung aus/ein
*
* Rueckgabe : BH_adr	 struct USINT tick		Sekundentakt
*							    USINT second	Sekundenzaehler
*							    USINT minute	Minutenzähler
*								USINT spare		Reserve
*			  BH_Imp			BOOL			Betriebsstundenimpuls
*
* History   :
*  V1.00	  14.09.1998,fw			erstellt
*  V1.01	  24.08.2001,Fa.		fd->BD_adr durch fd->BH_adr ersetzt
*  V1.10	  17.05.2002,fw			#include <burtrap.h> durch <sys_lib.h> ersetzt
*  V1.70	  17.06.2002,WeitzerT	inc. plctypes entf.; bei jewlib1.h <> statt "" 
*  V1.70.1	  24.01.2014,WeitzerT	correction of compiler warnings
*  V1.93.0	  27.10.2023,Zuschnig	Include minute impuls		
*
***********************************************************************************/
#include <jew_lib1.h>
#include <sys_lib.h>

void BH(BH_typ *fd)
{
	UINT	ticks;
	bh_typ	*bh_adr;
	
	bh_adr = (bh_typ*)fd->BH_adr;
	
	fd->BH_Imp = 0;							/* vorab Stundenimpuls reset */
	fd->BM_Imp = 0;							/* vorab Minutenimpuls reset */

	if (fd->enable == 1)
	{
		ticks = 0;							/* Zwischenzeitlich für Änderung auf i386 */
		
		ticks = TIM_ticks();				/* 10 ms Takt auslesen */

		if ((ticks < 50) && (bh_adr->tick == 0))
		{
			bh_adr->tick = 1;				/* Sekundentakt setzen */
			++bh_adr->second;				/* im Sekundentakt zaehlen */
			if (bh_adr->second > 59)
			{
				bh_adr->second = 0;
				fd->BM_Imp = 1;				/* Minutenimpuls ausgeben */
				++bh_adr->minute;			/* im Minutetakt zaehlen */
				if (bh_adr->minute > 59)
				{
					fd->BH_Imp = 1;			/* Stundenimpuls ausgeben */
					bh_adr->minute = 0;
				}
			}
		}
		else if ((ticks > 50) && (bh_adr->tick == 1))
			bh_adr->tick = 0;				/* Sekundentakt ruecksetzen */
	}
}
