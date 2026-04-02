/***********************************************************************************
* Name      : ton_r.c
* Titel     : Anzugsverzoegerung mit Reset-Eingang
* Version   : V1.10
* Datum     : 17.05.2002
*
* Uebergabe : IN		BOOL	Eingangssignal
*			  PT		UDINT	gewuenschte Verzoegerungszeit in [10 ms]
*			  RS		BOOL	Reseteingang: Durch Setzen dieses Eingangs wird der Ausgang Q sofort rueckgesetzt.
*
* Rueckgabe : Q	 		BOOL	Ausgangssignal
*			  PT		UDINT	abgelaufene Verzoegerungszeit in [10 ms]
*
* History   :
*  V1.00	  14.09.1998,fw			erstellt
*  V1.10      17.05.2002,fw    		Funktion SYS_info durch Funktionsblock SysInfo ersetzt,
*                           	    damit die Libary auch für i386 kompiliert werden kann.
*  V1.70	  17.06.2002,WeitzerT	inc. plctypes entf.; bei jewlib1.h <> statt "" 
*
***********************************************************************************/
#include <jew_lib1.h>
#include <brsystem.h>

void TON_R(TON_R_typ *fd)
{
	SysInfo_typ	SysInf;
	unsigned long time_over;
	
	SysInf.enable = 1;
	SysInfo(&SysInf);
	
	if (fd->IN == 1)
	{
		if (SysInf.tick_count >= fd->tick_old)
			time_over = SysInf.tick_count - fd->tick_old;
		else
			time_over = 0 - fd->tick_old + SysInf.tick_count;
		
		fd->ET = fd->ET + time_over;
		
		if (fd->ET >= fd->PT)
		{
			fd->Q = 1;
			fd->ET = fd->PT;
		}
		
		if (SysInf.init_count != fd->init_old)
		{
			fd->Q = 0;
			fd->ET = 0;
			fd->init_old = SysInf.init_count;
		}
	}
	else
	{
		fd->Q = 0;
		fd->ET = 0;
	}
	
	if (fd->RS == 1)
	{
		fd->Q = 0;
		fd->ET = 0;
	}
	
	fd->tick_old = SysInf.tick_count;
	
}
