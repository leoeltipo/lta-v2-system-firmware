----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2019 02:10:11 PM
-- Design Name: 
-- Module Name: sync_gen - Behavioral
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

entity sync_gen is
    Port ( rst : in STD_LOGIC;
           clk_low : in STD_LOGIC;
           clk_high : in STD_LOGIC;
           sel : in STD_LOGIC;
           STOP_REG : in STD_LOGIC;
           DELAY_REG : in STD_LOGIC_VECTOR (7 downto 0);
           sync_in : in STD_LOGIC;
           sync_out : out STD_LOGIC;
           stop_sync : out STD_LOGIC);
end sync_gen;

architecture Behavioral of sync_gen is

-- Signals.
signal sync_out_sa  : std_logic;
signal sync_mux     : std_logic;

-- Components.
component sync_align is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           sync_in : in STD_LOGIC;
           sync_out : out STD_LOGIC);
end component;

component pulse_gen is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           DELAY_REG : in STD_LOGIC_VECTOR (7 downto 0);
           sync_in : in STD_LOGIC;
           sync_out : out STD_LOGIC);
end component;

begin

-- sync_align instance.
sync_align_i : sync_align
    Port map 
        ( 
            rst         => rst,
            clk         => clk_low,
            sync_in     => STOP_REG,
            sync_out    => sync_out_sa
        );

-- Mux for sync signal.
-- sel = 0: master.
-- sel = 1: slave.
sync_mux <= sync_out_sa when sel = '0' else
            sync_in;
            
-- pulse_gen instance.
pulse_gen_i : pulse_gen
    Port map 
        ( 
            rst         => rst,
            clk         => clk_high,
            DELAY_REG   => DELAY_REG,
            sync_in     => sync_mux,
            sync_out    => stop_sync
        );

-- Assign output.
sync_out <= sync_out_sa;
        
end Behavioral;
