
bin/boot.bin: src/bootloader.asm
	@nasm src/bootloader.asm -f bin -o $@

run:
	@qemu-system-x86_64 -drive format=raw,file=bin/boot.bin