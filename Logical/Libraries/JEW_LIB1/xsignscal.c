/***********************************************************************************
* Name      : xSignScal.c
* Titel     : Lineare Interpolation aus num Stützstellen
* Version   : V1.0
* Datum     : 21.08.2001
*
* Uebergabe : enable			BOOL			Bearbeitung des Funktionsblockes aus/ein
*			: num				UINT			Anzahl der Stützstellen
*			: param				ULONG			Adresse der Stützstellenpaare
*			: In				INT				Aktueller Analogwert
*
* Rueckgabe : error	 			BOOL			Fehlparametrierung: 0= kein Fehler, 1= Fehler
*			: Out				INT	    		Funktionsabhängiger Ausgabewert
*
* History   :
*  V1.00	  21.08.2001,Fa			erstellt
*  V1.70	  17.06.2002,WeitzerT	inc. plctypes entf.; bei jewlib1.h <> statt "" 
*
***********************************************************************************/
#include <jew_lib1.h>

void xSignScal(xSignScal_typ* inst)
{
	unsigned long	usxPointNr;
	signed long		slErg;
	short*			PointAdress;
	
	inst->error = 0;			/* Error Bit zurücksetzen	*/
	inst->exceed= 0;
	usxPointNr = 0;

	if (inst->enable != 0)
	{
		if (inst->num > 1)
		{
			PointAdress = (short*)inst->param;
		/*	usxPointNr = inst->num;
			inst-> Out = PointAdress[usxPointNr];	*/
			
			/* prüfen ob In kleiner als des kleinste x-Element ist */
			if (inst->In < PointAdress[0])
			{
				inst->exceed = 1;			/* Eingabebereich unterschritten	*/
				usxPointNr 	 = 1;			/* Berechnung mit ersten Wertepaaren*/
			}
			/* prüfen ob In kleiner als des kleinste Element ist */
			else if (inst->In >= PointAdress[(inst->num <<1)-2])
			{
				usxPointNr = inst->num-1;		 /* Berechnung mit letzten Wertepaaren	*/
				if (inst->In > PointAdress[(inst->num <<1)-2])
				{
					inst->exceed = 1; 		/* Eingabebereich überschritten	*/
				}
			}
			/* suchen der Wertepaare im passenden Abschnitt	*/
			else
			{			
				while (inst->In >= PointAdress[usxPointNr<<1]) usxPointNr++;
			}
			
			/* Berechnung mittels Geradengleichung und der ermittelten Wertepaare	*/
			usxPointNr = usxPointNr*2 - 2;		/* usxPointNr auf erstes Element der Wertepaare stellen	*/
			if (PointAdress[usxPointNr] != PointAdress[usxPointNr+2])
			{
				slErg = ((long)inst->In - PointAdress[usxPointNr])*(PointAdress[usxPointNr+3]-PointAdress[usxPointNr+1])/(PointAdress[usxPointNr+2]-PointAdress[usxPointNr])+ PointAdress[usxPointNr+1];
				
				if (slErg > 32767)	inst->Out = 32767;				/* Ergebnis über Wertebereich von short */
				else if (slErg < -32768)	inst->Out = -32768;		/* Ergebnis unter Wertebereich von short*/
				else inst->Out = (short)slErg;						/* Ergebnis ausgeben					*/
			}
			else
			{
				inst->error = 1;	/* zwei x-Werte sind gleich	*/
				inst->Out 	= 0;
			}
		}
		else
		{
			inst->error = 1;	/* mindestens zwei Wertepaare sind notwendig	*/
			inst->Out 	= 0;
		}
	}
}

