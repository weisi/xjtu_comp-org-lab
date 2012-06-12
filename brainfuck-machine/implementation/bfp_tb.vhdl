-- multiple1902 <multple1902@gmail.com>
-- Released under GNU GPL v3, or later.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

use std.textio.all;

entity bfp_tb is
end bfp_tb;

architecture behav of bfp_tb is
    subtype bfp_instruction is std_logic_vector(2 downto 0);
    subtype bfp_data is std_logic_vector(7 downto 0);
    component bfp
        port (ins_in  : in bfp_instruction;
              data_in : in bfp_data;
              clk     : in std_logic;

              data_out: out bfp_data;
              halt    : out std_logic -- no semicolon here!
        );
    end component;

    for bfp_0: bfp use entity work.bfp;
    signal ins_in  : bfp_instruction;
    signal data_in : bfp_data;
    signal clk     : std_logic;
    signal data_out: bfp_data;
    signal halt    : std_logic;
begin
    bfp_0: bfp port map (ins_in => ins_in,
                         data_in => data_in,
                         clk => clk,
                         data_out => data_out,
                         halt => halt
                     );

    process
        variable l: line;
        variable counter: integer := 0;
        type op_array is array (natural range <>) of bfp_instruction;
        constant ops : op_array :=
           (
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "100",
            "000",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "000",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "000",
            "010",
            "010",
            "010",
            "000",
            "010",
            "001",
            "001",
            "001",
            "001",
            "011",
            "101",
            "000",
            "010",
            "010",
            "110",
            "000",
            "010",
            "110",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "110",
            "110",
            "010",
            "010",
            "010",
            "110",
            "000",
            "010",
            "010",
            "110",
            "001",
            "001",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "010",
            "110",
            "000",
            "110",
            "010",
            "010",
            "010",
            "110",
            "011",
            "011",
            "011",
            "011",
            "011",
            "011",
            "110",
            "011",
            "011",
            "011",
            "011",
            "011",
            "011",
            "011",
            "011",
            "110",
            "000",
            "010",
            "110",
            "000",
            "110"
          );
    begin
        for i in ops'range loop
            -- write(l, String'("loop"));
            -- writeline(output, l);
            clk <= '0';
            wait for 1 ns;
            ins_in <= ops(i);
            clk <= '1';
            wait for 10 ms;
        end loop;

        clk <= '0';
        wait for 1 ns;
        ins_in <= "ZZZ";
        clk <= '1';
        wait for 10 ms;

        while halt='0' loop
            clk <= '0';
            wait for 1 ns;
            clk <= '1';
            wait for 10 ms;

            if ieee.std_logic_1164."/="(data_out,"ZZZZZZZZ") then
                case conv_integer(data_out) is
                    when 97=>
                        write(l, string'("a"));
                    when 98=>
                        write(l, string'("b"));
                    when 99=>
                        write(l, string'("c"));
                    when 100=>
                        write(l, string'("d"));
                    when 101=>
                        write(l, string'("e"));
                    when 102=>
                        write(l, string'("f"));
                    when 103=>
                        write(l, string'("g"));
                    when 104=>
                        write(l, string'("h"));
                    when 105=>
                        write(l, string'("i"));
                    when 106=>
                        write(l, string'("j"));
                    when 107=>
                        write(l, string'("k"));
                    when 108=>
                        write(l, string'("l"));
                    when 109=>
                        write(l, string'("m"));
                    when 110=>
                        write(l, string'("n"));
                    when 111=>
                        write(l, string'("o"));
                    when 112=>
                        write(l, string'("p"));
                    when 113=>
                        write(l, string'("q"));
                    when 114=>
                        write(l, string'("r"));
                    when 115=>
                        write(l, string'("s"));
                    when 116=>
                        write(l, string'("t"));
                    when 117=>
                        write(l, string'("u"));
                    when 118=>
                        write(l, string'("v"));
                    when 119=>
                        write(l, string'("w"));
                    when 120=>
                        write(l, string'("x"));
                    when 121=>
                        write(l, string'("y"));
                    when 122=>
                        write(l, string'("z"));
                    when 65=>
                        write(l, string'("A"));
                    when 66=>
                        write(l, string'("B"));
                    when 67=>
                        write(l, string'("C"));
                    when 68=>
                        write(l, string'("D"));
                    when 69=>
                        write(l, string'("E"));
                    when 70=>
                        write(l, string'("F"));
                    when 71=>
                        write(l, string'("G"));
                    when 72=>
                        write(l, string'("H"));
                    when 73=>
                        write(l, string'("I"));
                    when 74=>
                        write(l, string'("J"));
                    when 75=>
                        write(l, string'("K"));
                    when 76=>
                        write(l, string'("L"));
                    when 77=>
                        write(l, string'("M"));
                    when 78=>
                        write(l, string'("N"));
                    when 79=>
                        write(l, string'("O"));
                    when 80=>
                        write(l, string'("P"));
                    when 81=>
                        write(l, string'("Q"));
                    when 82=>
                        write(l, string'("R"));
                    when 83=>
                        write(l, string'("S"));
                    when 84=>
                        write(l, string'("T"));
                    when 85=>
                        write(l, string'("U"));
                    when 86=>
                        write(l, string'("V"));
                    when 87=>
                        write(l, string'("W"));
                    when 88=>
                        write(l, string'("X"));
                    when 89=>
                        write(l, string'("Y"));
                    when 90=>
                        write(l, string'("Z"));
                    when 48=>
                        write(l, string'("0"));
                    when 49=>
                        write(l, string'("1"));
                    when 50=>
                        write(l, string'("2"));
                    when 51=>
                        write(l, string'("3"));
                    when 52=>
                        write(l, string'("4"));
                    when 53=>
                        write(l, string'("5"));
                    when 54=>
                        write(l, string'("6"));
                    when 55=>
                        write(l, string'("7"));
                    when 56=>
                        write(l, string'("8"));
                    when 57=>
                        write(l, string'("9"));
                    when others =>
                end case;
                writeline(output, l);
            end if;
        end loop;

        wait;
    end process;
end behav;

