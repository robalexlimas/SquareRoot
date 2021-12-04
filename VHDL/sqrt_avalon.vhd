--**********************************************************************************************************************
--Sqrt int implementation
--Authors:
--  Robert Alexander Limas Sierra
--  Wilson Javier Perez Holguin
--Year: 2021
--Research Group GIRA
--Universidad Pedagogica y Tecnologica de Colombia
--Description:
--    Implementation interface avalon
--        
--**********************************************************************************************************************
library ieee;
use ieee.std_logic_1164.all

entity sqrt_avalon is
port(
	clk, rst: in std_logic;
	r, w, chip_sel: in std_logic;
	write_data: in std_logic_vector(31 downto 0);
	read_data: out std_logic_vector(31 downto 0);
	Q_export: out std_logic_vector(31 downto 0)
);
end;

architecture rtl of sqrt_avalon is

signal to_sqrt, from_sqrt: std_logic_vector(31 downto 0);
signal radicand_16, root_int_16, root_decimal_16: std_logic_vector(15 downto 0);

begin

process(clk, chip_sel, w, rst)
begin
if rst='0' then
	to_sqrt <= (others=>'0');
elsif rising_edge(clk) then
	if (chip_sel = '1' and w = '1') then
		to_sqrt <= write_data;
	end if;
end if;
end process;

radicand_16 <= to_sqrt(15 downto 0);

sqrt0: entity work.sqrt
generic map(
	n => 16
)
port map(
	radicand => radicand_16,
	root_int => root_int_16,
	root_decimal => root_decimal_16
);

from_sqrt <= root_int_16 & root_decimal_16;
read_data <= from_sqrt;
Q_export <= from_sqrt;

end rtl;