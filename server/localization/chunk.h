#ifndef CHUNK_H
#define CHUNK_H
// Height and width of image in pixels
#define CAMERA_IMAGE_WIDTH 704
#define CAMERA_IMAGE_HEIGHT 480

// Number of pixels per cm
#define CAMERA_X_PIXEL_DENSITY 4.24 //along x axis
#define CAMERA_Y_PIXEL_DENSITY 3.94 //along y axis

int fetchImage(char *url, unsigned char **imageBuf);
void initializeHttpClient();
int destroyHttpClient();
#endif