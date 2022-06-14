TITLE Program Template     (template.asm)

; Author: Pranav Prabhu
; Last Modified: 01/30/2022
; OSU email address: prabhup@oregonstate.edu
; Course number/section: CS 271
; Assignment Number: 3                Due Date: 01/30/2022
; Description: this program implements an accumulator, which performs integer arithmetic and calculates average.

INCLUDE Irvine32.inc

LOWER_LIMIT equ -100
UPPER_LIMIT equ -1

.data
	intro					BYTE	"Welcome to the Integer Accumulator by Pranav Prabhu!", 10, 0
	input					BYTE	"What's your name? ", 0
	username				BYTE	100 DUP(?)

	greet					BYTE	"Hello, ", 0
	period					BYTE	".", 10, 0
	exclamation				BYTE	"!", 10, 0

	msg1					BYTE	"Please enter numbers in [-100, -1].", 10, 0
	msg2					BYTE	"Enter a non-negative number when you are finished to see results.", 10, 0
	prompt					BYTE	"Enter a number: ", 0, 10
	error_msg				BYTE	"Invalid number, please enter numbers in [-100, -1].", 10, 0
	
	total_sum				DWORD	0
	rounded_average			DWORD	0
	average					DWORD	0
	total_terms				DWORD	0
	result					DWORD	0
	two						DWORD	2
	quotient				SDWORD	0
	remainder				SDWORD	0
	div_result				DWORD	0
	ten						DWORD	10
	neg_thousand			DWORD	-1000

	msg3					BYTE	"You entered ", 0
	msg4					BYTE	" valid numbers.", 0
	sum_msg					BYTE	"The sum of your valid numbers is ", 0
	zero_sum_msg			BYTE	"The total sum is 0.", 10, 0
	rounded_average_msg		BYTE	"The rounded average is ", 0
	average_msg				BYTE	"The average is ", 0
	decimal					BYTE	".", 0
	zero_avg_msg			BYTE	"The average is 0.", 10, 0

	msg5					BYTE	"Thank you for playing Integer Accumulator!", 10, 0
	farewell_msg			BYTE	"Goodbye, ", 0

