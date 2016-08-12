import system.IO
import system.ffi
-- import config

set_option native.library_path "/Users/jroesch/Git/lean/build/debug"
set_option native.include_path "/Users/jroesch/Git/lean/src"
set_option native.emit_dwarf true
set_option trace.compiler true

open ffi
open ffi.type
open ffi.base_type
-- inductive result (I T : Type) :=
-- | done : I → T → result I T
--  | fail : I → result I T

check extern

constant put_int : extern void "put_int" [int]

definition main : IO unit := do
  i <- new (base int),
  write_nat_as_int 1337 i,
  n <- read_int_as_nat i,
  put_nat n

-- vm_eval main
