module PoliceLineup

// Persons are ordered left to right - the first person is at position A and
// the last person is at position E. Since we order the persons, we don't need
// a specific signature to represent positions.

open util/ordering[Person] as po

enum Job { Taxidermist, Undertaker, Teacher, BusDriver, ConMan }
enum FirstName { Ewan, Donald, Alf, Brian, Charles }
enum LastName { Jackson, Grady, Ibbotson, Frost, Howard }

sig Person {
	fn : FirstName,
	ln : LastName,
	job : Job
}

// Useful "helper" functions.
// Find the person to the left or right of a given person.
// Find the person at a given position (A to E).

fun left[p : Person] : lone Person {
	prev[p]
}
fun right[p : Person] : lone Person {
	next[p]
}

fun at_posA : Person { po/first }
fun at_posB : Person { right[at_posA] }
fun at_posC : Person { right[at_posB] }
fun at_posD : Person { right[at_posC] }
fun at_posE : Person { right[at_posD] }

// Basic uniqueness fact - no two distinct persons have the same
// job, the same first name or the same last name.

fact {
	no disj p1, p2 : Person |
		p1.job = p2.job or p1.fn = p2.fn or p1.ln = p2.ln
}

/*
1.	Ewan is standing to the left of Mr Jackson (who isn’t
	called Donald) but to the right of the undertaker.
*/
fact {
	let jackson = ln.Jackson, ewan = fn.Ewan, undertaker = job.Undertaker {
		left[jackson] = ewan
		right[undertaker] = ewan
		jackson.fn != Donald
	}
}

/*
2.	Mr Howard is standing in position C (that is, Mr. Howard is the
    third person in line).
*/
fact {
	at_posC.ln = Howard
}

/*
3.	Mr Ibbotson is a teacher of criminology at the local
      tech and was pleased to help out the police so he
      could get some “inside knowledge”!
*/
fact {
	job.Teacher.ln = Ibbotson
}

/*
4.	Mr Frost (who isn’t Alf and isn’t standing in position
	B) isn’t the undertaker.
*/
fact {
	let frost = ln.Frost {
		frost.job != Undertaker
		frost.fn != Alf
		frost != at_posB
	}
}

/*
5.	Alf (who isn’t standing in either position B or position E)
	isn’t the taxidermist. Nor is he the driver of the No. 27 bus
	which happens to go past the police station where the
	line-up is to be held.
*/
fact {
	let alf = fn.Alf {
		alf not in at_posB + at_posE
		alf.job not in Taxidermist + BusDriver
	}
}

/*
6.	Brian isn’t Mr Ibbotson or Mr Jackson.
*/
fact {
	let brian = fn.Brian | brian.ln not in Ibbotson + Jackson
}

/*
7.	Neither Charles (who isn't a taxidermist) nor Mr Frost (who isn’t the bus driver) is
	standing at the extreme right of the line-up.
*/
fact {
	let frost = ln.Frost, charles = fn.Charles {
		at_posE not in frost + charles
		frost.job != BusDriver
		charles.job != Taxidermist
	}
}

run {} for 5