.code
main PROC
													; Introduction
	mov		edx, OFFSET intro
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

	mov		edx, OFFSET msg1
	call	WriteString
	mov		edx, OFFSET msg2
	call	WriteString

	mov		edx, OFFSET prompt
	call	WriteString
	call	ReadInt							; reads signed integers (including negative numbers) from user
	add		eax, total_sum					; add user input to sum to accumulate
	cmp		eax, 0
	jge		zero_case						; if num >= 0, exit the program
	mov		total_sum, eax					; store sum in "total_sum" variable
	jmp		check_bounds

	check_bounds:										; this label checks if user input is within bounds
		cmp		eax, LOWER_LIMIT
		jl		reprompt					; if user input stored in eax is less than -100, jump to "reprompt" label to print error message
		cmp		eax, UPPER_LIMIT
		jg		jump_to_exit				; if num > -1, exit the loop
		add		total_terms, 1				; at this point, user input is within bounds, so add 1 to terms count
		jmp		receive_input

	reprompt:										; this label reprompts the user for valid input in invalid input is detected
		mov		edx, OFFSET error_msg
		call	WriteString					; print error message
		mov		edx, OFFSET prompt
		call	WriteString					; reprompt user for valid input
		call	ReadInt
		cmp		eax, LOWER_LIMIT
		jl		reprompt					; reprompt again if invalid input is detected again
		cmp		eax, UPPER_LIMIT
		jg		jump_to_exit
		add		eax, total_sum				; at this point, user input is valid, so add input to total sum
		mov		total_sum, eax
		add		total_terms, 1				; add 1 to the total valid number count (used for average later)

		; --------------------------------- print to verify numbers ---------------------------------------------------------
		;mov	eax, total_sum
		;call	WriteInt					; print sum
		;call	Crlf
		;mov	eax, total_terms
		;call	WriteDec					; print total terms (note: this is unsigned/positive)
		;call	Crlf
		; --------------------------------------- end -----------------------------------------------------------------------

		jmp		receive_input				; continue to receive user input

	jump_to_exit:
		jmp		exit1

	receive_input:									; this label receives user input and accumulates numbers 
		mov		edx, OFFSET prompt
		call	WriteString
		call	ReadInt
		cmp		eax, LOWER_LIMIT
		jl		reprompt					; reprompt again if invalid input is detected again
		cmp		eax, UPPER_LIMIT
		jg		jump_to_exit
		add		eax, total_sum				; at this point, user input is valid, so add input to total sum
		mov		total_sum, eax
		add		total_terms, 1				; add 1 to the total valid number count (used for average later)

		; ------------------------------------- print to verify numbers -----------------------------------------------------
		;mov	eax, total_sum
		;call	WriteInt
		;call	Crlf
		;mov	eax, total_terms
		;call	WriteDec
		;call	Crlf
		; ----------------------------------------------- end ---------------------------------------------------------------

		jmp		receive_input				; loop back to top of label to repeat the process

	exit1:									; exit the loop

	call	Crlf

											; print total number of valid numbers entered by user
	mov		edx, OFFSET msg3
	call	WriteString
	mov		eax, total_terms
	call	WriteDec
	mov		edx, OFFSET msg4
	call	WriteString
	cmp		total_terms, 0
	je		zero_case

	call	Crlf

											; print the total sum
	mov		edx, OFFSET sum_msg
	call	WriteString
	mov		eax, total_sum
	call	WriteInt
	mov		edx, OFFSET period
	call	WriteString

											; print the rounded average of the numbers
	mov		edx, OFFSET rounded_average_msg
	call	WriteString
	mov		eax, total_terms
	cdq										; cdq is used for signed integer division & extends space from eax to edx register
	idiv	two								; divide by 2
	mov		result, eax
	cmp		edx, 0							; compare remainder (always stored in edx register) to 0
	jne		odd_cases						; if remainder = 0, jump to "even_cases" (round down), else jump to "odd_cases" (round up)

	even_cases:
		mov		eax, total_sum
		cdq									; cdq is used for signed integer division
		idiv	total_terms					; divide sum by total terms
		mov		quotient, eax				; store quotient
		mov		remainder, edx				; store remainder
	
		mov		eax, total_terms
		mov		ebx, -2
		cdq
		idiv	ebx							; divide total terms by -2
		cmp		remainder, eax				; compare remainder against quotient of total_terms / -2
		jg		exit2
		add		quotient, -1				; round up to nearest integer
		jmp		exit2

	odd_cases:
		mov		eax, total_sum
		cdq									; cdq is used for signed integer division
		idiv	total_terms
		mov		quotient, eax				; store quotient
		mov		remainder, edx				; store remainder

		mov		eax, edx
		mul		ten							; multiply remainder (negative) by 10
		cdq
		idiv	total_terms					; divide multiplied result by total terms
		mov		div_result, eax				; store divided result in a variable
		cmp		div_result, -5
		jg		exit2						; exit if divided result > -5
		sub		quotient, 1					; subtract 1 from quotient to round down
				
		exit2:								; exit
	
	mov		eax, quotient
	mov		rounded_average, eax
	call	WriteInt						; print the rounded average
	mov		edx, OFFSET period
	call	WriteString

	mov		edx, OFFSET average_msg
	call	WriteString
	mov		eax, total_sum
	cdq										; cdq is used for signed integer division
	idiv	total_terms						; divide sum by total terms
	mov		quotient, eax					; store quotient
	mov		remainder, edx					; store remainder

	mov		eax, remainder
	imul	neg_thousand					; mutliply remainder by -1000
	cdq
	idiv	total_terms						; divide it by total terms
	mov		div_result, eax					; store quotient of the division in "div_result"
	mov		eax, quotient
	call	WriteInt						; now, print the original quotient first
	mov		edx, OFFSET decimal
	call	WriteString						; print decimal point
	mov		eax, div_result
	cdq
	idiv	ten								; divide the quotient in "div_result" by 10
	mov		remainder, edx					; store remainder
	cmp		remainder, 5
	jl		print_decimal_value								; jump to print_decimal_value if remainder < 5
	add		div_result, 1					; else add 1 to quotient in "div_result"

	print_decimal_value:
		mov		eax, div_result
		call	WriteDec					; print quotient in "div_result", which is actially the value after decimal point
		mov		edx, OFFSET period
		call	WriteString
		jmp		exit3

	zero_case:												; this label is only called when sum is 0
		call	Crlf
		mov		edx, OFFSET zero_sum_msg
		call	WriteString
		mov		edx, OFFSET zero_avg_msg
		call	WriteString

	exit3:
		call	Crlf

	mov		edx, OFFSET msg5
	call	WriteString
	mov		edx, OFFSET farewell_msg
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	mov		edx, OFFSET exclamation
	call	WriteString

	exit									; exit to operating system
main ENDP

END main