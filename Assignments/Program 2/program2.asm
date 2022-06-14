TITLE Program Template     (template.asm)

; Author: Pranav Prabhu
; Last Modified: 01/22/2022
; OSU email address: prabhup@oregonstate.edu
; Course number/section: CS 271
; Assignment Number: 2                Due Date: 01/23/2022
; Description: this program calculates Fibonacci numbers.

INCLUDE Irvine32.inc

UPPER_LIMIT equ 46

.data
	intro				BYTE	"-------------------Fibonacci Numbers-------------------", 10, 0
	programmer_intro	BYTE	"Programmed by Pranav Prabhu", 10, 0
	
	input				BYTE	"What's your name? ", 0
	username			BYTE	100 DUP(?)

	greet				BYTE	"Hello, ", 0
	exclamation			BYTE	"!", 10, 0

	msg					BYTE	"Enter the number of Fibonacci terms to be displayed.", 10, 0
	range_msg			BYTE	"Provide the number as an integer in the range [1 ... 46].", 10, 0

	total_terms			DWORD	?
	num_of_terms		DWORD	0
	prompt				BYTE	"How many Fibonacci terms do you want? ", 0, 10
	error_msg			BYTE	"Out of range. Enter a number in [1 .. 46].", 10, 0

	t1					DWORD	1
	t2					DWORD	1
	next_term			DWORD	0

	five_spaces			BYTE	"     ", 0
	six_spaces			BYTE	"      ", 0
	seven_spaces		BYTE	"       ", 0
	eight_spaces		BYTE	"        ", 0
	nine_spaces			BYTE	"         ", 0
	ten_spaces			BYTE	"          ", 0
	eleven_spaces		BYTE	"           ", 0
	twelve_spaces		BYTE	"            ", 0
	thirteen_spaces		BYTE	"             ", 0
	fourteen_spaces		BYTE	"              ", 0

	msg2				BYTE	"Results certified by Pranav Prabhu.", 10, 0
	farewell_msg		BYTE	"Goodbye, ", 0

