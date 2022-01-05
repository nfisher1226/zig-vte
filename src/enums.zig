const c = @import("cimport.zig");

/// Enum AccelFlags
pub const AccelFlags = enum {
    visible,
    locked,
    mask,

    pub fn parse(self: AccelFlags) c.GtkAccelFlags {
        return switch (self) {
            .visible => c.GTK_ACCEL_VISIBLE,
            .locked => c.GTK_ACCEL_LOCKED,
            .mask => c.GTK_ACCEL_MASK,
        };
    }
};

/// enum ConnectFlags
pub const ConnectFlags = enum {
    after,
    swapped,

    pub fn parse(self: ConnectFlags) c.GConnectFlags {
        return switch (self) {
            .after => c.G_CONNECT_AFTER,
            .swapped => c.G_CONNECT_SWAPPED,
        };
    }
};

/// enum BaselinePosition
pub const BaselinePosition = enum {
    top,
    center,
    bottom,

    pub fn parse(self: BaselinePosition) c.GtkBaselinePosition {
        return switch (self) {
            .top => c.GTK_BASELINE_POSITION_TOP,
            .center => c.GTK_BASELINE_POSITION_CENTER,
            .bottom => c.GTK_BASELINE_POSITION_BOTTOM,
        };
    }
};

/// enum DeleteType
pub const DeleteType = enum {
    chars,
    word_ends,
    words,
    line_ends,
    lines,
    paragraph_ends,
    paragraphs,
    whitespace,

    pub fn parse(self: DeleteType) c.GtkDeleteType {
        return switch (self) {
            .chars => c.GTK_DELETE_CHARS,
            .word_ends => c.GTK_DELETE_WORD_ENDS,
            .words => c.GTK_DELETE_WORDS,
            .line_ends => c.GTK_DELETE_LINE_ENDS,
            .lines => c.GTK_DELETE_LINES,
            .paragraph_ends => c.GTK_DELETE_PARAGRAPH_ENDS,
            .paragraphs => c.GTK_DELETE_PARAGRAPHS,
            .whitespace => c.GTK_DELETE_WHITESPACE,
        };
    }
};

/// enum DirectionType
pub const DirectionType = enum {
    tab_forward,
    tab_backward,
    up,
    down,
    left,
    right,

    pub fn parse(self: DirectionType) c.GtkDirectionType {
        return switch (self) {
            .forward => c.GTK_DIR_TAB_FORWARD,
            .backward => c.GTK_DIR_TAB_BACKWARD,
            .up => c.GTK_DIR_UP,
            .down => c.GTK_DIR_DOWN,
            .left => c.GTK_DIR_LEFT,
            .right => c.GTK_DIR_RIGHT,
        };
    }
};

/// enum IconSize
pub const IconSize = enum {
    invalid,
    menu,
    small_toolbar,
    large_toolbar,
    button,
    dnd,
    dialog,

    /// Parses an IconSize into a GtkIconSize
    pub fn parse(self: IconSize) c.GtkIconSize {
        return switch (self) {
            .invalid => c.GTK_ICON_SIZE_INVALID,
            .menu => c.GTK_ICON_SIZE_MENU,
            .small_toolbar => c.GTK_ICON_SIZE_SMALL_TOOLBAR,
            .large_toolbar => c.GTK_ICON_SIZE_LARGE_TOOLBAR,
            .button => c.GTK_ICON_SIZE_BUTTON,
            .dnd => c.GTK_ICON_SIZE_DND,
            .dialog => c.GTK_ICON_SIZE_DIALOG,
        };
    }
};

/// Enum ModifierType
pub const ModifierType = enum {
    shift_mask,
    mod1_mask,
    control_mask,

    pub fn parse(self: ModifierType) c.GdkModifierType {
        return switch (self) {
            .shift_mask => c.GDK_SHIFT_MASK,
            .mod1_mask => c.GDK_MOD1_MASK,
            .control_mask => c.GDK_CONTROL_MASK,
        };
    }
};

/// enum Orientation
pub const Orientation = enum {
    horizontal,
    vertical,

    pub fn parse(self: Orientation) c.GtkOrientation {
        return switch (self) {
            .horizontal => c.GTK_ORIENTATION_HORIZONTAL,
            .vertical => c.GTK_ORIENTATION_VERTICAL,
        };
    }

};

/// Enum PackType
pub const PackType = enum {
    start,
    end,

    pub fn parse(self: PackType) c.GtkPackType {
        return switch (self) {
            .end => c.GTK_PACK_END,
            .start => c.GTK_PACK_START,
        };
    }
};

/// Enum PositionType
pub const PositionType = enum {
    left,
    right,
    top,
    bottom,

    pub fn parse(self: PositionType) c.GtkPositionType {
        return switch (self) {
            .left => c.GTK_POS_LEFT,
            .right => c.GTK_POS_RIGHT,
            .top => c.GTK_POS_TOP,
            .bottom => c.GTK_POS_BOTTOM,
        };
    }
};

/// Enum ReliefStyle
pub const ReliefStyle = enum {
    normal,
    none,

    pub fn parse(self: ReliefStyle) c.GtkReliefStyle {
        return switch (self) {
            .normal => c.GTK_RELIEF_NORMAL,
            .none => c.GTK_RELIEF_NONE,
        };
    }
};

