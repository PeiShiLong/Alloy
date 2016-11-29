//Justin Liu
//R2 Sports Complex Scheduler

/*
* Add the ordered Step signature, and make the relations schedule,when,where step-variant.
*/
open util/ordering[Step]
sig Step{}

sig Field{}

sig Date{}

/*
* A Game is associated with a Field (where) and Date (when)
*/
sig Game{
	where : Field -> Step,
	when :  Date -> Step
}

/*
* Exactly one FieldComplex is associated with a schedule of zero or more Game
*/
one sig FieldComplex{
	schedule : Game -> Step
}

--------------------------------------Facts to Invariant (8 points)-------------------------------------------------
/*
* Change all the facts in the static model to predicates with a Step argument. 
*/

/*
* Games *not* on the schedule have no associated field or date.
*/
pred NotOnSchedule[st : Step]{
	all g : Game - FieldComplex.schedule.st | no g.where.st && no g.when.st
}

/*
* Games that *are* on the schedule have one field and one date.
*/
pred OnSchedule[st : Step]{
	all g :  FieldComplex.schedule.st | one g.where.st && one g.when.st
}

/*
* Games on the same field are scheduled for different dates.
*/
pred SameField[st : Step]{
	all disj g1, g2 : FieldComplex.schedule.st {
		g1.where.st = g2.where.st => g1.when.st != g2.when.st
	}
}

/*
* at least one Game is on the FieldComplex schedule with a Date and Field.
*/
//pred ScheduledGame[st : Step]{
	//some FieldComplex.schedule
//	some when.st
//}

/*
* at least one Game is not scheduled.
*/
//pred UnscheduledGame[st : Step]{
//	some g : Game | g !in FieldComplex.schedule.st
//}

/*
* Create a predicate Invariant with a Step argument that is the conjunction of all the facts-turned-predicates.
*/

pred Invariant[st : Step] {
		NotOnSchedule[st]
		OnSchedule[st]
		SameField[st]
}
-----------------------------------Initialization (12 points)-------------------------------------------------
/*
* In the initial state there are no games scheduled. There are consequences for games that must also be explicitly addressed.
*/
pred init[st : Step]{
	no schedule.st
	no when.st
	no where.st
}

assert init_closed {					
	init[first] => Invariant[first]	
}
check init_closed for 5 but 1 Step

/*
* Define and run an appropriate init_exists predicate.
*/
pred init_exists{
	Invariant[first]
	init[first]
}
run init_exists for 5 but exactly 1 Step



