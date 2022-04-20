const c = @import("cimport.zig");
const Buildable = @import("buildable.zig").Buildable;
const Button = @import("button.zig").Button;
const Dialog = @import("dialog.zig").Dialog;
const Orientable = @import("orientable.zig").Orientable;
const Widget = @import("widget.zig").Widget;
const Window = @import("window.zig").Window;

const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const FileChooser = struct {
    ptr: *c.GtkFileChooser,

    const Self = @This();

    pub const Action = enum(c_uint) {
        open = c.GTK_FILE_CHOOSER_ACTION_OPEN,
        save = c.GTK_FILE_CHOOSER_ACTION_SAVE,
        select_folder = c.GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER,
        create_folder = c.GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER,
    };

    pub const Confirmation = enum(c_uint) {
        confirm = c.GTK_FILE_CHOOSER_CONFIRMATION_CONFIRM,
        accept_filename = c.GTK_FILE_CHOOSER_CONFIRMATION_ACCEPT_FILENAME,
        select_again = c.GTK_FILE_CHOOSER_CONFIRMATION_SELECT_AGAIN,
    };

    pub const Error = enum(c_uint) {
        nonexistent = c.GTK_FILE_CHOOSER_ERROR_NONEXISTENT,
        bad_filename = c.GTK_FILE_CHOOSER_ERROR_BAD_FILENAME,
        already_exists = c.GTK_FILE_CHOOSER_ERROR_ALREADY_EXISTS,
        incomplete_hostname = c.GTK_FILE_CHOOSER_ERROR_INCOMPLETE_HOSTNAME,
    };

    pub fn set_action(self: Self, action: Action) void {
        c.gtk_file_chooser_set_action(self.ptr, @enumToInt(action));
    }

    pub fn get_action(self: Self) Action {
        return c.gtk_file_chooser_get_action(self.ptr);
    }

    pub fn set_local_only(self: Self, local: bool) void {
        c.gtk_file_chooser_set_local_only(self.ptr, if (local) 1 else 0);
    }

    pub fn get_local_only(self: Self) bool {
        return (c.gtk_file_chooser_get_local_only(self.ptr) == 1);
    }

    pub fn set_select_multiple(self: Self, multiple: bool) void {
        c.gtk_file_chooser_set_select_multiple(self.ptr, if (multiple) 1 else 0);
    }

    pub fn get_select_multiple(self: Self) bool {
        return (c.gtk_file_chooser_get_select_multiple(self.ptr) == 1);
    }

    pub fn set_show_hidden(self: Self, hidden: bool) void {
        c.gtk_file_chooser_set_show_hidden(self.ptr, if (hidden) 1 else 0);
    }

    pub fn get_show_hidden(self: Self) bool {
        return (c.gtk_file_chooser_get_show_hidden(self.ptr) == 1);
    }

    pub fn set_do_overwrite_confirmation(self: Self, confirm: bool) void {
        c.gtk_file_chooser_set_do_overwrite_confirmation(self.ptr, if (confirm) 1 else 0);
    }

    pub fn get_do_overwrite_confirmation(self: Self) bool {
        return (c.gtk_file_chooser_get_do_overwrite_confirmation(self.ptr) == 1);
    }

    pub fn set_create_folders(self: Self, create: bool) void {
        c.gtk_file_chooser_set_create_folders(self.ptr, if (create) 1 else 0);
    }

    pub fn get_create_folders(self: Self) bool {
        return (c.gtk_file_chooser_get_create_folders(self.ptr) == 1);
    }

    pub fn set_current_name(self: Self, name: [:0]const u8) void {
        c.gtk_file_chooser_set_current_name(self.ptr, name);
    }

    pub fn get_current_name(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_current_name(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn get_filename(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_filename(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_filename(self: Self, name: [:0]const u8) void {
        c.gtk_file_chooser_set_filename(self.ptr, name);
    }

    pub fn select_filename(self: Self, filename: [:0]const u8) void {
        c.gtk_file_chooser_select_filename(self.ptr, filename);
    }

    pub fn unselect_filename(self: Self, filename: [:0]const u8) void {
        c.gtk_file_chooser_unselect_filename(self.ptr, filename);
    }

    pub fn select_all(self: Self) void {
        c.gtk_file_chooser_select_all(self.ptr);
    }

    pub fn unselect_all(self: Self) void {
        c.gtk_file_chooser_unselect_all(self.ptr);
    }

    pub fn get_filenames(self: Self, allocator: mem.Allocator) ?std.ArrayList(Widget) {
        var kids = c.gtk_file_chooser_get_filenames(self.ptr);
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

    pub fn set_current_folder(self: Self, folder: [:0]const u8) void {
        c.gtk_file_chooser_set_current_folder(self.ptr, folder);
    }

    pub fn get_current_folder(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_current_folder(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn get_uri(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_uri(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_uri(self: Self, uri: [:0]const u8) void {
        c.gtk_file_chooser_set_uri(self.ptr, uri);
    }

    pub fn select_uri(self: Self, uri: [:0]const u8) void {
        c.gtk_file_chooser_select_uri(self.ptr, uri);
    }

    pub fn unselect_uri(self: Self, uri: [:0]const u8) void {
        c.gtk_file_chooser_unselect_uri(self.ptr, uri);
    }

    pub fn get_uris(self: Self, allocator: mem.Allocator) ?std.ArrayList(Widget) {
        var kids = c.gtk_file_chooser_get_uris(self.ptr);
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

    pub fn set_current_folder_uri(self: Self, uri: [:0]const u8) void {
        c.gtk_file_chooser_set_current_folder_uri(self.ptr, uri);
    }

    pub fn get_current_folder_uri(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_current_folder_uri(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_preview_widget(self: Self, widget: Widget) void {
        c.gtk_file_chooser_set_preview_widget(self.ptr, widget.ptr);
    }

    pub fn get_preview_widget(self: Self) ?Widget {
        if (c.get_file_chooser_get_preview_widget(self.ptr)) |ptr| {
            return Widget{ .ptr = ptr };
        } else return null;
    }

    pub fn set_preview_widget_active(self: Self, active: bool) void {
        c.gtk_file_chooser_set_preview_widget_active(self.ptr, if (active) 1 else 0);
    }

    pub fn get_preview_widget_active(self: Self) bool {
        return (c.gtk_file_chooser_get_preview_widget_active(self.ptr) == 1);
    }

    pub fn set_use_preview_label(self: Self, use: bool) void {
        c.gtk_file_chooser_set_use_preview_label(self.ptr, if (use) 1 else 0);
    }

    pub fn get_use_preview_label(self: Self) bool {
        return (c.gtk_file_chooser_get_use_preview_label(self.ptr) == 1);
    }

    pub fn get_preview_filename(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_preview_filename(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn get_preview_uri(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_get_preview_uri(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_extra_widget(self: Self, widget: Widget) void {
        c.gtk_file_chooser_set_extra_widget(self.ptr, widget.ptr);
    }

    pub fn get_extra_widget(self: Self) ?Widget {
        if (c.gtk_file_chooser_get_extra_widget(self.ptr)) |ptr| {
            return Widget{ .ptr = ptr };
        } else return null;
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @ptrCast(*c.GtkWidget, self.ptr) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_file_chooser_get_type() or FileChooserButton.is_instance(gtype) or FileChooserWidget.is_instance(gtype) or FileChooserDialog.is_instance(gtype));
    }
};

pub const FileChooserButton = struct {
    ptr: *c.GtkFileChooserButton,

    const Self = @This();

    pub fn new(title: [:0]const u8, action: FileChooser.Action) Self {
        return Self{ .ptr = @ptrCast(
            *c.GtkFileChooserButton,
            c.gtk_file_chooser_button_new(title, @enumToInt(action)),
        ) };
    }

    pub fn new_with_dialog(dlg: FileChooserDialog) Self {
        return Self{ .ptr = @ptrCast(*c.GtkFileChooserButton, c.gtk_file_chooser_button_new_with_dialog(@ptrCast(*c.GtkWidget, dlg.ptr))) };
    }

    pub fn get_title(self: Self, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.gtk_file_chooser_button_get_title(self.ptr);
        const len = mem.len(val);
        return fmt.allocPrintZ(allocator, "{s}", .{val[0..len]}) catch return null;
    }

    pub fn set_title(self: Self, title: [:0]const u8) void {
        c.gtk_file_chooser_button_set_title(self.ptr, title);
    }

    pub fn get_width_chars(self: Self) c_int {
        return c.gtk_file_chooser_button_get_width_chars(self.ptr);
    }

    pub fn set_width_chars(self: Self, width: c_int) void {
        c.gtk_file_chooser_button_set_width_chars(self.ptr, width);
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{ .ptr = @ptrCast(*c.GtkBuildable, self.ptr) };
    }

    pub fn as_button(self: Self) Button {
        return Button{ .ptr = @ptrCast(*c.GtkButton, self.ptr) };
    }

    pub fn as_filechooser(self: Self) FileChooser {
        return FileChooser{ .ptr = @ptrCast(*c.GtkWidget, self.ptr) };
    }

    pub fn as_orientable(self: Self) Orientable {
        return Orientable{ .ptr = @ptrCast(*c.GtkOrientable, self.ptr) };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @ptrCast(*c.GtkWidget, self.ptr) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_file_chooser_button_get_type());
    }
};

pub const FileChooserWidget = struct {
    ptr: *c.GtkFileChooserWidget,

    const Self = @This();

    pub fn new() Self {
        return Self{ .ptr = @ptrCast(*c.GtkFileChooserWidget, c.gtk_file_chooser_widget_new()) };
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{ .ptr = @ptrCast(*c.GtkBuildable, self.ptr) };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @ptrCast(*c.GtkWidget, self.ptr) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_file_chooser_widget_get_type());
    }
};

pub const FileChooserDialog = struct {
    ptr: *c.GtkFileChooserDialog,

    const Self = @This();

    pub fn new(
        title: [:0]const u8,
        parent: Window,
        action: FileChooser.Action,
        first_button_text: [:0]const u8,
    ) Self {
        return c.gtk_file_chooser_dialog_new(title, parent.ptr, @enumToInt(action), first_button_text);
    }

    pub fn as_buildable(self: Self) Buildable {
        return Buildable{ .ptr = @ptrCast(*c.GtkBuildable, self.ptr) };
    }

    pub fn as_dialog(self: Self) Dialog {
        return Dialog{ .ptr = @ptrCast(*c.GtkWidget, self.ptr) };
    }

    pub fn as_widget(self: Self) Widget {
        return Widget{ .ptr = @ptrCast(*c.GtkWidget, self.ptr) };
    }

    pub fn is_instance(gtype: u64) bool {
        return (gtype == c.gtk_file_chooser_dialog_get_type());
    }
};
