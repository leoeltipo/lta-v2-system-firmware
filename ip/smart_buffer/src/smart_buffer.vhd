----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/02/2018 03:13:32 PM
-- Design Name: 
-- Module Name: smart_buffer - Behavioral
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

entity smart_buffer is
    Generic 
        (
        -- Number of bits of total memory space.
        N   : integer := 18
        );
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
        CHA_NSAMP_REG       : in STD_LOGIC_VECTOR (N-1 downto 0);
        CHB_NSAMP_REG       : in STD_LOGIC_VECTOR (N-1 downto 0);
        CHC_NSAMP_REG       : in STD_LOGIC_VECTOR (N-1 downto 0);
        CHD_NSAMP_REG       : in STD_LOGIC_VECTOR (N-1 downto 0);    
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
end smart_buffer;

architecture Behavioral of smart_buffer is

-- Components.

-- Raw Capture.
component raw_capture is
    Generic 
    (
    -- Number of bits of total memory space.
    N   : integer := 18
    );
    Port     
        ( 
        -- Reset and clock.
        rst                 : in STD_LOGIC;
        clk                 : in STD_LOGIC;
        
        -- External capture enable signal.
        capture_en          : in STD_LOGIC;
        
        -- Start capture.
        capture_start       : in STD_LOGIC;        
        
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
        CH_SEL_REG          : in STD_LOGIC_VECTOR (1 downto 0);
        CH_NSAMP_REG        : in STD_LOGIC_VECTOR (N-1 downto 0);           
        CH_MODE_REG         : in STD_LOGIC_VECTOR (1 downto 0);
        DATA_MODE_REG       : in STD_LOGIC;        
        CAPTURE_MODE_REG    : in STD_LOGIC;
        CAPTURE_EN_SRC_REG  : in STD_LOGIC;
        RESET_REG           : in STD_LOGIC;
        
        -- Number of points captured.
        ptr_last_out        : out STD_LOGIC_VECTOR (N-1 downto 0);
        nsamp_out           : out STD_LOGIC_VECTOR (N downto 0);                
        
        -- Memory I/F.
        mem_en              : out STD_LOGIC;
        mem_we              : out STD_LOGIC_VECTOR(0 DOWNTO 0);
        mem_addr            : out STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        mem_din             : out STD_LOGIC_VECTOR(19 DOWNTO 0);        
        
        -- EOC signal.
        eoc                 : out STD_LOGIC;
        eoc_ack             : in STD_LOGIC
        );                
        
end component;

-- RAW Transfer.
component raw_transfer is
    Generic 
    (
    -- Number of bits of total memory space.
    N   : integer := 18
    );
    Port 
        ( 
        -- Reset and clock.
        rst                 : in STD_LOGIC;
        clk                 : in STD_LOGIC;
        
        -- Start transfer.
        transfer_start      : in STD_LOGIC;
        
        -- Registers.
        CHA_SEL_REG         : in STD_LOGIC_VECTOR (1 downto 0);
        CHB_SEL_REG         : in STD_LOGIC_VECTOR (1 downto 0);
        CHC_SEL_REG         : in STD_LOGIC_VECTOR (1 downto 0);
        CHD_SEL_REG         : in STD_LOGIC_VECTOR (1 downto 0);                
        CH_MODE_REG         : in STD_LOGIC_VECTOR (1 downto 0);
        SPEED_CTRL_REG      : in STD_LOGIC_VECTOR (15 downto 0);
        RESET_REG           : in STD_LOGIC;        
        
        -- Pointer to last sample.
        ptr_last_cha        : in STD_LOGIC_VECTOR (N-1 downto 0);
        ptr_last_chb        : in STD_LOGIC_VECTOR (N-1 downto 0);
        ptr_last_chc        : in STD_LOGIC_VECTOR (N-1 downto 0);
        ptr_last_chd        : in STD_LOGIC_VECTOR (N-1 downto 0);
        
        -- Number of samples.
        nsamp_cha           : in STD_LOGIC_VECTOR (N downto 0);
        nsamp_chb           : in STD_LOGIC_VECTOR (N downto 0);
        nsamp_chc           : in STD_LOGIC_VECTOR (N downto 0);
        nsamp_chd           : in STD_LOGIC_VECTOR (N downto 0);
                        
        -- Memory I/F.
        mem_en              : out STD_LOGIC;
        mem_we              : out STD_LOGIC_VECTOR(0 DOWNTO 0);
        mem_addr            : out STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        mem_dout            : in STD_LOGIC_VECTOR(19 DOWNTO 0);                
               
        -- RAW output data.
        ready_out           : out STD_LOGIC;
        data_out            : out STD_LOGIC_VECTOR (21 downto 0);
        
        -- EOT signals.
        eot                 : out STD_LOGIC;
        eot_ack             : in STD_LOGIC
        );
