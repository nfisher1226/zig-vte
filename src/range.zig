const c = @import("cimport.zig");
const Adjustment = @import("adjustment.zig").Adjustment;
const com = @import("common.zig");
const bool_to_c_int = com.bool_to_c_int;
const enums = @import("enums.zig");
const Orientation = enums.Orientation;
const PositionType = enums.PositionType;
const SpinType = enums.SpinType;
const SpinButtonUpdatePolicy = enums.SpinButtonUpdatePolicy;
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
        return (c.gtk_scale_get_draw_value(self.ptr) == 1);
    }

    pub fn set_draw_value(self: Scale, draw: bool) void {
        c.gtk_scale_set_draw_value(self.ptr, bool_to_c_int(draw));
    }

    pub fn get_has_origin(self: Scale) bool {
        return (c.gtk_scale_get_has_origin(self.ptr) == 1);
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

    const Self = @This();

    pub const Increments = struct {
        step: f64,
        page: f64,
    };

    pub const Bounds = struct {
        min: f64,
        max: f64,
    };

    pub fn configure(self: Self, adjustment: Adjustment, climb_rate: f64, digits: c_uint) void {
        c.gtk_spin_button_configure(self.ptr, adjustment.ptr, climb_rate, digits);
    }

    pub fn new(adjustment: Adjustment, climb_rate: f64, digits: c_uint) Self {
        return Self{
            .ptr = @ptrCast(*c.GtkSpinButton, c.gtk_spin_button_new(adjustment.ptr, climb_rate, digits)),
        };
    }

    pub fn new_with_range(min: f64, max: f64, step: f64) Self {
        return Self{
            .ptr = c.gtk_spin_button_new_with_range(min, max, step),
        };
    }

    pub fn set_adjustment(self: Self, adjustment: Adjustment) void {
        c.gtk_spin_button_set_adjustment(self.ptr, adjustment.ptr);
    }

    pub fn get_adjustment(self: Self) Adjustment {
        return Adjustment{
            .ptr = c.gtk_spin_button_get_adjustment(self.ptr),
        };
    }

    pub fn set_digits(self: Self, digits: c_uint) void {
        c.gtk_spin_button_set_digits(self.ptr, digits);
    }

    pub fn set_increments(self: Self, step: f64, page: f64) void {
        c.gtk_spin_button_set_increments(self.ptr, step, page);
    }

    pub fn set_range(self: Self, min: f64, max: f64) void {
        c.gtk_spin_button_set_range(self.ptr, min, max);
    }

    pub fn get_value_as_int(self: Self) c_int {
        return c.gtk_spin_button_get_value_as_int(self.ptr);
    }

    pub fn set_value(self: Self, value: f64) void {
        c.gtk_spin_button_set_value(self.ptr, value);
    }

    pub fn set_update_policy(self: Self, policy: SpinButtonUpdatePolicy) void {
        c.gtk_spin_button_set_update_policy(self.ptr, policy.parse());
    }

    pub fn set_numeric(self: Self, numeric: bool) void {
        c.gtk_spin_button_set_numeric(self.ptr, bool_to_c_int(numeric));
    }

    pub fn spin(self: Self, direction: SpinType, increment: f64) void {
        c.gtk_spin_button_spin(self.ptr, direction.parse(), increment);
    }

    pub fn set_wrap(self: Self, wrap: bool) void {
        c.gtk_spin_button_set_wrap(self.ptr, bool_to_c_int(wrap));
    }

    pub fn set_snap_to_ticks(self: Self, snap: bool) void {
        c.gtk_spin_button_set_snap_to_ticks(self.ptr, bool_to_c_int(snap));
    }

    pub fn update(self: Self) void {
        c.gtk_spin_button_update(self.ptr);
    }

    pub fn get_digits(self: Self) c_uint {
        return c.gtk_spin_button_get_digits(self.ptr);
    }

    pub fn get_increments(self: Self) Increments {
        var step: f64 = 0;
        var page: f64 = 0;
        c.gtk_spin_button_get_increments(self.ptr, step, page);
        return Increments{ .step = step, .page = page };
    }

    pub fn get_numeric(self: Self) bool {
        return (c.gtk_spin_button_get_numeric(self.ptr) == 1);
    }

    pub fn get_range(self: Self) Bounds {
        var min: f64 = 0;
        var max: f64 = 0;
        c.gtk_spin_button_get_range(self.ptr, min, max);
        return Bounds{ .min = min, .max = max };
    }

    pub fn get_snap_to_ticks(self: Self) bool {
        return (c.gtk_spin_button_get_snap_to_ticks(self.ptr) == 1);
    }

    pub fn get_update_policy(self: Self) SpinButtonUpdatePolicy {
        return switch (c.gtk_spin_button_get_update_policy(self.ptr)) {
            c.GTK_UPDATE_ALWAYS => .always,
            c.GTK_UPDATE_IF_VALID => .if_valid,
            else => unreachable,
        };
    }

    pub fn get_value(self: Self) f64 {
        return c.gtk_spin_button_get_value(self.ptr);
    }

    pub fn get_wrap(self: Self) bool {
        return (c.gtk_spin_button_get_wrap(self.ptr) == 1);
    }

    pub fn connect_value_changed(self: Self, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("value_changed", callback, if (data) |d| d else null);
    }

    pub fn as_range(self: Self) Range {
        return Range{
            .ptr = @ptrCast(*c.GtkRange, self.ptr),
        };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_spin_button_get_type());
    }
};
