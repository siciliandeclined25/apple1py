start:
JMP !loop
final:
    STA $D012
    JMP !veryend
loop:
    INX
    TXA
    CMP #01
    BEQ !final
    JMP !loop
veryend:
    BRK
