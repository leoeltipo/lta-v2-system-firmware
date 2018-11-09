----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2018 03:04:02 PM
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

component packer is
    Port ( 
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           rready_a : in STD_LOGIC;
           rdata_a : in STD_LOGIC_VECTOR (17 downto 0);
           rready_b : in STD_LOGIC;
           rdata_b : in STD_LOGIC_VECTOR (17 downto 0);
           rready_c : in STD_LOGIC;
           rdata_c : in STD_LOGIC_VECTOR (17 downto 0);
           rready_d : in STD_LOGIC;
           rdata_d : in STD_LOGIC_VECTOR (17 downto 0);
           rready_smart_buffer : in STD_LOGIC;
           rdata_smart_bufffer : in STD_LOGIC_VECTOR (21 downto 0);           
           pready_a : in STD_LOGIC;
           pdata_a : in STD_LOGIC_VECTOR (31 downto 0);
           pready_b : in STD_LOGIC;
           pdata_b : in STD_LOGIC_VECTOR (31 downto 0);
           pready_c : in STD_LOGIC;
           pdata_c : in STD_LOGIC_VECTOR (31 downto 0);
           pready_d : in STD_LOGIC;
           pdata_d : in STD_LOGIC_VECTOR (31 downto 0);
           header : in STD_LOGIC_VECTOR (1 downto 0);
           SOURCE_REG : in STD_LOGIC_VECTOR (3 downto 0);
           START_REG : in STD_LOGIC;
           dready : out STD_LOGIC;
           dack : in STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (63 downto 0)
           );
end component;

signal rst : STD_LOGIC := '0';
signal clk : STD_LOGIC := '0';
signal rready_a : STD_LOGIC := '0';
signal rdata_a : STD_LOGIC_VECTOR (17 downto 0) := "110101010110101010";
signal rready_b : STD_LOGIC := '0';
signal rdata_b : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
signal rready_c : STD_LOGIC := '0';
signal rdata_c : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
signal rready_d : STD_LOGIC := '0';
signal rdata_d : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
signal rready_smart_buffer : STD_LOGIC := '0';
signal rdata_smart_bufffer : STD_LOGIC_VECTOR (21 downto 0) := "0000000000000000000000";           
signal pready_a : STD_LOGIC := '0';
signal pdata_a : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal pready_b : STD_LOGIC := '0';
signal pdata_b : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal pready_c : STD_LOGIC := '0';
signal pdata_c : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal pready_d : STD_LOGIC := '0';
signal pdata_d : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal header : STD_LOGIC_VECTOR (1 downto 0) := "00";
signal SOURCE_REG : STD_LOGIC_VECTOR (3 downto 0) := "0000";
signal START_REG : STD_LOGIC := '0';
signal dready : STD_LOGIC := '0';
signal dack : STD_LOGIC := '1';
signal dout : STD_LOGIC_VECTOR (63 downto 0);
           
begin

