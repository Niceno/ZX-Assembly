;-----------
; Version 4
;-----------
frame_v4_address_table:
  defw frame_v4_q1
  defw frame_v4_q2
  defw frame_v4_q3
  defw frame_v4_q4
  defw frame_v4_up
  defw frame_v4_down
  defw frame_v4_left
  defw frame_v4_right

frame_v4_q1:     defb  %10000000
                 defb  %00000000
                 defb  %10000000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100010

frame_v4_q2:     defb  %00000000
                 defb  %00000001
                 defb  %00000010
                 defb  %00000101
                 defb  %00001010
                 defb  %00010101
                 defb  %00101010
                 defb  %01010101

frame_v4_q3:     defb  %10001000
                 defb  %00100011
                 defb  %10000110
                 defb  %00101011
                 defb  %10001110
                 defb  %00111011
                 defb  %01101110
                 defb  %10111011

frame_v4_q4:     defb  %10101010
                 defb  %10010101
                 defb  %11101010
                 defb  %10110101
                 defb  %11101010
                 defb  %10111001
                 defb  %11101110
                 defb  %10111011

frame_v4_up:     defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000

frame_v4_down:   defb  %11101110
                 defb  %10111011
                 defb  %11101110
                 defb  %10111011
                 defb  %11101110
                 defb  %10111011
                 defb  %11101110
                 defb  %10111011

frame_v4_left:   defb  %10001000
                 defb  %00100010
                 defb  %10001000
                 defb  %00100010
                 defb  %10001000
                 defb  %00100010
                 defb  %10001000
                 defb  %00100010

frame_v4_right:  defb  %10101010
                 defb  %01010101
                 defb  %10101010
                 defb  %01010101
                 defb  %10101010
                 defb  %01010101
                 defb  %10101010
                 defb  %01010101

;-----------
; Version 5
;-----------
frame_version_5:
  defw frame_v5_q1
  defw frame_v5_q2
  defw frame_v5_q3
  defw frame_v5_q4
  defw frame_v5_up
  defw frame_v5_down
  defw frame_v5_left
  defw frame_v5_right

frame_v5_q1:     defb  %10000000
                 defb  %00000000
                 defb  %10000000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100000

frame_v5_q2:     defb  %00000000
                 defb  %00000001
                 defb  %00000010
                 defb  %00000101
                 defb  %00001010
                 defb  %00010101
                 defb  %00101010
                 defb  %00010101

frame_v5_q3:     defb  %10001000
                 defb  %00100000
                 defb  %10000110
                 defb  %00101011
                 defb  %10001110
                 defb  %00111011
                 defb  %01101110
                 defb  %10111011

frame_v5_q4:     defb  %00101010
                 defb  %00010101
                 defb  %11101010
                 defb  %10110101
                 defb  %11101010
                 defb  %10111001
                 defb  %11101110
                 defb  %10111011

frame_v5_up:     defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000

frame_v5_down:   defb  %00000000
                 defb  %00000000
                 defb  %11101110
                 defb  %10111011
                 defb  %11101110
                 defb  %10111011
                 defb  %11101110
                 defb  %10111011

frame_v5_left:   defb  %10001000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100000
                 defb  %10001000
                 defb  %00100000

frame_v5_right:  defb  %00101010
                 defb  %00010101
                 defb  %00101010
                 defb  %00010101
                 defb  %00101010
                 defb  %00010101
                 defb  %00101010
                 defb  %00010101


