# --- Params ----------------------------------------------------
start  = 1            # first top-left coord
step   = 16           # spacing between top-lefts
last   = 254          # max row/col in world space
size   = 14           # default tile height/width
color  = "GREEN_PAPER"  # default tile color for records

# If True, the first generated tile id will be 1 (so 01, 02...), else 0
start_tid_at_1 = True

# Optional per-tile overrides
# You can key by tile id (after numbering) OR by (row, col) coordinate.
# Each override can set: "h" (height), "w" (width), "color" (string)
overrides_by_tid = {
    # 1: {"h": 3, "w": 3, "color": "RED_PAPER + BRIGHT"},
    # 2: {"h": 3, "w": 3, "color": "CYAN_PAPER + BRIGHT"},
}
overrides_by_xy = {
    # (128,128): {"h": 3,  "w": 3,  "color": "RED_PAPER + BRIGHT"},
    # (131,131): {"h": 3,  "w": 3,  "color": "CYAN_PAPER + BRIGHT"},
    # (128,131): {"h": 3,  "w": 3,  "color": "YELLOW_PAPER + BRIGHT"},
    # (131,128): {"h": 3,  "w": 3,  "color": "GREEN_PAPER + BRIGHT"},
    # (134,134): {"h": 12, "w": 16, "color": "MAGENTA_PAPER"},
    # (110,106): {"h": 12, "w": 16, "color": "MAGENTA_PAPER"},
    # (0,  128): {"h": 2,  "w": 3,  "color": "BLACK_PAPER"},  # over the top
    # (254,128): {"h": 2,  "w": 3,  "color": "BLACK_PAPER"},  # rock bottom
    # (128,0):   {"h": 3,  "w": 2,  "color": "BLACK_PAPER"},  # far left
    # (128,254): {"h": 3,  "w": 2,  "color": "BLACK_PAPER"},  # far right
}

# --- Generation ------------------------------------------------
# Build the list of tile placements (top-lefts)
coords = []
for r0 in range(start, last + 1, step):
    for c0 in range(start, last + 1, step):
        coords.append((r0, c0))

# Numbering
tid0 = 1 if start_tid_at_1 else 0
tiles = []  # list of dicts: {"tid", "row", "col", "h", "w", "color"}
for i, (r, c) in enumerate(coords):
    tid = tid0 + i
    ov = overrides_by_xy.get((r, c), {}) | overrides_by_tid.get(tid, {})
    h = ov.get("h", size)
    w = ov.get("w", size)
    clr = ov.get("color", color)
    tiles.append({"tid": tid, "row": r, "col": c, "h": h, "w": w, "color": clr})

# --- Output ----------------------------------------------------
# Header: world definition
print(";-------------------------")
print("; Definition of the world")
print(";-------------------------")
print("world_address_table:")
print("; type           row  col   definition")
# Mandatory world-filling ground tile first
print("  db WORLD_TILE,   1,   1 : dw tile_ground     ; covers the whole world and it is a MUST!!!")

# World entries
for t in tiles:
    # Format: db WORLD_TILE, r, c : dw tile_XX_record
    print(f"  db WORLD_TILE, {t['row']:3d}, {t['col']:3d} : dw tile_{t['tid']:03d}_record")

print("  db WORLD_END                       ; this marks the end of the world\n")

# Tile records
print(";----------------------------------------")
print("; Tile records")
print(";----------------------------------------")
print(";                   dimensions   color")
print("tile_ground   :  db  254,  254,  GREEN_PAPER")
for t in tiles:
    print(f"tile_{t['tid']:03d}_record:  db {t['h']:4d}, {t['w']:4d},  {t['color']}")