packer_i : packer
    Port map ( rst => rst,
           clk => clk,
           rready_a => rready_a,
           rdata_a => rdata_a,
           rready_b => rready_b,
           rdata_b => rdata_b,
           rready_c => rready_c,
           rdata_c => rdata_c,
           rready_d => rready_d,
           rdata_d => rdata_d,
           rready_smart_buffer => rready_smart_buffer,
           rdata_smart_bufffer => rdata_smart_bufffer,
           pready_a => pready_a,
           pdata_a => pdata_a,
           pready_b => pready_b,
           pdata_b => pdata_b,
           pready_c => pready_c,
           pdata_c => pdata_c,
           pready_d => pready_d,
           pdata_d => pdata_d,
           header => header,
           SOURCE_REG => SOURCE_REG,
           START_REG => START_REG,
           dready => dready,
           dack => dack,
           dout => dout
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
    rst <= '1';
    wait for 100 ns;
    rst <= '0';
    wait for 50 ns;
    
    START_REG <= '1';
    
    wait until clk = '1';
    rready_a <= '1';
    rdata_a <= std_logic_vector(to_unsigned(1,rdata_a'length));
    wait for 50 ns;
    
    wait until clk = '1';
    rready_a <= '0';
    wait for 25 ns;
    
    wait until clk = '1';
    rready_a <= '1';
    rdata_a <= std_logic_vector(to_unsigned(2,rdata_a'length));
    wait for 50 ns;
        
    wait until clk = '1';
    rready_a <= '0';
    wait for 25 ns;    
        
    wait until clk = '1';
    rready_a <= '1';
    rdata_a <= std_logic_vector(to_unsigned(3,rdata_a'length));
    wait for 50 ns;
            
    wait until clk = '1';
    rready_a <= '0';
    wait for 25 ns;
            
    wait until clk = '1';
    rready_a <= '1';
    rdata_a <= std_logic_vector(to_unsigned(4,rdata_a'length));
    wait for 50 ns;
                
    wait until clk = '1';
    rready_a <= '0';
    wait for 25 ns;
    
    wait until clk = '1';
    rready_a <= '1';
    rdata_a <= std_logic_vector(to_unsigned(5,rdata_a'length));
    wait for 50 ns;
        
    wait until clk = '1';
    rready_a <= '0';
    wait for 25 ns;    
        
    wait until clk = '1';
    rready_a <= '1';
    rdata_a <= std_logic_vector(to_unsigned(6,rdata_a'length));
    wait for 50 ns;
            
    wait until clk = '1';
    rready_a <= '0';
    wait for 25 ns;
            
    wait until clk = '1';
    rready_a <= '1';
    rdata_a <= std_logic_vector(to_unsigned(7,rdata_a'length));
    wait for 50 ns;
                
    wait until clk = '1';
    rready_a <= '0';
    wait for 25 ns;    
    
    wait until clk = '1';
    rready_a <= '1';
    rdata_a <= std_logic_vector(to_unsigned(8,rdata_a'length));
    wait for 50 ns;
    
    wait until clk = '1';
    rready_a <= '0';
    wait for 25 ns;

    wait until clk = '1';
    rready_a <= '1';
    rdata_a <= std_logic_vector(to_unsigned(9,rdata_a'length));
    wait for 50 ns;
    
    wait until clk = '1';
    rready_a <= '0';
    wait for 25 ns;
    
    wait until clk = '1';
    rready_a <= '1';
    rdata_a <= std_logic_vector(to_unsigned(10,rdata_a'length));
    wait for 50 ns;
    
    wait until clk = '1';
    rready_a <= '0';
    wait for 25 ns;

    -------------------
    -- Change source --
    -------------------
    SOURCE_REG <= "0101";   
     
    wait until clk = '1';
    pready_a <= '1';
    pdata_a <= std_logic_vector(to_unsigned(20,pdata_a'length));
    wait for 50 ns;
                
    wait until clk = '1';
    pready_a <= '0';
    wait for 25 ns;    
    
    wait until clk = '1';
    pready_a <= '1';
    pdata_a <= std_logic_vector(to_unsigned(21,pdata_a'length));
    wait for 50 ns;
    
    wait until clk = '1';
    pready_a <= '0';
    wait for 25 ns;

    wait until clk = '1';
    pready_a <= '1';
    pdata_a <= std_logic_vector(to_unsigned(22,pdata_a'length));
    wait for 50 ns;
    
    wait until clk = '1';
    pready_a <= '0';
    wait for 25 ns;
         
    -------------------
    -- Change source --
    -------------------
    SOURCE_REG <= "0001";         
         
    wait until clk = '1';
    rready_b <= '1';
    rdata_b <= std_logic_vector(to_unsigned(16,rdata_a'length));
    wait for 50 ns;
    
    wait until clk = '1';
    rready_b <= '0';
    wait for 25 ns;
    
    wait until clk = '1';
    rready_b <= '1';
    rdata_b <= std_logic_vector(to_unsigned(17,rdata_a'length));
    wait for 50 ns;
        
    wait until clk = '1';
    rready_b <= '0';
    wait for 25 ns;    
        
    wait until clk = '1';
    rready_b <= '1';
    rdata_b <= std_logic_vector(to_unsigned(18,rdata_a'length));
    wait for 50 ns;
            
    wait until clk = '1';
    rready_b <= '0';
    wait for 25 ns;
            
    wait until clk = '1';
    rready_b <= '1';
    rdata_b <= std_logic_vector(to_unsigned(18,rdata_a'length));
    wait for 50 ns;
                
    wait until clk = '1';
    rready_b <= '0';
    wait for 25 ns;
    
    wait until clk = '1';
    rready_b <= '1';
    rdata_b <= std_logic_vector(to_unsigned(20,rdata_a'length));
    wait for 50 ns;
        
    wait until clk = '1';
    rready_b <= '0';
    wait for 25 ns;    
        
    wait until clk = '1';
    rready_b <= '1';
    rdata_b <= std_logic_vector(to_unsigned(21,rdata_a'length));
    wait for 50 ns;
            
    wait until clk = '1';
    rready_b <= '0';
    wait for 25 ns;
            
    wait until clk = '1';
    rready_b <= '1';
    rdata_b <= std_logic_vector(to_unsigned(22,rdata_a'length));
    wait for 50 ns;
                
    wait until clk = '1';
    rready_b <= '0';
    wait for 25 ns;    
    
    wait until clk = '1';
    rready_b <= '1';
    rdata_b <= std_logic_vector(to_unsigned(23,rdata_a'length));
    wait for 50 ns;
    
    wait until clk = '1';
    rready_b <= '0';
    wait for 25 ns;

    wait until clk = '1';
    rready_b <= '1';
    rdata_b <= std_logic_vector(to_unsigned(24,rdata_a'length));
    wait for 50 ns;
    
    wait until clk = '1';
    rready_b <= '0';
    wait for 25 ns;            
    
    wait until clk = '1';
    rready_b <= '1';
    rdata_b <= std_logic_vector(to_unsigned(25,rdata_a'length));
    wait for 50 ns;
    
    wait until clk = '1';
    rready_b <= '0';
    wait for 25 ns;
    
    -------------------
    -- Change source --
    -------------------
    SOURCE_REG <= "0100";         
         

    rdata_smart_bufffer <= "0101010101010101010101";
                
    wait until clk = '1';
    rready_smart_buffer <= '1';
    wait for 50 ns;
    
    wait until clk = '1';
    rready_smart_buffer <= '0';
    wait for 100 ns;
    
    wait until clk = '1';
    rready_smart_buffer <= '1';
    wait for 50 ns;
    
    wait until clk = '1';
    rready_smart_buffer <= '0';
    wait for 100 ns;
    
    wait until clk = '1';
    rready_smart_buffer <= '1';
    wait for 50 ns;
    
    wait until clk = '1';
    rready_smart_buffer <= '0';
    wait for 100 ns;
    
    wait until clk = '1';
    rready_smart_buffer <= '1';
    wait for 50 ns;
    
    wait until clk = '1';
    rready_smart_buffer <= '0';
    wait for 100 ns;           
    

    -------------------
    -- Change source --
    -------------------
    SOURCE_REG <= "1001";         
         

    pdata_a <= x"0000AAAA";
    pdata_b <= x"0000BBBB";
    pdata_c <= x"0000CCCC";
    pdata_d <= x"0000DDDD";        
                
    wait until clk = '1';
    pready_a <= '1';
    pready_b <= '1';
    pready_c <= '1';
    pready_d <= '1';
    wait for 50 ns;
    
    wait until clk = '1';
    pready_a <= '0';
    pready_b <= '0';
    pready_c <= '0';
    pready_d <= '0';
    wait for 500 ns;
    
    wait until clk = '1';
    pready_a <= '1';
    pready_b <= '1';
    pready_c <= '1';
    pready_d <= '1';
    wait for 50 ns;
    
    wait until clk = '1';
    pready_a <= '0';
    pready_b <= '0';
    pready_c <= '0';
    pready_d <= '0';
    wait for 500 ns;
    
    wait until clk = '1';
    pready_a <= '1';
    pready_b <= '1';
    pready_c <= '1';
    pready_d <= '1';
    wait for 50 ns;
    
    wait until clk = '1';
    pready_a <= '0';
    pready_b <= '0';
    pready_c <= '0';
    pready_d <= '0';
    wait for 500 ns;
    
    wait until clk = '1';
    pready_a <= '1';
    pready_b <= '1';
    pready_c <= '1';
    pready_d <= '1';
    wait for 50 ns;
    
    wait until clk = '1';
    pready_a <= '0';
    pready_b <= '0';
    pready_c <= '0';
    pready_d <= '0';
    wait for 500 ns;           
    
    wait for 500 ns;
    
end process;
end Behavioral;
