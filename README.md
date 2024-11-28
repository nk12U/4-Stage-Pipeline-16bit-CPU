# 4-Stage-Pipeline-16bit-CPU

## Overview

This project implements a 4-Stage Pipeline 16bit CPU designed to execute simple instructions. The CPU architecture follows a 4-stage pipeline:  

1. Instruction Fetch (IF)
2. Instruction Decode (ID)
3. Execute (EX)
4. Write Back (WB)

## ISA

- RISC
- Load-Store Architecture
- Instruction Width: 15bit  
- Opcode: 4bit
<img src = "https://github.com/nk12U/4-Stage-Pipeline-16bit-CPU/blob/main/img/ISA.jpg"> 

## Micro Architecture

<img src = "https://github.com/nk12U/4-Stage-Pipeline-16bit-CPU/blob/main/img/chapter7.png"> 

## Environment

- FPGA: Altera Cyclone V DE0-CV
- IDE: [Quartus Prime Lite 23.1.1](https://www.intel.com/content/www/us/en/software-kit/825278/intel-quartus-prime-lite-edition-design-software-version-23-1-1-for-windows.html)
- Simulator: [ModelSim 20.1.1](https://www.intel.com/content/www/us/en/software-kit/660907/intel-quartus-prime-lite-edition-design-software-version-20-1-1-for-windows.html)
- Text Editor: [VSCode](https://code.visualstudio.com/)
