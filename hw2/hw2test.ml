type awksub_nonterminals =
  | Expr | Term | Lvalue | Incrop | Binop | Num;;

let awksub_rules =
  [Expr, [T"("; N Expr; T")"];
   Expr, [N Num];
   Expr, [N Expr; N Binop; N Expr];
   Expr, [N Lvalue];
   Expr, [N Incrop; N Lvalue];
   Expr, [N Lvalue; N Incrop];
   Lvalue, [T"$"; N Expr];
   Incrop, [T"++"];
   Incrop, [T"--"];
   Binop, [T"+"];
   Binop, [T"-"];
   Num, [T"0"];
   Num, [T"1"];
   Num, [T"2"];
   Num, [T"3"];
   Num, [T"4"];
   Num, [T"5"];
   Num, [T"6"];
   Num, [T"7"];
   Num, [T"8"];
   Num, [T"9"]];;

let awksub_grammar = Expr, awksub_rules;;

let awksub_grammar_2 = convert_grammar awksub_grammar;;

let convert_grammar_test0 = (fst awksub_grammar_2) = Expr;;
let convert_grammar_test1 = (snd awksub_grammar_2) Expr = [[T"("; N Expr; T")"];
                                                           [N Num];
                                                           [N Expr; N Binop; N Expr];
                                                           [N Lvalue];
                                                           [N Incrop; N Lvalue];
                                                           [N Lvalue; N Incrop]];;
let convert_grammar_test2 = (snd awksub_grammar_2) Lvalue = [[T"$"; N Expr]];;
let convert_grammar_test3 = (snd awksub_grammar_2) Incrop = [[T"++"]; [T"--"]];;
let convert_grammar_test4 = (snd awksub_grammar_2) Binop = [[T"+"]; [T"-"]];;
let convert_grammar_test5 = (snd awksub_grammar_2) Num = [[T"0"];
                                                          [T"1"];
                                                          [T"2"];
                                                          [T"3"];
                                                          [T"4"];
                                                          [T"5"];
                                                          [T"6"];
                                                          [T"7"];
                                                          [T"8"];
                                                          [T"9"]];;

let first_nonterm_test0 = (first_nonterm [T"("; N Expr; T")"]) = Some (Expr);;
let first_nonterm_test1 = (first_nonterm [T"("; T"+"; T")"]) = None;;

let check_terminal_test0 = (check_terminal [T"("; N Expr; T")"]) = false;;
let check_terminal_test1 = (check_terminal [T"("; T")"]) = true;;

let apply_nonterm_test0 =
  (apply_nonterm [] [T"("; N Expr; T")"] Expr [N Expr; N Binop; N Expr]) =
    [T"("; N Expr; N Binop; N Expr; T")"];;
let apply_nonterm_test1 =
  (apply_nonterm [] [T"("; T")"] Expr [N Expr; N Binop; N Expr]) =
    [T"("; T")"];;

let next_production_rules_test0 =
  (next_production_rules [T"("; N Expr; T")"] (snd awksub_grammar_2)) =
    [[T"("; N Expr; T")"];
     [N Num];
     [N Expr; N Binop; N Expr];
     [N Lvalue];
     [N Incrop; N Lvalue];
     [N Lvalue; N Incrop]];;
let next_production_rules_test1 =
  (next_production_rules [T"("; T")"] (snd awksub_grammar_2)) = [];;

let prefix_match_test0 = (prefix_match ["3"; "+"; "4"; "xyzzy"] [T"3"; N Expr]) = true;;
let prefix_match_test1 = (prefix_match ["3"] [T"3"; N Expr]) = true;;
let prefix_match_test2 = (prefix_match ["3"] [T"3"; T"+"; N Expr]) = false;;
let prefix_match_test3 = (prefix_match ["3"] [N Expr; T"3"; T"+"]) = true;;

