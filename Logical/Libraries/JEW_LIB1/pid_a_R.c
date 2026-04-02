/********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: JEW_LIB1
 * File: pid_a_R.c
 * Author: 320003156
 * Created: August 17, 2011
 * Modified: 2017-08-08 FW   adapted for GCC 4.1.2.
 *******************************************************************/

#include <bur/plc.h>
#include <JEW_LIB1.h>

void PID_A_R(PID_A_R_typ* pida)
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
