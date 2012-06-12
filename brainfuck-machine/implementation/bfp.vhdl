-- multiple1902 <multple1902@gmail.com>
-- Released under GNU GPL v3, or later.
library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

use std.textio.all;


entity bfp is
    port (ins_in  : in std_logic_vector(2 downto 0);
        data_in : in std_logic_vector(7 downto 0);
        clk     : in std_logic;

        data_out: out std_logic_vector(7 downto 0);
        halt    : out std_logic -- no semicolon here!
    );
end bfp;

architecture behv of bfp is
    subtype bfp_instruction is std_logic_vector(2 downto 0);
    subtype bfp_data is std_logic_vector(7 downto 0);

    type insm_type is array(4095 downto 0) of bfp_instruction;
    type datam_type is array(4095 downto 0) of bfp_data;
    type stackm_type is array(4095 downto 0) of integer range 0 to 4095;

    signal stage: integer range 0 to 2 := 0;
    signal pc: integer range 0 to 4095 := 0;
    signal ic: integer range 0 to 4095 := 0;
    signal P: integer range 0 to 4095  := 0;
    signal st: integer range 0 to 4095 := 0;

    signal insm: insm_type;
    signal datam: datam_type;
    signal stackm: stackm_type;
begin
    process(clk)
        variable l: line;
        variable bv: bit_vector(2 downto 0);
        variable bv1: bit_vector(7 downto 0);
        variable tst, tpc: integer;
    begin
        if clk = '1' then
            case stage is
                when 0 =>
                    -- input instructions

                    insm(ic) <= ins_in;
                    ic <= ic + 1;

                    bv := to_bitvector(ins_in);

                    if ieee.std_logic_1164."="(ins_in, "ZZZ") then
                        stage <= 1;
                        halt <= '0';
                        st <= 0;

                        for i in 0 to 4095 loop
                            datam(i) <= "00000000";
                        end loop;
                    end if;

                when 1 =>
                    -- running
                    data_out <= "ZZZZZZZZ";

                    case insm(pc) is
                        when "000" =>
                            P <= P + 1;
                            pc <= pc + 1;

                        when "001" =>
                            P <= P - 1;
                            pc <= pc + 1;

                        when "010" =>
                            datam(P) <= datam(P) + 1;
                            pc <= pc + 1;

                        when "011" =>
                            datam(P) <= datam(P) - 1;
                            pc <= pc + 1;

                        when "100" =>
                            bv1 := to_bitvector(datam(P));
                            if ieee.std_logic_unsigned."/="(datam(P), "00000000") then
                                stackm(st) <= pc;
                                st <= st + 1;
                            end if;
                            if ieee.std_logic_1164."="(datam(P), "00000000") then
                                tst:=1;
                                tpc := pc;
                                while(tst/=0) loop
                                    tpc := tpc + 1;
                                    if ieee.std_logic_1164."="(insm(tpc), "100") then
                                        tst := tst + 1;
                                    end if;
                                    if ieee.std_logic_1164."="(insm(tpc), "101") then
                                        tst := tst - 1;
                                    end if;
                                end loop;
                                pc <= tpc;
                            end if;
                            pc <= pc + 1;

                        when "101" =>
                            pc <= pc + 1;
                            if ieee.std_logic_unsigned."/="(datam(P), "00000000") then
                            pc <= stackm(st - 1);
                            end if;
                            st <= st - 1;

                        when "110" =>
                            data_out <= datam(P);
                            pc <= pc + 1;

                        when others =>
                            pc <= pc + 1;

                    end case;

                    if pc>ic then
                        stage <= 2;
                    end if;

                when 2 => 
                    -- halt
                    halt <= '1';

            end case;
        end if;
    end process;

end behv;
