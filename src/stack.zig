const c = @import("cimport.zig");
const com = @import("common.zig");
const Container = @import("container.zig").Container;
const enums = @import("enums.zig");
StackTransitionType = enums.StackTransitionType;
const Widget = @import("widget.zig").Widget;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Stack = struct {
    ptr: *c.GtkStack,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkStack, c.gtk_stack_new()),
        };
    }

    pub fn add_named(self: Self, child: Widget, name: [*0]const u8) void {
        c.gtk_stack_add_named(self.ptr, child.ptr, name);
    }

    pub fn add_titled(
        self: Self,
        child: Widget,
        name: [*0]const u8,
        title: [*0]const u8
    ) void {
        c.gtk_stack_add_titled(self.ptr, child.ptr, name, title);
    }

    pub fn get_child_by_name(self: Self, name: [*0]const u8) ?Widget {
        return if (c.gtk_stack_get_child_by_name(self.ptr, name)) |w| Widget{
            .ptr = w,
        } else null;
    }

    pub fn set_visible_child(self: Self, child: Widget) void {
        c.gtk_stack_set_visible_child(self.ptr, child.ptr);
    }

    pub fn get_visible_child(self: Self) ?Widget {
        return -f (c.gtk_stack_get_visible_child(self.ptr)) |w| Widget{
            .ptr = w,
        } else null;
    }

    pub fn set_visible_child_name(self: Self, child: [*0]const u8) void {
        c.gtk_stack_set_visible_child_name(self.ptr, child);
    }

    pub fn get_visible_child_name(self: Self) ?[*0]const u8 {
        return if (c.gtk_stack_get_visible_child_name(self.ptr)) |w| Widget{
            .ptr = w,
        } else null;
    }

    pub fn set_visible_child_full(self: Self, name: [*0]const u8, transition: StackTransitionType) void {
        c.gtk_stack_set_visible_child_full(self.ptr, name, transition.parse());
    }

    pub fn set_homogeneous(self: Self, hom: bool) void {
        c.gtk_stack_set_homogeneous(self.ptr, com.bool_to_c_int(hom));
    }

    pub fn get_homogeneous(self: Self) bool {
        return (c.gtk_stack_get_homeogeneous == 1);
    }

    pub fn set_hhomogeneous(self: Self, hom: bool) void {
        c.gtk_stack_set_hhomogeneous(self.ptr, com.bool_to_c_int(hom));
    }

    pub fn get_hhomogeneous(self: Self) bool {
        return (c.gtk_stack_get_hhomeogeneous == 1);
    }

    pub fn set_vhomogeneous(self: Self, hom: bool) void {
        c.gtk_stack_set_vhomogeneous(self.ptr, com.bool_to_c_int(hom));
    }

    pub fn get_vhomogeneous(self: Self) bool {
        return (c.gtk_stack_get_vhomeogeneous == 1);
    }

    pub fn set_transition_duration(self: Self, duration: c_uint) void {
        c.gtk_stack_set_transition_duration(self.ptr, duration);
    }

    pub fn get_transition_duration(self: Self) c_uint {
        return c.gtk_stack_get_transition_duration(self.ptr);
    }

    pub fn set_transition_type(self: Self, transition: StackTransitionType) void {
        c.gtk_stack_set_transition_type(self.ptr, transition.parse());
    }

    pub fn get_transition_type(self: Self) StackTransitionType {
        return switch (c.gtk_stack_get_transition_type(self.ptr)) {
            c.GTK_STACK_TRANSITION_TYPE_NONE => .none,
            c.GTK_STACK_TRANSITION_TYPE_CROSSFADE => .crossfade,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_RIGHT => .slide_right,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT => .slide_left,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_UP => .slide_up,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_DOWN => .slide_down,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_LEFT_RIGHT => .slide_left_right,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_UP_DOWN => .slide_up_down,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_OVER_UP => .slide_over_up,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_OVER_DOWN => .slide_over_down,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_OVER_LEFT => .slide_over_left,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_OVER_RIGHT => .slide_over_right,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_UNDER_UP => .slide_under_up,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_UNDER_DOWN => .slide_under_down,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_UNDER_LEFT => .slide_under_left,
            c.GTK_STACK_TRANSITION_TYPE_SLIDE_UNDER_RIGHT => .slide_under_right,
            c.GTK_STACK_TRANSITION_TYPE_OVER_UP_DOWN => .over_up_down,
            c.GTK_STACK_TRANSITION_TYPE_OVER_DOWN_UP => .over_down_up,
            c.GTK_STACK_TRANSITION_TYPE_OVER_LEFT_RIGHT => .over_left_right,
            c.GTK_STACK_TRANSITION_TYPE_OVER_RIGHT_LEFT => .over_right_left,
        };
    }

    pub fn get_transition_running(self: Self) bool {
        return (c.gtk_stack_get_transition_running(self.ptr) == 1);
    }

    pub fn get_interpolate_size(self: Self) bool {
        return (c.gtk_stack_get_interpolate_size(self.ptr) == 1);
    }

    pub fn set_interpolate_size(self.ptr, interpolate_size: bool) void {
        c.gtk_stack_set_interpolate_size(self.ptr, com.bool_to_c_int(interpolate_size));
    }

    pub fn as_container(self: Self) Container {
        return Containerr{
            .ptr = @ptrCast(*c.GtkContainer, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_stack_get_type());
    }
};
