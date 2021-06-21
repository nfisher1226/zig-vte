# zig-vte
This package contains some convenience functions and wrappers around the C api
of both the Gtk+ and Vte libraries for developing Gui applications using Zig.

## Usage
We track zig-master, so you will need the current master compiler. In your
```build.zig``` file, add the package path:
```Zig
    const exe = b.addExecutable("exe-name", "path-to-source.zig");
    exe.addPackagePath("zig-vte", "path/to/zig-vte/lib.zig");
    exe.linkLibC();
    exe.linkSystemLibrary("gtk+-3.0");
    exe.linkSystemLibrary("vte-2.91");
```
The Gtk wrappers are already namespaced to gtk, the C functions to c, and Vte to
vte, so it will be most convenient to import them into your code using the
```usingnamespace``` method.
```Zig
usingnamespace @import("zig-vte");
const std = @import("std");

const Gui = struct {
    window: gtk.Window,
    term: vte.Terminal,

    fn init(app: *c.GtkApplication) Gui {
...
```
There is a simple example application in the examples directory which can be built
by calling ```zig build```. Additional examples showing just the Gtk api are in
the [zig-gtk3](https://gitlab.com/jeang3nie/zig-gtk3/) repository.

## Rationale
It is entirely possible to call C functions directly from Zig. However, Zig's
translate-c function, which is used to import C code into Zig, is still somewhat
immature and tends to fail with heavily macro dependent code. This happens for
certain parts of Gtk+ that make working around it quite difficult.

Additionally, the C Api to Gtk (and Vte), due to limitations of the language, can
be incredibly verbose as well as quite clumsy at times. A better Api is both
possible and desireable in a language such as Zig.
