# multiple1902 <multiple1902@gmail.com>
# Released under GNU GPL v3, or later.


ELEMENT := alu.vhdl
BINARY16:= binary16.vhdl
TB		:= alu_tb
WAVE	:= $(TB).vcd

GHDL	:= ghdl 
IEEE	:= --ieee=synopsys

all: analyze executable

analyze: binary16.o alu.o alu_tb.o
	
binary16.o:	binary16.vhdl
	$(GHDL) -a -Wa,--32 $(IEEE) $(BINARY16)

alu.o: alu.vhdl binary16.o
	$(GHDL) -a -Wa,--32 $(IEEE) $(ELEMENT)

alu_tb.o: alu_tb.vhdl
	$(GHDL) -a -Wa,--32 $(IEEE) $(TB).vhdl

executable: alu_tb

alu_tb: analyze
	$(GHDL) -e -Wa,--32 $(IEEE) -Wl,-m32 $(TB)

run: alu_tb
	$(GHDL) -r $(TB)

signal: $(WAVE)

alu_tb.vcd: alu_tb
	$(GHDL) -r $(TB) --vcd=$(WAVE)

wave: $(WAVE)
	dinotrace $(WAVE)

gtkwave: $(WAVE)
	gtkwave $(WAVE)

clean:
	rm *.o *.vcd *.cf $(TB)
