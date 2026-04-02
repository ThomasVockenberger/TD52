(********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Package: ParaBase
 * File: ParaBase.typ
 * Author: zengeres
 * Created: September 14, 2012
 ********************************************************************
 * Data types of package ParaBase 
 ********************************************************************)

TYPE
	IN_PB_Struct : 	STRUCT 
		tVE2PB : MM2ParaBase_type; (*VE Ventilation*) (*OldName: new PV; Cycle: 5;*)
		tHC2PB : MM2ParaBase_type; (*HC Heating Cooling*) (*OldName: new PV; Cycle: 5;*)
		tEX2PB : MM2ParaBase_type; (*EX Exhaust*) (*OldName: new PV; Cycle: 5;*)
		tTR2PB : MM2ParaBase_type; (*TR ParaBase*) (*OldName: new PV; Cycle: 5;*)
		tGC2PB : MM2ParaBase_type; (*GC Generator Control*) (*OldName: new PV; Cycle: 5;*)
		tCU2PB : MM2ParaBase_type; (*CU Customized*) (*OldName: new PV; Cycle: 5;*)
		tMO2PB : MM2ParaBase_type; (*MO Monic*) (*OldName: new PV; Cycle: 5;*)
		tIC2PB : MM2ParaBase_type; (*IC ICxxx*) (*OldName: new PV; Cycle: 5;*)
		tIG2PB : MM2ParaBase_type; (*IG Ignition*) (*OldName: new PV; Cycle: 5;*)
		tSY2PB : MM2ParaBase_type; (*SY Synchronization*) (*OldName: new PV; Cycle: 5;*)
		tCP2PB : MM2ParaBase_type; (*CP Coupling*) (*OldName: new PV; Cycle: 5;*)
		tEC2PB : MM2ParaBase_type; (*EC EngineController*) (*OldName: new PV; Cycle: 5;*)
		tEG2PB : MM2ParaBase_type; (*EG EngineGeneral*) (*OldName: new PV; Cycle: 5;*)
		tEM2PB : MM2ParaBase_type; (*EM Exhaust Monitoring*) (*OldName: new PV; Cycle: 5;*)
		tKN2PB : MM2ParaBase_type; (*KN Knocking*) (*OldName: new PV; Cycle: 5;*)
		tGM2PB : MM2ParaBase_type; (*GM GasMixer*) (*OldName: new PV; Cycle: 5;*)
		tGR2PB : MM2ParaBase_type; (*GR Grid Codes*) (*OldName: new PV; Cycle: 5;*)
		tGT2PB : MM2ParaBase_type; (*GT GasTrain*) (*OldName: new PV; Cycle: 5;*)
		tAG2PB : MM2ParaBase_type; (*AG AuxiliariesGeneral*) (*OldName: new PV; Cycle: 5;*)
		tOP2PB : MM2ParaBase_type; (*OP Opstate*) (*OldName: new PV; Cycle: 5;*)
		tSA2PB : MM2ParaBase_type; (*SA SAFI*) (*OldName: new PV; Cycle: 5;*)
		tKL2PB : MM2ParaBase_type; (*KL KLS98*) (*OldName: new PV; Cycle: 5;*)
		tGD2PB : MM2ParaBase_type; (*GD Gas Dosing (Tecjet)  ALT: GMU	GasMeteringUnit*) (*OldName: new PV; Cycle: 5;*)
		tCH2PB : MM2ParaBase_type; (*CH ChargingUnit*) (*OldName: new PV; Cycle: 5;*)
		tHA2PB : MM2ParaBase_type; (*HA HalIO*) (*OldName: new PV; Cycle: 5;*)
		tAB2PB : MM2ParaBase_type; (*AB AlarmBase Vorsicht NAME ABWEICHEND wegen Konflikt mit Amm- RÜCKGÄNGIG GEMACHT*) (*OldName: new PV; Cycle: 5;*)
		tCB2PB : MM2ParaBase_type; (*prepared: CBM Module*) (*OldName: new PV; Cycle: 5;*)
		tVI2PB : MM2ParaBase_type; (*VI Visu*) (*OldName: new PV; Cycle: 5;*)
		tPB2PB : MM2ParaBase_type; (*INTERNAL USE ONLY in PB module! Selbstgespräche...*) (*OldName: new PV; Cycle: 5;*)
		tPB2MM : ParaBase2MM_type; (*INTERNAL USE ONLY  in PB module! Selbstgespräche wieder zurück...*) (*OldName: new PV; Cycle: 5;*)
		tTB2PB : MM2ParaBase_type; (*USE ONLY for TESTBENCH module!*) (*OldName: new PV; Cycle: 5;*)
		iPassLevel : INT; (*pass level actual*) (*OldName: Userlevel; Cycle: 5;*)
		tResetRemExt : HALioDi_Type; (*reset remote external*) (*OldName: new PV; Cycle: 5;*)
		tGCB_On : HALioDi_Type; (*generator circuit breaker closed*) (*OldName: GS_EIN; Cycle: 5;*)
		tGCB_RUC : HALioDo_Type; (*generator circuit breaker release undervoltage coil*) (*OldName: USP; Cycle: 5;*)
		tSafetyLoop_Eng : HALioDi_Type; (*safety loop engine*) (*OldName: new PV; Cycle: 5;*)
		iIdx_OMSS : INT; (*operation selection*) (*OldName: BWS_H, BWS_A, BHS_HA,; Cycle: 5;*)
		iSt_OpMode : UDINT; (*engine operation status*) (*OldName: verschiedene; Cycle: 5;*)
		rN_EngAct : REAL; (*engine speed actual [1/min]*) (*OldName: n_ist; Cycle: 5;*)
		iCnt_OpHours : DINT; (* engine operating hours counter (from Module Opstate)*) (*OldName:betrieb_h;Cycle:2;*)
		iCnt_Starts : DINT; (* start counter  (from Module Opstate)*) (*OldName:start_z;Cycle:2;*)
		iCnt_FastStarts : DINT; (*Fast  start counter  (from Module Opstate)*)
		iCnt_UnitOpHours : DINT; (* unit operating hours counter (from Module Opstate)*)
		StationIO : BOOL;
		bSimWinMOD_Active : BOOL; (*V4.10*)
		tAlarmB2PB : AmmBase2MM; (* OWN AlarmBase CONNECTOR as Ammm- Structuretype*) (*OldName: new PV; Cycle: 5;*)
	END_STRUCT;
	OUT_PB_Struct : 	STRUCT 
		iCnt_OpHours_Set : DINT; (*new V4.13 for ParaBase Counter Set*)
		iCnt_UnitOpHours_Set : DINT; (*new V4.13 for ParaBase Counter Set*)
		iCnt_Starts_Set : DINT; (*new V4.13 for ParaBase Counter Set*)
		iCnt_FastStarts_Set : DINT; (*new V4.13 for ParaBase Counter Set*)
		bMsg1995 : BOOL; (*V24*)
		bMsg2000 : BOOL;
		tPB2MM : ParaBase2MM_type; (*USE THIS INTERFACE structure to connect ALL other modules*)
		tPB2AB : MM2AmmBase; (* OWN AlarmBase CONNECTOR as Ammm- Structuretype*)
		tPB2PB : MM2ParaBase_type; (*INTERNAL USE ONLY in PB module! do NOT connect in vvm Selbstgespräche...*) (*OldName: new PV; Cycle: 5;*)
		tSys_Run : HALioDo_Type; (*RUN DigitaOut bit to HAL*) (*OldName: RUN; Cycle: 5;*)
		tSys_Run1 : HALioDo_Type; (*RUN DigitaOut bit to HAL*) (*OldName: RUN; Cycle: 5;*)
		tSys_Run2 : HALioDo_Type; (*RUN DigitaOut bit to HAL*) (*OldName: RUN; Cycle: 5;*)
		tSys_Run3 : HALioDo_Type; (*RUN DigitaOut bit to HAL*) (*OldName: RUN; Cycle: 5;*)
		tSys_Run4 : HALioDo_Type; (*RUN DigitaOut bit to HAL*) (*OldName: RUN; Cycle: 5;*)
		tSys_Run5 : HALioDo_Type; (*RUN DigitaOut bit to HAL*) (*OldName: RUN; Cycle: 5;*)
		tSys_Run6 : HALioDo_Type; (*RUN DigitaOut bit to HAL*) (*OldName: RUN; Cycle: 5;*)
	END_STRUCT;
	MM2VIS_Struct : 	STRUCT 
		tPB2VIS : ParaBase2MM_type; (*Uses type of interface to all structure for visu display allso*)
		bDownloadDetected : BOOL := FALSE; (*doppelt?*)
		tModuleState : ARRAY[0..36]OF ModuleInfo_type; (* BUNDELED STATUS INFORMATION of all software modules*)
		bVisVersionClaimsOk : BOOL; (*TRUE=reported VIS version number fits the claimed minimum requirements*)
		tClaimVisVersion : Revision_type;
		bMsg1901 : BOOL;
		bMsg1902 : BOOL;
		bMsg1903 : BOOL;
		bMsg1904 : BOOL;
		bMsg1905 : BOOL;
		bMsg1906 : BOOL;
		bMsg1907 : BOOL;
		bMsg1908 : BOOL;
		bMsg1909 : BOOL;
		bMsg1910 : BOOL;
		bMsg1911 : BOOL;
		bMsg1912 : BOOL;
		bMsg1913 : BOOL;
		bMsg1914 : BOOL;
		bMsg1915 : BOOL;
		bMsg1916 : BOOL;
		bMsg1917 : BOOL;
		bMsg1918 : BOOL;
		bMsg1919 : BOOL;
		bMsg1920 : BOOL;
		bMsg1921 : BOOL;
		bMsg1922 : BOOL;
		bMsg1923 : BOOL;
		bMsg1924 : BOOL;
		bMsg1925 : BOOL;
		bMsg1926 : BOOL;
		bMsg1927 : BOOL;
		bMsg1928 : BOOL;
		bMsg1929 : BOOL;
		bMsg1930 : BOOL;
		bMsg1931 : BOOL;
		bMsg1932 : BOOL;
		bMsg1933 : BOOL;
		bMsg1934 : BOOL;
		bMsg1935 : BOOL;
		bMsg1936 : BOOL;
		bMsg1937 : BOOL;
		bMsg1938 : BOOL;
		bMsg1939 : BOOL;
		bMsg1940 : BOOL;
		bMsg1941 : BOOL;
		bMsg1942 : BOOL;
		bMsg1943 : BOOL;
		bMsg1944 : BOOL;
		bMsg1945 : BOOL;
		bMsg1946 : BOOL;
		bMsg1947 : BOOL;
		bMsg1948 : BOOL;
		bMsg1949 : BOOL;
		bMsg1950 : BOOL;
		bMsg1951 : BOOL;
		bMsg1952 : BOOL;
		bMsg1953 : BOOL;
		bMsg1954 : BOOL;
		bMsg1955 : BOOL;
		bMsg1956 : BOOL;
		bMsg1957 : BOOL;
		bMsg1958 : BOOL;
		bMsg1959 : BOOL;
		bMsg1960 : BOOL;
		bMsg1961 : BOOL;
		bMsg1962 : BOOL;
		bMsg1963 : BOOL;
		bMsg1964 : BOOL;
		bMsg1965 : BOOL;
		bMsg1966 : BOOL;
		bMsg1967 : BOOL;
		bMsg1968 : BOOL;
		bMsg1969 : BOOL;
		bMsg1970 : BOOL;
		bMsg1971 : BOOL;
		bMsg1972 : BOOL;
		bMsg1973 : BOOL;
		bMsg1974 : BOOL;
		bMsg1975 : BOOL;
		bMsg1976 : BOOL;
		bMsg1977 : BOOL;
		bMsg1978 : BOOL;
		bMsg1979 : BOOL;
		bMsg1980 : BOOL;
		bMsg1981 : BOOL;
		bMsg1982 : BOOL;
		bMsg1983 : BOOL;
		bMsg1984 : BOOL;
		bMsg1985 : BOOL;
		bMsg1986 : BOOL;
		bMsg1987 : BOOL;
		bMsg1988 : BOOL;
		bMsg1989 : BOOL;
		bMsg1990 : BOOL;
		bMsg1991 : BOOL;
		iMsg1991 : DINT;
		bMsg1992 : BOOL;
		iMsg1992 : DINT;
		bMsg1993 : BOOL;
		iMsg1993 : DINT;
		bMsg1994 : BOOL;
		iMsg1994 : DINT;
		bMsg1995 : BOOL;
		iMsg1995 : DINT;
		bMsg1996 : BOOL;
		iMsg1996 : DINT;
		bMsg1997 : BOOL;
		iMsg1997 : DINT;
		bMsg1998 : BOOL;
		iMsg1998 : DINT;
		bMsg1999 : BOOL;
		iMsg1999 : DINT;
		bMsg2000 : BOOL;
		iMsg2000 : DINT;
	END_STRUCT;
	VIS2MM_Struct : 	STRUCT 
		bParaSaveOnce : BOOL; (*manually initiate a parameter save*)
		iParaSaveOnce_ModuleID : UDINT; (*Module ID code of a single module to save parameter manually. 0 for all modules*)
		bReleasePVI : BOOL; (*restricted!*)
		bRequestPVI : BOOL; (*restricted!*)
		iCnt_OpHours_DataMax : DINT; (* engine operating hours counter (Max Value from VIS DATABASE)*)
		iCnt_OpHours_DataMin : DINT; (* engine operating hours counter (SPARE Min. Value from VIS DATABASE)*)
		iCnt_UnitOpHours_DataMax : DINT; (* unit operating hours counter (Max Value from VIS DATABASE)*)
		iCnt_UnitOpHours_DataMin : DINT; (* unit operating hours counter (SPARE, Min. Value from VIS DATABASE)*)
		iCnt_Starts_DataMax : DINT; (* engine starts counter (Max Value from VIS DATABASE)*)
		iCnt_Starts_DataMin : DINT; (* engine starts counter (SPARE, Minx Value from VIS DATABASE)*)
		iCnt_FastStarts_DataMax : DINT; (* engine starts counter (Max Value from VIS DATABASE)*)
		iCnt_FastStarts_DataMin : DINT; (* engine starts counter (SPARE, Min Value from VIS DATABASE)*)
		iCmd_OpHours_SetCounter : UDINT; (*User command button: 1=set counters, 1+2=3=add to actual counters, 1+8=9=set offset to ignore DB max*)
		iCmd_OpHours_SetCorrMode : UDINT; (*User command button ADD VALUE: 0=set counters, 2=add to actual counters, 8=set offset to ignore DB max*)
		iCnt_OpHours_StoredOffset : DINT; (*ToDo: clarify*)
		iCnt_UnitOpHours_StoredOffset : DINT; (*ToDo: clarify*)
		iCnt_Starts_StoredOffset : DINT; (*ToDo: clarify*)
		iCnt_FastStarts_StoredOffset : DINT; (*ToDo: clarify*)
		tVisVersion : Revision_type;
	END_STRUCT;
END_TYPE
