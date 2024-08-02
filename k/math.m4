
m4_define_function(«m4_max(number, ...)»,
	«m4_ifelse(
		«$#», «0», «»,
		«$#», «1», «$1»,
		«$#», «2»,
			«m4_ifelse(
				«$2», «», «$1»,
				«m4_ifmath(«$1 > $2», «$1», «$2»)»)»,
		«$0($0($1, $2), m4_shift(m4_shift($@)))»)»)


m4_define_function(«m4_min(number, ...)»,
	«m4_case(«$#»,
		«0», «»,
		«1», «$1»,
		«2», «m4_ifmath(«$1 < $2», «$1», «$2»)»,
		«$0($0($1, $2), m4_shift(m4_shift($@)))»)»)
