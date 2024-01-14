
class LFSR:
    def __init__(self, coefficients, state):
        self.coefficients = coefficients  # List of coefficients (c1, c2, ..., cL)
        self.state = state  # Initial state of the LFSR (s0, s1, ..., sL-1)
        self.period = None  # Period of the sequence

    def step(self):
        # Perform one step of the LFSR and return the output bit
        # XOR the tap positions
        output = sum([c * s for c, s in zip(self.coefficients, self.state)]) % 2
        # Shift the state
        self.state = [output] + self.state[:-1]
        return output

    def generate_sequence(self):
        # Generate and return the sequence for one full period
        initial_state = self.state.copy()
        sequence = []
        while True:
            output = self.step()
            sequence.append(output)
            if self.state == initial_state:
                break
        self.period = len(sequence)
        return sequence


coefficients = [0, 0, 1, 1]  
initial_state = [1, 1, 0, 1] 

lfsr = LFSR(coefficients, initial_state)

# Generate the sequence and print it along with the period
sequence = lfsr.generate_sequence()
print("Generated sequence:", sequence)
print("Period of the sequence:", lfsr.period)