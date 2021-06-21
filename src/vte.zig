usingnamespace @import("cimport.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");
const std = @import("std");

/// Vte enum VteCursorBlinkMode
pub const cursor_blink_system = @intoToEnum(VteCursorBlinkMode, VTE_CURSOR_BLINK_SYSTEM);
pub const cursor_blink_on = @intoToEnum(VteCursorBlinkMode, VTE_CURSOR_BLINK_ON);
pub const cursor_blink_off = @intoToEnum(VteCursorBlinkMode, VTE_CURSOR_BLINK_OFF);

/// VtePtyFlags enum
pub const pty_no_lastlog = @intToEnum(VtePtyFlags, VTE_PTY_NO_LASTLOG);
pub const pty_no_utmp = @intToEnum(VtePtyFlags, VTE_PTY_NO_UTMP);
pub const pty_no_wtmp = @intToEnum(VtePtyFlags, VTE_PTY_NO_WTMP);
pub const pty_no_helper = @intToEnum(VtePtyFlags, VTE_PTY_NO_HELPER);
pub const pty_no_fallback = @intToEnum(VtePtyFlags, VTE_PTY_NO_FALLBACK);
pub const pty_default = @intToEnum(VtePtyFlags, VTE_PTY_DEFAULT);

/// Zig enum CursorBlinkMode
pub const CursorBlinkMode = enum {
    system,
    on,
    off,

    pub fn parse(self: CursorBlinkMode) VteCursorBlinkMode {
        switch (self) {
            .system => return cursor_blink_system,
            .on => return cursor_blink_on,
            .off => return cursor_blink_off,
        }
    }
};

/// Vte enum VteCursorShape
pub const cursor_shape_block = @intToEnum(VteCursorShape, VTE_CURSOR_SHAPE_BLOCK);
pub const cursor_shape_ibeam = @intToEnum(VteCursorShape, VTE_CURSOR_SHAPE_IBEAM);
pub const cursor_shape_underline = @intToEnum(VteCursorShape, VTE_CURSOR_SHAPE_UNDERLINE);

/// Zig enum CursorShape
pub const CursorShape = enum {
    block,
    ibeam,
    underline,

    pub fn parse(self: CursorShape) VteCursorShape {
        switch (self) {
            .block => return cursor_shape_block,
            .ibeam => return cursor_shape_ibeam,
            .underline => return cursor_shape_underline,
        }
    }
};

pub const Terminal = struct {
    ptr: *VteTerminal,

    pub fn new() Terminal {
        return Terminal {
            .ptr = @ptrCast(*VteTerminal, vte_terminal_new()),
        };
    }

    pub fn spawn_async(
            self: Terminal,
            flags: VtePtyFlags,
            wkgdir: ?[:0]const u8,
            command: [:0]const u8,
            env: ?[][:0]const u8,
            spawn_flags: GSpawnFlags,
            child_setup_func: ?GSpawnChildSetupFunc,
            timeout: c_int,
            cancellable: ?*GCancellable,
            ) void {
        vte_terminal_spawn_async(
            self.ptr,
            flags,
            wkgdir.?,
            @ptrCast([*c][*c]gchar, &([2][*c]gchar{
                g_strdup(command),
                null,
            })),
            if (env) |e| @ptrCast([*c][*c]u8, e) else null,
            spawn_flags,
            child_setup_func.?,
            @intToPtr(?*c_void, @as(c_int, 0)),
            null,
            timeout,
            cancellable.?,
            null,
            @intToPtr(?*c_void, @as(c_int, 0)),
        );
    }

    pub fn set_default_colors(self: Terminal) void {
        vte_terminal_set_default_colors(self.ptr);
    }

    pub fn set_color_foreground(self: Terminal, color: *GdkRGBA) void {
        vte_terminal_set_color_foreground(self.ptr, color);
    }

    pub fn set_color_background(self: Terminal, color: *GdkRGBA) void {
        vte_terminal_set_color_background(self.ptr, color);
    }

    pub fn set_color_cursor(self: Terminal, color: *GdkRGBA) void {
        vte_terminal_set_color_cursor(self.ptr, color);
    }

    pub fn set_color_cursor_foreground(self: Terminal, color: *GdkRGBA) void {
        vte_termina_set_color_cursor_foreground(self.ptr, color);
    }

    pub fn set_color_highlight(self: Terminal, color: *GdkRGBA) void {
        vte_terminal_set_color_highlight(self.ptr, color);
    }

    pub fn set_color_highlight_foreground(self: Terminal, color: *GdkRGBA) void {
        vte_terminal_set_color_highlight_foreground(self.ptr, color);
    }

    pub fn get_cursor_shape(self: Terminal) CursorShape {
        const shape = vte_terminal_get_cursor_shape(self.ptr);
        switch (shape) {
            cursor_shape_block => return CursorShape.block,
            cursor_shape_ibeam => return CursorShape.ibeam,
            cursor_shape_underline => return CursorShape.underline,
            else => unreachable,
        }
    }

    pub fn set_cursor_shape(self: Terminal, shape: CursorShape) void {
        vte_terminal_set_cursor_shape(self.ptr, shape.parse());
    }

    pub fn get_cursor_blink_mode(self: Terminal) CursorBlinkMode {
        const mode = vte_terminal_get_cursor_blink_mode(self.ptr);
        switch (mode) {
            cursor_blink_system => return CursorBlinkMode.system,
            cursor_blink_on => return CursorBlinkMode.on,
            cursor_blink_off => return CursorBlinkMode.off,
        }
    }

    pub fn set_cursor_blink_mode(self: Terrminal, mode: CursorBlinkMode) void {
        vte_terminal_set_cursor_blink_mode(self.ptr, mode.parse());
    }

    pub fn as_widget(self: Terminal) Widget {
        return Widget {
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn from_widget(widget: Widget) ?Terminal {
        return Terminal {
            .ptr = @ptrCast(*VteTerminal, widget.ptr),
        };
    }
};
