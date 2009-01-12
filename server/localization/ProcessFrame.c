#include <stdio.h>
#include <string.h>
//#include <malloc.h>

#include "ProcessFrame.h"
#include "CMVision.h"

#define CMV_RBITS 6
#define CMV_RADIX (1 << CMV_RBITS)
#define CMV_RMASK (CMV_RADIX-1)

char *getColorName(int color)
    {return(colors[color].name);}

// returns index of least significant set bit
int log2modp[37] = {
  0, 1, 2,27, 3,24,28, 0, 4,17,25,31,29,12, 0,14, 5, 8,18,
  0,26,23,32,16,30,11,13, 7, 0,22,15,10, 6,21, 9,20,19
};

// returns index of most significant set bit
int top_bit(int n)
{
  int i = 1;
  if(!n) return(0);
  while(n>>i) i++;
  return(i);
}


int bottom_bit(int n)
{
  return(log2modp[(n & -n) % 37]);
}

// sum of integers over range [x,x+w)
int range_sum(int x,int w)
{
  return(w*(2*x + w-1) / 2);
}

// returns maximal value of two parameters
int max(int a,int b)
{
  return((a > b)? a : b);
}

// returns minimal value of two parameters
int min(int a,int b)
{
  return((a < b)? a : b);
}

unsigned * classifyFrame(image_pixel * img,unsigned * map)
{
  int i,m,s;
  int m1,m2;
  image_pixel p;

  unsigned *uclas = u_class; // Ahh, the joys of a compiler that
  unsigned *vclas = v_class; //   has to consider pointer aliasing
  unsigned *yclas = y_class;

  s = width * height;

  if(options & CMV_DUAL_THRESHOLD){
    for(i=0; i<s; i+=2){
      p = img[i/2];
      m = uclas[p.u] & vclas[p.v];
      m1 = m & yclas[p.y1];
      m2 = m & yclas[p.y2];
      map[i + 0] = m1 | (m1 >> 16);
      map[i + 1] = m2 | (m2 >> 16);
    }
  }else{
    for(i=0; i<s; i+=2){
	  int j=0;
      p = img[i/2];
      m = uclas[p.u] & vclas[p.v];
	  //if(m !=0)
		//  printf("not zero\n");
	  j = yclas[p.y1];
      map[i + 0] = (m & j);
      map[i + 1] = m & yclas[p.y2];
    }
  }

  return map;
}

int encodeRuns(rle * out,unsigned * map)
{
  int x,y,j,l;
  unsigned m,save;
  int size;
  unsigned *row;
  rle r;

  size = width * height;

  // initialize terminator restore
  save = map[0];

  j = 0;
  for(y=0; y<height; y++){
    row = &map[y * width];

    // restore previous terminator and store next
    // one in the first pixel on the next row
    row[0] = save;
    save = row[width];
    row[width] = CMV_NONE;

    x = 0;
    while(x < width){
      m = row[x];
      // m = m & (~m + 1); // get last bit
      l = x;
      while(row[x] == m) x++;
      // x += (row[x] == CMV_NONE); //  && (last & m);

      r.color  = m;
	  //if(m !=0)
		//  printf("Again not zero\n");
      r.length = x - l;
      r.parent = j;
      out[j++] = r;
      if(j >= CMV_MAX_RUNS) return(0);
    }
  }

  return(j);
}

void connectComponents (rle * map,int num)
{
  int x1,x2;
  int l1,l2;
  rle r1,r2;
  int i,p,s,n;

  l1 = l2 = 0;
  x1 = x2 = 0;

  // Lower scan begins on second line, so skip over first
  while(x1 < width){
    x1 += map[l1++].length;
  }
  x1 = 0;

  // Do rest in lock step
  r1 = map[l1];
  r2 = map[l2];
  s = l1;
  while(l1 < num){
    if(r1.color==r2.color && r1.color){
      if((x1>=x2 && x1<x2+r2.length) || (x2>=x1 && x2<x1+r1.length)){
        if(s != l1){
          map[l1].parent = r1.parent = r2.parent;
          s = l1;
        }else{
          // find terminal roots of each path
          n = r1.parent;
          while(n != map[n].parent) n = map[n].parent;
          p = r2.parent;
          while(p != map[p].parent) p = map[p].parent;

          // must use smaller of two to preserve DAGness!
          if(n < p){
            map[p].parent = n;
          }else{
            map[n].parent = p;
          }
        }
      }
    }

    // Move to next point where values may change
    if(x1+r1.length < x2+r2.length){
      x1 += r1.length;
      r1 = map[++l1];
    }else{
      x2 += r2.length;
      r2 = map[++l2];
    }
  }

  // Now we need to compress all parent paths
  for(i=0; i<num; i++){
    p = map[i].parent;
    if(p > i){
      while(p != map[p].parent) p = map[p].parent;
      map[i].parent = p;
    }else{
      map[i].parent = map[p].parent;
    }
  }

 
}

