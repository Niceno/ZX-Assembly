import re
import sys
import os
from PIL import Image

def parse_font_data(filename):
    """Parse the font data file and extract all defb lines, ignoring comments"""
    defb_lines = []
    with open(filename, 'r') as f:
        for line in f:
            # Remove everything after a semicolon (comments)
            line = line.split(';')[0].strip()
            
            if line.startswith('defb'):
                # Extract the hexadecimal values
                hex_values = re.findall(r'\$([0-9A-Fa-f]{2})', line)
                if hex_values:
                    defb_lines.append(hex_values)
    return defb_lines

def create_font_bitmap(defb_lines, output_filename):
    """Create a bitmap from the font data using PIL"""
    # Each character is 8x8 pixels, arranged in 12 columns and 8 rows
    width = 12 * 8  # 96 pixels wide
    height = 8 * 8  # 64 pixels tall
    
    # Create a new image with white background
    image = Image.new('1', (width, height), 1)  # '1' for 1-bit pixels, 1=white
    pixels = image.load()
    
    # Process each character
    for char_index, hex_values in enumerate(defb_lines):
        if char_index >= 96:  # Only process first 96 characters
            break
            
        # Calculate position in the grid
        col = char_index % 12
        row = char_index // 12
        
        # Process each byte (row of the character)
        for byte_index, hex_byte in enumerate(hex_values):
            if byte_index >= 8:  # Only process 8 bytes per character
                break
                
            byte_value = int(hex_byte, 16)
            
            # Process each bit in the byte
            for bit in range(8):
                pixel_value = 0 if (byte_value >> (7 - bit)) & 1 else 1
                x = col * 8 + bit
                y = row * 8 + byte_index
                if x < width and y < height:
                    pixels[x, y] = pixel_value
    
    # Save as PNG
    image.save(output_filename)
    print(f"Bitmap created: {output_filename}")

def main():
    """Main function with command line argument handling"""
    if len(sys.argv) < 2:
        print("Usage: python script.py <input_file> [output_file]")
        print("If output_file is not specified, it will be input_file with .png extension")
        sys.exit(1)
    
    input_filename = sys.argv[1]
    
    # Check if input file exists
    if not os.path.isfile(input_filename):
        print(f"Error: File '{input_filename}' not found!")
        sys.exit(1)
    
    # Generate output filename if not provided
    if len(sys.argv) > 2:
        output_filename = sys.argv[2]
    else:
        # Replace extension with .png
        base_name = os.path.splitext(input_filename)[0]
        output_filename = base_name + ".png"
    
    # Parse and create bitmap
    defb_lines = parse_font_data(input_filename)
    
    if len(defb_lines) < 96:
        print(f"Warning: Only found {len(defb_lines)} character definitions (expected 96)")
    
    create_font_bitmap(defb_lines, output_filename)

if __name__ == "__main__":
    main()
