
m4_define(«m4_basename», «m4_patsubst(«$1», «^.*/»)»)

m4_define(«m4_dirname», «m4_patsubst(«$1», «\/[^\/]*$»)»)

/**
 * @return The filename from __file__
 */
m4_define(«m4_filename», «m4_basename(m4___file__)»)

m4_define_function(«m4_write», «m4_syscmd(«printf "%s" »m4_shquote(«$2»)« > »m4_shquote(«$1»)»)

m4_define_function(«m4_append», «m4_syscmd(«printf "%s" »m4_shquote(«$2»)« >> »m4_shquote(«$1»)»)

m4_define_function(«m4_read», «m4_erun(«cat», «$1»)»)

