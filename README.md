# x86-microkernel

A minimalist x86 microkernel implementation with basic memory management, interrupt handling, and I/O operations. This educational project demonstrates fundamental concepts of operating system development using assembly language.

## Features

- **Memory Management**: Basic memory segmentation and allocation
- **Interrupt Handling**: Custom interrupt handlers for keyboard input
- **I/O System**: Text-mode display with color support
- **User Interface**: Interactive menu system with:
  - Color switching (Red, Green, Blue)
  - Simple counter operations
  - Clean system shutdown

## Technical Details

### Architecture
- 16-bit Real Mode x86
- Single-stage bootloader
- Basic interrupt handling (IRQ1 for keyboard)
- Memory management starting at 0x7E00
- BIOS interrupt utilization

### Memory Layout
```
0x0000 - 0x7BFF: Reserved for IVT and BIOS
0x7C00 - 0x7DFF: Bootloader
0x7E00 - 0x8FFF: Kernel space
```

## Building

### Prerequisites
- NASM (Netwide Assembler)
- QEMU for emulation testing

### Build Instructions
```bash
# Compile the bootloader
nasm -f bin src/boot.asm -o build/kernel.bin

# Run in QEMU
qemu-system-i386 build/kernel.bin
```

### Project Structure
```
.
├── src/
│   ├── bootloader2.asm       # Main bootloader entry
│   
└── build/             # Build outputs
```

## Usage

The system provides an interactive menu interface:
1. Press 1-3 to change text color (Red/Green/Blue)
2. Press 4 to access the counter menu
3. Press 5 to exit

### Counter Menu
- 1: Increment counter
- 2: Decrement counter
- 3: Return to main menu

## Educational Value

This project serves as a practical introduction to:
- x86 Assembly programming
- Operating system fundamentals
- Memory management concepts
- Interrupt handling
- I/O operations
- Bootloader development

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for improvements and bug fixes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
