

/*
MEMORY
   {
     STACK (xrw)       : ORIGIN = 0x0, LENGTH = 300
   }

*/
SECTIONS
 {
   
   
   .text : { *(.text) }
   .data : { *(.data) }
   .bss  : { *(.bss)  }
    .stack : { *(.stack) }

 }
