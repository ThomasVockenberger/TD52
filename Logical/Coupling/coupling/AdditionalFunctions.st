(*******************************************************************************
coupling        additional functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	17.07.2012	froehlichw	new
V0.00.1	14.01.2019	Denk		adapted for bus test forcing

Instructions for use:
--------------------

Outstandings:
------------

(*******************************************************************************)

(*-----------------------------------------------------------------
/* compress and copy BOOL-Array at scrAdr to INT-Array at dstAdr
/* IN: scrAdr ... source address (start address of BOOL-Array)
/*     dstAdr ... destination address (base address=[0] of INT-Array)
/*     idxMin ... start index of INT-Array for copy
/*     idxMax ... end index of INT-Array for copy
/*---------------------------------------------------------------*)
ACTION BusTest_BOOL_TO_INT:
	FOR idx1:= idxMin TO idxMax DO
		pScrData ACCESS (srcAdr + (idx1 - idxMin) * 16);
		pDstData ACCESS (dstAdr + SIZEOF(pDstData) * idx1);
		pDstData.0:= pScrData[0];
		pDstData.1:= pScrData[1];
		pDstData.2:= pScrData[2];
		pDstData.3:= pScrData[3];
		pDstData.4:= pScrData[4];
		pDstData.5:= pScrData[5];
		pDstData.6:= pScrData[6];
		pDstData.7:= pScrData[7];
		pDstData.8:= pScrData[8];
		pDstData.9:= pScrData[9];
		pDstData.10:= pScrData[10];
		pDstData.11:= pScrData[11];
		pDstData.12:= pScrData[12];
		pDstData.13:= pScrData[13];
		pDstData.14:= pScrData[14];
		pDstData.15:= pScrData[15];
	END_FOR;
END_ACTION


(*-----------------------------------------------------------------
/* compress AND copy INT-Array at srcAdr TO BOOL-Array at dstAdr 
/* IN: dstAdr ... destination address (start address OF BOOL-Array)
/*     scrAdr ... source address (base address=[0] OF INT-Array)
/*     idxMin ... start index OF INT-Array FOR copy
/*     idxMax ... end index OF INT-Array FOR copy
/*---------------------------------------------------------------*)
ACTION BusTest_INT_TO_BOOL:
	FOR idx1:= idxMin TO idxMax DO
		pScrData1 ACCESS (srcAdr + SIZEOF(pScrData1) * idx1);
		pDstData1 ACCESS (dstAdr + (idx1 - idxMin) * 16);
		pDstData1[0]:= pScrData1.0;	
		pDstData1[1]:= pScrData1.1;
		pDstData1[2]:= pScrData1.2;
		pDstData1[3]:= pScrData1.3;
		pDstData1[4]:= pScrData1.4;
		pDstData1[5]:= pScrData1.5;
		pDstData1[6]:= pScrData1.6;
		pDstData1[7]:= pScrData1.7;
		pDstData1[8]:= pScrData1.8;
		pDstData1[9]:= pScrData1.9;
		pDstData1[10]:= pScrData1.10;
		pDstData1[11]:= pScrData1.11;
		pDstData1[12]:= pScrData1.12;
		pDstData1[13]:= pScrData1.13;
		pDstData1[14]:= pScrData1.14;
		pDstData1[15]:= pScrData1.15;
	END_FOR;
END_ACTION