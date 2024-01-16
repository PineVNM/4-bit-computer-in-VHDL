VHDL - 4 bit computer for DE 10 Lite

This is based on the verilog implemented, 4 bit computer described at
https://ryanzumbrunnen.wordpress.com/2018/03/04/4-bit-fpga-cpu/

The top level entity contains the description for the computer.
Individual entities and test benches are provided for other entitites

Main entity(s)
- arithmetic.vhdl
- logical.vhdl
- comparison4bit.vhdl
- magic2.vhdl

Helper entity(s)
- hexToSevenSegemnt.vhdl
- mux_10_4.vhdl

Top entity 4-bit computer
- conputer_4_bit.vhdl
