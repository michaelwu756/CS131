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
