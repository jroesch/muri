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

definition write_to_cstring (p : ptr cstring) : list (nat × char) → IO unit
| write_to_cstring [] := return unit.star
| write_to_cstring ((i, c) :: cs) := do
  foreign_c <- new (base char),
  write_char c foreign_c,
  (@write_array 256 (base base_type.char) p i foreign_c : IO unit),
  write_to_cstring cs

constant puts : extern void "puts" [cstring]
attribute [extern] puts

definition to_cstring (str : string) : IO (ptr cstring) := do
  cstr <- new cstring,
  write_to_cstring cstr (@enumerate char str),
  return cstr

definition foo : ptr cstring -> IO unit :=
  puts

definition main : IO unit :=
  ((to_cstring "Hello World!" : IO (ptr cstring)) >>= fun s, foo s)

-- vm_eval main