end component;

-- Control and interconnect.
component control_fsm is
    Generic
    (
    -- Number of bits of total memory space.
    N   : integer := 18
    );
    Port 
        (
        -- Reset and clock. 
        rst                     : in STD_LOGIC;
        clk                     : in STD_LOGIC;
        
        -- Registers.
        CH_MODE_REG             : in STD_LOGIC_VECTOR (1 downto 0);
        CAPTURE_START_REG       : in STD_LOGIC;
        CAPTURE_END_REG         : out STD_LOGIC;
        TRANSFER_START_REG      : in STD_LOGIC;
        TRANSFER_END_REG        : out STD_LOGIC;
        RESET_REG               : in STD_LOGIC;
                
        -- Capture Channel A.
        capture_start_cha       : out STD_LOGIC;
        mem_en_capture_cha      : in STD_LOGIC;
        mem_we_capture_cha      : in STD_LOGIC_VECTOR (0 downto 0);
        mem_addr_capture_cha    : in STD_LOGIC_VECTOR (N-1 downto 0);
        mem_din_capture_cha     : in STD_LOGIC_VECTOR (19 downto 0);
        eoc_cha                 : in STD_LOGIC;        
		
        -- Capture Channel B.
        capture_start_chb       : out STD_LOGIC;
        mem_en_capture_chb      : in STD_LOGIC;
        mem_we_capture_chb      : in STD_LOGIC_VECTOR (0 downto 0);
        mem_addr_capture_chb    : in STD_LOGIC_VECTOR (N-1 downto 0);
        mem_din_capture_chb     : in STD_LOGIC_VECTOR (19 downto 0);
        eoc_chb                 : in STD_LOGIC;        

		-- Capture Channel C.
		capture_start_chc       : out STD_LOGIC;
        mem_en_capture_chc      : in STD_LOGIC;
        mem_we_capture_chc      : in STD_LOGIC_VECTOR (0 downto 0);
        mem_addr_capture_chc    : in STD_LOGIC_VECTOR (N-1 downto 0);
        mem_din_capture_chc     : in STD_LOGIC_VECTOR (19 downto 0);
        eoc_chc                 : in STD_LOGIC;        
		
        -- Capture Channel D.
        capture_start_chd       : out STD_LOGIC;
        mem_en_capture_chd      : in STD_LOGIC;
        mem_we_capture_chd      : in STD_LOGIC_VECTOR (0 downto 0);
        mem_addr_capture_chd    : in STD_LOGIC_VECTOR (N-1 downto 0);
        mem_din_capture_chd     : in STD_LOGIC_VECTOR (19 downto 0);
        eoc_chd                 : in STD_LOGIC;
        
        -- eoc_ack.
        eoc_ack                 : out STD_LOGIC;        		
        
        -- Transfer.
        transfer_start          : out STD_LOGIC;
        mem_en_transfer         : in STD_LOGIC;
        mem_we_transfer         : in STD_LOGIC_VECTOR (0 downto 0);
        mem_addr_transfer       : in STD_LOGIC_VECTOR (N-1 downto 0);
        mem_dout_transfer       : out STD_LOGIC_VECTOR (19 downto 0);
        eot                     : in STD_LOGIC;
        eot_ack                 : out STD_LOGIC;
        
        -- Memory Buffer 0.
        mem_en_0                : out STD_LOGIC;
        mem_we_0                : out STD_LOGIC_VECTOR(0 DOWNTO 0);
        mem_addr_0              : out STD_LOGIC_VECTOR(N-3 DOWNTO 0);
        mem_din_0               : out STD_LOGIC_VECTOR(19 DOWNTO 0);
        mem_dout_0              : in STD_LOGIC_VECTOR(19 DOWNTO 0);
		
        -- Memory Buffer 1.
        mem_en_1                : out STD_LOGIC;
        mem_we_1                : out STD_LOGIC_VECTOR(0 DOWNTO 0);
        mem_addr_1              : out STD_LOGIC_VECTOR(N-3 DOWNTO 0);
        mem_din_1               : out STD_LOGIC_VECTOR(19 DOWNTO 0);
        mem_dout_1              : in STD_LOGIC_VECTOR(19 DOWNTO 0);

		-- Memory Buffer 2.
        mem_en_2                : out STD_LOGIC;
        mem_we_2                : out STD_LOGIC_VECTOR(0 DOWNTO 0);
        mem_addr_2              : out STD_LOGIC_VECTOR(N-3 DOWNTO 0);
        mem_din_2               : out STD_LOGIC_VECTOR(19 DOWNTO 0);
        mem_dout_2              : in STD_LOGIC_VECTOR(19 DOWNTO 0);
		
        -- Memory Buffer 3.
        mem_en_3                : out STD_LOGIC;
        mem_we_3                : out STD_LOGIC_VECTOR(0 DOWNTO 0);
        mem_addr_3              : out STD_LOGIC_VECTOR(N-3 DOWNTO 0);
        mem_din_3               : out STD_LOGIC_VECTOR(19 DOWNTO 0);
        mem_dout_3              : in STD_LOGIC_VECTOR(19 DOWNTO 0)		
        );
