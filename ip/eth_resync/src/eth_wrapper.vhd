----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2017 19:22:13
-- Design Name: 
-- Module Name: eth_wrapper - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity eth_wrapper is
port ( 
		PHY_RXCLK      : in    std_logic; 
		PHY_RXCTL_RXDV : in    std_logic; 
        PHY_RXD0	: in    std_logic; 
        PHY_RXD1	: in    std_logic; 
        PHY_RXD2	: in    std_logic; 
        PHY_RXD3	: in    std_logic; 
        PHY_RXD4	: in    std_logic; 
        PHY_RXD5	: in    std_logic; 
        PHY_RXD6	: in    std_logic; 
        PHY_RXD7	: in    std_logic; 
		  
		--PHY_RXER     : in    std_logic; 
		--USER_CLOCK   : in    std_logic; 
          
	--PHY_RESET	: out    std_logic; -- not needed in CCD_DAQ board
		
		PHY_TXCTL_TXEN : out   std_logic; 
        PHY_TXD0	: out   std_logic; 
        PHY_TXD1	: out   std_logic; 
        PHY_TXD2	: out   std_logic; 
        PHY_TXD3	: out   std_logic;
        PHY_TXD4	: out   std_logic; 
        PHY_TXD5	: out   std_logic; 
        PHY_TXD6	: out   std_logic; 
        PHY_TXD7	: out   std_logic; 
        PHY_TXER	: out   std_logic;
                              
        PHY_TXC_GTXCLK : out   std_logic;
          --user interface
        b_data		: in	std_logic_vector(63 downto 0);
        b_data_we	: in 	std_logic;
--        reset_in=>reset_btn,
--        reset_out => reset,
 	    tx_data_user		: in 	std_logic_vector(31 downto 0);
--        b_enable=>open,

        -- Added to allow setting IP from port.
        user_addr				: in    std_logic_vector (7 downto 0);
 	
        rx_addr_user		:out 	std_logic_vector(31 downto 0);
        rx_data_user		:out 	std_logic_vector(63 downto 0);
        rx_wren_user		:out 	std_logic_vector(3 downto 0);
        clk_125_out         :out    std_logic
              
          );
end eth_wrapper;

architecture Behavioral of eth_wrapper is

    
    attribute BOX_TYPE     : string ;
    attribute IOSTANDARD   : string ;
    attribute CAPACITANCE  : string ;
    attribute SLEW         : string ;
    attribute DRIVE        : string ;
    attribute IBUF_LOW_PWR : string ;
    
