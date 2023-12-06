const std = @import("std");

pub const TypeNode = union(enum) {
    const Self = *@This();

    TypeName: TypeName,
    RefType: RefType,
    UnionType: UnionType,
    ArrayType: ArrayType,

    pub fn deinit(self: Self) void {
        switch (self) {
            .TypeName, .RefType, .UnionType, .ArrayType => |x| {
                x.deinit();
            },
        }
    }
};

pub const TypeKind = enum { Str, Int, I8, Uint, U8, Bool, Null, Size, Void, Anyopaque };

pub const TypeName = union(enum) { Reserved: TypeKind, Name: struct {
    const Self = *@This();

    allocator: *std.mem.Allocator,
    name: []u8,

    pub fn deinit(self: Self) void {
        self.allocator.free(self.name);
    }
} };

pub const RefType = struct {
    const Self = *@This();

    isMutable: bool,
    content: *TypeNode,

    pub fn deinit(self: Self) void {
        self.content.deinit();
    }
};

pub const UnionType = struct {
    const Self = *@This();

    allocator: *std.mem.Allocator,
    items: []*TypeNode,

    pub fn deinit(self: Self) void {
        for (self.items) |node| {
            node.deinit();
        }

        self.allocator.free(self.items);
    }
};

pub const ArrayType = struct {
    const Self = *@This();

    item: *TypeNode,

    pub fn deinit(self: Self) void {
        self.item.deinit();
    }
};
