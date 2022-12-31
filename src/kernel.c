// Will this work?

#include <stdint.h>

#define VGA_MEM_START 0xB8000

void main()
{
   
    // The "string" we try to print has been manually defined in our kernel.asm file

    char message[10] = "Hi there!\0";
    char message2[18]  = "I am new to this!\0";
    
    write_message(&message, 10, 20);
    write_message(&message2, 5, 20);

    draw_rectangle(0x4f, 70, 20, 5, 2);
    disable_cursor();

    while(1)
    {
        wait_key();
    }
}

/* VGA specific functions */

/* Prints a null terminated string located at specified address */
void write_message(char *msg_address, int row, int column) 
{
    volatile uint16_t * location = (volatile uint16_t *) VGA_MEM_START + (80 * row + column);
   
    while(*msg_address)
    {
        *location = *msg_address | (0x0F << 8);
        location++;
        msg_address++;
    }
}

void write_char(char *c, int row, int column)
{
    volatile uint16_t * location = (volatile uint16_t *) VGA_MEM_START + (80 * row + column);
    *location = *c | (0x0F << 8);
}

/* Draws a rectangle in text mode using blank characters */
void draw_rectangle(uint8_t color, int length, int height, int start_x, int start_y)
{
    volatile uint16_t * location = (volatile uint16_t *) VGA_MEM_START + (80 * start_y + start_x);
   
    for(int i = 0; i < height; i++)                 // Treat it as a matrix
    {
        for(int j = 0; j < length; j++)
        {
            if(i == 0 | i == (height - 1) | j == 0 | j == length - 1)
            {
                *(location + j + i * 80) = ' ' | (color << 8);
            }
            else 
            {
                *(location + j + i * 80) = ' ' | (0x4f << 8);
            }
        }
    }
}


/* I/O functions */


/* Reads data from given I/O port - uses inline assembly */
static inline uint8_t inb(uint16_t port)
{
    uint8_t ret;
    asm volatile ("inb %1, %0"
                    :"=a"(ret)
                    :"Nd"(port));
    return ret;
}

static inline void outb(uint16_t port, uint8_t val)
{
    asm volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

void disable_cursor()
{
    outb(0x3D4, 0x0A);
	outb(0x3D5, 0x20);
}

void wait_key()
{
    char k;
    char k_old_state = inb(0x60);
    int x = 7;
    int y = 3;

    char kbd_US [128] =                 // Keyboard map found on https://stackoverflow.com/questions/61124564/convert-scancodes-to-ascii
    {
        0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',   
    '\t', /* <-- Tab */
    'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',     
        0, /* <-- control key */
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`',  0, '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/',   0,
    '*',
        0,  /* Alt */
    ' ',  /* Space bar */
        0,  /* Caps lock */
        0,  /* 59 - F1 key ... > */
        0,   0,   0,   0,   0,   0,   0,   0,
        0,  /* < ... F10 */
        0,  /* 69 - Num lock*/
        0,  /* Scroll Lock */
        0,  /* Home key */
        0,  /* Up Arrow */
        0,  /* Page Up */
    '-',
        0,  /* Left Arrow */
        0,
        0,  /* Right Arrow */
    '+',
        0,  /* 79 - End key*/
        0,  /* Down Arrow */
        0,  /* Page Down */
        0,  /* Insert Key */
        0,  /* Delete Key */
        0,   0,   0,
        0,  /* F11 Key */
        0,  /* F12 Key */
        0,  /* All other keys are undefined */
    };

    while((k = inb(0x60)) < 128)
    {
        if(k != k_old_state)    // Something's changed
        {
            k_old_state = k;
            write_char(&kbd_US[k], y, x);
            x++;
            if(x == 73)
            {
                x = 7;
                y++;
            }
            if(y == 20)
            {
                y = 3;
            }
        }        
    }
}
     