end component;

-- Memories.
component smart_mem_dummy is
    Generic 
        (
            N : integer := 16
        );
    Port 
        ( 
            clka    : in STD_LOGIC;
            ena     : in STD_LOGIC;
            wea     : in STD_LOGIC_VECTOR (0 downto 0);
            addra   : in STD_LOGIC_VECTOR (N-1 downto 0);
            dina    : in STD_LOGIC_VECTOR (19 downto 0);
            douta   : out STD_LOGIC_VECTOR (19 downto 0)
        );        
end component;

-- Capture signals.
signal capture_start_cha    : std_logic;
signal mem_en_capture_cha   : std_logic;
signal mem_we_capture_cha   : std_logic_vector (0 downto 0);
signal mem_addr_capture_cha : std_logic_vector (N-1 downto 0);
signal mem_din_capture_cha  : std_logic_vector (19 downto 0);        
signal eoc_cha              : std_logic;

signal capture_start_chb    : std_logic;
signal mem_en_capture_chb   : std_logic;
signal mem_we_capture_chb   : std_logic_vector (0 downto 0);
signal mem_addr_capture_chb : std_logic_vector (N-1 downto 0);
signal mem_din_capture_chb  : std_logic_vector (19 downto 0);        
signal eoc_chb              : std_logic;

signal capture_start_chc    : std_logic;
signal mem_en_capture_chc   : std_logic;
signal mem_we_capture_chc   : std_logic_vector (0 downto 0);
signal mem_addr_capture_chc : std_logic_vector (N-1 downto 0);
signal mem_din_capture_chc  : std_logic_vector (19 downto 0);        
signal eoc_chc              : std_logic;

signal capture_start_chd    : std_logic;
signal mem_en_capture_chd   : std_logic;
signal mem_we_capture_chd   : std_logic_vector (0 downto 0);
signal mem_addr_capture_chd : std_logic_vector (N-1 downto 0);
signal mem_din_capture_chd  : std_logic_vector (19 downto 0);        
signal eoc_chd              : std_logic;

-- Transfer signals.
signal transfer_start       : STD_LOGIC;
                
signal mem_en_transfer      : STD_LOGIC;
signal mem_we_transfer      : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_transfer    : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
signal mem_dout_transfer    : STD_LOGIC_VECTOR(19 DOWNTO 0);

signal eot                  : STD_LOGIC;
signal eot_ack              : STD_LOGIC;

-- Shared.
signal ptr_last_cha         : std_logic_vector (N-1 downto 0);
signal nsamp_cha            : std_logic_vector (N downto 0);
signal ptr_last_chb         : std_logic_vector (N-1 downto 0);
signal nsamp_chb            : std_logic_vector (N downto 0);
signal ptr_last_chc         : std_logic_vector (N-1 downto 0);
signal nsamp_chc            : std_logic_vector (N downto 0);
signal ptr_last_chd         : std_logic_vector (N-1 downto 0);
signal nsamp_chd            : std_logic_vector (N downto 0);
              
-- Memory signals.
signal ena_0    : std_logic;
signal wea_0    : std_logic_vector (0 downto 0);
signal addra_0  : std_logic_vector (N-3 downto 0);
signal dina_0   : std_logic_vector (19 downto 0);
signal douta_0  : std_logic_vector (19 downto 0);

