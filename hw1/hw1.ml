let rec subset a b =
  match a with
  | [] -> true
  | f::s -> if List.mem f b then subset s b else false
;;
