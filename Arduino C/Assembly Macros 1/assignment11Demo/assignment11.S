#include <avr/io.h>
#include "asmMacros.s"  // Include macros to print log messages or a single register
.text


.global slowDivisionUint8
slowDivisionUint8:
  // TODO: uint8_t slowDivisionUint8(uint8_t a, uint8_t b)
  ldi r20, 0
  cp r24, r22
  brlo answer
  
subtract:
  sub r24, r22
  inc r20
  cp r24, r22
  brsh subtract
  
answer:
  mov r24, r20
  ret


.global greaterThanOrEqualUInt16
greaterThanOrEqualUInt16:
  // TODO: bool greaterThanOrEqualUInt16(uint16_t a, uint16_t b)
  ldi r20, 1
  cp r23, r25
  brlo ans1
  cp r25, r23
  brlo ans2
  cp r24, r22
  brsh ans1
  
ans2:
  ldi r20, 0
  
ans1:
  mov r24, r20
  ret


.global slowDivisionUint16
slowDivisionUint16:
  // TODO: uint16_t slowDivisionUint16(uint16_t a, uint16_t b)
  ldi r20, 1
  ldi r19, 0
  ldi r18, 0
  cp r23, r25
  brlo subtract1
  cp r24, r22
  brlo answer1
  
subtract1:
  sub r24, r22
  sbc r25, r23
  add r18, r20
  adc r19, r1
  push r24
  push r25
  call greaterThanOrEqualUInt16
  mov r21, r24 
  pop r25
  pop r24
  cp r21, r20
  brsh subtract1
  
answer1:
  movw r24, r18
  ret

.global slowModulusUint8
slowModulusUint8:
  // TODO: uint16_t slowModulusUint8(uint8_t a, uint8_t b)
  ldi r25, 0
  cp r24, r22
  brlo answer2
  
subtract2:
  sub r24, r22
  cp r24, r22
  brsh subtract2
  
answer2:
  ret

.global sumOddsUint8
sumOddsUint8:
  // TODO uint16_t sumOddsUint8(uint8_t a, uint8_t b)
  mov r18, r24
  mov r20, r22
  ldi r22, 2
  call slowModulusUint8
  cp r1, r24
  mov r24, r18
  brlo add
  ldi r19, 1
  add r18, r19
  add r24, r19
  
 add:
  clc
  add r18, r22
  cp r20, r18
  brlo answer3
  adc r24, r18
  adc r25, r1
  cp r18, r20
  brlo add
  
 answer3:
  ret
