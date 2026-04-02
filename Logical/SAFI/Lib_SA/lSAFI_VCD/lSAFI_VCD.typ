

TYPE
	tSAFI_VCD_DBG :  STRUCT   
		StdVC_Dbg :  REAL; (*Standarddeviationofthelast100detectedvalveclosureevents(s)*)  
		iVC_out_perc :  UINT; (*Post-processedmainvalveclosuretimingpercentage(%)*)  
		iVC_2ndPeak :  UINT; (*2ndhighestvalveclosuretiming(°CA)*)  
		iVC_2ndPeak_perc :  UINT; (*2ndhighestvalveclosuretimingpercentage(%)*)  
	END_STRUCT;

	tSAFI_VCD_IN :  STRUCT   
		VC_in :  UINT; (*Rawvalveclosuretiming(°CA)*)  
		WinStart :  UINT; (*Windowstart(°CA)*)  
		bReset :  BOOL; (*Reset()*)  
	END_STRUCT;

	tSAFI_VCD_OUT :  STRUCT   
		VC_out :  UINT; (*Post-processedmainvalveclosuretiming(°CA)*)  
		bUnbalance :  BOOL; (*Valveunbalancedetected()*)  
	END_STRUCT;

	tSAFI_VCD_PARA :  STRUCT   
		StdLim :  REAL; (*Standarddeviationlimitforonesignal(°CA)*)  
		iDistanceLim :  UINT; (*Distancebetween1stand2ndpeaklimitforvalveunbalancedetection(°CA)*)  
		iPeakPercLim :  UINT; (*Percentageofvalveclosuredetectiontimingminimumlimitforvalveunbalancedetection(%)*)  
		iEarlyClosureLim :  UINT; (*Absolutelimitbeforewhichanunbalanceisdetectedforvalveunbalancedetection(°CA)*)  
	END_STRUCT;

END_TYPE

TYPE
rtB_FindVC_SAFI_VCD : STRUCT
	VCpeaks_data : ARRAY[0..718] OF LREAL;
	IdxVCpeaks_data : ARRAY[0..718] OF LREAL;
	dv : ARRAY[0..718] OF LREAL;
	dv1 : ARRAY[0..718] OF LREAL;
	Y_data : ARRAY[0..718] OF LREAL;
	StdVC_Dbg : REAL;
	VC_out_perc : UINT;
	VC_2ndPeak : UINT;
	VC_2ndPeak_perc : UINT;
	VC_out : UINT;
END_STRUCT;
rtDW_FindVC_SAFI_VCD : STRUCT
	VecVC : ARRAY[0..99] OF REAL;
	idx : UINT;
	idx_not_empty : BOOL;
	VecVC_not_empty : BOOL;
END_STRUCT;
BlockIO_SAFI_VCD : STRUCT
	BusInput3 : tSAFI_VCD_PARA;
	BusInput2 : tSAFI_VCD_IN;
	UnitDelay : UDINT;
	sf_FindVC : rtB_FindVC_SAFI_VCD;
END_STRUCT;
D_Work_SAFI_VCD : STRUCT
	UnitDelay_DSTATE : UDINT;
	sf_FindVC : rtDW_FindVC_SAFI_VCD;
END_STRUCT;
ExternalInputs_SAFI_VCD : STRUCT
	In : tSAFI_VCD_IN;
	Para : tSAFI_VCD_PARA;
END_STRUCT;
ExternalOutputs_SAFI_VCD : STRUCT
	Out : tSAFI_VCD_OUT;
	Out1 : tSAFI_VCD_DBG;
END_STRUCT;
tag_RTM_SAFI_VCD : STRUCT
	errorStatus : REFERENCE TO USINT;
	blockIO : REFERENCE TO BlockIO_SAFI_VCD;
	inputs : REFERENCE TO ExternalInputs_SAFI_VCD;
	outputs : REFERENCE TO ExternalOutputs_SAFI_VCD;
	dwork : REFERENCE TO D_Work_SAFI_VCD;
END_STRUCT;
RT_MODEL_SAFI_VCD : tag_RTM_SAFI_VCD;
END_TYPE
TYPE
END_TYPE