
m4_define(«m4_shift2», «m4_shift(m4_shift($@))»)
m4_define(«m4_shift3», «m4_shift(m4_shift(m4_shift($@)))»)
m4_define(«m4_shift4», «m4_shift(m4_shift(m4_shift(m4_shift($@))))»)
m4_define(«m4_shift5», «m4_shift(m4_shift(m4_shift(m4_shift(m4_shift($@)))))»)

m4_define(«m4_argn»,
	«m4_ifelse(
		«$1», 1, ««$2»»,
  		«m4_argn(m4_decr(«$1»), m4_shift(m4_shift($@)))»)»)

m4_define(«m4_if», «m4_ifelse(«$@»)»)

m4_define(«m4_case»,
		«m4_ifelse(
			«$#», 0, «»,
			«$#», 1, «»,
			«$#», 2, «$2»,
			«$1», «$2», «$3»,
			«$0(«$1», m4_shift(m4_shift(m4_shift($@))))»)»)

m4_define(«m4_casearg»,
		«m4_case(
			m4_shift($@),
			«m4_fatal(«$1: invalid number of arguments: $2»)»)»)

/**
 * Just ignore the arguments.
 */
m4_define(«m4_ignore», «»)

/**
 * Just ignore the arguments.
 * Used for commenting code.
 */
m4_define(«m4_ign», «»)

m4_define(«m4_I», «»)

/**
 * Expand to each argument.
 */
m4_define(«m4_do», «$1«»$2«»$3«»$4«»$5«»$6«»$7«»$8«»$9»)

/** concatenate all arguments */
m4_define(«m4_cat», «$1$2$3$4$5$6$7$8$9»)

m4_define(«m4_rshift»,
		«m4_ifelse(
			«$#», 0, «»,
			«$#», 1, «»,
			«$#», 2, «$1»,
			«$1,$0(m4_shift($@))»)»)
m4_test(«m4_rshift(1,2,3)», «1,2»)

/** ignore last argument and call first argument with the rest of arguments */
m4_define(«m4_call», «$1(m4_rshift(m4_shift($@)))»)

/** like m4_elseif, but ignore last argument */
m4_define_function(«m4_ifcall», «m4_call(«m4_ifelse», $@)»)
m4_test(«m4_ifcall(1, 1, 1, 2, 2, 2, 3, )», «1»)

/** reverse list of arguments */
m4_define(«m4_reverse»,
		«m4_ifelse(
			«$#», «0», «»,
			«$#», «1», ««$1»»,
			«m4_reverse(m4_shift($@)),«$1»»)»)

/** a newline */
m4_define(«m4_nl», «
»)
