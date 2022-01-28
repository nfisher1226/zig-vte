const c = @import("cimport.zig");
const com = @import("common.zig");
const enums = @import("enums.zig");
const Widget = @import("widget.zig").Widget;
const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

/// PtyFlags enum
pub const PtyFlags = enum {
    no_lastlog,
    no_utmp,
    no_wtmp,
    no_helper,
    no_fallback,
    default,

    pub fn parse(self: PtyFlags) c.VtePtyFlags {
        return switch (self) {
            .no_lastlog => c.VTE_PTY_NO_LASTLOG,
            .no_utmp => c.VTE_PTY_NO_UTMP,
            .no_wtmp => c.VTE_PTY_NO_WTMP,
            .no_helper => c.VTE_PTY_NO_HELPER,
            .no_fallback => c.VTE_PTY_NO_FALLBACK,
            .default => c.VTE_PTY_DEFAULT,
        };
    }

    pub fn from_c(flags: c.VtePtyFlags) PtyFlags {
        return switch (flags) {
            c.VTE_PTY_NO_LASTLOG => .no_lastlog,
            c.VTE_PTY_NO_UTMP => .no_utmp,
            c.VTE_PTY_NO_WTMP => .no_wtmp,
            c.VTE_PTY_NO_HELPER => .no_helper,
            c.VTE_PTY_NO_FALLBACK => .no_fallback,
            c.VTE_PTY_DEFAULT => .default,
        };
    }
};

/// Zig enum CursorBlinkMode
pub const CursorBlinkMode = enum {
    system,
    on,
    off,

    pub fn parse(self: CursorBlinkMode) c.VteCursorBlinkMode {
        return switch (self) {
            .system => c.VTE_CURSOR_BLINK_SYSTEM,
            .on => c.VTE_CURSOR_BLINK_ON,
            .off => c.VTE_CURSOR_BLINK_OFF,
        };
    }

    pub fn from_c(mode: c.VteCursorBlinkMode) CursorBlinkMode {
        return switch (mode) {
            c.VTE_CURSOR_BLINK_SYSTEM => .system,
            c.VTE_CURSOR_BLINK_ON => .on,
            c.VTE_CURSOR_BLINK_OFF => .off,
        };
    }
};

/// Zig enum CursorShape
pub const CursorShape = enum {
    block,
    ibeam,
    underline,

    pub fn parse(self: CursorShape) c.VteCursorShape {
        return switch (self) {
            .block => c.VTE_CURSOR_SHAPE_BLOCK,
            .ibeam => c.VTE_CURSOR_SHAPE_IBEAM,
            .underline => c.VTE_CURSOR_SHAPE_UNDERLINE,
        };
    }

    pub fn from_c(shape: c.VteCursorShape) CursorShape {
        return switch (shape) {
            c.VTE_CURSOR_SHAPE_BLOCK => .block,
            c.VTE_CURSOR_SHAPE_IBEAM => .ibeam,
            c.VTE_CURSOR_SHAPE_UNDERLINE => .underline,
        };
    }
};

/// enum Format
pub const Format = enum {
    text,
    html,

    const Self = @This();

    pub fn parse(self: Self) c.VteFormat {
        return switch (self) {
            .text => c.VTE_FORMAT_TEXT,
            .html => c.VTE_FORMAT_HTML,
        };
    }

    pub fn from_c(format: c.VteFormat) Self {
        return switch (format) {
            c.VTE_FORMAT_TEXT => Self.text,
            c.VTE_FORMAT_HTML => Self.html,
        };
    }
};

