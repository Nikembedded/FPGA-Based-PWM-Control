**Project Overview**
This project is built on Lattice Diamond and demonstrates a digital system consisting of multiple components that work together to control a PWM output signal. The system features a sequencer that modulates the PWM signal in specific patterns, a clock generator, and other interconnected modules.

**Key Features:**

Sequenced PWM Control: Dynamically adjusts duty cycles.
Custom Clock Generation: Produces multiple clock frequencies.
Modular Design: Includes distinct components for reusability.

**Component Descriptions**

1. Clock Module
File: clock.vhdl

Purpose: Generates two clock signals, CLK_1k (1 kHz) and CLK_2k (2 kHz), from an input clock.
How it works:
Uses counters (SAMPLER1 and SAMPLER2) that decrement on each rising edge of the input clock.
When the counters reach zero, the respective clock output toggles and the counters are reset to their initial reload values (RELOAD1, RELOAD2).

2. PWM Module
File: pwm.vhdl

Purpose: Generates a pulse-width modulation (PWM) signal based on a comparison (CMP) value.
How it works:
A counter increments on every clock cycle (iCLK_2KHz).
The output (PWM_out) is high ('1') if the counter value is less than CMP, and low ('0') otherwise.
The duty cycle is directly proportional to the CMP value.

3. Sequencer Module
File: SEQUENCER.vhdl

Purpose: Controls the behavior of the PWM signal over time by managing CMP values and transitioning through different operational states.
States:
IDLE: System is inactive, CMP is 0.
RAMPUP: Gradually increases CMP to ramp up the PWM duty cycle.
RUN: Maintains CMP at maximum for a fixed duration.
RAMPDN: Gradually decreases CMP to ramp down the PWM duty cycle.
STOP: Resets CMP to 0 and switches the direction of modulation (CMP_DIRECTION).
Timers: Utilizes counters (CLK_TIMER and SAMPLES_COUNTER) to manage state durations and sampling rates.

4. Top-Level Module
File: top.vhdl

Purpose: Integrates all modules to implement the full system.
Connections:
The clock module provides CLK_1k and CLK_2k signals.
The SEQUENCER module calculates CMP values and determines modulation direction (CMP_DIRECTION).
The pwm module uses CMP and CLK_2k to generate the PWM signal.
Outputs:
PWM_OUT: PWM signal modulated by CMP_DIRECTION.
PWM_2OUT: Complementary PWM signal.
Functionality
The system starts in IDLE state.
Progresses through a sequence of ramping up, running at full duty cycle, ramping down, and stopping.
The duty cycle of the PWM signal changes dynamically during operation based on the sequencer's state.
Build Details
Toolchain: Lattice Diamond
Simulation: Test the behavior using waveforms to verify proper state transitions and PWM output.
Target Device: Suitable for Lattice FPGAs, but portable to other FPGA families.
Usage
Compile the project in Lattice Diamond.
Connect a clock input (CLK) and reset (RESET_SWITCH) to the FPGA.
Observe the PWM output on PWM_OUT and PWM_2OUT.
