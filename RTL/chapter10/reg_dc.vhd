-- reg_dc.vhd
library IEEE;
use IEEE.std_logic_1164.all;

-- 入出力の宣言
entity reg_dc is
	port
	(
		CLK_DC		: in	std_logic;
		N_REG_IN	: in	std_logic_vector(2 downto 0);
		REG_0		: in	std_logic_vector(15 downto 0);
		REG_1		: in 	std_logic_vector(15 downto 0);
		REG_2		: in 	std_logic_vector(15 downto 0);
		REG_3		: in 	std_logic_vector(15 downto 0);
		REG_4		: in 	std_logic_vector(15 downto 0);
		REG_5		: in 	std_logic_vector(15 downto 0);
		REG_6		: in 	std_logic_vector(15 downto 0);
		REG_7		: in	std_logic_vector(15 downto 0);
		N_REG_OUT	: out	std_logic_vector(2 downto 0);
		REG_OUT		: out	std_logic_vector(15 downto 0)
	);
end reg_dc;

-- 回路の記述
architecture RTL of reg_dc is

begin
	process(CLK_DC)
	begin
		if(CLK_DC'event and CLK_DC = '1') then
			case N_REG_IN is
				when "000"  => REG_OUT <= REG_0;
				when "001"  => REG_OUT <= REG_1;
				when "010"  => REG_OUT <= REG_2;
				when "011"  => REG_OUT <= REG_3;
				when "100"  => REG_OUT <= REG_4;
				when "101"  => REG_OUT <= REG_5;
				when "110"  => REG_OUT <= REG_6;
				when "111"  => REG_OUT <= REG_7;
				when others => null;
			end case;

			N_REG_OUT <= N_REG_IN;

		end if;
	end process;
end RTL;