(*******************************************************************************
CUSTOMIZED: c_spare 			customized task placeholder

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V3.90.0	17-10-2012 Zengerer   new	
V4.02.0 24.06.2015 Zengerer   cleanup, init

Instructions for use:
--------------------
USE THIS TASK TO ADD CODE SNIPPETS AFTER ENGINE DELIVERY

Outstandings:
------------

*******************************************************************************)
PROGRAM _CYCLIC	
	
	(*Auflistung spezifischer Ein- und Ausgänge*) 
	
	(*----------------------------------------------------------------------------------------*)
	(*Digital Eingänge*)
	
	IN_CU.tCustDigIn[1].Di; 			// Status: Vorkammer Gasstrecke Gasdruck max
	IN_CU.tCustDigIn[2].Di; 			// 
	IN_CU.tCustDigIn[3].Di; 			// 
	IN_CU.tCustDigIn[4].Di; 			// Status - Frequenzumrichter Abgas Lüfter läuft
	IN_CU.tCustDigIn[5].Di; 			// Status - Motor Abgas Lüfter gestört
	IN_CU.tCustDigIn[6].Di; 			// Schnelles Trennen GCB
	IN_CU.tCustDigIn[8].Di; 			// Temperatur Abgas Lüfter max.
	IN_CU.tCustDigIn[15].Di; 			// Ansteuerung: Altölpumpe
	IN_CU.tCustDigIn[26].Di; 			// Synchronisiersperrrelais 700G Ausgangsüberwachung
	IN_CU.tCustDigIn[27].Di; 			// Status: Transformator Feeder Schutzgerät SEL 751 gestört
	IN_CU.tCustDigIn[28].Di; 			// Status - Trafoschalter geschlossen
	IN_CU.tCustDigIn[29].Di; 			// Status - Trafoschalter offen
	IN_CU.tCustDigIn[30].Di; 			// Transformator SEL 751 ausgelöst 
	IN_CU.tCustDigIn[31].Di; 			// Status: Transformator SEL 751 Überlast/Kurzschluss
	IN_CU.tCustDigIn[32].Di; 			// Status: Transformator SEL 751 Erdschluss
	IN_CU.tCustDigIn[33].Di; 			// Status - Harnstoff Tagestank Füllstand Maximum
	IN_CU.tCustDigIn[34].Di; 			// Status - Leckage Harnstoff Tagestank
	IN_CU.tCustDigIn[35].Di; 			// Status: Generator Schutz Relais 700G gestört
	IN_CU.tCustDigIn[36].Di; 			// Status: Transformator SEL 751 Kurzschluss
	IN_CU.tCustDigIn[49].Di; 			// Rückmeldung {{Service switch +MCC}} Harnstoff Rohrleitung Heizung
	IN_CU.tCustDigIn[50].Di; 			// Rückmeldungen Service switch  Hochtemperaturkreis Pumpe
	IN_CU.tCustDigIn[51].Di; 			// Rückmeldung {{Service switch +MCC}} Heizelemente
	IN_CU.tCustDigIn[52].Di; 			// Rückmeldung {{Service switch +MCC}} Motorkühlwasserpumpe 1
	IN_CU.tCustDigIn[53].Di; 			// 
	IN_CU.tCustDigIn[54].Di; 			// Feedback service switch charge cooling water pump
	IN_CU.tCustDigIn[55].Di; 			// Rückmeldung {{Service switch +MCC}} Getriebe Kühlwasserpumpe
	IN_CU.tCustDigIn[56].Di; 			// Rückmeldung {{Service switch +MCC}} Generator Lager Kühlsystem
	IN_CU.tCustDigIn[57].Di; 			// Rückmeldung {{Service switch +MCC}} Frischölpumpe
	IN_CU.tCustDigIn[58].Di; 			// Feedback {{Service switch}} Oil pump 2 AC
	IN_CU.tCustDigIn[59].Di; 			// 
	IN_CU.tCustDigIn[60].Di; 			// Rückmeldung {{Service switch +MCC}} Abgaslüfter
	IN_CU.tCustDigIn[61].Di; 			// Rückmeldung Abgas Lüfter Klappe geschlossen
	IN_CU.tCustDigIn[62].Di; 			// Rückmeldung Abgas Lüfter Klappe offen
	IN_CU.tCustDigIn[63].Di; 			// Rückmeldung {{Service switch }} +MCC Stillstandsheizung
	IN_CU.tCustDigIn[64].Di; 			// Rückmeldung {{Service switch }} +MCC Notkühler 1
	IN_CU.tCustDigIn[65].Di; 			// Rückmeldung {{Service switch }} +MCC Notkühler 2
	IN_CU.tCustDigIn[66].Di; 			// Rückmeldung {{Service switch }} +MCC Notkühler 3
	IN_CU.tCustDigIn[67].Di; 			// Rückmeldung {{Service switch }} +MCC Notkühler 4
	IN_CU.tCustDigIn[68].Di; 			// 
	IN_CU.tCustDigIn[69].Di; 			// 
	IN_CU.tCustDigIn[70].Di; 			// Rückmeldung {{Service switch }} +MCC Zuluftventilator 3
	IN_CU.tCustDigIn[71].Di; 			// Rückmeldung {{Service switch }} +MCC Zuluftventilator 4
	IN_CU.tCustDigIn[72].Di; 			// Rückmeldung {{Service switch }} +MCC Heizung Motorraum
	IN_CU.tCustDigIn[73].Di; 			// Rückmeldung {{Service switch }} +MCC Heizung Schaltschrankraum
	IN_CU.tCustDigIn[74].Di; 			// Rückmeldung {{Service switch +MCC}} Hilfsbetriebe 120V
	IN_CU.tCustDigIn[75].Di; 			// Rückmeldung: Spannung OK: Hilfsbetriebe 230V
	IN_CU.tCustDigIn[76].Di; 			// Rückmeldung {{Service switch +MCC}} Hilfsbetriebe 230V
	IN_CU.tCustDigIn[77].Di; 			// Rückmeldung {{Service switch +MCC}} Harnstoffdosierpumpe
	IN_CU.tCustDigIn[78].Di; 			// Rückmeldung Abgas Lüfter Klappe bereit
	
	(*----------------------------------------------------------------------------------------*)
	(*Digital Ausgänge*)
	(*-!!- ACHTUNG - AUSKOMMENTIEREN DER OUT_CU.tCustDigOut[x].Do im task c_dig line 403ff-!!-*)
	(*-!!- ACHTUNG - Je nach Verwendung 'Not-Halt' (bMsg1031) und/oder 'Ruhestromschleife' (bMsg1056) als Abschaltbedingung verwenden !!*)
	
	OUT_CU.tCustDigOut[3].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung - Abgas Lüfter
	OUT_CU.tCustDigOut[6].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung - Harnstoff Tagestank Ventil auf/zu
	OUT_CU.tCustDigOut[16].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung - Zuluftjalousie 1 
	OUT_CU.tCustDigOut[17].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung - Zuluftjalousie 2 
	OUT_CU.tCustDigOut[18].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung - Zuluftjalousie 3 
	OUT_CU.tCustDigOut[19].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung - Zuluftjalousie 4 
	OUT_CU.tCustDigOut[20].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung - Abluftjalousie 1
	OUT_CU.tCustDigOut[21].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung - Abluftjalousie 2
	OUT_CU.tCustDigOut[22].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung - Abluftjalousie 3
	OUT_CU.tCustDigOut[23].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung - Abluftjalousie 4
	OUT_CU.tCustDigOut[26].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Aktivierung Drehleuchte grün
	OUT_CU.tCustDigOut[27].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Aktivierung Drehleuchte gelb
	OUT_CU.tCustDigOut[28].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Aktivierung Drehleuchte rot
	OUT_CU.tCustDigOut[29].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Befehl - {{Circuit Breaker}} Hilfsbetriebe Transformator ein
	OUT_CU.tCustDigOut[30].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Befehl - {{Circuit Breaker}} Hilfsbetriebe Transformator aus
	OUT_CU.tCustDigOut[35].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Steuerung Altölpumpe
	OUT_CU.tCustDigOut[36].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Steuerung Frischölpumpe
	OUT_CU.tCustDigOut[37].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung - Abgas Lüfter
	OUT_CU.tCustDigOut[38].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung: Auspuff Gas Ventilator Klappe öffnen
	OUT_CU.tCustDigOut[39].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung: Notkühlventilator 1
	OUT_CU.tCustDigOut[40].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung: Notkühlventilator 2
	OUT_CU.tCustDigOut[41].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung: Notkühlventilator 3
	OUT_CU.tCustDigOut[42].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung: Notkühlventilator 4
	OUT_CU.tCustDigOut[43].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung: Luft Eintritt Ventilator 1 [24V] 
	OUT_CU.tCustDigOut[44].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung: Luft Eintritt Ventilator 2 [24V] 
	OUT_CU.tCustDigOut[45].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung: Zuluftventilator 3 [24V]
	OUT_CU.tCustDigOut[46].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung: Zuluftventilator 4 [24V]
	OUT_CU.tCustDigOut[48].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung Ultra low Nox Kühlgerät EIN
	OUT_CU.tCustDigOut[49].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Anforderung Begleitheizung {{Ultra low Nox}} EIN
	OUT_CU.tCustDigOut[50].Do :=	NOT IN_CU.bMsg[1031] AND NOT IN_CU.bMsg[1056] AND  bConnectYourBitHere ; 			// Status - Verzögerte Abstellung aktiv Status - Delayed Shutdown active
	
	(*----------------------------------------------------------------------------------------*)
	(*Analog Eingänge*)
	
	IN_CU.tCustAnaIn[8].Ai; 			// Messung: Druck Abgasklappe Eintritt
	IN_CU.tCustAnaIn[9].Ai; 			// Messung: Druck Abgasklappe Austritt
	IN_CU.tCustAnaIn[10].Ai; 			// Messung: Temperatur Abgasklappe Austritt
	IN_CU.tCustAnaIn[12].Ai; 			// Messung: Temperatur nach HDHT Gemischkuehler
	IN_CU.tCustAnaIn[13].Ai; 			// Messung: Temperatur nach NDHT Gemischkuehler
	IN_CU.tCustAnaIn[14].Ai; 			// Messung: Temperatur nach Motorkühlwasser Wämetauscher
	IN_CU.tCustAnaIn[15].Ai; 			// Messung: Öldruck Getriebe
	IN_CU.tCustAnaIn[16].Ai; 			// Messung: Öltemperatur Getriebe
	IN_CU.tCustAnaIn[17].Ai; 			// Messung: Vorlauftemperatur [Niedertemperaturkreis]
	IN_CU.tCustAnaIn[18].Ai; 			// Messung: Temperatur nach HDNT / vor NDNT 
	IN_CU.tCustAnaIn[19].Ai; 			// Messung. Ladetemperatur nach Niederdruck Turbolader
	IN_CU.tCustAnaIn[20].Ai; 			// Messung: Temperatur vor Motorkühlwasser Wämetauscher
	IN_CU.tCustAnaIn[23].Ai; 			// Messung: Gasdruck Gasstrecke Eintritt
	IN_CU.tCustAnaIn[24].Ai; 			// Messung: Gasdruck nach Gasfilter 1
	IN_CU.tCustAnaIn[25].Ai; 			// Measurement - Low Temperature Circuit water Pressure
	IN_CU.tCustAnaIn[27].Ai; 			// Messung - Rücklauftemperatur nach Notkühler HT
	IN_CU.tCustAnaIn[28].Ai; 			// Messung - Rücklauftemperatur nach Notkühler LT
	IN_CU.tCustAnaIn[29].Ai; 			// Messung - Temperatur Zuluft Motorraum
	IN_CU.tCustAnaIn[30].Ai; 			// Messung: Heizwasserdruck  Austritt Hochtemperaturkreis Pumpe
	IN_CU.tCustAnaIn[31].Ai; 			// Messung: Heizwasserdruck Vorlauf 
	IN_CU.tCustAnaIn[32].Ai; 			// Messung - Niedertemperaturkreis Rücklauftemperatur
	
	(*----------------------------------------------------------------------------------------*)
	(*Analog Ausgänge*)
	(*-!!- ACHTUNG - AUSKOMMENTIEREN DER OUT_CU.tCustAnaOut[x].Ao im task c_ana line 1104ff-!!-*)
	
	OUT_CU.tCustAnaOut[5].Ao; 			// Sollwert - Frequenzumrichter Abgas Lüfter
	OUT_CU.tCustAnaOut[7].Ao; 			// Sollwert: Notkühlventilator 1
	OUT_CU.tCustAnaOut[8].Ao; 			// Sollwert: Notkühler 2
	OUT_CU.tCustAnaOut[9].Ao; 			// Sollwert: Notkühler 3
	OUT_CU.tCustAnaOut[10].Ao; 			// Sollwert: Notkühler 4
	OUT_CU.tCustAnaOut[11].Ao; 			// Sollwert: Zuluftventilator 1
	OUT_CU.tCustAnaOut[12].Ao; 			// Sollwert: Zuluftventilator 2
	OUT_CU.tCustAnaOut[13].Ao; 			// Sollwert: Zuluftventilator 3
	OUT_CU.tCustAnaOut[14].Ao; 			// Sollwert: Zuluftventilator 4
	
	(*----------------------------------------------------------------------------------------*)
	(*Reserveparameter*)
	
	(*Para.rCust_SparePara[x];							// *)
	
	(*******************************************************************************)
	(*******************************************************************************)
	(*----------------------------FUNKTIONSABARBEITUNG-----------------------------*)
	(*******************************************************************************)
	(*******************************************************************************)
	
	
	
	(*-----------------------------------------------------------------------------*)
END_PROGRAM
