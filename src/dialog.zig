const c = @import("cimport.zig");
const common = @import("common.zig");
const Container = @import("container.zig").Container;
const License = @import("enums.zig").License;
const Widget = @import("widget.zig").Widget;
const Window = @import("window.zig").Window;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Dialog = struct {
    ptr: *c.GtkDialog,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkDialog, c.gtk_dialog_new()),
        };
    }

    pub fn run(self: Self) c_int {
        return c.gtk_dialog_run(self.ptr);
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_dialog_get_type()
        or AboutDialog.is_instance(gtype));
    }
};

pub const AboutDialog = struct {
    ptr: *c.GtkAboutDialog,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.GtkAboutDialog, c.gtk_about_dialog_new()),
        };
    }

    pub fn get_program_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_program_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_program_name(self: AboutDialog, name: [:0]const u8) void {
        c.gtk_about_dialog_set_program_name(self.ptr, name);
    }

    pub fn get_version(self: AboutDialog, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_version(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_version(self: AboutDialog, version: [:0]const u8) void {
        c.gtk_about_dialog_set_version(self.ptr, version);
    }

    pub fn get_copyright(self: AboutDialog, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_copyright(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_copyright(self: AboutDialog, copyright: [:0]const u8) void {
        c.gtk_about_dialog_set_copyright(self.ptr, copyright);
    }

    pub fn get_comments(self: AboutDialog, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_comments(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_comments(self: AboutDialog, comments: [:0]const u8) void {
        c.gtk_about_dialog_set_copyright(self.ptr, comments);
    }

    pub fn get_license(self: AboutDialog, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_license(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_license(self: AboutDialog, license: [:0]const u8) void {
        c.gtk_about_dialog_set_license(self.ptr, license);
    }

    pub fn get_wrap_license(self: Self) bool {
        return (c.gtk_about_dialog_get_wrap_license(self.ptr) == 1);
    }

    pub fn set_wrap_license(self: Self, wrap: bool) void {
        c.gtk_about_dialog_set_wrap_license(self.ptr, if (wrap) 1 else 0);
    }

    pub fn get_license_type(self: Self) License {
        return switch (c.gtk_about_dialog_get_license_type(self.ptr)) {
            c.GTK_LICENSE_UNKNOWN => License.unknown,
            c.GTK_LICENSE_CUSTOM => License.custom,
            c.GTK_LICENSE_GPL_2_0 => License.gpl2,
            c.GTK_LICENSE_GPL_3_0 => License.gpl3,
            c.GTK_LICENSE_LGPL_2_1 => License.lgpl2_1,
            c.GTK_LICENSE_LGPL_3_0 => License.lgpl3,
            c.GTK_LICENSE_BSD => License.bsd,
            c.GTK_LICENSE_MIT_X11 => License.mit_x11,
            c.GTK_LICENSE_ARTISTIC => License.artistic,
            c.GTK_LICENSE_GPL_2_0_ONLY => License.gpl2_only,
            c.GTK_LICENSE_GPL_3_0_ONLY => License.gpl3_only,
            c.GTK_LICENSE_LGPL_2_1_ONLY => License.lgpl2_1_only,
            c.GTK_LICENSE_LGPL_3_0_ONLY => License.lgpl3_only,
            c.GTK_LICENSE_AGPL_3_0 => License.agpl3,
            c.GTK_LICENSE_AGPL_3_0_ONLY => License.agpl3_only,
            c.GTK_LICENSE_BSD_3 => License.bsd3,
            c.GTK_LICENSE_APACHE_2_0 => License.apache2,
            c.GTK_LICENSE_MPL_2_0 => License.mpl2,
        };
    }

    pub fn set_license_type(self: Self, license: License) void {
        c.gtk_about_dialog_set_license_type(self.ptr, license.parse());
    }

    pub fn get_website(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_website(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_website(self: Self, site: [:0]const u8) void {
        c.gtk_about_dialog_set_website(self.ptr, site);
    }

    pub fn get_website_label(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_website_label(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_website_label(self: Self, label: [:0]const u8) void {
        c.gtk_about_dialog_set_website_label(self.ptr, label);
    }

    pub fn get_authors(self: Self) [][:0]const u8 {
        return c.gtk_about_dialog_get_authors(self.ptr);
    }

    /// Gtk+ expects a pointer to a null terminated array of pointers to null
    /// terminated arrays of u8. In order to coerce properly follow this form:
    /// var authors = [_:0][*c]const u8{ "Your Name" };
    /// dlg.set_authors(&authors);
    pub fn set_authors(self: Self, authors: [*c][*c]const u8) void {
        c.gtk_about_dialog_set_authors(self.ptr, authors);
    }

    pub fn get_artists(self: Self) [*c][*c]const u8 {
        return c.gtk_about_dialog_get_artists(self.ptr);
    }

    /// Gtk+ expects a pointer to a null terminated array of pointers to null
    /// terminated arrays of u8. In order to coerce properly follow this form:
    /// var artists = [_:0][*c]const u8{ "Some Artist" };
    /// dlg.set_authors(&artists);
    pub fn set_artists(self: Self, artists: [*c][*c]const u8) void {
        c.gtk_about_dialog_set_artists(self.ptr, artists);
    }

    pub fn get_documentors(self: Self) [*c][*c]const u8 {
        return c.gtk_about_dialog_get_documentors(self.ptr);
    }

    /// Gtk+ expects a pointer to a null terminated array of pointers to null
    /// terminated arrays of u8. In order to coerce properly follow this form:
    /// var documentors = [_:0][*c]const u8{ "Some Person" };
    /// dlg.set_authors(&documentors);
    pub fn set_documentors(self: Self, artists: [*c][*c]const u8) void {
        c.gtk_about_dialog_set_documentors(self.ptr, artists);
    }

    pub fn get_translator_credits(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_translator_credits(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_translator_credits(self: Self, site: [:0]const u8) void {
        c.gtk_about_dialog_set_translator_credits(self.ptr, site);
    }

    pub fn get_logo(self: Self) *c.GdkPixbuf {
        return c.gtk_about_dialog_get_logo(self.ptr);
    }

    pub fn set_logo(self: Self, logo: *c.GdkPixbuf) void {
        c.gtk_about_dialog_set_logo(self.ptr, logo);
    }

    pub fn get_logo_icon_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_about_dialog_get_logo_icon_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_logo_icon_name(self: Self, name: [:0]const u8) void {
        c.gtk_about_dialog_set_logo_icon_name(self.ptr, name);
    }

    /// Gtk+ expects a pointer to a null terminated array of pointers to null
    /// terminated arrays of u8. In order to coerce properly follow this form:
    /// var documentorss = [_:0][*c]const u8{ "Some Person" };
    /// dlg.set_authors(&documentors);
    pub fn add_credit_section(self: Self, section_name: [:0]const u8, people: [*c][*c]const u8) void {
        c.gtk_about_dialog_add_credit_section(self.ptr, section_name, people);
    }

    pub fn as_dialog(self: Self) Dialog {
        return Dialog{
            .ptr = @ptrCast(*c.GtkDialog, self.ptr),
        };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_about_dialog_get_type());
    }
};

pub const Flags = enum {
    modal,
    destroy_with_parent,
    use_header_bar,

    const Self = @This();

    pub fn parse(self: Self) c.GtkDialogFlags {
        return switch (self) {
            .modal => c.GTK_DIALOG_FLAGS_MODAL,
            .destroy_with_parent => c.GTK_DIALOG_FLAGS_DESTROY_WITH_PARENT,
            .use_header_bar => c.GTK_DIALOG_FLAGS_USE_HEADER_BAR,
        };
    }
};
