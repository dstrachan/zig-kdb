const std = @import("std");

pub const KdbType = enum(i8) {
    boolean = 1,
    guid = 2,
    byte = 4,
    short = 5,
    int = 6,
    long = 7,
    real = 8,
    float = 9,
    char = 10,
    symbol = 11,
    timestamp = 12,
    month = 13,
    date = 14,
    datetime = 15,
    timespan = 16,
    minute = 17,
    second = 18,
    time = 19,
    table = 98,
    dictionary = 99,
};

pub const K = *extern struct {
    m: i8,
    a: i8,
    typ: i8,
    attribute: u8,
    reference_count: i32,
    as: KUnion,

    pub fn isAtom(self: K, comptime T: KdbType) bool {
        if (@intFromEnum(T) > @intFromEnum(KdbType.time)) @compileError("Expected atom type but found: " ++ @tagName(T));
        return self.typ == -@intFromEnum(T);
    }

    pub fn isList(self: K, comptime T: KdbType) bool {
        if (@intFromEnum(T) > @intFromEnum(KdbType.time)) @compileError("Expected list type but found: " ++ @tagName(T));
        return self.typ == @intFromEnum(T);
    }

    pub fn isTable(self: K) bool {
        return self.typ == @intFromEnum(KdbType.table);
    }

    pub fn isDictionary(self: K) bool {
        return self.typ == @intFromEnum(KdbType.dictionary);
    }

    pub fn atom(self: K, comptime T: KdbType) T {
        return switch (T) {
            .boolean, .byte, .char => self.as.byte,
            .short => self.as.short,
            .int, .month, .date, .minute, .second, .time => self.as.int,
            .long, .timestamp, .timespan => self.as.long,
            .real => self.as.real,
            .float, .datetime => self.as.float,
            .symbol => self.as.symbol,
            .table => self.as.table,
            else => @compileError("Expected atom type but found: " ++ @tagName(T)),
        };
    }

    pub fn list(self: K, comptime T: KdbType) [*]FromType(T) {
        if (T == .table or T == .dictionary) @compileError("Expected list type but found: " ++ @tagName(T));
        return @ptrCast(&self.as.list.G0);
    }
};

pub fn FromType(comptime T: KdbType) type {
    return switch (T) {
        .boolean => bool,
        .guid => Guid,
        .byte => u8,
        .short => i16,
        .int => i32,
        .long => i64,
        .real => f32,
        .float => f64,
        .char => u8,
        .symbol => [*]u8,
        .timestamp => i32,
        .month => i32,
        .date => i32,
        .datetime => i32,
        .timespan => i32,
        .minute => i32,
        .second => i32,
        .time => i32,
        .table => @compileError("NYI"),
        .dictionary => @compileError("NYI"),
    };
}

pub fn makeAtom(comptime T: KdbType, value: FromType(T)) K {
    return switch (T) {
        .boolean => kb(@intFromBool(value)),
        .guid => ku(value),
        .byte => kg(value),
        .short => kh(value),
        .int => ki(value),
        .long => kj(value),
        .real => ke(value),
        .float => kf(value),
        .char => kc(value),
        .symbol => ks(value),
        .timestamp, .timespan => ktj(-@intFromEnum(T), value),
        .month, .minute, .second => blk: {
            const atom = ka(-@intFromEnum(T));
            atom.as.int = value;
            break :blk atom;
        },
        .date => kd(value),
        .datetime => kz(value),
        .time => kt(value),
        .table => @compileError("NYI"),
        .dictionary => @compileError("NYI"),
    };
}
pub extern fn ktj(i32, i64) K;
pub extern fn ka(i32) K;
pub extern fn kb(i32) K;
pub extern fn kg(i32) K;
pub extern fn kh(i32) K;
pub extern fn ki(i32) K;
pub extern fn kj(i64) K;
pub extern fn ke(f64) K;
pub extern fn kf(f64) K;
pub extern fn kc(i32) K;
pub extern fn ks([*]u8) K;
pub extern fn kd(i32) K;
pub extern fn kz(f64) K;
pub extern fn kt(i32) K;

