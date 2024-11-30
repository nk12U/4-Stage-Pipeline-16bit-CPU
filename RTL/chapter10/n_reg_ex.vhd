-- n_reg_ex.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- 入出力の宣言
entity n_reg_ex is
	port(
		CLK_EX		: in	std_logic;
		N_REG		: in	std_logic_vector(2 downto 0);
		N_REG_DLY	: out	std_logic_vector(2 downto 0)
	);
end n_reg_ex;

-- 回路の記述
architecture RTL of n_reg_ex is
-- 信号の N_REG を1クロック遅延させる
begin
	process(CLK_EX)
	begin
		if(CLK_EX'event and CLK_EX = '1') then
			N_REG_DLY <= N_REG;
		end if;
	end process;
end RTL;