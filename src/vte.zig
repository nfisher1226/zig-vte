const c = @import("cimport.zig");
const enums = @import("enums.zig");
const Widget = @import("widget.zig").Widget;
const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;

pub const Terminal = struct {
    ptr: *c.VteTerminal,

    const Self = @This();

    pub const CursorPosition = struct {
        x: c_long,
        y: c_long,
    };

    /// An enumeration type that can be used to specify how the terminal uses extra
    /// allocated space.
    pub const Align = enum(c_uint) {
        /// align to left/top
        start = c.VTE_ALIGN_START,
        /// align to centre
        center = c.VTE_ALIGN_CENTER,
        /// align to right/bottom
        end = c.VTE_ALIGN_END,
    };

    /// An enumerated type which can be used to indicate the cursor blink mode for
    /// the terminal.
    pub const CursorBlinkMode = enum(c_uint) {
        /// Follow GTK+ settings for cursor blinking.
        system = c.VTE_CURSOR_BLINK_SYSTEM,
        /// Cursor blinks.
        on = c.VTE_CURSOR_BLINK_ON,
        /// Cursor does not blink.
        off = c.VTE_CURSOR_BLINK_OFF,
    };

    /// An enumerated type which can be used to indicate what should the terminal
    /// draw at the cursor position.
    pub const CursorShape = enum(c_uint) {
        /// Draw a block cursor. This is the default.
        block = c.VTE_CURSOR_SHAPE_BLOCK,
        /// Draw a vertical bar on the left side of character. This is similar to
        /// the default cursor for other GTK+ widgets.
        ibeam = c.VTE_CURSOR_SHAPE_IBEAM,
        /// Draw a horizontal bar below the character.
        underline = c.VTE_CURSOR_SHAPE_UNDERLINE,
    };

    /// An enumerated type which can be used to indicate which string the terminal
    /// should send to an application when the user presses the Delete or Backspace
    /// keys.
    pub const EraseBinding = enum(c_uint) {
        /// For backspace, attempt to determine the right value from the terminal's
        /// IO settings. For delete, use the control sequence.
        auto = c.VTE_ERASE_AUTO,
        /// Send an ASCII backspace character (0x08).
        ascii_backspace = c.VTE_ERASE_ASCII_BACKSPACE,
        /// Send an ASCII delete character (0x7F).
        ascii_delete = c.VTE_ERASE_ASCII_DELETE,
        /// Send the "@7 " control sequence.
        delete_sequence = c.VTE_ERASE_DELETE_SEQUENCE,
        /// Send terminal's "erase" setting.
        tty = c.VTE_ERRASE_TTY,
    };

    /// An enumerated type which can be used to indicate whether the terminal allows
    /// the text contents to be blinked.
    pub const TextBlinkMode = enum(c_uint) {
        /// Do not blink the text.
        never = c.VTE_TEXT_BLINK_NEVER,
        /// Allow blinking text only if the terminal is focused.
        focused = c.VTE_TEXT_BLINK_FOCUSED,
        /// Allow blinking text only if the terminal is unfocused.
        unfocused = c.VTE_TEXT_BLINK_UNFOCUSED,
        /// Allow blinking text. This is the default.
        always = c.VTE_TEXT_BLINK_ALWAYS,
    };

    /// An enumeration type that can be used to specify the format the selection
    /// should be copied to the clipboard in.
    pub const Format = enum(c_uint) {
        /// Export as plain text
        text = c.VTE_FORMAT_TEXT,
        /// Export as HTML formatted text
        html = c.VTE_FORMAT_HTML,
    };

    /// A flag type to determine how terminal contents should be written to an
    /// output stream.
    pub const WriteFlags = enum(c_uint) {
        default = c.VTE_WRITE_DEFAULT,
    };

    /// An enumeration type for features.
    pub const FeatureFlags = enum(c_uint) {
        /// whether VTE was built with bidirectional text support
        bidi = c.VTE_FEATURE_FLAG_BIDI,
        /// whether VTE was built with ICU support
        icu = c.VTE_FEATURE_FLAG_ICU,
        /// whether VTE was built with systemd support
        systemd = c.VTE_FEATURE_FLAG_SYSTEMD,
        /// whether VTE was built with SIXEL support
        sixel = c.VTE_FEATURE_FLAG_SIXEL,
        /// mask of all feature flags
        mask = c.VTE_FEATURE_FLAGS_MASK,
    };

    /// Creates a new terminal widget.
    pub fn new() Self {
        return Self{
            .ptr = @ptrCast(*c.VteTerminal, c.vte_terminal_new()),
        };
    }

    /// Interprets data as if it were data received from a child process.
    pub fn feed(self: Self, data: [:0]const u8, length: c_long) void {
        c.vte_terminal_feed(self.ptr, data, length);
    }

    /// Sends a block of UTF-8 text to the child as if it were entered by the
    /// user at the keyboard.
    pub fn feed_child(self: Self, text: [:0]const u8, length: c_long) void {
        c.vte_terminal_feed_child(self.ptr, text, length);
    }

    /// Selects all text within the terminal (not including the scrollback
    /// buffer).
    pub fn select_all(self: Self) void {
        c.vte_terminal_select_all(self.ptr);
    }

    /// Clears the current selection.
    pub fn unselect_all(self: Self) void {
        c.vte_terminal_unselect_all(self.ptr);
    }

    /// Places the selected text in the terminal in the GDK_SELECTION_CLIPBOARD
    /// selection in the form specified by format.
    ///
    /// For all formats, the selection data (see GtkSelectionData) will include
    /// the text targets (see gtk_target_list_add_text_targets() and
    /// gtk_selection_data_targets_includes_text()). For *html*, the selection
    /// will also include the "text/html" target, which when requested, returns
    /// the HTML data in UTF-16 with a U+FEFF BYTE ORDER MARK character at the
    /// start.
    pub fn copy_clipboard_format(self: Self, format: Format) void {
        c.vte_terminal_copy_clipboard_format(self.ptr, @enumToInt(format));
    }

    /// Sends the contents of the GDK_SELECTION_CLIPBOARD selection to the
    /// terminal's child. It's called on paste menu item, or when user presses
    /// Shift+Insert.
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
        c.vte_terminal_set_text_blink_mode(self.ptr, @enumToInt(mode));
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
        c.vte_terminal_set_cursor_shape(self.ptr, @enumToInt(shape));
    }

    pub fn get_cursor_blink_mode(self: Terminal) CursorBlinkMode {
        const mode = c.vte_terminal_get_cursor_blink_mode(self.ptr);
        return CursorBlinkMode.from_c(mode);
    }

    pub fn set_cursor_blink_mode(self: Terminal, mode: CursorBlinkMode) void {
        c.vte_terminal_set_cursor_blink_mode(self.ptr, @enumToInt(mode));
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
        c.vte_terminal_set_backspace_binding(self.ptr, @enumToInt(binding));
    }

    pub fn set_delete_binding(self: Self, binding: EraseBinding) void {
        c.vte_terminal_set_delete_binding(self.ptr, @enumToInt(binding));
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
            @enumToInt(flags),
            if (wkgdir) |d| d else null,
            @ptrCast([*c][*c]c.gchar, &([2][*c]c.gchar{
                c.g_strdup(command),
                null,
            })),
            if (env) |e| @ptrCast([*c][*c]u8, e) else null,
            @enumToInt(spawn_flags),
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
        c.vte_terminal_set_clear_background(self.ptr, if (clear) 1 else 0);
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

    pub fn connect_bell(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("bell", callback, if (data) |d| d else null);
    }

    pub fn connect_char_size_changed(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("char-size-changed", callback, if (data) |d| d else null);
    }

    pub fn connect_child_exited(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("child_exited", callback, if (data) |d| d else null);
    }

    pub fn connect_commit(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("commit", callback, if (data) |d| d else null);
    }

    pub fn connect_contents_changed(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("contents-changed", callback, if (data) |d| d else null);
    }

    pub fn connect_copy_clipboard(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("copy-clipboard", callback, if (data) |d| d else null);
    }

    pub fn connect_current_directory_uri_changed(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("current-directory-uri-changed", callback, if (data) |d| d else null);
    }

    pub fn connect_current_file_uri_changed(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("current-file-uri-changed", callback, if (data) |d| d else null);
    }

    pub fn connect_cursor_moved(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("cursor-moved", callback, if (data) |d| d else null);
    }

    pub fn connect_decrease_font_size(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("decreas-font-size", callback, if (data) |d| d else null);
    }

    pub fn connect_encoding_changed(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("encoding-changed", callback, if (data) |d| d else null);
    }

    pub fn connect_eof(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("eof", callback, if (data) |d| d else null);
    }

    pub fn connect_hyperlink_hover_uri_changedl(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("hyperlink-hover-usi-changed", callback, if (data) |d| d else null);
    }

    pub fn connect_increas_font_size(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("increase-font-size", callback, if (data) |d| d else null);
    }

    pub fn connect_paste_clipboard(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("paste-clipboard", callback, if (data) |d| d else null);
    }

    pub fn connect_resize_window(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("resize-window", callback, if (data) |d| d else null);
    }

    pub fn connect_selection_changed(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("selection-changed", callback, if (data) |d| d else null);
    }

    pub fn connect_window_title_changed(self: Terminal, callback: c.GCallback, data: ?c.gpointer) void {
        self.as_widget().connect("window-title-changed", callback, if (data) |d| d else null);
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

/// PtyFlags enum
pub const PtyFlags = enum(c_uint) {
    no_lastlog = c.VTE_PTY_NO_LASTLOG,
    no_utmp = c.VTE_PTY_NO_UTMP,
    no_wtmp = c.VTE_PTY_NO_WTMP,
    no_helper = c.VTE_PTY_NO_HELPER,
    no_fallback = c.VTE_PTY_NO_FALLBACK,
    default = c.VTE_PTY_DEFAULT,
};
