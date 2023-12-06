code =
    wb* ((header br+)? body)? wb*

header =
  header_child (br+ header_child)*

header_child =
  header_include

//
// include "./hoge.rc"
//
header_include =
    "include" w+ literal_string

body =
  body_child (br+ body_child)*

body_child =
    define
  / stmt

w = " " / "\t"
wb = w / "\r" / "\n"
br = w* ("\r" / "\n") wb*

ident = [a-zA-Z_][a-zA-Z0-9_]*

expr =
    term
  / op

literal =
    ident
  / literal_byte_string
  / literal_string
  / literal_integer

literal_string = '"' (literal_string_escape / [^"\\])* '"'
literal_string_escape =
    "\\x" [0-9]{2}
  / "\\" [\s\S]

literal_byte_string = 'b"' (literal_string_escape / [^"\\])* '"'

literal_integer = [0-9]+

term = "(" wb* expr wb* ")" / literal

op =
    op_add
  / op_sub
  / op_mul
  / op_div
  / op_eq
  / op_ne
  / op_not
  / op_lt
  / op_gt
  / op_le
  / op_ge
  / op_index
  / op_cast
  / op_is
  / op_ref
  / op_unref
  / op_call

op_add = term w* "+" w* expr
op_sub = term w* "-" w* expr
op_mul = term w* "*" w* expr
op_div = term w* "/" w* expr

op_eq  = term w* "==" w* expr
op_ne  = term w* "!=" w* expr
op_not = "!" w* expr
op_lt  = term w* "<" w* expr
op_gt  = term w* ">" w* expr
op_le  = term w* "<=" w* expr
op_ge  = term w* ">=" w* expr

//
// arr[0]
//
op_index = term w* "[" wb* expr wb* "]"

//
// hoge as Fuga
//
op_cast = term w* "as" w* type

//
// unref hoge
//
op_unref = "unref" w+ expr

//
// ref hoge
//
op_ref = "ref" w+ expr

//
// add 1, 2
//
// (1 + 2)
//
op_call = term (w+ op_call_params)?
op_call_params = op_call_param (w* "," w* op_call_param)*
op_call_param = term

//
// if hoge is string {
//   ...
// }
//
op_is = term w* "is" w* type

stmt =
    stmt_return
  / stmt_break
  / stmt_contiue
  / stmt_let
  / stmt_assign
  / stmt_if
  / stmt_loop

//
// return ...
//
stmt_return = "return" w+ expr

//
// break
//
stmt_break = "break" w+ expr

//
// contiue ...
//
stmt_contiue = "contiue" w+ expr

//
// let hoge: integer = 1234
//
// let mut fuga: integer = 1234
//
stmt_let = "let" w+ ("mut" w+)? stmt_let_def w* "=" w* expr
stmt_let_def = ident w* ":" w* type

//
// hoge = 1234
//
stmt_assign = assign_term w* "=" w* expr

assign_term =
    ident
  / op_index
  / op_ref
  / op_unref

//
// if ... {
//   ...
// }
//
// if ... {
//   ...
// } else {
//   ...
// }
//
stmt_if = "if" w+ expr w* "{" wb* block? wb* "}" w* stmt_if_else?
stmt_if_else = "else" w+ ("{" wb* block? wb* "}" / stmt)

//
// loop {
//   ....
// }
//
stmt_loop = "loop" w* "{" wb* block? wb* "}"

block = block_child (br+ block_child)*
block_child = stmt / expr

define =
    define_struct
  / define_func
  / define_extern

//
// struct Hoge {
//   fuga: integer,
// }
//
define_struct = "struct" w+ ident w* "{" wb* define_struct_members wb* "}"
define_struct_members = define_struct_member (w* "," wb* define_struct_member)* w* ","?
define_struct_member = ident w* ":" w* type

//
// func add(x: integer, y: integer) interger {
//   return x + y
// }
//
define_func = "func" w+ ident w* "(" wb* define_func_params? wb* ")" w* type w* "{" wb* block? wb* "}"
define_func_params = define_func_param ( w* "," wb* define_func_param)* w* ","?
define_func_param = ident w* ":" w* type

//
// extern "..." func puts(text: unsafe_ptr u8): int
//
define_extern = "extern" w+ literal_string w+ extern

extern =
  extern_func

extern_func = "func" w+ ident w* "(" wb* define_func_params? wb* ")" w* type

type =
    type_term
  / type_union

type_term =
    type_name
  / type_ref
  / type_unsafe_ptr
  / type_array
  / ident
  / "(" wb* type wb* ")"

type_name =
    "str"
  / "int"
  / "i8"
  / "uint"
  / "u8"
  / "bool"
  / "null"
  / "size"
  / "void"
  / "anyopaque"

type_ref = "ref" w+ ("mut" w+)? type_name
type_union = type_term (w* "|" w* type)+
type_unsafe_ptr = "unsafe_ptr" w+ type

type_array = "[]" w* type_term