// Will this work?

#include <stdint.h>

void main()
{
    
    volatile uint16_t * location;
    location = (volatile uint16_t *) 0xB8000;
    
    *location = 'A' | (0x0F << 8);

    repeat:
        goto repeat;
}