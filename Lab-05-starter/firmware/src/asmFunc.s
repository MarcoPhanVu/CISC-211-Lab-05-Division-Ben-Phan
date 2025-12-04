/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
@ Define the globals so that the C code can access them
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object

/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Ben Phan"  

.align   /* realign so that next mem allocations are on word boundaries */

/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */

/* define a section for the lab variables at a fixed location.
* This ensures the answers won't vary based on SW version or
* other unrelated changes */
.section lab5data,data,address(0x20000800)

/* define and initialize global variables that C can access */

.global dividend,divisor,quotient,mod,we_have_a_problem
.type dividend,%gnu_unique_object
.type divisor,%gnu_unique_object
.type quotient,%gnu_unique_object
.type mod,%gnu_unique_object
.type we_have_a_problem,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
* If you want these to be 0 every time asmFunc gets called, you must set
* them to 0 at the start of your code!
*/
dividend:          .word     0  
divisor:           .word     0  
quotient:          .word     0  
mod:               .word     0 
we_have_a_problem: .word     0

/* Tell the assembler that what follows is in instruction memory    */
.text
.align

	
/********************************************************************
function name: asmFunc
function description:
	output = asmFunc ()
	
where:
	output: 
	
	function description: The C call ..........
	
	notes:
		None
		
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

	/* save the caller's registers, as required by the ARM calling convention */
	push {r4-r11,LR}pop {r4-r11,LR}


	/** note to profs: asmFunc.s solution is in Canvas at:
	*    Canvas Files->
	*        Lab Files and Coding Examples->
	*            Lab 5 Division
	* Use it to test the C test code */
	
	/*** STUDENTS: Place your code BELOW this line!!! **************/
	/*
	Note to self:
		+ should the least amount of registers possible since they're limited
		+ doesn't really have to store all labels into registers at all time(but still have to since I have bad memory)
	*/


	/* 
	r0, r1: dividend, divisor (input)
	r2: operations 
	r3: quotient counter
	r4, r5, r6: quotient, mod, problem 
	r7: tempVal 
	*/


	/* Save inputs into dividend and divisor*/
	ldr     r7, =dividend
	str     r0, [r7]

	ldr     r7, =divisor
	str     r1, [r7]

	/* Store 0 into all*/
	mov     r7, 0

	ldr     r4, =quotient
	str     r7, [r4]

	ldr     r5, =mod
	str     r7, [r5]

	ldr     r6, =we_have_a_problem
	str     r7, [r6]


	/* Error cases: dividend == 0 || divisor == 0 */
	cmp     r0, 0
	beq     error_case
	cmp     r1, 0
	beq     error_case

	/* DIVISION */
	mov     r2, r0          /* currDividend */
	mov     r3, 0           /* quotientCounter */

div_loop:
	cmp     r2, r1          
	blo     div_done        /* r2 < r1, should use blo for unsigned integers instead of blt */

	sub     r2, r2, r1      /* r2 -= r1 */
	add     r3, r3, 1       /* qC++ */
	b       div_loop

div_done:
	/* Store quotient(r4) */
	str     r3, [r4]

	/* Store remainder(r5) */
	str     r2, [r5]

	/* Ensure error flag(r6) = 0 */
	mov     r7, 0
	str     r7, [r6]

	/* 12. Return address of quotient in r0 */
	ldr     r0, =quotient
	b       done

error_case:
	/* Set error flag(r6) = 1 */
	mov     r7, 1
	str     r7, [r6]

	/* quotient(r4) = 0 */
	mov     r7, 0
	str     r7, [r4]

	/* mod(r5) = 0 */
	str     r7, [r5]

	/* Return address of quotient */
	ldr     r0, =quotient
	b       done
	/*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
	/* restore the caller's registers, as required by the 
	* ARM calling convention 
	*/
	mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
	mov r0,r0 /* this is a do-nothing line to deal with IDE mem display bug */

screen_shot:    pop {r4-r11,LR}

	mov pc, lr	 /* asmFunc return to caller */


/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */