-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
-- Date        : Thu Nov  8 08:45:46 2018
-- Host        : CUTLASS running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode funcsim
--               c:/v18.2/lta-v1-system-firmware/ip/serial_io/src/sio1_2_clk_wiz_0_0/sio1_2_clk_wiz_0_0_sim_netlist.vhdl
-- Design      : sio1_2_clk_wiz_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a200tfbg484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity sio1_2_clk_wiz_0_0_sio1_2_clk_wiz_0_0_clk_wiz is
  port (
    clk_out1 : out STD_LOGIC;
    clk_out2_ce : in STD_LOGIC;
    clk_out2 : out STD_LOGIC;
    clk_out3 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of sio1_2_clk_wiz_0_0_sio1_2_clk_wiz_0_0_clk_wiz : entity is "sio1_2_clk_wiz_0_0_clk_wiz";
end sio1_2_clk_wiz_0_0_sio1_2_clk_wiz_0_0_clk_wiz;

architecture STRUCTURE of sio1_2_clk_wiz_0_0_sio1_2_clk_wiz_0_0_clk_wiz is
  signal clk_in1_sio1_2_clk_wiz_0_0 : STD_LOGIC;
  signal clk_out1_sio1_2_clk_wiz_0_0 : STD_LOGIC;
  signal clk_out2_sio1_2_clk_wiz_0_0 : STD_LOGIC;
  signal clk_out3_sio1_2_clk_wiz_0_0 : STD_LOGIC;
  signal clkfbout_buf_sio1_2_clk_wiz_0_0 : STD_LOGIC;
  signal clkfbout_sio1_2_clk_wiz_0_0 : STD_LOGIC;
  signal NLW_plle2_adv_inst_CLKOUT3_UNCONNECTED : STD_LOGIC;
  signal NLW_plle2_adv_inst_CLKOUT4_UNCONNECTED : STD_LOGIC;
  signal NLW_plle2_adv_inst_CLKOUT5_UNCONNECTED : STD_LOGIC;
  signal NLW_plle2_adv_inst_DRDY_UNCONNECTED : STD_LOGIC;
  signal NLW_plle2_adv_inst_DO_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of clkf_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of clkin1_bufg : label is "PRIMITIVE";
  attribute BOX_TYPE of clkout1_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of clkout2_buf : label is "PRIMITIVE";
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of clkout2_buf : label is "BUFGCE";
  attribute XILINX_TRANSFORM_PINMAP : string;
  attribute XILINX_TRANSFORM_PINMAP of clkout2_buf : label is "CE:CE0 I:I0";
  attribute BOX_TYPE of clkout3_buf : label is "PRIMITIVE";
  attribute BOX_TYPE of plle2_adv_inst : label is "PRIMITIVE";
begin
clkf_buf: unisim.vcomponents.BUFG
     port map (
      I => clkfbout_sio1_2_clk_wiz_0_0,
      O => clkfbout_buf_sio1_2_clk_wiz_0_0
    );
clkin1_bufg: unisim.vcomponents.BUFG
     port map (
      I => clk_in1,
      O => clk_in1_sio1_2_clk_wiz_0_0
    );
clkout1_buf: unisim.vcomponents.BUFG
     port map (
      I => clk_out1_sio1_2_clk_wiz_0_0,
      O => clk_out1
    );
clkout2_buf: unisim.vcomponents.BUFGCTRL
    generic map(
      INIT_OUT => 0,
      PRESELECT_I0 => true,
      PRESELECT_I1 => false
    )
        port map (
      CE0 => clk_out2_ce,
      CE1 => '0',
      I0 => clk_out2_sio1_2_clk_wiz_0_0,
      I1 => '1',
      IGNORE0 => '0',
      IGNORE1 => '1',
      O => clk_out2,
      S0 => '1',
      S1 => '0'
    );
clkout3_buf: unisim.vcomponents.BUFG
     port map (
      I => clk_out3_sio1_2_clk_wiz_0_0,
      O => clk_out3
    );
plle2_adv_inst: unisim.vcomponents.PLLE2_ADV
    generic map(
      BANDWIDTH => "OPTIMIZED",
      CLKFBOUT_MULT => 9,
      CLKFBOUT_PHASE => 0.000000,
      CLKIN1_PERIOD => 10.000000,
      CLKIN2_PERIOD => 0.000000,
      CLKOUT0_DIVIDE => 6,
      CLKOUT0_DUTY_CYCLE => 0.500000,
      CLKOUT0_PHASE => 0.000000,
      CLKOUT1_DIVIDE => 6,
      CLKOUT1_DUTY_CYCLE => 0.500000,
      CLKOUT1_PHASE => 0.000000,
      CLKOUT2_DIVIDE => 30,
      CLKOUT2_DUTY_CYCLE => 0.500000,
      CLKOUT2_PHASE => 0.000000,
      CLKOUT3_DIVIDE => 1,
      CLKOUT3_DUTY_CYCLE => 0.500000,
      CLKOUT3_PHASE => 0.000000,
      CLKOUT4_DIVIDE => 1,
      CLKOUT4_DUTY_CYCLE => 0.500000,
      CLKOUT4_PHASE => 0.000000,
      CLKOUT5_DIVIDE => 1,
      CLKOUT5_DUTY_CYCLE => 0.500000,
      CLKOUT5_PHASE => 0.000000,
      COMPENSATION => "BUF_IN",
      DIVCLK_DIVIDE => 1,
      IS_CLKINSEL_INVERTED => '0',
      IS_PWRDWN_INVERTED => '0',
      IS_RST_INVERTED => '0',
      REF_JITTER1 => 0.010000,
      REF_JITTER2 => 0.010000,
      STARTUP_WAIT => "FALSE"
    )
        port map (
      CLKFBIN => clkfbout_buf_sio1_2_clk_wiz_0_0,
      CLKFBOUT => clkfbout_sio1_2_clk_wiz_0_0,
      CLKIN1 => clk_in1_sio1_2_clk_wiz_0_0,
      CLKIN2 => '0',
      CLKINSEL => '1',
      CLKOUT0 => clk_out1_sio1_2_clk_wiz_0_0,
      CLKOUT1 => clk_out2_sio1_2_clk_wiz_0_0,
      CLKOUT2 => clk_out3_sio1_2_clk_wiz_0_0,
      CLKOUT3 => NLW_plle2_adv_inst_CLKOUT3_UNCONNECTED,
      CLKOUT4 => NLW_plle2_adv_inst_CLKOUT4_UNCONNECTED,
      CLKOUT5 => NLW_plle2_adv_inst_CLKOUT5_UNCONNECTED,
      DADDR(6 downto 0) => B"0000000",
      DCLK => '0',
      DEN => '0',
      DI(15 downto 0) => B"0000000000000000",
      DO(15 downto 0) => NLW_plle2_adv_inst_DO_UNCONNECTED(15 downto 0),
      DRDY => NLW_plle2_adv_inst_DRDY_UNCONNECTED,
      DWE => '0',
      LOCKED => locked,
      PWRDWN => '0',
      RST => reset
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity sio1_2_clk_wiz_0_0 is
  port (
    clk_out1 : out STD_LOGIC;
    clk_out2_ce : in STD_LOGIC;
    clk_out2 : out STD_LOGIC;
    clk_out3 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of sio1_2_clk_wiz_0_0 : entity is true;
end sio1_2_clk_wiz_0_0;

architecture STRUCTURE of sio1_2_clk_wiz_0_0 is
begin
inst: entity work.sio1_2_clk_wiz_0_0_sio1_2_clk_wiz_0_0_clk_wiz
     port map (
      clk_in1 => clk_in1,
      clk_out1 => clk_out1,
      clk_out2 => clk_out2,
      clk_out2_ce => clk_out2_ce,
      clk_out3 => clk_out3,
      locked => locked,
      reset => reset
    );
end STRUCTURE;
