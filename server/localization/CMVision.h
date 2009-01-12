#ifndef __CMVISION_H__
#define __CM_VISION_H__

#define CMV_COLOR_LEVELS  256
#define CMV_MAX_COLORS     32

// Options for level of processing
//   use enable()/disable() to change 
#define CMV_THRESHOLD      0x01
#define CMV_COLOR_AVERAGES 0x02
#define CMV_DUAL_THRESHOLD 0x04
#define CMV_DENSITY_MERGE  0x08

#define CMV_VALID_OPTIONS  0x0F

#define CMV_NONE ((unsigned)(-1))

// sets tweaked optimal values for image size
#define CMV_DEFAULT_WIDTH  320
#define CMV_DEFAULT_HEIGHT 240

// values may need tweaked, although these seem to work usually
#define CMV_MAX_RUNS     (CMV_DEFAULT_WIDTH * CMV_DEFAULT_HEIGHT) / 4
#define CMV_MAX_REGIONS  CMV_MAX_RUNS / 4
#define CMV_MIN_AREA     10

#ifndef RGB_STRUCT
#define RGB_STRUCT
typedef struct rgb{
  unsigned char red,green,blue;
}rgb;
#endif


typedef struct yuv{
  unsigned char y,u,v;
}yuv;

typedef struct rle{
    unsigned color;     // which color(s) this run represents
    int length;         // the length of the run (in pixels)
    int parent;         // run's parent in the connected components tree
}rle;

typedef struct region{
    int color;          // id of the color
	char name[32];
    int area;           // occupied area in pixels
    int x1,y1,x2,y2;    // bounding box (x1,y1) - (x2,y2)
    float cen_x,cen_y;  // centroid
    yuv average;        // average color (if CMV_COLOR_AVERAGES enabled)

    int sum_x,sum_y,sum_z; // temporaries for centroid and avg color
    // int area_check; // DEBUG ONLY

    struct region *next;       // next region in list

    // int number; // DEBUG ONLY
}region;

typedef struct color_info{
    rgb color;          // example color (such as used in test output)
    char *name;         // color's meaninful name (e.g. ball, goal)
    double merge;       // merge density threshold
    int expected_num;   // expected number of regions (used for merge)
    int y_low,y_high;   // Y,U,V component thresholds
    int u_low,u_high;
    int v_low,v_high;
  }color_info;


int width,height;
unsigned *map;
unsigned options;
color_info colors[CMV_MAX_COLORS];

unsigned y_class[CMV_COLOR_LEVELS];
unsigned u_class[CMV_COLOR_LEVELS];
unsigned v_class[CMV_COLOR_LEVELS];

rle rmap[CMV_MAX_RUNS];
region region_table[CMV_MAX_REGIONS];
region* region_list[CMV_MAX_COLORS];
int region_count[CMV_MAX_COLORS];

int initialize(int nwidth,int nheight);
int loadOptions(char *filename);
int enable(unsigned opt);

#endif