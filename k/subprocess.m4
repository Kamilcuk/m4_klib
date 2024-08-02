
m4_define_function(«m4_erun», «m4_esyscmd(m4_shquote($@))»)

m4_define_function(«m4_run», «m4_syscmd(m4_shquote($@))»)

/**
 * @brief Quote the argument according to the shell.
 */
#define m4_shqoute(...)
m4_define(«m4_shquote»,
		«m4_ifelse(
			«$#», 0, «»,
			«$#», 1, «'m4_patsubst(«$1», «'», «'\\''»)'»,
			«m4_shquote(«$1») m4_shquote(m4_shift($@))»)»)
m4_test(«m4_shquote(a)», «'a'»)
m4_test(«m4_shquote(a, b c, d)», «'a' 'b c' 'd'»)

m4_define(«m4_shsplit_sh»,
	«m4_patsubst(
		m4_esyscmd(«printf "%s" »m4_shquote($1)« | xargs printf "«««%s»»,»"»),
		«,$»)»)
