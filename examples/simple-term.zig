const GTK = @import("gtk");
const c = GTK.c;
const gtk = GTK.gtk;
const vte = GTK.vte;
const std = @import("std");

var gui: Gui = undefined;

const Gui = struct {
    window: gtk.Window,
    term: vte.Terminal,

    fn init(app: *c.GtkApplication) Gui {
        return Gui{
            .window = gtk.ApplicationWindow.new(app).as_window(),
            .term = vte.Terminal.new(),
        };
    }

    fn setup(self: Gui) void {
        self.window.set_title("Simple Terminal");
        self.window.as_container().add(self.term.as_widget());
        self.term.spawn_async(.default, null, "/bin/sh", null, .default, null, -1, null);
        self.term.connect_child_exited(@ptrCast(c.GCallback, &close_callback), null);
    }
};

pub fn main() void {
    const app = c.gtk_application_new("org.vte.example", c.G_APPLICATION_FLAGS_NONE) orelse @panic("null app :(");
    defer c.g_object_unref(app);

    // Call the C function directly to connect our "activate" signal
    _ = c.g_signal_connect_data(
        app,
        "activate",
        @ptrCast(c.GCallback, &activate),
        null,
        null,
        c.G_CONNECT_AFTER,
    );
    _ = c.g_application_run(@ptrCast(*c.GApplication, app), 0, null);
}

fn activate(app: *c.GtkApplication, data: c.gpointer) void {
    // Create an ApplicationWindow using our *GtkApplication pointer, which we then use as a window
    // in order to inherit the Window methods
    gui = Gui.init(app);
    gui.setup();
    // show_all() is a Widget method
    gui.window.as_widget().show_all();
    _ = data;
}

fn close_callback(term: *c.VteTerminal, data: c.gpointer) void {
    gui.term.as_widget().destroy();
    gui.window.as_widget().destroy();
    _ = data;
    _ = term;
}
