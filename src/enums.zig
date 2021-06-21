usingnamespace @import("cimport.zig");

/// enum GConnectFlags
pub const connect_after = @intToEnum(GConnectFlags, G_CONNECT_AFTER);
pub const connect_swapped = @intToEnum(GConnectFlags, G_CONNECT_SWAPPED);

/// enum IconSize
pub const IconSize = enum {
    icon_size_invalid,
    icon_size_menu,
    icon_size_small_toolbar,
    icon_size_large_toolbar,
    icon_size_button,
    icon_size_dnd,
    icon_size_dialog,

    /// Parses an IconSize into a GtkIconSize
    pub fn parse(self: IconSize) GtkIconSize {
        switch (self) {
            .icon_size_invalid => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_INVALID),
            .icon_size_menu => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_MENU),
            .icon_size_small_toolbar => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_SMALL_TOOLBAR),
            .icon_size_large_toolbar => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_LARGE_TOOLBAR),
            .icon_size_button => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_BUTTON),
            .icon_size_dnd => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_DND),
            .icon_size_dialog => return @intToEnum(GtkIconSize, GTK_ICON_SIZE_DIALOG),
        }
    }
};

/// Gtk enum GtkIconSize
pub const icon_size_invalid = @intToEnum(GtkIconSize, GTK_ICON_SIZE_INVALID);
pub const icon_size_menu = @intToEnum(GtkIconSize, GTK_ICON_SIZE_MENU);
pub const icon_size_small_toolbar = @intToEnum(GtkIconSize, GTK_ICON_SIZE_SMALL_TOOLBAR);
pub const icon_size_large_toolbar = @intToEnum(GtkIconSize, GTK_ICON_SIZE_LARGE_TOOLBAR);
pub const icon_size_button = @intToEnum(GtkIconSize, GTK_ICON_SIZE_BUTTON);
pub const icon_size_dnd = @intToEnum(GtkIconSize, GTK_ICON_SIZE_DND);
pub const icon_size_dialog = @intToEnum(GtkIconSize, GTK_ICON_SIZE_DIALOG);

/// enum GtkBaselinePosition
pub const baseline_position_top = @intToEnum(GtkBaselinePosition, GTK_BASELINE_POSITION_TOP);
pub const baseline_position_center = @intToEnum(GtkBaselinePosition, GTK_BASELINE_POSITION_CENTER);
pub const baseline_position_bottom = @intToEnum(GtkBaselinePosition, GTK_BASELINE_POSITION_BOTTOM);

/// enum GtkDeleteType
pub const gtk_delete_chars = @intToEnum(GtkDeleteType, GTK_DELETE_CHARS);
pub const gtk_delete_word_ends = @intToEnum(GtkDeleteType, GTK_DELETE_WORD_ENDS);
pub const gtk_delete_words = @intToEnum(GtkDeleteType, GTK_DELETE_WORDS);
pub const gtk_delete_line_ends = @intToEnum(GtkDeleteType, GTK_DELETE_LINE_ENDS);
pub const gtk_delete_lines = @intToEnum(GtkDeleteType, GTK_DELETE_LINES);
pub const gtk_delete_paragraph_ends = @intToEnum(GtkDeleteType, GTK_DELETE_PARAGRAPH_ENDS);
pub const gtk_delete_paragraphs = @intToEnum(GtkDeleteType, GTK_DELETE_PARAGRAPHS);
pub const gtk_delete_whitespace = @intToEnum(GtkDeleteType, GTK_DELETE_WHITESPACE);

/// enum GtkDirectionType
pub const dir_tab_forward = @intToEnum(GtkDirectionType, GTK_DIR_TAB_FORWARD);
pub const dir_tab_backward = @intToEnum(GtkDirectionType, GTK_DIR_TAB_BACKWARD);
pub const dir_up = @intToEnum(GtkDirectionType, GTK_DIR_UP);
pub const dir_down = @intToEnum(GtkDirectionType, GTK_DIR_DOWN);
pub const dir_left = @intToEnum(GtkDirectionType, GTK_DIR_LEFT);
pub const dir_right = @intToEnum(GtkDirectionType, GTK_DIR_RIGHT);

/// enum GtkOrientation
pub const orientation_horizontal = @intToEnum(GtkOrientation, GTK_ORIENTATION_HORIZONTAL);
pub const orientation_vertical = @intToEnum(GtkOrientation, GTK_ORIENTATION_VERTICAL);