const KUnion = extern union {
    byte: u8,
    short: i16,
    int: i32,
    long: i64,
    real: f32,
    float: f64,
    symbol: [*]u8,
    table: Table,
    list: KList,
};

const KList = extern struct {
    len: i64,
    G0: [*]u8,
};

pub const Table = [*]K;
pub const Guid = extern struct {
    g: [16]u8 = .{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
};

pub extern fn ku(Guid) K;
pub extern fn knt(i64, K) K;
pub extern fn ktn(i32, i64) K;
pub extern fn kpn([*]u8, i64) K;
pub extern fn setm(i32) i32;
pub extern fn ver(...) i32;
pub const va_list = [*c]u8;
pub extern fn m9() void;
pub extern fn gc(i64) i64;
pub extern fn khpunc([*]u8, i32, [*]u8, i32, i32) i32;
pub extern fn khpun([*]u8, i32, [*]u8, i32) i32;
pub extern fn khpu([*]u8, i32, [*]u8) i32;
pub extern fn khp([*]u8, i32) i32;
pub extern fn okx(K) i32;
pub extern fn ymd(i32, i32, i32) i32;
pub extern fn dj(i32) i32;
pub extern fn r0(K) void;
pub extern fn sd0(i32) void;
pub extern fn sd0x(i32, i32) void;
pub extern fn kclose(i32) void;
pub extern fn sn([*]u8, i32) [*]u8;
pub extern fn ss([*]u8) [*]u8;
pub extern fn ee(K) K;
pub extern fn sd1(i32, ?*const fn (i32) callconv(.C) K) K;
pub extern fn dl(?*anyopaque, i64) K;
pub extern fn m4(i32) K;
pub extern fn knk(i32, ...) K;
pub extern fn kp([*]u8) K;
pub extern fn ja([*c]K, ?*anyopaque) K;
pub extern fn js([*c]K, [*]u8) K;
pub extern fn jk([*c]K, K) K;
pub extern fn jv([*c]K, K) K;
pub extern fn k(i32, [*]u8, ...) K;
pub extern fn xT(K) K;
pub extern fn xD(K, K) K;
pub extern fn ktd(K) K;
pub extern fn r1(K) K;

pub fn err(message: []const u8) K {
    return krr(@constCast(message.ptr));
}
pub extern fn krr([*]u8) K;

pub extern fn orr([*]u8) K;
pub extern fn dot(K, K) K;
pub extern fn b9(i32, K) K;
pub extern fn d9(K) K;
pub extern fn sslInfo(K) K;
pub extern fn vaknk(i32, va_list) K;
pub extern fn vak(i32, [*]u8, va_list) K;
pub extern fn vi(K, u64) K;
pub const nh = std.zig.c_translation.cast(i32, std.zig.c_translation.promoteIntLiteral(i32, 0xFFFF8000, .hexadecimal));
pub const wh = std.zig.c_translation.cast(i32, @as(i32, 0x7FFF));
pub const ni = std.zig.c_translation.cast(i32, std.zig.c_translation.promoteIntLiteral(i32, 0x80000000, .hexadecimal));
pub const wi = std.zig.c_translation.cast(i32, std.zig.c_translation.promoteIntLiteral(i32, 0x7FFFFFFF, .hexadecimal));
pub const nj = std.zig.c_translation.cast(i64, std.zig.c_translation.promoteIntLiteral(i64, 0x8000000000000000, .hexadecimal));
pub const wj = @as(i64, 0x7FFFFFFFFFFFFFFF);
pub const nf = std.zig.c_translation.MacroArithmetic.div(@as(i32, 0), @as(f64, 0.0));
pub const wf = std.zig.c_translation.MacroArithmetic.div(@as(i32, 1), @as(f64, 0.0));
