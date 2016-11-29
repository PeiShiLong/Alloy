abstract sig Couple {
	husband	:  MaleName, //attribute of couple but of type MaleName
	wife	: FemaleName,
	surname	: SurName,
	animal	: Animal,
	bird	: Bird
}
enum SurName { Connor, Carver, Jones, Porter, White }
enum MaleName{ Paul, Peter, Jim, Tom, Mike }
enum FemaleName { Joanna, Marjorie, Olivia, Patricia, Sandra }
enum Animal { Beaver, Rabbit, Coyote, Woodchuck, Fox }
enum Bird { Eagle, Goose, Pheasant, Swan, WildTurkey }

fact One_to_One_Mappings {
Couple.husband=MaleName
Couple.wife = FemaleName
Couple.surname = SurName
Couple.animal= Animal
Couple.bird = Bird
	// Ensure that the relations under Couple are 1-1
}

fact F1 {
husband.Tom.wife != Olivia
husband.Tom.animal = Fox
animal.Beaver = bird.WildTurkey
//	Couple.husband = Tom
//Couple.wife = Olivia

	
}

fact F2 {
wife.Patricia.surname = Carver
wife.Patricia.bird != Pheasant
husband.Paul.bird != Eagle
surname.Jones.animal = Coyote 
husband.Jim.surname !=White

}

fact F3 {
surname.Porter.bird != Swan
husband.Tom.wife != Sandra
husband.Tom != surname.Jones
surname.Connor = animal.Rabbit
}

fact F4 {
animal.Coyote != bird.Swan
husband.Mike.surname != Connor =>husband.Mike != animal.Woodchuck
wife.Sandra= bird.Goose
}

fact F5 {
husband.Peter & wife.Joanna != bird.WildTurkey
husband.Jim.surname != Jones
husband.Jim = bird.Pheasant
husband.Jim.animal != Woodchuck
}

fact F6 {
wife.Marjorie.surname =White => wife.Marjorie != bird.Swan
husband.Paul.surname =Porter=> husband.Paul != animal.Beaver
}

run { } for 5
