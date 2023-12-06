const std = @import("std");
const expr = @import("./expr.zig");
const t = @import("./type.zig");
const ast = @import("./ast.zig");

pub const StmtNode = union(enum) {
    const Self = *@This();

    ReturnNode: ReturnNode,
    LetNode: LetNode,
    AssignNode: AssignNode,
    IfNode: IfNode,
    LoopNode: LoopNode,

    pub fn deinit(self: Self) void {
        switch (self) {
            .ReturnNode, .LetNode, .IfNode, .LoopNode => |x| {
                x.deinit();
            },
        }
    }
};

pub const ReturnNode = struct {
    const Self = *@This();

    allocator: std.mem.Allocator,
    item: *expr.ExprNode,

    pub fn deinit(self: Self) void {
        self.item.deinit();
        self.allocator.free(self.item);
    }
};

pub const LetNode = struct {
    const Self = *@This();

    isMutable: bool,
    allocator: std.mem.Allocator,
    ident: *expr.IdentNode,
    varType: *t.TypeNode,
    expr: *expr.ExprNode,

    pub fn deinit(self: Self) void {
        self.ident.deinit();
        self.allocator.free(self.ident);
        self.varType.deinit();
        self.allocator.free(self.varType);
        self.expr.deinit();
        self.allocator.free(self.expr);
    }
};

pub const AssignNode = struct {
    const Self = *@This();

    allocator: std.mem.Allocator,
    target: *expr.ExprNode,
    expr: *expr.ExprNode,

    pub fn deinit(self: Self) void {
        self.target.deinit();
        self.allocator.free(self.target);
        self.expr.deinit();
        self.allocator.free(self.expr);
    }
};

pub const IfNode = struct {
    const Self = *@This();

    allocator: std.mem.Allocator,
    cond: *expr.ExprNode,
    thenClause: *ast.BlockNode,
    elseClause: *ast.TreeNode,

    pub fn deinit(self: Self) void {
        self.cond.deinit();
        self.allocator.free(self.cond);
        self.thenClause.deinit();
        self.allocator.free(self.thenClause);
        self.elseClause.deinit();
        self.allocator.free(self.elseClause);
    }
};

pub const LoopNode = struct {
    const Self = *@This();

    allocator: std.mem.Allocator,
    block: *ast.BlockNode,

    pub fn deinit(self: Self) void {
        self.block.deinit();
        self.allocator.free(self.block);
    }
};
