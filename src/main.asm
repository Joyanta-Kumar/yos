mov bl, 0d97
mov bh, 0d65

mov ah, 0x0e

loop:
  mov al, bh
  int 0x10
  inc bh
  inc bh

  inc bl
  mov al, bl
  int 0x10
  inc bl

  cmp bl, 'z'
  jg exit

  jmp loop


exit:
  jmp $

times 510-($-$$) db 0
db 0x55, 0xaa