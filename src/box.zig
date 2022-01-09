const c = @import("cimport.zig");
const Container = @import("container.zig").Container;
const enums = @import("enums.zig");
const Orientation = enums.Orientation;

const Orientable = @import("orientable.zig").Orientable;
const Widget = @import("widget.zig").Widget;

pub const Box = struct {
    ptr: *c.GtkBox,

    const Self = @This();

    pub fn new(orientation: Orientation, spacing: c_int) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkBox, c.gtk_box_new(orientation.parse(), spacing)),
        };
    }

    pub fn pack_start(self: Self, widget: Widget, expand: bool, fill: bool, padding: c_uint) void {
        c.gtk_box_pack_start(self.ptr, widget.ptr, if (expand) 1 else 0, if (fill) 1 else 0, padding);
    }

    pub fn pack_end(self: Self, widget: Widget, expand: bool, fill: bool, padding: c_uint) void {
        c.gtk_box_pack_end(self.ptr, widget.ptr, if (expand) 1 else 0, if (fill) 1 else 0, padding);
    }

    pub fn get_homogeneous(self: Self) bool {
        return (c.gtk_box_get_homogeneous(self.ptr) == 1);
    }

    pub fn set_homogeneous(self: Self, hom: bool) void {
        c.gtk_box_set_homogeneous(self.ptr, if (hom) 1 else 0);
    }

    pub fn as_orientable(self: Self) Orientable {
        return Orientable{
            .ptr = @ptrCast(*c.GtkOrientable, self.ptr),
        };
    }

    pub fn as_container(self: Self) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_box_get_type());
    }
};
