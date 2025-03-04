# Conway's Game of Life - Assembly Implementation

## Overview
This repository contains an assembly implementation of **Conway's Game of Life**, a zero-player game invented by mathematician **John Horton Conway** in 1970. The game simulates the evolution of a system of cells based on predefined rules.

The project includes **two versions** of the program:
- **Keyboard Input Version**: Reads the initial configuration from the keyboard.
- **File I/O Version**: Reads the initial configuration from a file and writes the output to a file.

## Rules of the Game
The simulation follows five fundamental rules that determine the life cycle of cells:

1. **Underpopulation**: Any live cell with fewer than **two** live neighbors **dies**.
2. **Survival**: Any live cell with **two or three** live neighbors **survives**.
3. **Overpopulation**: Any live cell with more than **three** live neighbors **dies**.
4. **Reproduction**: Any dead cell with **exactly three** live neighbors **becomes alive**.
5. **Stable Dead Cells**: Any other dead cell remains **dead**.

## Features
✅ Implemented in **assembly** for low-level performance and efficiency.<br>
✅ Supports **interactive mode** (keyboard input).<br>
✅ Supports **file-based input and output**.<br>
✅ Simulates multiple generations of Conway's Game of Life.<br>
✅ Fully compliant with the original ruleset.
