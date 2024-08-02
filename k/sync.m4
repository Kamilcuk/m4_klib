
/**
 * Synchronize the lines.
 * @param inc Increment the current line number by this value.
 */
#define m4_syncline_in(inc)
m4_define_function(«m4_syncline_in»,
«#line AA m4_eval(m4___line__ m4_ifelse(«$1», «», «», « + $1»)) "m4___file__"
»)

/**
 * Same as m4_syncline_in, but expands to nothing if not debug.
 * @see m4_syncline_in
 * @param inc
 */
#define m4_syncline(inc)
m4_define_function(«m4_syncline», «m4_ifdef(«M4_DEBUG», «m4_syncline_in($@)»)»)

#define m4_syncline_dnl(inc)
m4_define_function(«m4_syncline_dnl», «m4_syncline($@)m4_dnl »)

m4_define(«m4_sync»,
«#line m4_eval($2 + m4___line__) "m4___file__"m4_ifelse(«$1», «», «», «$1
#line m4_eval($2 + m4___line__ + m4_count_lines(«$1»)) "m4___file__"
»)»)

m4_define(«m4_syncdivert», «m4_divert(m4_ifelse($#, 0, 0, $@))m4_sync(,1)m4_dnl»)
