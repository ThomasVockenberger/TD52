/************************************************************************************
* Name      : pid_a.src                                                         	*
* Titel     : Einfacher PID-Regler auf Integer-Basis                               	*
*												                            	   	*
* Uebergabe : enable	BOOL	Freigabe											*
*			  init		BOOL	Initialisierung									   	*
*			  ist		INT		Inputvariablen, Istwert                         	*
*			  soll		INT		Sollwert                            	  			*
*			  kp		INT		Proportionalverstärkung                             *
*			  ki		INT		Integrationsbeiwert                                 *
*			  kd		INT		Differenzierbeiwert                                 *
*			  gunten	INT		unterer Grenzwert                              	   	*
*			  goben		INT		oberer Grenzwert                            	   	*
*			  C0		DINT	Integrator Startwert wird übernommen wenn !=0	   	*
*												                            	   	*
* Rueckgabe : limit		BOOL	Limit Stellgrenzwert unter-/Überschritten			*
*			  integr	DINT	Integrator              							*
*			  stell		INT		Outputvariable, Stellwert                           *
*												                       				*
* Lok. Var. : e			INT		Reglelabweichung aktuell							*
*			  ist_alt		INT		alte Regelabweichung für Differenzbildung			*
*			  stell_neu DINT	Zwischenspeicherung des Stellwertes					*
*												                            	   	*
* History   :	                            	   								   	*
* V1.00	  	  06.06.2002,tw		erstellt										   	*
* V1.10       2017-08-08 FW   adapted for GCC 4.1.2.
*																				   	*
*************************************************************************************
*               		                                                           	*
*  BESCHREIBUNG:        		                                                   	*
*  -------------                		                                           	*
*                                       		                                   	*
*  Der FUB PID_a realisiert einen einfachen PID-Algorithmus, der auf		       	*
*  unterschreiten der unteren Stellwertgrenze <gunten> und auf             		   	*
*  überschreiten der oberen Stellwertgrenze <goben> überwacht. In diesem		   	*
*  Fall wird der Integrator neu berechnet und der Stellwert gemäß der     		   	*
*  Grenze begrenzt.                                                       		   	*
*  Der Integrator <integr> muß beim erstmaligen Aufruf des FUB richtig    		   	*
*  initialisiert werden (in der Regel mit 0).                             		   	*
*  Die Regelparameter der FUB-Schnittstelle sind wegen der Integerrechnung		   	*
*  mit 256 zu multiplizieren, das untere Byte entspricht demnach der Stelle		   	*
*  hinter dem Komma.                                                      		   	*
*                                                                         		   	*
************************************************************************************/
#include <bur/plc.h>
#include <JEW_LIB1.h>

void PID_A(PID_A_typ* pida)
{
	/* Deklaration Zwischenablage */
	long	stell_neu;
	short	e;

	if (pida->enable) 
	{
		/* Initialisierung Regler */
		if (pida->init)
		{
			pida->integr = pida->C0;
			pida->ist_alt = 0;
		}
		
		/* Rücksetzen von Limitfehler */
		pida->limit = 0;

		/* Regler - Algorythmus
		yi = yi_1 + (e + ist_alt)/2 * ki
		stell  = (yp + yi + yd) / 256
		stell  = (e*kp + yi + (ist_alt - e) * (kd * -1)) / 256
		*/
		
		/* Berechnung Regelabweichung */
		e = pida->soll - pida->ist;
		
		/* Berechnung Integralanteil */
		pida->integr = pida->integr + (pida->ki) * ((e + pida->ist_alt) >> 1);
		
		/* Berechnung Stellgröße */
		stell_neu = (pida->kp * e + pida->integr - pida->kd * (pida->ist_alt - e)) >> 8; 

		/* Übergabe an Schnittstelle */
	    pida->stell = stell_neu;
	    
		/* Prüfung und Begrenzung des Stellsignales */
        if (stell_neu < pida->gunten)
		{
			pida->limit = 1;
			if (pida->ki != 0) pida->integr = (pida->gunten << 8) - (pida->kp * e - pida->kd * (e - pida->ist_alt));
			pida->stell = pida->gunten;
		}
		else if (stell_neu > pida->goben)
		{
			pida->limit = 1;
			if (pida->ki != 0) pida->integr = (pida->goben << 8) - (pida->kp * e - pida->kd * (e - pida->ist_alt));
			pida->stell = pida->goben; 
		}

		/* Übergabe für neue Berechnug */
		pida->ist_alt = e;

	}
}
