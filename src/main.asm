[org 0x7c00]


start:
  mov ax, 1023d
  call print_dec

  .hang:
    cli
    hlt
    jmp .hang

; input: ax = 16-bit unsigned number to print
print_dec:
  push ax
  push bx
  push cx
  push dx

  mov bx, 10  ; Base 10 divisor
  xor cx, cx  ; cx is 0, will count the number of digits

  .divide_loop:
    xor dx, dx  ; Clear dx before dividing dx:ax
    div bx      ; ax = quotient, dx = remainder
    add dl, '0' ; convert remainder to ascii char ('0' + 0->9)
    push dx     ; push the ascii char onthe stack
    inc cx      ; increment digit coumnter
    test ax, ax ; check if quotient is 0
    jnz .divide_loop  ; if not zero, repeat.

  .print_loop:
    pop ax  ; pop the next digit character into al
    mov ah, 0x0e
    int 0x10
    loop .print_loop

  pop dx
  pop cx
  pop bx
  pop ax
  ret

; Boot signature
times 510-($-$$) db 0
dw 0xaa55