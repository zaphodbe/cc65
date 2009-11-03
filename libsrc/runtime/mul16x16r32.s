;
; Ullrich von Bassewitz, 2010-11-03
;
; CC65 runtime: 16x16 => 32 multiplication
;

        .export         umul16x16r32, _cc65_umul16x16r32
       	.export	       	mul16x16r32 := umul16x16r32
        .import         popax
    	.importzp   	ptr1, ptr2, ptr3, ptr4, sreg


;---------------------------------------------------------------------------
; 16x16 => 32 multiplication routine.
;
;   lhs         rhs           result          result also in
; -------------------------------------------------------------
;   ptr1        ax            ax:sreg          ptr1:sreg
;

_cc65_umul16x16r32:
        sta     ptr1
        stx     ptr1+1
        jsr     popax

umul16x16r32:
        sta     ptr3
        stx     ptr3+1
       	lda	#0
       	sta    	sreg+1
       	ldy    	#16   	       	; Number of bits

        lsr     ptr1+1
        ror     ptr1            ; Get first bit into carry
@L0:    bcc     @L1

      	clc
      	adc	ptr3
      	pha
       	txa	      	       	; hi byte of left op
      	adc	sreg+1
      	sta	sreg+1
      	pla

@L1:    ror     sreg+1
     	ror	a
     	ror	ptr1+1
     	ror	ptr1
        dey
        bne     @L0

        sta     sreg            ; Save byte 3
      	lda	ptr1	       	; Load the result
      	ldx	ptr1+1
      	rts	    		; Done
