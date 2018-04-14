type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal

let convert_grammar gram1 =
  let check_element e = function (nonterm, _) -> e = nonterm in
  let rec group_rules returnVal ruleList =
    match ruleList with
    | [] -> returnVal
    | (left, right)::t ->
       (let add_element = function (nonterm, rules) -> if left = nonterm
                                                       then (nonterm, rules@[right])
                                                       else (nonterm, rules) in
        if List.exists (check_element left) returnVal
        then group_rules (List.map add_element returnVal) t
        else group_rules ((left, [right])::returnVal) t) in
  let production_function ruleList x =
    let grouped_rules = List.rev (group_rules [] ruleList) in
    if List.exists (check_element x) grouped_rules
    then snd (List.find (check_element x) grouped_rules)
    else [[]] in
  match gram1 with (s,a) -> (s, production_function a)
;;

let rec first_nonterm expr =
  match expr with
  | [] -> None
  | (T _)::t -> first_nonterm t
  | (N nonterm)::_ -> Some nonterm
;;

let check_terminal expr =
  match first_nonterm expr with
  | Some _ -> false
  | None -> true
;;

let rec apply_nonterm return_expr expr nonterm replacement =
  match expr with
  | [] -> return_expr
  | (T symb)::t -> apply_nonterm (return_expr@[T symb]) t nonterm replacement
  | (N symb)::t -> if symb = nonterm
                   then (return_expr@replacement@t)
                   else apply_nonterm (return_expr@[N symb]) t nonterm replacement
;;

let next_production_rules expr prod =
  match first_nonterm expr with
  | Some nonterm -> prod nonterm
  | None -> []
;;

let rec prefix_match frag expr =
  match expr with
  | (T symb)::t_expr -> (match frag with
                         | h::t_frag -> if h = symb then prefix_match t_frag t_expr else false
                         | [] -> false)
  | _ -> true
;;

let rec evaluate_derivation expr deriv =
  match deriv with
  | [] -> expr
  | (nonterm, replacement)::t -> evaluate_derivation (apply_nonterm [] expr nonterm replacement) t
;;

let generate_derivations start prod deriv =
  let expr = evaluate_derivation start deriv in
  let construct_deriv deriv nonterm replacement = List.append deriv [(nonterm, replacement)] in
  match first_nonterm expr with
  | Some nonterm -> List.map (construct_deriv deriv nonterm) (next_production_rules expr prod)
  | None -> [deriv]
;;

let filter_derivations start frag derivs =
  let evaluate_prefix_match start frag deriv = prefix_match frag (evaluate_derivation start deriv) in
  List.filter (evaluate_prefix_match start frag) derivs
;;

let rec generate_valid_derivations start frag prod derivs =
  let evaluate_check_terminal start deriv = check_terminal (evaluate_derivation start deriv) in
  if List.for_all (evaluate_check_terminal start) derivs
  then derivs
  else generate_valid_derivations start frag prod
         (filter_derivations start frag
            (List.concat
               (List.map
                  (generate_derivations start prod) derivs)))
;;

let generate_suffix start derivation frag =
  let eval = evaluate_derivation start derivation in
  let rec truncate_prefix eval frag =
    match eval with
    | (T symb)::t_eval -> (match frag with
                           | [] -> []
                           | h::t_frag -> if h = symb
                                          then truncate_prefix t_eval t_frag
                                          else frag)
    | _ -> frag in
  truncate_prefix eval frag
;;

let parse_prefix gram =
  let matcher start production accept frag =
    let valid_derivations = generate_valid_derivations start frag production [[]] in
    let rec matcher_helper start production derivations accept frag =
      match derivations with
      | [] -> None
      | h::t -> let suffix = generate_suffix start h frag in
                if (match accept h suffix with | Some _ -> true | None -> false)
                then accept h suffix
                else matcher_helper start production t accept frag in
    matcher_helper start production valid_derivations accept frag in
  match gram with (s,p) -> matcher [N s] p
;;
