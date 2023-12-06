const std = @import("std");
const expr = @import("./expr.zig");
const t = @import("./type.zig");
const stmt = @import("./stmt.zig");

pub const IdentTypePair = struct { ident: *expr.Ident, type: *t.TypeNode };

pub const BlockNode = struct {
    const Self = *@This();

    allocator: std.mem.Allocator,
    content: []*TreeNode,

    pub fn deinit(self: Self) void {
        for (self.content) |x| {
            x.deinit();
        }
        self.allocator.free(self.content);
    }
};

pub const TreeNode = union(enum) {
    const Self = *@This();

    Expr: expr.ExprNode,
    Stmt: stmt.StmtNode,

    pub fn deinit(self: Self) void {
        switch (self) {
            .Expr => |x| {
                x.deinit();
            },
        }
    }
};
