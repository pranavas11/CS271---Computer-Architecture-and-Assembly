TITLE Program Template     (template.asm)

; Author: Pranav Prabhu
; Last Modified: 01/15/2022
; OSU email address: prabhup@oregonstate.edu
; Course number/section: CS271/Roger
; Assignment Number: 1                Due Date: 01/16/2022
; Description: Elementary Arithmetic Program

INCLUDE Irvine32.inc

.data
	; Note: the type "BYTE" allocates 1 byte & "DWORD" allocates 4 bytes
	; Note: ; "10" stands for newline & "0" stands for end-of-line to print (as per ASCII table)

	string			BYTE	"Elementary Arithmetic by Pranav Prabhu", 10, 0
	msg				BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 10, 0

	num1			DWORD	?
	prompt			BYTE	"First number: ", 0, 10
	num2			DWORD	?
	input			BYTE	"Second number: ", 0, 10

	sum				DWORD	?
	difference		DWORD	?
	product			DWORD	?
	quotient		DWORD	?
	remainder		DWORD	?
	square1			DWORD	?
	square2			DWORD	?

	addition		BYTE	" + ", 0
	subtraction		BYTE	" - ", 0
	multiplication	BYTE	" * ", 0
	division		BYTE	" / ", 0
	balance			BYTE	" remainder ", 0
	equals			BYTE	" = ", 0
	newline			BYTE	" ", 10, 0

	ec_msg1			BYTE	"***EC: Validate the second number to be less than the first.", 10, 0
	comparison_msg	BYTE	"The second number must be less than the first!", 10, 0
	ec_msg2			BYTE	"***EC: Display the square of each number entered.", 10, 0
	square_msg		BYTE	"Square of ", 0
	farewell		BYTE	"Impressed? Bye!", 10, 0

.code
main PROC
	; Note: 'OFFSET' is used to retrive the memory address of the stored string to print

	mov		edx, OFFSET string			; offset helps to load the memory address of the string variable into register
	call	WriteString					; prints the string stored in variable "string"

	mov		edx, OFFSET newline
	call	WriteString

	mov		edx, OFFSET ec_msg1
	call	WriteString

	mov		edx, OFFSET msg
	call	WriteString

	mov		edx, OFFSET prompt
	call	WriteString
	call	readint						; "readint" helps to take integer input (positive and negative) from the user
	mov		num1, eax					; move eax inside of num1 (destination comes first)

	mov		edx, OFFSET input
	call	writestring
	call	readint						; "readint" helps to take integer input (positive and negative) from the user
	mov		num2, eax					; move eax inside of num2 (destination comes first)


												; Comparison Code Block
	mov		ecx, num1
	mov		ebx, num2
	cmp		ecx, ebx

	jge	continue_program				; if num1 >= num2, jump to 'continue_program' section
		mov		edx, OFFSET comparison_msg
		call	writestring
		exit
	continue_program:					; exit comparison block


													; Addition Code Block
	mov		eax, num1					; move "num1" to "eax" inside the register
	mov		ecx, eax					; move "eax" to "ecx" (i.e., make a copy of num1 inside register)
	mov		eax, num2					; move "num2" to "eax" inside the register
	add		eax, ecx					; add both numbers
	mov		sum, eax					; store result in "sum" variable


													; Subtraction Code Block
	mov		eax, num1					; move "num1" to "eax" inside the register
	mov		ecx, eax					; move "eax" to "ecx" (i.e., make a copy of num1 inside register)
	mov		eax, num2					; move "num2" to "eax" inside the register
	sub		ecx,eax						; subtract both numbers (i.e., ecx -= eax -> C/C++ method)
	mov		eax, ecx					; put the subtracted result in eax
	mov		difference, eax				; store result in "difference" variable


													; Multiplication Code Block
	mov		eax, num1					; move "num1" to "eax" inside the register
	mov		ecx, eax					; move "eax" to "ecx" (i.e., make a copy of num1 inside register)
	mov		eax, num2					; move "num2" to "eax" inside the register
	mul		ecx							; "mul" can only take 1 argument (here just "num1" or "ecx" is fine), and under the hood, it is ecx * eax
	mov		product, eax				; store result in "product" variable


													; Division Code Block
	mov		eax, num1					; move "num1" to the "eax" register
	mov		ecx, eax					; move "eax" to "ecx" (i.e., make a copy of num1 inside register)
	mov		eax, num2					; move "num2" to the "eax" register
	mov		eax, num1					; move "num1" to the "eax" register
	mov		edx, 0						; clear out "edx" to print remainder
	div		num2						; "div" can only take 1 argument (here just "num1" or "ecx" is fine), and under the hood, it is num1 / num2
	mov		quotient, eax				; store result in "quotient" variable
	mov		remainder, edx				; store result in "remainder" variable
	mov		eax, remainder				; store remainder in eax register
	

													; Square Code Block
	mov		eax, num1
	mul		eax							; squares num1 entered
	mov		square1, eax				; store result in "square1" variable
	mov		eax, num2
	mul		eax							; squares num2 entered
	mov		square2, eax				; store result in a variable


													; Print Sum
	mov		eax, num1
	call	WriteDec
	mov		ecx, eax
	mov		edx, OFFSET addition		; move addition symbol into edx in the register
	call	WriteString					; print the addition symbol
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET equals			; move the equals symbol into edx in the register
	call	WriteString					; print the equals symbol
	mov		eax, sum					; move calculated sum into ecx register
	call	WriteDec					; print the sum

	mov		edx, OFFSET newline
	call	WriteString

													; Print Difference
	mov		eax, num1
	call	WriteDec
	mov		ecx, eax
	mov		edx, OFFSET subtraction		; move subtraction symbol into edx in the register
	call	WriteString					; print the subtraction symbol
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, difference				; move calculated difference into ecx register
	call	WriteDec					; print the difference

	mov		edx, OFFSET newline
	call	Writestring

													; Print Product
	mov		eax, num1
	call	WriteDec
	mov		ecx, eax
	mov		edx, OFFSET multiplication	; move multiplication symbol into edx in the register
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, product				; move calculated product into ecx register
	call	WriteDec					; print the product

	mov		edx, OFFSET newline
	call	WriteString

													; Print Quotient & Remainder
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET division		; move division symbol into edx in the register
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, quotient				; move calculated quotient into eax register
	call	WriteDec					; print the quotient
	mov		edx, OFFSET balance			; move balance variable (string) into edx register
	call	WriteString					; print remainder message
	mov		eax, remainder				; store remainder in eax register
	call	WriteDec					; print the remainder

	mov		edx, OFFSET newline
	call	writestring
	mov		edx, OFFSET newline
	call	WriteString
	mov		edx, OFFSET newline
	call	WriteString

	mov		edx, OFFSET ec_msg2
	call	WriteString

														; Print Squares
	mov		edx, OFFSET square_msg
	call	WriteString
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, square1				; move square result of num1 into eax register
	call	WriteDec					; print square of num1

	mov		edx, OFFSET newline
	call	WriteString

	mov		edx, OFFSET square_msg
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, square2				; move square result of num2 into eax register
	call	WriteDec					; print square of num2
			
	mov		edx, OFFSET newline
	call	WriteString
	mov		edx, OFFSET newline
	call	WriteString
	mov		edx, OFFSET newline
	call	WriteString

														; Farewell Message
	mov		edx, OFFSET farewell
	call	WriteString

	exit								; exit to operating system
main ENDP

END main