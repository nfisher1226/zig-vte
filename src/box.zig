const c = @import("cimport.zig");
const Container = @import("container.zig").Container;
const common = @import("common.zig");
const enums = @import("enums.zig");
const Orientation = enums.Orientation;

const Orientable = @import("orientable.zig").Orientable;
const Widget = @import("widget.zig").Widget;

pub const Box = struct {
    ptr: *c.GtkBox,

    pub fn new(orientation: Orientation, spacing: c_int) Box {
        return Box{
            .ptr = @ptrCast(*c.GtkBox, c.gtk_box_new(orientation.parse(), spacing)),
        };
    }

    pub fn pack_start(self: Box, widget: Widget, expand: bool, fill: bool, padding: c_uint) void {
        c.gtk_box_pack_start(self.ptr, widget.ptr, common.bool_to_c_int(expand), common.bool_to_c_int(fill), padding);
    }

    pub fn pack_end(self: Box, widget: Widget, expand: bool, fill: bool, padding: c_uint) void {
        c.gtk_box_pack_end(self.ptr, widget.ptr, common.bool_to_c_int(expand), common.bool_to_c_int(fill), padding);
    }

    pub fn get_homogeneous(self: Box) bool {
        return (c.gtk_box_get_homogeneous(self.ptr) == 1);
    }

    pub fn set_homogeneous(self: Box, hom: bool) void {
        c.gtk_box_set_homogeneous(self.ptr, common.bool_to_c_int(hom));
    }

    pub fn as_orientable(self: Box) Orientable {
        return Orientable{
            .ptr = @ptrCast(*c.GtkOrientable, self.ptr),
        };
    }

    pub fn as_container(self: Box) Container {
        return Container{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Box) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_box_get_type());
    }
};
