const c = @import("cimport.zig");
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = mem.fmt;
const mem = std.mem;

pub const Container = struct {
    ptr: *c.GtkContainer,

    const Self = @This();

    pub fn add(self: Self, widget: Widget) void {
        c.gtk_container_add(self.ptr, widget.ptr);
    }

    pub fn remove(self: Self, widget: Widget) void {
        c.gtk_container_remove(self.ptr, widget.ptr);
    }

    pub fn get_focus_child(self: Self) Widget {
        return Widget{ .ptr = c.gtk_container_get_focus_child(self.ptr) };
    }

    pub fn set_focus_child(self: Self, child: Widget) void {
        c.gtk_widget_set_focus_child(self.ptr, child.ptr);
    }

    pub fn get_border_width(self: Self) c_uint {
        c.gtk_container_get_border_width(self.ptr);
    }

    pub fn set_border_width(self: Self, border: c_uint) void {
        c.gtk_container_set_border_width(self.ptr, border);
    }

    pub fn get_children(self: Self, allocator: mem.Allocator) ?std.ArrayList(Widget) {
        var kids = c.gtk_container_get_children(self.ptr);
        defer c.g_list_free(kids);
        var list = std.ArrayList(Widget).init(allocator);
        while (kids) |ptr| {
            list.append(Widget{ .ptr = @ptrCast(*c.GtkWidget, @alignCast(8, ptr.*.data)) }) catch {
                list.deinit();
                return null;
            };
            kids = ptr.*.next;
        }
        return list;
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_container_get_type()
        or Box.is_instance(gtype)
        or Grid.is_instance(gtype)
        or Notebook.is_instance(gtype)
        or Stack.is_instance(gtype));
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }
};
