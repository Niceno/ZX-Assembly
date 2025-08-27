# ZX-Assembly

Learning Z80 assembly on the ZX Spectrum 48K  
*(with the help of sjasmplus and Fuse emulator)*

---

## About

This repository is my personal playground for exploring **ZX Spectrum assembly language programming**.  

- I’m starting from **baby steps** (printing text, moving characters around the screen, delays).  
- Over time, this may grow into something more useful (a demo, a game, or maybe just a nice archive of experiments).  
- Either way, it’s mainly a **learning project**: a place to write code, make mistakes, and figure out how the Spectrum really works under the hood.

---

## Tools

- **Assembler**: [sjasmplus](https://github.com/z00m128/sjasmplus)  
- **Emulator**: [Fuse](https://fuse-emulator.sourceforge.net/)  
- **Platform**: tested on Pop!\_OS (Linux), but should work anywhere sjasmplus + Fuse are available.

---

## Running the code

Each subdirectory contains one or more `.asm` files.  

To assemble and run:

```bash
sjasmplus hello.asm
fuse --machine 48 --snapshot hello.sna
