
# First time trying to use make

bin/boot.bin: src/bootloader.nasm
	@nasm src/bootloader.nasm -f bin -o $@

kernel:
	@nasm src/kernel.nasm -f bin -o bin/kernel.bin

all: bin/boot.bin kernel
	@cat bin/boot.bin bin/kernel.bin > bin/os.bin	

run: all
	@qemu-system-x86_64 -drive format=raw,file=bin/os.bin