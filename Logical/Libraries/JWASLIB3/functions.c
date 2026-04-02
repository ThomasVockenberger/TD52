/**************************************************************
*  functions.c - Sourcefile fuer Jenbacher-Library JWASLIB3
*  Copyright 1998 Jenbacher Werke AG 
*
*  Entwicklungsgeschichte
*  ----------------------
*  V0.1   06-10-98,BrunnerK    erstellt
*  V0.2   07-08-98,BrunnerK	   FUB xSigScal geaendert
*  V0.3   11-11-98,BrunnerK    FUB xSigScal korrigiert
*  V0.4   21-01-99,FahringerA  FUB xSigScal korrigiert
*  V0.5   18-07-00,BrunnerK	   Parameter geaendert (AS V1.4 - LibManager)
*							   define´s aus h-File importiert
*  V0.6	  17-06-02,WeitzerT    include Befehle geändert
*							   (<bur/plc.h> entfernt und bei jwaslib3.h <> statt "")
*  V0.7   22-04-02,WeitzerT    Fehler bei x<x1 behoben
*  V0.7.1 24-01-14,WeitzerT	   correction of compiler warnings
*
*  Offene Punkte
*  -------------
*
***************************************************************/

#include <JWASLIB3.h>

#define vxSigMax(a,b)	((a)>(b))?(a):(b)					/* Begrenzung auf Obergrenze	*/
#define vxSigMin(a,b)	((a)<(b))?(a):(b)					/* Begrenzung auf Untergrenze 	*/
#define vxSigBet(a,b,c)	(vxSigMax((vxSigMin((c),(b))),(a)))	/* a=unterer-, c=oberer-Grenzwert	*/

/**************************************************************
*
*  Zweck:  Signalskalierung ueber Gerade (2 Punkte)
*
*  Aufruf: xSigScal(xSigScal_typ *tSigScalVar)
*
*  Übergabep.:    xSigScal_typ-Variable:
*                 X1		1. X-Koordinate
*                 Y1		1. Y-Koordinate
*                 X2		2. X-Koordinate
*                 Y2		2. Y-Koordinate
*                 X			Rohwert
*				  
*  Rückgabep.:    Y_SCAL	skalierter Wert
*                 RUN      	FUB in Bearbeitung
*                 ERROR     FUB-Fehler steht an
*
*  Beschreibung:  Der FUB skaliert den am Eingang anliegenden
*                 Rohwert ueber eine 2-Punkte-Gerade (x1,y1-x2,y2)
*                 Bei Bereichsueberlauf Begrenzung auf
*                 Max/Min-Wert, setzen des Error-Bits.
*
*
*
*  Datum/Autor:
*  V0.1   06-10-98,BrunnerK    erstellt
*  V0.2	  07-08-98,BrunnerK    Begrenzung auf y1 bzw. y2 eingebaut
*  V0.3   11-11-98,BrunnerK    Fehler in Berechnung behoben (fK gecastet)
*  V0.4   21-01-99,FahringerA  Float-Berechnung entfernt
*  V0.5   18-07-00,BrunnerK	   Parameter geaendert (AS V1.4 - LibManager)
*  V0.6	  17-06-02,WeitzerT    include Befehle geändert
*							   (<bur/plc.h> entfernt und bei jwaslib3.h <> statt "")
*
**************************************************************/

void xSigScal(xSigScal_typ *tSigScalVar)
{
	long	slZwischen; 
	
	tSigScalVar->RUN = 1;
	if (tSigScalVar->X2 != tSigScalVar->X1)
	{
		tSigScalVar->ERROR  = 0;

	    /*----------------------------------------------------------*
    	* Berechnung der Skalierung                                 *
	    * Ableitung:    y = k * x + d                               *
    	*                                                           *
	    *               k = (y2-y1) / (x2-x1)                       *
    	*               d = (y1*x2 - y2*x1) / (x2-x1)               *
	    *           ==> y = (x*(y2-y1) + y1*x2 - y2*x1) / (x2-x1)   *
    	*-----------------------------------------------------------*/
    	/* Typkonvertierung auf 32Bit durchführen					*/
    	
		slZwischen = ((tSigScalVar->X * ((long)tSigScalVar->Y2-tSigScalVar->Y1) +
					  		   ((long)tSigScalVar->Y1*tSigScalVar->X2) -
					  		   ((long)tSigScalVar->Y2*tSigScalVar->X1))/
					  		   ((long)tSigScalVar->X2-tSigScalVar->X1));

		/* y zwischen y1 und y2 begrenzen 		*/
		tSigScalVar->Y_SCAL = (short)vxSigBet(vxSigMin(tSigScalVar->Y1,tSigScalVar->Y2),slZwischen,vxSigMax(tSigScalVar->Y1,tSigScalVar->Y2));
	}
	else
	{
		tSigScalVar->ERROR  = 1;
		tSigScalVar->Y_SCAL = 0;
	}	
	tSigScalVar->RUN = 0;
}







