"""
Assembler for VHDL Von Neumann Pipelined Processor
Converts assembly instructions to 32-bit machine code
"""

import re
import sys


class Assembler:
    def __init__(self):
        self.registers = {f"R{i}": format(i, "03b") for i in range(8)}
        self.opcodes = {
            "NOP": "00000",
            "HLT": "00001",
            "SETC": "00010",
            "NOT": "00010",
            "INC": "00010",
            "MOV": "00010",
            "ADD": "00010",
            "SUB": "00010",
            "AND": "00010",
            "OUT": "00011",
            "IN": "00100",
            "PUSH": "00110",
            "POP": "00111",
            "IADD": "01001",
            "LDM": "01010",
            "JZ": "01011",
            "JN": "01100",
            "JC": "01101",
            "JMP": "01110",
            "CALL": "01111",
            "RET": "10000",
            "INT": "10001",
            "RTI": "10010",
            "LDD": "10011",
            "STD": "10100",
            "SWAP": "11111",
        }
        self.func_codes = {
            "SETC": "100",
            "NOT": "001",
            "INC": "010",
            "MOV": "011",
            "ADD": "000",
            "SUB": "101",
            "AND": "110",
        }

    def parse_register(self, reg_str):
        reg_str = reg_str.strip().upper()
        if reg_str in self.registers:
            return self.registers[reg_str]
        raise ValueError(f"Invalid register: {reg_str}")

    def parse_immediate(self, imm_str):
        imm_str = imm_str.strip()
        # handling the 3 cases of immediate values :D
        if (
            imm_str.startswith("0x")
            or imm_str.startswith("0X")
            or imm_str.startswith("-0x")
            or imm_str.startswith("-0X")
        ):
            value = int(imm_str, 16)
        elif (
            imm_str.startswith("0b")
            or imm_str.startswith("0B")
            or imm_str.startswith("-0b")
            or imm_str.startswith("-0B")
        ):
            value = int(imm_str, 2)
        else:
            value = int(imm_str)

        # handling the negative values
        if value < 0:
            value = (1 << 32) + value

        return format(value & 0xFFFFFFFF, "032b")

    def create_instruction_word(self, opcode, fields):
        """
        Create a 32-bit instruction word
        fields is a dictionary with bit ranges as keys and values to place
        Example: {(31,27): '00010', (26,24): '001', (2,0): '011'}
        """
        word = ["0"] * 32

        for (start, end), value in fields.items():
            if value:
                value_bits = value if isinstance(value, str) else format(value, "0b")
                bit_length = start - end + 1
                if len(value_bits) < bit_length:
                    value_bits = value_bits.zfill(bit_length)
                elif len(value_bits) > bit_length:
                    value_bits = value_bits[-bit_length:]  # Take least significant bits

                # Place bits (bit 31 is leftmost)
                for i, bit in enumerate(value_bits):
                    word[31 - (start - i)] = bit

        return "".join(word)

    def encode_nop(self, parts):
        # NOP
        return [self.create_instruction_word("00000", {(31, 27): "00000"})]

    def encode_hlt(self, parts):
        # HLT
        return [self.create_instruction_word("00001", {(31, 27): "00001"})]

    def encode_setc(self, parts):
        # SETC
        return [
            self.create_instruction_word("11110", {(31, 27): "11110", (2, 0): "100"})
        ]

    def encode_not(self, parts):
        # NOT
        if len(parts) != 2:
            raise ValueError("NOT instruction requires 1 operand: NOT Rdst")
        rdst = self.parse_register(parts[1])
        return [
            self.create_instruction_word(
                "00010",
                {(31, 27): "00010", (26, 24): rdst, (23, 21): rdst, (20, 18): rdst, (2, 0): "001"},
            )
        ]

    def encode_inc(self, parts):
        # INC
        if len(parts) != 2:
            raise ValueError("INC instruction requires 1 operand: INC Rdst")
        rdst = self.parse_register(parts[1])
        return [
            self.create_instruction_word(
                "00010",
                {(31, 27): "00010", (26, 24): rdst, (23, 21): rdst, (20, 18): rdst, (2, 0): "010"},
            )
        ]

    def encode_mov(self, parts):
        # MOV
        if len(parts) != 3:
            raise ValueError("MOV instruction requires 2 operands: MOV Rdst, Rsrc")
        rdst = self.parse_register(parts[1].rstrip(","))
        rsrc = self.parse_register(parts[2])
        return [
            self.create_instruction_word(
                "00010",
                {(31, 27): "00010", (26, 24): rdst, (23, 21): rsrc, (20, 18): rsrc, (2, 0): "011"},
            )
        ]

    def encode_movs(self, parts):
        # MOVS
        if len(parts) != 3:
            raise ValueError("MOVS instruction requires 2 operands: MOVS Rdst, Rsrc")
        rdst = self.parse_register(parts[1].rstrip(","))
        rsrc = self.parse_register(parts[2])
        return [
            self.create_instruction_word(
                "01000",
                {(31, 27): "01000", (26, 24): rdst, (23, 21): rsrc, (2, 0): "011"},
            )
        ]

    def encode_swap(self, parts):
        # SWAP
        if len(parts) != 3:
            raise ValueError("SWAP instruction requires 2 operands: SWAP Rdst, Rsrc")
        rdst = self.parse_register(parts[1].rstrip(","))
        rsrc = self.parse_register(parts[2])
        return [
            self.create_instruction_word(
                "11111",
                {(31, 27): "11111", (26, 24): rdst, (23, 21): rsrc, (20, 18): rsrc, (2, 0): "011"},
            )
        ]

    def encode_add(self, parts):
        # ADD
        if len(parts) != 4:
            raise ValueError(
                "ADD instruction requires 3 operands: ADD Rdst, Rsrc1, Rsrc2"
            )
        rdst = self.parse_register(parts[1].rstrip(","))
        rsrc1 = self.parse_register(parts[2].rstrip(","))
        rsrc2 = self.parse_register(parts[3])
        return [
            self.create_instruction_word(
                "00010",
                {
                    (31, 27): "00010",
                    (26, 24): rdst,
                    (23, 21): rsrc1,
                    (20, 18): rsrc2,
                    (2, 0): "000",
                },
            )
        ]

    def encode_sub(self, parts):
        # SUB
        if len(parts) != 4:
            raise ValueError(
                "SUB instruction requires 3 operands: SUB Rdst, Rsrc1, Rsrc2"
            )
        rdst = self.parse_register(parts[1].rstrip(","))
        rsrc1 = self.parse_register(parts[2].rstrip(","))
        rsrc2 = self.parse_register(parts[3])
        return [
            self.create_instruction_word(
                "00010",
                {
                    (31, 27): "00010",
                    (26, 24): rdst,
                    (23, 21): rsrc1,
                    (20, 18): rsrc2,
                    (2, 0): "101",
                },
            )
        ]

    def encode_and(self, parts):
        # AND
        if len(parts) != 4:
            raise ValueError(
                "AND instruction requires 3 operands: AND Rdst, Rsrc1, Rsrc2"
            )
        rdst = self.parse_register(parts[1].rstrip(","))
        rsrc1 = self.parse_register(parts[2].rstrip(","))
        rsrc2 = self.parse_register(parts[3])
        return [
            self.create_instruction_word(
                "00010",
                {
                    (31, 27): "00010",
                    (26, 24): rdst,
                    (23, 21): rsrc1,
                    (20, 18): rsrc2,
                    (2, 0): "110",
                },
            )
        ]

    def encode_out(self, parts):
        # OUT
        if len(parts) != 2:
            raise ValueError("OUT instruction requires 1 operand: OUT Rsrc1")
        rsrc1 = self.parse_register(parts[1])
        return [
            self.create_instruction_word("00011", {(31, 27): "00011", (23, 21): rsrc1})
        ]

    def encode_in(self, parts):
        # IN
        if len(parts) != 2:
            raise ValueError("IN instruction requires 1 operand: IN Rdst")
        rdst = self.parse_register(parts[1])
        return [
            self.create_instruction_word("00100", {(31, 27): "00100", (26, 24): rdst})
        ]

    def encode_push(self, parts):
        # PUSH
        if len(parts) != 2:
            raise ValueError("PUSH instruction requires 1 operand: PUSH Rsrc2")
        rsrc2 = self.parse_register(parts[1])
        return [
            self.create_instruction_word("00110", {(31, 27): "00110", (20, 18): rsrc2})
        ]

    def encode_pop(self, parts):
        # POP
        if len(parts) != 2:
            raise ValueError("POP instruction requires 1 operand: POP Rdst")
        rdst = self.parse_register(parts[1])
        return [
            self.create_instruction_word("00111", {(31, 27): "00111", (26, 24): rdst})
        ]

    def encode_iadd(self, parts):
        # IADD
        if len(parts) != 4:
            raise ValueError(
                "IADD instruction requires 3 operands: IADD Rdst, Rsrc, Imm"
            )
        rdst = self.parse_register(parts[1].rstrip(","))
        rsrc = self.parse_register(parts[2].rstrip(","))
        imm = self.parse_immediate(parts[3])

        word1 = self.create_instruction_word(
            "01001", {(31, 27): "01001", (26, 24): rdst, (23, 21): rsrc}
        )
        return [word1, imm]

    def encode_ldm(self, parts):
        # LDM
        if len(parts) != 3:
            raise ValueError("LDM instruction requires 2 operands: LDM Rdst, Imm")
        rdst = self.parse_register(parts[1].rstrip(","))
        imm = self.parse_immediate(parts[2])

        word1 = self.create_instruction_word(
            "01010", {(31, 27): "01010", (26, 24): rdst}
        )
        return [word1, imm]

    def encode_jz(self, parts):
        # JZ
        if len(parts) != 2:
            raise ValueError("JZ instruction requires 1 operand: JZ Imm")
        imm = self.parse_immediate(parts[1])

        word1 = self.create_instruction_word("01011", {(31, 27): "01011"})
        return [word1, imm]

    def encode_jn(self, parts):
        # JN
        if len(parts) != 2:
            raise ValueError("JN instruction requires 1 operand: JN Imm")
        imm = self.parse_immediate(parts[1])

        word1 = self.create_instruction_word("01100", {(31, 27): "01100"})
        return [word1, imm]

    def encode_jc(self, parts):
        # JC
        if len(parts) != 2:
            raise ValueError("JC instruction requires 1 operand: JC Imm")
        imm = self.parse_immediate(parts[1])

        word1 = self.create_instruction_word("01101", {(31, 27): "01101"})
        return [word1, imm]

    def encode_jmp(self, parts):
        # JMP
        if len(parts) != 2:
            raise ValueError("JMP instruction requires 1 operand: JMP Imm")
        imm = self.parse_immediate(parts[1])

        word1 = self.create_instruction_word("01110", {(31, 27): "01110"})
        return [word1, imm]

    def encode_call(self, parts):
        # CALL
        if len(parts) != 2:
            raise ValueError("CALL instruction requires 1 operand: CALL Imm")
        imm = self.parse_immediate(parts[1])

        word1 = self.create_instruction_word("01111", {(31, 27): "01111"})
        return [word1, imm]

    def encode_ret(self, parts):
        # RET
        return [self.create_instruction_word("10000", {(31, 27): "10000"})]

    def encode_int(self, parts):
        # INT
        if len(parts) != 2:
            raise ValueError("INT instruction requires 1 operand: INT index")
        index = parts[1].strip()
        if index not in ["0", "1"]:
            raise ValueError("INT index must be 0 or 1")
        index_bit = index
        return [
            self.create_instruction_word(
                "10001", {(31, 27): "10001", (0, 0): index_bit}
            )
        ]

    def encode_rti(self, parts):
        # RTI
        return [self.create_instruction_word("10010", {(31, 27): "10010"})]

    def encode_ldd(self, parts):
        # LDD
        if len(parts) != 3:
            raise ValueError(
                "LDD instruction requires 2 operands: LDD Rdst, offset(Rsrc)"
            )

        # Parse offset(Rsrc) format
        offset_rsrc = parts[2]
        match = re.match(r"(-?\d+|0x[0-9A-Fa-f]+|0b[01]+)\(R(\d+)\)", offset_rsrc)
        if not match:
            raise ValueError(
                f"Invalid LDD format: {offset_rsrc}. Expected: offset(Rsrc)"
            )

        offset = self.parse_immediate(match.group(1))
        rsrc = self.parse_register(f"R{match.group(2)}")
        rdst = self.parse_register(parts[1].rstrip(","))

        word1 = self.create_instruction_word(
            "10011", {(31, 27): "10011", (26, 24): rdst, (23, 21): rsrc}
        )
        return [word1, offset]

    def encode_std(self, parts):
        # STD
        if len(parts) != 3:
            raise ValueError(
                "STD instruction requires 2 operands: STD Rsrc2, offset(Rsrc1)"
            )

        # Parse offset(Rsrc) format
        offset_rsrc = parts[2]
        match = re.match(r"(-?\d+|0x[0-9A-Fa-f]+|0b[01]+)\(R(\d+)\)", offset_rsrc)
        if not match:
            raise ValueError(
                f"Invalid STD format: {offset_rsrc}. Expected: offset(Rsrc1)"
            )

        offset = self.parse_immediate(match.group(1))
        rsrc1 = self.parse_register(f"R{match.group(2)}")
        rsrc2 = self.parse_register(parts[1].rstrip(","))

        word1 = self.create_instruction_word(
            "10100", {(31, 27): "10100", (23, 21): rsrc1, (20, 18): rsrc2}
        )
        return [word1, offset]

    def parse_line(self, line):
        # Remove comments in asm instructions
        line = line.split("#")[0].strip()

        # Skip empty lines
        if not line:
            return None

        # Split by whitespace and comma
        parts = re.split(r"[\s,]+", line.upper())

        # Remove empty parts
        parts = [p for p in parts if p]

        if not parts:
            return None

        instruction = parts[0]

        # Instruction mapping
        encoders = {
            "NOP": self.encode_nop,
            "HLT": self.encode_hlt,
            "SETC": self.encode_setc,
            "NOT": self.encode_not,
            "INC": self.encode_inc,
            "MOV": self.encode_mov,
            "MOVS": self.encode_movs,
            "SWAP": self.encode_swap,
            "ADD": self.encode_add,
            "SUB": self.encode_sub,
            "AND": self.encode_and,
            "OUT": self.encode_out,
            "IN": self.encode_in,
            "PUSH": self.encode_push,
            "POP": self.encode_pop,
            "IADD": self.encode_iadd,
            "LDM": self.encode_ldm,
            "JZ": self.encode_jz,
            "JN": self.encode_jn,
            "JC": self.encode_jc,
            "JMP": self.encode_jmp,
            "CALL": self.encode_call,
            "RET": self.encode_ret,
            "INT": self.encode_int,
            "RTI": self.encode_rti,
            "LDD": self.encode_ldd,
            "STD": self.encode_std,
        }

        if instruction not in encoders:
            raise ValueError(f"Unknown instruction: {instruction}")

        return encoders[instruction](parts)

    def assemble(self, input_file, output_file=None):
        machine_code = []

        with open(input_file, "r") as f:
            for line_num, line in enumerate(f, 1):
                try:
                    words = self.parse_line(line)
                    if words:
                        machine_code.extend(words)
                except Exception as e:
                    raise ValueError(f"Error on line {line_num}: {e}")

        if output_file:
            lineCount = 0
            CodeSegment = 10
            Interrupt1 = 2**5
            Interrupt2 = 2**7
            Interrupt3 = 2**10
            with open("../" + output_file, "w") as f:
                f.write(f"0:{CodeSegment:08x}".upper() + "\n")
                f.write(f"1:{Interrupt1:08x}".upper() + "\n")
                f.write(f"2:{Interrupt2:08x}".upper() + "\n")
                f.write(f"3:{Interrupt3:08x}".upper() + "\n")
                for word in machine_code:
                    f.write(f"{lineCount+CodeSegment}:{int(word,2):08x}".upper() + "\n")
                    lineCount = lineCount + 1

        return machine_code


def main():
    if len(sys.argv) < 2:
        print("Usage: python assembler.py <input_file> [output_file]")
        print("Example: python assembler.py program.asm program.bin")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None

    assembler = Assembler()

    try:
        machine_code = assembler.assemble(input_file, output_file)
        if output_file:
            print(f"Assembled {len(machine_code)} words, written to {output_file}")

    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
