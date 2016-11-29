//SYEDA SHAH


open util/ordering[Step]
sig Step{}
/**
 *	Fields and Date atoms used for scheduling games.
 */
some sig Field{}
some sig Date{}

/**
 * Scheduled games take place on a field on a given date.
 */
some sig Game {
	where : Field -> Step,
	when	: Date -> Step
}

/**
 * There is one field complex with a schedule of games.
 */
one sig FieldComplex {
	schedule : Game -> Step
}

/**
 * Games *not* on the schedule have no associated field
 * or date.
 */
pred NotOnSchedule_NoFieldNoDate[st: Step]{
	all g : Game - FieldComplex.schedule.st | no g.where.st && no g.when.st
}

/**
 * Games that *are* on the schedule have one field and one
 * date.
 */
pred OnSchedule_HaveFieldAndDate[st: Step]{
	all g : FieldComplex.schedule.st | one g.where.st && one g.when.st
}

/**
 * Games on the same field are scheduled for
 * different dates.
 */
pred SameFieldMeansDifferentDate[st: Step] {
	all disj g1, g2 : FieldComplex.schedule.st {
		g1.where.st = g2.where.st => g1.when.st != g2.when.st
	}
}

/**
 * Find solutions where at least one game is on
 * the schedule with a date. Note that 'some when'
 * implies 'some where' and 'some schedule' in order to
 * adhere to the facts.
 */
/*

/**
 * Find solutions where at least one game is NOT on
 * the schedule with a date.
 */
/**
pred UnscheduledGame[st: Step]{
	some g : Game | g !in FieldComplex.schedule.st
}*/

// Invariant has all the predicates
pred Invariant[st: Step]{
	NotOnSchedule_NoFieldNoDate[st]
	OnSchedule_HaveFieldAndDate[st]
	SameFieldMeansDifferentDate[st] 
}

pred init[st: Step]{
	no where.st && no when.st
	no schedule.st
}


assert init_closed{
	init[first] => Invariant[first]
}

check init_closed for 5 but 1 Step

pred init_exists{
	some st: Step | init[st]

}

run init_exists for 5 but exactly 1 Step



// Operations
pred scheduleGame[g : Game, f : Field, d : Date, st : Step] {
	// The new game is not currently scheduled
	g not in FieldComplex.schedule.st


	// No other games are scheduled on the requested field and date.
	all a : Game |f != a.where.st and d != a.when.st	=> FieldComplex.schedule.st =a

	// The operation completes with the new game scheduled and being specifically assigned the 
	// field and date requested.
	

	// Nothing else about the schedule or the other games is affected.
	let st2 = next[st]{
		all g2: Game - g {
			g2.when.st2 = g2.when.st
			g2.where.st2 = g2.where.st
		}
		g.where.st2 = f
		g.when.st = d
		FieldComplex.schedule.st2 = FieldComplex.schedule.st + g
	}
}


/*********************************************************************/


assert scheduleGame_closed {
	all g : Game, f : Field, d : Date, st : Step {
		Invariant[st] && scheduleGame[g, f, d, st] =>
			Invariant[next[st]]
	}
}
check scheduleGame_closed for 6 but 2 Step

pred scheduleGame_exists {
	some g : Game, r : Field, t : Date, st : Step {
		Invariant[st]
		scheduleGame[g, r, t, st]
	}
}
run scheduleGame_exists for 6 but 2 Step


pred cancelGame[g : Game, st : Step] {
	let st' = next[st] {
		all ge : Game - g {
			ge.when.st' = ge.when.st
			ge.where.st' = ge.where.st
		}
		no g.where.st'
		no g.when.st'
		FieldComplex.schedule.st' = FieldComplex.schedule.st - g
	}
}

assert cancelGame_closed {
	all g : Game, st : Step {
		Invariant[st] && cancelGame[g, st] =>
			Invariant[next[st]]
	}
}
check cancelGame_closed for 6 but 1 Step

pred cancelGame_exists {
	some g : Game, st : Step {
		Invariant[st]
		cancelGame[g, st]
	}
}
run cancelGame_exists for 5 but 1 Step

pred rescheduleGame[g : Game, f : Field, st : Step]{
	g in FieldComplex.schedule.st

	all ge : Game {
		(ge.when.st = g.when.st) => (ge.where.st != f) 
		(ge.where.st = f) => (ge.when.st != g.when.st)
	}

	let st' = next[st]{
		all ge : Game - g{ //
			ge.when.st' = ge.when.st
			ge.where.st' = ge.where.st
		}
		g.when.st' = g.when.st
		g.where.st' = f 

		FieldComplex.schedule.st' = FieldComplex.schedule.st
	}
}

assert reschedGame {
	all g : Game, f : Field, st : Step {
		Invariant[st] and rescheduleGame[g, f, st] =>
			Invariant[next[st]]
	}
}

check reschedGame for 6 but 1 Step

pred rescheduleGame_exists{
	some g: Game, f:Field, st:Step{
		Invariant[st]
		rescheduleGame[g,f,st]
	}
}

run rescheduleGame_exists for 6 but 1 Step
