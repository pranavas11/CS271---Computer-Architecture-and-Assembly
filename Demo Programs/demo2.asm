TITLE Program Template     (template.asm)

; Author: Roger
; Last Modified: 1/18/22
; OSU email address: 
; Course number/section: CS 271
; Assignment Number:                 Due Date:
; Description: Get two numbers from the user, and 
;              output the sum of ints from the 1st num to the 2nd

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
	prompt_1	BYTE	"Enter lower limit: ", 0
	prompt_2	BYTE	"Enter upper limit: ", 0
	low_limit	DWORD	?
	up_limit	DWORD	?

.code
main PROC

; (insert executable instructions here)

; // get the user inputs: 2 numbers
	; // low limit
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		low_limit, eax

	; //up limit
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		up_limit, eax

; // data validation: swap low_limit and up_limit if low > up
	mov		ebx, low_limit
	cmp		ebx, eax
	jle		inputOK
	mov		up_limit, ebx
	mov		low_limit, eax

; // do calculation 
inputOK:
	; // set up the accumulator, eax 
	mov		eax, 0
	mov		ebx, low_limit

	; // set up the counter: up_limit - low_limit + 1
	mov		ecx, up_limit
	sub		ecx, low_limit
	inc		ecx

	;//loop body
top:
	add		eax, ebx
	inc		ebx
	loop	top



; // print the result 
	call	WriteDec




	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
