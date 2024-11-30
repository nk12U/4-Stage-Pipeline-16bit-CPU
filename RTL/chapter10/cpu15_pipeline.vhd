-- cpu15_pipeline.vhd
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- 入出力の宣言
entity cpu15_pipeline is
	port(
		CLK			: in  std_logic;
		RESET_N		: in  std_logic;
		IO65_IN		: in  std_logic_vector (15 downto 0);
		IO64_OUT		: out std_logic_vector (15 downto 0)
	);
end cpu15_pipeline;

-- 回路の記述
architecture RTL of cpu15_pipeline is

-- fetch_rom コンポーネントの宣言
	component fetch_rom
		port(
			address		: in  std_logic_vector (7 downto 0);
			clock			: in  std_logic;
			q				: out std_logic_vector (14 downto 0)
		);
	end component;

-- decode コンポーネントの宣言
	component decode
		port(
			CLK_DC		: in  std_logic;
			PROM_OUT	   : in  std_logic_vector (14 downto 0);
			OP_CODE		: out std_logic_vector (3 downto 0);
			OP_DATA		: out std_logic_vector (7 downto 0)	
		);
	end component;

-- n_reg_ex コンポーネントの宣言
	component n_reg_ex
		port(
			CLK_EX		: in	std_logic;
			N_REG			: in  std_logic_vector (2 downto 0);
			N_REG_DLY 	: out	std_logic_vector (2 downto 0)
		);
	end component;

-- reg_dc コンポーネントの宣言
	component reg_dc
		port(
			CLK_DC		: in  std_logic;
			N_REG_IN		: in  std_logic_vector (2 downto 0);
			REG_0			: in  std_logic_vector (15 downto 0);
			REG_1			: in  std_logic_vector (15 downto 0);
			REG_2			: in  std_logic_vector (15 downto 0);
			REG_3			: in  std_logic_vector (15 downto 0);
			REG_4			: in  std_logic_vector (15 downto 0);
			REG_5			: in  std_logic_vector (15 downto 0);
			REG_6			: in  std_logic_vector (15 downto 0);
			REG_7			: in  std_logic_vector (15 downto 0);
			N_REG_OUT	: out std_logic_vector (2 downto 0);	
			REG_OUT		: out std_logic_vector (15 downto 0)
		);
	end component;

-- exec2 コンポーネントの宣言
	component exec2
		port(
			CLK_EX  		: in  std_logic;
			RESET_N 		: in  std_logic;
			OP_CODE    	: in  std_logic_vector (3 downto 0);
			REG_A			: in  std_logic_vector (15 downto 0);
			REG_B			: in  std_logic_vector (15 downto 0);
			OP_DATA		: in  std_logic_vector (7 downto 0);
			RAM_OUT		: in  std_logic_vector (15 downto 0);
			P_COUNT		: out std_logic_vector (7 downto 0);
			REG_IN		: out std_logic_vector (15 downto 0);
			RAM_IN		: out std_logic_vector (15 downto 0);
			REG_WEN		: out std_logic;
			RAM_WEN		: out std_logic
		);
	end component;

-- reg_wb コンポーネントの宣言
	component reg_wb
		port(
   			CLK_WB		: in  std_logic;
   			RESET_N		: in  std_logic;
			N_REG			: in  std_logic_vector (2 downto 0);
			REG_IN		: in  std_logic_vector (15 downto 0);
			REG_WEN		: in  std_logic;
			REG_0 		: out std_logic_vector (15 downto 0);
			REG_1 		: out std_logic_vector (15 downto 0);
			REG_2 		: out std_logic_vector (15 downto 0);
			REG_3 		: out std_logic_vector (15 downto 0);
			REG_4 		: out std_logic_vector (15 downto 0);
			REG_5 		: out std_logic_vector (15 downto 0);
			REG_6 		: out std_logic_vector (15 downto 0);
			REG_7 		: out std_logic_vector (15 downto 0)
		);
	end component;
-- ram_dc_wb2 コンポーネントの宣言
	component ram_dc_wb2
		port(
			CLK			: in std_logic;
			RAM_ADDR		: in std_logic_vector (7 downto 0);
			RAM_IN		: in std_logic_vector (15 downto 0);
			IO65_IN		: in std_logic_vector (15 downto 0);
			RAM_WEN		: in std_logic;
			RAM_OUT		: out std_logic_vector (15 downto 0);
			IO64_OUT		: out std_logic_vector (15 downto 0)
		);
	end component;

