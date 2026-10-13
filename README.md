# FPGA Psychotechnical Tests Prototype

## Overview

This project is an educational prototype developed by a team of three students. It implements two psychotechnical tests on a Digilent Basys 3 FPGA development board using VHDL and AMD Vivado.

The system evaluates basic psychomotor coordination and temporal anticipation through interactive hardware tests. It uses arcade joysticks, a VGA monitor, push buttons, a seven-segment display, and audio feedback.

The main objective is to explore digital system design, finite state machines (FSMs), hardware interfacing, and real-time interaction using FPGA technology.

## Psychotechnical Tests

### 1. Psychomotor Coordination Test

This test focuses on psychomotor coordination using two arcade joysticks.

**Main components:**
- Two 5-pin arcade joysticks for directional inputs.
- VGA monitor for graphical feedback.
- Speaker for audio feedback.
- Internal timer to control test execution.

The FPGA processes joystick inputs and generates visual feedback through the VGA interface.

A finite state machine manages the initialization, execution, timing, and completion of the test.

### 2. Temporal Anticipation Test

This test explores temporal anticipation and reaction timing through visual stimuli and user interaction.

**Main components:**
- VGA monitor for visual feedback.
- FPGA push buttons for starting the test and registering user reactions.
- Seven-segment display for numerical information.
- Internal timing and control logic.

The test is organized into several phases controlled by a finite state machine. User responses are registered and processed to obtain the final result.

## Hardware Components

| Component | Description |
|---|---|
| FPGA Board | Digilent Basys 3 |
| FPGA Device | Xilinx Artix-7 XC7A35T-1CPG236 |
| Input Devices | Two 5-pin arcade joysticks |
| Video Output | VGA monitor |
| Audio Output | Mini speaker with driver circuit |
| Additional Inputs | Basys 3 switches and push buttons |
| Additional Output | Seven-segment display |

### FPGA Controls

| Control | Function |
|---|---|
| SW0 | Global reset |
| SW15 | Select psychotechnical test |
| BTNC | Start the test |
| BTNU | Register user reaction |

### Hardware Connections

The external peripherals are connected to the Basys 3 development board using its available interfaces.

- **Joysticks:** Connected through Pmod GPIO pins using internal pull-up configuration. Directional inputs are active-low.
- **VGA:** The FPGA generates RGB and horizontal/vertical synchronization signals.
- **Speaker:** Connected through an external driver circuit.
- **Power and logic:** The Pmod interfaces use 3.3 V LVCMOS33 logic levels, with a shared ground between the FPGA and external peripherals.

## System Architecture

The project is organized around three main functional modules:

**U_COORDINACION**

Implements the psychomotor coordination test, processing joystick inputs and generating the corresponding VGA output.

**U_ANTICIPACION**

Implements the temporal anticipation test, controlling timing, user responses, VGA output, and the seven-segment display.

**U_SELECTOR**

Selects the active test and manages the corresponding output signals.

### Finite State Machine (FSM)

The system uses state machines to control the execution sequence of the psychotechnical tests.

The main states and transitions manage:

1. Initial test selection.
2. Test initialization.
3. Test execution and timing.
4. User interaction and response registration.
5. Result display.
6. Reset or test switching.

This architecture separates the control logic from the individual test implementations.

## Technologies and Tools

- **VHDL:** Hardware description language.
- **AMD Vivado:** FPGA design, simulation, synthesis, and implementation.
- **FPGA:** Digilent Basys 3 (Xilinx Artix-7).
- **VGA:** Graphical output.
- **Finite State Machines:** Control of test execution and transitions.
- **Pmod GPIO:** Interfacing with external joystick controls.

## Repository Structure

- `Pruebas_Psicotecnico.srcs/` — VHDL source files and project constraints.
- `Pruebas_Psicotecnico.xpr` — Vivado project file.
- `Basys3_Master.xdc` — FPGA pin assignment and electrical constraints.
- `.gitignore` — Excludes unnecessary Vivado-generated files.
- `README.md` — Project documentation.

## Getting Started

1. Install AMD Vivado.
2. Clone or download this repository.
3. Open `Pruebas_Psicotecnico.xpr` in Vivado.
4. Check source file paths, constraints, and FPGA configuration.
5. Connect the external hardware according to the circuit diagram.
6. Generate the bitstream and program the Basys 3 FPGA.

## Project Team

This project was collaboratively developed by **three team members** as an educational FPGA prototype.

**Contributors:**
- Raúl Gonzalo Toapanta Paucar ()
- Alejandro Lalana Sáez
- Daniel De Nóbrega

All three team members are acknowledged for their participation in the project.

## Project Status

**Educational prototype**

This project demonstrates a basic hardware implementation of interactive psychotechnical tests. It is intended for educational and experimental purposes rather than professional psychometric assessment.

## Potential Improvements

- Improve the VGA graphical interface.
- Refine timing and response measurements.
- Optimize VHDL modules and hardware resource utilization.
- Add support for saving test results permanently
- Expand the system by implementing new psychotechnical tests