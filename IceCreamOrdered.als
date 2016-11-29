/*
 * Persons are ordered, so there is a first, second, etc.
 * The ordering represents their position in the waiting line.
 * po/first is the person to be served next.
 */
open util/ordering[Person] as po

/*
 * Each person has a scoop of ice cream they want on their cone.
 */
abstract sig Person {
	scoop : IceCream /// name of a field in person of type icecream
}

/*
 * The names of the four girls ordering ice cream.
 */
one sig Bridget, Glenda, Patricia, Viola extends Person{}

/*
 * The four types of ice cream the girls want.
 */
enum IceCream {Cherry, Coconut, Peppermint, Vanilla}
//p in Person
/*
 * Four helper functions to indicate the first through
 * fourth girl in line.
 */
fun firstP : Person {
	po/first
}

fun secondP : Person {
  next[firstP] ///
}

fun thirdP : Person {
  next[secondP]
}

fun fourthP : Person {
  next[thirdP]
}

/*
 * No two girls want the same flavor ice cream, and all
 * flavors are wanted by one of the girls.
 */
fact OneToOne {
	Person.scoop = IceCream
}

/*
 * Fact #1
* The second person in line is either Glenda or the person who ordered a scoop of Peppermint
 */
fact F1 {
secondP= Glenda or secondP.scoop=Peppermint
}

/*
 * Fact #2
 * The four customers are exactly:
*     a. The second person in line,  
*     b. Glenda, 
*     c. Bridget and 
*     d. The person who ordered a Vanilla scoop.
 */
fact F2 {
//Glenda != secondP
//Bridget != secondP
//scoop.Vanilla != secondP
//Glenda.scoop != Vanilla
//Bridget.scoop != Vanilla

Person = secondP + Glenda + Bridget + scoop.Vanilla
}

/*
 * Fact #3
*  Viola was 2 spots in line behind the person who ordered a scoop of Coconut
 */
fact F3 {
Viola  != firstP
Viola != secondP 
}

/*
 * Fact #4
*  Glenda ordered a scoop of Cherry ice cream
 */
fact F4 {
	Glenda = scoop.Cherry
//Glenda.scoop= Cherry
}

/*
 * Run command - correct facts lead to a unique solution.
 */
run {} for 4