/**************************************************************/


void xSigScal_R(xSigScal_R_typ *tSigScalVar)
{
	float	slZwischen; 
	
	tSigScalVar->RUN = 1;
	if (tSigScalVar->X2 != tSigScalVar->X1)
	{
		tSigScalVar->ERROR  = 0;

	    /*----------------------------------------------------------*
    	* Berechnung der Skalierung                                 *
	    * Ableitung:    y = k * x + d                               *
    	*                                                           *
	    *               k = (y2-y1) / (x2-x1)                       *
    	*               d = (y1*x2 - y2*x1) / (x2-x1)               *
	    *           ==> y = (x*(y2-y1) + y1*x2 - y2*x1) / (x2-x1)   *
    	*-----------------------------------------------------------*/
    	/* Typkonvertierung auf 32Bit durchführen					*/
    	
		slZwischen = (( (float)(tSigScalVar->X * (tSigScalVar->Y2-tSigScalVar->Y1) +
					  		   (tSigScalVar->Y1*tSigScalVar->X2) -
					  		   (tSigScalVar->Y2*tSigScalVar->X1)) )/
					  		   (float)(tSigScalVar->X2-tSigScalVar->X1));

		/* y zwischen y1 und y2 begrenzen 		*/
		tSigScalVar->Y_SCAL = vxSigBet(vxSigMin(tSigScalVar->Y1,tSigScalVar->Y2),slZwischen,vxSigMax(tSigScalVar->Y1,tSigScalVar->Y2));
	}
	else
	{
		tSigScalVar->ERROR  = 1;
		tSigScalVar->Y_SCAL = 0;
	}	
	tSigScalVar->RUN = 0;
}




/**************************************************************
*
*  Zweck:  Schrittregler
*
*  Aufruf: xPISchr(xPISchr_typ *tPISchrVar)
*
*  Übergabep.:    xPISchr_typ-Variable:
*				  
*  Rückgabep.:    
*
*  Beschreibung:  
*
*  Datum/Autor:
*  V0.1   08-10-98,BrunnerK   erstellt
*  V0.2   18-07-00,BrunnerK	  Parameter geaendert (AS V1.4 - LibManager)
*
**************************************************************/

void xPISchr(xPISchr_typ *tPISchrVar)
{
	long slXWk;

	if (tPISchrVar->bPIDinit == 0)
	{
		slXWk                = (long)(tPISchrVar->ssX - tPISchrVar->ssW);
		tPISchrVar->slA_XWka = slXWk;
		tPISchrVar->ssdY     = 
		    (short)(tPISchrVar->slK * ((slXWk - tPISchrVar->slXWka) + 
		    (tPISchrVar->slTI * slXWk)/1000) / 1000 );
	}
	else
	{
		tPISchrVar->ssdY      = 0;
	}
}




/**************************************************************


**************************************************************

**************************************************************/

void xPISchr_R(xPISchr_R_typ *tPISchrVar)
{
	long slXWk;

	if (tPISchrVar->bPIDinit == 0)
	{
		slXWk                = (tPISchrVar->ssX - tPISchrVar->ssW);
		tPISchrVar->slA_XWka = slXWk;
		tPISchrVar->ssdY     = 
		    (tPISchrVar->slK * ((slXWk - tPISchrVar->slXWka) + 
		    (tPISchrVar->slTI * slXWk)/1000) / 1000 );
	}
	else
	{
		tPISchrVar->ssdY      = 0;
	}
}