signal ena_1    : std_logic;
signal wea_1    : std_logic_vector (0 downto 0);
signal addra_1  : std_logic_vector (N-3 downto 0);
signal dina_1   : std_logic_vector (19 downto 0);
signal douta_1  : std_logic_vector (19 downto 0);

signal ena_2    : std_logic;
signal wea_2    : std_logic_vector (0 downto 0);
signal addra_2  : std_logic_vector (N-3 downto 0);
signal dina_2   : std_logic_vector (19 downto 0);
signal douta_2  : std_logic_vector (19 downto 0);

signal ena_3    : std_logic;
signal wea_3    : std_logic_vector (0 downto 0);
signal addra_3  : std_logic_vector (N-3 downto 0);
signal dina_3   : std_logic_vector (19 downto 0);
signal douta_3  : std_logic_vector (19 downto 0);

-- EOC.
signal eoc_ack_i    : std_logic;

begin

-- RAW capture channel A.
raw_capture_cha_i : raw_capture
    Generic map
        (
        -- Number of bits of total memory space.
        N   => N
        )
    Port map     
        ( 
        -- Reset and clock.
        rst                 => rst,
        clk                 => clk,
        
        -- External capture enable signal.
        capture_en          => capture_en_cha,
        
        -- Start capture.
        capture_start       => capture_start_cha,
        
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
        CH_SEL_REG          => CHA_SEL_REG,
        CH_NSAMP_REG        => CHA_NSAMP_REG,  
        CH_MODE_REG         => CH_MODE_REG,            
        DATA_MODE_REG       => DATAA_MODE_REG,      
        CAPTURE_MODE_REG    => CAPTURE_MODE_REG,
        CAPTURE_EN_SRC_REG  => CAPTURE_EN_SRC_REG,
        RESET_REG           => RESET_REG,
        
        -- Number of points captured.
        ptr_last_out        => ptr_last_cha,
        nsamp_out           => nsamp_cha,                 
        
        -- Memory I/F.
        mem_en              => mem_en_capture_cha,
        mem_we              => mem_we_capture_cha,
        mem_addr            => mem_addr_capture_cha,
        mem_din             => mem_din_capture_cha,      
        
        -- EOC signal.
        eoc                 => eoc_cha,
        eoc_ack             => eoc_ack_i
        );
        
-- RAW capture channel B.
raw_capture_chb_i : raw_capture
    Generic map
    (
    -- Number of bits of total memory space.
    N   => N
    )
    Port map     
        ( 
        -- Reset and clock.
        rst                 => rst,
        clk                 => clk,
        
        -- External capture enable signal.
        capture_en          => capture_en_chb,
        
        -- Start capture.
        capture_start       => capture_start_chb,        
        
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
        CH_SEL_REG          => CHB_SEL_REG,
        CH_NSAMP_REG        => CHB_NSAMP_REG,  
        CH_MODE_REG         => CH_MODE_REG,            
        DATA_MODE_REG       => DATAB_MODE_REG,      
        CAPTURE_MODE_REG    => CAPTURE_MODE_REG,
        CAPTURE_EN_SRC_REG  => CAPTURE_EN_SRC_REG,  
        RESET_REG           => RESET_REG,
        
        -- Number of points captured.
        ptr_last_out        => ptr_last_chb,
        nsamp_out           => nsamp_chb,            
        
        -- Memory I/F.
        mem_en              => mem_en_capture_chb,
        mem_we              => mem_we_capture_chb,
        mem_addr            => mem_addr_capture_chb,
        mem_din             => mem_din_capture_chb,      
        
        -- EOC signal.
        eoc                 => eoc_chb,
        eoc_ack             => eoc_ack_i
        ); 

