----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/19/2018 10:20:33 AM
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb is
--  Port ( );
end tb;

architecture Behavioral of tb is

component cds_noncausal is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           p : in STD_LOGIC;
           s : in STD_LOGIC;
           dready_in : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (17 downto 0);
           dready_out : out STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (31 downto 0);
           DELAYP_REG : in STD_LOGIC_VECTOR (15 downto 0);
           DELAYS_REG : in STD_LOGIC_VECTOR (15 downto 0);
           SAMPLESP_REG : in STD_LOGIC_VECTOR (15 downto 0);
           SAMPLESS_REG : in STD_LOGIC_VECTOR (15 downto 0);
           OUTSEL_REG : in STD_LOGIC_VECTOR (1 downto 0));
end component;

signal rst          : STD_LOGIC;
signal clk          : STD_LOGIC;
signal p            : STD_LOGIC := '0';
signal s            : STD_LOGIC := '0';
signal dready_in    : STD_LOGIC := '0';
signal data_in      : STD_LOGIC_VECTOR (17 downto 0) := "000000111100001111";
signal dready_out   : STD_LOGIC;
signal data_out     : STD_LOGIC_VECTOR (31 downto 0);
signal DELAYP_REG   : STD_LOGIC_VECTOR (15 downto 0) := x"0000";
signal DELAYS_REG   : STD_LOGIC_VECTOR (15 downto 0) := x"0000";
signal SAMPLESP_REG : STD_LOGIC_VECTOR (15 downto 0) := x"00FF";
signal SAMPLESS_REG : STD_LOGIC_VECTOR (15 downto 0) := x"00FF";
signal OUTSEL_REG   : STD_LOGIC_VECTOR (1 downto 0)  := "10";

begin

DUT : cds_noncausal
    Port map ( 
        rst             => rst,
        clk             => clk,
        p               => p,
        s               => s,
        dready_in       => dready_in,
        data_in         => data_in,
        dready_out      => dready_out,
        data_out        => data_out,
        DELAYP_REG      => DELAYP_REG,
        DELAYS_REG      => DELAYS_REG,
        SAMPLESP_REG    => SAMPLESP_REG,
        SAMPLESS_REG    => SAMPLESS_REG,
        OUTSEL_REG      => OUTSEL_REG
        );

process
begin
    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
end process;

process
begin
    dready_in <= '1';
    wait for 33 ns;
    dready_in <= '0';
    wait for 33 ns;
end process;

process
begin
    rst <= '1';
    wait for 100 ns;
    rst <= '0';
    
    wait for 20 ns;
    
    DELAYP_REG <= std_logic_vector(to_signed(10,DELAYP_REG'length));
    SAMPLESP_REG <= std_logic_vector(to_signed(125,SAMPLESP_REG'length));
    
    DELAYS_REG <= std_logic_vector(to_signed(25,DELAYS_REG'length));
    SAMPLESS_REG <= std_logic_vector(to_signed(73,SAMPLESS_REG'length));        
    
    for J in 0 to 4 loop
    
        wait until rising_edge(clk);
        p <= '1';            
    
        for I in 1 to 300 loop
            wait until rising_edge(dready_in);
            data_in <= std_logic_vector(to_signed(I,data_in'length));
            wait until falling_edge(dready_in);
        end loop;
    
        p <= '0';
    
        wait for 1 us;
        
        
        wait until rising_edge(clk);              
        s <= '1';
        
        for I in 1 to 200 loop
            wait until rising_edge(dready_in);
            data_in <= std_logic_vector(to_signed(I,data_in'length));
            wait until falling_edge(dready_in);
        end loop;
    
        s <= '0';
        
        wait until rising_edge(dready_out);        
    end loop;        
    
    wait for 500 ns;
    assert false report "simulation ended" severity failure;
                
end process;

end Behavioral;
