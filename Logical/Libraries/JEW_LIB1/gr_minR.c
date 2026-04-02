/********************************************************************
 * COPYRIGHT -- INNIO Company
 ********************************************************************
 * Library: JEW_LIB1
 * File: gr_minR.c
 * Author: 320003156
 * Created: August 17, 2011
 *******************************************************************/

#include <jew_lib1.h>

void GR_MINR(GR_MINR_typ *fd)
{
	if (fd->In <= fd->Gw)
		fd->Q = 1;
	else if (fd->In > (fd->Gw + fd->Hy))
		fd->Q = 0;
}
