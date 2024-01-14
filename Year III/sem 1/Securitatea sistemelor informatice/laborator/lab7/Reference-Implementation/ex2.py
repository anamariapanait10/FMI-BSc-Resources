import subprocess

# gcc -D_PHOTON80_ -D_TABLE_ photondriver.c -o photon80 sha2.c timer.c photon.c -O3
def create_input_file(n = 10, initial_word="ana"):
    initial_word = "ana"
    with open("input.txt", "w") as f:
        for i in range(n):
            f.write(f"{initial_word}{i}\n")

def move_hashes():
    subprocess.run(["./photon80", "-f", "input.txt", "output.txt"])

def find_collisions():
    with open("output_test.txt", "r") as f:
        test_hashes = {line.split("::::: ")[1].strip() for line in f.readlines()[1:]}

    has_collisions = False
    with open("output.txt", "r") as f:
        for line in f.readlines()[1:]:
            hash_value = line.split("::::: ")[1].strip()
            if hash_value in test_hashes:
                print(f"\nCollision found for input '{line.strip()}': {hash_value}")
                has_collisions = True

    if has_collisions:
        print("\nCollisions found")
    else:
        print("\nNo collisions found")
    
if __name__ == '__main__':
    n = int(input("n = "))
    create_input_file(n)
    move_hashes()
    find_collisions()