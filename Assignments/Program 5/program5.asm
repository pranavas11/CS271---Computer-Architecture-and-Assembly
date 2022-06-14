TITLE Program Template     (template.asm)

; Author: Pranav Prabhu
; Last Modified: 03/01/2022
; OSU email address: prabhup@oregonstate.edu
; Course number/section: CS 271
; Assignment Number: 5                Due Date: 02/27/2022
; Description: this program implements Selection Sort to sort elements in an array in descending order

INCLUDE Irvine32.inc

; user input range
MIN		EQU		15
MAX		EQU		200

; random integer range
LO		EQU		100
HI		EQU		999

.data
	intro				BYTE	"Sorting Random Integers!", 10, 0
	programmer			BYTE	"Programmed by Pranav.", 10, 0
	greet				BYTE	"Welcome Julian!", 10, 0
	late_days			BYTE	"Note: I used my 2 grace days on this assignment.", 10, 0
	msg1				BYTE	"This program generates random numbers in the range [100 .. 999],", 10, 0
	msg2				BYTE	"displays the original list, sorts the list, and calculates the median value.", 10, 0
	msg3				BYTE	"Finally, it displays the list sorted in descending order.", 10, 0

	prompt				BYTE	"How many numbers should be generated? [15 ... 200]: ", 0, 10
	error_msg			BYTE	"Out of range. Please try again!", 10, 0
	space				BYTE	" ", 9, 0

	array				DWORD	MAX		DUP(?)
	request				DWORD	?
	
	unsorted_list_title	BYTE	"Unsorted List:", 10, 0
	sorted_list_title	BYTE	"Sorted List:", 10, 0
	median_title		BYTE	"The Median is: ", 0

	farewell_msg		BYTE	"Thanks for using my program! Goodbye!", 10, 0

.code
main PROC
	call	Randomize					; Irvine library procedure for initializing the random number generator

	push	OFFSET intro
	push	OFFSET programmer
	push	OFFSET greet
	push	OFFSET msg1
	push	OFFSET msg2
	push	OFFSET msg3
	call	Introduction				; similar to C/C++ function call: introduction(&intro, &programmer, &greet, &msg1, &msg2, &msg3)

	call	Crlf

	mov		edx, OFFSET late_days
	call	WriteString

	call	Crlf

	push	OFFSET prompt
	push	OFFSET error_msg
	push	OFFSET request
	call	Get_Data					; get_data(&prompt, &error_msg, &request)
	
	push	OFFSET array
	push	request
	call	Fill_Array					; fill_array(array[], size);

	push	OFFSET unsorted_list_title
	push	OFFSET array
	push	OFFSET space
	push	request
	call	Display_List				; display_list(&unsorted_list_title, array[], size)

	push	OFFSET array
	push	request
	call	Sort_List					; sort_list(array[], size)

	push	OFFSET median_title
	push	OFFSET array
	push	request
	call	Display_Median				; display_median(median_title, array[], size)

	call	Crlf
	call	Crlf
	call	Crlf

	push	OFFSET sorted_list_title
	push	OFFSET array
	push	OFFSET space
	push	request
	call	Display_List				; display_list(&unsorted_list_title, array[], size)

	call	Crlf
	call	Crlf
	call	Crlf

	mov		edx, OFFSET farewell_msg
	call	WriteString

	exit								; exit to operating system
main ENDP

; Description: prints all welcoming messages
; Receives: intro, programmer, greet, ms1, msg2, msg3	=>	(string messages)
; Returns:	strings of messages
; Preconditions: none
; Registers Changed: edx, ebp
Introduction	PROC
	push	ebp							; push ebp onto the stack
	mov		ebp, esp					; ebp points to esp (base pointer)
													; print all introductory messages
	mov		edx, [ebp + 28]
	call	WriteString					; prints string message stored in "intro" variable
	mov		edx, [ebp + 24]
	call	WriteString					; prints string message stored in "programmer" variable

	call	Crlf

	mov		edx, [ebp + 20]
	call	Writestring					; prints string message stored in "greet" variable

	call	Crlf

	mov		edx, [ebp + 16]
	call	WriteString					; prints string message stored in "msg1" variable
	mov		edx, [ebp + 12]
	call	WriteString					; prints string message stored in "msg2" variable
	mov		edx, [ebp + 8]
	call	WriteString					; prints string message stored in "msg3" variable

	call	Crlf
	
	pop		ebp							; pops ebp off the top of the stack

	ret		24							; 6 (total string messages printed) * 4 bytes = 24 bytes (i.e., pops the return address and 24 additional bytes off the stack)
Introduction	ENDP

; Description: gets user input
; Receives: prompt, error_msg, request	=>	(string messages and "request" is array size)
; Returns: none
; Preconditions: none
; Registers Changed: ebx, edx, ebp
Get_Data	PROC
	push	ebp
	mov		ebp, esp

	mov		ebx, [ebp + 8]				; move value in "request" to ecx register

	validate_input:
		mov		edx, [ebp + 16]
		call	WriteString				; display prompt message and read user input
		call	ReadDec
		mov		[ebx], eax				; store input in ebx register after dereferencing ebx

		cmp		eax, MIN
		jl		reprompt
		cmp		eax, MAX
		jg		reprompt
		jmp		exit1

	reprompt:
		mov		edx, [ebp + 12]
		call	WriteString				; print error message
		jmp		validate_input

	exit1:

	pop		ebp

	ret		12							; "get_data()" takes 3 paramters, so 4 * 3 = 12
Get_Data	ENDP

