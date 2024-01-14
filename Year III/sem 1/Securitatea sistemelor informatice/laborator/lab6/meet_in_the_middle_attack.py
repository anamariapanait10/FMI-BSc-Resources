from Crypto.Cipher import DES
from itertools import product


key1 = b"\x00" * 7
key2 = b"\x00" * 7

plaintext = b"Provocare MitM!!"
ciphertext = b"G\xfd\xdfpd\xa5\xc9'C\xe2\xf0\x84)\xef\xeb\xf9"
key_counter = 0 

middle_texts = {}
candidate_keys = []
ciphers = []

for i in range(16):
    candidate_key1 = (i << 4).to_bytes(1, byteorder="big") + key1
    candidate_keys.append(candidate_key1)
    cipher = DES.new(candidate_key1, DES.MODE_ECB) 
    ciphers.append(cipher)
    middle_encryption = cipher.encrypt(plaintext)
    middle_texts[middle_encryption] = candidate_key1

for key, cipher in zip(candidate_keys, ciphers):
    middle_decryption = cipher.decrypt(ciphertext)
    if middle_decryption in middle_texts.keys():
        key1 = middle_texts[middle_decryption]
        key2 = key
        break

print(f"key1 = {key1}\nkey2 = {key2}")

