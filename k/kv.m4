/**
 * Get a key from a space separated list of k=v.
 */
m4_define_function(«m4_kv_get(data, key, default)»,
		«_$0(m4_regexp(« $1 », « $2=\([^ ]*\) », «\1»), «$3»)»)
m4_define_function(«_m4_kv_get(res, default)»,
		«m4_ifelse(«$1», «», «$2», «$1»)»)
m4_test(«m4_kv_get(a=1 b=2 c=3, c)», «3»)
m4_test(«m4_kv_get(a=1 b=2, c)», «»)
m4_test(«m4_kv_get(a=1 b=2, c, default)», «default»)

/**
 * Expand to 1 if kv has they key, to zero otherwise.
 */
m4_define_function(«m4_kv_has(data, key)»,
		«m4_ifelse(m4_regexp(« $1 », « $2=»), -1, 0, 1)»)
m4_test(«m4_kv_has(a=1 b=2 c=3, c)», «1»)
m4_test(«m4_kv_has(a=1 b=2, c)», «0»)

/**
 * If kv contains the key, expand the true_expression as a function with the first argument they key value.
 * Expand to false_expression otherwise.
 */
m4_define_function(«m4_kv_map(data, key, true_expression, false_expression)»,
		«m4_do(
			«m4_pushdef(«_$0_», m4_ifelse(m4_kv_has(«$1», «$2»), 1, «$3», «$4»))»,
			«_$0_(m4_kv_get(«$1», «$2»))»,
			«m4_popdef(«_$0_»)»,
		)»)
m4_test(«m4_kv_map(a=1 b=2 c=3, c, «C is equal to $1», «C was not found»)», «C is equal to 3»)
m4_test(«m4_kv_map(a=1 b=2, c, «C is equal to $1», «C was not found»)», «C was not found»)