pub const Terminal = struct {
    ptr: *c.VteTerminal,

    const Self = @This();

    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.VteTerminal, c.vte_terminal_new()),
        };
    }

    pub fn feed(self: Self, data: [:0]const u8, length: c_long) void {
        c.vte_terminal_feed(self.ptr, data, length);
    }

    pub fn feed_child(self: Self, text: [:0]const u8, length: c_long) void {
        c.vte_terminal_feed_child(self.ptr, text, length);
    }

    pub fn select_all(self: Self) void {
        c.vte_terminal_select_all(self.ptr);
    }

    pub fn unselect_all(self: Self) void {
        c.vte_terminal_unselect_all(self.ptr);
    }

    pub fn copy_clipboard_format(self: Self, format: Format) void {
        c.vte_terminal_copy_clipboard_format(self.ptr, format.parse());
    }

    pub fn paste_clipboard(self: Self) void {
        c.vte_terminal_paste_clipboard(self.ptr);
    }

    pub fn copy_primary(self: Terminal) void {
        c.vte_terminal_copy_primary(self.ptr);
    }

    pub fn paste_primary(self: Terminal) void {
        c.vte_terminal_paste_primary(self.ptr);
    }

    pub fn set_size(self: Self, cols: c_long, rows: c_long) void {
        c.vte_terminal_set_size(self.ptr, cols, rows);
    }

    pub fn set_font_scale(self: Self, scale: c_longlong) void {
        c.vte_terminal_set_font_scale(self.ptr, scale);
    }

    pub fn get_font_scale(self: Self) c_longlong {
        return c.vte_terminal_get_font_scale(self.ptr);
    }

    pub fn set_audible_bell(self: Self, audible: bool) void {
        c.vte_terminal_set_audible_bell(self.ptr, if (audible) 1 else 0);
    }

    pub fn get_audible_bell(self: Self) bool {
        return (c.vte_terminal_get_audible_bell(self.ptr) == 1);
    }

    pub fn set_bold_is_bright(self: Self, bib: bool) void {
        c.vte_terminal_set_bold_is_bright(self.ptr, if (bib) 1 else 0);
    }

    pub fn get_bold_is_bright(self: Self) bool {
        return (c.vte_terminal_get_bold_is_bright(self.ptr) == 1);
    }

    pub fn set_allow_hyperlink(self: Self, allow: bool) void {
        c.vte_terminal_set_allow_hyperlink(self.ptr, if (allow) 1 else 0);
    }

    pub fn get_allow_hyperlink(self: Self) bool {
        return (c.vte_terminal_get_allow_hyperlink(self.ptr) == 1);
    }

    pub fn spawn_async(
        self: Self,
        flags: PtyFlags,
        wkgdir: ?[:0]const u8,
        command: [:0]const u8,
        env: ?[][:0]const u8,
        spawn_flags: enums.SpawnFlags,
        child_setup_func: ?c.GSpawnChildSetupFunc,
        timeout: c_int,
        cancellable: ?*c.GCancellable,
    ) void {
        c.vte_terminal_spawn_async(
            self.ptr,
            flags.parse(),
            if (wkgdir) |d| d else null,
            @ptrCast([*c][*c]c.gchar, &([2][*c]c.gchar{
                c.g_strdup(command),
                null,
            })),
            if (env) |e| @ptrCast([*c][*c]u8, e) else null,
            spawn_flags.parse(),
            if (child_setup_func) |f| f else null,
            @intToPtr(?*anyopaque, @as(c_int, 0)),
            null,
            timeout,
            if (cancellable) |cn| cn else null,
            null,
            @intToPtr(?*anyopaque, @as(c_int, 0)),
        );
    }

    pub fn set_clear_background(self: Terminal, clear: bool) void {
        c.vte_terminal_set_clear_background(self.ptr, com.bool_to_c_int(clear));
    }

    pub fn get_current_directory_uri(self: Terminal, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.vte_terminal_get_current_directory_uri(self.ptr);
        if (val) |v| {
            const len = mem.len(v);
            const text = fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    pub fn get_window_title(self: Terminal, allocator: mem.Allocator) ?[:0]const u8 {
        const val = c.vte_terminal_get_window_title(self.ptr);
        if (val) |v| {
            const len = mem.len(v);
            const text = fmt.allocPrintZ(allocator, "{s}", .{v[0..len]}) catch {
                return null;
            };
            return text;
        } else return null;
    }

    pub fn set_default_colors(self: Terminal) void {
        c.vte_terminal_set_default_colors(self.ptr);
    }

    pub fn set_color_foreground(self: Terminal, color: *c.GdkRGBA) void {
        c.vte_terminal_set_color_foreground(self.ptr, color);
    }

    pub fn set_color_background(self: Terminal, color: *c.GdkRGBA) void {
        c.vte_terminal_set_color_background(self.ptr, color);
    }

    pub fn set_color_cursor(self: Terminal, color: *c.GdkRGBA) void {
        c.vte_terminal_set_color_cursor(self.ptr, color);
    }

    pub fn set_color_cursor_foreground(self: Terminal, color: *c.GdkRGBA) void {
        c.vte_termina_set_color_cursor_foreground(self.ptr, color);
    }

    pub fn set_color_highlight(self: Terminal, color: *c.GdkRGBA) void {
        c.vte_terminal_set_color_highlight(self.ptr, color);
    }

    pub fn set_color_highlight_foreground(self: Terminal, color: *c.GdkRGBA) void {
        c.vte_terminal_set_color_highlight_foreground(self.ptr, color);
    }

    pub fn get_cursor_shape(self: Terminal) CursorShape {
        const shape = c.vte_terminal_get_cursor_shape(self.ptr);
        return CursorShape.from_c(shape);
    }

    pub fn set_cursor_shape(self: Terminal, shape: CursorShape) void {
        c.vte_terminal_set_cursor_shape(self.ptr, shape.parse());
    }

    pub fn get_cursor_blink_mode(self: Terminal) CursorBlinkMode {
        const mode = c.vte_terminal_get_cursor_blink_mode(self.ptr);
        return CursorBlinkMode.from_c(mode);
    }

    pub fn set_cursor_blink_mode(self: Terminal, mode: CursorBlinkMode) void {
        c.vte_terminal_set_cursor_blink_mode(self.ptr, mode.parse());
    }

    pub fn connect_child_exited(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("child_exited", callback, if (data) |d| d else null);
    }

    pub fn as_widget(self: Terminal) Widget {
        return Widget{
            .ptr = @ptrCast(*c.GtkWidget, self.ptr),
        };
    }

    pub fn from_widget(widget: Widget) ?Terminal {
        return Terminal{
            .ptr = @ptrCast(*c.VteTerminal, widget.ptr),
        };
    }
};
