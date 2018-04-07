let my_subset_test0 = subset [] ["a";"a"];;
let my_subset_test1 = subset ["a";"a"] ["a";"b"];;
let my_subset_test2 = not (subset ["b";"a"] ["a";"c"]);;

let my_equal_sets_test0 = equal_sets ["a";"b"] ["b";"b";"a"];;
let my_equal_sets_test1 = not (equal_sets ["a";"b"] ["c";"b";"a"]);;

let my_set_union_test0 = equal_sets (set_union ["a"] ["b"]) ["a";"b"];;
let my_set_union_test1 = equal_sets (set_union ["b";"c"] []) ["b";"c"];;

let my_set_intersection_test0 = equal_sets (set_intersection ["a"] ["b"]) [];;
let my_set_intersection_test1 = equal_sets (set_intersection ["a"] ["a"]) ["a"];;
let my_set_intersection_test1 = equal_sets (set_intersection ["a";"b"] ["a";"c"]) ["a"];;

let my_set_diff_test0 = equal_sets (set_diff ["a"] ["a"]) [];;
let my_set_diff_test0 = equal_sets (set_diff ["a"] ["b"]) ["a"];;
let my_set_diff_test0 = equal_sets (set_diff [] ["b"]) [];;

let my_computed_fixed_point_test0 = computed_fixed_point (=) (fun x -> x/2 + x/2) 3 = 2;;

let my_computed_periodic_point_test0 = computed_periodic_point (=) (fun x -> if x mod 2 = 0 then x/2 else 3*x+1) 3 234 = 4;;

let my_while_away_test0 = while_away (fun x -> x+3) (fun x -> x<10) 0 = [0;3;6;9];;

let my_rle_decode_test0 = rle_decode [4,"w"] = ["w";"w";"w";"w"];;
let my_rle_decode_test1 = rle_decode [2,"w";1,"b";] = ["w";"w";"b"];;

type test_nonterminals = | A | B | C | D;;

let my_check_terminal_or_generating_test0 = check_terminal_or_generating [T "a"] [] = true;;
let my_check_terminal_or_generating_test1 = check_terminal_or_generating [T "a"; N D] [D] = true;;
let my_check_terminal_or_generating_test2 = check_terminal_or_generating [T "a"; N D; N A] [D] = false;;
let my_check_terminal_or_generating_test2 = check_terminal_or_generating [T "a"; N D; N A; T "b"] [D; A] = true;;

type awksub_nonterminals = | Expr | Lvalue | Incrop | Binop | Num;;
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

type giant_nonterminals = | Conversation | Sentence | Grunt | Snore | Shout | Quiet;;
let giant_rules =
  [Snore, [T"ZZZ"];
   Quiet, [];
   Grunt, [T"khrgh"];
   Shout, [T"aooogah!"];
   Sentence, [N Quiet];
   Sentence, [N Grunt];
   Sentence, [N Shout];
   Conversation, [N Snore];
   Conversation, [N Sentence; T","; N Conversation]];;

let my_extract_symbols_test0 = extract_symbols awksub_rules = [Expr; Lvalue; Incrop; Binop; Num];;
let my_extract_symbols_test1 = extract_symbols giant_rules = [Snore; Quiet; Grunt; Shout; Sentence; Conversation];;
let my_extract_symbols_test2 = extract_symbols [A, [T "a"]; C, [N A; N C]; D, [N B]] = [A; C; D];;

let my_mark_generating_test0 =
  mark_generating awksub_rules [] =
    [Incrop, [T"++"];
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
let my_mark_generating_test1 =
  let f = mark_generating awksub_rules in
  f (f []) =
    [Expr, [N Num];
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
let my_mark_generating_test2 =
  let f = mark_generating awksub_rules in
  f (f (f [])) =
    [Expr, [T"("; N Expr; T")"];
     Expr, [N Num];
     Expr, [N Expr; N Binop; N Expr];
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
let my_mark_generating_test3 =
  let f = mark_generating awksub_rules in
  f (f (f (f []))) = awksub_rules;;

let my_generating_rules_test0 = generating_rules (Expr, awksub_rules) = awksub_rules;;
let my_generating_rules_test1 = generating_rules (Conversation, giant_rules) = giant_rules;;
let my_generating_rules_test2 = generating_rules (Sentence, (List.tl giant_rules)) =
                                  [Quiet, [];
                                   Grunt, [T "khrgh"];
                                   Shout, [T "aooogah!"];
                                   Sentence, [N Quiet];
                                   Sentence, [N Grunt];
                                   Sentence, [N Shout]];;
let my_generating_rules_test3 = generating_rules (Expr, (List.tl (List.tl awksub_rules))) =
                                  [Incrop, [T"++"];
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

let my_filter_blind_alleys_test0 = true;;
