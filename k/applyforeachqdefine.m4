
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
		
m4_TEST(«m4_applyforeachqdefine(«««1», «2»», ««3», «4»»», «one=$1 two=$2», «,»)»)
// PASS_REGULAR_EXPRESSION one=1 two=2,one=3 two=4
m4_TEST(«m4_applyforeachqdefine(«a, b», «>>$1<<»)»)
// PASS_REGULAR_EXPRESSION >>a<<>>b<<
