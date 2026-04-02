/***********************************************************************************
* Name      : itoa.c
* Titel     : Konvertierung Integer to ASCII-String
* Version   : V1.3
* Datum     : 30.09.1999
*
* Uebergabe : Strukturvariable:
*             In		INT		Zu konvertierender Integerwert
*			  *pCharFld	SINT	Pointer auf das Char-Array
*
* Rueckgabe : Strukturvariable:
*			  StrLen	SINT	Laenge des Strings	
*
* History   :
*  V1.00	  xx.xx.1998,fw			erstellt
*  V1.30      30.09.1999,BrunnerK	In Library umgewandelt
*  V1.70	  17.06.2002,WeitzerT	inc. plctypes entf.; bei jewlib1.h <> statt "" 
*  V1.70.1	  24.01.2014,WeitzerT	correction of compiler warnings
*
***********************************************************************************/
#include <jew_lib1.h>

signed char ITOA(signed short In, plcstring* Out)

{
	signed short	i, string_len, neg;
	signed long		val;
	signed short	InTemp;
	
	
	string_len = 1;					/* minimum 1 Zeichen lang */
	neg = 0;						/* vorab Wert positiv */
	InTemp = 0;
	
	if (In<0)
	{								/* Wert negativ */
		InTemp = In;				/* Negative Wert sichern */
/*		In = abs(In);				   Absolutbetrag bilden */
		neg = 1;					/* Kennung Wert ist negativ setzen */
		string_len++;				/* String wird um das Vorzeichen länger */
		Out[0] = '-';		    	/* Vorzeichen am Stringanfang eintragen */
	}
	
	val = In;
	while((val= val/10) != 0)		/* Berechnung der Stringlänge */
	{
		string_len++;
	}
	
	val = In;
	Out[string_len] = 0;		/* Stringendekennung eintragen */
	
	for(i=0; i<(string_len-neg); ++i)	/* Wert ASCII wandeln */
	{
		Out[string_len-i-1] = (char)((val % 10) + '0');
		val = val / 10;
	}
	
	if (neg == 1)
	{
		In = InTemp;				/* Negativen Wert zuruecksichern */
	}
	
	return string_len;				/* Stringlänge ohne Stringendekennung */
}