let long_derivation = [(Expr, [N Term; N Binop; N Expr]);
                       (Term, [T "("; N Expr; T ")"]);
                       (Expr, [N Term]);
                       (Term, [N Lvalue]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term]);
                       (Term, [N Num]);
                       (Num, [T "8"]);
                       (Binop, [T "-"]);
                       (Expr, [N Term; N Binop; N Expr]);
                       (Term, [N Lvalue]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term; N Binop; N Expr]);
                       (Term, [N Incrop; N Lvalue]);
                       (Incrop, [T "++"]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term; N Binop; N Expr]);
                       (Term, [N Incrop; N Lvalue]);
                       (Incrop, [T "--"]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term; N Binop; N Expr]);
                       (Term, [N Num]);
                       (Num, [T "9"]);
                       (Binop, [T "+"]);
                       (Expr, [N Term]);
                       (Term, [T "("; N Expr; T ")"]);
                       (Expr, [N Term; N Binop; N Expr]);
                       (Term, [N Lvalue]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term; N Binop; N Expr]);
                       (Term, [N Incrop; N Lvalue]);
                       (Incrop, [T "++"]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term]);
                       (Term, [N Num]);
                       (Num, [T "2"]);
                       (Binop, [T "+"]);
                       (Expr, [N Term]);
                       (Term, [T "("; N Expr; T ")"]);
                       (Expr, [N Term]);
                       (Term, [N Num]);
                       (Num, [T "8"]);
                       (Binop, [T "-"]);
                       (Expr, [N Term]);
                       (Term, [N Num]);
                       (Num, [T "9"]);
                       (Binop, [T "-"]);
                       (Expr, [N Term]);
                       (Term, [T "("; N Expr; T ")"]);
                       (Expr, [N Term]);
                       (Term, [N Lvalue]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term]);
                       (Term, [N Lvalue]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term]);
                       (Term, [N Lvalue]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term]);
                       (Term, [N Lvalue; N Incrop]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term]);
                       (Term, [N Lvalue; N Incrop]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term]);
                       (Term, [N Incrop; N Lvalue]);
                       (Incrop, [T "++"]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term]);
                       (Term, [N Lvalue; N Incrop]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term]);
                       (Term, [N Num]);
                       (Num, [T "5"]);
                       (Incrop, [T "++"]);
                       (Incrop, [T "++"]);
                       (Incrop, [T "--"]);
                       (Binop, [T "-"]);
                       (Expr, [N Term]);
                       (Term, [N Incrop; N Lvalue]);
                       (Incrop, [T "++"]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term]);
                       (Term, [N Lvalue; N Incrop]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term]);
                       (Term, [T "("; N Expr; T ")"]);
                       (Expr, [N Term]);
                       (Term, [N Lvalue; N Incrop]);
                       (Lvalue, [T "$"; N Expr]);
                       (Expr, [N Term]);
                       (Term, [N Num]);
                       (Num, [T "8"]);
                       (Incrop, [T "++"]);
                       (Incrop, [T "++"]);
                       (Binop, [T "+"]);
                       (Expr, [N Term]);
                       (Term, [N Num]);
                       (Num, [T "0"])];;

let long_expression = [T"("; T"$"; T"8"; T")"; T"-"; T"$"; T"++"; T"$"; T"--"; T"$"; T"9"; T"+";
                       T"("; T"$"; T"++"; T"$"; T"2"; T"+"; T"("; T"8"; T")"; T"-"; T"9"; T")";
                       T"-"; T"("; T"$"; T"$"; T"$"; T"$"; T"$"; T"++"; T"$"; T"$"; T"5"; T"++";
                       T"++"; T"--"; T")"; T"-"; T"++"; T"$"; T"$"; T"("; T"$"; T"8"; T"++"; T")";
                       T"++"; T"+"; T"0"]

let awkish_grammar =
  (Expr,
   function
   | Expr ->
      [[N Term; N Binop; N Expr];
       [N Term]]
   | Term ->
      [[N Num];
       [N Lvalue];
       [N Incrop; N Lvalue];
       [N Lvalue; N Incrop];
       [T"("; N Expr; T")"]]
   | Lvalue ->
      [[T"$"; N Expr]]
   | Incrop ->
      [[T"++"];
       [T"--"]]
   | Binop ->
      [[T"+"];
       [T"-"]]
   | Num ->
      [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
       [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]]);;

let evaluate_derivation_test0 = (evaluate_derivation [N Expr] long_derivation) = long_expression;;
let generate_derivations_test0 =
  (generate_derivations [N Expr] (snd awkish_grammar) []) =
    [[(Expr, [N Term; N Binop; N Expr])];
     [(Expr, [N Term])]];;
let generate_derivations_test1 =
  (generate_derivations [N Expr] (snd awkish_grammar) [(Expr, [N Term; N Binop; N Expr])]) =
    [[(Expr, [N Term; N Binop; N Expr]);
      (Term, [N Num])];
     [(Expr, [N Term; N Binop; N Expr]);
      (Term, [N Lvalue])];
     [(Expr, [N Term; N Binop; N Expr]);
       (Term, [N Incrop; N Lvalue])];
     [(Expr, [N Term; N Binop; N Expr]);
      (Term, [N Lvalue; N Incrop])];
     [(Expr, [N Term; N Binop; N Expr]);
      (Term, [T"("; N Expr; T")"])]];;

