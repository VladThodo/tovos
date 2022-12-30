[bits 16]
[org 0x7C00]

kernel_main equ 0x7E00

	jmp 0x0000:main_init	; Make sure the segment selector is 0x0000

	; TODO: not really sure about this, but some article said it was important

; *******************************************

; Gdt descriptor

gdt:						; Global descriptor table

	.sd_null:				; Null segment descriptor - 8 bytes
		
		times 8 db 0x00
	
	.sd_code:				; Code segment descriptor - 8 bytes
		
		db 0xff, 0xff		; Kind of a copy-pase, need to understand this
		db 0x00, 0x00		; See https://huichen-cs.github.io/course/CISC3320/19FA/lecture/modeswitch.html
		db 0x00

		db 0b10011010
		db 0b11001111
		db 0x00

	.sd_data:				; Data segment descriptor - 8 bytes

		db 0xff, 0xff
		db 0x00, 0x00
		db 0x00

		db 0b10010010
		db 0b11001111
		db 0x00

gdt_end:

gdt_descriptor:
	
	dw gdt - gdt_end - 1
	dd gdt

code_seg equ gdt.sd_code - gdt
data_seg equ gdt.sd_data - gdt

buffer: dw code_seg

; ******************************************************

main_init:					; This is the entry point of our bootloader
	
	mov bp, 7C00h			; Set bp to origin address
	xor ax, ax			; Not sure what this does - need to do some more research
	mov ds, ax
	mov es, ax
	mov ss, ax			; Tf does this do?
	mov sp, 7C00h		; Somehow our stack pointer should now be located at 0x7C00 ???

load_kernel_code:		; No error check here, add one
	mov ah, 2h
	mov al, 10
	mov bx, 7E00h
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, 80h
	;mov es, [buffer]
	int 13h				; Hope this works
	mov es, ax			; Idk if this does anything

switch_protected:
	cli 				; Disable interrupts
	lgdt [gdt_descriptor]			; Load segment descripor table
	mov eax, cr0		; Set protection enable bit in CR0
	or eax, 1
	mov cr0, eax		; Now in protected mode, time to hand control to kernel

times 10 db 0x69

hand_control_to_kernel:
	jmp 0x08:kernel_main		; Far jump to kernel main


times 510 - ($ - $$) db 0x00
db 0x55, 0xAA

; Starting at 0x7E00
; This should be our second sector

; Kernel code to follow


