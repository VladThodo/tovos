# TovOS

Simple operating system developed in my YouTube series. The documentation is still being developed.

# The boot process

TovOS only works on legacy systems that support BIOS boot. It could probably be adapted for a UEFI system aswell, although that could be quite a difficult process. More info on how x86 computers start up cand be found in the links provided below.

In short, the system "boots" in three stages:

- BIOS loads the bootloader at physical address `0x7C00`

- Bootloader uses BIOS interrupts to select a video mode and load the rest of the kernel and then switches to protected mode

- The first stage kernel (although a better name for it would be a second stage bootloader) configures the system and the switches to a second stage kernel written in C

- The C kernel handles simple functions susch as print and keyboard input

# The build system

TovOS is built using NASM and GCC (with NASM being used for assembling the assembly code and GCC used for compiling the C code). Make is used in order to simplify the build flow and allow for easier and quicker builds.

The make file assembles and compiles the code, links it and then bundles it in a disk image that is then ran by QEMU. If all the required build and simulation tools are installed, `make run` is the single command needed to build and the run the system.

Required build tools:

- NASM
- GCC
- QEMU (for running the OS)

Availabile make commands:

- `make kernel` only builds the kernel
- `make all` builds the bootloader, kernel and then bundles them in a disk image
- `make run` similar to `make all` but also starts QEMU

Additional make commands will be added as the system is being developed and the builds become more sophysticated.

# TovOS I/O

The system is currently only capable of reading keyboard scan codes from port `0x60`. A better keyboard driver is currently being implemented.

# Useful links

- [OSDev Wiki](https://wiki.osdev.org/Expanded_Main_Page)
- [BIOS Interrupts](https://ostad.nit.ac.ir/payaidea/ospic/file1615.pdf)
- [Boot sector - Wikipedia](https://en.wikipedia.org/wiki/Boot_sector)
