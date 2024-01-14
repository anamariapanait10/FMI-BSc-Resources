from PIL import Image
import hashlib
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes

def pad_image(data):
    block_size = AES.block_size
    padding_required = block_size - len(data) % block_size
    return data + bytes([padding_required] * padding_required)

def process_image(file_index, aes_key):
    file_name = f"my_encrypted_files/decrypted_images_with_headers/File{file_index}.ppm"
    with open(file_name, 'rb') as file:
        file_content = file.read()

        # Split the header and the image data
        file_content = file_content.split(b'\n', 3)
        
        header = b' '.join(file_content[:3])
        image_data = file_content[-1]

        # Hash the header
        header_hash = hashlib.sha256(header).hexdigest()

        # AES encryption
        cipher = AES.new(aes_key, AES.MODE_ECB)
        encrypted_image_data = cipher.encrypt(pad_image(image_data))

        # Save the encrypted image data to a new file
        encrypted_file_name = f"my_encrypted_files/encrypted_images/File{file_index}_encr.ppm"
        with open(encrypted_file_name, 'wb') as encrypted_file:
            encrypted_file.write(encrypted_image_data)

        return header_hash

def add_headers_to_encrypted_images():
    headers = [
        "P6\n488 515\n255\n",
        "P6\n561 546\n255\n",
        "P6\n544 470\n255\n",
        "P6\n489 548\n255\n",
        "P6\n692 677\n255\n"
    ]
    for file_index in range(5):
        with open(f"my_encrypted_files/encrypted_images/File{file_index+1}_encr.ppm", "rb") as f:
            encrypted_image_data = f.read()
        with open(f"my_encrypted_files/encrypted_images_with_headers/File{file_index+1}.jpg", "w") as f:
            f.write(headers[file_index])
        with open(f"my_encrypted_files/encrypted_images_with_headers/File{file_index+1}.jpg", "ab") as f:
            f.write(encrypted_image_data)
         
    
def main():
    key = get_random_bytes(16) 
    with open("my_encrypted_files/headers.txt", "w") as f:
        for file in range(5):
            header_hash = process_image(file+1, key)
            f.write(f"{header_hash}\n")
    # add_headers_to_encrypted_images()
    
if __name__ == "__main__":
    main()