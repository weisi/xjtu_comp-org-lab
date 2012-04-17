-- multiple1902 <multple1902@gmail.com>
-- Released under GNU GPL v3, or later.

library ieee;
use ieee.std_logic_1164.all;

entity decoder is
  port (op      : in std_logic_vector(3 downto 0); 
        clk     : in std_logic;

        result  : out std_logic_vector(15 downto 0) -- no semicolon here!
  );
end decoder;

architecture behv of decoder is

begin
    process(op)
    begin
        case op is

            when "0000" => result <= "0000000000000001";
            when "0001" => result <= "0000000000000010";
            when "0010" => result <= "0000000000000100";
            when "0011" => result <= "0000000000001000";
            when "0100" => result <= "0000000000010000";
            when "0101" => result <= "0000000000100000";
            when "0110" => result <= "0000000001000000";

         -- unused
         -- when "0111" => result <= "0000000010000000";
            when "1000" => result <= "0000000100000000";
            when "1001" => result <= "0000001000000000";
            when "1010" => result <= "0000010000000000";
            when "1011" => result <= "0000100000000000";

         -- unused
         -- when "1100" => result <= "0001000000000000";
         -- when "1101" => result <= "0010000000000000";
         -- when "1110" => result <= "0100000000000000";
         -- when "1111" => result <= "1000000000000000";

            when others =>
                result <= "0000000000000000";
        end case;
    end process;

end behv;