/// enum SpawnFlags
pub const SpawnFlags = enum {
    default,
    leave_descriptors_open,
    do_not_reap_child,
    search_path,
    stdout_to_dev_null,
    stderr_to_dev_null,
    child_inherits_stdin,
    file_and_argv_zero,
    search_path_from_envp,
    cloexec_pipes,

    pub fn parse(self: SpawnFlags) c.GSpawnFlags {
        return switch (self) {
            .default => c.G_SPAWN_DEFAULT,
            .leave_descriptors_open => c.G_SPAWN_LEAVE_DESCRIPTORS_OPEN,
            .do_not_reap_child => c.G_SPAWN_DO_NOT_REAP_CHILD,
            .search_path => c.G_SPAWN_SEARCH_PATH,
            .stdout_to_dev_null => c.G_SPAWN_STDOUT_TO_DEV_NULL,
            .stderr_to_dev_null => c.G_SPAWN_STDERR_TO_DEV_NULL,
            .child_inherits_stdin => c.G_SPAWN_CHILD_INHERITS_STDIN,
            .file_and_argv_zero => c.G_SPAWN_FILE_AND_ARGV_ZERO,
            .search_path_from_envp => c.G_SPAWN_SEARCH_PATH_FROM_ENVP,
            .cloexec_pipes => c.G_SPAWN_CLOEXEC_PIPES,
        };
    }
};

/// Enum SpinButtonUpdatePolicy
pub const SpinButtonUpdatePolicy = enum {
    always,
    if_valid,

    const Self = @This();

    pub fn parse(self: Self) c.GtkSpinButtonUpdatePolicy {
        return switch (self) {
            .always => c.GTK_UPDATE_ALWAYS,
            .if_valid => c.GTK_UPDATE_IF_VALID,
        };
    }
};

/// Enum SpinType
pub const SpinType = enum {
    step_forward,
    step_backward,
    page_forward,
    page_backward,
    home,
    end,
    user_defined,

    const Self = @This();

    pub fn parse(self: Self) c.GtkSpinType {
        return switch (self) {
            .step_forward => c.GTK_SPIN_STEP_FORWARD,
            .step_backward => c.GTK_SPIN_STEP_BACKWARD,
            .page_forward => c.GTK_SPIN_PAGE_FORWARD,
            .page_backward => c.GTK_SPIN_PAGE_BACKWARD,
            .home => c.GTK_SPIN_HOME,
            .end => c.GTK_SPIN_END,
            .user_defined => c.GTK_SPIN_USER_DEFINED,
        };
    }
};

/// enum StackTransitionStyle
pub const StackTransitionStyle = enum {
    none,
    crossfade,
    slide_right,
    slide_left,
    slide_up,
    slide_down,
    slide_left_right,
    slide_up_down,
    over_up,
    over_down,
    over_left,
    over_right,
    under_up,
    under_down,
    under_left,
    under_right,
    over_up_down,
    over_down_up,
    over_left_right,
    over_right_left,

    const Self = @This();

    pub fn parse(self: Self) c.GtkStackTransitionStyle {
        return switch (self) {
            .none => c.GTK_STACK_TRANSITION_TYPE_NONE,
            .crossfade => c.GTK_STACK_TRANSITION_TYPE_CROSSFADE,
            .slide_right => c.GTK_STACK_TRANSITION_TYPE_RIGHT,
            .slide_left => c.GTK_STACK_TRANSITION_TYPE_LEFT,
            .slide_up => c.GTK_STACK_TRANSITION_TYPE_UP,
            .slide_down => c.GTK_STACK_TRANSITION_TYPE_DOWN,
            .slide_left_right => c.GTK_STACK_TRANSITION_TYPE_LEFT_RIGHT,
            .slide_up_down => c.GTK_STACK_TRANSITION_TYPE_UP_DOWN,
            .over_up => c.GTK_STACK_TRANSITION_TYPE_OVER_UP,
            .over_down => c.GTK_STACK_TRANSITION_TYPE_OVER_DOWN,
            .over_left => c.GTK_STACK_TRANSITION_TYPE_OVER_LEFT,
            .over_right => c.GTK_STACK_TRANSITION_TYPE_OVER_RIGHT,
            .under_up => c.GTK_STACK_TRANSITION_TYPE_UNDER_UP,
            .under_down => c.GTK_STACK_TRANSITION_TYPE_UNDER_DOWN,
            .under_left => c.GTK_STACK_TRANSITION_TYPE_UNDER_LEFT,
            .under_right => c.GTK_STACK_TRANSITION_TYPE_UNDER_RIGHT,
            .over_up_down => c.GTK_STACK_TRANSITION_TYPE_OVER_UP_DOWN,
            .over_down_up => c.GTK_STACK_TRANSITION_TYPE_OVER_DOWN_UP,
            .over_left_right => c.GTK_STACK_TRANSITION_TYPE_OVER_LEFT_RIGHT,
            .over_right_left => c.GTK_STACK_TRANSITION_TYPE_OVER_RIGHT_LEFT,
        };
    }
};

/// enum WindowType
pub const WindowType = enum {
    toplevel,
    popup,

    pub fn parse(self: WindowType) c.GtkWindowType {
        return switch (self) {
            .toplevel => c.GTK_WINDOW_TOPLEVEL,
            .popup => c.GTK_WINDOW_POPUP,
        };
    }
};
