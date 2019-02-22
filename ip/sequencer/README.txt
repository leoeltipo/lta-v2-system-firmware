sequencer block:

* 02/22/2019: 
	Added funcionality to connect external clock for sequencer operation. Register signals are re-synced from/to AXI Clock to clk domains.
	Added register for stop source selection.
	Added external pin for stop control (for sync mode multi-board).

	Note on simulation: SystemVerilog testbench to allow using AXI VIP. For usage, right click on project and Add Design Sources->add the xci file of the AXI VIP. Right click on AXI VIP inside the project hierarchy->Generate output products. Now simulation can be run. Do not commit generated files in GIT!!!