--    signal b_data                   : std_logic_vector (63 downto 0);
--    signal b_data_we                : std_logic;
    signal GMII_RXD_0_sig           : std_logic_vector (7 downto 0);
    signal GMII_RX_DV_0_sig         : std_logic;
    signal GMII_RX_ER_0_sig         : std_logic;
    signal GTX_CLK_0_sig            : std_logic;
    signal MASTER_CLK               : std_logic;
    signal CLK15NS, CLK15NS_sig     : std_logic;                                   
   
    signal gec_mac, gec_user_src_mac       : std_logic_vector (47 downto 0);
    signal gec_port, gec_user_src_port     : std_logic_vector (15 downto 0);
    signal gec_addrs, gec_user_src_addrs   : std_logic_vector (7 downto 0); 
    
    signal gec_user_src_capture                  : std_logic;    
    
    signal reset_btn : std_logic;
    signal gnd : std_logic;
   
    
    signal PHY_TXD_sig              : std_logic_vector (7 downto 0);
    signal PHY_TXEN_sig             : std_logic;
    signal PHY_TXER_sig             : std_logic;
    signal psi_status               : std_logic_vector (63 downto 0);
    signal reset                    : std_logic;
    signal reset_n                  : std_logic;
    signal rx_addr                  : std_logic_vector (31 downto 0);
    signal rx_data                  : std_logic_vector (63 downto 0);
    signal rx_wren                  : std_logic;
    signal secondary_clk, secondary_clk_sig       : std_logic;
    signal tx_data                  : std_logic_vector (63 downto 0);
    
    signal wea_connector            : STD_LOGIC_VECTOR(0 DOWNTO 0);
    
    signal wea_bus                  :std_logic_vector(3 downto 0);
    signal web_bus                  :std_logic_vector(3 downto 0);
    
    signal addrb_signal             : std_logic_vector(12 downto 0):= "0000000000000";
    signal dinb_signal              : std_logic_vector(31 downto 0) := x"00000000";
    signal doutb_signal              : std_logic_vector(31 downto 0);
    
    
    signal b_data_signal		:std_logic_vector(63 downto 0);
    signal b_data_we_signal    :std_logic;
    --        reset_in=>reset_btn,
    --        reset_out => reset,
    signal tx_data_user_signal        :std_logic_vector(63 downto 0);
    --        b_enable=>open,
    
    signal rx_addr_user_signal        :std_logic_vector(31 downto 0);
    signal rx_data_user_signal        :std_logic_vector(63 downto 0);
    signal rx_wren_user_signal        :std_logic_vector(3 downto 0);

     
     
   
    attribute mark_debug : string;
    attribute mark_debug of MASTER_CLK : signal is "true";
    attribute mark_debug of secondary_clk : signal is "true";
    attribute mark_debug of PHY_TXD_sig : signal is "true";
    attribute mark_debug of PHY_TXEN_sig : signal is "true";
    attribute mark_debug of rx_wren : signal is "true";
    attribute mark_debug of CLK15NS : signal is "true";
    

    attribute mark_debug of rx_addr : signal is "true";
    attribute mark_debug of tx_data : signal is "true";
    attribute mark_debug of rx_data : signal is "true";
    attribute mark_debug of b_data : signal is "true";
    attribute mark_debug of b_data_we : signal is "true";
    
	--    attribute mark_debug of GMII_RXD_0_sig : signal is "true";
	--    attribute mark_debug of GMII_RX_DV_0_sig : signal is "true";
       
   
   
   component OBUF
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute IOSTANDARD of OBUF : component is "DEFAULT";
   attribute CAPACITANCE of OBUF : component is "DONT_CARE";
   attribute SLEW of OBUF : component is "SLOW";
   attribute DRIVE of OBUF : component is "12";
   attribute BOX_TYPE of OBUF : component is "BLACK_BOX";
   
   component IBUF
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute IOSTANDARD of IBUF : component is "DEFAULT";
   attribute CAPACITANCE of IBUF : component is "DONT_CARE";
   attribute BOX_TYPE of IBUF : component is "BLACK_BOX";
   
   component IBUFG
      -- synopsys translate_off
      generic( IBUF_LOW_PWR : boolean :=  TRUE);
      -- synopsys translate_on
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute IOSTANDARD of IBUFG : component is "DEFAULT";
   attribute CAPACITANCE of IBUFG : component is "DONT_CARE";
   attribute IBUF_LOW_PWR of IBUFG : component is "TRUE";
   attribute BOX_TYPE of IBUFG : component is "BLACK_BOX";
     
   
   component BUFG
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute BOX_TYPE of BUFG : component is "BLACK_BOX";
   
   component reset_mgr
      port ( slow_clk    : in    std_logic; 
             reset_start : in    std_logic; 
             reset       : out   std_logic);
   end component;
   
   component dist_mem_gen_0 
         PORT (
           a : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
           d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           clk : IN STD_LOGIC;
           we : IN STD_LOGIC;
           spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
         );
   end component;
   
   
   component blk_mem_gen_0 
     PORT (
            clka : IN STD_LOGIC;
--         rsta : IN STD_LOGIC;
--         ena : IN STD_LOGIC;
         wea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
         addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
         dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
         douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
         clkb : IN STD_LOGIC;
--         rstb : IN STD_LOGIC;
--         enb : IN STD_LOGIC;
         web : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
         addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
         dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
         doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
     );
   end component; 
   
   
begin
   
	gnd <= '0';
    
	reset_n <= not reset;
	reset_btn <= '0';
	
	  --user interface
    b_data_signal <= b_data;
    b_data_we_signal <= b_data_we;
    --        reset_in=>reset_btn,
    --        reset_out => reset,
    tx_data_user_signal <= rx_addr_user_signal & tx_data_user;
    --        b_enable=>open,
    
    rx_addr_user <= rx_addr_user_signal (29 downto 0) & "00"; -- to addressing per byte from uBlaze
    rx_data_user <= rx_data_user_signal;
    rx_wren_user <= rx_wren_user_signal;
    clk_125_out  <= MASTER_CLK;
	
	
	

	--	reset_ibuf : IBUF       -- SW3 on board is active high
	--     port map (I=>GPIO_SW_W,  O=>reset_btn);
	--   user_led1: OBUF   -- LED display of RESET
	--      port map (I=>reset,    O=>PZ_ULED_1);        
      
   
	-- start simple OEI
	eth_interface : entity work.Ethernet_Interface
	  port map (b_data(63 downto 0)=>b_data_signal(63 downto 0),
				b_data_we=>b_data_we_signal,
				PHY_RXD(7 downto 0)=>GMII_RXD_0_sig(7 downto 0),
				PHY_RX_DV=>GMII_RX_DV_0_sig,
				PHY_RX_ER=>GMII_RX_ER_0_sig,
				MASTER_CLK=>MASTER_CLK,                
				reset_in=>reset_btn,
				reset_out => reset,
				tx_data(63 downto 0)=>tx_data_user_signal(63 downto 0),
				b_enable=>open,
				TX_CLK=>GTX_CLK_0_sig,
				PHY_TXD(7 downto 0)=>PHY_TXD_sig(7 downto 0),
				PHY_TX_EN=>PHY_TXEN_sig,
				PHY_TX_ER=>PHY_TXER_sig,
				rx_addr(31 downto 0)=>rx_addr_user_signal(31 downto 0),
				rx_data(63 downto 0)=>rx_data_user_signal(63 downto 0),
				rx_wren=>rx_wren,
				user_addr=>user_addr);
					 
	-- end simple OEI
	
	

     
   

	-- start data gen block
