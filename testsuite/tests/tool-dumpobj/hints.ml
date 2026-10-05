(* TEST
 flags = "-nopervasives -bytecode-hints";
 setup-ocamlc.byte-build-env;
 ocamlc.byte;
 run;
 check-program-output;
*)

(* Hints on the reads of values known to be immediates *)

external get : 'a array -> int -> 'a = "%array_safe_get"
external unsafe_get : 'a array -> int -> 'a = "%array_unsafe_get"

type r = { a : int; b : string }

(* Field containing an immediate *)
let field_immediate (r : r) = r.a

(* Field that may contain a pointer: no hint *)
let field_pointer (r : r) = r.b

(* Element of an integer array *)
let int_array_get (t : int array) i = get t i

let int_array_unsafe_get (t : int array) i = unsafe_get t i

(* Element of an array of pointers: no hint *)
let string_array_get (t : string array) i = get t i

(* Components of a tuple pattern *)
let tuple_components (p : int * string) = let x, y = p in x, y

type t = A of int * string

(* Arguments of a constructor pattern *)
let constructor_arguments (A (x, y)) = x, y

(* Hints on integer comparisons *)

external ( = ) : 'a -> 'a -> bool = "%equal"
external ( <> ) : 'a -> 'a -> bool = "%notequal"
external ( < ) : 'a -> 'a -> bool = "%lessthan"
external ( == ) : 'a -> 'a -> bool = "%eq"
external ( != ) : 'a -> 'a -> bool = "%noteq"

let int_equal (x : int) y = x = y

let int_not_equal (x : int) y = x <> y

(* Ordering comparisons are always on integers: no hint *)
let int_less_than (x : int) y = x < y

(* Physical comparisons: no hint *)
let physical_equal (x : string) y = x == y

let physical_not_equal (x : string) y = x != y
