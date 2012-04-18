-- multiple1902 <multple1902@gmail.com>
-- Released under GNU GPL v3, or later.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity memory is
  port (
        cs      : in std_logic; -- Chip select
        re, we  : in std_logic; -- Read / Write Enable
        clk     : in std_logic;

        addr_h, addr_l  
                 : in  std_logic_vector(4 downto 0);
        data_in  : in  std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(15 downto 0) -- no semicolon here!
  );
end memory;

architecture behv of memory is

    type core_type is array(1023 downto 0) of std_logic_vector(15 downto 0);

    signal core: core_type;
    signal addr: std_logic_vector(9 downto 0);

begin
    process(clk,cs,re,we,addr_h,addr_l) 
    begin
        if clk='1' and cs='1' and re='1' then
            addr(9 downto 5)<= addr_h(4 downto 0);
            addr(4 downto 0)<= addr_l(4 downto 0);
            data_out <= core(conv_integer(std_logic_vector(addr)));
        elsif clk='1' and cs='1' and we='1' then
            addr(9 downto 5)<= addr_h(4 downto 0);
            addr(4 downto 0)<= addr_l(4 downto 0);
            -- core(to_integer(unsigned(addr)))<= data_in;
            -- core(to_integer(unsigned(addr)))<= data_in;
            core(conv_integer(std_logic_vector(addr)))<= data_in;
            data_out <= core(to_integer(unsigned(addr)));
      assert false report "hello" severity note;
        --    data_out <= "ZZZZZZZZZZZZZZZZ";
        --else
        --    data_out <= "ZZZZZZZZZZZZZZZZ";
        end if;
    end process;

end behv;
