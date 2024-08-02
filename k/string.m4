

m4_define_function(«m4_ifmath(expr, true, false)»,
	«m4_ifelse(m4_eval(«$1»), 0, «$3», «$2»)»)

m4_define_function(«m4_ifregex(str, rgx, true, false)»,
	«m4_ifelse(m4_regexp(«$1», «$2»), -1, «$4», «$3»)»)

m4_define_function(«m4_ifsubstr(str, needle, true, false)»,
	«m4_ifelse(m4_index(«$1», «$2»), -1, «$4», «$3»)»)

m4_define(«m4_regexquote», «m4_patsubst(«$@», «[]\/$*.^[]», «\&»)»)

/** m4_quote(args) - convert args to single-quoted string */
m4_define(«m4_quote», «m4_ifelse(«$#», «0», «», ««$*»»)»)
m4_test(«m4_quote(a)», ««a»»)

/** m4_dquote(args) - convert args to quoted list of quoted strings */
m4_define(«m4_dquote», ««$@»»)

/** m4_dquote_elt(args) - convert args to list of double-quoted strings */
m4_define(«m4_dquote_elt», «m4_ifelse(«$#», «0», «», «$#», «1», «««$1»»»,
                             «««$1»»,$0(m4_shift($@))»)»)

/**
 * split string on spaces
 */
#define m4_split(str)
#define m4_split(str, rgx)
m4_define(«m4_split»,
	«m4_ifelse(
		«$#», «0», «»,
		«$#», «1», «$0(«$1», « »m4_nl)»,
		«$#», «2», «m4_patsubst(
				m4_patsubst(
					«$1»,
					«[$2]*\([^$2]+\)[$2]*»,
					««««\1»»,»»),
				«,$»)»,
		«m4_fatal(«invalid arguments to $0»)»)»)
m4_test(«m4_split(«a b    c»)», «««a»,«b»,«c»»»)

m4_define(«m4_splitlines», «m4_split(«$1», m4_nl)»)
m4_test(«m4_splitlines(«a
  b
c»)», «««a»,«  b»,«c»»»)

/**
 * join each ARG, excluding empty lines
 */
#define m4_join(sep, ...)
m4_define(«m4_join»,
	«m4_ifelse(
		«$#», «2», ««$2»»,
		«ifelse(«$2», «», «», ««$2»_»)$0(«$1», m4_shift(m4_shift($@)))»)»)
m4_define(«_m4_join»,
	«m4_ifelse(«$#$2», «2», «»,
		«m4_ifelse(«$2», «», «», ««$1$2»»)$0(«$1», m4_shift(m4_shift($@)))»)»)

/**
 * join each ARG, including empty ones,
 * into a single string, with each element separated by SEP
 */
#define m4_joinall(sep, ...)
m4_define(«m4_joinall», ««$2»_$0(«$1», m4_shift($@))»)
m4_define(«_m4_joinall», «m4_ifelse(«$#», «2», «», ««$1$3»$0(«$1», m4_shift(m4_shift($@)))»)»)

/**
 * The m4_chop macro (based on perl's chop command) returns the
 * input string minus its final character. m4_chop is useful for
 * removing "\n" from m4_esyscmd strings.
 */
#define m4_chop(string)
m4_define(«m4_chop», «m4_substr($1, 0, m4_decr(m4_len($1)))»)

/** like python rstrip */
m4_define_function(«m4_rstrip(str)», «m4_patsubst(«$1», «\s*$»)»)

/** like python lstrip */
m4_define_function(«m4_lstrip(str)», «m4_patsubst(«$1», «^\s*»)»)

/** like python strip */
m4_define_function(«m4_strip(str)», «m4_rstrip(m4_lstrip(«$1»))»)
m4_test(«m4_strip(«   a   b   »)», «a   b»)

/** like python string.count */
m4_define(«m4_count», «m4_len(m4_patsubst(«$1», «[^$2]*»))»)
m4_test(«m4_count(«abacadef», «a»)», «3»)

/** count newlines in a string */
m4_define(«m4_count_lines», «m4_count(«$@», m4_nl)»)
m4_test(«m4_count_lines(«ab
			de
			ef
			»)», «3»)

m4_define_function(«m4_rindex(str, needle)»,
		«m4_ifelse(
			m4_index(«$1», «$2»), -1, -1,
			«m4_decr(m4_len(m4_patsubst(«$1», «^\(\(.*$2\)+\).*», ««\1»»)))»)»)
m4_define_function(«_m4_rindex(pos, str, needle)»,
		«m4_ifelse(
			m4_eval(«$1 < 0»), «1», «-1»,
			m4_substr(«$2», «$1», m4_len(«$3»)), «$3», «$1»,
			«$a0(m4_decr(«$1»), «$2», «$3»)»)»)
m4_test(«m4_rindex(«abc», «b»)», «1»)
m4_test(«m4_rindex(«)», «)»)», «0»)
m4_test(«m4_rindex(«,,,,», «,»)», «3»)
m4_test(«m4_rindex(«abc», «d»)», «-1»)
m4_test(«m4_rindex(«abc», «c»)», «2»)
m4_test(«m4_rindex(«abc», «a»)», «0»)
m4_test(«m4_rindex(«a,b,c», «b»)», «2»)
m4_test(«m4_rindex(«a,b,c», «d»)», «-1»)
m4_test(«m4_rindex(««a(a»», ««»»)», «-1»)

m4_define(«m4_strupper», «translit(«$*», «a-z», «A-Z»)»)
m4_define(«m4_strlower», «translit(«$*», «A-Z», «a-z»)»)
m4_define(«_m4_capitalize», «m4_regexp(«$1», «^\(\w\)\(\w*\)», «m4_strupper(«\1»)»«m4_strlower(«\2»)»)»)
m4_define(«m4_capitalize», «patsubst(«$1», «\w+», «_$0(«\&»)»)»)
