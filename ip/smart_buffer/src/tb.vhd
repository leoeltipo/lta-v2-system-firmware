----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/03/2018 09:25:43 AM
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

component smart_buffer is
    Port 
        ( 
        -- Reset and clock.
        rst                 : in STD_LOGIC;
        clk                 : in STD_LOGIC;
        
        -- External capture enable signal.
        capture_en_cha      : in STD_LOGIC;
        capture_en_chb      : in STD_LOGIC;
        capture_en_chc      : in STD_LOGIC;
        capture_en_chd      : in STD_LOGIC;
        
        -- RAW input data.
        ready_in_a          : in STD_LOGIC;
        data_in_a           : in STD_LOGIC_VECTOR (17 downto 0);
        ready_in_b          : in STD_LOGIC;
        data_in_b           : in STD_LOGIC_VECTOR (17 downto 0);
        ready_in_c          : in STD_LOGIC;
        data_in_c           : in STD_LOGIC_VECTOR (17 downto 0);
        ready_in_d          : in STD_LOGIC;
        data_in_d           : in STD_LOGIC_VECTOR (17 downto 0);
        
        -- Header.
        header              : in STD_LOGIC_VECTOR (1 downto 0);        
        
        -- Registers.        
        CHA_SEL_REG         : in STD_LOGIC_VECTOR (1 downto 0);
        CHB_SEL_REG         : in STD_LOGIC_VECTOR (1 downto 0);
        CHC_SEL_REG         : in STD_LOGIC_VECTOR (1 downto 0);
        CHD_SEL_REG         : in STD_LOGIC_VECTOR (1 downto 0);
        CHA_NSAMP_REG       : in STD_LOGIC_VECTOR (17 downto 0);
        CHB_NSAMP_REG       : in STD_LOGIC_VECTOR (17 downto 0);
        CHC_NSAMP_REG       : in STD_LOGIC_VECTOR (17 downto 0);
        CHD_NSAMP_REG       : in STD_LOGIC_VECTOR (17 downto 0);    
        CH_MODE_REG         : in STD_LOGIC_VECTOR (1 downto 0);   
        DATAA_MODE_REG      : in STD_LOGIC;        
        DATAB_MODE_REG      : in STD_LOGIC;
        DATAC_MODE_REG      : in STD_LOGIC;
        DATAD_MODE_REG      : in STD_LOGIC;                
        CAPTURE_MODE_REG    : in STD_LOGIC;
        CAPTURE_EN_SRC_REG  : in STD_LOGIC;
        CAPTURE_START_REG   : in STD_LOGIC;
        CAPTURE_END_REG     : out STD_LOGIC;
        SPEED_CTRL_REG      : in STD_LOGIC_VECTOR (15 downto 0);
        TRANSFER_START_REG  : in STD_LOGIC;
        TRANSFER_END_REG    : out STD_LOGIC;
        RESET_REG           : in STD_LOGIC;
               
        -- RAW output data.
        ready_out           : out STD_LOGIC;
        data_out            : out STD_LOGIC_VECTOR (21 downto 0)
        );
end component;

-- Reset and clock.
signal rst                 : STD_LOGIC := '0';
signal clk                 : STD_LOGIC := '0';

-- External capture enable signal.
signal capture_en_cha      : STD_LOGIC := '1';
signal capture_en_chb      : STD_LOGIC := '1';
signal capture_en_chc      : STD_LOGIC := '1';
signal capture_en_chd      : STD_LOGIC := '1';

-- RAW input data.
signal ready_in_a          : STD_LOGIC := '0';
signal data_in_a           : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
signal ready_in_b          : STD_LOGIC := '0';
signal data_in_b           : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
signal ready_in_c          : STD_LOGIC := '0';
signal data_in_c           : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
signal ready_in_d          : STD_LOGIC := '0';
signal data_in_d           : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";

-- Header.
signal header              : STD_LOGIC_VECTOR (1 downto 0) := "00";

