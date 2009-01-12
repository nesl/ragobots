/*

					W3C Sample Code Library libwww MIME multipart parser stream





!MIME Multipart Parser Stream!

*/

/*
**	(c) COPYRIGHT MIT 1995.
**	Please first read the full copyright statement in the file COPYRIGH.
*/

/*

This stream parses a MIME multipart stream and builds a set of new
streams via the stream stack each time we encounter a boundary start.
We get the boundary from the normal MIME parser via the Request
object. As we keep a local copy this also work for nested
multiparts.

This module is implemented by HTBound.c, and it is
a part of the W3C
Sample Code Library.

*/

#ifndef HTBOUND_H
#define HTBOUND_H
#include "HTFormat.h"

extern HTConverter HTBoundary;

#endif

/*



@(#) $Id: HTBound.h,v 1.1 2004/06/16 03:23:11 advait Exp $


*/