--   dataGenGen : for i in 0 to 0 generate
--		signal reg_cnt : unsigned(63 downto 0) := (others => '0'); -- 1s is infinite
--		signal reg_rate : unsigned(63 downto 0) := (others => '0');  -- delay between 8 clock periods
		
--		signal cnt : unsigned(2 downto 0) := (others => '0');
--		signal delay_cnt : unsigned(63 downto 0) := (others => '0');
--		signal data_cnt : unsigned(31 downto 0) := (others => '0');

--        attribute mark_debug of reg_cnt : signal is "true";
--        attribute mark_debug of reg_rate : signal is "true";
--        attribute mark_debug of cnt : signal is "true";
--        attribute mark_debug of delay_cnt : signal is "true";
--        attribute mark_debug of data_cnt : signal is "true";
--	begin
--		process(MASTER_CLK)
--		begin
--			if (rising_edge(MASTER_CLK)) then
				
--				b_data_we <= '0';
				
--				-- register map
--				if (rx_wren = '1') then 	
--					if (unsigned(rx_addr) = x"1001") then --reg_cnt
--						reg_cnt <= unsigned(rx_data); 
--					elsif (unsigned(rx_addr) = x"1002") then --reg_rate
--						reg_rate <= unsigned(rx_data); 						
--					end if;
--					delay_cnt <= (others => '0'); --reset delay and execute burst write
--				else
				
--					cnt <= cnt + 1; 
--					if (cnt = 0) then	--count groups of 8 with wrap around
--						delay_cnt <= delay_cnt + 1;
						
--						if (delay_cnt = reg_rate and reg_cnt /= 0) then
--							delay_cnt <= (others => '0'); --reset delay and execute burst write
--							b_data(63 downto 32) <= std_logic_vector(data_cnt);
--							b_data(31 downto 0) <= tx_data(31 downto 0); -- last saved write
--							b_data_we <= '1';
--							data_cnt <= data_cnt + 1;
							
--							if ( and_reduce(std_logic_vector(reg_cnt)) /= '1' ) then --count down pulses, if not infinite
--								reg_cnt <= reg_cnt - 1;
--							end if;
--						end if;
--					end if;
--				end if;
--			end if;
				
		
--		end process;
		
	
	
--	end generate;	
	-- end data gen block
   
   
--   makeSlowClock : for i in 0 to 0 generate
--        signal cnt : unsigned(4 downto 0) := (others => '0');
--   begin
--        secondary_clk_sig <= cnt(4); -- 32 times slower clock than MASTER_CLK 
--        CLK15NS_sig <= cnt(0); -- 2 times slower clock than MASTER_CLK
--        process(MASTER_CLK)
--        begin
--            if (rising_edge(MASTER_CLK)) then
--                cnt <= cnt + 1;        
--            end if;
--        end process;   
--   end generate;
   
--   CLK5MHz_bufg : BUFG
--      port map (I=>secondary_clk_sig,  O=>secondary_clk);
      
--   CLK15NS_bufg : BUFG
--    port map (I=>CLK15NS_sig,  O=>CLK15NS);
      
--    -- tx_data for reads.. rx_address(31:0) | rx_data(31:0) 
--    tx_data(63 downto 32) <= rx_addr(31 downto 0);  
--    process(MASTER_CLK)
--    begin
--        if (rising_edge(MASTER_CLK) and rx_wren='1') then
--			--tx_data(15 downto 0) <= rx_data(15 downto 0); 
--        end if;    
--    end process;  
    
--    process(CLK15NS)
--    begin
--		if (rising_edge(CLK15NS)) then
--			--tx_data(31 downto 24) <= std_logic_vector(unsigned(tx_data(31 downto 24)) + 1); 
--		end if;    
--    end process;  
    
