some sig Person {
	friends : set Person,
	enemies : set Person
}

// Everyone is a friend of him or her self.
fact AreOwnFriend {
all p : Person |(p in p.friends)
	// Fill in
}

// Nobody has someone else as both a friend and an enemy.
fact NoFriendsAreEnemies {
all p: Person | no p.friends &  p.enemies
	// Fill in
}

// No person is his or her own enemy.
assert NotOwnEnemy {
all  p : Person | p! in p.enemies
	// Fill in
}
check NotOwnEnemy for 8
 
// The enemies of a person's enemies are friends
// of that person.

fact EnemyOfEnemyIsFriend {
	all p : Person, q : p.enemies {
		q.enemies in p.friends
	}
}

// A person's friends have that person as their
// friend.
fact FriendsAreSymmetric {
friends=~friends
	// Fill in
}

// A person's enemies have that person as their
// enemy.
fact EnemiesAreSymmetric {
all disj p, p2 : Person|   p2 in p.enemies => p in p2.enemies
	// Fill in
}

run {} for exactly 5 Person


// There is exactly one person who is the enemy of
// everyone else.
pred CommonEnemy {
one p : Person, q : Person {
p.enemies = q.enemies
	// Fill in
	}
}
run CommonEnemy for exactly 5 Person

// Some persons have no friends other than themselves.
pred SomeLonelyPersons {
 some p : friends {
p.friends = p
	}
}
run SomeLonelyPersons for exactly 5 Person
