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
  let aLen = List.length a in
  let bLen = List.length b in
  if aLen = 0 && bLen = 0 then true
  else if aLen = 0 && bLen <> 0 then false
  else if bLen = 0 && aLen <> 0 then false
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

let rec computed_fixed_point eq f x =
  let applied = f x in
  if eq applied x
  then x
  else computed_fixed_point eq f applied
;;

let computed_periodic_point eq f p x =
  let rec computed_periodic_point_helper eq f p x l =
    let len = List.length l in
    let appended = x::l in
    if len >= p && eq (List.hd appended) (List.nth appended p) then x
    else computed_periodic_point_helper eq f p (f x) appended in
  computed_periodic_point_helper eq f p x []
;;

let while_away s p x =
  let rec while_away_helper s p x l =
    if not (p x) then l
    else while_away_helper s p (s x) (x::l) in
  List.rev (while_away_helper s p x [])
;;

let rle_decode lp =
  let rec rle_decode_helper l lp =
    let rec appendNum prev n v =
      if n = 0 then prev
      else appendNum (v::prev) (n-1) v in
    match lp with
    | [] -> l
    | f::s -> (match f with (num, value) -> (let addedList = appendNum l num value in
                                             rle_decode_helper addedList s)) in
  List.rev (rle_decode_helper [] lp)
;;

let rec check_terminal_or_generating replacement generating_symbols =
  match replacement with
  | [] -> true
  | f::s -> (match f with
             | T symb -> check_terminal_or_generating s generating_symbols
             | N symb -> if List.mem symb generating_symbols
                         then check_terminal_or_generating s generating_symbols
                         else false)
;;

let extract_symbols rules =
  let rec extract_symbols_helper rules return_symbols =
    match rules with
    | [] -> return_symbols
    | f::s -> (match f with (symb, replacement) -> if not (List.mem symb return_symbols)
                                                   then extract_symbols_helper s (symb::return_symbols)
                                                   else extract_symbols_helper s return_symbols) in
  List.rev (extract_symbols_helper rules [])
;;

let mark_generating rules generating_rules =
  let rec mark_generating_helper rules generating_symbols return_rules =
    match rules with
    | [] -> return_rules
    | f::s -> (match f with (symb, replacement) -> (if check_terminal_or_generating replacement generating_symbols
                                                    then mark_generating_helper s generating_symbols (f::return_rules)
                                                    else mark_generating_helper s generating_symbols return_rules)) in
  List.rev (mark_generating_helper rules (extract_symbols generating_rules) [])
;;

let generating_rules g = match g with (start, rules) -> computed_fixed_point (=) (mark_generating rules) [];;

let extract_reachable_symbols start reachable_rules =
  let rec extract_reachable_symbols_helper reachable_rules return_symbols =
    let rec get_non_terminals replacement return_non_terminals =
      match replacement with
      | [] -> return_non_terminals
      | f::s -> (match f with
                 | T symb -> get_non_terminals s return_non_terminals
                 | N symb -> get_non_terminals s (symb::return_non_terminals)) in
    match reachable_rules with
    | [] -> return_symbols
    | f::s -> (match f with (symb, replacement) ->
                 extract_reachable_symbols_helper s (set_union (get_non_terminals replacement []) return_symbols)) in
  List.rev (extract_reachable_symbols_helper reachable_rules [start])
;;

let mark_reachable rules start reachable_rules =
  let rec mark_reachable_helper rules reachable_symbols return_rules =
    match rules with
    | [] -> return_rules
    | f::s -> (match f with (symb, replacement) -> (if List.mem symb reachable_symbols
                                                    then mark_reachable_helper s reachable_symbols (f::return_rules)
                                                    else mark_reachable_helper s reachable_symbols return_rules)) in
  List.rev (mark_reachable_helper rules (extract_reachable_symbols start reachable_rules) [])
;;

let reachable_rules g = match g with (start, rules) -> computed_fixed_point (=) (mark_reachable rules start) [];;

let filter_blind_alleys g = match g with (start, rules) -> (start, generating_rules g);;
(* To remove unreachable rules, return (start, reachable_rules (start, generating_rules g)) instead *)