-- Registers.        
signal CHA_SEL_REG         : STD_LOGIC_VECTOR (1 downto 0) := "00";
signal CHB_SEL_REG         : STD_LOGIC_VECTOR (1 downto 0) := "01";
signal CHC_SEL_REG         : STD_LOGIC_VECTOR (1 downto 0) := "10";
signal CHD_SEL_REG         : STD_LOGIC_VECTOR (1 downto 0) := "11";
signal CHA_NSAMP_REG       : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
signal CHB_NSAMP_REG       : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
signal CHC_NSAMP_REG       : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
signal CHD_NSAMP_REG       : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";    
signal CH_MODE_REG         : STD_LOGIC_VECTOR (1 downto 0) := "00";
signal DATAA_MODE_REG      : STD_LOGIC := '0';        
signal DATAB_MODE_REG      : STD_LOGIC := '0';
signal DATAC_MODE_REG      : STD_LOGIC := '0';
signal DATAD_MODE_REG      : STD_LOGIC := '0';                
signal CAPTURE_MODE_REG    : STD_LOGIC := '1';
signal CAPTURE_EN_SRC_REG  : STD_LOGIC := '1';
signal CAPTURE_START_REG   : STD_LOGIC := '0';
signal CAPTURE_END_REG     : STD_LOGIC;
signal SPEED_CTRL_REG      : STD_LOGIC_VECTOR (15 downto 0) := "0000000000001111";
signal TRANSFER_START_REG  : STD_LOGIC := '0';
signal TRANSFER_END_REG    : STD_LOGIC;
signal RESET_REG           : STD_LOGIC := '0';
       
-- RAW output data.
signal ready_out           : STD_LOGIC;
signal data_out            : STD_LOGIC_VECTOR (21 downto 0);

begin

