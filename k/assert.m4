
/**
 * @param message Message to print.
 * @param ... List of any arguments to print
 * @ingroup m4
 * @brief Just print an error and exits m4 with an error.
 */
#define m4_fatal(message, ...)
m4_define(«m4_fatal», «m4_errprint(m4___file__:m4___line__«: error: $*
»)m4_m4exit(«1»)»)

m4_define_function(«m4_assert_fail(expr1, expr2, str1, str2, ...)»,
	«m4_fatal(
«ASSERTION FAILED: $5$6$7$8$9
  "$3" != "$4"
  "$1" != "$2"
»)»)

m4_define(«m4_assert_quote», «m4_ifelse(«$#», «0», «», ««$*»»)»)

m4_define_function(«_m4_assert(expr1, expr2, str1, str2, ...)»,
	«m4_ifelse(«$1», «$2», «», «m4_assert_fail($@)»)»)
m4_define(«m4_assert», «_m4_assert($1, $2, $@)»)

m4_define_function(«_m4_assert_not(expr1, expr2, str1, str2, ...)»,
	«m4_ifelse(«$1», «$2», «m4_assert_fail($@)»)»)
m4_define_function(«m4_assert_not», «_$0($1, $2, $@)»)

/**
 * If M4_TEST is defined, check if a is equal to b.
 * Otherwise expand to nothing.
 */
m4_define_function(«m4_test(a, b)», «»)
m4_ifdef(«M4_TEST», «m4_define(«m4_test», «_m4_test_in(($1), ($2), $@)»)»)
m4_define(«_m4_test_in», «m4_errprint(m4___file__:m4___line__«: CHECK "$3" -> "$1" == "$2"
»)_m4_assert($@)»)
m4_test(«a», «a»)
m4_test(«m4_patsubst(«a», «a», «\&b»)», «ab»)
