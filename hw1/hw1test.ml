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

let my_computed_fixed_point_test0 = true;;
let my_computed_periodic_point_test0 = true;;
let my_while_away_test0 = true;;
let my_rle_decode_test0 = true;;
let my_filter_blind_alleys_test0 = true;;
