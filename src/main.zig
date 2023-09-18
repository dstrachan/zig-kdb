const k = @import("k.zig");

export fn add(x: k.K, y: k.K) k.K {
    if (!x.isAtom(.long) or !y.isAtom(.long)) return k.err("type");

    const _1 = k.makeAtom(.month, @intCast(x.as.long));
    const _2 = k.makeAtom(.minute, @intCast(y.as.long));
    const _3 = k.makeAtom(.second, @intCast(x.as.long + y.as.long));
    const list = k.knk(3, _1, _2, _3);

    return list;
}
