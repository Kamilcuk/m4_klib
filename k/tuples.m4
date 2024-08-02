
/**
 * tuples - tuple of tuples
 */

m4_define_function(«m4_tuples_next(tuple, func)»,
	«m4_ifelse(
		m4_tuple_sane(«$1»), «()», «»,
		m4_cat(«$2», m4_tuple_first(«$1»)), «1», «m4_tuple_first(«$1»)»,
		«$0(m4_tuple_shift(«$1»), «$2»)»)»)

m4_define_function(«m4_tuples_next_define(tuple, expr)»,
	«m4_do(
		m4_pushdef(«_$0_», «$2»),
		m4_tuples_next(«$1», «_$0_»),
		m4_popdef(«_$0_»),
	)»)
m4_test(
		«m4_tuples_next_define(
			«((1,2),(3,4),(5,6))»,
			«m4_eval($1 == 5 && $2 == 6)»)»,
		«(5,6)»)

/** Call function for every tuple inside tuples */
m4_define_function(«m4_tuples_map(tuples, func, separator)»,
		«m4_ifelse(
			m4_tuple_isempty(«$1»), «1», «»,
			«m4_do(
				«m4_tuple_call(«$2», m4_tuple_first(«$1»))»,
				«m4_ifelse(
					m4_tuple_len(«$1»), «1», «»,
					«$3»«$0(m4_tuple_shift(«$1»), «$2», «$3»)»)»,
			)»)»)

/** Expand expression for every tuple inside tuples. */
m4_define_function(«m4_tuples_map_define(tuples, expr, separator)»,
		«m4_do(
			«m4_pushdef(«_$0_», «$2»)»,
			«m4_tuples_map(«$1», «_$0_», «$3»)»,
			«m4_popdef(«_$0_»)»,
		)»)

/**
 * @def m4_tuples_longest
 * @brief Given tuples extract the longest tuple within
 */
m4_define_function(«m4_tuples_longest(tuples)», «m4_max(m4_tuples_map(«$1», «m4_args_len», «,»))»)
m4_test(«m4_tuples_longest(«((1,2,3),(1),(1,2))»)», «3»)
m4_test(«m4_tuples_longest(«((1), (2))»)», «1»)

/**
 * @param pre integer
 * @param tuple
 * @param post integer
 */
m4_define_function(«_m4_tuples_nest(pre, tuple, post)»,
	«(m4_do(
			«m4_ifelse(
				«$1», «0», «»,
				«m4_seqcommaX(1, $1, ««$»X»),»)»,
			«m4_args_esc$2»,
			«m4_ifelse(
				«$3», «0», «»,
				«,m4_seqcommaX(
					m4_eval($1 + m4_tuple_len(«$2») + 1),
					m4_eval($1 + m4_tuple_len(«$2») + $3),
					««$»X»)»)»,
		))»)
m4_test(«_m4_tuples_nest(0, (1,2), 0)», «(1,2)»)
m4_test(«_m4_tuples_nest(0, (1,2), 2)», «(1,2,$3,$4)»)
m4_test(«_m4_tuples_nest(2, (3,4), 2)», «($1,$2,3,4,$5,$6)»)

m4_define(«_m4_tuples_map_nested_lvl», «0»)

m4_define_function(«_m4_tuples_map_nested(tuples, func, separator, longest)»,
	«m4_ifelse(
		m4_tuple_sane(«$1»), «()», «»,
		«m4_do(
			«m4_cat(
				«$2»,
				_m4_tuples_nest($4, m4_tuple_first(«$1»), 9))»,
			«m4_ifelse(
				m4_tuple_len(«$1»), «1», «»,
				«$3»«$0(m4_tuple_shift(«$1»), «$2», «$3», «$4»)»)»,
		)»)»)

m4_define_function(«m4_tuples_map_nested(tuples, func, separator)»,
	«m4_do(
		«m4_pushdef(«_$0_lvl», m4_eval(_$0_lvl + m4_tuples_longest(«$1»)))»,
		«_$0(«$1», «$2», «$3», m4_eval(_$0_lvl - m4_tuples_longest(«$1»)))»,
		«m4_popdef(«_$0_lvl»)»,
	)»)

m4_define_function(«m4_tuples_map_define_nested(tuples, expr, separator)»,
		«m4_do(
			«m4_pushdef(«_$0_», «$2»)»,
			«m4_tuples_map_nested(«$1», «_$0_», «$3»)»,
			«m4_popdef(«_$0_»)»,
		)»)
m4_test(
	«m4_tuples_map_define_nested(
		«((1,2), (3,4), (5,6))»,
		«m4_tuples_map_define_nested(
			«((a,b),(c,d))»,
			«$1$2$3$4|»,
		)»,
	)»,
	«12ab|12cd|34ab|34cd|56ab|56cd|»,
)
