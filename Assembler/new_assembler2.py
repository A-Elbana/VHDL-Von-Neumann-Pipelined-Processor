"""
Assembler for VHDL Von Neumann Pipelined Processor
Converts assembly instructions to 32-bit machine code
Supports .ORG directives for memory mapping
"""

import re
import sys


class Assembler:
    def __init__(self):
        self.registers = {f"R{i}": format(i, "03b") for i in range(8)}
        self.memory = {}  # Stores address: binary_string
        self.current_address = 0
        
        self.opcodes = {
            "NOP": "00000", "HLT": "00001", "SETC": "00010", "NOT": "00010",
            "INC": "00010", "MOV": "00010", "ADD": "00010", "SUB": "00010",
            "AND": "00010", "OUT": "00011", "IN": "00100", "PUSH": "00110",
            "POP": "00111", "IADD": "01001", "LDM": "01010", "JZ": "01011",
            "JN": "01100", "JC": "01101", "JMP": "01110", "CALL": "01111",
            "RET": "10000", "INT": "10001", "RTI": "10010", "LDD": "10011",
            "STD": "10100", "SWAP": "11111"
        }
        
        # Map instructions to their encoding methods
        self.encoders = {
            "NOP": self.encode_nop, "HLT": self.encode_hlt, "SETC": self.encode_setc,
            "NOT": self.encode_not, "INC": self.encode_inc, "MOV": self.encode_mov,
            "SWAP": self.encode_swap, "ADD": self.encode_add,
            "SUB": self.encode_sub, "AND": self.encode_and, "OUT": self.encode_out,
            "IN": self.encode_in, "PUSH": self.encode_push, "POP": self.encode_pop,
            "IADD": self.encode_iadd, "LDM": self.encode_ldm, "JZ": self.encode_jz,
            "JN": self.encode_jn, "JC": self.encode_jc, "JMP": self.encode_jmp,
            "CALL": self.encode_call, "RET": self.encode_ret, "INT": self.encode_int,
            "RTI": self.encode_rti, "LDD": self.encode_ldd, "STD": self.encode_std,
        }

    def parse_register(self, reg_str):
        reg_str = reg_str.strip().upper()
        if reg_str in self.registers:
            return self.registers[reg_str]
        raise ValueError(f"Invalid register: {reg_str}")

    def parse_immediate(self, imm_str):
        imm_str = imm_str.strip()
        try:
            # if imm_str.lower().startswith("0x"):
            #     value = int(imm_str, 16)
            # elif imm_str.lower().startswith("0b"):
            #     value = int(imm_str, 2)
            # else:
            #     value = int(imm_str)
            value = int(imm_str, 16)
        except ValueError:
            raise ValueError(f"Invalid immediate value: {imm_str}")
            
        # if value < 0:
        #     value = (1 << 32) + value

        return format(value & 0xFFFFFFFF, "032b")

    def create_instruction_word(self, opcode, fields):
        word = ["0"] * 32
        for (start, end), value in fields.items():
            if value:
                value_bits = value if isinstance(value, str) else format(value, "0b")
                bit_length = start - end + 1
                if len(value_bits) < bit_length:
                    value_bits = value_bits.zfill(bit_length)
                elif len(value_bits) > bit_length:
                    value_bits = value_bits[-bit_length:]
                for i, bit in enumerate(value_bits):
                    word[31 - (start - i)] = bit
        return "".join(word)

    # --- ENCODER METHODS (Same as original) ---
    def encode_nop(self, parts): return [self.create_instruction_word("00000", {(31, 27): "00000"})]
    def encode_hlt(self, parts): return [self.create_instruction_word("00001", {(31, 27): "00001"})]
    def encode_setc(self, parts): return [self.create_instruction_word("11110", {(31, 27): "11110", (2, 0): "100"})]
    def encode_ret(self, parts): return [self.create_instruction_word("10000", {(31, 27): "10000"})]
    def encode_rti(self, parts): return [self.create_instruction_word("10010", {(31, 27): "10010"})]

    def encode_not(self, parts):
        rdst = self.parse_register(parts[1])
        return [self.create_instruction_word("00010", {(31, 27): "00010", (26, 24): rdst, (23, 21): rdst, (20, 18): rdst, (2, 0): "001"})]

    def encode_inc(self, parts):
        rdst = self.parse_register(parts[1])
        return [self.create_instruction_word("00010", {(31, 27): "00010", (26, 24): rdst, (23, 21): rdst, (20, 18): rdst, (2, 0): "010"})]

    def encode_mov(self, parts):
        rsrc = self.parse_register(parts[1].rstrip(","))
        rdst = self.parse_register(parts[2])
        return [self.create_instruction_word("00010", {(31, 27): "00010", (26, 24): rdst, (23, 21): rsrc, (20, 18): rsrc, (2, 0): "011"})]

    

    def encode_swap(self, parts):
        rsrc = self.parse_register(parts[1].rstrip(","))
        rdst = self.parse_register(parts[2])
        return [self.create_instruction_word("11111", {(31, 27): "11111", (26, 24): rdst, (23, 21): rsrc, (20, 18): rsrc, (2, 0): "011"})]

    def encode_add(self, parts):
        rdst = self.parse_register(parts[1].rstrip(","))
        rsrc1 = self.parse_register(parts[2].rstrip(","))
        rsrc2 = self.parse_register(parts[3])
        return [self.create_instruction_word("00010", {(31, 27): "00010", (26, 24): rdst, (23, 21): rsrc1, (20, 18): rsrc2, (2, 0): "000"})]

    def encode_sub(self, parts):
        rdst = self.parse_register(parts[1].rstrip(","))
        rsrc1 = self.parse_register(parts[2].rstrip(","))
        rsrc2 = self.parse_register(parts[3])
        return [self.create_instruction_word("00010", {(31, 27): "00010", (26, 24): rdst, (23, 21): rsrc1, (20, 18): rsrc2, (2, 0): "101"})]

    def encode_and(self, parts):
        rdst = self.parse_register(parts[1].rstrip(","))
        rsrc1 = self.parse_register(parts[2].rstrip(","))
        rsrc2 = self.parse_register(parts[3])
        return [self.create_instruction_word("00010", {(31, 27): "00010", (26, 24): rdst, (23, 21): rsrc1, (20, 18): rsrc2, (2, 0): "110"})]

    def encode_out(self, parts):
        rsrc1 = self.parse_register(parts[1])
        return [self.create_instruction_word("00011", {(31, 27): "00011", (23, 21): rsrc1})]

    def encode_in(self, parts):
        rdst = self.parse_register(parts[1])
        return [self.create_instruction_word("00100", {(31, 27): "00100", (26, 24): rdst})]

    def encode_push(self, parts):
        rsrc2 = self.parse_register(parts[1])
        return [self.create_instruction_word("00110", {(31, 27): "00110", (20, 18): rsrc2})]

    def encode_pop(self, parts):
        rdst = self.parse_register(parts[1])
        return [self.create_instruction_word("00111", {(31, 27): "00111", (26, 24): rdst})]

    def encode_iadd(self, parts):
        rdst = self.parse_register(parts[1].rstrip(","))
        rsrc = self.parse_register(parts[2].rstrip(","))
        imm = self.parse_immediate(parts[3])
        word1 = self.create_instruction_word("01001", {(31, 27): "01001", (26, 24): rdst, (23, 21): rsrc})
        return [word1, imm]

    def encode_ldm(self, parts):
        rdst = self.parse_register(parts[1].rstrip(","))
        imm = self.parse_immediate(parts[2])
        word1 = self.create_instruction_word("01010", {(31, 27): "01010", (26, 24): rdst})
        return [word1, imm]

    def encode_jz(self, parts):
        imm = self.parse_immediate(parts[1])
        word1 = self.create_instruction_word("01011", {(31, 27): "01011"})
        return [word1, imm]

    def encode_jn(self, parts):
        imm = self.parse_immediate(parts[1])
        word1 = self.create_instruction_word("01100", {(31, 27): "01100"})
        return [word1, imm]

    def encode_jc(self, parts):
        imm = self.parse_immediate(parts[1])
        word1 = self.create_instruction_word("01101", {(31, 27): "01101"})
        return [word1, imm]

    def encode_jmp(self, parts):
        imm = self.parse_immediate(parts[1])
        word1 = self.create_instruction_word("01110", {(31, 27): "01110"})
        return [word1, imm]

    def encode_call(self, parts):
        imm = self.parse_immediate(parts[1])
        word1 = self.create_instruction_word("01111", {(31, 27): "01111"})
        return [word1, imm]

    def encode_int(self, parts):
        index = parts[1].strip()
        if index not in ["0", "1"]: raise ValueError("INT index must be 0 or 1")
        return [self.create_instruction_word("10001", {(31, 27): "10001", (0, 0): index})]

    def encode_ldd(self, parts):
        offset_rsrc = parts[2]
        match = re.match(r"(-?\d+|0x[0-9A-Fa-f]+|0b[01]+)\(R(\d+)\)", offset_rsrc)
        if not match: raise ValueError(f"Invalid LDD format: {offset_rsrc}")
        offset = self.parse_immediate(match.group(1))
        rsrc = self.parse_register(f"R{match.group(2)}")
        rdst = self.parse_register(parts[1].rstrip(","))
        word1 = self.create_instruction_word("10011", {(31, 27): "10011", (26, 24): rdst, (23, 21): rsrc})
        return [word1, offset]

    def encode_std(self, parts):
        offset_rsrc = parts[2]
        match = re.match(r"(-?\d+|0x[0-9A-Fa-f]+|0b[01]+)\(R(\d+)\)", offset_rsrc)
        if not match: raise ValueError(f"Invalid STD format: {offset_rsrc}")
        offset = self.parse_immediate(match.group(1))
        rsrc1 = self.parse_register(f"R{match.group(2)}")
        rsrc2 = self.parse_register(parts[1].rstrip(","))
        word1 = self.create_instruction_word("10100", {(31, 27): "10100", (23, 21): rsrc1, (20, 18): rsrc2})
        return [word1, offset]

    def parse_line(self, line):
        # Remove both types of comments (# and //)
        line = line.split("#")[0].split("//")[0].strip()
        
        if not line:
            return None

        # Handle .ORG directive
        if line.upper().startswith(".ORG"):
            parts = line.split()
            if len(parts) < 2:
                raise ValueError(".ORG requires an address")
            # Parse address and update current address pointer
            # We use parse_immediate to handle hex/binary/int, then convert back to int
            addr_bin = self.parse_immediate(parts[1])
            self.current_address = int(addr_bin, 2)
            return None

        # Split instruction parts
        parts = re.split(r"[\s,]+", line.upper())
        parts = [p for p in parts if p]

        if not parts:
            return None

        instruction = parts[0]

        if instruction in self.encoders:
            return self.encoders[instruction](parts)
        else:
            # If not a known instruction, try parsing as a raw data value
            # This handles lines like '200', '400' after .ORG
            try:
                raw_value = self.parse_immediate(instruction)
                return [raw_value]
            except ValueError:
                raise ValueError(f"Unknown instruction or invalid value: {instruction}")

    def assemble(self, input_file, output_file=None):
        with open(input_file, "r") as f:
            for line_num, line in enumerate(f, 1):
                try:
                    words = self.parse_line(line)
                    if words:
                        # Store words in memory map at current address
                        for word in words:
                            self.memory[self.current_address] = word
                            self.current_address += 1
                except Exception as e:
                    raise ValueError(f"Error on line {line_num}: {e}")

        if output_file:
            with open(output_file, "w") as f:
                # Write memory map sorted by address
                # Format: Address:Value (in hex)
                for addr in sorted(self.memory.keys()):
                    val_int = int(self.memory[addr], 2)
                    f.write(f"{addr}:{val_int:08x}".upper() + "\n")

        return self.memory

def main():
    if len(sys.argv) < 2:
        print("Usage: python assembler.py <input_file> [output_file]")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None

    assembler = Assembler()

    try:
        memory = assembler.assemble(input_file, output_file)
        if output_file:
            print(f"Assembly successful. Output written to {output_file}")
            print(f"Total words: {len(memory)}")

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()