# uart-traffic-light-fpga
UART-based FSM traffic light controller written in structural VHDL, deployed on DE2 FPGA board with live debug messages sent to PC via serial.

# UART-Based Traffic Light Controller

A structural VHDL project implementing a fully functional UART system integrated with a finite-state machine (FSM) traffic light controller. 

## Technologies Used

- **VHDL (Structural)**
- **Quartus II (Altera)**
- **DE2 Cyclone FPGA Board**


## Project Description

The goal of this project was to design and implement a UART communication system entirely in structural VHDL. This UART was then integrated with a traffic light controller FSM to transmit debug messages to a PC. The project reinforces core concepts in digital systems, FSM design, synchronization, and hardware-software integration using FPGA platforms.

## Features

- UART transmitter and receiver modules
- Baud rate generator supporting 8 selectable baud rates
- Address decoder for register access
- FSM-based traffic light controller with 4 states
- Real-time debug output displayed on PC terminal (via RS-232)
- Deployed and tested on DE2 FPGA board

