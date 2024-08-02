/**
 * Functions for managing argument list (...)
 */

m4_define_function(«m4_args_pop_back_n(cnt, args...)»,
	«m4_ifelse(
		m4_eval(«$1 < 0»), «1», «m4_fatal(«$0 cnt=$1 < 0»)»,
		m4_eval(«$1 == 0»), «1», «m4_shift($@)»,
		m4_eval(«$# <= $1 + 1»), «1», «»,
		m4_eval(«$# == $1 + 2»), «1», «$2»,
		«$2,$0($1, m4_shift2($@))»)»)
m4_test(«m4_args_pop_back_n(0,1,2,3,4)», «1,2,3,4»)
m4_test(«m4_args_pop_back_n(1,1,2,3,4)», «1,2,3»)
m4_test(«m4_args_pop_back_n(2,1,2,3,4)», «1,2»)
m4_test(«m4_args_pop_back_n(4,1,2,3,4)», «»)

m4_define_function(«m4_args_pop_back(args...)», «m4_args_pop_back_n(1, $@)»)

m4_define_function(«m4_args_pop_front_n(cnt, args...)»,
	«m4_ifelse(
		«$1», 0, «$@»,
		«$1», 1, «m4_shift(m4_shift($@))»,
		«m4_args_pop_front_n(m4_eval($1 - 1), m4_shift(m4_shift($@)))»)»)

m4_define_function(«m4_args_pop_front(args...)», «m4_shift($@)»)

m4_define_function(«m4_args_len(args...)», «$#»)

m4_define_function(«m4_args_sub(start, len, args...)»,
	«m4_args_pop_back(
		m4_max(m4_eval($# - 2 - $1 - $2), 0),
		m4_args_pop_front_n($1, m4_shift(m4_shift($@))))»)

m4_define(«m4_args_first», «$1»)

m4_define(«m4_args_esc», «$@»)
