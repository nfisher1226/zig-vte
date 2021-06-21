const std = @import("std");

const Builder = std.build.Builder;
const Mode = builtin.Mode;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("simple-term", "example/simple-term.zig");
    exe.addPackagePath("zig-vte", "lib.zig");
    exe.setBuildMode(mode);
    exe.setTarget(target);
    exe.linkLibC();
    exe.linkSystemLibrary("gtk+-3.0");
    exe.linkSystemLibrary("vte-2.91");
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
