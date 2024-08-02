
m4_define(«m4_tuple_L», «(»)
m4_define(«m4_tuple_R», «)»)

m4_define_function(«m4_tuple_sane(tuple)», «_m4_tuple_sane(m4_strip(«$1»))»)
m4_define_function(«m4_tuple_sane(tuple)», «m4_ifelse(«$1», «», «()», «m4_strip(«$1»)»)»)
m4_define_function(«_m4_tuple_sane(tuple)»,
		«m4_ifelse(
			m4_eval(«$# != 1»), «1», «m4_fatal(«m4_tuple_sane: wrong number of arguments: $#»)»,
			«$1», «», «()»,
			m4_regexp(«$1», «^(.*)$»), «-1», «m4_fatal(«not a valid tuple: "$1"»)»,
			«$1»)»)

m4_define_function(«m4_tuple_call(func, tuple)», «m4_cat(«$1», m4_tuple_sane(«$2»))»)

m4_define_function(«m4_tuple_first(tuple)», «m4_tuple_call(«m4_args_first», «$1»)»)

m4_define_function(«m4_tuple_shift(tuple)», «(m4_tuple_call(«m4_shift», «$1»))»)

m4_define_function(«m4_tuple_len(tuple)»,
		«m4_ifelse(
			«$1», «()», «0»,
			«$1», «», «0»,
			«m4_tuple_call(«m4_args_len», «$1»)»)»)
m4_test(«m4_tuple_len(())», «0»)
m4_test(«m4_tuple_len((1,2))», «2»)
m4_test(«m4_tuple_len((1,2,3,4,5))», «5»)

/** 1 if tuple is empty, 0 otherwise */
m4_define_function(«m4_tuple_isempty(tuple)», «m4_ifelse(m4_tuple_sane(«$1»), «()», «1», «0»)»)
m4_test(«m4_tuple_isempty(())», 1)
m4_test(«m4_tuple_isempty((1,2))», 0)

m4_define_function(«m4_tuple_push_back(tuple, elem, ...)»,
		«(m4_ifelse(
				m4_tuple_sane(«$1»), «()», «$2»,
				«m4_tuple_call(«m4_args_esc», «$1»),m4_shift($@)»))»)
m4_test(«m4_tuple_push_back(,1)», «(1)»)
m4_test(«m4_tuple_push_back((),1)», «(1)»)
m4_test(«m4_tuple_push_back((1),2)», «(1,2)»)
m4_test(«m4_tuple_push_back((1,2,3),4)», «(1,2,3,4)»)

m4_define_function(«m4_tuple_pop_back(tuple)», «m4_args_pop_back$1»)

m4_define_function(«m4_tuple_join(tuple1, tuple2)»,
		«(m4_do(
				«m4_tuple_call(«m4_args_esc», «$1»)»,
				«m4_ifelse(
					m4_tuple_sane(«$1»), «()», «»,
					m4_tuple_sane(«$2»), «()», «»,
					«,»)»,
				«m4_tuple_call(«m4_args_esc», «$2»)»,
				))»)
m4_test(«m4_tuple_join( (a,b,c), (1,2,3) )», «(a,b,c,1,2,3)»)
m4_test(«m4_tuple_join( (a,b,c), () )», «(a,b,c)»)
m4_test(«m4_tuple_join( (), (1,2,3) )», «(1,2,3)»)

#define m4_tuples_merge(tuple1, tuple2)
m4_define(«m4_tuples_merge», «(_m4_tuples_merge((), $@, «»))»)
m4_define_function(«_m4_tuples_merge(result, tuple1, tuple2, empty)»,
	«m4_ifelse(
		«$2», «», «$1»,
		m4_strip(«$2»), «()», «$1»,
		«m4_do(
			«$0(m4_tuple_join($1, m4_tuple_first($2)), m4_shift2($@))»,
			«m4_ifelse(
				m4_tuple_len(«$2»), 0, «»,
				m4_tuple_len(«$2»), 1, «»,
				«,$0($1, m4_tuple_shift($2), m4_shift2($@))»)»)»)»)
m4_test(
		«m4_tuples_merge( ((1,2),(a,b)), ((3,4),(c,d)))»,
		«((1,2,3,4),(1,2,c,d),(a,b,3,4),(a,b,c,d))»)
m4_test(
		«m4_tuples_merge( ((1,2),(a,b)), ((3,4),(d)))»,
		«((1,2,3,4),(1,2,d),(a,b,3,4),(a,b,d))»)
m4_test(
		«m4_tuples_merge( ((1,2),(a,b)), ((3,4),(c,d)), ((5,6),(e,f)))»,
		«((1,2,3,4,5,6),(1,2,3,4,e,f),(1,2,c,d,5,6),(1,2,c,d,e,f),(a,b,3,4,5,6),(a,b,3,4,e,f),(a,b,c,d,5,6),(a,b,c,d,e,f))»)

#define m4_tuple_has(tuple, elem)
m4_define_function(«m4_tuple_has(tuple, elem)»,
	«m4_ifelse(
		m4_tuple_sane(«$1»), «()», «0»,
		m4_tuple_first(«$1»), «$2», «1»,
		«$0(m4_tuple_shift(«$1»), $2)»)»)
m4_test(«m4_tuple_has((1,2,3,4), 5)», «0»)
m4_test(«m4_tuple_has((1,2,3,4), 2)», «1»)

/**
 * @def m4_tuple_map
 * @brief Given a tuple, apply function of each element of the tuple and return the result.
 */
m4_define_function(«m4_tuple_map(tuple, func)»,
		«(_$0(m4_tuple_len(«$1»), «$1», «$2»))»)
m4_define_function(«_m4_tuple_map(length, tuple, func)»,
		«m4_ifelse(
			«$1», «0», «»,
			«$3(m4_tuple_first(«$2»))m4_ifelse(
					«$1», «1», «»,
					«,$0(m4_decr(«$1»), m4_tuple_shift(«$2»), «$3»)»)»)»)

m4_test(
		«m4_do(
			«m4_pushdef(«func»,
				«m4_ifelse(
					«m4_eval($# != 1)», «1», «m4_fatal(«not enough args: $@»)»,
					«m4_eval($1 * 2)»)»)»,
			«m4_tuple_map(«(1, 2, 3)», «func»)»,
			«m4_popdef(«func»)»,
		)»,
		«(2,4,6)»)

m4_define_function(«m4_tuple_map_define(tuple, expr)»,
		«m4_do(
			«m4_pushdef(«_$0_», «$2»)»,
			«_$0(«$1», «_$0_»)»,
			«m4_popdef(«_$0_»)»,
		)»)
