type ('nonterminal, 'terminal) symbol = N of 'nonterminal | T of 'terminal
val convert_grammar : 'a * ('b * 'c list) list -> 'a * ('b -> 'c list list)
val first_nonterm : ('a, 'b) symbol list -> 'a option
val check_terminal : ('a, 'b) symbol list -> bool
val apply_nonterm :
  ('a, 'b) symbol list -> 'a -> ('a, 'b) symbol list -> ('a, 'b) symbol list
val next_production_rules :
  ('a, 'b) symbol list -> ('a -> 'c list) -> 'c list
val prefix_match : 'a list -> ('b, 'a) symbol list -> bool
val evaluate_derivation :
  ('a, 'b) symbol list ->
  ('a * ('a, 'b) symbol list) list -> ('a, 'b) symbol list
val generate_derivations :
  ('a, 'b) symbol list ->
  ('a -> ('a, 'b) symbol list list) ->
  ('a * ('a, 'b) symbol list) list -> ('a * ('a, 'b) symbol list) list list
val filter_derivations :
  'a list ->
  ('b, 'a) symbol list ->
  ('b * ('b, 'a) symbol list) list list ->
  ('b * ('b, 'a) symbol list) list list
val generate_suffix : ('a, 'b) symbol list -> 'b list -> 'b list
val generate_valid_derivation :
  ('a, 'b) symbol list ->
  ('a -> ('a, 'b) symbol list list) ->
  (('a * ('a, 'b) symbol list) list -> 'b list -> ('c list * 'd) option) ->
  'b list -> ('a * ('a, 'b) symbol list) list list -> ('c list * 'd) option
val parse_prefix :
  'a * ('a -> ('a, 'b) symbol list list) ->
  (('a * ('a, 'b) symbol list) list -> 'b list -> ('c list * 'd) option) ->
  'b list -> ('c list * 'd) option
