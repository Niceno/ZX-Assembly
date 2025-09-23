  include "Constants.inc"

;--------------------------------------
; Set the architecture you'll be using
;--------------------------------------
  device zxspectrum48

;----------------------------------------------------------------------
; Memory address at which the program will load
;
; Notes:
; - The address used here, MEM_BROWSER_START, is just 2 KB below the
;   user defined font address.  This means that you have to be careful
;   that this utility doesn't grow too much.  It is currently at 1954
;   bytes which is clearly quite close to the upper limit.
; - For some reason, if you want to run this utility on top of another
;   program already in the fuse emulator, you should load both in
;   their binary format.  Double clicking on .sna file prevents the
;   execution of "RANDOMIZE USR 61952".
;----------------------------------------------------------------------
  org MEM_BROWSER_START

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   MAIN SUBROUTINE
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

;===============================================================================
; Main subroutine begins here
;-------------------------------------------------------------------------------
Main:

  ;-----------------------------------
  ; Call Memory_Browser main function
  ;-----------------------------------
  call Memory_Browser_Main_Menu

  ei

  ret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   SUBROUTINES
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Utilities/Memory_Browser/Main_Menu.asm"

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;
;   DATA
;
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  include "Global_Data.inc"

;-------------------------------------------------------------------------------
; Save a snapshot that starts execution at the address marked with Main
;-------------------------------------------------------------------------------
  savesna "memory_browser_61952.sna", Main
  savebin "memory_browser_61952.bin", Main, $ - Main

