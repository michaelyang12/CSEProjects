#include <avr/io.h>
#include "asmMacros.s"  // Include macros to print log messages or a single register
.data
globalasm: .byte 0

.text


.global updateGlobal
updateGlobal:
  // TODO: void updateGlobal(byte a)
  ldi r31, hi8(globalasm)
  ldi r30, lo8(globalasm)
  ld r20, Z
  add r24, r20
  st Z, r24
  ret


.global getGlobal
getGlobal:
  // TODO: uint8_t getGlobal()
  ldi r31, hi8(globalasm)
  ldi r30, lo8(globalasm)
  ld r24, Z
  ret


.global cStringLength
cStringLength:
  // TODO: uint8_t cStringLength(const char aString[])
  movw r30, r24
  clr r24
  ld r20, Z+
  cp r24, r20
  brsh a
  
 add:
  inc r24
  ld r20, Z+
  cp r1, r20
  brlo add

 a:
  ret

.global sumArrays
sumArrays:
  // TODO: void sumArrays(uint8_t *a, uint8_t *b, uint8_t *c, byte length)
  ldi r19, 0
  cp r19, r18
  brsh b
  movw r26, r20
  movw r30, r24
  push r28
  push r29
  movw r28, r22

 add2:
  ld r22, Y+
  ld r24, Z+
  inc r19
  add r24, r22
  st X+, r24
  cp r19, r18
  brlo add2

 b:
  pop r29
  pop r28
  ret

.global dot
dot:
  // TODO uint16_t dot(uint8_t *a, uint8_t *b, byte length)
  ldi r17, 0
  cp r17, r20
  brsh c
  movw r30, r24
  movw r26, r22
  clr r24
  clr r25
  
 sum:
  inc r17
  ld r18, Z+
  ld r19, X+
  mul r18, r19
  add r24, r0
  adc r25, r1
  cp r17, r20
  brlo sum
  
 c:
  ret