; Description: fills the array with random integers
; Receives: array, request (array size)
; Returns: array of random integers
; Preconditions: none
; Registers Changed: eax, ecx, ebp, edi
Fill_Array		PROC
	push	ebp
	mov		ebp, esp

	mov		edi, [ebp + 12]				; move array into edi
	mov		ecx, [ebp + 8]				; move value in "request" to ecx

	fill:
		mov		eax, HI
		sub		eax, LO					; eax = 999 - 100 = 899
		add		eax, 1					; eax = 900
		call	RandomRange				; generates random integers in the range [0, 899]
		add		eax, LO					; eax is now between [100, 999]
		mov		[edi], eax				; move that random number to array
		add		edi, 4					; adds 4 bytes (since it's DWORD), meaning we shift to the next index in the array to place a number
		loop	fill

	pop		ebp

	ret		8							; "fill_array()" takes 2 paramters, so 4 * 2 = 8
Fill_Array		ENDP

; Description: displays the unsorted & sorted array
; Receives: unsorted_list_title, array, space, request	=>	(string messages, array, and array size)
; Returns: unsorted or sorted list
; Preconditions: array size >= 15
; Registers Changed: eax, ebx, ecx, edx, ebp, esi
Display_List	PROC
	push	ebp
	mov		ebp, esp

	call	Crlf

	mov		edx, [ebp + 20]
	call	WriteString					; displays a title message
	mov		esi, [ebp + 16]				; move array to esi
	mov		ecx, [ebp + 8]				; move value in "request" to ecx
	mov		ebx, 0

	print_list:
		mov		eax, [esi]
		call	WriteDec				; print each number in the unsorted/sorted array
		mov		edx, [ebp + 12]
		call	WriteString				; print horizontal space
		add		esi, 4					; add 4 bytes (i.e., move to next index in array)
		inc		ebx
		cmp		ebx, 10
		jne		continue

		print_new_line:
			mov		ebx, 0
			call	Crlf

		continue:
			loop	print_list

	pop		ebp

	ret		16							; "display_list()" takes 4 paramters, so 4 * 4 = 16
Display_List	ENDP

; Description: swaps two numbers with indices next to each other
; Receives: array
; Returns: list with swapped numbers
; Preconditions: element at index i + 1 > element at index i
; Registers Changed: eax, ebx, ebp, esi, edi
Swap_Numbers	PROC
	push	ebp
	mov		ebp, esp
	push	eax							; store original value of eax onto stack frame (for use in sort function below)
	push	esi							; store array onto stack frame (for use in sort function below)

	mov		esi, [ebp + 8]				; store element 1 to be swapped in esi
	mov		edi, [ebp + 12]				; store element 2 to be swapped in edi

	; the code below is equivalent to the following in C/C++
	;			temp = a
	;			a = b
	;			b = temp
	mov		eax, esi
	mov		ebx, edi
	mov		esi, ebx
	mov		edi, eax
	mov		[ebp + 8], esi
	mov		[ebp + 12], edi
	
	pop		esi
	pop		eax
	pop		ebp

	ret
Swap_Numbers	ENDP

; Description: displays the sorted array
; Receives: array, request (array size)
; Returns: sorted list
; Preconditions: array size >= 15
; Registers Changed: eax, ecx, ebp, esi
Sort_List	PROC
	push	ebp
	mov		ebp, esp

	mov		ecx, [ebp + 8]				; move value in "request" to ecx
	sub		ecx, 1

	outer_loop:
		push	ecx						; save outer loop count
		mov		esi, [ebp + 12]			; point to first value

		inner_loop:
			mov		eax, [esi]			; get value in array
			cmp		[esi + 4], eax		; compare against next value in array
			jl		no_exchange
			push	[esi + 4]			; push element at current_index + 1 onto stack to swap
			push	[esi]				; push element at current_index onto stack to swap
			call	Swap_Numbers
			pop		[esi]
			pop		[esi + 4]

			no_exchange:
				add		esi, 4			; go to the next element
				loop	inner_loop
				pop		ecx				; retrieve outer loop count
				loop	outer_loop

	pop		ebp

	ret		8							; "sort_list()" takes 2 paramters, so 4 * 2 = 8
Sort_List	ENDP

; Description: displays the median of the array
; Receives: median_title, array, request	=>	(string message, array, and array size)
; Returns: median of the list
; Preconditions: none
; Registers Changed: eax, ebx, ecx, edx, ebp, edi
Display_Median	PROC
	push	ebp
	mov		ebp, esp

	call	Crlf
	call	Crlf
	call	Crlf

	mov		edx, [ebp + 16]
	call	WriteString					; display median title (string message)
	mov		edi, [ebp + 12]				; store array in edi
	mov		ecx, [ebp + 8]				; store value in "request" in ecx
	
	mov		eax, ecx
	mov		ebx, 2
	mov		edx, 0
	div		ebx
	cmp		edx, 1						; compare remainder against 1
	jne		even_array
	
													; odd array
	mov		ecx, 4
	mul		ecx							; eax = (request / 2) * ecx = size_of_array * 4
	mov		ebx, eax
	mov		eax, [edi + ebx]			; add edi to number of bytes in ebx to find the median value
	call	WriteDec
	jmp		exit2

	even_array:
		mov		ecx, eax
		dec		ecx
		mov		ebx, [edi + eax * 4]
		mov		edx, [edi + ecx * 4]
		add		ebx, edx				; add 2 middle values

		mov		eax, ebx
		mov		ecx, 2
		mov		edx, 0
		div		ecx						; divide sum by 2
		call	WriteDec				; print median

	exit2:

	pop		ebp

	ret		12							; "display_median()" takes 3 paramters, so 4 * 3 = 12
Display_Median	ENDP

END main