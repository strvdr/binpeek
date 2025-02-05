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

4. Optional: Move binpeek to `/usr/local/bin` and change config path. From the directory above binpeek:
   ```
    mv /binpeek/zig-out/bin/binpeek /usr/local/bin
    mv /binpeek/.config/binpeek.toml ~/.config/
   ```

## Configuration
**binpeek** has color customizability. Currently, we use ANSI escape codes to add color to the output as it is relatively ubiquitous and works with most terminals and operating systems. However, the potential to add complete themes to **binpeek** remains relatively straightforward if you're up for the task. 

If not, there are a few default colors that **binpeek** works with. Inside binpeek.toml, you can set the following colors:
```
    ASCII Colors 'asciiColors'
    Binary Colors 'binColors'
    Format Colors 'formatColors'
    Escape Colors 'escapeColors'
```
to any of the following options:
```
    red
    green
    blue
    cyan
    yellow
    magenta
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
