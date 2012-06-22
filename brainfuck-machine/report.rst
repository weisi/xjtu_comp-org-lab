======================
计算机组成原理专题实验
======================

:Author:    Weisi Dai <weisi@x-research.com>
:Date:      Jun 10, 2012
:Revision:  1
:Copyright: `CC BY-NC-SA 2.0 <http://creativecommons.org/licenses/by-nc-sa/2.0/>`_

实验目的
========

    #. 实践「计算机组成原理」课程中学习的知识.
    #. 学习和掌握设计一个计算机系统 (模型机) 的方法和设计「CPU」的技术.

实验要求
========

    设计并实现一个基本的计算机主机系统.

实验原理
========

VHDL 和 GHDL
------------

    VHDL (Very-High-Speed Integrated Circuit Hardware Description Language) 是电子工程领域的通用硬件描述语言, 通过使用函数, 数据流表现, 结构来描述逻辑电路, 常用于 FPGA 和集成电路. 通过使用 EDA 工具, 可以将 VHDL 程序翻译为对应的数字电路. 在计算机上编写 VHDL 代码, 也可以将 VHDL 作为程序设计语言, 通过编译形成机器代码, 在计算机上执行. 

    GHDL 就是这样的一个开源编译器, 它基于 GCC 编译后端, 实现了 VHDL 语言的一个子集. 与大型 EDA 工具如 Quartus II, ModelSim 等相比, VHDL 因为无需对电路进行综合等原因, 编译更快, 通常要快几十倍甚至上百倍, 极大地方便了编写和调试相对简单的 VHDL 代码的过程. 

    GHDL 的一个 Hello World 程序如下::

        use std.textio.all;

        entity hello_world is
        end hello_world;

        architecture behaviour of hello_world is
        begin
           process
              variable l : line;
           begin
              write (l, String'("Hello world!"));
              writeline (output, l);
              wait;
           end process;
        end behaviour;

    首先分析 (analysis) 系统的设计::

        $ ghdl -a hello.vhdl

    此时 ``hello.vhdl`` 被编译成目标文件 ``hello.o`` (Windows 上没有), 然后进一步生成可执行文件::

        $ ghdl -e hello_world

    这一步生成了可执行文件 ``hello_world``, 执行它::

        $ ghdl -r hello_world

    可以看到一行输出::

        Hello World!

    在执行可执行文件时, 可以指定 ``vcd`` 参数, 将信号波形保存到外置 ``vcd`` (Value Change Dump) 文件中. 然后可以用 GTKWave 和 dinotrace 等软件查看具体的波形.

计算机系统的组成
----------------

    一个完整的计算机主机系统应当包括运算器, 控制器, 存储器, 输入设备, 输出设备这五个部分.

Brainf**k 指令集
----------------

    Urban Müller 在 1993 年为他的 Amiga OS 2.0 操作系统设计了一种名为 brainf**k 的编程语言. 我将 brainf**k 改编为一个 8 指令的指令集合, 其助记符和含义见下表.

    ==========  ======================================= =================== =======
    助记符      含义                                    C 语言等价形式      编码
    ==========  ======================================= =================== =======
    ``>``       指针自增                                ``++P;``            ``000``
    ``<``       指针自减                                ``--P;``            ``001``
    ``+``       指针指向单元自增                        ``++*P;``           ``010``
    ``-``       指针指向单元自减                        ``--*P;``           ``011``
    ``[``       指针指向单元为零则跳转到 ``]`` 之后     ``while (*P){``     ``100``
    ``]``       跳转到对应的 ``[``                      ``}``               ``101``
    ``.``       输出指针指向单元的值                    ``putchar(*P);``    ``110``
    ``,``       读入指针指向单元的值                    ``*P = getchar();`` ``111``
    ==========  ======================================= =================== =======


    Brainf**k 的机器代码由有限条三位元指令构成, 并且用到了一个名为 ``P`` 的指针. ``P`` 指向数据存储区的某个单元, 在初始情况下指向首个单元. 数据存储区的大小事先约定.

设计思路和源代码
================

数据表示
--------

    * 指令和数据分开存储和表示.

    * 指令段: 12 KB. 每条指令 3 比特, 因此可以存放 4096 条指令.

    * 数据段: 4 KB. 数据宽度为 8 位, 因此数据段包括 4096 个单元.

    * PC 的宽度为 12 位. ``P`` 指针的宽度为 12 位.

CPU 的外部接口
--------------

    * 输入接口
        * 指令输入, 3 位.

        * 数据输入, 8 位.

        * 时钟信号, 1 位.

    * 输出接口
        * 数据输出, 8 位.

        * 停机状态, 1 位. 停机时有效.

    以下是 CPU 模块的 VHDL 实体描述::

        entity bfp is
            port (ins_in  : in std_logic_vector(2 downto 0);
                data_in : in std_logic_vector(7 downto 0);
                clk     : in std_logic;

                data_out: out std_logic_vector(7 downto 0);
                halt    : out std_logic
            );
        end bfp;

CPU 的内部信号
--------------

    * 指令存储器 Instruction Memory
    * 数据存储器 Data Memory
    * 寄存器 Registers
      包括 PC, ``P``, IC (Instruction Counter)
    * 循环辅助堆栈 Loop Stack

    因此分别定义指令和数据子类型::

        subtype bfp_instruction is std_logic_vector(2 downto 0);
        subtype bfp_data is std_logic_vector(7 downto 0);

    其 VHDL 实现为::

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

执行阶段
--------

    #. 开机, 读入程序内容.
    #. 执行程序.
    #. 停机.

实现 Brainf**k 指令集
---------------------

    Brainf**k 指令集中的八条指令可以这样实现:

    * ``>`` 指针自增
        #. ``P`` 计数器自增
        #. PC 计数器自增

    * ``<`` 指针自减
        #. ``P`` 计数器自减
        #. PC 计数器自增

    * ``+`` 指针指向单元自增
        #. ``P`` 计数器指向的单元自\ **增**
        #. PC 计数器自增

    * ``-`` 指针指向单元自减
        #. ``P`` 计数器指向的单元自\ **减**
        #. PC 计数器自增

    * ``[`` 指针指向单元不为零则跳转到 ``]`` 之后
        #. 若 ``P`` 计数器指向的单元不为零则将 PC 压入 Loop Stack 并找到对应的 ``]`` 的地址
        #. PC 计数器自增

    * ``]`` 跳转到对应的 ``[``
        #. PC 计数器自增 (思考: 为什么这里先执行?)
        #. 若 ``P`` 计数器指向的单元不为零从 Loop Stack 中弹出 PC, 否则丢弃 Loop Stack 的栈顶元素

    * ``.`` 输出指针指向单元的值
        #. 从存储器中读出 ``P`` 计数器指向的单元并输出
        #. PC 计数器自增

    * ``,`` 读入指针指向单元的值
        #. 将数据输入到 ``P`` 计数器指向的单元
        #. PC 计数器自增

第 1 阶段: 输入指令
-------------------

    CPU 上电后, 从指令输入接口读入指令::

            insm(ic) <= ins_in;
            ic <= ic + 1;

    一旦指令输入变为高阻, 则认为指令输入完毕, 此时将数据存储区域初始化, 并进入第 2 阶段::

            bv := to_bitvector(ins_in);

            if ieee.std_logic_1164."="(ins_in, "ZZZ") then
                stage <= 1;
                halt <= '0';
                st <= 0;

                for i in 0 to 4095 loop
                    datam(i) <= "00000000";
                end loop;
            end if;

第 2 阶段: 执行指令
-------------------

    对于不同的指令, 执行不同的动作::

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

    此处, 对于 ``[`` 指令的执行最为复杂. 按照定义, 执行到 ``[`` 时, ``P`` 指针指向的数据单元若为 0 则跳转到对应的 ``]`` 之后继续执行. 为了找出对应的 ``]``, 需要进行括号匹配过程. 另外, 出于测试方便考虑, 这里没有实现数据输入指令.

    一旦 PC 在自增后超出了 IC, 则进入第三阶段::
        
        if pc>ic then
            stage <= 2;
        end if;

第三阶段: 停机
--------------

    停机阶段, 只需要简单输出停机信号即可::

        halt <= '1';

编写测试环境
------------

    Hello World 程序的助记符表达如下::

        ++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..
        +++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.

    翻译为机器代码为::

        type op_array is array (natural range <>) of bfp_instruction;
        constant ops : op_array :=
        (
            "010", "010", "010", "010", "010", 
            "010", "010", "010", "010", "010", 
            "100", "000", "010", "010", "010",
            "010", "010", "010", "010", "000",
            "010", "010", "010", "010", "010",
            "010", "010", "010", "010", "010",
            "000", "010", "010", "010", "000",
            "010", "001", "001", "001", "001",
            "011", "101", "000", "010", "010",
            "110", "000", "010", "110", "010",
            "010", "010", "010", "010", "010",
            "010", "110", "110", "010", "010",
            "010", "110", "000", "010", "010",
            "110", "001", "001", "010", "010",
            "010", "010", "010", "010", "010",
            "010", "010", "010", "010", "010",
            "010", "010", "010", "110", "000",
            "110", "010", "010", "010", "110",
            "011", "011", "011", "011", "011",
            "011", "110", "011", "011", "011",
            "011", "011", "011", "011", "011",
            "110", "000", "010", "110", "000", "110"
        );

    将机器代码写入 CPU::

        for i in ops'range loop
            clk <= '0';
            wait for 10 ms;
            ins_in <= ops(i);
            clk <= '1';
            wait for 10 ms;
        end loop;

    将指令输入置为高阻, 结束指令输入::

            clk <= '0';
            wait for 10 ms;
            ins_in <= "ZZZ";
            clk <= '1';
            wait for 10 ms;

    然后在停机之前执行指令. 这里, 我们用 ``std.textio`` 库将 CPU 的数据输出对应 ASCII 码的字符打印到屏幕. 程序内置码表::

        while halt='0' loop
            clk <= '0';
            wait for 1 ms;
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
                    ... ...
                    when 121=>
                        write(l, string'("y"));
                    when 122=>
                        write(l, string'("z"));
                    when 65=>
                        write(l, string'("A"));
                    when 66=>
                        write(l, string'("B"));
                    ... ...
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
                    ... ...
                    when 57=>
                        write(l, string'("9"));
                    when others =>
                        write(l, string'(" "));
                end case;
            end if;
        end loop;
        writeline(output, l);

编译控制文件
------------

    为了方便编译源代码, 编写如下 ``Makefile`` 文件, 以使用 ``make`` 工具自动编译::

        ELEMENT := bfp
        TB      := bfp_tb
        WAVE    := $(TB).vcd

        GHDL    := ghdl 
        IEEE    := --ieee=synopsys

        all: analyze executable

        analyze: $(ELEMENT).o $(TB).o
            
        $(ELEMENT).o: $(ELEMENT).vhdl
            $(GHDL) -a -Wa,--32 $(IEEE) $(ELEMENT).vhdl

        $(TB).o: $(TB).vhdl
            $(GHDL) -a -Wa,--32 $(IEEE) $(TB).vhdl

        executable: $(TB)

        $(TB): analyze
            $(GHDL) -e -Wa,--32 $(IEEE) -Wl,-m32 $(TB)

        run: (TB)
            $(GHDL) -r $(TB)

        signal: $(WAVE)

        $(WAVE): $(TB)
            $(GHDL) -r $(TB) --vcd=$(WAVE)

        wave: $(WAVE)
            dinotrace $(WAVE)

        gtkwave: $(WAVE)
            gtkwave $(WAVE)

        clean:
            rm *.o *.vcd *.cf $(TB)

    GHDL 目前只支持 32 位编译, 在 64 位环境下需要用到交叉编译技术, 即打开 ``-Wa,--32`` , ``-Wl,-m32`` 等编译开关.

实验现象
========

    编译并执行代码, 可以看到正确输出了 ``Hello World`` 字符, 说明 CPU 工作正常::

        [multiple1902 implementation]$ make clean
        rm *.o *.vcd *.cf bfp_tb
        [multiple1902 implementation]$ make signal
        ghdl  -a -Wa,--32 --ieee=synopsys bfp.vhdl
        ghdl  -a -Wa,--32 --ieee=synopsys bfp_tb.vhdl
        ghdl  -e -Wa,--32 --ieee=synopsys -Wl,-m32 bfp_tb
        ghdl  -r bfp_tb --vcd=bfp_tb.vcd
        Hello World


    同时可以查看到波形:

    .. image:: drawing.svg
        :width: 100%

实验总结
========

    通过这次计算机组成原理专题实验课程, 我基本掌握了设计计算机组成元件的方法, 并动手设计并实现了一个简单的 CPU.

    本次实验的所有程序代码基于 GNU GPL v3 协议开源, 并可以从 `<https://github.com/multiple1902/xjtu_comp-org-lab>`_ 访问.

    感谢老师的指点.

附录: 辅助工具
==============

    为了编写代码, 我使用 Python 语言编写了两个小工具.

将 Brainf**k 助记符翻译为机器指令
---------------------------------

    ::

        #!/usr/bin/env python
        # translate from brainf**k to binary code in string

        bf_str = raw_input()

        table = {
                '>' : '000',
                '<' : '001',
                '+' : '010',
                '-' : '011', 
                '[' : '100',
                ']' : '101',
                '.' : '110',
                ',' : '111',
                }

        for i in range(len(bf_str)): print "%s" % table[bf_str[i]]

获取 ASCII 字母和数字字符的码表
-------------------------------

    ::

        #!/usr/bin/env python

        chars = []
        chars += range(ord('a'), ord('z') + 1, 1) 
        chars += range(ord('A'), ord('Z') + 1, 1) 
        chars += range(ord('0'), ord('9') + 1, 1)

        for i in chars:
            print "when %s=>" % i
            print "    write(l, string'(\"%s\"));" % (chr(i))

(完)
