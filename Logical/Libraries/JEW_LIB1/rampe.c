/***********************************************************************************
* Name      : rampe.c
* Titel     : Rampengenerierung
* Version   : V1.0
* Datum     : 14.09.1998
*
* Uebergabe : enable	BOOL	Freigabe 0 => Out = in / 1 => Out = rampe(in)
*			  In		INT		Eingangssignal
*			  Rise		UINT	positive Aenderung / s
*			  Sink		UINT	negative Aenderung / s
*			  TC_Time	UINT	Zykluszeit der Taskklasse in [ms]
*
* Rueckgabe : Out	 	INT		Ausgangssignal
*
* History   :
*  V1.00	  14.09.1998,fw			erstellt
*  V1.70	  17.06.2002,WeitzerT	inc. plctypes entf.; bei jewlib1.h <> statt "" 
*
***********************************************************************************/
#include <jew_lib1.h>

void RAMPE(RAMPE_typ *fd)
{
	if (fd->enable)
	{
		if (fd->Out < fd->In)
		{
			fd->f_out = fd->f_out + (0.001 * fd->Rise * fd->TC_Time);
			if (fd->f_out > fd->In)
				fd->f_out = fd->In;
		}
		else if (fd->Out > fd->In)
		{
			fd->f_out = fd->f_out - (0.001 * fd->Sink * fd->TC_Time);
			if (fd->f_out < fd->In)
				fd->f_out = fd->In;
		}
		
		fd->Out = (short int)(fd->f_out);
	}
	else
	{
		fd->Out = fd->In;
		fd->f_out = fd->In;
	}
}
