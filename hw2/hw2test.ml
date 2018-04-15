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
   Num, [T"9"]]

let awksub_grammar = Expr, awksub_rules

let awksub_grammar_2 = convert_grammar awksub_grammar

let convert_grammar_test0 = (fst awksub_grammar_2) = Expr
let convert_grammar_test1 = (snd awksub_grammar_2) Expr = [[T"("; N Expr; T")"];
                                                           [N Num];
                                                           [N Expr; N Binop; N Expr];
                                                           [N Lvalue];
                                                           [N Incrop; N Lvalue];
                                                           [N Lvalue; N Incrop]]
let convert_grammar_test2 = (snd awksub_grammar_2) Lvalue = [[T"$"; N Expr]]
let convert_grammar_test3 = (snd awksub_grammar_2) Incrop = [[T"++"]; [T"--"]]
let convert_grammar_test4 = (snd awksub_grammar_2) Binop = [[T"+"]; [T"-"]]
let convert_grammar_test5 = (snd awksub_grammar_2) Num = [[T"0"];
                                                          [T"1"];
                                                          [T"2"];
                                                          [T"3"];
                                                          [T"4"];
                                                          [T"5"];
                                                          [T"6"];
                                                          [T"7"];
                                                          [T"8"];
                                                          [T"9"]]

let first_nonterm_test0 = (first_nonterm [T"("; N Expr; T")"]) = Some (Expr)
let first_nonterm_test1 = (first_nonterm [T"("; T"+"; T")"]) = None

let check_terminal_test0 = (check_terminal [T"("; N Expr; T")"]) = false
let check_terminal_test1 = (check_terminal [T"("; T")"]) = true

let apply_nonterm_test0 =
  (apply_nonterm [T"("; N Expr; T")"] Expr [N Expr; N Binop; N Expr]) =
    [T"("; N Expr; N Binop; N Expr; T")"]
let apply_nonterm_test1 =
  (apply_nonterm [T"("; T")"] Expr [N Expr; N Binop; N Expr]) =
    [T"("; T")"]

let next_production_rules_test0 =
  (next_production_rules [T"("; N Expr; T")"] (snd awksub_grammar_2)) =
    [[T"("; N Expr; T")"];
     [N Num];
     [N Expr; N Binop; N Expr];
     [N Lvalue];
     [N Incrop; N Lvalue];
     [N Lvalue; N Incrop]]
let next_production_rules_test1 =
  (next_production_rules [T"("; T")"] (snd awksub_grammar_2)) = []

let prefix_match_test0 = (prefix_match ["3"; "+"; "4"; "xyzzy"] [T"3"; N Expr]) = true
let prefix_match_test1 = (prefix_match ["3"] [T"3"; N Expr]) = true
let prefix_match_test2 = (prefix_match ["3"] [T"3"; T"+"; N Expr]) = false
let prefix_match_test3 = (prefix_match ["3"] [N Expr; T"3"; T"+"]) = true

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
       [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]])

let generate_derivations_test0 =
  (generate_derivations [N Expr] (snd awkish_grammar) []) =
    [[(Expr, [N Term; N Binop; N Expr])];
     [(Expr, [N Term])]]
let generate_derivations_test1 =
  (generate_derivations [N Term; N Binop; N Expr] (snd awkish_grammar) [(Expr, [N Term; N Binop; N Expr])]) =
    List.map (List.rev) [[(Expr, [N Term; N Binop; N Expr]);
                          (Term, [N Num])];
                         [(Expr, [N Term; N Binop; N Expr]);
                          (Term, [N Lvalue])];
                         [(Expr, [N Term; N Binop; N Expr]);
                          (Term, [N Incrop; N Lvalue])];
                         [(Expr, [N Term; N Binop; N Expr]);
                          (Term, [N Lvalue; N Incrop])];
                         [(Expr, [N Term; N Binop; N Expr]);
                          (Term, [T"("; N Expr; T")"])]]

let filter_derivations_test0 =
  let deriv = [(Expr, [N Term; N Binop; N Expr])] in
  (filter_derivations ["3"; "+"; "4"; "xyzzy"] [N Term; N Binop; N Expr]
     (generate_derivations [N Term; N Binop; N Expr] (snd awkish_grammar) deriv)) =
    [([N Num; N Binop; N Expr],
      [(Term, [N Num]); (Expr, [N Term; N Binop; N Expr])]);
     ([N Lvalue; N Binop; N Expr],
      [(Term, [N Lvalue]); (Expr, [N Term; N Binop; N Expr])]);
     ([N Incrop; N Lvalue; N Binop; N Expr],
      [(Term, [N Incrop; N Lvalue]); (Expr, [N Term; N Binop; N Expr])]);
     ([N Lvalue; N Incrop; N Binop; N Expr],
      [(Term, [N Lvalue; N Incrop]); (Expr, [N Term; N Binop; N Expr])])]

let generate_suffix_test0 = (generate_suffix [T "3"] ["3"; "+"]) = ["+"]
