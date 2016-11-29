/* Marriage - Part 1 */

sig Name{}

/* Create an abstract signature (much like an abstract O-O class)
*  to represent Male and Female instances of Person.
* 	All instances of Person have a relation to exactly one Name
*/
abstract sig Person{
	name: one Name
}

sig Male extends Person{}
sig Female extends Person{}


/* Married is a subset (in) of Person meaning that a Married instance
*	will also be in Male or Female
*  Married as a relational field spouse, the exactly one Married person to
*  whom they are married to and zero or more (set) children.
*/
sig Married in Person{
	spouse: one Married
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

/* Marriage is symmertical 
*/
fact{
	spouse = ~spouse
}

run{
	#Male > 2
	#Female > 2
	#Married < 5
}for 7
