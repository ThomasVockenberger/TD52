/***********************************************************************************
* Name      : JWASLIB2
* Title     : Special functions for module controll
* Version   : V1.40
* Date      : 18.02.2004
*
* History   :
*  V1.40	  18.02.2004,TEE/TW add function block AlarmSequence
*  V1.41	  16.12.2004,TEE/TW AmmSequence: alarm reset handling improved
*
*
***********************************************************************************/
/*******************************************************************************
* AGGR: AmmSequence.c - message sequencer for alarm management
*
* This code is confidential and proprietary to the INNIO Company.
* It may not be used in any form, or reproduced in any manner, without the express
* written permission of the INNIO Company.
* Copyright, INNIO Company, 2004
* 
* Input : 	Enable		BOOL		enable function block
*			ClockPulse	BOOL		external clock pulse to sequence the different amm messages (AM)
*			NrOfBits	USINT		number of bits that should be checked
*			BitArray	UDINT		address of the alram bit array
*
* Output:   Alarm1		BOOL		if any AM in the array is active then the output is 1
*           Alarm2		BOOL		signals the output of a new AM with the same pulse as the clock pulse
*			ErrorNr		USINT		signals the bit number of a new AM
*			Status		UINT		gives back a number if fub works correct or not
*
* Var	:	InputArray	BOOL[256]	image of input array
*			OutputArray BOOL[256]	image of output array
*			ChkValue	USINT		check counter for sequencing
*			ChkEdge		BOOL		check the rising edge of the pulse signal
*
* History:
* -------
* V0.1	18-02-04	Weitzer, generated
*		
* V0.2	16-12-04	Weitzer, alarm reset handling improved
*
* V0.3	02-11-05	Weitzer, reset of Alarm1 and Alarm2 bits if inputs and enable is false
*
* Outstandings:
* ------------
*
*******************************************************************************/
#include <JWASLIB2.h>

void AmmSequence(AmmSequence_typ* inst)
{
	
	/* declaration of additional tags */
	
	unsigned short	n;				/* counter for loops */
	unsigned short	InputSum;		/* check if any alarm is set */
	plcbit*			ArrayAdr;		/* data tag for adress pointer */
	plcbit			ResetAll;		/* flag for erasing all entries */



	/* prepare data copy from bit array address */	
	
	ArrayAdr = (plcbit*)inst->BitArray;
	

	/* check if FUB is enabled to run */	
	
	if(inst->Enable != 1)
	{ 
	
		/* check if all alarms were put out or a alarm was gone */	
		ResetAll = 0;
		InputSum = 0;
		for(n = 0; n < inst->NrOfBits; ++n)		/* loop over the complete bit array */
		{
			/* check if data adress is valid and for diffences between input and output array */				
			if (ArrayAdr != 0) 
			{
				if (inst->OutputArray[n] != ArrayAdr[n])	ResetAll = 1;		/* set reset flag */
				InputSum = InputSum + ArrayAdr[n];								/* check if any error is set */
			}	
		}
		
		/* if reset flag was set -> reset data = acknowledgement */	
		if (ResetAll == 1 || InputSum == 0) 
		{
			inst->Alarm1   = 0;		/* reset alarm output 1 */
			inst->Alarm2   = 0;		/* reset alarm output 2 */
			inst->ErrorNr  = 0;		/* reset error number output */
			inst->ChkValue = 0;		/* reset check value */
			inst->ChkEdge  = 0;		/* reset check edge */
		
			for(n = 0; n < inst->NrOfBits; ++n)		/* loop over the complete bit array */
			{
				inst->InputArray[n]  = 0;		/* reset image of input array  */
				inst->OutputArray[n] = 0;		/* reset image of output array */
			}
		}
		inst->Status   = 0;		/* reset status output */	
		
	}

	/* if FUB is enabled -> monitoring and output is active */
	else
	{
	
		/* check if address of bit array exists */
		if(ArrayAdr != 0)
		{
		
			/* search in the array for new alarm messages */
		
			for(n = 0; n < inst->NrOfBits; ++n)		/* loop over the number of bits */
			{
				/* check bit array address at position n */
				if(ArrayAdr[n] == 1)	
				{
			 		/* check if it is the first entry */
					if(inst->Alarm1 == 0)
					{
						inst->ErrorNr  = n;			/* set output error number */
						inst->ChkValue = 0;			/* reset check value to start with number output */
					}	
					inst->Alarm1        = 1;		/* set general alarm output 1 */
					inst->InputArray[n] = 1;		/* set alarm entry at the input image */
				}
			}
					
			
			/* create sequenced alarm output */
			
			/* if any entry has been made */
			if(inst->Alarm1 == 1)
			{
				/* wait for positiv edge of the pulse input */
				if(inst->ClockPulse == 1)
				{
					/* check if it was the first call after the edge */
					if(inst->ChkEdge == 0)
					{
						inst->ChkEdge = 1;		/* set check bit for toggeling the check value */
						
						/* toggeling between number and pulse output */
						
						/* number output */
						if(inst->ChkValue == 0) 
						{							
							for(n = 0; n < inst->NrOfBits; ++n)		/* loop over the number of bits */
							{
								/* check for alarm message which were not copied to the output entry */
								if(inst->OutputArray[n] == 0)
								{
									/* set output if there is a new message in the input image */
									if(inst->InputArray[n] == 1) 
									{
										inst->Alarm2         = 0;					/* set alarm output pulse */
										inst->ErrorNr        = n;					/* set output error number */				
										inst->OutputArray[n] = 1;					/* set entry in the output image */
										n                    = inst->NrOfBits;		/* exit loop */
										inst->ChkValue       = 1;					/* set value to detect the change */
									}
								}
								
								/* check bit array at position n if inputs have gone */
								else if (ArrayAdr[n] == 0) inst->InputArray[n]  = 0;		/* reset entry in the input image */
							
								/* check if old messages exits */
								inst->ChkValue = inst->ChkValue + inst->OutputArray[n];	
							}
						
							/* check if no new message or no old message exits */
							if(inst->ChkValue == 0)
							{
								inst->Alarm1 = 0;		/* reset alarm output 1 if no alarm in the input image */
								inst->Alarm2 = 0;		/* reset alarm output pulse if no alarm to output */
							}	
							else inst->ChkValue = 1;		/* else output next message */
															
						}
						
						/* pulse output Alarm2 */
						else 
						{
							inst->Alarm2   = 1;		/* set alarm output pulse */
							inst->ChkValue = 0;		/* reset check value for switching to pulse output */
						}	
					}
				}
				else inst->ChkEdge = 0;		/* reset edge detection */
			}
			
		}
		
		/* error handling */
				
		/* set status output to 1 if no pointer connected */
		else inst->Status  = 1;			

		/* set status output to 2 if number of bits is 0 */
		if(inst->NrOfBits == 0) inst->Status = 2;			
	}
}
