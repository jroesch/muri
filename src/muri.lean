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
attribute [extern "put_int" "/Users/jroesch/Git/muri/target/libput_int.so"] put_int

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

definition to_cstring (s : string) : IO (ptr cstring) := do
  cstr <- new cstring,
  write_to_cstring cstr (enumerate (list.append (list.reverse s) [char.of_nat 0])),
  return cstr

constant putstr : extern void "puts" [cstring]
attribute [extern "putstr" "/Users/jroesch/Git/muri/target/libput_int.so"] putstr

inductive file
| mk : ptr int -> file

constant read_file : extern void "puts" [int, cstring, int]
attribute [extern "read_file" "/Users/jroesch/Git/muri/target/libput_int.so"] read_file

constant open_file : extern int "puts" [cstring]
attribute [extern "open_file" "/Users/jroesch/Git/muri/target/libput_int.so"] open_file


-- local attribute [semireducible] extern
local attribute [reducible] cstring
local attribute [reducible] extern

definition open_file' : ptr cstring -> IO (ptr (base int)) := open_file
definition read_file' : ptr (base int) -> ptr cstring -> ptr (base int) -> IO unit := read_file

definition openf (file_name : string) : IO file :=
  to_cstring file_name >>= open_file' >>= (fun cfd, return (file.mk cfd))

definition readf : file -> IO (ptr cstring)
| readf (file.mk fd) := do
  buf <- new cstring,
  count <- new (base int),
  storable.write (5 : nat) count,
  read_file' fd buf count,
  iv <- index_array buf 6,
  write_char (char.of_nat 0) iv,
  return buf

definition foo : ptr cstring -> IO unit :=
  putstr

definition main : IO unit := do
   f <- openf "hello.txt",
   s <- readf f,
   foo s

   -- f <- openf "hello.txt",
   -- return ()
   -- s <- readf f,
   -- foo s

vm_eval main
