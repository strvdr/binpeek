const std = @import("std");
const cfg = @import("config.zig");

pub const Color = struct {
    red: []const u8 = "\x1b[31m",
    green: []const u8 = "\x1b[32m",
    yellow: []const u8 = "\x1b[33m",
    blue: []const u8 = "\x1b[34m",
    magenta: []const u8 = "\x1b[35m",
    cyan: []const u8 = "\x1b[36m",
    reset: []const u8 = "\x1b[0m",
    bold: []const u8 = "\x1b[1m",

    asciiColors: []const u8 = "\x1b[32m", // Default to green
    binColors: []const u8 = "\x1b[31m", // Default to red
    escapeColors: []const u8 = "\x1b[33m", // Default to yellow
    formatColors: []const u8 = "\x1b[34m", // Default to blue

    pub fn updateColors(self: *Color, config: cfg.Config) void {
        if (config.asciiColors.len > 0) {
            self.asciiColors = switch (config.asciiColors[0]) {
                'r' => self.red,
                'b' => self.blue,
                'g' => self.green,
                'y' => self.yellow,
                'm' => self.magenta,
                'c' => self.cyan,
                else => self.green, // default to green
            };
        }

        if (config.binColors.len > 0) {
            self.binColors = switch (config.binColors[0]) {
                'r' => self.red,
                'b' => self.blue,
                'g' => self.green,
                'y' => self.yellow,
                'm' => self.magenta,
                'c' => self.cyan,
                else => self.red, // default to red
            };
        }

        if (config.escapeColors.len > 0) {
            self.escapeColors = switch (config.escapeColors[0]) {
                'r' => self.red,
                'b' => self.blue,
                'g' => self.green,
                'y' => self.yellow,
                'm' => self.magenta,
                'c' => self.cyan,
                else => self.yellow, // default to yellow
            };
        }
        if (config.formatColors.len > 0) {
            self.formatColors = switch (config.formatColors[0]) {
                'r' => self.red,
                'b' => self.blue,
                'g' => self.green,
                'y' => self.yellow,
                'm' => self.magenta,
                'c' => self.cyan,
                else => self.blue, // default to blue
            };
        }
    }
};

pub fn main() !void {
    var colors = Color{};

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const deinitStatus = gpa.deinit();
        if (deinitStatus == .leak) std.debug.print("{s}You're leaking{s}😧", .{ colors.red, colors.reset });
    }

    var config = try cfg.Config.loadFromFile(gpa.allocator());
    defer config.deinit();
    colors.updateColors(config);

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    // Read arguments and skip program name (first arg)
    var args = try std.process.argsWithAllocator(gpa.allocator());
    defer args.deinit();
    _ = args.skip();

    const filename = args.next() orelse {
        std.debug.print("Invalid usage. Try: binpeek <filename>", .{});
        return;
    };

    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    var buf: [4096]u8 = undefined;
    var bytesRead: u64 = 0;
    var hexBufIndex: u64 = 0;

    while (true) {
        bytesRead = try file.read(&buf);

        var hexBufLower: u16 = 0;
        var hexBufUpper: u16 = 16;

        while (hexBufUpper <= bytesRead) {
            try stdout.print("{x:0>8}:", .{hexBufIndex});
            hexBufIndex += 16;
            for (buf[hexBufLower..hexBufUpper], 0..) |byte, i| {
                if (i % 2 == 0) {
                    if (byte == 0) {
                        try stdout.print(" {s}{x:0>2}{s}", .{ colors.bold, byte, colors.reset });
                    } else if (byte >= 36 and byte <= 126) {
                        try stdout.print(" {s}{s}{x:0>2}{s}", .{ colors.bold, colors.asciiColors, byte, colors.reset });
                    } else if (byte == 10 or byte == 9 or byte == 26 or byte == 13) {
                        try stdout.print(" {s}{s}{x:0>2}{s}", .{ colors.bold, colors.escapeColors, byte, colors.reset });
                    } else if (byte == 255 or byte == 127 or byte == 32) {
                        try stdout.print(" {s}{s}{x:0>2}{s}", .{ colors.bold, colors.formatColors, byte, colors.reset });
                    } else {
                        try stdout.print(" {s}{s}{x:0>2}{s}", .{ colors.bold, colors.binColors, byte, colors.reset });
                    }
                } else {
                    if (byte == 0) {
                        try stdout.print("{s}{x:0>2}{s}", .{ colors.bold, byte, colors.reset });
                    } else if (byte >= 36 and byte <= 126) {
                        try stdout.print("{s}{s}{x:0>2}{s}", .{ colors.bold, colors.asciiColors, byte, colors.reset });
                    } else if (byte == 10 or byte == 9 or byte == 26 or byte == 13) {
                        try stdout.print("{s}{s}{x:0>2}{s}", .{ colors.bold, colors.escapeColors, byte, colors.reset });
                    } else if (byte == 255 or byte == 127 or byte == 32) {
                        try stdout.print("{s}{s}{x:0>2}{s}", .{ colors.bold, colors.formatColors, byte, colors.reset });
                    } else {
                        try stdout.print("{s}{s}{x:0>2}{s}", .{ colors.bold, colors.binColors, byte, colors.reset });
                    }
                }
            }

            try stdout.print("  ", .{});

            for (buf[hexBufLower..hexBufUpper]) |byte| {
                if (byte == 0) {
                    try stdout.print("{s}.{s}", .{ colors.bold, colors.reset });
                } else if (byte >= 36 and byte <= 126) {
                    try stdout.print("{s}{s}{c}{s}", .{ colors.bold, colors.asciiColors, byte, colors.reset });
                } else if (byte == 10 or byte == 9 or byte == 26 or byte == 13) {
                    try stdout.print("{s}{s}.{s}", .{ colors.bold, colors.escapeColors, colors.reset });
                } else if (byte == 255 or byte == 127 or byte == 32) {
                    try stdout.print("{s}{s}.{s}", .{ colors.bold, colors.formatColors, colors.reset });
                } else {
                    try stdout.print("{s}{s}.{s}", .{ colors.bold, colors.binColors, colors.reset });
                }
            }

            try stdout.print("\n", .{});
            hexBufLower += 16;
            hexBufUpper += 16;
        }

        if (bytesRead == 0) break;
    }

    try bw.flush(); // Don't forget to flush!
}
