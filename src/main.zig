const std = @import("std");

const k = @import("kdb");

fn add(a: k.K, b: k.K) k.K {
    return k.makeAtom(.long, a.as.long + b.as.long);
}

test "add" {
    const a = k.makeAtom(.long, 3);
    const b = k.makeAtom(.long, 7);
    try std.testing.expect(add(a, b).as.long == 10);
}
