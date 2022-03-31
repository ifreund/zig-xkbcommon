pub const names = @import("xkbcommon_names.zig");

pub const Keycode = u32;

pub const Keysym = @import("xkbcommon_keysyms.zig").Keysym;

pub const KeyDirection = enum(c_int) {
    up,
    down,
};

pub const LayoutIndex = u32;
pub const LayoutMask = u32;

pub const LevelIndex = u32;

pub const ModIndex = u32;
pub const ModMask = u32;

pub const LED_Index = u32;
pub const LED_Mask = u32;

pub const keycode_invalid = 0xffff_ffff;
pub const layout_invalid = 0xffff_ffff;
pub const level_invalid = 0xffff_ffff;
pub const mod_invalid = 0xffff_ffff;
pub const led_invalid = 0xffff_ffff;

pub const keycode_max = 0xffff_ffff - 1;

pub const RuleNames = extern struct {
    rules: ?[*:0]const u8,
    model: ?[*:0]const u8,
    layout: ?[*:0]const u8,
    variant: ?[*:0]const u8,
    options: ?[*:0]const u8,
};

pub const LogLevel = enum(c_int) {
    crit = 10,
    err = 20,
    warn = 30,
    info = 40,
    debug = 50,
};

pub const Context = opaque {
    pub const Flags = enum(c_int) {
        no_flags = 0,
        no_default_includes = 1 << 0,
        no_environment_names = 1 << 1,
    };

    extern fn xkb_context_new(flags: Flags) ?*Context;
    pub const new = xkb_context_new;

    extern fn xkb_context_ref(context: *Context) *Context;
    pub const ref = xkb_context_ref;

    extern fn xkb_context_unref(context: *Context) void;
    pub const unref = xkb_context_unref;

    extern fn xkb_context_set_user_data(context: *Context, user_data: ?*anyopaque) void;
    pub const setUserData = xkb_context_set_user_data;

    extern fn xkb_context_get_user_data(context: *Context) ?*anyopaque;
    pub const getUserData = xkb_context_get_user_data;

    extern fn xkb_context_include_path_append(context: *Context, path: [*:0]const u8) c_int;
    pub const includePathAppend = xkb_context_include_path_append;

    extern fn xkb_context_include_path_append_default(context: *Context) c_int;
    pub const includePathAppendDefault = xkb_context_include_path_append_default;

    extern fn xkb_context_include_path_reset_defaults(context: *Context) c_int;
    pub const includePathResetDefaults = xkb_context_include_path_reset_defaults;

    extern fn xkb_context_include_path_clear(context: *Context) void;
    pub const includePathClear = xkb_context_include_path_clear;

    extern fn xkb_context_num_include_paths(context: *Context) c_uint;
    pub const numIncludePaths = xkb_context_num_include_paths;

    extern fn xkb_context_include_path_get(context: *Context, index: c_uint) ?[*:0]const u8;
    pub const includePathGet = xkb_context_include_path_get;

    extern fn xkb_context_set_log_level(context: *Context, level: LogLevel) void;
    pub const setLogLevel = xkb_context_set_log_level;

    extern fn xkb_context_get_log_level(context: *Context) LogLevel;
    pub const getLogLevel = xkb_context_get_log_level;

    extern fn xkb_context_set_log_verbosity(context: *Context, verbosity: c_int) void;
    pub const setLogVerbosity = xkb_context_set_log_verbosity;

    extern fn xkb_context_get_log_verbosity(context: *Context) c_int;
    pub const getLogVerbosity = xkb_context_get_log_verbosity;

    // TODO
    //extern fn xkb_context_set_log_fn(context: *Context, log_fn: ?fn (?*Context, enum_xkb_log_level, [*c]const u8, [*c]struct___va_list_tag) callconv(.C) void) void;
};

