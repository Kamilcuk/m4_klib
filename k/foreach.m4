/**
 * m4_foreach(x, (item4_1, item4_2, ..., item4_n), stmt)
 *
 * https://www.gnu.org/software/m4/manual/m4-1.4.14/html_node/Foreach.html
 */
#define m4_foreach(iterator, braces_item4_list, statement)
m4_define(«m4_foreach», «m4_pushdef(«$1»)_m4_foreach($@)m4_popdef(«$1»)»)
m4_define(«_m4_foreach_arg1», «$1»)
m4_define(«_m4_foreach», «m4_ifelse(«$2», «()», «»,
  «m4_define_name(«$1», _m4_foreach_arg1$2)$3«»$0(«$1», (m4_shift$2), «$3»)»)»)

/**
 * @ingroup m4
 * @param macro A macro name to apply arguments to
 * @param argslist A list og macro arguments in the form of
 * «((arg1, arg2, ...), (args1, arg2, ...), ...)».
 * Remember to qoute it!!
 * @param separator An optional separator to separate elements.
 *
 * Apply macro on arguments in brackets.
 * The list of arguments is shifted and is applied on each argument.
 * Example:
 *     m4_define(«m4_func», «>1=$1 2=$2 3=$3<») m4_applyforeach(«m4_func», «((«a», «b», «c»), («d», «e», «f»), («g», «h», «i»))», « % »)
 * would output:
 *    >1=a 2=b 3=c< % >1=d 2=e 3=f< % >1=g 2=h 3=i<
 */
#define m4_applyforeach(macro, args, separator)
m4_define(«_m4_applyforeach_arg1», «$1»)
m4_define(«_m4_applyforeach_cat», «$1$2»)
m4_define(«_m4_applyforeach_separator», «m4_ifelse(«$2», «()», «», «$1»)»)
m4_define(«m4_applyforeach», «m4_ifelse(«$2», «()», «»,
    «_m4_applyforeach_cat(
    	«$1»,
    	_m4_applyforeach_arg1$2)_m4_applyforeach_separator(
    		«$3»,
    		(m4_shift$2))m4_applyforeach(
    			«$1»,
    			(m4_shift$2),
    			«$3»)»)»)
m4_test(
		«m4_define(«m4_func», «>1=$1 2=$2 3=$3<»)m4_applyforeach(«m4_func», «((«a», «b», «c»), («d», «e», «f»), («g», «h», «i»))», « % »)»,
		«>1=a 2=b 3=c< % >1=d 2=e 3=f< % >1=g 2=h 3=i<»)
m4_test(
		«m4_define(«m4_func», «@$1<»)m4_applyforeach(«m4_func», «((bar), (foo))», «:»)»,
		«@bar<:@foo<»)
m4_test(
		«m4_define(«m4_func», «@$1<»)m4_applyforeach(«m4_func», «((bar), (foo),)», «:»)»,
		«@bar<:@foo<»)

/**
 * @ingroup m4
 *
 * Example:
 *
 *     m4_applyforeachdefine(«((1, 2), (3, 4))», «one=$1 two=$2 »)
 */
#define m4_applyforeachdefine(bracket_list, function_body, separator)

m4_define(«m4_applyforeachdefine»,
		«m4_pushdef(
			«_$0_function»,
			«$2»)m4_applyforeach(
				«_$0_function»,
				«$1»,
				«$3»)m4_popdef(
					«_$0_function»)»)

m4_test(
		«m4_applyforeachdefine(«((1, 2), (3, 4))», «one=$1 two=$2», «,»)»,
		«one=1 two=2,one=3 two=4»)
m4_test(
		«m4_applyforeachdefine(«((1, 2), (3, 4),)», «one=$1 two=$2», «,»)»,
		«one=1 two=2,one=3 two=4»)

/**
 * @ingroup m4
 *
 * Apply macro on quoted list
 * Example:
 *    m4_define(«m4_func», «>1=$1 2=$2 3=$3<
 *    »)
 *    m4_applyforeachq(«m4_func», «««a», «b», «c»», ««d», «e», «f»», ««g», «h», «i»»»)
 * would result in:
 *    >1=a 2=b 3=c<
 *    >1=d 2=e 3=f<
 *    >1=g 2=h 3=i<
 */
