const std = @import("std");

const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();
    const examples = .{"simple", "glade", "callbacks", "range", "simple-term"};

    const lib = b.addStaticLibrary("zig-vte", "lib.zig");
    lib.setBuildMode(mode);
    lib.install();

    const example_step = b.step("examples", "Build examples");
    inline for (examples) |name| {
        const example = b.addExecutable(name, "examples/" ++ name ++ ".zig");
        example.addPackagePath("gtk", "lib.zig");
        example.setBuildMode(mode);
        example.setTarget(target);
        example.linkLibC();
        example.linkSystemLibrary("gtk+-3.0");
        example.linkSystemLibrary("vte-2.91");
        example.install();
        example_step.dependOn(&example.step);
    }

    const all_step = b.step("all", "Build everything");
    all_step.dependOn(example_step);
    b.default_step.dependOn(all_step);
}
