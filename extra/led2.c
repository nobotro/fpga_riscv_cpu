#include <stdint.h>

#define LEDS        *((volatile uint32_t *) 32)

void main(){

LEDS=0xff;




while(1)
{
  for(int i=0;i<15;i++){
  LEDS=i;

  //for sleep
  for(int j=0;j<19000000;j++){}
  }
   
}


}