pub const Keymap = opaque {
    pub const CompileFlags = enum(c_int) {
        no_flags = 0,
    };

    pub const Format = enum(c_int) {
        text_v1 = 1,
    };

    extern fn xkb_keymap_new_from_names(context: *Context, names: ?*const RuleNames, flags: CompileFlags) ?*Keymap;
    pub const newFromNames = xkb_keymap_new_from_names;

    // TODO
    //extern fn xkb_keymap_new_from_file(context: *Context, file: *FILE, format: Format, flags: CompileFlags) ?*Keymap;
    //pub const newFromFile = xkb_keymap_new_from_file;

    extern fn xkb_keymap_new_from_string(context: *Context, string: [*:0]const u8, format: Format, flags: CompileFlags) ?*Keymap;
    pub const newFromString = xkb_keymap_new_from_string;

    extern fn xkb_keymap_new_from_buffer(context: *Context, buffer: [*]const u8, length: usize, format: Format, flags: CompileFlags) ?*Keymap;
    pub const newFromBuffer = xkb_keymap_new_from_buffer;

    extern fn xkb_keymap_ref(keymap: *Keymap) *Keymap;
    pub const ref = xkb_keymap_ref;

    extern fn xkb_keymap_unref(keymap: *Keymap) void;
    pub const unref = xkb_keymap_unref;

    extern fn xkb_keymap_get_as_string(keymap: *Keymap, format: Format) [*c]u8;
    pub const getAsString = xkb_keymap_get_as_string;

    extern fn xkb_keymap_min_keycode(keymap: *Keymap) Keycode;
    pub const minKeycode = xkb_keymap_min_keycode;

    extern fn xkb_keymap_max_keycode(keymap: *Keymap) Keycode;
    pub const maxKeycode = xkb_keymap_max_keycode;

    extern fn xkb_keymap_key_for_each(
        keymap: *Keymap,
        iter: fn (keymap: *Keymap, key: Keycode, data: ?*anyopaque) callconv(.C) void,
        data: ?*anyopaque,
    ) void;
    pub inline fn keyForEach(
        keymap: *Keymap,
        comptime T: type,
        iter: fn (keymap: *Keymap, key: Keycode, data: T) callconv(.C) void,
        data: T,
    ) void {
        xkb_keymap_key_for_each(
            keymap,
            // TODO Remove when the zig compiler gets smart enough to handle this coercion.
            @ptrCast(fn (keymap: *Keymap, key: Keycode, data: ?*anyopaque) callconv(.C) void, iter),
            data,
        );
    }

    extern fn xkb_keymap_key_get_name(keymap: *Keymap, key: Keycode) ?[*:0]const u8;
    pub const keyGetName = xkb_keymap_key_get_name;

    extern fn xkb_keymap_key_by_name(keymap: *Keymap, name: [*:0]const u8) Keycode;
    pub const keyByName = xkb_keymap_key_by_name;

    extern fn xkb_keymap_num_mods(keymap: *Keymap) ModIndex;
    pub const numMods = xkb_keymap_num_mods;

    extern fn xkb_keymap_mod_get_name(keymap: *Keymap, idx: ModIndex) ?[*:0]const u8;
    pub const modGetName = xkb_keymap_mod_get_name;

    extern fn xkb_keymap_mod_get_index(keymap: *Keymap, name: [*:0]const u8) ModIndex;
    pub const modGetIndex = xkb_keymap_mod_get_index;

    extern fn xkb_keymap_num_layouts(keymap: *Keymap) LayoutIndex;
    pub const numLayouts = xkb_keymap_num_layouts;

    extern fn xkb_keymap_layout_get_name(keymap: *Keymap, idx: LayoutIndex) ?[*:0]const u8;
    pub const layoutGetName = xkb_keymap_layout_get_name;

    extern fn xkb_keymap_layout_get_index(keymap: *Keymap, name: [*:0]const u8) LayoutIndex;
    pub const layoutGetIndex = xkb_keymap_layout_get_index;

    extern fn xkb_keymap_num_leds(keymap: *Keymap) LED_Index;
    pub const numLeds = xkb_keymap_num_leds;

    extern fn xkb_keymap_led_get_name(keymap: *Keymap, idx: LED_Index) ?[*:0]const u8;
    pub const ledGetName = xkb_keymap_led_get_name;

    extern fn xkb_keymap_led_get_index(keymap: *Keymap, name: [*:0]const u8) LED_Index;
    pub const ledGetIndex = xkb_keymap_led_get_index;

    extern fn xkb_keymap_num_layouts_for_key(keymap: *Keymap, key: Keycode) LayoutIndex;
    pub const numLayoutsForKey = xkb_keymap_num_layouts_for_key;

    extern fn xkb_keymap_num_levels_for_key(keymap: *Keymap, key: Keycode, layout: LayoutIndex) LevelIndex;
    pub const numLevelsForKey = xkb_keymap_num_levels_for_key;

    extern fn xkb_keymap_key_get_mods_for_level(keymap: *Keymap, key: Keycode, layout: LayoutIndex, level: LevelIndex, masks_out: [*]ModMask, masks_size: usize) usize;
    pub const keyGetModsForLevel = xkb_keymap_key_get_mods_for_level;

    extern fn xkb_keymap_key_get_syms_by_level(keymap: *Keymap, key: Keycode, layout: LayoutIndex, level: LevelIndex, syms_out: *?[*]const Keysym) c_int;
    pub fn keyGetSymsByLevel(keymap: *Keymap, key: Keycode, layout: LayoutIndex, level: LevelIndex) []const Keysym {
        var ptr: ?[*]const Keysym = undefined;
        const len = xkb_keymap_key_get_syms_by_level(keymap, key, layout, level, &ptr);
        return if (len == 0) &[0]Keysym{} else ptr.?[0..@intCast(usize, len)];
    }

    extern fn xkb_keymap_key_repeats(keymap: *Keymap, key: Keycode) c_int;
    pub const keyRepeats = xkb_keymap_key_repeats;
};

