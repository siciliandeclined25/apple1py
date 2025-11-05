        LDX #$03      ; X = 3
        TXS           ; SP = X = 3
        LDX #$00      ; X = 0 (temporary change)
        TSX           ; X = SP = 3
        BRK           ; Stop, X=3 and SP=3
