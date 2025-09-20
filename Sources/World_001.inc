;-------------------------
; Definition of the world
;-------------------------
world_address_table:
  dw tile_00_record  ; this covers the whole world
  dw tile_01_record
  dw tile_02_record
  dw tile_03_record
  dw tile_04_record
  dw tile_05_record  ; starts inside, but breaks out at lower right
  dw tile_06_record  ; starts outside, but protrudes from upper left
  dw tile_07_record  ; everything smaller than min row
  dw tile_08_record  ; everything greater than max row
  dw tile_09_record  ; everything smaller than min col
  dw tile_10_record  ; everything greater than max col
  dw $0000           ; this marks the end of the world

;----------------------------------------
; Tile records
;----------------------------------------
;                    row0  col0  row1  col1  color
tile_000_record:  db    1,    1,   16,   16, GREEN_PAPER
tile_000_record:  db   17,    1,   32,   16, GREEN_PAPER
tile_000_record:  db   33,    1,   48,   16, GREEN_PAPER
tile_000_record:  db   49,    1,   64,   16, GREEN_PAPER
tile_000_record:  db   63,    1,   80,   16, GREEN_PAPER
tile_000_record:  db   81,    1,   96,   16, GREEN_PAPER
tile_000_record:  db   97,    1,  112,   16, GREEN_PAPER
tile_000_record:  db   17,    1,  128,   16, GREEN_PAPER
tile_000_record:  db   17,    1,  144,   16, GREEN_PAPER
tile_000_record:  db   17,    1,  160,   16, GREEN_PAPER
tile_000_record:  db   17,    1,  176,   16, GREEN_PAPER
tile_000_record:  db   17,    1,  192,   16, GREEN_PAPER
tile_000_record:  db   17,    1,  208,   16, GREEN_PAPER
tile_000_record:  db   17,    1,  224,   16, GREEN_PAPER
tile_000_record:  db   17,    1,  240,   16, GREEN_PAPER
tile_000_record:  db   17,    1,  256,   16, GREEN_PAPER

