import secrets
import string
import hashlib
import os

# Function to generate a secure password
def generate_secure_password(length=10):
    if length < 10:
        raise ValueError("Password length should be at least 10 characters.")
    
    characters = string.ascii_letters + string.digits + ".!$@"
    while True:
        password = ''.join(secrets.choice(characters) for _ in range(length))
        if (any(c.islower() for c in password)
                and any(c.isupper() for c in password)
                and any(c.isdigit() for c in password)
                and any(c in ".!$@" for c in password)):
            return password

# Function to generate a URL-safe text string
def generate_url_safe_string(length=32):
    if length < 32:
        raise ValueError("URL length should be at least 32 characters.")
    return secrets.token_urlsafe(length)

# Function to generate a hexadecimal token
def generate_hex_token(length=32):
    if length < 32:
        raise ValueError("Hex token length should be at least 32 characters.")
    return secrets.token_hex(length)

# Function to compare two strings using a method that prevents timing attacks
def are_strings_equal(str1, str2):
    return secrets.compare_digest(str1, str2)

# Function to generate a binary key for encrypting a 100 character message
def generate_encryption_key():
    # Assuming each character is encoded in 8 bits, we need 100 characters * 8 bits each
    return secrets.token_bytes(100 * 8)

def hash_password(password):
    salt = os.urandom(32)
    # Creează un hash folosind algoritmul sha256
    pwdhash = hashlib.pbkdf2_hmac('sha256', password.encode('utf-8'), salt, 100000)
    
    # Stochează saltul și hash-ul împreună
    storage = salt + pwdhash
    
    return storage.hex()