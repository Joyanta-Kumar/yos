org 0x7C00
; Assembler is directed to assume 0x7C00 as the 
; virtual 0'th memory address. Becuase,
; BIOS puts our OS in memory starting
; from this address.

bits 16
; assembler is directed to produce 16 bit code
; for backward compatibility (8086).
; A 64-bit processor can run 16-bit codes


main:
  hlt

.done:
  jmp .done


times 510 - ($-$$) db 0x0
db 0xAA
db 0x55