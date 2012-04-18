-- multiple1902 <multple1902@gmail.com>
-- Released under GNU GPL v3, or later.

library ieee;
use ieee.std_logic_1164.all;

entity memory_tb is
end memory_tb;

architecture behav of memory_tb is
   component memory
      port (
            cs      : in std_logic; -- Chip select
            re, we  : in std_logic; -- Read / Write Enable
            clk     : in std_logic;

            addr_h, addr_l  
                     : in  std_logic_vector(4 downto 0);
            data_in  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0) -- no semicolon here!
      );
   end component;

   for memory_0: memory use entity work.memory;
   signal cs      : std_logic; -- Chip select
   signal re, we  : std_logic; -- Read / Write Enable
   signal clk     : std_logic;

   signal addr_h, addr_l  : std_logic_vector(4 downto 0);
   signal data_in  : std_logic_vector(7 downto 0);
   signal data_out : std_logic_vector(7 downto 0);
begin
   memory_0: memory port map (
                             cs => cs,
                             re => re,
                             we => we,
                             clk => clk,
                             addr_h => addr_h,
                             addr_l => addr_l,
                             data_in => data_in,
                             data_out => data_out
                             );

   process
   begin
       cs<='1';
       we<='1';
       re<='0';
       clk<='0';
       addr_h<="00000";
       addr_l<="11111";
       data_out<="01010110";
       wait for 10 ms;
       clk<='1';
       wait for 10 ms;

       we<='0';
       re<='1';
       clk<='0';
       addr_h<="00000";
       addr_l<="11111";
       wait for 10 ms;
       clk<='1';
       wait for 10 ms;
      assert false report "have a nice day!" severity note;
      wait;
   end process;
end behav;

