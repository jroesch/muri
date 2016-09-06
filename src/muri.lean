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

constant put_int : extern void "put_int" [int]
attribute [extern "put_int" "/Users/jroesch/Git/muri/target/libfs.so"] put_int

constant putstr : extern void "puts" [cstring]
attribute [extern "putstr" "/Users/jroesch/Git/muri/target/libfs.so"] putstr

inductive file
| mk : ptr int -> file

constant read_file : extern void "puts" [int, cstring, int]
attribute [extern "read_file" "/Users/jroesch/Git/muri/target/libfs.so"] read_file

constant open_file : extern int "puts" [cstring]
attribute [extern "open_file" "/Users/jroesch/Git/muri/target/libfs.so"] open_file

-- local attribute [semireducible] extern
local attribute [reducible] cstring
local attribute [reducible] extern

definition open_file' : ptr cstring -> IO (ptr (base int)) := open_file
definition read_file' : ptr (base int) -> ptr cstring -> ptr (base int) -> IO unit := read_file

definition openf (file_name : string) : IO file :=
  to_cstring file_name >>= open_file' >>= (fun cfd, return (file.mk cfd))

-- definition select {T : type} (i : nat) (array : ptr (array T)) : ptr T :=
--   index_array array i

definition update {U} {T : type} [sto : storable U T] (i : nat) (value : U) (array : ptr (array T)) : IO unit := do
  iv <- index_array array i,
  storable.write value iv

definition readf_to_string : file → ptr cstring → IO unit
| readf_to_string (file.mk fd) buffer := do
  (array_capacity buffer >>= (fun (cap : ptr (base int)), read_file' fd buffer cap)),
  cap_n <- capacity buffer,
  update (cap_n + 1) (char.of_nat 0) buffer

definition readf (f : file) : IO (ptr cstring) := do
  buf <- new cstring,
  readf_to_string f buf,
  return buf

definition foo : ptr cstring -> IO unit :=
  putstr

definition main : IO unit := do
   f <- openf "hello.txt",
   str <- readf f,
   foo str

vm_eval main
