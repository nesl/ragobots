#include <stdio.h>
#include <iostream>
#include <stdlib.h>
#include <string.h>
#include <magick/api.h>
#include <math.h>
#include "Main.h"
extern "C"{
  #include "chunk.h"
  #include "ProcessFrame.h"
  #include "CMVision.h"
  #include "MoteCom.h"
}


using namespace std;

double mod(double d) {
  if (d<0)
	return -1 * d;
  else
	return d;
}

int main(int argc,char **argv) {
  image_pixel *img = NULL;
  double theta;
  double hyp;
  size_t size;
  unsigned char *imageBuf;
  FILE *fp;
  Image *image;
  ImageInfo  *imageInfo = NULL;
  ExceptionInfo exception;
  Location location[NUM_TEAMS * NUM_RAGOBOTS_PER_TEAM];
  int i;
  int sock;

  // Initialize ImageMagick install location for Windows
  InitializeMagick(*argv);
  GetExceptionInfo(&exception);

  // CMVision initialization
  initialize(CAMERA_IMAGE_WIDTH, CAMERA_IMAGE_HEIGHT);
  loadOptions("colors.txt");
  enable(CMV_DENSITY_MERGE);

  // Open TCP socket
  sock = openSocket();

  initializeHttpClient();
start:
  while(1) {
    size = (size_t)fetchImage("http://128.97.93.192/jpg/image.jpg", &imageBuf);

	fp = fopen("capture.jpeg","wb");
	fwrite(imageBuf, 1, size, fp);
	fclose(fp);

	imageInfo=CloneImageInfo((ImageInfo *) NULL);
	image = BlobToImage(imageInfo, imageBuf, size, &exception);
	if (exception.severity != UndefinedException)
	  cout<<exception.reason;
  
	free(imageBuf);
	imageBuf = NULL;

	(void) strcpy(image->magick,"UYVY");
	imageBuf = ImageToBlob(imageInfo, image, &size, &exception);
	if (exception.severity != UndefinedException)
	  cout<<exception.reason;

	DestroyImage(image);
	DestroyImageInfo(imageInfo);

//  fp = fopen("capture.uyvy","wb");
//  fwrite(imageBuf, 1, size, fp);
//  fclose(fp);

	processFrame((image_pixel*)imageBuf);

	free(imageBuf);
	imageBuf = NULL;

	for(i=0;i<NUM_TEAMS * NUM_RAGOBOTS_PER_TEAM * 2;++i) {
	  if(region_list[i]!=NULL) {
//		printf("Tag detected.\n");
		region_list[i]->cen_y = CAMERA_IMAGE_HEIGHT - region_list[i]->cen_y;
//		cout<<region_list[i]->cen_x<<" "<<region_list[i]->cen_y<<endl;
	  }
	  else {
		printf("WARNING: Tag %d not detected.\n", i);
		goto start;
	  }
	}

	for(i=0;i<NUM_TEAMS * NUM_RAGOBOTS_PER_TEAM * 2;i+=2) {
	  hyp = sqrt(pow((int)(region_list[i]->cen_x - region_list[i+1]->cen_x),2) +
			     pow((int)(region_list[i]->cen_y - region_list[i+1]->cen_y),2));
	  hyp = mod(hyp);
	  if(mod(region_list[i]->cen_x - region_list[i+1]->cen_x) > mod(region_list[i]->cen_y - region_list[i+1]->cen_y)) {
		theta = asin(((double)(region_list[i]->cen_y - region_list[i+1]->cen_y))/hyp);
		theta = theta * 180.0 / 3.14;
		if(region_list[i]->cen_x < region_list[i+1]->cen_x)
		  theta = 180.0 - theta;
		if(theta < 0)
		  theta = 360.0 + theta;
	  }
	  else {
		theta = acos(((double)(region_list[i]->cen_x - region_list[i+1]->cen_x))/hyp);
		theta = theta * 180.0 / 3.14;
		if(region_list[i]->cen_y < region_list[i+1]->cen_y)
		  theta = 360.0 - theta;
	  }
	  location[0].x_pix = (uint16_t) ((region_list[i]->cen_x + region_list[i+1]->cen_x)/2);
	  location[0].y_pix = (uint16_t) ((region_list[i]->cen_y + region_list[i+1]->cen_y)/2);
	  location[0].orientation_deg = (uint16_t) theta;
	  cout<<location[0].orientation_deg<<" Angle\n";
	  if(theta== 0) {
		  printf("wrong\n");
	  }
	}

	broadcastLocation(sock, location);
  }//end-of-infinite while

  DestroyExceptionInfo(&exception);
  DestroyMagick();

  return 0;
}