-- 内部信号の定義
	signal	P_COUNT			: std_logic_vector (7 downto 0);
	signal	PROM_OUT			: std_logic_vector (14 downto 0);
	signal	OP_CODE			: std_logic_vector (3 downto 0);
	signal	OP_DATA			: std_logic_vector (7 downto 0);
	signal	N_REG_A			: std_logic_vector (2 downto 0);
	signal	N_REG_B			: std_logic_vector (2 downto 0);
	signal	N_REG_A_DLY		: std_logic_vector (2 downto 0);
	signal	REG_IN			: std_logic_vector (15 downto 0);
	signal	REG_A				: std_logic_vector (15 downto 0);
	signal	REG_B				: std_logic_vector (15 downto 0);
	signal	REG_WEN			: std_logic;
	signal	REG_0				: std_logic_vector (15 downto 0);
	signal	REG_1				: std_logic_vector (15 downto 0);
	signal	REG_2				: std_logic_vector (15 downto 0);
	signal	REG_3				: std_logic_vector (15 downto 0);
	signal	REG_4				: std_logic_vector (15 downto 0);
	signal	REG_5				: std_logic_vector (15 downto 0);
	signal	REG_6				: std_logic_vector (15 downto 0);
	signal	REG_7				: std_logic_vector (15 downto 0);
	signal	RAM_IN			: std_logic_vector (15 downto 0);
	signal	RAM_OUT			: std_logic_vector (15 downto 0);
	signal	RAM_WEN			: std_logic;
	signal	IO64_OUT_TMP	: std_logic_vector (15 downto 0);

	begin

-- fetch_rom コンポーネントの実体化と入出力の相互接続
		C1 : fetch_rom
				port map(
					address => P_COUNT,
					clock => CLK,
					q => PROM_OUT
				);

-- decode コンポーネントの実体化と入出力の相互接続
		C2 : decode
				port map(
					CLK_DC => CLK,
					PROM_OUT => PROM_OUT,
					OP_CODE => OP_CODE,
					OP_DATA => OP_DATA
				);

-- reg_dc コンポーネント(1) の実体化と入出力の相互接続
		C3 : reg_dc
				port map(
					CLK_DC => CLK,
					N_REG_IN => PROM_OUT(10 downto 8),
					REG_0 => REG_0,
					REG_1 => REG_1,
					REG_2 => REG_2,
					REG_3 => REG_3, 
					REG_4 => REG_4,
					REG_5 => REG_5,
					REG_6 => REG_6,
					REG_7 => REG_7,
					N_REG_OUT => N_REG_A,
					REG_OUT => REG_A
				);

-- reg_dc コンポーネント(2) の実体化と入出力の相互接続
		C4 : reg_dc
				port map(
					CLK_DC => CLK,
					N_REG_IN => PROM_OUT(7 downto 5),
					REG_0 => REG_0,
					REG_1 => REG_1,
					REG_2 => REG_2,
					REG_3 => REG_3, 
					REG_4 => REG_4,
					REG_5 => REG_5,
					REG_6 => REG_6,
					REG_7 => REG_7,
					N_REG_OUT => N_REG_B,
					REG_OUT => REG_B
				);

-- n_reg_ex コンポーネントの実体化と入出力の相互接続
		C5 : n_reg_ex
				port map(
					CLK_EX => CLK,
					N_REG => N_REG_A,
					N_REG_DLY => N_REG_A_DLY
				);


-- exec2 コンポーネントの実体化と入出力の相互接続
		C6 : exec2
				port map(
					CLK_EX => CLK,
					RESET_N => RESET_N,
					OP_CODE => OP_CODE,
					REG_A => REG_A,
					REG_B => REG_B,
					OP_DATA => OP_DATA,
					RAM_OUT => RAM_OUT,
					P_COUNT => P_COUNT,
					REG_IN => REG_IN,
					RAM_IN => RAM_IN,
					REG_WEN => REG_WEN,
					RAM_WEN => RAM_WEN
				);

-- reg_wb コンポーネントの実体化と入出力の相互接続
		C7 : reg_wb
				port map(
					CLK_WB => CLK,
					RESET_N => RESET_N,
					N_REG => N_REG_A_DLY,
					REG_IN => REG_IN,
					REG_WEN => REG_WEN,
					REG_0 => REG_0,
					REG_1 => REG_1,
					REG_2 => REG_2,
					REG_3 => REG_3,
					REG_4 => REG_4,
					REG_5 => REG_5,
					REG_6 => REG_6,
					REG_7 => REG_7
				);

-- ram_dc_wb2 コンポーネントの実体化と入出力の相互接続
		C8 : ram_dc_wb2
				port map(
					CLK => CLK,
					RAM_ADDR => PROM_OUT(7 downto 0),
					RAM_IN => RAM_IN,
					IO65_IN => IO65_IN and "0000001111111111",		-- 上位6bitを強制的に0にする
					RAM_WEN => RAM_WEN,
					RAM_OUT => RAM_OUT,
					IO64_OUT => IO64_OUT_TMP
				);

				IO64_OUT <= IO64_OUT_TMP xor "1111110000000000";	-- 上位6bitのみ反転

end RTL;