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
  match gram1 with
  | (s,a) -> (s, production_function a)
;;
(*  match gram1 with
  | (s,[]) -> (s, fun x -> [[]]);
  | (s,a) -> (s, fun x*)
