const c = @import("cimport.zig");
const common = @import("common.zig");
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Label = struct {
    ptr: *c.GtkLabel,

    pub fn new(text: ?[:0]const u8) Label {
        return Label {
            .ptr = if (text) |t| @ptrCast(*c.GtkLabel, c.gtk_label_new(t)) else @ptrCast(*c.GtkLabel, c.gtk_label_new(null)),
        };
    }

    pub fn get_text(self: Label, allocator: *mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_label_get_text(self.ptr);
        if (val) |v| {
            const len = mem.len(v);
            const text = fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    pub fn set_text(self: Label, text: [:0]const u8) void {
        c.gtk_label_set_text(self.ptr, text);
    }

    pub fn set_markup(self: Label, text: [:0]const u8) void {
        c.gtk_label_set_markup(self.ptr, text);
    }

    pub fn set_line_wrap(self: Label, wrap: bool) void {
        c.gtk_label_set_line_wrap(self.ptr, common.bool_to_c_int(wrap));
    }

    pub fn as_widget(self: Label) Widget {
        return Widget {
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_label_get_type());
    }
};

