
# First time trying to use make
# TODO: Check gcc compile options

bin/boot.bin: src/bootloader.nasm
	@nasm src/bootloader.nasm -f bin -o $@

kernel:
	@nasm src/kernel.nasm -f bin -o bin/kernel.bin
	@gcc -ffreestanding -c -o obj/kernel.o src/kernel.c				
	@ld -Ttext 0x8000 --oformat binary -o bin/kernel_c.bin obj/kernel.o

all: bin/boot.bin kernel
	@cat bin/boot.bin bin/kernel.bin bin/kernel_c.bin > bin/os.bin	

run: all
	@qemu-system-x86_64 -drive format=raw,file=bin/os.bin