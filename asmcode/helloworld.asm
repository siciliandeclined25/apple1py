JSR !start
start:
    JMP !loop
loop:
    INX
    TXA
    STA $D012
    CMP #3E
    BEQ #06
    NOP
    JMP !loop
end:
    LDX #00
    RTS
