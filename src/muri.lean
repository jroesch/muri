import system.IO
import system.ffi
-- import config

set_option native.library_path "/Users/jroesch/Git/lean/build/debug"
set_option native.include_path "/Users/jroesch/Git/lean/src"
-- This flag controls whether lean will automatically invoke C++
-- set_option native.compile false
set_option native.emit_dwarf true
-- set_option trace.compiler true

open ffi
open ffi.type
open ffi.base_type
-- inductive result (I T : Type) :=
-- | done : I → T → result I T
--  | fail : I → result I T

constant put_int : extern void "put_int" [int]
attribute [extern] put_int

definition enumerate_inner {A : Type}: nat → list A → list (nat × A)
| enumerate_inner i [] := []
| enumerate_inner i (x :: xs) := (i, x) :: enumerate_inner (i + 1) xs

definition enumerate {A : Type} (xs : list A) :=
  enumerate_inner 0 xs

-- okay wtf was this? rememeber the constant failure
definition write_char (c : char) (p : ptr (base char)) : IO unit :=
  write_char_as_char c p

definition initialize (value : char) : IO (ptr (base base_type.char)) :=
  new (base char) >>= (fun foreign_c, write_char value foreign_c >>= (fun t, return foreign_c))

check @trace

definition write_to_cstring (p : ptr cstring) : list (nat × char) → IO unit
| write_to_cstring [] := return unit.star
| write_to_cstring ((i, c) :: cs) := do
  iv <- index_array p i,
  write_char c iv,
  write_to_cstring cs

constant putstr : extern void "puts" [cstring]
attribute [extern] putstr

definition to_cstring (s : string) : IO (ptr cstring) := do
  cstr <- new cstring,
  write_to_cstring cstr (enumerate [char.of_nat 48, char.of_nat 0]),
  return cstr

definition foo : ptr cstring -> IO unit :=
  putstr

definition main : IO unit :=
   -- i <- new (base int),
   -- write_nat_as_int 10 i,
   -- put_int i
  ((to_cstring "Hello World!" : IO (ptr cstring)) >>= fun s, foo s)

vm_eval main
