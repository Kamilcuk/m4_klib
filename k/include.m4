
m4_define(«m4_include_quiet», «m4_divert(-1)m4_include(«$@»)m4_divert(0)»)

m4_define_function(«m4_include_relative», «m4_include(m4_patsubst(m4___file__, «/«^/»*$»)/$1)»)

m4_define_function(«m4_include_relative_quiet», «m4_divert(-1)m4_include_relative(«$@»)m4_divert(0)»)

m4_define_function(«m4_included», «()»)

m4_define_function(«m4_include_once(file)»,
	«m4_ifcall(
		m4_tuple_has(m4_included, «$1»), «1», «m4_fatal(«file $1 included twice»)»,
		«m4_do(
			«m4_define(«m4_included», m4_tuple_push_back(m4_included, «$1»))»,
			«m4_include(«$1»)»,
		)»,
	)»)
