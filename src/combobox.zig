const c = @import("cimport.zig");
const common = @import("common.zig");
const enums = @import("enums.zig");
const Widget = @import("widget.zig").Widget;

const std = @cImport("std");
const fmt = std.fmt;
const mem = std.mem;

pub const ComboBox = struct {
    ptr: *c.GtkComboBox,

    pub fn new() ComboBox {
        return ComboBox{
            .ptr = @ptrCast(*c.GtkComboBox, c.gtk_combo_box_new()),
        };
    }

    pub fn new_with_entry() ComboBox {
        return ComboBox{
            .ptr = @ptrCast(*c.GtkComboBox, c.gtk_combo_box_new_with_entry()),
        };
    }

    pub fn get_active(self: ComboBox) ?c_int {
        const res = c.gtk_combo_box_get_active(self.ptr);
        return switch (res) {
            -1 => null,
            else => res,
        };
    }

    pub fn set_active(self: ComboBox, item: ?c_int) void {
        c.gtk_commbo_box_set_active(self.ptr, if (item) |i| i else -1);
    }

    pub fn get_active_id(self: ComboBox, allocator: *mem.Allocator) ?[:0]const u8 {
        if (c.gtk_combo_box_get_active_id(self.ptr)) |val| {
            const len = mem.len(val);
            return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
        } else return null;
    }

    pub fn set_active_id(self: ComboBox, id: ?[:0]const u8) void {
        c.gtk_combo_box_set_active_id(self.ptr, if (id) |i| i else null);
    }

    pub fn as_widget(self: ComboBox) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_combo_box_get_type());
    }
};
