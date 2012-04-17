-- multiple1902 <multple1902@gmail.com>
-- Released under GNU GPL v3, or later.

library ieee;
use ieee.std_logic_1164.all;

entity decoder_tb is
end decoder_tb;

architecture behav of decoder_tb is
   component decoder
      port (op      : in std_logic_vector(3 downto 0); 
            clk     : in std_logic;

            result  : out std_logic_vector(15 downto 0) -- no semicolon here!
      );
   end component;

   for decoder_0: decoder use entity work.decoder;
   signal op : std_logic_vector(3 downto 0); 
   signal clk : std_logic;
   signal result : std_logic_vector(15 downto 0);
begin
   decoder_0: decoder port map (op=>op, clk=>clk, result => result);

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
         op <= ops(i);
         wait for 10 ms;
      end loop;
      assert false report "have a nice day!" severity note;
      wait;
   end process;
end behav;

