type ('nonterminal, 'terminal) symbol = N of 'nonterminal | T of 'terminal
val convert_grammar : 'a * ('b * 'c list) list -> 'a * ('b -> 'c list list)
val first_nonterm : ('a, 'b) symbol list -> 'a option
val check_terminal : ('a, 'b) symbol list -> bool
val apply_nonterm :
  ('a, 'b) symbol list -> 'a -> ('a, 'b) symbol list -> ('a, 'b) symbol list
val next_production_rules :
  ('a, 'b) symbol list -> ('a -> 'c list) -> 'c list
val prefix_match : 'a list -> ('b, 'a) symbol list -> bool
val generate_derivations :
  ('a, 'b) symbol list ->
  ('a -> 'c list) -> ('a * 'c) list -> ('a * 'c) list list
val filter_derivations :
  'a list ->
  ('b, 'a) symbol list ->
  ('b * ('b, 'a) symbol list) list list ->
  (('b, 'a) symbol list * ('b * ('b, 'a) symbol list) list) list
val generate_suffix : ('a, 'b) symbol list -> 'b list -> 'b list
val generate_valid_derivation :
  'a ->
  ('b -> ('b, 'c) symbol list list) ->
  (('b * ('b, 'c) symbol list) list -> 'c list -> ('d * 'e) option) ->
  'c list ->
  (('b, 'c) symbol list * ('b * ('b, 'c) symbol list) list) list ->
  ('d * 'e) option
val parse_prefix :
  'a * ('a -> ('a, 'b) symbol list list) ->
  (('a * ('a, 'b) symbol list) list -> 'b list -> ('c * 'd) option) ->
  'b list -> ('c * 'd) option
