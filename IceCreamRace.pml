
/* Ice Cream Race
*  
*  (1) Add assertions as shown to define valid states for
*      M() and P() processes.
*  (2) Run the model to demonstrate those assertions are violated
*	   (invalid states).
*  (3) Modify the model to prevent inavalid states from occurring
*	   (i.e. both Mike and Pete thinking they have the ice cream
*/

mtype = {NO_ONE, MIKE, PETE} ;

mtype ice_cream_owner = NO_ONE ;

active proctype M() {
	byte gotit = false;

	if
	::  atomic{
	    ice_cream_owner == NO_ONE ->
		ice_cream_owner = MIKE ;
		gotit = true;
		printf("Mike says \"I've got it!\"\n") ;
		}
	::else -> skip
	fi ;
// Add assert here for process M() valid state 
  assert( ! gotit || ice_cream_owner == MIKE ) ;

}

active proctype P() {
    byte gotit = false;

	if
	::  
 	    ice_cream_owner == NO_ONE ->
		ice_cream_owner = PETE ;
        gotit = true;
		printf("Pete says \"I've got it!\"\n") ;
 
	::else -> skip
    fi ;
assert( ! gotit || ice_cream_owner == PETE) ;
// Add assert here for process P() valid state 
}