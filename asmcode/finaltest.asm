        .org $0600

start:
        sei                 ; implied - disable interrupts
        cld                 ; implied - clear decimal
        txs                 ; implied - set stack pointer (safe)
        ldx #$ff
        txs

; ------ immediate addressing ------
        lda #$12            ; immediate
        ldx #$03            ; immediate
        ldy #$05            ; immediate

; ------ zero page / zero page,X / zero page,Y ------
        sta $10             ; zero page
        stx $11             ; zero page
        sty $12             ; zero page
        lda $10             ; zero page load
        lda $10,x           ; zero page,x (load uses wrap)
        lda $10,y           ; zero page,y

; ------ absolute / absolute,X / absolute,Y ------
        sta $0800           ; absolute
        sta $0801,x         ; absolute,x
        sta $0802,y         ; absolute,y
        lda $0800           ; absolute
        lda $0800,x         ; absolute,x
        lda $0800,y         ; absolute,y

; ------ indexed-indirect (zp,x) and indirect-indexed (zp),y ------
        lda ($20,x)         ; (zp,x) indexed-indirect
        lda ($20),y         ; (zp),y indirect-indexed

; prepare indirect vectors and zp pointers
        lda #$34
        sta $24
        lda #$07
        sta $25
        lda #$55
        sta $26
        lda #$06
        sta $27

; make an absolute pointer for jmp (indirect)
        lda #<jmptarget
        sta $300
        lda #>jmptarget
        sta $301

; ------ indirect (only for jmp) ------
        jmp ($0300)         ; indirect addressing (JMP)

; (if jmp worked, execution continues at jmptarget)

jmptarget:
; ------ accumulator mode ------
        lda #$80
        asl a               ; asl accumulator
        lsr a               ; lsr accumulator
        rol a               ; rol accumulator
        ror a               ; ror accumulator

; ------ memory shift/rotate ------
        lda #$01
        sta $30
        asl $30             ; asl zeropage (memory)
        lsr $30
        rol $30
        ror $30

; ------ logic / arithmetic / compare (various modes) ------
        lda #$0f
        eor #$ff            ; immediate
        ora $30             ; zero page
        and $0800           ; absolute

        adc #$01            ; immediate
        sbc #$01            ; immediate

        cmp #$10            ; immediate
        cpx #$03            ; immediate
        cpy #$05            ; immediate

; ------ increment / decrement ------
        inc $40             ; absolute
        dec $40             ; absolute
        inx                 ; implied
        iny                 ; implied
        dex                 ; implied
        dey                 ; implied

; ------ transfers ------
        tax                 ; implied
        tay                 ; implied
        txa                 ; implied
        tya                 ; implied
        tsx                 ; implied
        txs                 ; implied

; ------ stack ops & processor-status ops ------
        pha                 ; implied (push a)
        pla                 ; implied (pull a)
        php                 ; implied (push p)
        plp                 ; implied (pull p)

; ------ flag set/clear ------
        sec                 ; implied
        clc                 ; implied
        sed                 ; implied
        cld                 ; implied
        sei                 ; implied
        cli                 ; implied
        clv                 ; implied

; ------ branches (relative) ------
        lda #$01
        beq B_never         ; branch equal (won't take)
        bne br_taken        ; branch not-equal (will take)
B_never:
        bmi B_never2
        bpl B_never2
B_never2:
        bcc bcctest
        bcs bcstest
        bvc B_never3
        bvs B_never3
        bra skip_branches   ; (if assembler supports BRA; if not, use jmp)
skip_branches:
        jmp after_branches
br_taken:
        nop
        jmp after_branches

bcctest:
        clc
        bcc took_bcc
        jmp after_branches
took_bcc:
        nop

bcstest:
        sec
        bcs took_bcs
        jmp after_branches
took_bcs:
        nop

B_never3:
        nop

after_branches:

; ------ bit instruction (zp and abs) ------
        lda #$80
        sta $50
        bit $50             ; zero page
        bit $0800           ; absolute

; ------ jsr / rts ------
        jsr subroutine      ; implied (jsr absolute)
        jmp post_jsr

subroutine:
        pha
        txa
        pla
        rts                 ; return from jsr

post_jsr:

; ------ rti and brk demonstration (careful: uses stack) ------
; simulate an interrupt frame: push pc+1 low, high, push p, then rti will pull and return.
        lda #<rti_target
        ldy #>rti_target
        ; push return address low/high then p
        lda #<rti_target
        pha
        lda #>rti_target
        pha
        php                 ; push status
        rti                 ; will pull p, pcl, pch and jump to rti_target

rti_target:
        nop

; ------ jmp indirect,x and indirect,y already covered by lda ($20,x) and ($20),y usage above

; ------ store instructions in varied modes ------
        lda #$aa
        sta $60             ; abs
        sta $60,x           ; abs,x
        sta $60,y           ; abs,y
        sta $70             ; zp
        sta $70,x           ; zp,x

        ldx #$77
        stx $80             ; zp
        stx $0802           ; abs
        sty $0900           ; abs

; ------ test bitwise shifts on memory with indexed modes ------
        lda #$12
        sta $30
        asl $30,x           ; zero page,x
        lsr $30,y           ; zero page,y (assembler may restrict; some ops allow zp,y pseudo)

; ------ miscellaneous ops often present ------
        nop                 ; implied

; ------ end loop / finish ------
        cli
        rts                 ; return to monitor / emulator

; data and zero page pointers used by indirect tests
        .org $0080
zp_table:
        .byte $00,$06,$00,$07  ; pointers for ($20,x) and ($20),y etc
        .org $0200
        .byte $00

; ensure jmptarget label exists earlier; if assembler moves sections, jmptarget already defined.

        .org $0800
jmptarget_data:
        .byte $00

        .org $0700
; absolute memory used above ($0800 etc) placed by assembler directives; adjust as needed.

        .end
