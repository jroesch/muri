import system.IO
import system.ffi
-- import config

set_option native.library_path "/Users/jroesch/Git/lean/build/debug"
set_option native.include_path "/Users/jroesch/Git/lean/src"

open ffi
open ffi.type
open ffi.base_type
-- inductive result (I T : Type) :=
-- | done : I → T → result I T
--  | fail : I → result I T

constant put_int : extern "put_int" [int] void

definition main : IO unit := do
  i <- new (base int),
  put_int i,
  put_str_ln "Hello World!"
