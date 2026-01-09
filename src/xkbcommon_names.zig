pub const mod = struct {
    pub const shift = "Shift";
    pub const caps = "Lock";
    pub const ctrl = "Control";
    pub const mod1 = "Mod1";
    pub const mod2 = "Mod2";
    pub const mod3 = "Mod3";
    pub const mod4 = "Mod4";
    pub const mod5 = "Mod5";

    /// Deprecated
    pub const alt = "Mod1";
    /// Deprecated
    pub const num = "Mod2";
    /// Deprecated
    pub const logo = "Mod4";
};

pub const vmod = struct {
    pub const alt = "Alt";
    pub const hyper = "Hyper";
    pub const level3 = "LevelThree";
    pub const level5 = "LevelFive";
    pub const meta = "Meta";
    pub const num = "NumLock";
    pub const scroll = "ScrollLock";
    pub const super = "Super";
};

pub const led = struct {
    pub const caps = "Caps Lock";
    pub const num = "Num Lock";
    pub const scroll = "Scroll Lock";
};
