/* Marriage - Part 2, add Children */

sig Name{}

/* Create an abstract signature (much like an abstract O-O class)
*  to represent Male, Children and Female instances of Person.
* 	All instances of Person have a relation to exactly one Name
*/
abstract sig Person{
	name: one Name
}

sig Male extends Person{}
sig Female extends Person{}
sig Children in Person{}


/* Married is a subset (in) of Person meaning that a Married instance
*	will also be in Male or Female
*  Married has a relational field spouse, the exactly one Married person to
*  whom they are married to and zero or more (set) children.
*/
sig Married in Person{
	spouse: one Married,
	child: set Children
}

/*--------------------FACTS -----------------------------------------------*/

/*  No two people can have the same name
*/
fact UniqueName{ 
	all disjoint p1, p2 : Person | no p1.name & p2.name
}

/*  If male, must be married to a female & visa versa
*/
fact PCMarriage{
	all m : Married | (m in Male => m.spouse in Female) and
							   (m in Female => m.spouse in Male)
}

/* Can't share spouses
*/
fact NoSharing{
	all disjoint m1, m2 : Married | no m1.spouse & m2.spouse
}

/* Marriage is symmetrical */
fact{
	spouse = ~spouse
}

/* If you are married, your child cannot be your spouse
*/
fact No_Child_Marriage{
	all m1 : Married | no m1.child & m1.spouse
	all m : Married | m.spouse not in Children and m not in Children
}

/* If married, both partners have the same set of Children
*/
fact SameChild{
	all m : Married | m.child = m.spouse.child
}

/* All childen belong to some marriage - Note transpose navigation (~)
*/
fact NoOrphans{
    all c : Children | some c.~child
}

/* Assertion looks for counterexamples given a predicate
*/
assert No_Child{
	all m2 : Married | m2.spouse not in m2.child
}
check No_Child


run{
	#Children > 0
	#Male > 2
	#Female > 2
	#Married < 5
}for 7
