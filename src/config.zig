const std = @import("std");
const ztoml = @import("ztoml");
const ArenaAllocator = std.heap.ArenaAllocator;

pub const Config = struct {
    asciiColors: []const u8,
    binColors: []const u8,
    formatColors: []const u8,
    escapeColors: []const u8,
    arena: ArenaAllocator,

    pub fn init() Config {
        return .{
            .asciiColors = "blue",
            .binColors = "red",
            .formatColors = "blue",
            .escapeColors = "yellow",
            .arena = undefined,
        };
    }

    pub fn deinit(self: *Config) void {
        self.arena.deinit();
    }

    pub fn loadFromFile(allocator: std.mem.Allocator) !Config {
        // Create an arena and store it in the config
        var arena = ArenaAllocator.init(allocator);

        // Try to read the config file
        const file = std.fs.cwd().openFile("~/.config/binpeek.toml", .{}) catch |err| {
            if (err == error.FileNotFound) {
                //std.debug.print("Error, no config file found. ", .{});
                return Config.init();
            }
            return err;
        };
        defer file.close();

        const fileSize = try file.getEndPos();
        const tomlContent = try arena.allocator().alloc(u8, fileSize);
        _ = try file.readAll(tomlContent);

        var parser = ztoml.Parser.init(&arena, tomlContent);
        const result = try parser.parse();

        // Create config with the arena
        var config = Config{
            .asciiColors = "green",
            .binColors = "red",
            .formatColors = "blue",
            .escapeColors = "yellow",
            .arena = arena,
        };

        if (ztoml.getValue(result, &[_][]const u8{ "Colors", "asciiColors" })) |value| {
            config.asciiColors = value.data.String;
        }
        if (ztoml.getValue(result, &[_][]const u8{ "Colors", "binColors" })) |value| {
            config.binColors = value.data.String;
        }
        if (ztoml.getValue(result, &[_][]const u8{ "Colors", "formatColors" })) |value| {
            config.formatColors = value.data.String;
        }
        if (ztoml.getValue(result, &[_][]const u8{ "Colors", "escapeColors" })) |value| {
            config.escapeColors = value.data.String;
        }

        return config;
    }
};
