/********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Program: CheckMap
 * File: CheckMap.c
 * Author: havlovect
 * Created: September 27, 2011
 ********************************************************************
 * Programm zum Auslesen von inaktiven PV-PV Rangierungen
 * Zum Starten muss man die "state" Variable auf 1 setzen
 * Nach einem erfolgreichen Durchlauf ist dann "state" auf 1000
 * und in der Tabelle "Table" sind "table_index" Eintraege mit inaktiven 
 * PV-PV Rangierungen.
 * Im Fehlerfall hat "state" den Wert 999, und "errState" gibt den 
 * Schritt in der State-Machine an, in dem der Fehler auftrat
 ********************************************************************/

#include <bur/plctypes.h>

#ifdef _DEFAULT_INCLUDES
	#include <AsDefault.h>
#endif

#include <string.h>

#define INIT_MAPPING_S            1
#define NEXT_MAPPING_S           10
#define INIT_LINK_S				 15
#define LINK_S					 20
#define ERROR_S					999
#define RETRY_MAPPING_S			500
#define FINISHED_S			   1000

static void clear_table()
/* Loeschen der Tabelle mit den Resultaten */
{
	table_index = 0;
	memset (&Table, 0, sizeof(Table));
}

static void insert_entry(char * sourceName,
						 USINT  sourceFlags,
						 char * sinkName,
	                     USINT  sinkFlags)
	/* Eintrag eines Resultats in die Tabelle 
	   Hier waeren eventuell noch weitere Filterungen moeglich,
	   z.B. nur Rangierungen eintragen, deren Ziel in einem bestimmten
	   AppModul liegen.
	*/
{
	if (table_index <= MAX_TABLE)
	{
		strncpy(Table[table_index].sourceName, sourceName, sizeof(Table[0].sourceName));
		strncpy(Table[table_index].sinkName,   sinkName,   sizeof(Table[0].sinkName));
		Table[table_index].sourceFlags = sourceFlags;
		Table[table_index].sinkFlags   = sinkFlags;
	
		table_index++;
	}
}

void _INIT CheckMapINIT(void)
{
	state = 1;		/* Start automatisch mit PLC Hochlauf */
	AsArLogGetInfo_01.enable = 1;
	AsArLogGetInfo_01.pName = arlogBASE_USER_LOG_IDENT;
	AsArLogGetInfo(&AsArLogGetInfo_01);
}

void _CYCLIC CheckMapCYCLIC(void)
{
	if (active)
		cycleCount++;
		
	switch (state) {
		case INIT_MAPPING_S:	
		/* Einstieg in die State-Machine, Initialisierung des Loops ueber AsIOFListDP */
			
			cycleCount = 0;
			active = 1;
			clear_table();
			/* Wir interessieren uns nur fuer PV-PV Rangierungen, die nicht aktiv sind 
			   (siehe Dokumentation des FUBs) */
			List.flagsMask      = 0x38;
			List.flagsValue     = 0x08; 
			
			List.enable         = 1;
			List.pLastDatapoint = 0;
			state = NEXT_MAPPING_S;
			/* FALLTHROUGH */
		case NEXT_MAPPING_S:
		/* Aufruf von AsIOFListDP */
			
			AsIOFListDP(&List);
			if (List.status == ERR_FUB_BUSY)
			{
				/* weiter aufrufen */
				break;
			}
			/* FUB ist fertig geworden -> Auswertung */	
			
			if (List.status == asioERR_NOSUCH_DP)
			{
				/* Datenpunkt inzwischen verschwunden -> nochmals von vorne beginnen */
				state = RETRY_MAPPING_S;
				break;
			}
			
			/* Behandlung anderer Fehler */
			if (List.status != ERR_OK)
			{
				errState = NEXT_MAPPING_S;
				active = 0;
				state = ERROR_S;
				break;
			}
			
			/* FUB ist erfolgreich fertig geworden */
			
			if (List.pDatapoint == 0)
			{
				/* Kein weiterer Eintrag mehr gefunden -> Fertig */
				active = 0;
				state = FINISHED_S;
				break;
			}
			
			/* Wir haben einen passenden Datenpunkt gefunden */
			
			/* Fuer naechsten Durchlauf pLastDatapoint weitersetzen */
			List.pLastDatapoint = List.pDatapoint;
			
			state = INIT_LINK_S;
			/* FALLTHROUGH */
		case INIT_LINK_S:
		/*	die betroffenen PVs auswerten: Initialisierung fuer AsIOPVInfo */
			
			str[0][0] = 0;
			str[1][0] = 0;			
			lflags[0] = 0;
			lflags[1] = 0;
			
			Info.enable = 1;
			Info.pDatapoint = List.pDatapoint;
			
			/* Mit Signalquelle (index 0) starten */
			Info.index = 0;
			state = LINK_S;
			/* FALLTHROUGH */
		case LINK_S:
		/* Aufruf von AsIOPVInfo */ 
			
			AsIOPVInfo(&Info);
			if (Info.status == ERR_FUB_BUSY)
			{
				/* weiter aufrufen */
				break;
			}
			/* FUB ist fertig geworden -> Auswertung */
		
			if (Info.status == asioERR_NOSUCH_DP)
			{
				state = RETRY_MAPPING_S;
				break;
			}
			
			/* Behandlung anderer Fehler */
			if (Info.status != ERR_OK)
			{
				errState = LINK_S;
				active = 0;
				state = ERROR_S;
				break;
			}
			
			/* FUB ist erfolgreich fertig geworden */
			
			if (Info.pPvName)
				strncpy(str[Info.index], (char *)Info.pPvName, sizeof(str[Info.index]));
			lflags[Info.index] = Info.flags;
			
			if (Info.index == 0)
			{
				/* Wir haben die Signalquelle ausgelesen und wollen
				   jetzt die erste Senke auslesen: 
				   index auf 1 setzen, aber im gleichen State bleiben */
				Info.index = 1;
				break;
			} 
			
			/* Wir haben jetzt auch die erste Senke ausgelesen,
			   und da es bei PV-PV Rangierungen nur eine Senke gibt, sind 
               wir jetzt fertig */

			/* Merken der Rangierung */
			insert_entry(str[0], lflags[0], str[1], lflags[1]);

			/* und weiter im Loop mit AsIOFListDP */
			state = NEXT_MAPPING_S;
			break;
		case RETRY_MAPPING_S:
		/*  Falls waehrend der Abarbeitung durch Deinstall von Mapping Modulen
			der letzte/aktuelle Datenpunkt nicht gefunden wurde fangen wir nochmals von vorne an         
	     */
			retryCount++;
			state = INIT_MAPPING_S;
			break;
		case FINISHED_S:
		/*  Logger Eintrag der inaktiven Mappings */ 
			strcpy(logErrorStringPV, "There are ");
			strcpy(hilfstr2, " unresolved PV2PV mappings. For details see: ParaBase::Checkmap.Table");
			itoa(table_index,(UDINT)hilfstr3);
			strcat(logErrorStringPV, hilfstr3);
			strcat(logErrorStringPV, hilfstr2);

         	AsArLogWrite_01.enable = 1;
			AsArLogWrite_01.ident = AsArLogGetInfo_01.ident;
			AsArLogWrite_01.logLevel = arlogLEVEL_WARNING;
			AsArLogWrite_01.errornr = 52200;
			AsArLogWrite_01.asciiString = (UDINT)(&logErrorStringPV);
			AsArLogWrite(&AsArLogWrite_01);
			if (AsArLogWrite_01.status != 0)
				state = 0;
			break;
		default:
			break;
	}
}