--    process(secondary_clk)
--    begin
--		if (rising_edge(secondary_clk)) then
--			--tx_data(23 downto 16) <= std_logic_vector(unsigned(tx_data(23 downto 16)) + 1); 
--		end if;    
--    end process;
    
    
--    memram : dist_mem_gen_0
--        port map(
--        a => rx_addr(8 downto 0),
--        d => rx_data(31 downto 0),
--        clk => MASTER_CLK,
--        we => rx_wren,
--        spo => tx_data (31 downto 0)
--        );
        
    
    
    rx_wren_user_signal(0) <= rx_wren;
    rx_wren_user_signal(1) <= rx_wren;    
    rx_wren_user_signal(2) <= rx_wren;
    rx_wren_user_signal(3) <= rx_wren;
    
    
              
--           memram_1 : blk_mem_gen_0 
--              port map (
--                    clka => MASTER_CLK,
--                    wea => wea_bus,
--                    addra => rx_addr(12 DOWNTO 0),
--                    dina => rx_data(31 DOWNTO 0),
--                    douta => tx_data(31 DOWNTO 0),
--                    clkb => MASTER_CLK,
--                    web => web_bus,
--                    addrb => addrb_signal(12 downto 0),
--                    dinb => dinb_signal,
--                    doutb => doutb_signal
--              );
   
        
   
    -----------------------
    ----------------------- IBUF 's 
    
     IBUF_PHY_RXDV : IBUF       port map (I=>PHY_RXCTL_RXDV,  O=>GMII_RX_DV_0_sig);
      
--removed by script (others => '0'); -- for RGMII or SGMII
     
	IBUF_PHY_RXD7 : IBUF        port map (I=>PHY_RXD7, O=>GMII_RXD_0_sig(7));	  
	IBUF_PHY_RXD6 : IBUF        port map (I=>PHY_RXD6, O=>GMII_RXD_0_sig(6));	  
	IBUF_PHY_RXD5 : IBUF        port map (I=>PHY_RXD5, O=>GMII_RXD_0_sig(5)); 	  
	IBUF_PHY_RXD4 : IBUF        port map (I=>PHY_RXD4, O=>GMII_RXD_0_sig(4));
	IBUF_PHY_RXD3 : IBUF        port map (I=>PHY_RXD3, O=>GMII_RXD_0_sig(3));
	IBUF_PHY_RXD2 : IBUF        port map (I=>PHY_RXD2, O=>GMII_RXD_0_sig(2));
	IBUF_PHY_RXD1 : IBUF        port map (I=>PHY_RXD1, O=>GMII_RXD_0_sig(1));
	IBUF_PHY_RXD0 : IBUF        port map (I=>PHY_RXD0, O=>GMII_RXD_0_sig(0));   
     
     GMII_RX_ER_0_sig <= '0';
     
     IBUF_PHY_RXCLK : BUFG      port map (I=>PHY_RXCLK,  O=>MASTER_CLK);
        
    -----------------------
    ----------------------- OBUF 's 
    	 
	--OBUF_PHY_RESET : OBUF	   port map (I=>'1',  O=>PHY_RESET); --hold not reset --not needed in CCD_DQA board
		 
	OBUF_PHY_TXER : OBUF       port map (I=>PHY_TXER_sig,  O=>PHY_TXER);
	 
    OBUF_PHY_TXEN : OBUF       port map (I=>PHY_TXEN_sig,  O=>PHY_TXCTL_TXEN);
    
    OBUF_PHY_TXCLK : OBUF      port map (I=>GTX_CLK_0_sig, O=>PHY_TXC_GTXCLK);
    
	OBUF_PHY_TXD7 : OBUF   	   port map (I=>PHY_TXD_sig(7), O=>PHY_TXD7);    
	OBUF_PHY_TXD6 : OBUF       port map (I=>PHY_TXD_sig(6), O=>PHY_TXD6);    
	OBUF_PHY_TXD5 : OBUF       port map (I=>PHY_TXD_sig(5), O=>PHY_TXD5);    
	OBUF_PHY_TXD4 : OBUF       port map (I=>PHY_TXD_sig(4), O=>PHY_TXD4);    
	OBUF_PHY_TXD3 : OBUF       port map (I=>PHY_TXD_sig(3), O=>PHY_TXD3);    
	OBUF_PHY_TXD2 : OBUF       port map (I=>PHY_TXD_sig(2), O=>PHY_TXD2);    
	OBUF_PHY_TXD1 : OBUF       port map (I=>PHY_TXD_sig(1), O=>PHY_TXD1);    
	OBUF_PHY_TXD0 : OBUF       port map (I=>PHY_TXD_sig(0), O=>PHY_TXD0);
           
           





end Behavioral;
