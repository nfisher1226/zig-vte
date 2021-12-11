const c = @import("cimport.zig");
const Container = @import("container.zig").Container;
const common = @import("common.zig");
const bool_to_c_int = common.bool_to_c_int;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const MenuItem = struct {
    ptr: *c.GtkMenuItem,

    pub fn new() MenuItem {
        return MenuItem{
            .ptr = @ptrCast(*c.GtkMenuItem, c.gtk_menu_tem_new()),
        };
    }

    pub fn new_with_label(text: [:0]const u8) MenuItem {
        return MenuItem{
            .ptr = @ptrCast(*c.GtkMenuItem, c.gtk_menu_item_new_with_label(text)),
        };
    }

    pub fn new_with_mnemonic(text: [:0]const u8) MenuItem {
        return MenuItem{
            .ptr = @ptrCast(*c.GtkMenuItem, c.gtk_menu_item_new_with_mnemonic(text)),
        };
    }

    pub fn get_label(self: MenuItem, allocator: *mem.Allocator) ?[:0]const u8 {
        if (c.gtk_menu_item_get_label(self.ptr)) |v| {
            const len = mem.len(v);
            return fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
        } else return null;
    }

    pub fn set_label(self: MenuItem, text: [:0]const u8) void {
        c.gtk_menu_item_set_label(self.ptr, text);
    }

    pub fn get_use_underline(self: MenuItem) bool {
        return (c.gtk_menu_item_get_use_underline(self.ptr) == 1);
    }

    pub fn set_use_underline(self: MenuItem, use: bool) void {
        c.gtk_menu_item_set_use_underline(self.ptr, bool_to_c_int(use));
    }

    pub fn set_submenu(self: MenuItem, widget: Widget) void {
        c.gtk_menu_item_set_submenu(self.ptr, widget.ptr);
    }

    pub fn get_submenu(self: MenuItem) ?Widget {
        return if (c.gtk_menu_item_get_submenu(self.ptr)) |s| Widget{ .ptr = s } else null;
    }

    pub fn set_accel_path(self: MenuItem, path: ?[:0]const u8) void {
        c.gtk_menu_item_set_accel_path(self.ptr, if (path) |p| p else null);
    }

    pub fn get_accel_path(self: MenuItem, allocator: *mem.Allocator) ?[:0]const u8 {
        if (c.gtk_menu_item_get_accel_path(self.ptr)) |v| {
            const len = mem.len(v);
            return fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
        } else return null;
    }

    pub fn get_reserve_indicator(self: MenuItem) bool {
        return (c.gtk_menu_item_get_reserve_indicator(self.ptr) == 1);
    }

    pub fn connect_activate(self: MenuItem, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("activate", callback, if (data) |d| d else null);
    }

    pub fn as_container(self: MenuItem) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: MenuItem) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_menu_item_get_type());
    }
};
