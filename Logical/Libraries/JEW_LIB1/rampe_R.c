/********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: JEW_LIB1
 * File: rampe_R.c
 * Author: 320003156
 * Created: August 17, 2011
 *******************************************************************/

#include <jew_lib1.h>

void RAMPE_R(RAMPE_R_typ *fd)
{
	if (fd->enable)
	{
		if (fd->Out < fd->In)
		{
			fd->f_out = fd->f_out + (0.001 * fd->Rise * fd->TC_Time);
			if (fd->f_out > fd->In)
				fd->f_out = fd->In;
		}
		else if (fd->Out > fd->In)
		{
			fd->f_out = fd->f_out - (0.001 * fd->Sink * fd->TC_Time);
			if (fd->f_out < fd->In)
				fd->f_out = fd->In;
		}
		
		fd->Out = fd->f_out;
	}
	else
	{
		fd->Out = fd->In;
		fd->f_out = fd->In;
	}
}
