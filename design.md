# paladin design documentation

Paladin is an 8-bit system emulator. The paladin system includes CPU, memory, hard disk, extension cards, and more.
Design is inspired from many sources, including the Commodore 64 and Commodore 128.

## Main System

### CPU
The CPU is an 8-bit architecture, with 8 registers. Instructions for the CPU are in the form of opcodes. This lightweight assembly language is inspired from classic assembly languages like Intel's 80x86.

### Memory

## Extensions
Extensions include expansion cards, and some other input and output devices.

### Display
Paladin features a simple expansion slot for display cards and displays. By default, the display is accessed by sending commands to the graphics card and modifying raw pixel values. More design will be needed.