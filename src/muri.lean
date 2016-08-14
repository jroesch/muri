import system.IO
import system.ffi
-- import config

set_option native.library_path "/Users/jroesch/Git/lean/build/debug"
set_option native.include_path "/Users/jroesch/Git/lean/src"
-- This flag controls whether lean will automatically invoke C++
set_option native.compile false
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

check write_array

definition write_to_cstring (p : ptr cstring) : list (nat × char) → IO unit
| write_to_cstring [] := return unit.star
| write_to_cstring ((i, c) :: cs) := do
  foreign_c <- new (base char),
  _ <- write_char_as_char_ptr c foreign_c,
  write_array p i foreign_c,
  write_to_cstring cs

definition to_cstring : string → IO (ptr cstring) := fun str, do
  str <- new cstring,
 
  return str

definition main : IO unit := do
  s <- to_cstring "Hello World!",
  return unit.star

  -- i <- new (base int),
  -- write_nat_as_int 1337 i,
  -- put_int i

vm_eval main
