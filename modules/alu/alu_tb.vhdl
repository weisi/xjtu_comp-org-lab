library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

use work.binary16.all;


entity alu_tb is
end alu_tb;

architecture behav of alu_tb is
   component alu
      port (i0, i1  : in binary16; 
            op      : in std_logic_vector(3 downto 0); 
            clk     : in std_logic; 
            

            result  : out binary16;
            exception: out std_logic
      );
   end component;

   for alu_0: alu use entity work.alu;
   signal i0, i1 : binary16; 
   signal op : std_logic_vector(3 downto 0); 
   signal clk : std_logic;
   signal result : binary16;
begin
   alu_0: alu port map (i0 => i0, i1 => i1, op=>op, clk=>clk, result => result);

   process
      type op_array is array (natural range <>) of std_logic_vector(3 downto 0);
      constant ops : op_array :=
        ("0000", "0001", "0100", "0101", 
         "1000", "1001", "1010", "1011");
   begin
      for i in ops'range loop
         i0 <= "1010010101011010";
         i1 <= "0101101010100101";
         op <= ops(i);
         wait for 1 ms;
      end loop;
      assert false report "have a nice day!" severity note;
      wait;
   end process;
end behav;

