;===============================================================================
; Browse_Memory
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
Browse_Memory:

  ld A, (MEM_STORE_SCREEN_COLOR)  ; set color into A
  call Clear_Screen               ; clear the screen

  ; Imagine this is the desired memory address you want to print from
  ld HL, $0000  ; should be divisable by 8

.browse_some_more
  push HL       ; save it for the later, when the keys are pressed

  ;---------------------------------------------------------------
  ; Oh well, this is the central thing here, dump those 128 bytes
  ;---------------------------------------------------------------
  call Dump_Memory

  ;-----------------------
  ; Create a little delay
  ;-----------------------
  ld B, 5
  call Delay

  ;-----------------------
  ; Loop for reading keys
  ;-----------------------
.wait_for_keys

    call Browse_Key_Rows      ; A = code, C bit0 = 1 if pressed

    ld HL, key_to_quit : cp (HL)  ; is the key "0" pressed?  Set z if so
    jr z, .done_browsing          ; quit if it is so, quit if "0" was pressed

    ld HL, key_for_line_down : cp (HL)
    jr z, .wanna_go_line_down

    ld HL, key_for_page_down : cp (HL)
    jr z, .wanna_go_page_down

    ld HL, key_for_book_down : cp (HL)
    jr z, .wanna_go_book_down

    ld HL, key_for_line_up : cp (HL)
    jr z, .wanna_go_line_up

    ld HL, key_for_page_up : cp (HL)
    jr z, .wanna_go_page_up

    ld HL, key_for_book_up : cp (HL)
    jr z, .wanna_go_book_up

    jr .wait_for_keys

  ;-----------------------------------------
  ; Book down is like increasing 1024 bytes
  ;-----------------------------------------
.wanna_go_book_down
  pop HL
  ld  DE, $0400
  add HL, DE
  jp .browse_some_more

  ;----------------------------------------
  ; Page down is like increasing 128 bytes
  ;----------------------------------------
.wanna_go_page_down
  pop HL
  ld  DE, $0080
  add HL, DE
  jp .browse_some_more

  ;--------------------------------------
  ; Line down is like increasing 8 bytes
  ;--------------------------------------
.wanna_go_line_down
  pop HL
  ld  DE, $0008
  add HL, DE
  jp .browse_some_more

  ;------------------------------------
  ; Line up is like decreasing 8 bytes
  ;------------------------------------
.wanna_go_line_up
  pop HL
  ld  DE, $0008
  sub HL, DE
  jp .browse_some_more

  ;--------------------------------------
  ; Page up is like decreasing 128 bytes
  ;--------------------------------------
.wanna_go_page_up
  pop HL
  ld  DE, $0080
  sub HL, DE
  jp .browse_some_more

  ;---------------------------------------
  ; Book up is like decreasing 1024 bytes
  ;---------------------------------------
.wanna_go_book_up
  pop HL
  ld  DE, $4000
  sub HL, DE
  jp .browse_some_more

  ;----------------------------------
  ; You get here when "0" is pressed
  ;----------------------------------
.done_browsing:
  pop HL

  jp Memory_Browser_Main_Menu

  ret