int extractRegions(region * reg,rle * rmap,int num)
{
  int x,y,i;
  int b,n,a;
  rle r;
  yuv black = {0,0,0};

  x = y = n = 0;
  for(i=0; i<num; i++){
    r = rmap[i];

    if(r.color){
      if(r.parent == i){
        // Add new region if this run is a root (i.e. self parented)
        rmap[i].parent = b = n;  // renumber to point to region id
        reg[b].color = bottom_bit(r.color) - 1;
        reg[b].area = r.length;
        reg[b].x1 = x;
        reg[b].y1 = y;
        reg[b].x2 = x + r.length;
        reg[b].y2 = y;
        reg[b].sum_x = range_sum(x,r.length);
        reg[b].sum_y = y * r.length;
        reg[b].average = black;
        // reg[b].area_check = 0; // DEBUG ONLY
        n++;
        if(n >= CMV_MAX_REGIONS) return(CMV_MAX_REGIONS);
      }else{
        // Otherwise update region stats incrementally
        b = rmap[r.parent].parent;
        rmap[i].parent = b; // update to point to region id
        reg[b].area += r.length;
        reg[b].x2 = max(x + r.length,reg[b].x2);
        reg[b].x1 = min(x,reg[b].x1);
        reg[b].y2 = y; // last set by lowest run
        reg[b].sum_x += range_sum(x,r.length);
        reg[b].sum_y += y * r.length;
      }
      /* DEBUG
      if(r.color == 1){
        printf("{%d,%d,%d} ",i,rmap[i].parent,b);
      }
      */
    }

    // step to next location
    x = (x + r.length) % width;
    y += (x == 0);
  }

  // printf("\n");

  // calculate centroids from stored temporaries
  for(i=0; i<n; i++){
    a = reg[i].area;
    reg[i].cen_x = (float)reg[i].sum_x / a;
    reg[i].cen_y = (float)reg[i].sum_y / a;
  }

  return(n);

}

void calcAverageColors(region *  reg,int num_reg,
                                 image_pixel *  img,
                                 rle *  rmap,int num_runs)