-- RAW capture channel C.
raw_capture_chc_i : raw_capture
    Generic map
    (
    -- Number of bits of total memory space.
    N   => N
    )
    Port map     
        ( 
        -- Reset and clock.
        rst                 => rst,
        clk                 => clk,
        
        -- External capture enable signal.
        capture_en          => capture_en_chc,
        
        -- Start capture.
        capture_start       => capture_start_chc,        
        
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
        CH_SEL_REG          => CHC_SEL_REG,
        CH_NSAMP_REG        => CHC_NSAMP_REG,  
        CH_MODE_REG         => CH_MODE_REG,            
        DATA_MODE_REG       => DATAC_MODE_REG,      
        CAPTURE_MODE_REG    => CAPTURE_MODE_REG,
        CAPTURE_EN_SRC_REG  => CAPTURE_EN_SRC_REG,
        RESET_REG           => RESET_REG,
        
        -- Number of points captured.
        ptr_last_out        => ptr_last_chc,
        nsamp_out           => nsamp_chc,
                
        -- Memory I/F.
        mem_en              => mem_en_capture_chc,
        mem_we              => mem_we_capture_chc,
        mem_addr            => mem_addr_capture_chc,
        mem_din             => mem_din_capture_chc,      
        
        -- EOC signal.
        eoc                 => eoc_chc,
        eoc_ack             => eoc_ack_i
        );

-- RAW capture channel D.
raw_capture_chd_i : raw_capture
    Generic map
    (
    -- Number of bits of total memory space.
    N   => N
    )
    Port map     
        ( 
        -- Reset and clock.
        rst                 => rst,
        clk                 => clk,
        
        -- External capture enable signal.
        capture_en          => capture_en_chd,
        
        -- Start capture.
        capture_start       => capture_start_chd,        
        
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
        CH_SEL_REG          => CHD_SEL_REG,
        CH_NSAMP_REG        => CHD_NSAMP_REG,  
        CH_MODE_REG         => CH_MODE_REG,            
        DATA_MODE_REG       => DATAD_MODE_REG,      
        CAPTURE_MODE_REG    => CAPTURE_MODE_REG,
        CAPTURE_EN_SRC_REG  => CAPTURE_EN_SRC_REG,
        RESET_REG           => RESET_REG,
        
        -- Number of points captured.
        ptr_last_out        => ptr_last_chd,
        nsamp_out           => nsamp_chd,        
        
        -- Memory I/F.
        mem_en              => mem_en_capture_chd,
        mem_we              => mem_we_capture_chd,
        mem_addr            => mem_addr_capture_chd,
        mem_din             => mem_din_capture_chd,      
        
        -- EOC signal.
        eoc                 => eoc_chd,
        eoc_ack             => eoc_ack_i
        );		

-- RAW Transfer.
raw_transfer_i : raw_transfer
    Generic map
    (
    -- Number of bits of total memory space.
    N   => N
    )
    Port map
        ( 
        -- Reset and clock.
        rst                 => rst,
        clk                 => clk,
        
        -- External transfer enable signal.
        transfer_start      => transfer_start,
        
        -- Registers.
        CHA_SEL_REG         => CHA_SEL_REG,
        CHB_SEL_REG         => CHB_SEL_REG,
        CHC_SEL_REG         => CHC_SEL_REG,
        CHD_SEL_REG         => CHD_SEL_REG,        
        CH_MODE_REG         => CH_MODE_REG,
        SPEED_CTRL_REG      => SPEED_CTRL_REG,
        RESET_REG           => RESET_REG,
        
        -- Pointer to last sample.
        ptr_last_cha        => ptr_last_cha,
        ptr_last_chb        => ptr_last_chb,
        ptr_last_chc        => ptr_last_chc,
        ptr_last_chd        => ptr_last_chd,
        
        -- Number of samples.
        nsamp_cha           => nsamp_cha,
        nsamp_chb           => nsamp_chb,
        nsamp_chc           => nsamp_chc,
        nsamp_chd           => nsamp_chd,
                        
        -- Memory I/F.
        mem_en              => mem_en_transfer,
        mem_we              => mem_we_transfer,
        mem_addr            => mem_addr_transfer,
        mem_dout            => mem_dout_transfer,                
               
        -- RAW output data.
        ready_out           => ready_out,
        data_out            => data_out,
        
        -- EOT signals.
        eot                 => eot,
        eot_ack             => eot_ack
        );

