(* TEST
   flags = " -short-paths "
   modules = "merlin_dep.mli"
   * toplevel
*)

(* *** #670 *** *)

module type S = sig
  class virtual x : object
    method private virtual release : unit
  end
end;;

module Make (C : S) = struct

  class c =
    object
      method private release = ()
    end

  let x = 3
end;;

(* *** #843 *** *)

class a x = object method x = x end and b x = a x;;

class a x = object end and b = object inherit a end;;

(* *** Don't select deprecated paths *** *)

include struct
  [@@@warning "-3"]

  module M = struct
    type t = T
    [@@deprecated "bad"]
  end

  type t = M.t
  [@@deprecated "bad"]

  module N = struct
    module O = struct
      type t = M.t
    end
  end

  let f (x : t) : unit = x

end;;

(* *** #999 *** *)

module type S = sig
  type t

  val foo : int -> t
end;;

module Functor (S: S) : sig
  val bar : int -> S.t
end = struct
  let bar i =
    S.foo i
end;;

module Bar = Functor (struct
    type t = int

    let foo _i = "haha"
  end);;

(* #1082 *)

let x : Merlin_dep.M.t = 5;;
