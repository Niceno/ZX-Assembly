import sys
import os

def convert_sprite(filename):
    with open(filename, 'r') as f:
        lines = [line.rstrip('\n')[:8].ljust(8) for line in f]

    for row in lines:
        binary_str = ''.join('1' if ch != ' ' else '0' for ch in row)
        value = int(binary_str, 2)
        print(f"{binary_str}   {value:3d}   ${value:02X}")

    label = os.path.splitext(os.path.basename(filename))[0]

    defb_line = ", ".join(
        f"${int(''.join('1' if ch != ' ' else '0' for ch in line.rstrip('\n')[:8].ljust(8)), 2):02X}"
        for line in open(filename)
    )

    print(f"\n{label}: ;")
    print(f"  defb {defb_line} ;")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python convert_sprite.py <sprite_file.txt>")
        sys.exit(1)

    convert_sprite(sys.argv[1])

