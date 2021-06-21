usingnamespace @import("zig-vte");
const std = @import("std");

const Gui = struct {
    window: gtk.Window,
    term: vte.Terminal,

    fn init(app: *c.GtkApplication) Gui {
        return Gui {
            .window = gtk.ApplicationWindow.new(app).as_window(),
            .term = vte.Terminal.new(),
        };
    }

    fn setup(self: Gui) void {
        self.window.set_title("Simple Terminal");
        self.window.as_container().add(self.term.as_widget());
        c.vte_terminal_spawn_async(
            self.term.ptr,
            vte.pty_default,
            null,
            @ptrCast([*c][*c]c.gchar, &([2][*c]c.gchar{
                c.g_strdup("/bin/sh"),
                null,
            })),
            null,
            gtk.g_spawn_default,
            null,
            @intToPtr(?*c_void, @as(c_int, 0)),
            null,
            -1,
            null,
            null,
            @intToPtr(?*c_void, @as(c_int, 0)),
        );
        //self.term.spawn_async(vte.pty_default, null, "/bin/sh", null, gtk.g_spawn_default, null, -1, null);
    }
};

pub fn main() void {
    const app = c.gtk_application_new("org.vte.example", .G_APPLICATION_FLAGS_NONE) orelse @panic("null app :(");
    defer c.g_object_unref(app);

    // Call the C function directly to connect our "activate" signal
    _ = c.g_signal_connect_data(
        app,
        "activate",
        @ptrCast(c.GCallback, activate),
        null,
        null,
        gtk.connect_after,
    );
    _ = c.g_application_run(@ptrCast(*c.GApplication, app), 0, null);
}

fn activate(app: *c.GtkApplication, data: c.gpointer) void {
    // Create an ApplicationWindow using our *GtkApplication pointer, which we then use as a window
    // in order to inherit the Window methods
    const gui = Gui.init(app);
    gui.setup();
    // show_all() is a Widget method
    gui.window.as_widget().show_all();
}