let filter_derivations_test0 =
  (filter_derivations [N Expr] ["3"; "+"; "4"; "xyzzy"] (generate_derivations [N Expr] (snd awkish_grammar) [(Expr, [N Term; N Binop; N Expr])])) =
    [[(Expr, [N Term; N Binop; N Expr]);
      (Term, [N Num])];
     [(Expr, [N Term; N Binop; N Expr]);
      (Term, [N Lvalue])];
     [(Expr, [N Term; N Binop; N Expr]);
      (Term, [N Incrop; N Lvalue])];
     [(Expr, [N Term; N Binop; N Expr]);
      (Term, [N Lvalue; N Incrop])]];;

let flatmap deriv = filter_derivations [N Expr] ["3"; "+"; "4"; "xyzzy"]
                           (List.concat
                              (List.map
                                 (generate_derivations [N Expr] (snd awkish_grammar)) deriv));;
let list_flatmap_test0 =
  (flatmap [[]]) =
     [[(Expr, [N Term; N Binop; N Expr])]; [(Expr, [N Term])]];;
let list_flatmap_test1 =
  (flatmap (flatmap [[]])) =
    [[(Expr, [N Term; N Binop; N Expr]); (Term, [N Num])];
     [(Expr, [N Term; N Binop; N Expr]); (Term, [N Lvalue])];
     [(Expr, [N Term; N Binop; N Expr]); (Term, [N Incrop; N Lvalue])];
     [(Expr, [N Term; N Binop; N Expr]); (Term, [N Lvalue; N Incrop])];
     [(Expr, [N Term]); (Term, [N Num])];
     [(Expr, [N Term]); (Term, [N Lvalue])];
     [(Expr, [N Term]); (Term, [N Incrop; N Lvalue])];
     [(Expr, [N Term]); (Term, [N Lvalue; N Incrop])]];;
let list_flatmap_test2 =
  (flatmap (flatmap (flatmap [[]]))) =
    [[(Expr, [N Term; N Binop; N Expr]); (Term, [N Num]); (Num, [T "3"])];
     [(Expr, [N Term]); (Term, [N Num]); (Num, [T "3"])]];;
let list_flatmap_test3 =
  (flatmap (flatmap (flatmap (flatmap [[]])))) =
    [[(Expr, [N Term; N Binop; N Expr]); (Term, [N Num]); (Num, [T "3"]);
      (Binop, [T "+"])];
     [(Expr, [N Term]); (Term, [N Num]); (Num, [T "3"])]]
;;
let list_flatmap_test4 =
  (flatmap (flatmap (flatmap (flatmap (flatmap [[]]))))) =
    [[(Expr, [N Term; N Binop; N Expr]); (Term, [N Num]); (Num, [T "3"]);
      (Binop, [T "+"]); (Expr, [N Term; N Binop; N Expr])];
     [(Expr, [N Term; N Binop; N Expr]); (Term, [N Num]); (Num, [T "3"]);
      (Binop, [T "+"]); (Expr, [N Term])];
     [(Expr, [N Term]); (Term, [N Num]); (Num, [T "3"])]]
;;

let generate_valid_derivations_test0 =
  generate_valid_derivations [N Expr] ["3"; "+"; "4"; "xyzzy"] (snd awkish_grammar) [[]];;
let generate_valid_derivations_test1 =
  generate_valid_derivations [N Expr] ["("; "$"; "8"; ")"; "-"; "$"; "++"; "$"; "--"; "$"; "9"; "+";
                                       "("; "$"; "++"; "$"; "2"; "+"; "("; "8"; ")"; "-"; "9"; ")";
                                       "-"; "("; "$"; "$"; "$"; "$"; "$"; "++"; "$"; "$"; "5"; "++";
                                       "++"; "--"; ")"; "-"; "++"; "$"; "$"; "("; "$"; "8"; "++"; ")";
                                       "++"; "+"; "0"] (snd awkish_grammar) [[]];;

let accept_all derivation string = Some (derivation, string);;

let accept_empty_suffix derivation = function
  | [] -> Some (derivation, [])
  | _ -> None
;;
(* An example grammar for a small subset of Awk.
   This grammar is not the same as Homework 1; it is
   instead the same as the grammar under
   "Theoretical background" above.  *)



let test0 =
  ((parse_prefix awkish_grammar accept_all ["ouch"]) = None);;

let test1 =
  (parse_prefix awkish_grammar accept_all ["9"]);;