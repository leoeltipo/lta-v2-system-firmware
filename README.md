# lta-v2-system-firmware
Firmware part to control the second version of the LTA board.

Version including:
* Ethernet block: used for sending/receiving control packets and sending data packets.
* Interrupt controller: used for generating 1ms INT time base.
* USB-UART: allows hot-plug for controlling the board (works always).
* Flash memory: used for storing board information and unique ID.
* LEDS for board state monitoring.
* EXEC function catalog.
* ADC controller for 15 MSPS fixed frequency.
* Packer for selecting data source transferred to PC with Ethernet block.
* Non-causal CDS block with buffer to allow integrating from middle point backwards and forward.
* Sequencer using downsized version of processor with minimum instruction set.
* Telemetry block for monitoring real-time voltages on board.
* LDOs controller for configuring bias voltages.
* DAC controller for setting low and high voltages of clock signals.
* Voltage switch controller for allowing enable/disable of bias voltages to 50-pin connector.
* Smart Buffer: fixed block with 64 KSamples of memory (total).

After configuring from FLASH, the microblaze software will read the board information from the flash memory. The IP address is part of that information, so the board will reconfigure the IP before starting the booting process. Switch 0 is also checked to decide if the system should enter on flash programming state. 
