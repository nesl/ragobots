#include <stdio.h>

#include "WWWLib.h"
#include "WWWHTTP.h"
#include "WWWInit.h"
#include "chunk.h"

PRIVATE int terminate_handler (HTRequest * request, HTResponse * response,
			       void * param, int status) 
{
    /* Check for status */
    HTPrint("Load resulted in status %d\n", status);
	
	/* we're not handling other requests */
	HTEventList_stopLoop ();
 
	/* stop here */
    return HT_ERROR;
}

void initializeHttpClient(){
    /* Initialize libwww core */
    HTProfile_newPreemptiveClient("TestApp", "1.0");

}
int fetchImage (char *url, unsigned char **imageBuffer)
{
    HTRequest * request = HTRequest_new();
    HTChunk * chunk = NULL;
	

    /* We want raw output including headers */
    HTRequest_setOutputFormat(request, WWW_SOURCE);

    /* Close connection immediately */
    HTRequest_addConnection(request, "close", "");

    /* Add our own filter to handle termination */
    HTNet_addAfter(terminate_handler, NULL, NULL, HT_ALL, HT_FILTER_LAST);

    if (url) {
	char * cwd = HTGetCurrentDirectoryURL();
	char * absolute_url = HTParse(url, cwd, PARSE_ALL);
	chunk = HTLoadToChunk(absolute_url, request);
	HT_FREE(absolute_url);
	HT_FREE(cwd);

	/* If chunk != NULL then we have the data */
	if (chunk) {
	    HTEventList_loop(request);
	}
    } else {
		HTPrint("Type the URL you want to accces on the command line\n");
		return 0;
    }
	
    /* Clean up the request */
    HTRequest_delete(request);

    /* Terminate the Library */
	*imageBuffer = (unsigned char*)HTChunk_data(chunk);
    return HTChunk_size(chunk);
}
