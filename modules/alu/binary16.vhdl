-- multiple1902 <multple1902@gmail.com>
-- Released under GNU GPL v3, or later.

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

package binary16 is

    subtype binary16 is std_logic_vector(15 downto 0);

    function ieee754_binary16_iszero(
        i0: binary16
    ) return boolean;

    constant ieee754_binary16_zero: std_logic_vector;

    function ieee754_binary16_significand(
        i0: binary16
    ) return std_logic_vector;

    procedure ieee754_binary16_align(
        variable i0, i1: in binary16;
        variable i0o, i1o: out binary16
    );

    procedure ieee754_binary16_add(
        variable i0, i1: in binary16;
        variable ret: out binary16
    );
end;

package body binary16 is

    function ieee754_binary16_iszero(
        i0: binary16
    ) return boolean is
    begin
        for i in 14 downto 0 loop -- yes, it's 14
            if i0(i)='1' then
                return(FALSE);
            end if;
        end loop;
        return(TRUE);
    end;

    constant ieee754_binary16_zero: std_logic_vector:="0000000000000000";

    function ieee754_binary16_significand(
        i0: binary16
    ) return std_logic_vector is
        variable ret: std_logic_vector(11 downto 0);

            -- 9 downto 0   : same as i0
            -- 10           : 1
            -- 11           : reserved
    begin
        ret(9 downto 0)     := i0(9 downto 0);
        ret(11 downto 10)   := "01";
        return(ret);
    end;

    procedure ieee754_binary16_align(
        variable i0, i1: in binary16;
        variable i0o, i1o: out binary16
    ) is
        variable i0t, i1t: binary16;
    begin
        i0t := i0;
        i1t := i1;

        while ieee.std_logic_unsigned.">"(i0t(14 downto 10), i1t(14 downto 10)) loop
            i0t(9 downto 0) := i0t(10 downto 1);
            i0t(10) := '0';
            i0t(14 downto 10) := i0t(14 downto 0) - 1;
        end loop;

        while ieee.std_logic_unsigned."<"(i0t(14 downto 10), i1t(14 downto 10)) loop
            i1t(9 downto 0) := i1t(10 downto 1);
            i1t(10) := '0';
            i1t(14 downto 10) := i1t(14 downto 0) - 1;
        end loop;

        i0o := i0t;
        i1o := i1t;
    end;

    procedure ieee754_binary16_add(
        variable i0, i1: in binary16;
        variable ret: out binary16
    ) is 
        variable i0t, i1t: binary16;
    begin

        -- Special Conditions Check

        -- 1. if a1==0 and a2==0
        --      result = 0
        if ieee754_binary16_iszero(i0) and ieee754_binary16_iszero(i1) then
            ret := ieee754_binary16_zero;
            return;
        end if;

        -- 2. if a1==a2 but signs differ
        --      ret = 0
        if ieee.std_logic_unsigned."="(i0(14 downto 0),i1(14 downto 0)) and i0(15)/=i1(15) then
            ret := ieee754_binary16_zero;
            return;
        end if;

        -- 3. if a1==0 but a2<>0
        --      ret = a1
        if ieee754_binary16_iszero(i0) and not ieee754_binary16_iszero(i1) then
            ret := i1;
            return;
        end if;

        -- 4. if a1<>0 but a2==0
        --      ret = a2
        if not ieee754_binary16_iszero(i0) and ieee754_binary16_iszero(i1) then
            ret := i0;
            return;
        end if;

        -- No Special Conditions Matched

            

    end;

end package body;
