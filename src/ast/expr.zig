const std = @import("std");
const op = @import("./operator.zig");

pub const ExprNode = union(enum) {
    const Self = *@This();

    Ident: IdentNode,
    String: StringNode,
    Integer: IntegerNode,
    Opeator: op.OperatorNode,

    pub fn deinit(self: Self) void {
        switch (self) {
            .Integer, .String, .Ident => |x| {
                x.deinit();
            },
        }
    }
};

pub const IdentNode = struct {
    const Self = *@This();

    allocator: std.mem.Allocator,
    content: []u8,

    pub fn deinit(self: Self) void {
        self.allocator.free(self.content);
    }
};

pub const StringNode = struct {
    const Self = *@This();

    allocator: std.mem.Allocator,
    content: []u8,

    pub fn deinit(self: Self) void {
        self.allocator.free(self.content);
    }
};

pub const IntegerNode = struct {
    const Self = *@This();

    allocator: std.mem.Allocator,
    digits: []u8,

    pub fn deinit(self: Self) void {
        self.allocator.free(self.content);
    }
};
