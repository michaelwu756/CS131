type awksub_nonterminals =
  | Expr | Lvalue | Incrop | Binop | Num;;

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