.code
main PROC
													; Introduction
	mov		edx, OFFSET intro
	call	WriteString

	call	Crlf							; print new line

	mov		edx, OFFSET programmer_intro
	call	WriteString

	call	Crlf

	mov		edx, OFFSET input
	call	WriteString
	mov		edx, OFFSET username
	mov		ecx, sizeof username
	call	ReadString

	mov		edx, OFFSET greet
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	mov		edx, OFFSET exclamation
	call	WriteString

	call	Crlf

	mov		edx, OFFSET msg
	call	WriteString
	mov		edx, OFFSET range_msg
	call	WriteString

													; Error Handling User Input
	mov		edx, OFFSET prompt
	call	WriteString
	call	ReadInt							; get total terms from user
	mov		total_terms, eax
	jmp		L2

	L2:
		cmp		eax, 0
		jle		L3							; if input <= 0, jump to L3 to reprompt
		cmp		eax, UPPER_LIMIT
		jg		L3							; if input > MAX LIMIT, jump to L3 to reprompt
		mov		eax, 0						; reset 'eax' register for later use
		leave								; exit the label
		jmp		L4							; jump to end of loop

	L3:
		mov		edx, OFFSET error_msg
		call	WriteString					; print error message
		mov		edx, OFFSET prompt
		call	WriteString					; reprompt user for valid input
		call	ReadInt
		mov		total_terms, eax			; store input in "total_term" variable
		jmp		L2
	
	L4:										; exit the loop
	
	call	Crlf

													; Print Fibonacci Sequence
	mov		eax, 1
	mov		ecx, total_terms				; 'ecx' register stores total terms

	L6:
		cmp		eax, 2						; compare eax register to 2; jump to L7 (first 2 values are bases cases)

	L7:
		; NOTE: the following statements in this label equal to the following in C code:
		;			if (i == 1) {		printf("\t");	continue;	}
		;			if (i == 2) {		printf("\t");	continue;	}

		mov		eax, t1						; eax now holds the value 1 (first value in Fibonacci Sequence)
		call	WriteDec
		mov		edx, OFFSET fourteen_spaces
		call	WriteString
		sub		ecx, 1						; subtract 1 from ecx register to loop through remaining terms
		add		num_of_terms, 1				; add 1 to the count
		cmp		ecx, 0
		je		L10							; when ecx register = 0, exit the loop (i.e., decrement from total terms to 0)
		mov		eax, t2						; eax now holds the value 1 (second value in Fibonacci Sequence)
		call	WriteDec
		mov		edx, OFFSET fourteen_spaces
		call	WriteString
		sub		ecx, 1						; subtract 1 again from ecx register to loop through remaining terms
		add		num_of_terms, 1				; add 1 to the count
		cmp		ecx, 0
		je		L10							; when ecx register = 0, exit the loop (i.e., decrement from total terms to 0)

	L8:
		; NOTE: the following statements in this label equal to the following in C code:
		;			next_term = t1 + t2
		;			t1 = t2
		;			t2 = next_term
		; this swaps the values of t1 & t2, takes the sum of the previous two terms to find the next term in the sequence

		mov		eax, t1
		mov		ebx, t2
		add		eax, ebx					; t1 + t2
		mov		next_term, eax				; store sum in "next_term" variable
		mov		ebx, t2
		mov		t1, ebx						; t1 = t2 (i.e., move value from t2 to 'ebx' register to t1)
		mov		ebx, next_term
		mov		t2, ebx						; t2 = next_term (i.e., move value from next_term to 'ebx' register to t2)

		mov		eax, next_term
		call	WriteDec					; move value of "next_term" to eax register to print it
		call	print_spaces				; calls "print_spaces" function
		add		num_of_terms, 1				; add 1 to count
		cmp		num_of_terms, 4
		jne		L9							; compare count to 4; jump to L9 if not equal
		call	Crlf						; if equal to 4, print new line (to separate into 4 columns)
		mov		num_of_terms, 0				; reset count to 0

		L9:
		loop	L8							; loop back to top of label (note: "loop" automatically subtracts 1 from ecx register for each call)

		; NOTE: loop statement is equivalent to the following for-loop statement in C:
		;			for (int i = total_terms; i <= 0; i--) {	/* code	*/		}

	L10:									; exit the for-loop


	;	--------------------------------------------- Alternative For Loop -----------------------------------------------
	;mov eax, 1
	;mov ecx, 1
	;jmp L6

	;L5:
	;	add ecx, 1							; increment counter in ecx register (i++)

	;L6:
		;			equivalent to the following C code:		for (int i = 1; i <= total_terms; i++)

	;	cmp ecx, total_terms				; check if i <= total_terms
	;	jle L7								; jump to L7 if ecx <= total_terms
	;	jg L10								; exit loop once it exceeds the total terms

	;L7:
		;			equivalent to the following C code:		if (i == 1) {		printf("\t");	continue;	}

	;	cmp ecx, 1							; if i == 1 print 1st term (i.e., prints 1)
	;	jne L8								; jump to L8 if ecx != 1
	;	mov eax, t1
	;	call WriteDec
	;	mov edx, OFFSET five_spaces
	;	call WriteString
	;	jmp L5								; increment counter (i.e., i++)

	;L8:
		;			equivalent to the following C code:		if (i == 2) {		printf("\t");	continue;	}

	;	cmp ecx, 2							; if i == 2 print 2nd term (i.e., prints 1)
	;	jne L9								; jump to L8 if ecx != 2
	;	mov eax, t2
	;	call WriteDec
	;	mov edx, OFFSET five_spaces
	;	call WriteString
	;	jmp L5								; increment counter (i.e., i++)
	
	;L9:
		;			NOTE: the following statements in this label equal to the following in C code:
		;					next_term = t1 + t2
		;					t1 = t2
		;					t2 = next_term
		
		; note: you have to move the values in "t1", "t2", and "next_term" to a register to add, swap, and print values

	;	mov eax, t1
	;	mov ebx, t2
	;	add eax, ebx
	;	mov next_term, eax
	;	mov ebx, t2
	;	mov t1, ebx
	;	mov ebx, next_term
	;	mov t2, ebx

	;	mov eax, next_term
	;	call WriteDec
	;	mov edx, OFFSET five_space
	;	call WriteString
	;	jmp L5								; jump to L5 to increment counter which then jumps to L6 -> L7 -> L8 -> L9

	;L10:									; exit the for-loop
	
	;	----------------------------------------- End of Alternative For Loop -----------------------------------------------

	call	Crlf
	call	Crlf
	call	Crlf

	mov		edx, OFFSET msg2
	call	WriteString
	mov		edx, OFFSET farewell_msg
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	mov		edx, OFFSET exclamation
	call	WriteString

	exit									; exit to operating system
main ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; Function: print_spaces
 ; Description: this function prints the appropriate number of spaces between numbers (minimum of 5)
 ; Parameters: none
 ; Preconditions: compares values in eax against numbers ranging from 10 to 1000000000
 ; Postconditions: prints the appropriate number of spaces for numbers within a certain range
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_spaces PROC							; function to print appropriate spaces between numbers
	cmp		eax, 1000000000
	jge		L1								; jump to L1 if number in eax register >= 1000000000
	jmp		skipL1							; skip from printing spaces in L1 to next comparison block if num < 1000000000
	L1:
		mov		edx, OFFSET five_spaces
		call	WriteString
		jmp		L11							; exit the entire function once condition is met and spaces are printed
	skipL1:

	cmp		eax, 100000000
	jge		L2								; jump to L2 if number in eax register >= 100000000
	jmp		skipL2							; skip from printing spaces in L2 to next comparison block if num < 100000000
	L2:
		mov		edx, OFFSET six_spaces
		call	WriteString
		jmp		L11							; exit the entire function once condition is met and spaces are printed
	skipL2:

	cmp		eax, 10000000
	jge		L3								; jump to L3 if number in eax register >= 10000000
	jmp		skipL3							; skip from printing spaces in L3 to next comparison block if num < 10000000
	L3:
		mov		edx, OFFSET seven_spaces
		call	WriteString
		jmp		L11							; exit the entire function once condition is met and spaces are printed
	skipL3:

	cmp		eax, 1000000
	jge		L4								; jump to L4 if number in eax register >= 1000000
	jmp		skipL4								; skip from printing spaces in L4 to next comparison block if num < 1000000
	L4:
		mov		edx, OFFSET eight_spaces
		call	WriteString
		jmp		L11							; exit the entire function once condition is met and spaces are printed
	skipL4:

	cmp		eax, 100000
	jge		L5								; jump to L5 if number in eax register >= 100000
	jmp		skipL5							; skip from printing spaces in L5 to next comparison block if num < 100000
	L5:
		mov		edx, OFFSET nine_spaces
		call	WriteString
		jmp		L11							; exit the entire function once condition is met and spaces are printed
	skipL5:

	cmp		eax, 10000
	jge		L6								; jump to L6 if number in eax register >= 10000
	jmp		skipL6							; skip from printing spaces in L6 to next comparison block if num < 10000
	L6:
		mov		edx, OFFSET ten_spaces
		call	WriteString
		jmp		L11							; exit the entire function once condition is met and spaces are printed
	skipL6:

	cmp		eax, 1000
	jge		L7								; jump to L7 if number in eax register >= 1000
	jmp		skipL7							; skip from printing spaces in L7 to next comparison block if num < 1000
	L7:
		mov		edx, OFFSET eleven_spaces
		call	WriteString
		jmp		L11							; exit the entire function once condition is met and spaces are printed
	skipL7:

	cmp		eax, 100
	jge		L8								; jump to L8 if number in eax register >= 100
	jmp		skipL8							; skip from printing spaces in L8 to next comparison block if num < 100
	L8:
		mov		edx, OFFSET twelve_spaces
		call	WriteString
		jmp		L11							; exit the entire function once condition is met and spaces are printed
	skipL8:

	cmp		eax, 10
	jge		L9								; jump to L9 if number in eax register >= 10
	jmp		skipL9							; skip from printing spaces in L9 to next comparison block if num < 10
	L9:
		mov		edx, OFFSET thirteen_spaces
		call	WriteString
		jmp		L11							; exit the entire function once condition is met and spaces are printed
	skipL9:
	
	cmp		eax, 1
	jge		L10								; jump to L10 if number in eax register >= 10
	L10:
		mov		edx, OFFSET fourteen_spaces
		call	WriteString
		jmp		L11							; exit the entire function once condition is met and spaces are printed

	L11:									; exit funtion

	ret										; return
print_spaces ENDP

END main