/*
 * Starter skeleton for Cafe using semaphores
 */

#define NCUSTS 2 	/* number of customers */
#define NCASHIERS 1 /* number of cashiers */
#define NSERVERS 1 	/* number of servers */

#define semaphore byte   /* define a sempahore */

/*
 * up and down functions for semaphores
 */
inline up(s) {s++;}
inline down(s) {atomic{ s>0 ; s--}}

mtype = {CHILI, SANDWICH, PIZZA} ;	/* the types of foods */

mtype favorite_foods[NCUSTS];
mtype food;

byte serving=0;
semaphore cashier=1; 
byte cooking=0;
semaphore server=1;


/*
 * Process representing a customer.
 * Takes in their favorite food and an integer id
 * to represent them
 */
proctype Customer(mtype favorite; byte id)
{
	/* customer cycle */
	do
	::

		/* 1. Customer enters the cafe */
		printf("C%d enters.\n", id) ;
		down(cashier);
		/* 2. Record a new customer */
			serving=id;
	
		/* 3. Wait for the cashier */
			if 
			::cashier==1->
		/* 4. Customer places order for favorite food */
		printf("C%d orders %e.\n", id, favorite) ;
			fi;
		/* 5. Wait for the order to be fulfilled */
			if
		  	::cooking==0 ->
		/* 6. Customer exits with food */
		printf("C%d leaves.\n", id);
			fi;
		

	od ;
}

/*
 * Process representing a cashier
 */
proctype Cashier()
{
	do
	::
		/* 1. Cashier waits for a new customer */
		printf("Cashier is waiting for a new customer.\n");
			(cashier==0);
	
		/* 2. Cashier selects a waiting customer */
		printf("Cashier selects customer.\n");
			down(server);
			cooking=serving;
		
		/* 3. Cashier takes selected customer's order */
		printf("Cashier takes order.\n");

		/* 4. Cashier passes order to server */
		printf("Cashier passes order to server.\n");
			if
			:: server==1 ->
			serving=0;
			up(cashier);
			fi;
	od ;
}

/*
 * Process representing a server 
 */
proctype Server()
{

	do
	::
		printf("Server is free.\n") ;
		/* Server is waiting for an order */
			if 
		::server==0->
		/* Server retrives an order and takes it down */
		printf("Server is retrieves an order for customer...\n") ;
		   fi;
		atomic{
			food=favorite_foods[cooking];
			up(server);
				}
		/* Server makes the order */
		printf("Server makes order.\n");


		/* server gives the order to the customer */
		printf("Server delivers order to customer.\n");
		atomic{
			cooking=0;
			food=0;
		}
	od ;

}

/*
 * Sets up processes. This model creates two
 * customers with the favorite foods PIZZA & CHILI.
 */
init{

	atomic{
		run Customer(PIZZA, 0) ;
		run Customer(CHILI, 1) ;
		run Cashier();
		run Server();		
	}
}

/*
 * Safety: The server always gives the correct food
 * for the customer
 */

ltl S_ServerCorrectFood {
	//[](favorite_foods[being_served]==food)
}

/*
 * Safety: The cashier always sends the correct customer
 * order to the servers.
 */

ltl S_CashierSendsCorrectOrder{
	[](serving==cooking)
}

/* 
 * Liveness: If the customer wants to place
 * an order then it eventually does.
 */

ltl L_CustomerOrders {
	<>(cashier==1)
}

/* 
 * Liveness: Eventually the server is busy
 * fulfilling an order.
 */

ltl L_ServerBusy{
<>(serving!=0)
}


