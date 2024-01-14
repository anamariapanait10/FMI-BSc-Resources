from Crypto.Cipher import AES
from Crypto.Util.Padding import pad

key = b'O cheie oarecare'

data_with_padding = pad(b'test', AES.block_size)

cipher = AES.new(key, AES.MODE_CBC)

print(cipher.encrypt(data_with_padding))
