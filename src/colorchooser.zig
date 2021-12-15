const c = @import("cimport.zig");
const Button = @import("button.zig").Button;
const common = @import("common.zig");
const bool_to_c_int = common.bool_to_c_int;
const enums = @import("enums.zig");
const Widget = @import("widget.zig").Widget;

const std = @import("std");

pub const ColorChooser = struct {
    ptr: *c.GtkColorChooser,

    pub fn get_rgba(self: ColorChooser) c.GdkRGBA {
        var rgba: c.GdkRGBA = undefined;
        _ = c.gtk_color_chooser_get_rgba(self.ptr, &rgba);
        return rgba;
    }

    pub fn set_rgba(self: ColorChooser, rgba: c.GdkRGBA) void {
        c.gtk_color_chooser_set_rgba(self.ptr, &rgba);
    }

    pub fn get_use_alpha(self: ColorChooser) bool {
        return (c.gtk_color_chooser_get_use_alpha(self.ptr) == 1);
    }

    pub fn set_use_alpha(self: ColorChooser, use: bool) void {
        c.gtk_color_chooser_set_use_alpha(self.ptr, bool_to_c_int(use));
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_color_chooser_get_type() or ColorButton.is_instance(gtype) or ColorChooserWidget.is_instance(gtype) or ColorChooserDialog.is_instance(gtype));
    }

    pub fn to_color_button(self: ColorChooser) ?ColorButton {
        if (self.as_widget().isa(ColorButton)) {
            return ColorButton{
                .ptr = @ptrCast(*c.GtkColorButton, self.ptr),
            };
        } else return null;
    }

    pub fn to_color_chooser_widget(self: ColorChooser) ?ColorChooserWidget {
        if (self.as_widget().isa(ColorChooserWidget)) {
            return ColorChooserWidget{
                .ptr = @ptrCast(*c.GtkColorChooserWidget, self.ptr),
            };
        } else return null;
    }

    pub fn to_color_chooser_dialog(self: ColorChooser) ?ColorChooserDialog {
        if (self.as_widget().isa(ColorChooserWidget)) {
            return ColorChooserDialog{
                .ptr = @ptrCast(*c.GtkColorChooserDialog, self.ptr),
            };
        } else return null;
    }
};

pub const ColorButton = struct {
    ptr: *c.GtkColorButton,

    pub fn as_color_chooser(self: ColorButton) ColorChooser {
        return ColorChooser{
            .ptr = @ptrCast(*c.GtkColorChooser, self.ptr),
        };
    }

    pub fn as_button(self: ColorButton) Button {
        return Button{
            .ptr = @ptrCast(*c.GtkButton, self.ptr),
        };
    }

    pub fn as_widget(self: ColorButton) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_color_button_get_type());
    }
};

pub const ColorChooserWidget = struct {
    ptr: *c.GtkColorChooserWidget,

    pub fn as_color_chooser(self: ColorChooserWidget) ColorChooser {
        return ColorChooser{
            .ptr = @ptrCast(*c.GtkColorChooser, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_color_chooser_widget_get_type());
    }
};

pub const ColorChooserDialog = struct {
    ptr: *c.GtkColorChooserDialog,

    pub fn as_color_chooser(self: ColorChooserDialog) ColorChooser {
        return ColorChooser{
            .ptr = @ptrCast(*c.GtkColorChooser, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_color_chooser_dialog_get_type());
    }
};
