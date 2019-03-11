----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2017 11:53:43 AM
-- Design Name: 
-- Module Name: eth_resync - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity eth_resync is
port ( 
        rst         : in std_logic;
        
		ENET_RXCLK      : in    std_logic; 
		ENET_RXDV : in    std_logic; 
        ENET_RX0	: in    std_logic; 
        ENET_RX1	: in    std_logic; 
        ENET_RX2	: in    std_logic; 
        ENET_RX3	: in    std_logic; 
        ENET_RX4	: in    std_logic; 
        ENET_RX5	: in    std_logic; 
        ENET_RX6	: in    std_logic; 
        ENET_RX7	: in    std_logic; 
		  
		--PHY_RXER     : in    std_logic; 
		--USER_CLOCK   : in    std_logic; 
          
	--PHY_RESET	: out    std_logic; -- not needed in CCD_DAQ board
		
		ENET_TXEN : out   std_logic; 
        ENET_TX0	: out   std_logic; 
        ENET_TX1	: out   std_logic; 
        ENET_TX2	: out   std_logic; 
        ENET_TX3	: out   std_logic;
        ENET_TX4	: out   std_logic; 
        ENET_TX5	: out   std_logic; 
        ENET_TX6	: out   std_logic; 
        ENET_TX7	: out   std_logic; 
        ENET_TXER	: out   std_logic;
                              
        ENET_GTXCLK : out   std_logic;
          --user interface
        b_data		: in	std_logic_vector(63 downto 0);
        b_we	    : in 	std_logic;        
        
        -- Added to allow setting IP from port.
        user_addr   : in    std_logic_vector (31 downto 0);
        
 	    data_in		: in 	std_logic_vector(31 downto 0);
 	
        addr		:out 	std_logic_vector(31 downto 0);
        data_out	:out 	std_logic_vector(63 downto 0);
        wren		:out 	std_logic_vector(3 downto 0);
                
        clk_125_out :out    std_logic              
        );
end eth_resync;

architecture Behavioral of eth_resync is

component eth_wrapper is
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
        user_addr				: in    std_logic_vector (31 downto 0);
 	
        rx_addr_user		:out 	std_logic_vector(31 downto 0);
        rx_data_user		:out 	std_logic_vector(63 downto 0);
        rx_wren_user		:out 	std_logic_vector(3 downto 0);
        clk_125_out         :out    std_logic
              
          );
end component;

component resync is
    Port (
        -- Global reset and clock. 
        rst     : in STD_LOGIC;
        clk     : in STD_LOGIC;        
        
        -- Interface signals.
        we_in   : in STD_LOGIC;
        we_out  : out STD_LOGIC;
        data_in : in STD_LOGIC_VECTOR (63 downto 0);
        data_out: out STD_LOGIC_VECTOR (63 downto 0)
    );
end component;

signal clk_125 : std_logic;
signal b_data_resync : std_logic_vector (63 downto 0);
signal b_we_resync : std_logic;

begin

eth_wrapper_i : eth_wrapper
port map ( 
		PHY_RXCLK =>  ENET_RXCLK,
		PHY_RXCTL_RXDV => ENET_RXDV, 
        PHY_RXD0 => ENET_RX0, 
        PHY_RXD1 => ENET_RX1, 
        PHY_RXD2 => ENET_RX2, 
        PHY_RXD3 => ENET_RX3, 
        PHY_RXD4 => ENET_RX4, 
        PHY_RXD5 => ENET_RX5, 
        PHY_RXD6 => ENET_RX6, 
        PHY_RXD7 => ENET_RX7,  
        
		PHY_TXCTL_TXEN => ENET_TXEN, 
        PHY_TXD0 => ENET_TX0, 
        PHY_TXD1 => ENET_TX1, 
        PHY_TXD2 => ENET_TX2, 
        PHY_TXD3 => ENET_TX3, 
        PHY_TXD4 => ENET_TX4, 
        PHY_TXD5 => ENET_TX5, 
        PHY_TXD6 => ENET_TX6, 
        PHY_TXD7 => ENET_TX7, 
        PHY_TXER => ENET_TXER,
                              
        PHY_TXC_GTXCLK => ENET_GTXCLK,
       
        b_data      => b_data_resync,
        b_data_we   => b_we_resync,
        
        user_addr   => user_addr,

 	    tx_data_user => data_in,
        rx_addr_user => addr,
        rx_data_user => data_out,
        rx_wren_user => wren,
        clk_125_out => clk_125
              
          );

resync_i : resync
    Port map (
        -- Global reset and clock. 
        rst     => rst,
        clk     => clk_125,
        
        -- Interface signals.
        we_in   => b_we,
        we_out  => b_we_resync,
        data_in => b_data,
        data_out=> b_data_resync
    );
    
clk_125_out <= clk_125;

end Behavioral;
