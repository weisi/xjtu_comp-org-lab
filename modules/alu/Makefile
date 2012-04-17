# multiple1902 <multiple1902@gmail.com>
# Released under GNU GPL v3, or later.


ELEMENT := alu
BINARY16:= binary16
TB		:= alu_tb
WAVE	:= $(TB).vcd

GHDL	:= ghdl 
IEEE	:= --ieee=synopsys

all: analyze executable

analyze: $(BINARY16).o $(ELEMENT).o $(TB).o
	
$(BINARY16).o:	$(BINARY16).vhdl
	$(GHDL) -a -Wa,--32 $(IEEE) $(BINARY16).vhdl

$(ELEMENT).o: $(ELEMENT).vhdl $(BINARY16).o
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
