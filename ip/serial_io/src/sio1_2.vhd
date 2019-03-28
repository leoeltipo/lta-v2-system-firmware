--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
--Date        : Wed Mar 27 16:25:39 2019
--Host        : L-LWL-120289 running 64-bit major release  (build 9200)
--Command     : generate_target sio1_2.bd
--Design      : sio1_2
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity sio1_2 is
  port (
    acquire : in STD_LOGIC;
    adc_clk_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    adc_clk_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    adc_cnvrt_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    adc_cnvrt_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    clk_100 : in STD_LOGIC;
    din_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    din_p : in STD_LOGIC_VECTOR ( 1 downto 0 );
    dout : out STD_LOGIC_VECTOR ( 17 downto 0 );
    dout_strobe : out STD_LOGIC;
    en_tst_ptrn : in STD_LOGIC;
    reset : in STD_LOGIC;
    send_bitslip : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of sio1_2 : entity is "sio1_2,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=sio1_2,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=13,numReposBlks=13,numNonXlnxBlks=3,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of sio1_2 : entity is "sio1_2.hwdef";
end sio1_2;

architecture STRUCTURE of sio1_2 is
  component sio1_2_axis_clock_converter_0_0 is
  port (
    s_axis_aresetn : in STD_LOGIC;
    m_axis_aresetn : in STD_LOGIC;
    s_axis_aclk : in STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 23 downto 0 );
    m_axis_aclk : in STD_LOGIC;
    m_axis_tvalid : out STD_LOGIC;
    m_axis_tready : in STD_LOGIC;
    m_axis_tdata : out STD_LOGIC_VECTOR ( 23 downto 0 )
  );
  end component sio1_2_axis_clock_converter_0_0;
  component sio1_2_bitslip_0_0 is
  port (
    master_reset : in STD_LOGIC;
    clk_1 : in STD_LOGIC;
    clk_3 : in STD_LOGIC;
    send_bitslip_0 : in STD_LOGIC;
    send_bitslip_1 : in STD_LOGIC;
    enable_test_pattern : in STD_LOGIC;
    check_test_pattern : in STD_LOGIC;
    sio_wiz_data_in : in STD_LOGIC_VECTOR ( 19 downto 0 );
    sio_wiz_bitslip : out STD_LOGIC_VECTOR ( 1 downto 0 );
    sio_wiz_data_out : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component sio1_2_bitslip_0_0;
  component sio1_2_clk_wiz_0_0 is
  port (
    reset : in STD_LOGIC;
    clk_in1 : in STD_LOGIC;
    clk_out1 : out STD_LOGIC;
    locked : out STD_LOGIC;
    clk_out2 : out STD_LOGIC;
    clk_out3 : out STD_LOGIC;
    clk_out2_ce : in STD_LOGIC
  );
  end component sio1_2_clk_wiz_0_0;
  component sio1_2_convert_0_0 is
  port (
    master_reset : in STD_LOGIC;
    clk_1 : in STD_LOGIC;
    clk_3 : in STD_LOGIC;
    acquire : in STD_LOGIC;
    readout_cycle : in STD_LOGIC;
    adc_convert : out STD_LOGIC;
    convert_done : out STD_LOGIC
  );
  end component sio1_2_convert_0_0;
  component sio1_2_proc_sys_reset_0_0 is
  port (
    slowest_sync_clk : in STD_LOGIC;
    ext_reset_in : in STD_LOGIC;
    aux_reset_in : in STD_LOGIC;
    mb_debug_sys_rst : in STD_LOGIC;
    dcm_locked : in STD_LOGIC;
    mb_reset : out STD_LOGIC;
    bus_struct_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    interconnect_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component sio1_2_proc_sys_reset_0_0;
  component sio1_2_proc_sys_reset_1_0 is
  port (
    slowest_sync_clk : in STD_LOGIC;
    ext_reset_in : in STD_LOGIC;
    aux_reset_in : in STD_LOGIC;
    mb_debug_sys_rst : in STD_LOGIC;
    dcm_locked : in STD_LOGIC;
    mb_reset : out STD_LOGIC;
    bus_struct_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    interconnect_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component sio1_2_proc_sys_reset_1_0;
  component sio1_2_readout_0_0 is
  port (
    master_reset : in STD_LOGIC;
    clk_1 : in STD_LOGIC;
    clk_3 : in STD_LOGIC;
    acquire : in STD_LOGIC;
    convert_done : in STD_LOGIC;
    adc_readout : out STD_LOGIC;
    sio_clk_enable : out STD_LOGIC;
    sio_wiz_dstrobe : out STD_LOGIC;
    clk_5_ce : out STD_LOGIC
  );
  end component sio1_2_readout_0_0;
  component sio1_2_selectio_wiz_0_0 is
  port (
    data_in_from_pins_p : in STD_LOGIC_VECTOR ( 1 downto 0 );
    data_in_from_pins_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    clk_in : in STD_LOGIC;
    clk_div_in : in STD_LOGIC;
    io_reset : in STD_LOGIC;
    bitslip : in STD_LOGIC_VECTOR ( 1 downto 0 );
    data_in_to_device : out STD_LOGIC_VECTOR ( 19 downto 0 )
  );
  end component sio1_2_selectio_wiz_0_0;
  component sio1_2_util_ds_buf_0_0 is
  port (
    OBUF_IN : in STD_LOGIC_VECTOR ( 0 to 0 );
    OBUF_DS_P : out STD_LOGIC_VECTOR ( 0 to 0 );
    OBUF_DS_N : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component sio1_2_util_ds_buf_0_0;
  component sio1_2_util_ds_buf_1_0 is
  port (
    OBUF_IN : in STD_LOGIC_VECTOR ( 0 to 0 );
    OBUF_DS_P : out STD_LOGIC_VECTOR ( 0 to 0 );
    OBUF_DS_N : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component sio1_2_util_ds_buf_1_0;
  component sio1_2_xlconcat_0_0 is
  port (
    In0 : in STD_LOGIC_VECTOR ( 17 downto 0 );
    In1 : in STD_LOGIC_VECTOR ( 5 downto 0 );
    dout : out STD_LOGIC_VECTOR ( 23 downto 0 )
  );
  end component sio1_2_xlconcat_0_0;
  component sio1_2_xlconstant_0_0 is
  port (
    dout : out STD_LOGIC_VECTOR ( 5 downto 0 )
  );
  end component sio1_2_xlconstant_0_0;
  component sio1_2_xlslice_0_0 is
  port (
    Din : in STD_LOGIC_VECTOR ( 23 downto 0 );
    Dout : out STD_LOGIC_VECTOR ( 17 downto 0 )
  );
  end component sio1_2_xlslice_0_0;
  signal acquire_1 : STD_LOGIC;
  signal axis_clock_converter_0_m_axis_tdata : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal axis_clock_converter_0_m_axis_tvalid : STD_LOGIC;
  signal bitslip_0_sio_wiz_bitslip : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal bitslip_0_sio_wiz_data_out : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal clk_in1_1 : STD_LOGIC;
  signal clk_wiz_0_clk_out1 : STD_LOGIC;
  signal clk_wiz_0_clk_out2 : STD_LOGIC;
  signal clk_wiz_0_clk_out3 : STD_LOGIC;
  signal clk_wiz_0_locked : STD_LOGIC;
  signal convert_0_adc_convert : STD_LOGIC;
  signal convert_0_convert_done : STD_LOGIC;
  signal data_in_from_pins_n_1 : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal data_in_from_pins_p_1 : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal enable_test_pattern_1 : STD_LOGIC;
  signal proc_sys_reset_0_peripheral_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
  signal proc_sys_reset_0_peripheral_reset : STD_LOGIC_VECTOR ( 0 to 0 );
  signal proc_sys_reset_1_peripheral_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
  signal proc_sys_reset_1_peripheral_reset : STD_LOGIC_VECTOR ( 0 to 0 );
  signal readout_0_adc_readout : STD_LOGIC;
  signal readout_0_clk_5_ce : STD_LOGIC;
  signal readout_1_0_sio_wiz_dstrobe : STD_LOGIC;
  signal reset_1 : STD_LOGIC;
  signal selectio_wiz_0_data_in_to_device : STD_LOGIC_VECTOR ( 19 downto 0 );
  signal send_bitslip_0_1 : STD_LOGIC;
  signal util_ds_buf_0_OBUF_DS_N : STD_LOGIC_VECTOR ( 0 to 0 );
  signal util_ds_buf_0_OBUF_DS_P : STD_LOGIC_VECTOR ( 0 to 0 );
  signal util_ds_buf_1_OBUF_DS_N : STD_LOGIC_VECTOR ( 0 to 0 );
  signal util_ds_buf_1_OBUF_DS_P : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xlconcat_0_dout : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal xlconstant_0_dout : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal xlslice_0_Dout : STD_LOGIC_VECTOR ( 17 downto 0 );
  signal NLW_axis_clock_converter_0_s_axis_tready_UNCONNECTED : STD_LOGIC;
  signal NLW_proc_sys_reset_0_mb_reset_UNCONNECTED : STD_LOGIC;
  signal NLW_proc_sys_reset_0_bus_struct_reset_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_proc_sys_reset_0_interconnect_aresetn_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_proc_sys_reset_1_mb_reset_UNCONNECTED : STD_LOGIC;
  signal NLW_proc_sys_reset_1_bus_struct_reset_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_proc_sys_reset_1_interconnect_aresetn_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_readout_0_sio_clk_enable_UNCONNECTED : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk_100 : signal is "xilinx.com:signal:clock:1.0 CLK.CLK_100 CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk_100 : signal is "XIL_INTERFACENAME CLK.CLK_100, CLK_DOMAIN sio1_2_clk_100, FREQ_HZ 100000000, PHASE 0.000";
  attribute X_INTERFACE_INFO of reset : signal is "xilinx.com:signal:reset:1.0 RST.RESET RST";
  attribute X_INTERFACE_PARAMETER of reset : signal is "XIL_INTERFACENAME RST.RESET, POLARITY ACTIVE_HIGH";
  attribute X_INTERFACE_INFO of adc_clk_n : signal is "xilinx.com:signal:clock:1.0 CLK.ADC_CLK_N CLK";
  attribute X_INTERFACE_PARAMETER of adc_clk_n : signal is "XIL_INTERFACENAME CLK.ADC_CLK_N, CLK_DOMAIN /clk_wiz_0_clk_out1, FREQ_HZ 150000000, PHASE 0.0";
  attribute X_INTERFACE_INFO of adc_clk_p : signal is "xilinx.com:signal:clock:1.0 CLK.ADC_CLK_P CLK";
  attribute X_INTERFACE_PARAMETER of adc_clk_p : signal is "XIL_INTERFACENAME CLK.ADC_CLK_P, CLK_DOMAIN /clk_wiz_0_clk_out1, FREQ_HZ 150000000, PHASE 0.0";
  attribute X_INTERFACE_INFO of adc_cnvrt_n : signal is "xilinx.com:signal:clock:1.0 CLK.ADC_CNVRT_N CLK";
  attribute X_INTERFACE_PARAMETER of adc_cnvrt_n : signal is "XIL_INTERFACENAME CLK.ADC_CNVRT_N, CLK_DOMAIN sio1_2_util_ds_buf_1_0_OBUF_DS_N, FREQ_HZ 100000000, PHASE 0.000";
  attribute X_INTERFACE_INFO of adc_cnvrt_p : signal is "xilinx.com:signal:clock:1.0 CLK.ADC_CNVRT_P CLK";
  attribute X_INTERFACE_PARAMETER of adc_cnvrt_p : signal is "XIL_INTERFACENAME CLK.ADC_CNVRT_P, CLK_DOMAIN sio1_2_util_ds_buf_1_0_OBUF_DS_P, FREQ_HZ 100000000, PHASE 0.000";
begin
  acquire_1 <= acquire;
  adc_clk_n(0) <= util_ds_buf_0_OBUF_DS_N(0);
  adc_clk_p(0) <= util_ds_buf_0_OBUF_DS_P(0);
  adc_cnvrt_n(0) <= util_ds_buf_1_OBUF_DS_N(0);
  adc_cnvrt_p(0) <= util_ds_buf_1_OBUF_DS_P(0);
  clk_in1_1 <= clk_100;
  data_in_from_pins_n_1(1 downto 0) <= din_n(1 downto 0);
  data_in_from_pins_p_1(1 downto 0) <= din_p(1 downto 0);
  dout(17 downto 0) <= xlslice_0_Dout(17 downto 0);
  dout_strobe <= axis_clock_converter_0_m_axis_tvalid;
  enable_test_pattern_1 <= en_tst_ptrn;
  reset_1 <= reset;
  send_bitslip_0_1 <= send_bitslip;
axis_clock_converter_0: component sio1_2_axis_clock_converter_0_0
     port map (
      m_axis_aclk => clk_in1_1,
      m_axis_aresetn => proc_sys_reset_1_peripheral_aresetn(0),
      m_axis_tdata(23 downto 0) => axis_clock_converter_0_m_axis_tdata(23 downto 0),
      m_axis_tready => '1',
      m_axis_tvalid => axis_clock_converter_0_m_axis_tvalid,
      s_axis_aclk => clk_wiz_0_clk_out1,
      s_axis_aresetn => proc_sys_reset_0_peripheral_aresetn(0),
      s_axis_tdata(23 downto 0) => xlconcat_0_dout(23 downto 0),
      s_axis_tready => NLW_axis_clock_converter_0_s_axis_tready_UNCONNECTED,
      s_axis_tvalid => readout_1_0_sio_wiz_dstrobe
    );
bitslip_0: component sio1_2_bitslip_0_0
     port map (
      check_test_pattern => readout_1_0_sio_wiz_dstrobe,
      clk_1 => clk_wiz_0_clk_out1,
      clk_3 => clk_wiz_0_clk_out3,
      enable_test_pattern => enable_test_pattern_1,
      master_reset => proc_sys_reset_0_peripheral_reset(0),
      send_bitslip_0 => send_bitslip_0_1,
      send_bitslip_1 => send_bitslip_0_1,
      sio_wiz_bitslip(1 downto 0) => bitslip_0_sio_wiz_bitslip(1 downto 0),
      sio_wiz_data_in(19 downto 0) => selectio_wiz_0_data_in_to_device(19 downto 0),
      sio_wiz_data_out(17 downto 0) => bitslip_0_sio_wiz_data_out(17 downto 0)
    );
clk_wiz_0: component sio1_2_clk_wiz_0_0
     port map (
      clk_in1 => clk_in1_1,
      clk_out1 => clk_wiz_0_clk_out1,
      clk_out2 => clk_wiz_0_clk_out2,
      clk_out2_ce => readout_0_clk_5_ce,
      clk_out3 => clk_wiz_0_clk_out3,
      locked => clk_wiz_0_locked,
      reset => reset_1
    );
convert_0: component sio1_2_convert_0_0
     port map (
      acquire => acquire_1,
      adc_convert => convert_0_adc_convert,
      clk_1 => clk_wiz_0_clk_out1,
      clk_3 => clk_wiz_0_clk_out3,
      convert_done => convert_0_convert_done,
      master_reset => proc_sys_reset_0_peripheral_reset(0),
      readout_cycle => readout_0_adc_readout
    );
proc_sys_reset_0: component sio1_2_proc_sys_reset_0_0
     port map (
      aux_reset_in => '1',
      bus_struct_reset(0) => NLW_proc_sys_reset_0_bus_struct_reset_UNCONNECTED(0),
      dcm_locked => clk_wiz_0_locked,
      ext_reset_in => reset_1,
      interconnect_aresetn(0) => NLW_proc_sys_reset_0_interconnect_aresetn_UNCONNECTED(0),
      mb_debug_sys_rst => '0',
      mb_reset => NLW_proc_sys_reset_0_mb_reset_UNCONNECTED,
      peripheral_aresetn(0) => proc_sys_reset_0_peripheral_aresetn(0),
      peripheral_reset(0) => proc_sys_reset_0_peripheral_reset(0),
      slowest_sync_clk => clk_wiz_0_clk_out1
    );
proc_sys_reset_1: component sio1_2_proc_sys_reset_1_0
     port map (
      aux_reset_in => '1',
      bus_struct_reset(0) => NLW_proc_sys_reset_1_bus_struct_reset_UNCONNECTED(0),
      dcm_locked => clk_wiz_0_locked,
      ext_reset_in => reset_1,
      interconnect_aresetn(0) => NLW_proc_sys_reset_1_interconnect_aresetn_UNCONNECTED(0),
      mb_debug_sys_rst => '0',
      mb_reset => NLW_proc_sys_reset_1_mb_reset_UNCONNECTED,
      peripheral_aresetn(0) => proc_sys_reset_1_peripheral_aresetn(0),
      peripheral_reset(0) => proc_sys_reset_1_peripheral_reset(0),
      slowest_sync_clk => clk_wiz_0_clk_out1
    );
readout_0: component sio1_2_readout_0_0
     port map (
      acquire => acquire_1,
      adc_readout => readout_0_adc_readout,
      clk_1 => clk_wiz_0_clk_out1,
      clk_3 => clk_wiz_0_clk_out3,
      clk_5_ce => readout_0_clk_5_ce,
      convert_done => convert_0_convert_done,
      master_reset => proc_sys_reset_0_peripheral_reset(0),
      sio_clk_enable => NLW_readout_0_sio_clk_enable_UNCONNECTED,
      sio_wiz_dstrobe => readout_1_0_sio_wiz_dstrobe
    );
selectio_wiz_0: component sio1_2_selectio_wiz_0_0
     port map (
      bitslip(1 downto 0) => bitslip_0_sio_wiz_bitslip(1 downto 0),
      clk_div_in => clk_wiz_0_clk_out3,
      clk_in => clk_wiz_0_clk_out1,
      data_in_from_pins_n(1 downto 0) => data_in_from_pins_n_1(1 downto 0),
      data_in_from_pins_p(1 downto 0) => data_in_from_pins_p_1(1 downto 0),
      data_in_to_device(19 downto 0) => selectio_wiz_0_data_in_to_device(19 downto 0),
      io_reset => proc_sys_reset_1_peripheral_reset(0)
    );
util_ds_buf_0: component sio1_2_util_ds_buf_0_0
     port map (
      OBUF_DS_N(0) => util_ds_buf_0_OBUF_DS_N(0),
      OBUF_DS_P(0) => util_ds_buf_0_OBUF_DS_P(0),
      OBUF_IN(0) => clk_wiz_0_clk_out2
    );
util_ds_buf_1: component sio1_2_util_ds_buf_1_0
     port map (
      OBUF_DS_N(0) => util_ds_buf_1_OBUF_DS_N(0),
      OBUF_DS_P(0) => util_ds_buf_1_OBUF_DS_P(0),
      OBUF_IN(0) => convert_0_adc_convert
    );
xlconcat_0: component sio1_2_xlconcat_0_0
     port map (
      In0(17 downto 0) => bitslip_0_sio_wiz_data_out(17 downto 0),
      In1(5 downto 0) => xlconstant_0_dout(5 downto 0),
      dout(23 downto 0) => xlconcat_0_dout(23 downto 0)
    );
xlconstant_0: component sio1_2_xlconstant_0_0
     port map (
      dout(5 downto 0) => xlconstant_0_dout(5 downto 0)
    );
xlslice_0: component sio1_2_xlslice_0_0
     port map (
      Din(23 downto 0) => axis_clock_converter_0_m_axis_tdata(23 downto 0),
      Dout(17 downto 0) => xlslice_0_Dout(17 downto 0)
    );
end STRUCTURE;
