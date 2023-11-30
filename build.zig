const std = @import("std");
const os = @import("builtin").os.tag;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    if (os != .linux) {
        @compileError("Unsupported platform - " ++ @tagName(os));
    }

    const zig_kdb = b.addModule("zig-kdb", .{
        .source_file = .{ .path = b.pathFromRoot("src/k.zig") },
    });

    const kdb = b.dependency("kdb", .{});
    b.installArtifact(kdb.artifact("c.o"));
    b.installArtifact(kdb.artifact("e.o"));

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    unit_tests.addModule("kdb", zig_kdb);
    unit_tests.linkLibrary(kdb.artifact("c.o"));

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
