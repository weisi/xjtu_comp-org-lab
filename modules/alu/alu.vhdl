library ieee;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

use work.binary16.all;

entity alu is
  port (i0, i1  : in binary16; 
        op      : in std_logic_vector(3 downto 0); 
        clk     : in std_logic;

        result  : out binary16;
        exception: out std_logic -- no semicolon here!
  );
end alu;

architecture behv of alu is

    procedure bitwise_and(
        signal i0, i1: in binary16;
        signal result: out binary16;
        signal exception: out std_logic
    ) is
    begin
        result <= i0 and i1;
        exception <= '0';
    end;

begin
    process(i0, i1, op)
    -- process(clk)
        variable i0t, i1t, ret: binary16;
        variable exp0, exp1: std_logic_vector(4 downto 0);
        variable tmp_compl: std_logic_vector(31 downto 0);
            
    begin
        exception <= '0';
        case op is

            -- Standard Logic

            when "0000" => 
                -- bitwise AND
                bitwise_and(i0,i1,result,exception);

            when "0001" =>
                -- bitwise OR
                result <= i0 or i1;
                exception <= '0';

            when "0010" =>
                -- bitwise XOR 
                result <= i0 xor i1;
                exception <= '0';

            when "0011" =>
                -- bitwise NOT
                result <= not i0;
                exception <= '0';

            -- Arithmic on Complements of Integers

            when "0100" =>
                -- plus on complements
                i0t := not(i0)+2;
                i1t := not(i1)+2;
                ret := i0t+i1t;
                result <= not(ret)+2;
                exception <= i0t(0) and i1t(0);

            when "0101" =>
                -- minus on complements
                i0t := not(i0)+2;
                i1t := not(i1)+2;
                ret := i0t-i1t;
                result <= not(ret)+2;
                exception <= '0';


            when "0110" =>
                -- multiplication on complements
                i0t := not(i0)+2;
                i1t := not(i1)+2;
                tmp_compl := i0t*i1t;
                ret := tmp_compl(15 downto 0);
                result <= not(ret)+2;
                exception <= '0';

            -- Shift 

            when "1000" =>
                -- shift left logic
                result <= to_stdlogicvector(to_bitvector(i0) sll 1);
                exception <= '0';

            when "1001" =>
                -- shift right logic
                result <= to_stdlogicvector(to_bitvector(i0) srl 1);
                exception <= '0';

            when "1010" =>
                -- shift left arithmic
                result <= to_stdlogicvector(to_bitvector(i0) sla 1);
                exception <= '0';

            when "1011" =>
                -- shift right arithmic
                result <= to_stdlogicvector(to_bitvector(i0) sra 1);
                exception <= '0';

            when others =>
        end case;
    end process;

end behv;
