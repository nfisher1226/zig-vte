usingnamespace @import("cimport.zig");
usingnamespace @import("enums.zig");
usingnamespace @import("widget.zig");
const std = @import("std");

/// PtyFlags enum
pub const PtyFlags = enum {
    no_lastlog,
    no_utmp,
    no_wtmp,
    no_helper,
    no_fallback,
    default,

    pub fn parse(self: PtyFlags) VtePtyFlags {
        return switch (self) {
            .no_lastlog => VTE_PTY_NO_LASTLOG,
            .no_utmp => VTE_PTY_NO_UTMP,
            .no_wtmp => VTE_PTY_NO_WTMP,
            .no_helper => VTE_PTY_NO_HELPER,
            .no_fallback => VTE_PTY_NO_FALLBACK,
            .default => VTE_PTY_DEFAULT,
        };
    }

    pub fn from_c(flags: VtePtyFlags) PtyFlags {
        return switch (flags) {
            VTE_PTY_NO_LASTLOG => .no_lastlog,
            VTE_PTY_NO_UTMP => .no_utmp,
            VTE_PTY_NO_WTMP => .no_wtmp,
            VTE_PTY_NO_HELPER => .no_helper,
            VTE_PTY_NO_FALLBACK => .no_fallback,
            VTE_PTY_DEFAULT => .default,
        };
    }
};

/// Zig enum CursorBlinkMode
pub const CursorBlinkMode = enum {
    system,
    on,
    off,

    pub fn parse(self: CursorBlinkMode) VteCursorBlinkMode {
        return switch (self) {
            .system => VTE_CURSOR_BLINK_SYSTEM,
            .on => VTE_CURSOR_BLINK_ON,
            .off => VTE_CURSOR_BLINK_OFF,
        };
    }

    pub fn from_c(mode: VteCursorBlinkMode) CursorBlinkMode {
        return switch (mode) {
            VTE_CURSOR_BLINK_SYSTEM => .system,
            VTE_CURSOR_BLINK_ON => .on,
            VTE_CURSOR_BLINK_OFF => .off,
        };
    }
};

/// Zig enum CursorShape
pub const CursorShape = enum {
    block,
    ibeam,
    underline,

    pub fn parse(self: CursorShape) VteCursorShape {
        return switch (self) {
            .block => VTE_CURSOR_SHAPE_BLOCK,
            .ibeam => VTE_CURSOR_SHAPE_IBEAM,
            .underline => VTE_CURSOR_SHAPE_UNDERLINE,
        };
    }

    pub fn from_c(shape: VteCursorShape) CursorShape {
        return switch (shape) {
            VTE_CURSOR_SHAPE_BLOCK => .block,
            VTE_CURSOR_SHAPE_IBEAM => .ibeam,
            VTE_CURSOR_SHAPE_UNDERLINE => .underline,
        };
    }
};

pub const Terminal = struct {
    ptr: *VteTerminal,

    pub fn new() Terminal {
        return Terminal{
            .ptr = @ptrCast(*VteTerminal, vte_terminal_new()),
        };
    }

    pub fn spawn_async(
        self: Terminal,
        flags: PtyFlags,
        wkgdir: ?[:0]const u8,
        command: [:0]const u8,
        env: ?[][:0]const u8,
        spawn_flags: SpawnFlags,
        child_setup_func: ?GSpawnChildSetupFunc,
        timeout: c_int,
        cancellable: ?*GCancellable,
    ) void {
        vte_terminal_spawn_async(
            self.ptr,
            flags.parse(),
            if (wkgdir) |d| d else null,
            @ptrCast([*c][*c]gchar, &([2][*c]gchar{
                g_strdup(command),
                null,
            })),
            if (env) |e| @ptrCast([*c][*c]u8, e) else null,
            spawn_flags.parse(),
            if (child_setup_func) |f| f else null,
            @intToPtr(?*c_void, @as(c_int, 0)),
            null,
            timeout,
            if (cancellable) |cn| cn else null,
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
        return CursorShape.from_c(shape);
    }

    pub fn set_cursor_shape(self: Terminal, shape: CursorShape) void {
        vte_terminal_set_cursor_shape(self.ptr, shape.parse());
    }

    pub fn get_cursor_blink_mode(self: Terminal) CursorBlinkMode {
        const mode = vte_terminal_get_cursor_blink_mode(self.ptr);
        return CursorBlinkMode.from_c(mode);
    }

    pub fn set_cursor_blink_mode(self: Terrminal, mode: CursorBlinkMode) void {
        vte_terminal_set_cursor_blink_mode(self.ptr, mode.parse());
    }

    pub fn copy_primary(self: Terminal) void {
        vte_terminal_copy_primary(self.ptr);
    }

    pub fn paste_primary(self: Terminal) void {
        vte_terminal_paste_primary(self.ptr);
    }

    pub fn connect_child_exited(self: Terminal, callback: GCallback, data: ?gpointer) void {
        self.as_widget().connect("child_exited", callback, if (data) |d| d else null);
    }

    pub fn as_widget(self: Terminal) Widget {
        return Widget{
            .ptr = @ptrCast(*GtkWidget, self.ptr),
        };
    }

    pub fn from_widget(widget: Widget) ?Terminal {
        return Terminal{
            .ptr = @ptrCast(*VteTerminal, widget.ptr),
        };
    }
};
