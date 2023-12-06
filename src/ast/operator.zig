const std = @import("std");
const expr = @import("./expr.zig");
const t = @import("./type.zig");

pub const OperatorNode = union(enum) {
    const Self = *@This();

    Binary: BinaryOperatorNode,
    Unary: UnaryOperatorNode,

    IndexNode: IndexNode,
    CastNode: CastNode,
    IsNode: IsNode,
    CallNode: CallNode,

    pub fn deinit(self: Self) void {
        switch (self) {
            .Binary, .Unary, .Index => |x| {
                x.deinit();
            },
        }
    }
};

pub const BinaryOperatorKind = enum { Add, Sub, Mul, Div, Eq, Ne, Lt, Gt, Le, Ge };
pub const BinaryOperatorNode = struct {
    const Self = *@This();

    kind: BinaryOperatorKind,
    priority: u32,
    allocator: std.mem.Allocator,
    left: *expr.ExprNode,
    right: *expr.ExprNode,

    pub fn deinit(self: Self) void {
        self.left.deinit();
        self.right.deinit();
        self.allocator.free(self.left);
        self.allocator.free(self.right);
    }
};

pub const UnaryOperatorKind = enum { Not, Ref, Unref };
pub const UnaryOperatorNode = struct {
    const Self = *@This();

    kind: UnaryOperatorKind,
    priority: u32,
    allocator: std.mem.Allocator,
    expr: *expr.ExprNode,

    pub fn deinit(self: Self) void {
        self.expr.deinit();
    }
};

pub const IndexNode = struct {
    const Self = *@This();

    priority: u32,
    allocator: std.mem.Allocator,
    target: *expr.ExprNode,
    expr: *expr.ExprNode,

    pub fn deinit(self: Self) void {
        self.target.deinit();
        self.expr.deinit();
        self.allocator.free(self.target);
        self.allocator.free(self.expr);
    }
};

pub const CastNode = struct {
    const Self = *@This();

    allocator: std.mem.Allocator,
    target: *expr.ExprNode,
    type: *t.TypeNode,

    pub fn deinit(self: Self) void {
        self.target.deinit();
        self.type.deinit();
        self.allocator.free(self.target);
        self.allocator.free(self.type);
    }
};

pub const IsNode = struct {
    const Self = *@This();

    allocator: std.mem.Allocator,
    target: *expr.ExprNode,
    type: *t.TypeNode,

    pub fn deinit(self: Self) void {
        self.target.deinit();
        self.type.deinit();
        self.allocator.free(self.target);
        self.allocator.free(self.type);
    }
};

pub const CallNode = struct {
    const Self = *@This();

    allocator: std.mem.Allocator,
    target: *expr.ExprNode,
    params: []*expr.ExprNode,

    pub fn deinit(self: Self) void {
        self.target.deinit();
        self.allocator.free(self.target);

        for (self.params) |x| {
            x.deinit();
        }
        self.allocator.free(self.params);
    }
};