smart_buffer_i : smart_buffer
    Port map
        ( 
        -- Reset and clock.
        rst                 => rst,
        clk                 => clk,
        
        -- External capture enable signal.
        capture_en_cha      => capture_en_cha,
        capture_en_chb      => capture_en_chb,
        capture_en_chc      => capture_en_chc,
        capture_en_chd      => capture_en_chd,
        
        -- RAW input data.
        ready_in_a          => ready_in_a,
        data_in_a           => data_in_a,
        ready_in_b          => ready_in_b,
        data_in_b           => data_in_b,
        ready_in_c          => ready_in_c,
        data_in_c           => data_in_c,
        ready_in_d          => ready_in_d,
        data_in_d           => data_in_d,
        
        -- Header.
        header              => header,        
        
        -- Registers.        
        CHA_SEL_REG         => CHA_SEL_REG,
        CHB_SEL_REG         => CHB_SEL_REG,
        CHC_SEL_REG         => CHC_SEL_REG,
        CHD_SEL_REG         => CHD_SEL_REG,
        CHA_NSAMP_REG       => CHA_NSAMP_REG,
        CHB_NSAMP_REG       => CHB_NSAMP_REG,
        CHC_NSAMP_REG       => CHC_NSAMP_REG,
        CHD_NSAMP_REG       => CHD_NSAMP_REG,    
        CH_MODE_REG         => CH_MODE_REG,   
        DATAA_MODE_REG      => DATAA_MODE_REG,        
        DATAB_MODE_REG      => DATAB_MODE_REG,
        DATAC_MODE_REG      => DATAC_MODE_REG,
        DATAD_MODE_REG      => DATAD_MODE_REG,                
        CAPTURE_MODE_REG    => CAPTURE_MODE_REG,
        CAPTURE_EN_SRC_REG  => CAPTURE_EN_SRC_REG,
        CAPTURE_START_REG   => CAPTURE_START_REG,
        CAPTURE_END_REG     => CAPTURE_END_REG,
        SPEED_CTRL_REG      => SPEED_CTRL_REG,
        TRANSFER_START_REG  => TRANSFER_START_REG,
        TRANSFER_END_REG    => TRANSFER_END_REG,
        RESET_REG           => RESET_REG,        
               
        -- RAW output data.
        ready_out           => ready_out,
        data_out            => data_out
        );


    -- Clock.
    process
    begin
        clk <= '0';
        wait for 4 ns;
        clk <= '1';
        wait for 4 ns;
    end process;
    
    -- Data A process.
    process
        variable I : integer := 0;
    begin        
        wait until rising_edge(clk);
        ready_in_a <= '1';
        data_in_a <= std_logic_vector(to_signed(I,data_in_a'length));
        wait until rising_edge(clk);
        ready_in_a <= '0';
        I := I + 1;
        wait for 30 ns;
    end process;
	
    -- Data B process.
    process
    begin
        wait until rising_edge(clk);
        ready_in_b <= '1';
        data_in_b <= std_logic_vector(to_signed(20,data_in_b'length));
        wait until rising_edge(clk);
        ready_in_b <= '0';
        wait for 20 ns;
    end process;

    -- Data C process.
    process
    begin
        wait until rising_edge(clk);
        ready_in_c <= '1';
        data_in_c <= std_logic_vector(to_signed(30,data_in_c'length));
        wait until rising_edge(clk);
        ready_in_c <= '0';
        wait for 45 ns;
    end process;        

    -- Data D process.
    process
    begin
        wait until rising_edge(clk);
        ready_in_d <= '1';
        data_in_d <= std_logic_vector(to_signed(40,data_in_d'length));
        wait until rising_edge(clk);
        ready_in_d <= '0';
        wait for 25 ns;
    end process;	
    
    -- Header process
    process
    begin
        wait until rising_edge(clk);
        header <= "00";
        --wait for 250 ns;
        --header <= "01";
        --wait for 330 ns;
        --header <= "10";
        --wait for 180 ns;
        --header <= "11";
        --wait for 550 ns;
    end process;
    
    -- Main TB.
    process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        
        wait until rising_edge(clk);
        
        -- CHA_SEL_REG : channel A.
        -- CH_MODE_REG : Single.
        -- CHA_NSAMP_REG : 17.
        -- DATAA_MODE_REG : Full.
        -- CAPTURE_MODE_REG : Continuous.
        -- CAPTURE_EN_SRC_REG : internal.        
         CHA_SEL_REG <= "00";
         CH_MODE_REG <= "00";       
         DATAA_MODE_REG <= '0';
         CAPTURE_MODE_REG <= '0';
         CAPTURE_EN_SRC_REG <= '1';
         
        -- Start.
        CAPTURE_START_REG <= '1';
        
        wait for 500 ns;
        
        -- End.
        --CAPTURE_START_REG <= '0';		  
        
        wait until CAPTURE_END_REG = '1';
        
        -- Transfer.
        TRANSFER_START_REG <= '1';
        wait until TRANSFER_END_REG <= '1';
        TRANSFER_START_REG <= '0';		
		
		wait for 100 ns;
		
	   -- CHA_SEL_REG : channel A.
       -- CH_MODE_REG : Single.
       -- CHA_NSAMP_REG : 17.
       -- DATAA_MODE_REG : NSAMP.
       -- CAPTURE_MODE_REG : Single.
       -- CAPTURE_EN_SRC_REG : internal.
        CHA_SEL_REG <= "00";
        CH_MODE_REG <= "00";
        CHA_NSAMP_REG <= std_logic_vector(to_unsigned(17,CHA_NSAMP_REG'length));
        DATAA_MODE_REG <= '1';
        CAPTURE_MODE_REG <= '0';
        CAPTURE_EN_SRC_REG <= '1';
        
        -- Start.              
        CAPTURE_START_REG <= '1';               
        wait until CAPTURE_END_REG <= '1';
        CAPTURE_START_REG <= '0';
        
        -- Transfer.
        TRANSFER_START_REG <= '1';
        wait until TRANSFER_END_REG = '1';
        TRANSFER_START_REG <= '0';
        
        wait for 100 ns;

	   -- CHA_SEL_REG : channel B.
	   -- CHB_SEL_REG : channel C.
       -- CH_MODE_REG : Dual.
       -- CHA_NSAMP_REG : 8.
       -- CHB_NSAMP_REG : 72.
       -- DATAA_MODE_REG : NSAMP.
       -- DATAB_MODE_REG : NSAMP.
       -- CAPTURE_MODE_REG : Single.
       -- CAPTURE_EN_SRC_REG : internal.
        CHA_SEL_REG <= "01";
        CHB_SEL_REG <= "10";
        CH_MODE_REG <= "01";
        CHA_NSAMP_REG <= std_logic_vector(to_unsigned(8,CHA_NSAMP_REG'length));
        CHB_NSAMP_REG <= std_logic_vector(to_unsigned(72,CHB_NSAMP_REG'length));
        DATAA_MODE_REG <= '1';
        DATAB_MODE_REG <= '1';
        CAPTURE_MODE_REG <= '0';
        CAPTURE_EN_SRC_REG <= '1';
        
        -- Start.              
        CAPTURE_START_REG <= '1';               
        wait until CAPTURE_END_REG <= '1';
        CAPTURE_START_REG <= '0';
        
        -- Transfer.
        TRANSFER_START_REG <= '1';
        wait until TRANSFER_END_REG = '1';
        TRANSFER_START_REG <= '0';             		
            
        wait for 100 ns;
		
	   -- CHA_SEL_REG : channel D.
	   -- CHB_SEL_REG : channel C.
	   -- CHC_SEL_REG : channel B.
	   -- CHD_SEL_REG : channel A.
       -- CH_MODE_REG : Quad.
       -- CHA_NSAMP_REG : 150.
       -- CHB_NSAMP_REG : 98.
       -- CHC_NSAMP_REG : 13.
       -- CHD_NSAMP_REG : --.
       -- DATAA_MODE_REG : NSAMP.
       -- DATAB_MODE_REG : NSAMP.
       -- DATAC_MODE_REG : NSAMP.
       -- DATAD_MODE_REG : Full.
       -- CAPTURE_MODE_REG : Single.
       -- CAPTURE_EN_SRC_REG : internal.
        CHA_SEL_REG <= "11";
        CHB_SEL_REG <= "10";
        CHC_SEL_REG <= "01";
        CHD_SEL_REG <= "00";
        CH_MODE_REG <= "10";
        CHA_NSAMP_REG <= std_logic_vector(to_unsigned(150,CHA_NSAMP_REG'length));
        CHB_NSAMP_REG <= std_logic_vector(to_unsigned(98,CHB_NSAMP_REG'length));
        CHC_NSAMP_REG <= std_logic_vector(to_unsigned(13,CHC_NSAMP_REG'length));
        CHD_NSAMP_REG <= std_logic_vector(to_unsigned(2,CHD_NSAMP_REG'length));
        DATAA_MODE_REG <= '1';
        DATAB_MODE_REG <= '1';
        DATAC_MODE_REG <= '1';
        DATAD_MODE_REG <= '0';
        CAPTURE_MODE_REG <= '0';
        CAPTURE_EN_SRC_REG <= '1';
        
        -- Start.              
        CAPTURE_START_REG <= '1';
        TRANSFER_START_REG <= '1';
        
        -- RESET Test.
        wait for 1 ms;
        RESET_REG <= '1';
        wait for 20 ns;
        RESET_REG <= '0';
                       
        wait until CAPTURE_END_REG <= '1';
        CAPTURE_START_REG <= '0';               
        
        wait until TRANSFER_END_REG = '1';
        TRANSFER_START_REG <= '0'; 
        
        wait for 100 ns;
		
	   -- CHA_SEL_REG : channel B.
	   -- CHB_SEL_REG : channel A.	  
       -- CH_MODE_REG : Dual.
       -- CHA_NSAMP_REG : 15.
       -- CHB_NSAMP_REG : 54.            
       -- DATAA_MODE_REG : NSAMP.
       -- DATAB_MODE_REG : NSAMP.              
       -- CAPTURE_MODE_REG : Single.
       -- CAPTURE_EN_SRC_REG : external.
        CHA_SEL_REG <= "01";
        CHB_SEL_REG <= "00";
        CH_MODE_REG <= "01";
        CHA_NSAMP_REG <= std_logic_vector(to_unsigned(15,CHA_NSAMP_REG'length));
        CHB_NSAMP_REG <= std_logic_vector(to_unsigned(54,CHB_NSAMP_REG'length));
        DATAA_MODE_REG <= '1';
        DATAB_MODE_REG <= '1';        
        CAPTURE_MODE_REG <= '0';
        CAPTURE_EN_SRC_REG <= '0';
        
        -- Enable pins.
        capture_en_cha <= '0';
        capture_en_chb <= '0';
        
        -- Start.              
        CAPTURE_START_REG <= '1';
        
        wait for 50 ns;
        capture_en_cha <= '1';
        
        wait for 100 ns;
        capture_en_chb <= '1';
        
        wait for 40 ns;
        capture_en_cha <= '0';
        capture_en_chb <= '0';
        
        wait for 200 ns;
        capture_en_cha <= '1';
        capture_en_chb <= '1';
                               
        wait until CAPTURE_END_REG <= '1';
        CAPTURE_START_REG <= '0';
        
        -- Transfer.
        TRANSFER_START_REG <= '1';
        wait until TRANSFER_END_REG = '1';
        TRANSFER_START_REG <= '0'; 
        
        wait for 100 ns;

	   -- CHA_SEL_REG : channel C.
	   -- CHB_SEL_REG : channel D.	  
       -- CH_MODE_REG : Dual.
       -- CHA_NSAMP_REG : 15.
       -- CHB_NSAMP_REG : 54.            
       -- DATAA_MODE_REG : NSAMP.
       -- DATAB_MODE_REG : NSAMP.              
       -- CAPTURE_MODE_REG : Continuous.
       -- CAPTURE_EN_SRC_REG : external.
        CHA_SEL_REG <= "10";
        CHB_SEL_REG <= "11";
        CH_MODE_REG <= "01";
        CHA_NSAMP_REG <= std_logic_vector(to_unsigned(15,CHA_NSAMP_REG'length));
        CHB_NSAMP_REG <= std_logic_vector(to_unsigned(54,CHB_NSAMP_REG'length));
        DATAA_MODE_REG <= '1';
        DATAB_MODE_REG <= '1';        
        CAPTURE_MODE_REG <= '1';
        CAPTURE_EN_SRC_REG <= '0';
        
        -- Enable pins.
        capture_en_cha <= '0';
        capture_en_chb <= '0';
        
        -- Start.              
        CAPTURE_START_REG <= '1';
        
        wait for 1 ms;        
        capture_en_cha <= '1';
        
        wait for 5 ms;
        capture_en_chb <= '1';
        
        wait for 20 ms;
        capture_en_chb <= '0';
        
        wait for 10 ms;
        
        -- End.      
        CAPTURE_START_REG <= '0';
        
        -- Transfer.
        TRANSFER_START_REG <= '1';
        wait until TRANSFER_END_REG = '1';
        TRANSFER_START_REG <= '0'; 
        
        wait for 100 ns;				
		
	   -- CHA_SEL_REG : channel A.
	   -- CHB_SEL_REG : channel B.
	   -- CHC_SEL_REG : channel C.
	   -- CHD_SEL_REG : channel D.	  
       -- CH_MODE_REG : Quad.
       -- CHA_NSAMP_REG : --.
       -- CHB_NSAMP_REG : --.
       -- CHC_NSAMP_REG : --.
       -- CHD_NSAMP_REG : --.            
       -- DATAA_MODE_REG : Full.
       -- DATAB_MODE_REG : Full.              
       -- DATAC_MODE_REG : Full.
       -- DATAD_MODE_REG : Full.
       -- CAPTURE_MODE_REG : Single.
       -- CAPTURE_EN_SRC_REG : Internal.
        CHA_SEL_REG <= "00";
        CHB_SEL_REG <= "01";
        CHC_SEL_REG <= "10";
        CHD_SEL_REG <= "11";
        CH_MODE_REG <= "10";
        CHA_NSAMP_REG <= std_logic_vector(to_unsigned(11,CHA_NSAMP_REG'length));
        CHB_NSAMP_REG <= std_logic_vector(to_unsigned(22,CHB_NSAMP_REG'length));
        CHC_NSAMP_REG <= std_logic_vector(to_unsigned(33,CHC_NSAMP_REG'length));
        CHD_NSAMP_REG <= std_logic_vector(to_unsigned(44,CHD_NSAMP_REG'length));
        DATAA_MODE_REG <= '0';
        DATAB_MODE_REG <= '0';        
        DATAC_MODE_REG <= '0';
        DATAD_MODE_REG <= '0';
        CAPTURE_MODE_REG <= '0';
        CAPTURE_EN_SRC_REG <= '1';      
        
        -- Start.              
        CAPTURE_START_REG <= '1';                        
        TRANSFER_START_REG <= '1';
        		
        wait until CAPTURE_END_REG = '1';
        wait until TRANSFER_END_REG = '1';
		
		wait for 100 ns;
		
		CAPTURE_START_REG <= '0';                        
        TRANSFER_START_REG <= '0';
        
        wait for 100 ns;

	   -- CHA_SEL_REG : channel D.
       -- CH_MODE_REG : Single.
       -- CHA_NSAMP_REG : --.       
       -- DATAA_MODE_REG : Full.
       -- CAPTURE_MODE_REG : Single.
       -- CAPTURE_EN_SRC_REG : Internal.
        CHA_SEL_REG <= "11";
		CH_MODE_REG <= "00";
        CHA_NSAMP_REG <= std_logic_vector(to_unsigned(11,CHA_NSAMP_REG'length));
        DATAA_MODE_REG <= '0';
        CAPTURE_MODE_REG <= '0';
        CAPTURE_EN_SRC_REG <= '1';      
        
        -- Start.              
        CAPTURE_START_REG <= '1';                        
        TRANSFER_START_REG <= '1';
        
        wait until CAPTURE_END_REG = '1';
        wait until TRANSFER_END_REG = '1';
        
        wait for 100 ns;

		CAPTURE_START_REG <= '0';                        
        TRANSFER_START_REG <= '0';

        wait for 100 ns;
		
	   -- CHA_SEL_REG : channel A.
       -- CH_MODE_REG : Single.
       -- CHA_NSAMP_REG : --.       
       -- DATAA_MODE_REG : Full.
       -- CAPTURE_MODE_REG : Continuous.
       -- CAPTURE_EN_SRC_REG : Internal.
        CHA_SEL_REG <= "00";
		CH_MODE_REG <= "00";
        CHA_NSAMP_REG <= std_logic_vector(to_unsigned(11,CHA_NSAMP_REG'length));
        DATAA_MODE_REG <= '0';
        CAPTURE_MODE_REG <= '1';
        CAPTURE_EN_SRC_REG <= '1';      
        
        -- Start.              
        CAPTURE_START_REG <= '1';                        
        TRANSFER_START_REG <= '1';
		
		wait for 13 ms;
		
		-- End capture.
		CAPTURE_START_REG <= '0';
        
        wait until CAPTURE_END_REG = '1';
        wait until TRANSFER_END_REG = '1';
        
        wait for 100 ns;

		TRANSFER_START_REG <= '0';
		
		wait for 100 ns;
        
        assert false report "simulation ended" severity failure;            				
    end process;
end Behavioral;
