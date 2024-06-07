const std = @import("std");
const Build = std.Build;

pub fn build(b: *Build) !void {
    _ = b.addModule("xkbcommon", .{
        .root_source_file = b.path("src/xkbcommon.zig"),
    });
}
