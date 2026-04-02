/***********************************************************************************
* Name      : digfilsrc.c
* Titel     : Regelungstechnik
* Version   : V0.1
* Datum     : 28.06.2006
*
* Uebergabe : Input		REAL	Eingangssignal
*			  Ordnung	USINT	Filterordnung
*			  an		REAL	Nennerkoeffizienten
*			  bn		REAL	Zählerkoeffizienten
*			  Output	REAL	Ausgangssignal
*			  Y			REAL	Zähler
*			  X			REAL	Nenner
*
*
* History   :
* V0.1		  28.06.2006,Hirzinger	erstellt
*
***********************************************************************************/
#include <CTRL.h>

unsigned int	uszaehl;
float			rN_N;

void DigFil(DigFil_typ *tDigFilVar)
{
		
	/***** EINGANG ********/
	/*tDigFilVar->X[3]	= tDigFilVar->X[2];
	tDigFilVar->X[2]	= tDigFilVar->X[1];
	tDigFilVar->X[1]	= tDigFilVar->X[0];	
	tDigFilVar->X[0]	= tDigFilVar->Input;
	*/

	/***** HISTORIE EINGANG *****/
	for(uszaehl = tDigFilVar->Ordnung; uszaehl >= 1; uszaehl--)
		tDigFilVar->X[uszaehl] = tDigFilVar->X[uszaehl-1];

	tDigFilVar->X[0]	= tDigFilVar->Input;
		
	/********  ZÄHLER B*X **********/
	/*for (uszaehl = 0; uszaehl <= tDigFilVar->Ordnung; uszaehl++)
		rN_N	= rN_N + tDigFilVar->X[uszaehl] * tDigFilVar->bn[uszaehl];
	
	*/
	tDigFilVar->Y[0] = 	tDigFilVar->X[0] * tDigFilVar->bn[0] + tDigFilVar->X[1] * tDigFilVar->bn[1] + tDigFilVar->X[2] * tDigFilVar->bn[2] ;
				
	/********  NENNER A*Y **********/
	/*for (uszaehl = 1; uszaehl <= tDigFilVar->Ordnung; uszaehl++)
		rN_N	= rN_N - tDigFilVar->Y[uszaehl] * tDigFilVar->an[uszaehl];
	*/

	tDigFilVar->Y[0] = tDigFilVar->Y[0] - tDigFilVar->Y[1] * tDigFilVar->an[1] - tDigFilVar->Y[2] * tDigFilVar->an[2];
	
	/*tDigFilVar->Y[3]	= tDigFilVar->Y[2];
	tDigFilVar->Y[2]	= tDigFilVar->Y[1];
	tDigFilVar->Y[1]	= tDigFilVar->Y[0];
	*/
	
	/***** HISTORIE AUSGANG Z-1 *****/
	for (uszaehl = tDigFilVar->Ordnung; uszaehl >= 1; uszaehl--)
		tDigFilVar->Y[uszaehl]	= tDigFilVar->Y[uszaehl-1];

/*	tDigFilVar->Y[1]	= rN_N;*/				

		
	/***** AUSGANG *******/
	tDigFilVar->Output	= tDigFilVar->Y[0];	
}
