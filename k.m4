m4_divert(-1)

m4_changequote(,)
m4_changequote(«, »)
m4_changecom(«/*», «*/»)
m4_define(«dnl», «m4_dnl»)

m4_include(k/define_name.m4)
m4_include(k/define_function.m4)
m4_include(k/assert.m4)
m4_include(k/basic.m4)
m4_include(k/string.m4)
m4_include(k/math.m4)
m4_include(k/args.m4)
m4_include(k/tuple.m4)
m4_include(k/kv.m4)
m4_include(k/forloop.m4)
m4_include(k/forloopdash.m4)
m4_include(k/seq.m4)
m4_include(k/tuples.m4)
m4_include(k/foreach.m4)
m4_include(k/subprocess.m4)
m4_include(k/path.m4)
m4_include(k/include.m4)
m4_include(k/sync.m4)

m4_define(«m4_map», «m4_tuples_map_define_nested(«$@»)»)

m4_divert(0)m4_dnl

m4_divert(-1)
m4_define(«funcs», «(
  (),
  (d, «int fd, »),
  (f, «FILE *file, »),
  (s, «char *buf, »),
  (a, «char **buf, »),
)»)

m4_define(«prefix», «( (), (n, «size_t n, ») )»)

m4_define(«suffix», «( ( , «, ...»), (v, «, va_args *va») )»)

m4_define(«locale», «( (), (_l, «, locale_t») )»)
m4_divert(0)

## SYNOPSIS

m4_tuples_longest(funcs)
m4_map(funcs, «$1 $2»)

```
m4_map(funcs, «
  m4_map(prefix, «
    m4_map(suffix, «
      m4_map(locale, «
int y_$5$1$3print$8($2$4const char *restrict fmt$7$6);
    -»)
»)
»)
»)
```
