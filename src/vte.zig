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

/// enum TextBlinkMode
pub const TextBlinkMode = enum {
    never,
    focused,
    unfocused,
    always,

    const Self = @This();

    pub fn parse(self: Self) c.VteTextBlinkMode {
        return switch (self) {
            .never => c.VTE_TEXT_BLINK_NEVER,
            .focused => c.VTE_TEXT_BLINK_FOCUSED,
            .unfocused => c.VTE_TEXT_BLINK_UNFOCUSED,
            .always => c.VTE_TEXT_BLINK_ALWAYS,
        };
    }

    pub fn from_c(mode: c.VteTextBlinkMode) Self {
        return switch (mode) {
            c.VTE_TEXT_BLINK_NEVER => Self.never,
            c.VTE_TEXT_BLINK_FOCUSED => Self.focused,
            c.VTE_TEXT_BLINK_UNFOCUSED => Self.unfocused,
            c.VTE_TEXT_BLINK_ALWAYS => Self.always,
        };
    }
};

/// enum EraseBinding
pub const EraseBinding = enum {
    auto,
    ascii_backspace,
    ascii_delete,
    delete_sequence,
    tty,

    const Self = @This();

    pub fn parse(self: Self) c.VteEraseBinding {
        return switch (self) {
            .auto => c.VTE_ERASE_AUTO,
            .ascii_backspace => c.VTE_ERASE_ASCII_BACKSPACE,
            .ascii_delete => c.VTE_ERASE_ASCII_DELETE,
            .delete_sequence => c.VTE_ERASE_DELETE_SEQUENCE,
            .tty => c.VTE_ERRASE_TTY,
        };
    }

    pub fn from_c(binding: c.VteEraseBinding) Self {
        return switch (binding) {
            c.VTE_ERASE_AUTO => Self.auto,
            c.VTE_ERASE_ASCII_BACKSPACE => Self.ascii_backspace,
            c.VTE_ERASE_ASCII_DELETE => Self.ascii_delete,
            c.VTE_ERASE_DELETE_SEQUENCE => Self.delete_sequence,
            c.VTE_ERRASE_TTY => Self.tty,
        };
    }
};

pub const CursorPosition = struct {
    x: c_long,
    y: c_long,
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

    pub fn set_enable_fallback_scrolling(self: Self, enable: bool) void {
        c.vte_terminal_set_enable_fallback_scrolling(self.ptr, if (enable) 1 else 0);
    }

    pub fn get_enable_fallback_scrolling(self: Self) bool {
        return (c.vte_terminal_get_enable_fallback_scrolling(self.ptr) == 1);
    }

    pub fn set_scroll_on_output(self: Self, set: bool) void {
        c.vte_terminal_set_scroll_on_output(self.ptr, if (set) 1 else 0);
    }

    pub fn get_scroll_on_output(self: Self) bool {
        return (c.vte_terminal_get_scroll_on_ouput(self.ptr) == 1);
    }

    pub fn set_scroll_on_keystroke(self: Self, set: bool) void {
        c.vte_terminal_set_scroll_on_keystroke(self.ptr, if (set) 1 else 0);
    }

    pub fn get_scroll_on_keystroke(self: Self) bool {
        return (c.vte_terminal_get_scroll_on_output(self.ptr) == 1);
    }

    pub fn set_scroll_unit_is_pixels(self: Self, set: bool) void {
        c.vte_terminal_set_scroll_unit_is_pixels(self.ptr, if (set) 1 else 0);
    }

    pub fn get_scroll_unit_is_pixels(self: Self) bool {
        return (c.vte_terminal_get_scroll_unit_is_pixels(self.ptr) == 1);
    }

    pub fn set_cell_height_scale(self: Self, scale: c_longlong) void {
        c.vte_terminal_set_cell_height_scale(self.ptr, scale);
    }

    pub fn get_cell_height_scale(self: Self) c_longlong {
        return (c.vte_terminal_get_cell_height_scale(self.ptr) == 1);
    }

    pub fn set_cell_width_scale(self: Self, scale: c_longlong) void {
        c.vte_terminal_set_cell_width_scale(self.ptr, scale);
    }

    pub fn get_cell_width_scale(self: Self) c_longlong {
        return c.vte_terminal_get_cell_width_scale(self.ptr);
    }

    pub fn set_color_bold(self: Self, color: *c.GdkRGBA) void {
        c.vte_terminal_set_color_bold(self.ptr, color);
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

    pub fn get_text_blink_mode(self: Self) TextBlinkMode {
        return TextBlinkMode.from_c(c.vte_terminal_get_text_blink_mode(self.ptr));
    }

    pub fn set_text_blink_mode(self: Self, mode: TextBlinkMode) void {
        c.vte_terminal_set_text_blink_mode(self.ptr, mode.parse());
    }

    pub fn set_colors(
        self: Self,
        foreground: ?*c.GdkRGBA,
        background: ?*c.GdkRGBA,
        colors: anytype,
        psize: c_ulong,
    ) void {
        c.vte_terminal_set_colors(
            self.ptr,
            if (foreground) |f| f else null,
            if (background) |b| b else null,
            colors,
            psize,
        );
    }

    pub fn set_default_colors(self: Terminal) void {
        c.vte_terminal_set_default_colors(self.ptr);
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

    pub fn set_scrollback_lines(self: Self, lines: c_long) void {
        c.vte_terminal_set_scrollback_lines(self.ptr, lines);
    }

    pub fn get_scrollback_lines(self: Self) c_long {
        return c.vte_terminal_get_scrollback_lines(self.ptr);
    }

    pub fn set_font(self: Self, font: ?*c.PangoFontDescription) void {
        c.vte_terminal_set_font(self.ptr, if (font) |f| f else null);
    }

    pub fn get_font(self: Self) *c.PangoFontDescription {
        return c.vte_terminal_get_font(self.ptr);
    }

    pub fn get_has_selection(self: Self) bool {
        return (c.vte_terminal_get_has_selection(self.ptr) == 1);
    }

    pub fn set_backspace_binding(self: Self, binding: EraseBinding) void {
        c.vte_terminal_set_backspace_binding(self.ptr, binding.parse());
    }

    pub fn set_delete_binding(self: Self, binding: EraseBinding) void {
        c.vte_terminal_set_delete_binding(self.ptr, binding.parse());
    }

    pub fn set_mouse_autohide(self: Self, hide: bool) void {
        c.vte_terminal_set_mouse_autohide(self.ptr, if (hide) 1 else 0);
    }

    pub fn get_mouse_autohide(self: Self) bool {
        return (c.vte_terminal_get_mouse_autohide(self.ptr) == 1);
    }

    pub fn set_enable_bidi(self: Self, bidi: bool) void {
        c.vte_terminal_set_enable_bidi(self.ptr, if (bidi) 1 else 0);
    }

    pub fn get_enable_bidi(self: Self) bool {
        return (c.vte_terminal_get_enable_bidi(self.ptr) == 1);
    }

    pub fn set_enable_shaping(self: Self, set: bool) void {
        c.vte_terminal_set_enable_shaping(self.ptr, if (set) 1 else 0);
    }

    pub fn get_enable_shaping(self: Self) bool {
        return (c.vte_terminal_get_enable_shaping(self.ptr) == 1);
    }

    pub fn reset(self: Self) void {
        c.vte_terminal_reset(self.ptr);
    }

    pub fn get_cursor_position(self: Self) CursorPosition {
        var x: c_long = undefined;
        var y: c_long = undefined;
        c.vte_terminal_get_cursor_position(self.ptr, x, y);
        return CursorPosition{ .x = x, .y = y };
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
