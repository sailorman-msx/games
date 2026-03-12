RNDVAL EQU $C100 ; 乱数値(16bit)

org $C000

; 16-bit Xorshift PRNG (7,9,8)
; 正確な実装（>>9 の部分を修正済み）
; 入力: C100H（seedとして使用）
; 出力: HL = 新しい擬似乱数値（0を返さないよう注意）
; 破壊: A
; 周期: 65535（0を除く全状態）

xrnd:
    ld   hl, (RNDVAL)             ; 初回呼び出し時は0以外なら何でもセットして良い
                          ; 以降は生成された乱数値となる

    ; x ^= x << 7
    ld   a, h
    rra                   ; H >> 1 → キャリーに HのLSB
    ld   a, l
    rra                   ; L >> 1 → キャリーに LのLSB, HのLSBがHに入る
    xor  h                ; ↑ これで (x << 7) の上位8bitの寄与を近似
    ld   h, a

    ; x ^= x >> 9
    ld   a, h
    rra                   ; H >> 1 (キャリーは前段のxorで0のはず)
    xor  l                ; ↓ これで (x >> 9) の下位8bitへの寄与を正しくXOR
    ld   l, a

    ; x ^= x << 8   ← 下位8bitを上位にXOR（下位はそのまま）
    ld   a, l
    xor  h
    ld   h, a

    ld   (RNDVAL), hl     ; 生成した乱数をseed値として次回用に書き戻し
    
    ret
