# binpeek

**binpeek** is a minimalist hexdump utility inspired by `xxd`, rewritten in Zig for performance and simplicity. It displays binary files in hexadecimal and ASCII formats, making it a handy tool for low-level analysis and debugging.

## Features

- Hexadecimal and ASCII side-by-side view.
- Clean, efficient output inspired by traditional hexdumps.
- Written in Zig for memory safety and cross-platform compatibility.
- Lightweight and fast, with no external dependencies.

## Installation

1. Ensure [Zig](https://ziglang.org/) (v0.14.0 or later) is installed.
2. Clone the repository:
   ```bash
   git clone https://github.com/strvdr/binpeek
   ```
3. Build and install:
   ```bash
   cd binpeek
   zig build -Doptimize=ReleaseFast
   ```

## Usage

Run `binpeek` with a filename to view its hexdump:

```bash
binpeek <filename>
```

### Example Output

```
00000000: 7f45 4c46 0201 0100 0000 0000 0000 0000  .ELF............
00000010: 0300 3e00 0100 0000 1010 0000 0000 0000  ..>.............
```

## Contributing

Contributions are welcome! Open an issue or submit a pull request for improvements or bug fixes.

## License

[MIT](LICENSE) © Strydr Silverberg

---

Inspired by `xxd`, built with Zig's simplicity in mind.🧠
