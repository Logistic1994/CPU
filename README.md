# SoC课程设计CPU概要说明

`SoC` `CPU` `VHDL`

---
### 对原方案的改进
1. 原方案中的模块时序无法理解，我按照自己的想法进行了改进。但是定周期指令这个要求就无法完成了。
2. 数据总线的实现。必须要实现数据总线，否则ISE会提示“Mutiple Drivers”。这里我实现的方式是在固定的时间上对刚刚运行完的模块发出的数据进行查询，如果有更新，则进行更新操作。这样就要求原来的每个模块的data port被拆分为datai, datao, do。其中do指示当前有没有更新。

### 模块的时序
``` vhdl
	clk_MC <= w0;
	clk_ROM <= nclk1 and w0 and clk2;
	clk_IR <= nclk2 and w0;
	clk_PC <= nclk1 and w0 and nclk2;
	clk_P0 <= w1;
	clk_SP <= nclk1 and w1 and clk2;
	clk_RAM <= nclk1 and w1 and nclk2;
	clk_Rn <= nclk1 and w2 and clk2;
	clk_ALU <= nclk1 and w2 and nclk2;
```
在一个微指令周期内，时序顺序是MC, ROM, IR, PC, P0, SP, RAM, Rn, ALU

### 几条指令的具体解释
* PUSH Ri
1. 读取Ri;SP UP;写RAM

* RR Ri
1. 读取Ri; 写到ALU第一个寄存器
2. 设置ALU的运算方式为循环右移，并输出到数据总线
3. 写到Ri

### CM解释
* ALU-CM(47:35)
    * M_A: set A register in ALU
    * M_B: set B register in ALU
    * M_F: show if do shift operation
    * S(4): show if do logic or arithmetic operation
    * S(3:0): logic or arithmetic operations
    * F(1:0): shift operations
    * nAlUEN: transfer result out
    * nPSWEn: transfer PSW out
    * C0: set if the carry is 0 or 1

* RAM-CM(34:32)
    * RAM_CS: select this RAM or not
    * Wr_nRD: if write or read this ram
    * nRAM_EN: set this RAM is enabled

* Rn-CM(31:28)
    * Rn_CS: select this register or not
    * RDRi: if read
    * WRRi: if write
    * nRi_EN: set so that this register is enabled

* IR-CM(27:24)
    * LDIR1: function 1 in IR
    * LDIR2: f2
    * LDIR3: f3
    * nAREN: send generated AR out

* PC-CM(23:20)
    * M_PC: PC++
    * nLD_PC: load new PC
    * nPCH: send high 4 bit of PC out
    * nPCL: send low 8 bit of PC out

* SP-CM(19:16)
    * SP_UP: sp--
    * SP_DN: sp++
    * SP_CS: select this sp or not
    * nSP_EN: enable this sp or not

* P_CS-CM(15:13)
    * P_CS: enable this i/o or not
    * nP_IEN: enable read data 
    * nP_OEN: enable write data

* X-CM(12)
    * X: use some signal, reserved

* ROM-CM(11:10)
    * M_ROM: 
    * nROM_EN: with M_ROM we can know if ROM is working

* MC-CM(9:8)
    * M_uA: use micro instruction or not
    * CMROM_CS: read instruction from inner com

* u-CM(7:0): generated micro instruction

### 跑马灯程序解释
``` as
MOV R0, P0      ; 先从外部设备上读取数据并送到寄存器
B: MOV P0, R0   ; 将此数据从寄存器输出到外部设备上
RR R0           ; 将R0中的数据循环右移（不带进位）
MOV R1, #FF     ; 在R1中写入255
A: DEC R1       ; R1中的数据自减1
JNZ A           ; 如果此时ZN标志位为0, 则跳转到A标签
JMP B           ; 跳转到B标签
```

``` machine_code
10010100 -- 000H nop
00111000 -- 001H mov r0, p0
00110100 -- 002H mov p0, r0
01111100 -- 003H rr r0
00100110 -- 004H
11111111 -- 005H mov r1, 255
01110010 -- 006H dec r1
10001100 -- 007H
00000000 -- 008H
00000110 -- 009H jnz 006H
10001000 -- 00AH
00000000 -- 00BH
00000010 -- 00CH jmp 002H
```

### 当前支持的指令集
``` assembly
MOV Ri, #data   ; 001001Ri0, XXXXXXXX
MOV P0, Ri      ; 0011010Ri
MOV Ri, P0      ; 001110Ri0
ANL Ri, Rj      ; 010001RiRj
ADD Ri, Rj      ; 011001RiRj
DEC Ri          ; 01100Ri0
RL Ri           ; 011110Ri0
RR Ri           ; 011111Ri0
JMP addr12      ; 10001000, 0000AAAA, AAAAAAAA
JNZ addr12      ; 10001100, 0000AAAA, AAAAAAAA
NOP             ; 10010100
CALL addr12     ; 10011000, 0000AAAA, AAAAAAAA
RET             ; 10011100
```


