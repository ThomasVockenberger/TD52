/********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: JEW_LIB1
 * File: filter_R.c
 * Author: 320003156
 * Created: August 17, 2011
 *
 * History   :
 *  V1.91	  02.02.2022,Schmid		added Reset input
 *
*******************************************************************/

#include <jew_lib1.h>

void FILTER_R(FILTER_R_typ *fd)
{
	if (fd->Filter == 0.0)
		fd->Filter = 1.0;				/* Division durch 0 verhindern */
	
	if (fd->Reset)
		fd->temp_mw = fd->In * fd->Filter;
	else
		fd->temp_mw = fd->temp_mw + fd->In - fd->Out;
	
	fd->Out = fd->temp_mw/fd->Filter;
}
