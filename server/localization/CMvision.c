#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "processFrame.h"
#include "CMVision.h"

#define WIDTH  CMV_DEFAULT_WIDTH
#define HEIGHT CMV_DEFAULT_HEIGHT
#define CMV_MAX_BUF 256

#define CMV_STATE_SCAN   0
#define CMV_STATE_COLORS 1
#define CMV_STATE_THRESH 2
#define CMV_MAX_BUF 256


void set_bits(int *arr,int len,int l,int r,int k)
{
  int i;

  l = max(l,0);
  r = min(r+1,len);

  for(i=l; i<r; i++) arr[i] |= k;
}

void clear_bits(int *arr,int len,int l,int r,int k)
{
  int i;

  l = max(l,0);
  r = min(r+1,len);

  k = ~k;
  for(i=l; i<r; i++) arr[i] &= k;
}

int initialize(int nwidth,int nheight)
// Initializes library to work with images of specified size
{
  width = nwidth;
  height = nheight;

  if(map) free ((void*)map);

  map = malloc(sizeof(unsigned) *(width * height + 1));
  // Need 1 extra element to store terminator value in encodeRuns()

  options = CMV_THRESHOLD | CMV_COLOR_AVERAGES;

  return(map != NULL);
}


int loadOptions(char *filename)
// Loads in options file specifying color names and representative
// rgb triplets.  Also loads in color class threshold values.
{
  char buf[CMV_MAX_BUF],str[CMV_MAX_BUF];
  FILE *in;
  int state,i,n;

  int r,g,b;
  int exp_num=0;
  double merge;
  color_info *c;

  int y1,y2,u1,u2,v1,v2;
  unsigned k;

  // Open options file
  in = fopen(filename,"rt");
  if(!in) return(-1);

  // Clear out previously set options
  for(i=0; i<CMV_COLOR_LEVELS; i++){
    y_class[i] = u_class[i] = v_class[i] = 0;
  }
  for(i=0; i<CMV_MAX_COLORS; i++){
    if(colors[i].name){
      free(colors[i].name);
      colors[i].name = NULL;
    }
  }

  // Loop ever lines, processing via a simple parser
  state = 0;
  while(fgets(buf,CMV_MAX_BUF,in)){
    switch(state){
      case CMV_STATE_SCAN:
        n = sscanf(buf,"[%s",str);
        if(n == 1){
          if(!strncmp(str,"Colors]",CMV_MAX_BUF)){
            state = CMV_STATE_COLORS;
            i = 0;
	  //}else if(!strncmp(str,"thresholds]",CMV_MAX_BUF)){
	  }else if(!strncmp(str,"Thresholds]",CMV_MAX_BUF)){
	    state = CMV_STATE_THRESH;
            i = 0;
	  }else{
            printf("CMVision: Ignoring unknown option header '%s'.\n",str);
          }
	}
        break;
      case CMV_STATE_COLORS:
        //n = sscanf(buf,"(%d,%d,%d) %lf %s",&r,&g,&b,&merge,str);
        n = sscanf(buf,"(%d,%d,%d) %lf %d %s",&r,&g,&b,&merge,&exp_num,str);
        if(n == 6){
       //    printf("(%d,%d,%d) %lf %d '%s'\n",
	     //     r,g,b,merge,exp_num,str); fflush(stdout);
          if(i < CMV_MAX_COLORS){
            c = &colors[i];
            c->color.red   = r;
            c->color.green = g;
            c->color.blue  = b;
            c->name  = strdup(str);
            c->merge = merge;
	    c->expected_num = exp_num;
            i++;
	  }else{
	    printf("CMVision: Too many colors, ignoring '%s'.\n",str);
	  }
	}else if(n == 0){
          state = CMV_STATE_SCAN;
        }
        break;
      case CMV_STATE_THRESH:
        n = sscanf(buf,"(%d:%d,%d:%d,%d:%d)",&y1,&y2,&u1,&u2,&v1,&v2);
        if(n == 6){
          // printf("(%d:%d,%d:%d,%d:%d)\n",y1,y2,u1,u2,v1,v2);
          if(i < CMV_MAX_COLORS){
            c = &colors[i];
            c->y_low = y1;  c->y_high = y2;
            c->u_low = u1;  c->u_high = u2;
            c->v_low = v1;  c->v_high = v2;

            k = (1 << i);
            set_bits(y_class,CMV_COLOR_LEVELS,y1,y2,k);
            set_bits(u_class,CMV_COLOR_LEVELS,u1,u2,k);
            set_bits(v_class,CMV_COLOR_LEVELS,v1,v2,k);
            i++;
	  }else{
	    printf("CMVision: Too many thresholds.\n");
	  }
	}else if(n == 0){
          state = CMV_STATE_SCAN;
        }
        break;
    }
  }

  
/*  for(i=0; i<CMV_COLOR_LEVELS; i++){
    printf("%02X %02X %02X\n",y_class[i],u_class[i],v_class[i]);
  }*/
  {
	 // char ch = getchar();
  }

  fclose(in);

  return(1);
}

int enable(unsigned opt)
{
  int valid;

  valid = opt & CMV_VALID_OPTIONS;
  options |= valid;

  return 1;
}
