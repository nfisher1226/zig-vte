const c = @import("cimport.zig");
const common = @import("common.zig");
const Container = @import("container.zig").Container;
const Widget = @import("widget.zig").Widget;
const Window = @import("window.zig").Window;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Dialog = struct {
    ptr: *c.GtkDialog,

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_dialog_get_type());
    }
};

pub const AboutDialog = struct {
    ptr: *c.GtkAboutDialog,

    pub fn new() AboutDialog {
        return AboutDialog{
            .ptr = c.gtk_about_dialog_new(),
        };
    }

    pub fn get_program_name(self: AboutDialog, allocator: mem.Allocator) ?[]const u8 {
        const val = c.gtk_about_dialog_get_program_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_program_name(self: AboutDialog, name: []const u8) void {
        c.gtk_about_dialog_set_program_name(self.ptr, name);
    }

    pub fn get_version(self: AboutDialog, allocator: mem.Allocator) ?[]const u8 {
        const val = c.gtk_about_dialog_get_version(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_version(self: AboutDialog, version: []const u8) void {
        c.gtk_about_dialog_set_version(self.ptr, version);
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_about_dialog_get_type());
    }
};
