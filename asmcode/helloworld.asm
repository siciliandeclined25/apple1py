JSR !start
start:
    JMP !loop
loop:
    INX
    TXA
    STA $D012
    CMP #3E
    BEQ !end
    NOP
    JMP !loop
end:
    LDX #00
    RTS
