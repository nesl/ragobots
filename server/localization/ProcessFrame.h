#ifndef __PROCESS_FRAME_H__
#define __PROCESS_FRAME_H__


struct yuv422{
  unsigned char y1,u,y2,v;
};

struct uyvy{
  unsigned char u,y1,v,y2;
};


#ifdef USE_METEOR
  typedef struct uyvy image_pixel;
#else
  typedef struct yuv422 image_pixel;
#endif



//image_pixel* convertToImgPixel(image_pixel *image);
int processFrame(image_pixel *image);


#endif