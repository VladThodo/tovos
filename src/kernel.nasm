[bits 32]
[org 0x7e00]

VGA_MEM_START equ 0xB8000
C_KERNEL_MAIN equ 0x8000    ; Main entry point for our C kernel

; Yay, we finally got into protected mode and can use 32 bit instructions and more memory

pm_main_init:						; Print something to our screen
	
	mov ax, 0x0010
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

	mov ebp, 0x90000
	mov esp, ebp

    ;call print_msg
    jmp 0x08:C_KERNEL_MAIN                 ; Handle control to C kernel 

print_msg:

.init:
    mov edx, VGA_MEM_START
    mov ebx, message
.loop:
    mov al, [ebx]      ; Letters from our message
    cmp al, 0
    je .end
    mov [edx], al       ; First byte - character
    add edx, 1           
    mov byte [edx], 0x0F    ; Second byte - Color
    add edx, 1
    add ebx, 1    
    jmp .loop
.end:
    ret

message db 'Hi there from protected mode'
db 0x00
message2 db 'Trying to print from C. If you see this, the operation was successful! (69 lmao)'

times 200h - ($ -$$) db 0x00      ; Make this 512 bytes long
