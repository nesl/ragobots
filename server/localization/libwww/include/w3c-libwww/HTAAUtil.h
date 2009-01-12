/*

  					W3C Sample Code Library libwww Access Authentication


!
  Access Authentication Manager
!
*/

/*
**	(c) COPYRIGHT MIT 1995.
**	Please first read the full copyright statement in the file COPYRIGH.
*/

/*

The Authentication Manager is a registry for Authentication
Schemes that follow the generic syntax defined by the
HTTP WWW-authenticate and
Authorization headers. Currently, the only scheme defined is
Basic Authentication, but Digest Authentication will soon follow.
All Authentication Schemes are registered at run-time in form of an
Authentication Module. An Authentication Module consists of
the following:

  
    scheme
  
    The name which is used to identify the scheme. This is equivalent to the
    <scheme> part of the WWW-authenticate HTTP
    header, for example "basic"
  
    BEFORE Filter
  
    When a new request is issued, the Authentication Manager looks in
    the URL tree to see if we have any access authentication information for
    this particular request. The search is based on the realm (if known) in which
    the request belongs and the URL itself. If a record is found then the
    Authentication Manager calls the Authentication Module in order
    to generate the credentials.
  
    AFTER Filter
  
    After a request has terminated and the result was lack of credentials, the
    request should normally be repeated with a new set of credentials. The AFTER
    filter is responsible for extracting the challenge from the HTTP response
    and store it in the URL tree, so that we next time we request the same URL
    we know that it is protected and we can ask the user for the appropriate
    credentials (user name and password, for example).
  
    garbage collection
  
    The authentication information is stored in a URL
    Tree but as it doesn't know the format of the scheme specific parts,
    you must register a garbage collector (gc). The gc is called when node is
    deleted in the tree.


Note: The Authentication Manager itself consists of
BEFORE and an AFTER filter - just
like the Authentication Modules. This means that any Authentication
Module also can be registered directly as a BEFORE and
AFTER filter by the Net
Manager. The reason for having the two layer model is that the
Authentication Manager maintains a single URL
tree for storing access information for all Authentication Schemes.

An Authentication Module has three resources, it can use when creating
challenges or credentials:
	 
	   o 
	     Handle the credentials which is a part of the
    Request obejct. The credentials are often
    generated by asking the user for a user name ansd a password.
  o 
	     Handle the challenges which is a part of the
    Request object. The MIME
    parser will normally find the credentials as we parse the HTTP response.
  o 
	     Add information to the URL Tree

	 
This module is implemented by HTAAUtil.c, and it
is a part of the  W3C Sample Code
Library.
*/

#ifndef HTAAUTIL_H
#define HTAAUTIL_H
#include "HTReq.h"
#include "HTNet.h"
#include "HTUTree.h"

/*
.
  Authentication Scheme Registration
.

An Authentication Scheme is registered by registering an
Authentication Module to in the Authentication Manager.
(
  Add an Authentication Module
)

You can add an authentication scheme by using the following method. Each
of the callback function must have the type as defined below.
*/

typedef struct _HTAAModule HTAAModule;

extern HTAAModule * HTAA_newModule (const char *		scheme,
				    HTNetBefore *		before,
				    HTNetAfter *		after,
				    HTNetAfter *                update,
				    HTUTree_gc *		gc);

/*
(
  Find an Authentication Module
)
*/
extern HTAAModule * HTAA_findModule (const char * scheme);

/*
(
  Delete an Authentication Module
)
*/
extern BOOL HTAA_deleteModule (const char * scheme);

/*
(
  Delete ALL Authentication modules
)
*/
extern BOOL HTAA_deleteAllModules (void);

/*
.
  Handling the URL Tree
.

The authentication information is stored as URL
Trees. &nbsp;The root of a URL Tree is identified by a hostname
and a port number. Each URL Tree contains a set of templates and realms
which can be used to predict what information to use in a hierarchical tree.

The URL trees are automatically collected after some time so the application
does not have to worry about freeing the trees. When a node in a tree is
freed, the gc registered as part of the Authentication Module is called.

Server applications can have different authentication setups for each hostname
and port number, they control. For example, a server with interfaces
"www.foo.com" and "internal.foo.com" can have different
protection setups for each interface.
(
  Add new or Update a Note in the UTree
)

Add an access authentication information node to the database or update an
existing one. If the entry is already found then it is replaced with the
new one. The template must follow normal URI syntax but can include a wildcard
Return YES if added (or replaced), else NO
*/
extern void * HTAA_updateNode (BOOL proxy,
                               char const * scheme,
			       const char * realm, const char * url,
			       void * context);

/*
(
  Delete a Node from the UTree
)

This is called if an already entered node has to be deleted, for example
if it is not used (the user cancelled entering a username and password),
or for some reason has expired.
*/
extern BOOL HTAA_deleteNode (BOOL proxy_access, char const * scheme,
                             const char * realm, const char * url);

/*
.
  The Authentication Manager Filters
.

As mentioned, the Access Authentication Manager is itself a set of
filters that can be registered by the
Net manager.
(
  Before Filter
)

Make a lookup in the URL tree to find any context for this node, If no context
is found then we assume that we don't know anything about this URL and hence
we don't call any BEFORE filters at all.
*/

HTNetBefore HTAA_beforeFilter;

/*
(
  After Filter
)

Call the AFTER filter that knows how to handle this scheme.
*/

HTNetAfter HTAA_afterFilter;

/*
(
  Update Filter
)

Call the UPDATE filter that knows how to handle this scheme.
*/

HTNetAfter HTAA_updateFilter;

/*
(
  Proxy Authentication Filter
)

Just as for normal authentication we have a filter for proxy authentication.
The proxy authentication uses exactly the same code as normal authentication
but it stores the information in a separate proxy authentication
URL tree. That way, we don't get any clashes between
a server acting as a proxy and a normal server at the same time on the same
port. The difference is that we only have a ingoing filter (a before filter)
as the out going filter is identical to the normal authentication filter.
The filter requires to be called after a proxy filter as we otherwise don't
know whether we are using a proxy or not.
*/

HTNetBefore HTAA_proxyBeforeFilter;

/*
*/

#endif	/* NOT HTAAUTIL_H */

/*

  

  @(#) $Id: HTAAUtil.h,v 1.1 2004/06/16 03:23:11 advait Exp $

*/