// calculates the average color for each region.
// num is the number of runs in the rmap array, and the number of
// unique regions in reg[] (< CMV_MAX_REGIONS) is returned.
// Implemented as a single pass over the image, and a second pass over
// the regions.
{
  int i,j,x,l;
  image_pixel p;
  rle r;
  int sum_y,sum_u,sum_v;
  int b,xs;

  yuv avg;
  int area;

  // clear out temporaries
  for(i=0; i<num_reg; i++){
    reg[i].sum_x = 0;
    reg[i].sum_y = 0;
    reg[i].sum_z = 0;
  }

  x = 0;

  // printf("FRAME_START\n");

  // sum up color components for each region, by traversing image and runs
  for(i=0; i<num_runs; i++){
    r = rmap[i];
    l = r.length;

    if(!r.color){
      x += l;
    }else{
      xs = x;
      p = img[x / 2];

      if(x & 1){
        sum_y = p.y2;
        sum_u = p.u;
        sum_v = p.v;
        // area = 1;
        x++;
        l--;
      }else{
        sum_y = sum_u = sum_v = 0;
        area = 0;
      }

      for(j=0; j<l/2; j++){
        p = img[x / 2];
        sum_y += p.y1 + p.y2;
        sum_u += 2 * p.u;
        sum_v += 2 * p.v;
        x+=2;
        // area += 2;
      }

      if(l & 1){
        x++;
        p = img[x / 2];
        sum_y += p.y1;
        sum_u += p.u;
        sum_v += p.v;
        // area++;
      }

      // add sums to region
      b = r.parent;
      reg[b].sum_x += sum_y;
      reg[b].sum_y += sum_u;
      reg[b].sum_z += sum_v;
      // reg[b].area_check += area;

      /*
      if((r.color & (1 << reg[b].color)) != (1 << reg[b].color)){
        printf("(%d,%d)",r.color,reg[b].color);
      }

      if(x != xs + r.length){
	printf("Length mismatch %d:%d\n",x,xs + r.length);
      }
      */

      x = xs + r.length;
    }
  }

  // Divide sums by area to calculate average colors
  for(i=0; i<num_reg; i++){
    area = reg[i].area;
    avg.y = reg[i].sum_x / area;
    avg.u = reg[i].sum_y / area;
    avg.v = reg[i].sum_z / area;

    /*
    if(reg[i].area != reg[i].area_check){
      printf("Area Mismatch: %d %d\n",reg[i].area,reg[i].area_check);
    }

    x = (y_class[avg.y] & u_class[avg.u] & v_class[avg.v]);
    j = reg[i].color;
    l = (1 << j);
    if((x & l) != l){
      printf("Error: c=%d a=%d (%d,%d) (%d,%d,%d)\n",
	     reg[i].color,area,
	     (int)reg[i].cen_x,(int)reg[i].cen_y,
             avg.y,avg.u,avg.v);
    }
    */

    reg[i].average = avg;
	strcpy(reg[i].name,getColorName(reg[i].color));

  }
}

int separateRegions(region * reg,int num)
{
  region *p;
  int i,l;
  int area,max_area;

  // clear out the region table
  for(i=0; i<CMV_MAX_COLORS; i++){
    region_count[i] = 0;
    region_list[i] = NULL;
  }

  // step over the table, adding successive
  // regions to the front of each list
  max_area = 0;
  for(i=0; i<num; i++){
    p = &reg[i];
    area = p->area;
    if(area >= CMV_MIN_AREA){
      if(area > max_area) max_area = area;
      l = p->color;
      region_count[l]++;
      p->next = region_list[l];
      region_list[l] = p;
    }
  }

  return(max_area);

}

region *sortRegionListByArea(region * list,int passes)
// Sorts a list of regions by their area field.
// Uses a linked list based radix sort to process the list.
{
  region *tbl[CMV_RADIX],*p,*pn;
  int slot,shift;
  int i,j;

  // Handle trivial cases
  if(!list || !list->next) return(list);

  // Initialize table
  for(j=0; j<CMV_RADIX; j++) tbl[j] = NULL;

  for(i=0; i<passes; i++){
    // split list into buckets
    shift = CMV_RBITS * i;
    p = list;
    while(p){
      pn = p->next;
      slot = ((p->area) >> shift) & CMV_RMASK;
      p->next = tbl[slot];
      tbl[slot] = p;
      p = pn;
    }

    // integrate back into partially ordered list
    list = NULL;
    for(j=0; j<CMV_RADIX; j++){
      p = tbl[j];
      tbl[j] = NULL;  // clear out table for next pass
      while(p){
        pn = p->next;
        p->next = list;
        list = p;
        p = pn;
      }
    }
  }

  return(list);
}


void sortRegions(int max_area)
// Sorts entire region table by area, using the above
// function to sort each threaded region list.
{
  int i,p;

  // do minimal number of passes sufficient to touch all set bits
  p = top_bit((max_area + CMV_RBITS-1) / CMV_RBITS);

  // sort each list
  for(i=0; i<CMV_MAX_COLORS; i++){
    region_list[i] = sortRegionListByArea(region_list[i],p);
  }
}



int processFrame(image_pixel *image)
{
	int regions;
	int runs;
	int max_area;

	if(!image) return (-1);

    map = (unsigned *)classifyFrame(image,map);
    runs = encodeRuns(rmap,map);
    connectComponents(rmap,runs);

    regions = extractRegions(region_table,rmap,runs);

    if(options & CMV_COLOR_AVERAGES){
      calcAverageColors(region_table,regions,image,rmap,runs);
    }

    max_area = separateRegions(region_table,regions);
    sortRegions(max_area);

	return 1;
}