/********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: JEW_LIB1
 * File: timebasedonoff_R.c
 * Author: 320003156
 * Created: August 23, 2011
 *******************************************************************/

#include <jew_lib1.h>
#include <bur/plctypes.h>

void TimeBasedOnOff(TimeBasedOnOff_typ *fd)
/* begin FUB */
{

if (fd->enable != 0)
{
	fd->status = 0;		/* reset status */

	/* calculate basetime for 1 step of x */
	if (fd->tchange != 0)
	{
		fd->fUnitTime = (float)(fd->max_value - fd->min_value)/fd->tchange;
	}	
	else
	{
		fd->status = 1;		/* no change time from min_value to max_value */
	}	
	
	/* calcualte time difference since last cycle */
	fd->fDiffTime = fd->basetime - fd->ulLastTime;

	/* calculate minimum hysteresis for the next step */
	fd->fHysteresis = fd->fUnitTime*fd->fDiffTime;

	/* calculate actual position and hysteresis for the next step */
	if (fd->up != 0) 	/* open actuator */
	{
		fd->y_act   = fd->y_act + fd->fHysteresis;		/* calcualte new actual position = y_act + fDiffTime*fUnitTime*/

		fd->fHystUp = fd->fHysteresis;					/* set to minimum up hystersis */

		if (fd->fHysteresis < fd->hysteresis)		/* is mimimum hysteresis < user hysteresis */
		{
			fd->fHystDown = fd->hysteresis;		/* use user down hysteresis */
		}	
		else
		{
			fd->fHystDown = fd->fHysteresis;	/* set to minimum down hysteresis */
		}

	}
	else if (fd->down != 0)		/* close actuator */ 
	{
		fd->y_act     = fd->y_act - fd->fHysteresis;		/* calcualte new actual position close = y_act - fDiffTime*fUnitTime*/

		fd->fHystDown = fd->fHysteresis;					/* set to minimum down hysteresis */

		if (fd->fHysteresis < fd->hysteresis)		/* is mimimum hysteresis < user hysteresis */
		{
			fd->fHystUp = fd->hysteresis;		/* use user up hysteresis */
		}	
		else
		{
			fd->fHystUp = fd->fHysteresis;		/* set to minimum up hysteresis */
		}	
	}
	else		/* actuator stopped */
	{
		if (fd->fHysteresis < fd->hysteresis)		/* is mimimum hysteresis < user hysteresis */
		{
			fd->fHystUp   = fd->hysteresis;		/* use user up hysteresis */
			fd->fHystDown = fd->fHystUp;		/* use user down hysteresis */
		}	
		else
		{
			fd->fHystUp   = fd->fHysteresis;		/* set to minimum up hysteresis */
			fd->fHystDown = fd->fHystUp;			/* set to minimum down hysteresis */
		}
	}
	
	if (fd->x >= fd->y_act + fd->fHystUp)		/* setpoint position >= actual position + hysteresis */
	{
		fd->up   = 1;		/* set bit for open */
		fd->down = 0;		/* reset bit for close */
	}
	else if (fd->x <= fd->y_act - fd->fHystDown)		/* setpoint position <= actual position - hysteresis */
	{
		fd->down = 1;		/* set bit for close */
		fd->up   = 0;		/* reset bit for open */
	}
	else		/* if difference between actual and setpoint positioin within hystetrsis */
	{
		fd->up   = 0;		/* reset bit for open */
		fd->down = 0;		/* reset bit for close */
	}
}
else
{
	fd->y_act = fd->set_pos;
}

if (fd->y_act >= 0)	/* check pos. or neg. output and compensate rounding error */
{
	fd->y          = (fd->y_act+0.5);	/* actual position FUB output */
}
else
{
	fd->y          = (fd->y_act-0.5);	/* actual position FUB output */
}

fd->ulLastTime = fd->basetime;				/* save last cycle time */

/* end FUB */
}
