[bits 32]
[org 0x7e00]

VGA_MEM_START equ 0xB8000

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

    call screen_clear
    call print_msg

screen_clear:

.init:
	mov edx, VGA_MEM_START
    mov ecx, 2000   
.loop:
	mov byte [edx], ''
	add edx, 1
	mov byte [edx], 0x00
    dec cx
    cmp cx, 0
    je .end
    jmp .loop
.end:
    ret

print_msg:

.init:
    mov edx, VGA_MEM_START
    mov ebx, message
.loop:
    mov [edx], ebx


message db 'Hi there from protected mode'

times 1400h - ($ -$$) db 0x00      ; Make this 512 bytes long
