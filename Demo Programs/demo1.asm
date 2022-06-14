TITLE Program Template     (template.asm)

; Author: 
; Last Modified:
; OSU email address: 
; Course number/section:
; Assignment Number:                 Due Date:
; Description:

INCLUDE Irvine32.inc

; (insert constant definitions here) 
; declare yard to inch factor here 
YARD_TO_INCH_FACTOR = 36

.data

; (insert variable definitions here)
	intro		BYTE		"Hi there, this is Roger", 13, 10, "This program is going to convert yard to inches", 0
	result_1	BYTE		"That's ....", 0
	result_2	BYTE		" in inches", 0
	inches		DWORD		? 
	yard		DWORD		?
	good_bye	BYTE		"Good Bye ", 0
	username	BYTE		33 DUP(0)		;string enter by the user, initialized to 0 

	prompt_1	BYTE		"What's your name? ", 0
	prompt_2	BYTE		"Enter yard(s): ", 0


.code
main PROC

; (insert executable instructions here)

; 1. Introduce the programmer
	
	mov		edx, OFFSET intro
	call	WriteString
	call	Crlf
	 

; 2. Get the name from the user 
	mov		edx, OFFSET prompt_1
	call	WriteString

	mov		edx, OFFSET username
	mov		ecx, 32
	call	ReadString


; 3. Get the yards from the user 
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt		;	user input will be stored in eax 
	mov		yard, eax

; 4. Calculation 
	mov		eax, yard
	mov		ebx, YARD_TO_INCH_FACTOR
	mul		ebx				; result is stored in eax 
	mov		inches, eax


	;testing 
	;mov		eax, 99999999999
	;cdq
	;mov		ebx, 1
	;div		ebx

; 5. Report the result 
	mov		edx,	OFFSET result_1
	call	WriteString
	mov		eax,	inches
	call	WriteDec	; call WriteInt
	mov		edx,	OFFSET result_2
	call	WriteString
	call	Crlf



; 6. Farewell "Goodbye" 
	mov		edx, OFFSET good_bye
	call	WriteString

	mov		edx, OFFSET username
	call	WriteString
	call	Crlf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
