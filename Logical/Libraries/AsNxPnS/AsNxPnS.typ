                                                                       
TYPE
	PnSoftwareRevisionType : 	STRUCT 
		Prefix : USINT;
		X : USINT;
		Y : USINT;
		Z : USINT;
	END_STRUCT;
	PnIm0Type : 	STRUCT 
		VendorID : UINT;
		OrderID : ARRAY[0..19]OF USINT;
		SerialNumber : ARRAY[0..15]OF USINT;
		HardwareRevision : UINT;
		SoftwareRevision : PnSoftwareRevisionType;
		RevisionCounter : UINT;
		ProfileID : UINT;
		ProfileSpecificType : UINT;
		IMVersion : UINT;
		IMSupported : UINT;
	END_STRUCT;
	PnIm5Type : 	STRUCT 
		Annotation : ARRAY[0..63]OF USINT;
		OrderID : ARRAY[0..63]OF USINT;
		VendorID : UINT;
		SerialNumber : ARRAY[0..15]OF USINT;
		HardwareRevision : UINT;
		SoftwareRevision : PnSoftwareRevisionType;
	END_STRUCT;
END_TYPE 
