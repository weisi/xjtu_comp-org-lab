-- multiple1902 <multple1902@gmail.com>
-- Released under GNU GPL v3, or later.

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
        ("0000", -- bitwise AND
         "0001", --         OR
         "0010", --         XOR
         "0011", --         NOT (1st op)

         "0100", -- addition on complements
         "0101", -- minus
         "0110", -- multiplication

         "1000", -- logic shl
         "1001", --       shr
         "1010", -- arithmetic shl
         "1011"  --            shr
        );
   begin
      for i in ops'range loop
         i0 <= "1010010101011010";
         i1 <= "0101101010100101";
         op <= ops(i);
         wait for 10 ms;
      end loop;
      assert false report "have a nice day!" severity note;
      wait;
   end process;
end behav;

