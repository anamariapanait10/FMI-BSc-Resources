import os
from hashlib import sha256

mixed_hashes = [
    "602a4a8fff652291fdc0e049e3900dae608af64e5e4d2c5d4332603c9938171d",
    "f40e838809ddaa770428a4b2adc1fff0c38a84abe496940d534af1232c2467d5",
    "aa105295e25e11c8c42e4393c008428d965d42c6cb1b906e30be99f94f473bb5",
    "70f87d0b880efcdbe159011126db397a1231966991ae9252b278623aeb9c0450",
    "77a39d581d3d469084686c90ba08a5fb6ce621a552155730019f6c02cb4c0cb6",
    "456ae6a020aa2d54c0c00a71d63033f6c7ca6cbc1424507668cf54b80325dc01",
    "bd0fd461d87fba0d5e61bed6a399acdfc92b12769f9b3178f9752e30f1aeb81d",
    "372df01b994c2b14969592fd2e78d27e7ee472a07c7ac3dfdf41d345b2f8e305"
]

def compute_header_hash(pixels_horizontal, pixels_vertical):
    header_to_hash = f"P6 {pixels_horizontal} {pixels_vertical} 255" 
    return sha256(header_to_hash.encode()).hexdigest()

def get_file_size(file_path):
    return os.path.getsize(file_path)

def dimensions_product(item):
    return item[0] * item[1]

def main():
    header_dimensions = []
    for pixels_horizontal in range(1, 1000):
        for pixels_vertical in range(1, 1000):
            computed_hash = compute_header_hash(pixels_horizontal, pixels_vertical)
            for hash in mixed_hashes:
                if hash == computed_hash:
                    header_dimensions.append((pixels_horizontal, pixels_vertical))
    
    encrypted_files_sizes = [(f"encrypted_files/File{file+1}_encr.ppm", os.stat(f"encrypted_files/File{file+1}_encr.ppm").st_size) for file in range(8)]
    encrypted_files_sizes = sorted(encrypted_files_sizes, key=lambda x: x[1])
    header_dimensions = sorted(header_dimensions, key=dimensions_product)
    print(header_dimensions)
    print(encrypted_files_sizes)
                
    for index, (file, _) in enumerate(encrypted_files_sizes):
        with open(file, "rb") as f:
            encrypted_file = f.read()
        pixels_horizontal, pixels_vertical = header_dimensions[index]
        with open(f"{file.split('.')[0]}.jpg" , "w") as f:
            f.write(f"P6 {pixels_horizontal} {pixels_vertical} 255\n")
            
        with open(f"{file.split('.')[0]}.jpg" , "ab") as f:
            f.write(encrypted_file)

    
if __name__ == "__main__":
    main()