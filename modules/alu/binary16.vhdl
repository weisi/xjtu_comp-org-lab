-- multiple1902 <multple1902@gmail.com>
-- Released under GNU GPL v3, or later.

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

package binary16 is

    subtype binary16 is std_logic_vector(15 downto 0);
    
    type binary16_ir is record -- the intermediate representation
        sign:           std_logic;
        exponent:       std_logic_vector(4 downto 0);     -- offset-binary
        significand:    std_logic_vector(10 downto 0);    -- no hidden bit, unsigned
    end record;

    function ieee754_binary16_iszero_ir(
        i0: binary16_ir
    ) return boolean;

    function ieee754_binary16_iszero(
        i0: binary16
    ) return boolean;

    constant ieee754_binary16_zero: std_logic_vector;

    function ieee754_binary16_significand(
        i0: binary16
    ) return std_logic_vector;

    procedure ieee754_binary16_align(
        variable i0, i1: inout binary16_ir
    );

    function ieee754_binary16_add(
        i0, i1:  binary16
    ) return binary16;
end;

package body binary16 is

    function ieee754_binary16_getir(
        i0: binary16
    ) return binary16_ir is
        variable ret: binary16_ir;
    begin
        ret.sign := i0(15);
        ret.exponent:=i0(14 downto 10);
        if ieee754_binary16_iszero_ir(ret) then
            ret.significand := "00000000000";
        else
            ret.significand(9 downto 0) := i0(9 downto 0);
            ret.significand(10):='1';
        end if;
        return ret;
    end;

    function ieee754_binary16_getraw(
        i0: binary16_ir
    ) return binary16 is
        variable ret: binary16;
        variable i0t: binary16_ir;
    begin
        i0t:=i0;
        ret(15) := i0t.sign;
        ret(14 downto 10) := i0t.exponent;
        if ieee754_binary16_iszero_ir(i0t) then
            ret(9 downto 0) := "0000000000";
        else

            while i0t.significand(9)/='1' and (ieee.std_logic_unsigned.">"(i0.exponent, "00010")) loop
                -- no overflow
                i0t.significand(10 downto 1) := i0t.significand(9 downto 0);
                i0t.significand(0) := '0';
                i0t.exponent := ieee.std_logic_unsigned."+"(i0t.exponent,1);
            end loop;

            ret(9 downto 0) := i0t.significand(9 downto 0);
        end if;
        return ret;
    end;

    function ieee754_binary16_iszero_ir(
        i0: binary16_ir
    ) return boolean is
    begin
        return ieee.std_logic_unsigned."="(i0.exponent,"00000");
    end;

    function ieee754_binary16_iszero(
        i0: binary16
    ) return boolean is
    begin
        return ieee.std_logic_unsigned."="(i0(14 downto 0),"000000000000000");
    end;

    constant ieee754_binary16_zero: std_logic_vector:="0000000000000000";

    function ieee754_binary16_significand(
        -- get the significand, or fraction
        i0: binary16
    ) return std_logic_vector is
        variable ret: std_logic_vector(11 downto 0);

            -- 9 downto 0   : same as i0
            -- 10           : 1 -- hidden bit
            -- 11           : reserved
    begin
        ret(9 downto 0)     := i0(9 downto 0);
        ret(11 downto 10)   := "01";
        return(ret);
    end;

    procedure ieee754_binary16_align(
        -- outputs may not be ieee754 qualified
        variable i0, i1: inout binary16_ir
    ) is
    begin
        -- make the smaller one scale to the bigger one's exponent

        while (ieee.std_logic_unsigned."<"(i0.exponent, i1.exponent)) and (ieee.std_logic_unsigned."<"(i0.exponent, "11111")) loop
            -- no overflow
            i0.significand(10 downto 1) := i0.significand(9 downto 0);
            i0.significand(0) := '0';
            i0.exponent := ieee.std_logic_unsigned."+"(i0.exponent,1);
        end loop;

        while (ieee.std_logic_unsigned."<"(i0.exponent, i1.exponent)) and (ieee.std_logic_unsigned."<"(i1.exponent, "11111")) loop
            i0.significand(10 downto 1) := i0.significand(9 downto 0);
            i1.significand(10 downto 1) := i1.significand(9 downto 0);
            i1.significand(0) := '0';
            i1.exponent := ieee.std_logic_unsigned."+"(i1.exponent,1);
        end loop;
    end;

    function ieee754_binary16_add(
        i0, i1: binary16
    ) return binary16 is 
        variable i0ir, i1ir: binary16_ir;
        variable ret: binary16;
    begin

        i0ir := ieee754_binary16_getir(i0);
        i1ir := ieee754_binary16_getir(i1);

        -- Special Conditions Check

        -- 1. if a1==0 and a2==0
        --      result = 0
        if ieee754_binary16_iszero(i0) and ieee754_binary16_iszero(i1) then
            ret := ieee754_binary16_zero;
            return ret;
        end if;

        -- 2. if a1==a2 but signs differ
        --      ret = 0
        if ieee.std_logic_unsigned."="(i0(14 downto 0),i1(14 downto 0)) and i0(15)/=i1(15) then
            ret := ieee754_binary16_zero;
            return ret;
        end if;

        -- 3. if a1==0 but a2<>0
        --      ret = a1
        if ieee754_binary16_iszero(i0) and not ieee754_binary16_iszero(i1) then
            ret := i1;
            return ret;
        end if;

        -- 4. if a1<>0 but a2==0
        --      ret = a2
        if not ieee754_binary16_iszero(i0) and ieee754_binary16_iszero(i1) then
            ret := i0;
            return ret;
        end if;

        -- No Special Conditions Matched

        ieee754_binary16_align(i0ir, i1ir);

        i0ir.significand := ieee.std_logic_unsigned."+"(i0ir.significand + i1ir.significand);
        if i0ir.significand(10)='1' then
            i0ir.exponent := ieee.std_logic_unsigned."-"(i0ir.exponent, 1);
            i0ir.significand(9 downto 0):=i0ir.significand(10 downto 1);
            i0ir.significand(10):='0';
        end if;

    end;

end package body;
