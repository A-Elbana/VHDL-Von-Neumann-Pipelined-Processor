library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity regFile is
	port(
		clk : in std_logic;
		regWrite : in std_logic;
		writeReg, readReg1, readReg2 : in  std_logic_vector(2 downto 0);
		writeData  : in  std_logic_vector(31 downto 0);
		readData1, readData2 : out std_logic_vector(31 downto 0)
        );
end entity regFile;

architecture regFileArch of regFile is

	type regFileType is array(0 to 7) of std_logic_vector(31 downto 0);
	signal RegFile : regFileType := (others => (others => '0'));
	
	begin
		process(clk) is
			begin
				if rising_edge(clk) then  
					if regWrite = '1' then
						RegFile(to_integer(unsigned(writeReg))) <= writeData;
					end if;
				end if;
		end process;
		
		readData1 <= RegFile(to_integer(unsigned(readReg1)));
		readData2 <= RegFile(to_integer(unsigned(readReg2)));
end regFileArch;