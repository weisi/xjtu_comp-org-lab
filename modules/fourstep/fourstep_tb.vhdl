-- multiple1902 <multple1902@gmail.com>
-- Released under GNU GPL v3, or later.

library ieee;
use ieee.std_logic_1164.all;

entity fourstep_tb is
end fourstep_tb;

architecture behav of fourstep_tb is
   component fourstep
      port (
            clk     : in std_logic;
            step    : out std_logic_vector(3 downto 0) -- no semicolon here!
      );
   end component;

   for fourstep_0: fourstep use entity work.fourstep;
   signal clk     : std_logic;

   signal step : std_logic_vector(3 downto 0);
begin
   fourstep_0: fourstep port map (
                             clk => clk,
                             step => step
                             );

   process
   begin
       for i in 0 to 20 loop
           clk<='0';
           wait for 10 ms;
           clk<='1';
           wait for 10 ms;
       end loop;
      assert false report "have a nice day!" severity note;
      wait;
   end process;
end behav;

