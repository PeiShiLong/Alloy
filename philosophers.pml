/*
* Modify the Dinning Philosopher's model to avoid deadlock (break
* cyclic dependancy) by having Philosophers 0 & 2 go fo the right fork
* first, Philosophers 1 & 3 go for the left fork first. 
*/

/*
 * Number of processes, including init.
 */
#define NPROC 4

/*
 * want_to_eat[i] is true <-> philospher with pid = i wants
 * two forks to eat.
 */
bool want_to_eat[NPROC] = false ;

/*
 * eating[i] is true <-> philosopher with pid = i has both
 * forks and is eating.
 */
bool eating[NPROC] = false ;

/*
 * Pseudo-type semaphore
 */
#define semaphore byte

/*
 * Forks - each fork *is* a mutual exclusion semaphore
 */
semaphore fork[NPROC] = 1 ;

/*
 * Up and down functions on semaphores.
 * down blocks if the semaphore is 0 on entry.
 */
inline up(s)    { s++ }
inline down(s)  { atomic{ s > 0 ; s-- } }


/*
 * Forever process (4 copies)
 */
active[4] proctype Phil() {
    byte me = _pid ;				// _pid returns current process number (0-3)




	do
	::
		/*
		 * Thinking - Non-Critical Sectio
		 */
		printf("P%d is thinking\n", me) ;

	    /*
         * Get The Forks - Enter the Critical Section
         */
	
        want_to_eat[me] = true ;
		printf("P%d wants to chow down\n", me) ;
	if
		::(me % 2) == 0 ->
        	down(fork[me]) ;
													// secure the fork for the right hand
      		down(fork[ (me + 1) % NPROC ]) ;		// secure the fork for the opposite hand
		::(me%2) == 1 ->
			down(fork[ (me + 1) % NPROC ]) ;	
			down(fork[me]) ;
	fi;
		printf("%d, %d\n", me, (me+1)%NPROC);	// outputs the right & left fork numbers

        want_to_eat[me] = false ;

		/*
	     * Eating - Executing in the Critical Section
		 */
		eating[me] = true ;
        printf("P%d eating\n", me) ;
	
		/*
		 * Give Back The Forks - Leave the Critical Section
		 */
 		up(fork[me]) 
         eating[me] = false ;
		 up(fork[me]) ;							// release the fork for the right hand
		 up(fork[ (me + 1) % NPROC ]) ;			// release the fork for the left hand
	 printf("P%d finished eating and is thinking\n", me) ;
	od
}
