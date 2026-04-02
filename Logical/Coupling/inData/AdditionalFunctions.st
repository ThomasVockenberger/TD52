(*******************************************************************************
outData        additianal functions

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	17.07.2012	froehlichw	new

Instructions for use:
--------------------

Outstandings:
------------

(*******************************************************************************)

(*-----------------------------------------------------------------
/* compress and copy INT-Array at srcAdr to BOOL-Array at dstAdr 
/* IN: dstAdr ... destination address (start address of BOOL-Array)
/*     scrAdr ... source address (base address=[0] of INT-Array)
/*     idxMin ... start index of INT-Array for copy
/*     idxMax ... end index of INT-Array for copy
/*---------------------------------------------------------------*)
ACTION CompressAndCopyIn:
	FOR idx:= idxMin TO idxMax DO
		pScrData ACCESS (srcAdr + SIZEOF(pScrData) * idx);
		pDstData ACCESS (dstAdr + (idx - idxMin) * 16);	
		pDstData[1]:= pScrData.1;
		pDstData[2]:= pScrData.2;
		pDstData[3]:= pScrData.3;
		pDstData[4]:= pScrData.4;
		pDstData[5]:= pScrData.5;
		pDstData[6]:= pScrData.6;
		pDstData[7]:= pScrData.7;
		pDstData[8]:= pScrData.8;
		pDstData[9]:= pScrData.9;
		pDstData[10]:= pScrData.10;
		pDstData[11]:= pScrData.11;
		pDstData[12]:= pScrData.12;
		pDstData[13]:= pScrData.13;
		pDstData[14]:= pScrData.14;
		pDstData[15]:= pScrData.15;
	END_FOR;
END_ACTION
