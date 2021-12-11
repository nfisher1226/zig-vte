const c = @import("cimport.zig");
const Adjustment = @import("adjustment.zig").Adjustment;
const common = @import("common.zig");
const bool_to_c_int = common.bool_to_c_int;
const enums = @import("enums.zig");
const Orientation = enums.Orientation;
const PositionType = enums.PositionType;
const Orientable = @import("orientable.zig").Orientable;
const Widget = @import("widget.zig").Widget;

pub const Range = struct {
    ptr: *c.GtkRange,

    pub fn get_value(self: Range) f64 {
        return c.gtk_range_get_value(self.ptr);
    }

    pub fn set_value(self: Range, val: f64) void {
        c.gtk_range_set_value(self.ptr, val);
    }

    pub fn as_widget(self: Range) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_range_get_type() or Scale.is_instance(gtype) or SpinButton.is_instance(gtype));
    }
};

pub const Scale = struct {
    ptr: *c.GtkScale,

    pub fn new(orientation: Orientation, adjustment: Adjustment) Scale {
        return Scale{
            .ptr = @ptrCast(*c.GtkScale, c.gtk_scale_new(orientation.parse(), adjustment.ptr)),
        };
    }

    pub fn new_with_range(orientation: Orientation, min: f64, max: f64, step: f64) Scale {
        return Scale{
            .ptr = @ptrCast(*c.GtkScale, c.gtk_scale_new_with_range(orientation.parse(), min, max, step)),
        };
    }

    pub fn get_digits(self: Scale) c_int {
        return c.gtk_scale_get_digits(self.ptr);
    }

    pub fn set_digits(self: Scale, digits: c_int) void {
        c.gtk_scale_set_digits(self.ptr, digits);
    }

    pub fn get_draw_value(self: Scale) bool {
        return if (c.gtk_scale_get_draw_value(self.ptr) == 1) true else false;
    }

    pub fn set_draw_value(self: Scale, draw: bool) void {
        c.gtk_scale_set_draw_value(self.ptr, bool_to_c_int(draw));
    }

    pub fn get_has_origin(self: Scale) bool {
        return if (c.gtk_scale_get_has_origin(self.ptr) == 1) true else false;
    }

    pub fn set_has_origin(self: Scale, origin: bool) void {
        c.gtk_scale_set_has_origin(self.ptr, bool_to_c_int(origin));
    }

    pub fn get_value_pos(self: Scale) PositionType {
        const val = c.gtk_scale_get_value_pos(self.scale);
        switch (val) {
            c.GTK_POS_LEFT => return .left,
            c.GTK_POS_RIGHT => return .right,
            c.GTK_POS_TOP => return .top,
            c.GTK_POS_BOTTOM => return .bottom,
            else => unreachable,
        }
    }

    pub fn set_value_pos(self: Scale, pos: PositionType) void {
        c.gtk_scale_set_value_pos(self.ptr, pos.parse());
    }

    pub fn add_mark(self: Scale, value: f64, pos: PositionType, markup: ?[:0]const u8) void {
        c.gtk_scale_add_mark(self.ptr, value, pos.parse(), if (markup) |t| t else null);
    }

    pub fn clear_marks(self: Scale) void {
        c.gtk_scale_clear_marks(self.ptr);
    }

    pub fn as_orientable(self: Scale) Orientable {
        return Orientable{
            .ptr = @ptrCast(*c.GtkOrientable, self.ptr),
        };
    }

    pub fn as_range(self: Scale) Range {
        return Range{
            .ptr = @ptrCast(*c.GtkRange, self.ptr),
        };
    }

    pub fn as_widget(self: Scale) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_scale_get_type());
    }
};

pub const SpinButton = struct {
    ptr: *c.GtkSpinButton,

    pub fn new(adjustment: Adjustment, climb_rate: f64, digits: c_uint) SpinButton {
        return SpinButton{
            .ptr = @ptrCast(*c.GtkSpinButton, c.gtk_spin_button_new(adjustment.ptr, climb_rate, digits)),
        };
    }

    pub fn as_range(self: SpinButton) Range {
        return Range{
            .ptr = @ptrCast(*c.GtkRange, self.ptr),
        };
    }

    pub fn as_widget(self: SpinButton) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_spin_button_get_type());
    }
};
