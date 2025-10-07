;-----------
; Version 3
;-----------
frame_v3_address_table:
  defw frame_v3_q1
  defw frame_v3_q2
  defw frame_v3_q3
  defw frame_v3_q4
  defw frame_v3_up
  defw frame_v3_down
  defw frame_v3_left
  defw frame_v3_right

frame_v3_q1:     defb  %00111111
                 defb  %01000000
                 defb  %10100000
                 defb  %10010000
                 defb  %10001000
                 defb  %10000100
                 defb  %10000011
                 defb  %10000010

frame_v3_q2:     defb  %11111100
                 defb  %00000010
                 defb  %00000101
                 defb  %00001001
                 defb  %00010001
                 defb  %00100001
                 defb  %11000001
                 defb  %01000001

frame_v3_q3:     defb  %10000010
                 defb  %10000011
                 defb  %10000100
                 defb  %10001000
                 defb  %10010000
                 defb  %10100000
                 defb  %01000000
                 defb  %00111111

frame_v3_q4:     defb  %01000001
                 defb  %11000001
                 defb  %00100001
                 defb  %00010001
                 defb  %00001001
                 defb  %00000101
                 defb  %00000010
                 defb  %11111100

frame_v3_up:     defb  %11111111
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %11111111
                 defb  %00000000

frame_v3_down:   defb  %00000000
                 defb  %11111111
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %00000000
                 defb  %11111111

frame_v3_left:   defb  %10000010
                 defb  %10000010
                 defb  %10000010
                 defb  %10000010
                 defb  %10000010
                 defb  %10000010
                 defb  %10000010
                 defb  %10000010

frame_v3_right:  defb  %01000001
                 defb  %01000001
                 defb  %01000001
                 defb  %01000001
                 defb  %01000001
                 defb  %01000001
                 defb  %01000001
                 defb  %01000001
