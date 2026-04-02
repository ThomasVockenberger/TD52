(*******************************************************************************
Msg_VE	 			 alarms generation MM_ventilation

This code is confidential and proprietary to the INNIO Company.
It may not be used in any form, or reproduced in any manner,
without written permission of the INNIO Company.
Copyright, INNIO Company, 2019

Customized modifications: -
------------------------
 
History:
-------
V0.00.0	29.07.2011	lettenb.	new
V4.00.0 22-08-2013  Maxhera,   	implementation of the module for modular software
V4.03.0	15-12-2015	Perktold,	Reset für alle Warnungen auf TRUE gesetzt + ERDF Meldungen implementiert
V4.04.0	06-10-2016	Perktold	added W2799
														
Instructions for use:
--------------------
1) declare alarm with function block "Msg"

2) use template to create a new alarm, substitue 0000 by message number:

	xMsg0000.Num		:=	0000;					alarm number
	xMsg0000.AmmSysAdr	:=  iAdrAmmBase2MM;			do not change
	xMsg0000.AmmOutAdr	:=  iAdrMM2AmmBase;			do not change

3) 	set alarm number
	

			
Outstandings:
------------
(*******************************************************************************)
PROGRAM _INIT

	iAdrAmmBase2MM		:=  ADR(IN_GR.tAB2GR);
	iAdrMM2AmmBase		:=  ADR(OUT_GR.tGR2AB);

	xMsg2171.Num		:= 	2171;
	xMsg2171.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2171.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2172.Num		:= 	2172;
	xMsg2172.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2172.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2173.Num		:= 	2173;
	xMsg2173.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2173.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2174.Num		:= 	2174;
	xMsg2174.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2174.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2175.Num		:=	2175;
	xMsg2175.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2175.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2176.Num		:= 	2176;
	xMsg2176.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2176.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2177.Num		:= 	2177;
	xMsg2177.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2177.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2178.Num		:= 	2178;
	xMsg2178.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2178.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2179.Num		:= 	2179;
	xMsg2179.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2179.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2180.Num		:= 	2180;
	xMsg2180.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2180.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2181.Num		:= 	2181;
	xMsg2181.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2181.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2182.Num		:= 	2182;
	xMsg2182.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2182.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2183.Num		:= 	2183;
	xMsg2183.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2183.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2184.Num		:=	2184;
	xMsg2184.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2184.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2185.Num		:= 	2185;
	xMsg2185.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2185.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2186.Num		:= 	2186;
	xMsg2186.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2186.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2344.Num		:= 	2344;
	xMsg2344.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2344.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2345.Num		:= 	2345;
	xMsg2345.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2345.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2811.Num		:= 	2811;
	xMsg2811.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2811.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2812.Num		:= 	2812;
	xMsg2812.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2812.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2853.Num		:= 	2853;
	xMsg2853.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2853.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2854.Num		:= 	2854;
	xMsg2854.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2854.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2855.Num		:= 	2855;
	xMsg2855.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2855.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2856.Num		:= 	2856;
	xMsg2856.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2856.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2857.Num		:= 	2857;
	xMsg2857.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2857.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2858.Num		:= 	2858;
	xMsg2858.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2858.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2859.Num		:= 	2859;
	xMsg2859.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2859.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2860.Num		:= 	2860;
	xMsg2860.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2860.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2861.Num		:= 	2861;
	xMsg2861.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2861.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2862.Num		:= 	2862;
	xMsg2862.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2862.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2863.Num		:= 	2863;
	xMsg2863.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2863.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2864.Num		:= 	2864;
	xMsg2864.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2864.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2865.Num		:=  2865;
	xMsg2865.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2865.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2866.Num		:=  2866;
	xMsg2866.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2866.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2867.Num		:=  2867;
	xMsg2867.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2867.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2868.Num		:=  2868;
	xMsg2868.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2868.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2869.Num		:=  2869;
	xMsg2869.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2869.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2870.Num		:=  2870;
	xMsg2870.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2870.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2870.Num		:=  2870;
	xMsg2870.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2870.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg3384.Num		:= 	3384;
	xMsg3384.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3384.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3385.Num		:= 	3385;
	xMsg3385.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3385.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3386.Num		:= 	3386;
	xMsg3386.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3386.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3591.Num		:=  3591;
	xMsg3591.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3591.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3592.Num		:=  3592;
	xMsg3592.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3592.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3593.Num		:=  3593;
	xMsg3593.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3593.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3594.Num		:=  3594;
	xMsg3594.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3594.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3595.Num		:=  3595;
	xMsg3595.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3595.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3596.Num		:=  3596;
	xMsg3596.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg3596.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2799.Num		:=  2799;
	xMsg2799.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2799.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2940.Num		:=  2940;
	xMsg2940.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2940.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2941.Num		:=  2941;
	xMsg2941.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2941.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2942.Num		:=  2942;
	xMsg2942.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2942.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2943.Num		:=  2943;
	xMsg2943.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2943.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2944.Num		:=  2944;
	xMsg2944.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2944.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2945.Num		:=  2945;
	xMsg2945.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2945.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2946.Num		:=  2946;
	xMsg2946.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2946.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2947.Num		:=  2947;
	xMsg2947.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2947.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2948.Num		:=  2948;
	xMsg2948.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2948.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2949.Num		:=  2949;
	xMsg2949.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2949.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2950.Num		:=  2950;
	xMsg2950.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2950.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2951.Num		:=  2951;
	xMsg2951.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2951.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg2952.Num		:=  2952;
	xMsg2952.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2952.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2953.Num		:=  2953;
	xMsg2953.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2953.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2954.Num		:=  2954;
	xMsg2954.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2954.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2955.Num		:=  2955;
	xMsg2955.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2955.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg2331.Num		:=  2331;
	xMsg2331.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg2331.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg3000.Num		:=	3000;
	xMsg3000.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg3000.AmmOutAdr	:=	iAdrMM2AmmBase;
	
	xMsg9261.Num		:=  9261;
	xMsg9261.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9261.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg9262.Num		:=  9262;
	xMsg9262.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9262.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9263.Num		:=  9263;
	xMsg9263.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9263.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9264.Num		:=  9264;
	xMsg9264.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9264.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9265.Num		:=  9265;
	xMsg9265.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9265.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9266.Num		:=  9266;
	xMsg9266.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9266.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9267.Num		:=  9267;
	xMsg9267.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9267.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9268.Num		:=  9268;
	xMsg9268.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9268.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9269.Num		:=  9269;
	xMsg9269.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9269.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9270.Num		:=  9270;
	xMsg9270.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9270.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9271.Num		:=  9271;
	xMsg9271.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9271.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9272.Num		:=  9272;
	xMsg9272.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9272.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9273.Num		:=  9273;
	xMsg9273.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9273.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9274.Num		:=  9274;
	xMsg9274.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9274.AmmOutAdr	:=  iAdrMM2AmmBase;	

	xMsg9008.Num		:=  9008;
	xMsg9008.AmmInAdr	:=  iAdrAmmBase2MM;
	xMsg9008.AmmOutAdr	:=  iAdrMM2AmmBase;	
	
	xMsg9009.Num		:=	9009;
	xMsg9009.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9009.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9010.Num		:=	9010;
	xMsg9010.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9010.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9011.Num		:=	9011;
	xMsg9011.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9011.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9012.Num		:=	9012;
	xMsg9012.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9012.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9013.Num		:=	9013;
	xMsg9013.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9013.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9014.Num		:=	9014;
	xMsg9014.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9014.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9015.Num		:=	9015;
	xMsg9015.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9015.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9016.Num		:=	9016;
	xMsg9016.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9016.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9017.Num		:=	9017;
	xMsg9017.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9017.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9018.Num		:=	9018;
	xMsg9018.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9018.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9019.Num		:=	9019;
	xMsg9019.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9019.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9020.Num		:=	9020;
	xMsg9020.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9020.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9021.Num		:=	9021;
	xMsg9021.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9021.AmmOutAdr	:=	iAdrMM2AmmBase;
	
	xMsg9022.Num		:=	9022;
	xMsg9022.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9022.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9023.Num		:=	9023;
	xMsg9023.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9023.AmmOutAdr	:=	iAdrMM2AmmBase;

	xMsg9093.Num		:=	9093;
	xMsg9093.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9093.AmmOutAdr	:=	iAdrMM2AmmBase;
	
	xMsg9094.Num		:=	9094;
	xMsg9094.AmmInAdr	:=	iAdrAmmBase2MM;
	xMsg9094.AmmOutAdr	:=	iAdrMM2AmmBase;
	
END_PROGRAM

