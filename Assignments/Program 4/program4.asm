TITLE Program Template     (template.asm)

; Author: Pranav Prabhu
; Last Modified: 02/12/22
; OSU email address: prabhup@oregonstate.edu
; Course number/section: CS 271
; Assignment Number: 4                Due Date: 02/13/2022
; Description: this program calculates composite numbers in the range [1, 300], inclusive.

INCLUDE Irvine32.inc

LOWER_LIMIT equ 1
UPPER_LIMIT equ 300

.data
	intro				BYTE	"Welcome to the Composite Number Spreadsheet by Pranav Prabhu!", 10, 0
	msg1				BYTE	"This program is capable of generating a list of composite numbers.", 10, 0
	msg2				BYTE	"Simply let me know how many you would like to see.", 10, 0
	msg3				BYTE	"I'll accept orders for up to 300 composites.", 10, 0
	ec_msg				BYTE	"***EC: Options to print either all composite numbers or just odd composite numbers.", 10, 0
	
	choice				BYTE	"You have two options:", 10, 0
	choice0				BYTE	"0. Display Composite Numbers", 10, 0
	choice1				BYTE	"1. Display Only Odd Composite Numbers", 10, 0
	msg4				BYTE	"Select an option: ", 0

	prompt				BYTE	"How many composites do you want to view? [1 ... 300]: ", 0, 10
	error_msg			BYTE	"Out of range. Please try again!", 10, 0
	space				BYTE	"   ", 9, 0

	user_option			DWORD	?
	start				DWORD	1
	num_of_terms		DWORD	?
	count				DWORD	0
	flag				DWORD	0
	num					DWORD	?
	composite_nums		DWORD	?

	farewell_msg		BYTE	"Thanks for using my program! Goodbye!", 10, 0

.code
main PROC
	call	Introduction

	mov		edx, OFFSET ec_msg
	call	WriteString
	mov		edx, OFFSET choice				; get user choice if they want the program to display all composites or just odd composites
	call	WriteString
	mov		edx, OFFSET choice0
	call	WriteString
	mov		edx, OFFSET choice1
	call	WriteString
	mov		edx, OFFSET msg4
	call	WriteString
	call	ReadDec							; read in user input
	call	Crlf

	mov		user_option, eax
	cmp		user_option, 0					; if user entered 1, jump to print odd composites
	jne		call_odd_composites

	call	GetUserData

	call	ShowComposites
	jmp		call_farewell

	call_odd_composites:
		call	GetUserData
		call	ShowOddComposites

	call_farewell:
		call	Goodbye

	exit										; exit to operating system
main ENDP

; Description: prints all welcoming messages
; Receives: none
; Returns:	strings of messages
; Preconditions: none
; Registers Changed: edx
Introduction	PROC
	mov		edx, OFFSET intro					; print all introductory messages
	call	WriteString
	call	Crlf
	mov		edx, OFFSET msg1
	call	WriteString
	mov		edx, OFFSET msg2
	call	WriteString
	mov		edx, OFFSET msg3
	call	WriteString
	call	Crlf

	ret
Introduction	ENDP

; Description: gets user input and calls the "Validate" function to error handle user input
; Receives: user input
; Returns: none
; Preconditions: none
; Registers Changed: edx
GetUserData		PROC
	mov		edx, OFFSET prompt
	call	WriteString
	call	ReadDec								; get total terms from user
	
	call	Validate							; call "Validate" function to error handle user input

	ret
GetUserData		ENDP

; Description: validates (error handles) user input
; Receives: user input
; Returns: number of terms input by user
; Preconditions: num >= LOWER_LIMIT and num <= UPPER_LIMIT
; Registers Changed: eax, edx
Validate	PROC
	check_bounds:
		cmp		eax, LOWER_LIMIT
		jl		reprompt
		cmp		eax, UPPER_LIMIT
		jg		reprompt						; reprompt if invalid input is detected
		mov		num_of_terms, eax				; if input is valid, store the integer into a variable
		call	Crlf
		jmp		exit1

	reprompt:
		mov		edx, OFFSET error_msg
		call	WriteString						; print error message
		mov		edx, OFFSET prompt
		call	WriteString						; reprompt user for valid input
		call	ReadDec
		cmp		eax, LOWER_LIMIT
		jl		reprompt						; reprompt again if invalid input is detected again
		cmp		eax, UPPER_LIMIT
		jg		reprompt
		mov		num_of_terms, eax				; if input is valid, store the integer into a variable
		jmp		exit1

	exit1:

	ret
Validate	ENDP

; Description: prints the list of composite numbers
; Receives: user input of total number of terms
; Returns: composite numbers
; Preconditions: "flag" variable must be set to 1 in order for the integer to be composite
; Registers Changed: eax, ecx, edx
ShowComposites		PROC
	mov		ecx, num_of_terms
	mov		start, 4							; composite numbers start at 4

	call_function:
		call	IsComposite						; call the "IsComposite" function
		cmp		flag, 1
		jne		loop_back						; jump to "loop_back" label if "flag" in "IsComposite" is not set to 1
		mov		eax, start
		call	WriteDec						; if num is composite, print it
		mov		edx, OFFSET space
		call	WriteString
		inc		start							; increment number to find next composite number
		inc		count
		cmp		count, 10
		jne		continue

		print_new_line:							; print new line after every 10 numbers are printed
			mov		count, 0					; reset the "count" flag
			call	Crlf

		continue:
			loop	call_function				; decrements "num_of_terms" value in ecx register by 1 to continue looping (i.e., backwards looping)
			jmp		exit2						; exit the function once all composites are printed (i.e, when ecx = 0)

		loop_back:								; while "flag" in "IsComposite" is set to 0, increment number to loop back and find next composite number
			inc		start
			jmp		call_function
	
	exit2:

	ret
ShowComposites		ENDP

; Description: identifies all composite numbers in the sequence of numbers
; Receives: "start" variable starting at 4
; Returns: "flag" is set to 1 only if a composite number is found
; Preconditions: "flag" is set to 0 and "num" starts at 2
; Registers Changed: eax, ebx, edx
IsComposite		PROC
	mov		flag, 0								; initially, "flag" condition is set to 0
	mov		num, 2

	find_factors:
		mov		eax, start
		cmp		num, eax
		je		exit3							; when num = start, it's not a composite (ex: 5 = 5 is not a composite)
		mov		ebx, num
		mov		edx, 0							; reset edx register before doing division
		div		ebx
		cmp		edx, 0
		jne		increment_num
		mov		flag, 1							; if a factor is found (i.e., when remainder = 0), set the "flag" status to 1
		jmp		exit3							; exit function once the number is determined as a composite

	increment_num:								; at this point, a composite hasn't been found yet
		inc		num								; increment num
		jmp		find_factors					; jump back to finding a factor once num is incremented (until num = start)

	exit3:
	
	ret
IsComposite		ENDP

; Description: prints the list of odd composite numbers
; Receives: user input of total number of terms
; Returns: odd composite numbers
; Preconditions: "flag" variable must be set to 1 in order for the integer to be an odd composite
; Registers Changed: eax, ecx, edx
ShowOddComposites	PROC
	mov		ecx, num_of_terms
	mov		start, 3							; since 3 is the first odd number (1 is neither prime nor composite), start at 3

	call_function:
		call	IsOddComposite					; call the "IsOddComposite" function
		cmp		flag, 1
		jne		loop_back						; jump to "loop_back" label if "flag" in "IsComposite" is not set to 1
		mov		eax, start
		call	WriteDec						; if num is composite and odd, print it
		mov		edx, OFFSET space
		call	WriteString

		increment_start:
			add		start, 2					; add start by 2 because we do not have to check composites for even numbers
			inc		count
			cmp		count, 10
			jne		continue

		print_new_line:							; print new line after every 10 numbers are printed
			mov		count, 0					; reset the "count" flag
			call	Crlf

		continue:
			loop	call_function				; decrements "num_of_terms" value in ecx register by 1 to continue looping (i.e., backwards looping)
			jmp		exit4						; exit the function once all composites are printed (i.e, when ecx = 0)

		loop_back:								; while "flag" in "IsOddComposite" is set to 0, increment number to loop back and find next composite number
			add		start, 2
			jmp		call_function
	
	exit4:

	ret
ShowOddComposites	ENDP

; Description: identifies all odd composite numbers in the sequence of numbers
; Receives: "start" variable starting at 3
; Returns: "flag" is set to 1 only if an odd composite number is found
; Preconditions: "flag" is set to 0 and "num" starts at 2
; Registers Changed: eax, ebx, edx
IsOddComposite		PROC
	mov		flag, 0								; initially, "flag" condition is set to 0
	mov		num, 2

	find_factors:
		mov		eax, start
		cmp		num, eax
		je		exit5							; when num = start, it's not a composite (ex: 11 = 11 is not a composite)
		mov		ebx, num
		mov		edx, 0							; reset edx register before doing division
		div		ebx
		cmp		edx, 0
		jne		increment_num
		mov		flag, 1							; if a factor is found (i.e., when remainder = 0), set the "flag" status to 1
		jmp		exit5							; exit function once the number is determined as an odd composite

	increment_num:								; at this point, a composite hasn't been found yet
		inc		num								; increment num
		jmp		find_factors					; jump back to finding a factor once num is incremented (until num = start)

	exit5:

	ret
IsOddComposite		ENDP

; Description: prints farewell message
; Receives: none
; Returns: string of a goodbye message
; Preconditions: none
; Registers Changed: edx
Goodbye		PROC
	call	Crlf
	call	Crlf
	call	Crlf

	mov		edx, OFFSET farewell_msg			; print goodbye message
	call	WriteString

	ret
Goodbye		ENDP

END main