pub const ConsumedMode = enum(c_int) {
    xkb,
    gtk,
};

pub const State = opaque {
    pub const Component = enum(c_int) {
        _,
        pub const mods_depressed = 1 << 0;
        pub const mods_latched = 1 << 1;
        pub const mods_locked = 1 << 2;
        pub const mods_effective = 1 << 3;
        pub const layout_depressed = 1 << 4;
        pub const layout_latched = 1 << 5;
        pub const layout_locked = 1 << 6;
        pub const layout_effective = 1 << 7;
        pub const leds = 1 << 8;
    };

    pub const Match = enum(c_int) {
        _,
        pub const any = 1 << 0;
        pub const all = 1 << 1;
        pub const non_exclusive = 1 << 16;
    };

    extern fn xkb_state_new(keymap: *Keymap) ?*State;
    pub const new = xkb_state_new;

    extern fn xkb_state_ref(state: *State) *State;
    pub const ref = xkb_state_ref;

    extern fn xkb_state_unref(state: *State) void;
    pub const unref = xkb_state_unref;

    extern fn xkb_state_get_keymap(state: *State) *Keymap;
    pub const getKeymap = xkb_state_get_keymap;

    extern fn xkb_state_update_key(state: *State, key: Keycode, direction: KeyDirection) Component;
    pub const updateKey = xkb_state_update_key;

    extern fn xkb_state_update_mask(
        state: *State,
        depressed_mods: ModMask,
        latched_mods: ModMask,
        locked_mods: ModMask,
        depressed_layout: LayoutIndex,
        latched_layout: LayoutIndex,
        locked_layout: LayoutIndex,
    ) Component;
    pub const updateMask = xkb_state_update_mask;

    extern fn xkb_state_key_get_syms(state: *State, key: Keycode, syms_out: *?[*]const Keysym) c_int;
    pub fn keyGetSyms(state: *State, key: Keycode) []const Keysym {
        var ptr: ?[*]const Keysym = undefined;
        const len = xkb_state_key_get_syms(state, key, &ptr);
        return if (len == 0) &[0]Keysym{} else ptr.?[0..@intCast(usize, len)];
    }

    extern fn xkb_state_key_get_utf8(state: *State, key: Keycode, buffer: [*]u8, size: usize) c_int;
    pub const keyGetUtf8 = xkb_state_key_get_utf8;

    extern fn xkb_state_key_get_utf32(state: *State, key: Keycode) u32;
    pub const keyGetUtf32 = xkb_state_key_get_utf32;

    extern fn xkb_state_key_get_one_sym(state: *State, key: Keycode) Keysym;
    pub const keyGetOneSym = xkb_state_key_get_one_sym;

    extern fn xkb_state_key_get_layout(state: *State, key: Keycode) LayoutIndex;
    pub const keyGetLayout = xkb_state_key_get_layout;

    extern fn xkb_state_key_get_level(state: *State, key: Keycode, layout: LayoutIndex) LevelIndex;
    pub const keyGetLevel = xkb_state_key_get_level;

    extern fn xkb_state_serialize_mods(state: *State, components: Component) ModMask;
    pub const serializeMods = xkb_state_serialize_mods;

    extern fn xkb_state_serialize_layout(state: *State, components: Component) LayoutIndex;
    pub const serializeLayout = xkb_state_serialize_layout;

    extern fn xkb_state_mod_name_is_active(state: *State, name: [*:0]const u8, kind: Component) c_int;
    pub const modNameIsActive = xkb_state_mod_name_is_active;

    extern fn xkb_state_mod_names_are_active(state: *State, kind: Component, match: Match, ...) c_int;
    pub const modNamesAreActive = xkb_state_mod_names_are_active;

    extern fn xkb_state_mod_index_is_active(state: *State, idx: ModIndex, kind: Component) c_int;
    pub const modIndexIsActive = xkb_state_mod_index_is_active;

    extern fn xkb_state_mod_indices_are_active(state: *State, kind: Component, match: Match, ...) c_int;
    pub const modIndicesAreActive = xkb_state_mod_indices_are_active;

    extern fn xkb_state_key_get_consumed_mods2(state: *State, key: Keycode, mode: ConsumedMode) ModMask;
    pub const keyGetConsumedMods2 = xkb_state_key_get_consumed_mods2;

    extern fn xkb_state_key_get_consumed_mods(state: *State, key: Keycode) ModMask;
    pub const keyGetConsumedMods = xkb_state_key_get_consumed_mods;

    extern fn xkb_state_mod_index_is_consumed2(state: *State, key: Keycode, idx: ModIndex, mode: ConsumedMode) c_int;
    pub const modIndexIsConsumed2 = xkb_state_mod_index_is_consumed2;

    extern fn xkb_state_mod_index_is_consumed(state: *State, key: Keycode, idx: ModIndex) c_int;
    pub const modIndexIsConsumed = xkb_state_mod_index_is_consumed;

    extern fn xkb_state_mod_mask_remove_consumed(state: *State, key: Keycode, mask: ModMask) ModMask;
    pub const modMaskRemoveConsumed = xkb_state_mod_mask_remove_consumed;

    extern fn xkb_state_layout_name_is_active(state: *State, name: [*c]const u8, kind: Component) c_int;
    pub const layoutNameIsActive = xkb_state_layout_name_is_active;

    extern fn xkb_state_layout_index_is_active(state: *State, idx: LayoutIndex, kind: Component) c_int;
    pub const layoutIndexIsActive = xkb_state_layout_index_is_active;

    extern fn xkb_state_led_name_is_active(state: *State, name: [*c]const u8) c_int;
    pub const ledNameIsActive = xkb_state_led_name_is_active;

    extern fn xkb_state_led_index_is_active(state: *State, idx: LED_Index) c_int;
    pub const ledIndexIsActive = xkb_state_led_index_is_active;
};

fn refAllDeclsRecursive(comptime T: type) void {
    @setEvalBranchQuota(1000000);
    const decls = switch (@typeInfo(T)) {
        .Struct => |info| info.decls,
        .Union => |info| info.decls,
        .Enum => |info| info.decls,
        .Opaque => |info| info.decls,
        else => return,
    };
    inline for (decls) |decl| {
        switch (decl.data) {
            .Type => |T2| refAllDeclsRecursive(T2),
            else => _ = decl,
        }
    }
}

test "" {
    refAllDeclsRecursive(@This());
}