pub const Orientation = enum {
    horizontal,
    vertical,

    pub fn parse(self: Orientation) GtkOrientation {
        switch (self) {
            .horizontal => return orientation_horizontal,
            .vertical => return orientation_vertical,
        }
    }

};

///enum GtkWindowType
pub const window_toplevel = @intToEnum(GtkWindowType, GTK_WINDOW_TOPLEVEL);
pub const window_popup = @intToEnum(GtkWindowType, GTK_WINDOW_POPUP);

pub const WindowType = enum {
    toplevel,
    popup,

    pub fn parse(self: WindowType) GtkWindowType {
        switch (self) {
            .toplevel => return window_toplevel,
            .popup => return window_popup,
        }
    }
};

/// Enum GtkPackType
pub const pack_end = @intToEnum(GtkPackType, GTK_PACK_END);
pub const pack_start = @intToEnum(GtkPackType, GTK_PACK_START);

/// Enum GtkPositionType
pub const pos_left = @intToEnum(GtkPositionType, GTK_POS_LEFT);
pub const pos_right = @intToEnum(GtkPositionType, GTK_POS_RIGHT);
pub const pos_top = @intToEnum(GtkPositionType, GTK_POS_TOP);
pub const pos_bottom = @intToEnum(GtkPositionType, GTK_POS_BOTTOM);

pub const PositionType = enum {
    pos_left,
    pos_right,
    pos_top,
    pos_bottom,

    pub fn parse(self: PositionType) GtkPositionType {
        switch (self) {
            .pos_left => return pos_left,
            .pos_right => return pos_right,
            .pos_top => return pos_top,
            .pos_bottom => return pos_bottom,
        }
    }
};

/// Enum GtkReliefStyle
pub const relief_normal = @intToEnum(GtkReliefStyle, GTK_RELIEF_NORMAL);
pub const relief_none = @intToEnum(GtkReliefStyle, GTK_RELIEF_NONE);

pub const ReliefStyle = enum {
    normal,
    none,

    pub fn parse(self: ReliefStyle) GtkReliefStyle {
        switch (self) {
            .normal => return relief_normal,
            .none => return relief_none,
        }
    }
};

/// Enum GdkModifierType
pub const shift_mask = @intToEnum(GdkModifierType, GDK_SHIFT_MASK);
/// Mod1 generally maps to Alt key
pub const mod1_mask = @intToEnum(GdkModifierType, GDK_MOD1_MASK);
pub const ctrl_mask = @intToEnum(GdkModifierType, GDK_CONTROL_MASK);

pub const ModifierType = enum {
    shift_mask,
    mod1_mask,
    ctrl_mask,

    pub fn parse(self: ModifierType) GdkModifierType {
        switch (self) {
            .shift_mask => return shift_mask,
            .mod1_mask => return mod1_mask,
            .ctrl_mask => return ctrl_mask,
        }
    }
};

/// Enum GtkAccelFlags
pub const accel_locked = @intToEnum(GtkAccelFlags, GTK_ACCEL_LOCKED);

/// enum GSpawnFlags
pub const g_spawn_default = @intToEnum(GSpawnFlags, G_SPAWN_DEFAULT);
pub const g_spawn_leave_descriptors_open = @intToEnum(GSpawnFlags, G_SPAWN_LEAVE_DESCRIPTORS_OPEN);
pub const g_spawn_do_no_reap_child = @intToEnum(GSpawnFlags, G_SPAWN_DO_NO_REAP_CHILD);
pub const g_spawn_search_path = @intToEnum(GSpawnFlags, G_SPAWN_SEARCH_PATH);
pub const g_spawn_stdout_to_dev_null = @intToEnum(GSpawnFlags, G_SPAWN_STDOUT_TO_DEV_NULL);
pub const g_spawn_stderr_to_dev_null = @intToEnum(GSpawnFlags, G_SPAWN_STDERR_TO_DEV_NULL);
pub const g_spawn_child_inherits_stdin = @intToEnum(GSpawnFlags, G_SPAWN_CHILD_INHERITS_STDIN);
pub const g_spawn_file_and_argv_zero = @intToEnum(GSpawnFlags, G_SPAWN_FILE_AND_ARGV_ZERO);
pub const g_spawn_search_path_from_envp = @intToEnum(GSpawnFlags, G_SPAWN_SEARCH_PATH_FROM_ENVP);
pub const g_spawn_cloexec_pipes = @intToEnum(GSpawnFlags, G_SPAWN_CLOEXEC_PIPES);
