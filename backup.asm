; Data Segment
my_data segment
    CONTROL EQU 06H        ; I/O port for control
    PORTA   EQU 00H        ; I/O port for PORTA
    PB      EQU 02H        ; I/O port for PB
    PC      EQU 04H        ; I/O port for PC
my_data ends

; Code Segment
mycode segment
    mov ax, my_data         ; Load the data segment address into AX
    mov ds, ax              ; Set DS to point to the data segment

Start:
    ; Initialize memory at 1000h with values
    mov [1000h], 0C0H
    mov [1001h], 0F9H
    mov [1002h], 0A4H
    mov [1003h], 0B0H
    mov [1004h], 099H
    mov [1005h], 092H
    mov [1006h], 082H
    mov [1007h], 0F8H
    mov [1008h], 080H
    mov [1009h], 090H

    ; Output binary value 10000010B to the CONTROL port
    mov al, 10000010B
    mov dx, CONTROL
    out dx, al

again:
    ; Input the value from PB and store it in memory at 2000h
    mov dx, PB
    in al, dx
    mov [2000h], al

    ; Convert the binary value to decimal
    mov cl, 0AH
    mov dx, 00H
    div cx
    mov [1031h], dl
    inc si
    mov dx, 00H
    div cl
    mov [1032h], ah

    ; Compare the value at 2000h
    mov al, [2000h]
    cmp al, 26D
    jc light_on
    cmp al, 31D
    jnc light_off
    jmp display

light_on:
    ; Set the values for light_on condition
    mov [1200h], 05h
    mov [1201h], 06h
    jmp display

light_off:
    ; Set the values for light_off condition
    mov [1200h], 01h
    mov [1201h], 02h
    jmp display

display:
    ; Output the value in memory at 1200h to the PC port
    mov al, [1200h]
    mov dx, PC
    out dx, al

    ; Output the converted decimal value to PORTA
    mov bh, 10h
    mov bl, [1032h]
    mov al, [bx]
    mov dx, PORTA
    out dx, al

    ; Call the delay subroutine
    call DELAY_S

    ; Output the value in memory at 1201h to the PC port
    mov al, [1201h]
    mov dx, PC
    out dx, al

    ; Output the converted decimal value to PORTA
    mov bh, 10h
    mov bl, [1031h]
    mov al, [bx]
    mov dx, PORTA
    out dx, al

    ; Call the delay subroutine
    call DELAY_S

    ; Jump to the beginning of the loop
    jmp again

; Subroutine for delay
DELAY_S PROC NEAR
    PUSH CX
    MOV CX, 0FFH
RPT2:
    LOOP RPT2
    POP CX
    RET
DELAY_S ENDP

mycode ends
end
