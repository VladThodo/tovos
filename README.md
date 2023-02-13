# TovOS

Simple operating system developed in my YouTube series. The documentation is still being developed.

# The boot process

TovOS only works on legacy systems that support BIOS boot. It could probably be adapted for a UEFI system as well, although that could be quite a difficult process. More info on how x86 computers start up cand be found in the links provided below.

In short, the system "boots" in three stages:

- BIOS loads the bootloader at physical address `0x7C00`

- Bootloader uses BIOS interrupts to select a video mode and load the rest of the kernel and then switches to protected mode

- The first stage kernel (although a better name for it would be a second stage bootloader) configures the system and the switches to a second stage kernel written in C

- The C kernel handles simple functions susch as print and keyboard input

# The build system






# Useful links

- [OSDev Wiki](https://wiki.osdev.org/Expanded_Main_Page)
- [BIOS Interrupts](https://ostad.nit.ac.ir/payaidea/ospic/file1615.pdf)
- [Boot sector - Wikipedia](https://en.wikipedia.org/wiki/Boot_sector)
