----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2017 10:58:25 AM
-- Design Name: 
-- Module Name: tb - Behavioral
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

entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is

constant T : time := 8 ns;

component eth_resync is
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
        b_ack       : out std_logic;
        
 	    data_in		: in 	std_logic_vector(31 downto 0);
 	
        addr		:out 	std_logic_vector(31 downto 0);
        data_out	:out 	std_logic_vector(63 downto 0);
        wren		:out 	std_logic_vector(3 downto 0);
        clk_125_out :out    std_logic
              
          );
end component;

signal rst : std_logic := '0';

signal ENET_RXCLK : std_logic := '0';

signal ENET_GTXCLK   : std_logic;

signal b_data : std_logic_vector (63 downto 0);
signal b_we : std_logic := '0';
signal b_ack : std_logic;

signal clk_125_out  : std_logic;

begin

DUT : eth_resync
port map ( 
        rst => rst,
        
		ENET_RXCLK => ENET_RXCLK, 
		ENET_RXDV => '0', 
        ENET_RX0 => '0', 
        ENET_RX1 => '0', 
        ENET_RX2 => '0', 
        ENET_RX3 => '0', 
        ENET_RX4 => '0', 
        ENET_RX5 => '0', 
        ENET_RX6 => '0', 
        ENET_RX7 => '0', 
		
		ENET_TXEN => open,
        ENET_TX0 => open,
        ENET_TX1 => open,
        ENET_TX2 => open,
        ENET_TX3 => open,
        ENET_TX4 => open,
        ENET_TX5 => open,
        ENET_TX6 => open,
        ENET_TX7 => open,
        ENET_TXER => open,
                              
        ENET_GTXCLK => ENET_GTXCLK,

        b_data => b_data,
        b_we => b_we,
        b_ack => b_ack,
        
 	    data_in => x"01234567",
 	
        addr => open,
        data_out => open,
        wren => open,
        clk_125_out => clk_125_out
              
          );
          
          -- 125 MHz clock.
          ENET_RXCLK <= not(ENET_RXCLK) after T/2;
          
          process
          begin
            rst <= '1';
            wait for 200 ns;
            rst <= '0';
            wait until ENET_RXCLK = '1';
            wait until ENET_RXCLK = '0';
            wait until ENET_RXCLK = '1';

            b_we <= '1';
            b_data <= x"0123456701234567"; 
            
            wait until b_ack = '1';
            wait until ENET_RXCLK = '1';
            b_we <= '0';
            
            wait until ENET_RXCLK = '0';
            wait until ENET_RXCLK = '1';
            
            b_we <= '1';
            b_data <= x"AAAAAAAAFFFFFFFF"; 
            
            wait for 1ms;
          end process;

end Behavioral;
