type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal
;;

let rec subset a b =
  match a with
  | [] -> true
  | f::s -> if List.mem f b then subset s b else false
;;

let rec equal_sets a b =
  if List.length a = 0 && List.length b = 0 then true
  else if List.length a = 0 && List.length b <> 0 then false
  else if List.length b = 0 && List.length a <> 0 then false
  else if not (List.mem (List.hd a) b) then false
  else let removeElement l = List.filter (fun x -> x <> List.hd a) l in
       equal_sets (removeElement a) (removeElement b)
;;

let rec set_union a b =
  match a with
  | [] -> b
  | f::s -> if not (List.mem f s) && not (List.mem f b)
            then set_union s (f::b)
            else set_union s b
;;

let rec set_intersection a b =
  match a with
  | [] -> []
  | f::s -> if List.mem f b && not (List.mem f s)
            then f::set_intersection s b
            else set_intersection s b
;;

let rec set_diff a b =
  match a with
  | [] -> []
  | f::s -> if not (List.mem f b) && not (List.mem f s)
            then f::set_diff s b
            else set_diff s b
;;
