// Will this work?

#include <stdint.h>

void main()
{
   
    // The "string" we try to print has been manually defined in our kernel.asm file

    char *msg = (char *) 0x7E82;
    volatile uint16_t * where = (volatile uint16_t *) 0xB8000 + 80;

    while(*msg != 0){
        *where = *msg | (0x0F << 8);
        where++;
        msg++;
    }
        
    repeat:
        goto repeat;
}
     
