-- multiple1902 <multple1902@gmail.com>
-- Released under GNU GPL v3, or later.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fourstep is
  port (
        clk     : in std_logic;
        step    : out std_logic_vector(3 downto 0) -- no semicolon here!
  );
end fourstep;

architecture behv of fourstep is

    signal state, nstate: std_logic_vector(3 downto 0) := "0001";

begin
    process(clk) 
    begin
        -- if clk='1' then
            step(3 downto 0) <= "1111";

            nstate(2 downto 0)<=state(3 downto 1);
            nstate(3) <= state(0);
            state(3 downto 0)<=nstate(3 downto 0);

            step(3 downto 0) <= nstate(3 downto 0);
        -- end if;
    end process;

end behv;
