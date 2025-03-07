# zig-xkbcommon

[zig](https://ziglang.org/) 0.14 bindings for
[xkbcommon](https://xkbcommon.org) that are a little
nicer to use than the output of `zig translate-c`.

The main repository is on [codeberg](https://codeberg.org/ifreund/zig-xkbcommon),
which is where the issue tracker may be found and where contributions are accepted.

Read-only mirrors exist on [sourcehut](https://git.sr.ht/~ifreund/zig-xkbcommon)
and [github](https://github.com/ifreund/zig-xkbcommon).

## Versioning

For now, zig-xkbcommon versions are of the form `0.major.patch`. A major version
bump indicates a zig-xkbcommon release that breaks API or requires a newer Zig
version to build. A patch version bump indicates a zig-xkbcommon release that is
fully backwards compatible.

For unreleased versions, the `-dev` suffix is used (e.g. `0.1.0-dev`).

The version of zig-xkbcommon currently has no direct relation to the upstream
xkbcommon version supported.

Breaking changes in zig-xkbcommon's API will be necessary until a stable Zig 1.0
version is released, at which point I plan to switch to a new versioning scheme
and start the version numbers with `1` instead of `0`.