#define m4_applyforeachq(function, qouted_list, separator)
m4_define(«_m4_applyforeachq_arg1», «$1»)
m4_define(«_m4_applyforeachq_cat», «_m4_applyforeachq_arg1($@)(m4_shift($@))»)
m4_define(«_m4_applyforeachq_quote», «m4_ifelse(«$#», «0», «», ««$*»»)»)
m4_define(«_m4_applyforeachq_separator», «m4_ifelse(m4_eval(«$# > 2»), «1», «$1», «»)»)
m4_define(«m4_applyforeachq», «m4_ifelse(
		_$0_quote($2),
		«»,
		«»,
		«_$0_cat(
				«$1»,
				_$0_arg1($2))_$0_separator(
						«$3»,
						$2)«»$0(
								«$1»,
								«m4_shift($2)»,
								«$3»)»)»)
m4_test(«m4_define(«m4_func», «>1=$1 2=$2 3=$3<»)m4_applyforeachq(«m4_func», «
		a,
		d,
		g»)»,
		«>1=a 2= 3=<>1=d 2= 3=<>1=g 2= 3=<»)
m4_test(«m4_define(«m4_func», «>1=$1 2=$2 3=$3<»)m4_applyforeachq(«m4_func», «
		z,
		x,
		y», « % »)»,
		«>1=z 2= 3=< % >1=x 2= 3=< % >1=y 2= 3=<»)
m4_test(«m4_define(«m4_func», «>1=$1 2=$2 3=$3<»)m4_applyforeachq(«m4_func», ««1», «2», «3»», « % »)»,
		«>1=1 2= 3=< % >1=2 2= 3=< % >1=3 2= 3=<»)
m4_test(«m4_define(«m4_func», «>1=$1 2=$2 3=$3<»)m4_dnl
m4_applyforeachq(«m4_func», «««a», «b», «c»», ««d», «e», «f»», ««g», «h», «i»»», « % »)»,
	«>1=a 2=b 3=c< % >1=d 2=e 3=f< % >1=g 2=h 3=i<»)


/**
 * @ingroup m4
 *
 * Example:
 *
 *     m4_applyforeachqdefine(«««1», «2»», ««3», «4»»», «one=$1 two=$2 »)
 */
#define m4_applyforeachqdefine(qouted_list, function_body, separator)

m4_define(«m4_applyforeachqdefine», «m4_pushdef(
	«_$0_function»,
	«$2»)m4_applyforeachq(
		«_$0_function»,
		«$1»,
		«$3»)m4_popdef(
			«_$0_function»)»)

m4_test(«m4_applyforeachqdefine(«««1», «2»», ««3», «4»»», «one=$1 two=$2», «,»)», «one=1 two=2,one=3 two=4»)
m4_test(«m4_applyforeachqdefine(«a, b», «>>$1<<»)», «>>a<<>>b<<»)

/**
 * @ingroup m4
 */
#define m4_applyforloop(...)
m4_define(«m4_applyforloop», «m4_forloop(
	«_m4_applyforloop_iterator»,
	«$1»,
	«$2»,
	«$3(_m4_applyforloop_iterator)»,
	«$4»)»)
m4_test(«m4_define(«m4_func», «m4_forloop(«J», 1, $1, «@$1, J%»)»)m4_applyforloop(1, 4, «m4_func»)»,
		«@1, 1%@2, 1%@2, 2%@3, 1%@3, 2%@3, 3%@4, 1%@4, 2%@4, 3%@4, 4%»)

/**
 * @def m4_applyforloopdefine(start_range, end_range, function_body, separator)
 * @ingroup m4
 * @param start_range A number to start counting from, inclusive.
 * @param end_range A number to end counting on, inclusive.
 * @param function_body The body of a function to call. $1 will be substituted for the number
 * @param separator An optional separator to call.
 *
 * Defines a temporary function with the function body passed
 * as a paremeter. Generates numbers from start_range to end_range
 * and passes the numbe as the first (and only) argument of the
 * defined function. Optionally non-empty separator can be used
 * to separate elements.
 */
#define m4_applyforloopdefine(start_range, end_range, function_body, separator)

m4_define(«m4_applyforloopdefine», «m4_pushdef(
	«_$0_function»,
	«$3»)m4_forloop(
		«_$0_iterator»,
		«$1»,
		«$2»,
		«_$0_function(_$0_iterator)»,
		«$4»)m4_popdef(
			«_$0_function»)»)

m4_test(«m4_applyforloopdefine(1, 3, «arg=$1», « S »)», «arg=1 S arg=2 S arg=3»)
m4_test(«m4_applyforloopdefine(1, 3, «ARG=$1 »)», «ARG=1 ARG=2 ARG=3 »)
m4_test(
		«m4_define(«m4_func», «cnt=$1»)m4_I(
		)m4_applyforloopdefine(1, 3, «m4_applyforloop(1, $1, «m4_func», «,»)», « S »)»,
		«cnt=1 S cnt=1,cnt=2 S cnt=1,cnt=2,cnt=3»)