-- Control and interconnect.
control_fsm_i : control_fsm
    Generic map
    (
    -- Number of bits of total memory space.
    N   => N
    )
    Port map 
        (
        -- Reset and clock. 
        rst                     => rst,
        clk                     => clk,
        
        -- Registers.
        CH_MODE_REG             => CH_MODE_REG,
        CAPTURE_START_REG       => CAPTURE_START_REG,
        CAPTURE_END_REG         => CAPTURE_END_REG,
        TRANSFER_START_REG      => TRANSFER_START_REG,
        TRANSFER_END_REG        => TRANSFER_END_REG,
        RESET_REG               => RESET_REG,        
        
        -- Capture Channel A.
        capture_start_cha       => capture_start_cha,
        mem_en_capture_cha      => mem_en_capture_cha,
        mem_we_capture_cha      => mem_we_capture_cha,
        mem_addr_capture_cha    => mem_addr_capture_cha,
        mem_din_capture_cha     => mem_din_capture_cha,
        eoc_cha                 => eoc_cha,        
		
        -- Capture Channel B.
        capture_start_chb       => capture_start_chb,
        mem_en_capture_chb      => mem_en_capture_chb,
        mem_we_capture_chb      => mem_we_capture_chb,
        mem_addr_capture_chb    => mem_addr_capture_chb,
        mem_din_capture_chb     => mem_din_capture_chb,
        eoc_chb                 => eoc_chb,        

		-- Capture Channel C.
		capture_start_chc       => capture_start_chc,
        mem_en_capture_chc      => mem_en_capture_chc,
        mem_we_capture_chc      => mem_we_capture_chc,
        mem_addr_capture_chc    => mem_addr_capture_chc,
        mem_din_capture_chc     => mem_din_capture_chc,
        eoc_chc                 => eoc_chc,        
		
        -- Capture Channel D.
        capture_start_chd       => capture_start_chd,
        mem_en_capture_chd      => mem_en_capture_chd,
        mem_we_capture_chd      => mem_we_capture_chd,
        mem_addr_capture_chd    => mem_addr_capture_chd,
        mem_din_capture_chd     => mem_din_capture_chd,
        eoc_chd                 => eoc_chd,
        
        -- eoc_ack.
        eoc_ack                 => eoc_ack_i,        		
        
        -- Transfer.
        transfer_start          => transfer_start,
        mem_en_transfer         => mem_en_transfer,
        mem_we_transfer         => mem_we_transfer,
        mem_addr_transfer       => mem_addr_transfer,
        mem_dout_transfer       => mem_dout_transfer,
        eot                     => eot,
        eot_ack                 => eot_ack,
        
        -- Memory Buffer 0.
        mem_en_0                => ena_0,
        mem_we_0                => wea_0,
        mem_addr_0              => addra_0,
        mem_din_0               => dina_0,
        mem_dout_0              => douta_0,
		
        -- Memory Buffer 1.
        mem_en_1                => ena_1,
        mem_we_1                => wea_1,
        mem_addr_1              => addra_1,
        mem_din_1               => dina_1,
        mem_dout_1              => douta_1,

		-- Memory Buffer 2.
        mem_en_2                => ena_2,
        mem_we_2                => wea_2,
        mem_addr_2              => addra_2,
        mem_din_2               => dina_2,
        mem_dout_2              => douta_2,
		
        -- Memory Buffer 3.
        mem_en_3                => ena_3,
        mem_we_3                => wea_3,
        mem_addr_3              => addra_3,
        mem_din_3               => dina_3,
        mem_dout_3              => douta_3		
        );
        
-- Memory buffer 0.
smart_mem_0_i : smart_mem_dummy
      Generic map 
          (
              N => N-2
          )
      Port map
          ( 
              clka    => clk,
              ena     => ena_0, 
              wea     => wea_0,
              addra   => addra_0,
              dina    => dina_0,
              douta   => douta_0
          );

-- Memory buffer 1.
smart_mem_1_i : smart_mem_dummy
      Generic map 
          (
              N => N-2
          )
      Port map
          ( 
              clka    => clk,
              ena     => ena_1, 
              wea     => wea_1,
              addra   => addra_1,
              dina    => dina_1,
              douta   => douta_1
          );

-- Memory buffer 2.
smart_mem_2_i : smart_mem_dummy
      Generic map 
          (
              N => N-2
          )
      Port map
          ( 
              clka    => clk,
              ena     => ena_2, 
              wea     => wea_2,
              addra   => addra_2,
              dina    => dina_2,
              douta   => douta_2
          );

-- Memory buffer 3.
smart_mem_3_i : smart_mem_dummy
      Generic map 
          (
              N => N-2
          )
      Port map
          ( 
              clka    => clk,
              ena     => ena_3, 
              wea     => wea_3,
              addra   => addra_3,
              dina    => dina_3,
              douta   => douta_3
          );

end Behavioral;

