----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/06/2018 03:28:53 PM
-- Design Name: 
-- Module Name: control_fsm - Behavioral
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

entity control_fsm is
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
end control_fsm;

architecture Behavioral of control_fsm is

-- State machine.
type fsm_state is ( WAIT_CAPTURE_START_ST,
                    WAIT_CAPTURE_END_ST,
                    SEND_EOC_ACK_ST,
                    WAIT_TRANSFER_START_ST,
                    WAIT_TRANSFER_END_ST,
                    SEND_EOT_ACK_ST,
                    END_ST);
signal current_state, next_state : fsm_state;

-- Registers.
signal CH_MODE_REG_r         : STD_LOGIC_VECTOR (1 downto 0);
signal CAPTURE_START_REG_r   : STD_LOGIC;
signal CAPTURE_END_REG_r     : STD_LOGIC;
signal TRANSFER_START_REG_r  : STD_LOGIC;
signal TRANSFER_END_REG_r    : STD_LOGIC;
signal RESET_REG_r           : STD_LOGIC;

-- end signals.
signal capture_end_i    : std_logic;
signal transfer_end_i   : std_logic;

-- Start signals.
signal capture_start_i : std_logic;
signal transfer_start_i : std_logic;

signal capture_mode : std_logic;

signal eoc : std_logic;

signal eoc_ack_i : std_logic;
signal eot_ack_i : std_logic;

-- Memory control signals.
-- Capture.
signal mem_en_0_c   : STD_LOGIC;
signal mem_we_0_c   : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_0_c : STD_LOGIC_VECTOR(N-3 DOWNTO 0);

signal mem_en_1_c   : STD_LOGIC;
signal mem_we_1_c   : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_1_c : STD_LOGIC_VECTOR(N-3 DOWNTO 0);

signal mem_en_2_c   : STD_LOGIC;
signal mem_we_2_c   : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_2_c : STD_LOGIC_VECTOR(N-3 DOWNTO 0);

signal mem_en_3_c   : STD_LOGIC;
signal mem_we_3_c   : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_3_c : STD_LOGIC_VECTOR(N-3 DOWNTO 0);

-- Transfer
signal mem_en_0_t   : STD_LOGIC;
signal mem_we_0_t   : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_0_t : STD_LOGIC_VECTOR(N-3 DOWNTO 0);

signal mem_en_1_t   : STD_LOGIC;
signal mem_we_1_t   : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_1_t : STD_LOGIC_VECTOR(N-3 DOWNTO 0);

signal mem_en_2_t   : STD_LOGIC;
signal mem_we_2_t   : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_2_t : STD_LOGIC_VECTOR(N-3 DOWNTO 0);

signal mem_en_3_t   : STD_LOGIC;
signal mem_we_3_t   : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_3_t : STD_LOGIC_VECTOR(N-3 DOWNTO 0);

signal mem_dout_t   : STD_LOGIC_VECTOR (19 downto 0);

-- After global mux.
signal mem_en_0_i   : STD_LOGIC;
signal mem_we_0_i   : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_0_i : STD_LOGIC_VECTOR(N-3 DOWNTO 0);
signal mem_din_0_i  : STD_LOGIC_VECTOR(19 DOWNTO 0);

signal mem_en_1_i   : STD_LOGIC;
signal mem_we_1_i   : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_1_i : STD_LOGIC_VECTOR(N-3 DOWNTO 0);
signal mem_din_1_i  : STD_LOGIC_VECTOR(19 DOWNTO 0);

signal mem_en_2_i   : STD_LOGIC;
signal mem_we_2_i   : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_2_i : STD_LOGIC_VECTOR(N-3 DOWNTO 0);
signal mem_din_2_i  : STD_LOGIC_VECTOR(19 DOWNTO 0);

signal mem_en_3_i   : STD_LOGIC;
signal mem_we_3_i   : STD_LOGIC_VECTOR(0 DOWNTO 0);
signal mem_addr_3_i : STD_LOGIC_VECTOR(N-3 DOWNTO 0);
signal mem_din_3_i  : STD_LOGIC_VECTOR(19 DOWNTO 0);
                   
begin

-- Registers.
process (rst, clk)
begin
    if ( rst = '1' ) then
        -- Registers.
        CH_MODE_REG_r           <= (others => '0');
        CAPTURE_START_REG_r     <= '0';
        CAPTURE_END_REG_r       <= '0';
        TRANSFER_START_REG_r    <= '0';
        TRANSFER_END_REG_r      <= '0';
        RESET_REG_r             <= '0';
        
        -- State register.
        current_state           <= WAIT_CAPTURE_START_ST;
        
    elsif ( rising_edge(clk) ) then
        -- Registers.
        CH_MODE_REG_r           <= CH_MODE_REG;
        CAPTURE_START_REG_r     <= CAPTURE_START_REG;
        CAPTURE_END_REG_r       <= capture_end_i;
        TRANSFER_START_REG_r    <= TRANSFER_START_REG;
        TRANSFER_END_REG_r      <= transfer_end_i;
        RESET_REG_r             <= RESET_REG;
            
        -- State register.
        current_state           <= next_state;            
    end if;
end process;

-- EOC signal.
eoc <=  (eoc_cha)                                       when CH_MODE_REG_r = "00" else
        (eoc_cha and eoc_chb)                           when CH_MODE_REG_r = "01" else
        (eoc_cha and eoc_chb and eoc_chc and eoc_chd)   when CH_MODE_REG_r = "10" else
        (eoc_cha); 

-- Memory multiplexor.
-- Capture signals.        
-- Single channel : Channel A writes to all four memories.
-- Double channel : Channel A writes into Memory buffer 0 and 1.
--                  Channel B writes into Memory buffer 2 and 3.
-- Quad   channel : Channel A writes into Memory buffer 0.
--                  Channel B writes into Memory buffer 1.
--                  Channel C writes into Memory buffer 2.
--                  Channel D writes into Memory buffer 3.
mem_en_0_c <=   mem_en_capture_cha when ( mem_addr_capture_cha(N-1 downto N-2) = "00" ) else
                '0';
mem_en_1_c <=   mem_en_capture_cha when ( (CH_MODE_REG_r = "00") and (mem_addr_capture_cha(N-1 downto N-2) = "01") ) else
                mem_en_capture_cha when ( (CH_MODE_REG_r = "01") and (mem_addr_capture_cha(N-1 downto N-2) = "01") ) else
                mem_en_capture_chb when ( (CH_MODE_REG_r = "10") ) else
                '0';
mem_en_2_c <=   mem_en_capture_cha when ( (CH_MODE_REG_r = "00") and (mem_addr_capture_cha(N-1 downto N-2) = "10") ) else
                mem_en_capture_chb when ( (CH_MODE_REG_r = "01") and (mem_addr_capture_chb(N-1 downto N-2) = "00") ) else                                                
                mem_en_capture_chc when ( (CH_MODE_REG_r = "10") ) else
                '0';
mem_en_3_c <=   mem_en_capture_cha when ( (CH_MODE_REG_r = "00") and (mem_addr_capture_cha(N-1 downto N-2) = "11") ) else
                mem_en_capture_chb when ( (CH_MODE_REG_r = "01") and (mem_addr_capture_chb(N-1 downto N-2) = "01") ) else
                mem_en_capture_chd when ( (CH_MODE_REG_r = "10") ) else
                '0';
				
mem_we_0_c <=   mem_we_capture_cha when ( mem_addr_capture_cha(N-1 downto N-2) = "00" ) else
                "0";
mem_we_1_c <=   mem_we_capture_cha when ( (CH_MODE_REG_r = "00") and (mem_addr_capture_cha(N-1 downto N-2) = "01") ) else
                mem_we_capture_cha when ( (CH_MODE_REG_r = "01") and (mem_addr_capture_cha(N-1 downto N-2) = "01") ) else
                mem_we_capture_chb when ( (CH_MODE_REG_r = "10") ) else
                "0";
mem_we_2_c <=   mem_we_capture_cha when ( (CH_MODE_REG_r = "00") and (mem_addr_capture_cha(N-1 downto N-2) = "10") ) else
                mem_we_capture_chb when ( (CH_MODE_REG_r = "01") and (mem_addr_capture_chb(N-1 downto N-2) = "00") ) else                                                
                mem_we_capture_chc when ( (CH_MODE_REG_r = "10") ) else
                "0";
mem_we_3_c <=   mem_we_capture_cha when ( (CH_MODE_REG_r = "00") and (mem_addr_capture_cha(N-1 downto N-2) = "11") ) else
                mem_we_capture_chb when ( (CH_MODE_REG_r = "01") and (mem_addr_capture_chb(N-1 downto N-2) = "01") ) else
                mem_we_capture_chd when ( (CH_MODE_REG_r = "10") ) else
                "0";				
				
mem_addr_0_c <= mem_addr_capture_cha(N-3 downto 0);
mem_addr_1_c <= mem_addr_capture_cha(N-3 downto 0) when  CH_MODE_REG_r = "00" else
                mem_addr_capture_cha(N-3 downto 0) when  CH_MODE_REG_r = "01" else
                mem_addr_capture_chb(N-3 downto 0) when  CH_MODE_REG_r = "10" else
                mem_addr_capture_cha(N-3 downto 0);
mem_addr_2_c <= mem_addr_capture_cha(N-3 downto 0) when  CH_MODE_REG_r = "00" else
                mem_addr_capture_chb(N-3 downto 0) when  CH_MODE_REG_r = "01" else
                mem_addr_capture_chc(N-3 downto 0) when  CH_MODE_REG_r = "10" else
                mem_addr_capture_cha(N-3 downto 0);
mem_addr_3_c <= mem_addr_capture_cha(N-3 downto 0) when  CH_MODE_REG_r = "00" else
                mem_addr_capture_chb(N-3 downto 0) when  CH_MODE_REG_r = "01" else
                mem_addr_capture_chd(N-3 downto 0) when  CH_MODE_REG_r = "10" else
                mem_addr_capture_cha(N-3 downto 0);

-- Transfer signals.
mem_en_0_t <=   mem_en_transfer when ( mem_addr_transfer(N-1 downto N-2) = "00" ) else
                '0';                
mem_en_1_t <=   mem_en_transfer when ( mem_addr_transfer(N-1 downto N-2) = "01" ) else
                '0';                
mem_en_2_t <=   mem_en_transfer when ( mem_addr_transfer(N-1 downto N-2) = "10" ) else
                '0';                                
mem_en_3_t <=   mem_en_transfer when ( mem_addr_transfer(N-1 downto N-2) = "11" ) else
                '0';                

mem_we_0_t <=   mem_we_transfer when ( mem_addr_transfer(N-1 downto N-2) = "00" ) else
                "0";                
mem_we_1_t <=   mem_we_transfer when ( mem_addr_transfer(N-1 downto N-2) = "01" ) else
                "0";                
mem_we_2_t <=   mem_we_transfer when ( mem_addr_transfer(N-1 downto N-2) = "10" ) else
                "0";                                
mem_we_3_t <=   mem_we_transfer when ( mem_addr_transfer(N-1 downto N-2) = "11" ) else
                "0";

mem_addr_0_t <= mem_addr_transfer (N-3 downto 0);
mem_addr_1_t <= mem_addr_transfer (N-3 downto 0);
mem_addr_2_t <= mem_addr_transfer (N-3 downto 0);
mem_addr_3_t <= mem_addr_transfer (N-3 downto 0);

mem_dout_t <=   mem_dout_0 when ( mem_addr_transfer(N-1 downto N-2) = "00" ) else
                mem_dout_1 when ( mem_addr_transfer(N-1 downto N-2) = "01" ) else
                mem_dout_2 when ( mem_addr_transfer(N-1 downto N-2) = "10" ) else
                mem_dout_3;

-- Global mux.
mem_en_0_i  <=  mem_en_0_c when ( capture_mode = '1' ) else
                mem_en_0_t; 
mem_en_1_i  <=  mem_en_1_c when ( capture_mode = '1' ) else
                mem_en_1_t;
mem_en_2_i  <=  mem_en_2_c when ( capture_mode = '1' ) else
                mem_en_2_t; 
mem_en_3_i  <=  mem_en_3_c when ( capture_mode = '1' ) else
                mem_en_3_t;

mem_we_0_i  <=  mem_we_0_c when ( capture_mode = '1' ) else
                mem_we_0_t; 
mem_we_1_i  <=  mem_we_1_c when ( capture_mode = '1' ) else
                mem_we_1_t;
mem_we_2_i  <=  mem_we_2_c when ( capture_mode = '1' ) else
                mem_we_2_t; 
mem_we_3_i  <=  mem_we_3_c when ( capture_mode = '1' ) else
                mem_we_3_t;

mem_addr_0_i <= mem_addr_0_c when ( capture_mode = '1' ) else
                mem_addr_0_t; 
mem_addr_1_i <= mem_addr_1_c when ( capture_mode = '1' ) else
                mem_addr_1_t;
mem_addr_2_i <= mem_addr_2_c when ( capture_mode = '1' ) else
                mem_addr_2_t; 
mem_addr_3_i <= mem_addr_3_c when ( capture_mode = '1' ) else
                mem_addr_3_t;

mem_en_0_i  <=  mem_en_0_c when ( capture_mode = '1' ) else
                mem_en_0_t; 
mem_en_1_i  <=  mem_en_1_c when ( capture_mode = '1' ) else
                mem_en_1_t;
mem_en_2_i  <=  mem_en_2_c when ( capture_mode = '1' ) else
                mem_en_2_t; 
mem_en_3_i  <=  mem_en_3_c when ( capture_mode = '1' ) else
                mem_en_3_t; 				

-- Fixed signals.
mem_din_0_i <=  mem_din_capture_cha;
mem_din_1_i <=  mem_din_capture_cha when  CH_MODE_REG_r = "00" else
                mem_din_capture_cha when  CH_MODE_REG_r = "01" else
                mem_din_capture_chb when  CH_MODE_REG_r = "10" else
                mem_din_capture_cha;
mem_din_2_i <=  mem_din_capture_cha when  CH_MODE_REG_r = "00" else
                mem_din_capture_chb when  CH_MODE_REG_r = "01" else
                mem_din_capture_chc when  CH_MODE_REG_r = "10" else
                mem_din_capture_cha;
mem_din_3_i <=  mem_din_capture_cha when  CH_MODE_REG_r = "00" else
                mem_din_capture_chb when  CH_MODE_REG_r = "01" else
                mem_din_capture_chd when  CH_MODE_REG_r = "10" else
                mem_din_capture_cha;             

-- Next state logic.
process (current_state, RESET_REG_r, CAPTURE_START_REG_r, TRANSFER_START_REG_r, eoc, eot)
begin
    case current_state is    
        when WAIT_CAPTURE_START_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= WAIT_CAPTURE_START_ST;
            elsif ( CAPTURE_START_REG_r = '0' ) then
                next_state <= WAIT_CAPTURE_START_ST;
            else
                next_state <= WAIT_CAPTURE_END_ST;
            end if;
            
        when WAIT_CAPTURE_END_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= WAIT_CAPTURE_START_ST;                
            elsif ( eoc = '0' ) then
                next_state <= WAIT_CAPTURE_END_ST;
            else
                next_state <= SEND_EOC_ACK_ST;
            end if;
            
        when SEND_EOC_ACK_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= WAIT_CAPTURE_START_ST;
            else
                next_state <= WAIT_TRANSFER_START_ST;
            end if;
            
        when WAIT_TRANSFER_START_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= WAIT_CAPTURE_START_ST;
            elsif ( TRANSFER_START_REG_r = '0' ) then
                next_state <= WAIT_TRANSFER_START_ST;
            else
                next_state <= WAIT_TRANSFER_END_ST;
            end if;            
            
        when WAIT_TRANSFER_END_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= WAIT_CAPTURE_START_ST;
            elsif ( eot = '0' ) then
                next_state <= WAIT_TRANSFER_END_ST;
            else
                next_state <= SEND_EOT_ACK_ST;
            end if;
            
        when SEND_EOT_ACK_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= WAIT_CAPTURE_START_ST;
            else
                next_state <= END_ST;
            end if;
            
        when END_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= WAIT_CAPTURE_START_ST;                
            elsif ( (CAPTURE_START_REG_r = '1') or (TRANSFER_START_REG_r='1') ) then
                next_state <= END_ST;
            else
                next_state <= WAIT_CAPTURE_START_ST;
            end if;
    end case;
end process;

-- Output logic.
process (current_state)
begin
capture_start_i     <= '0';
capture_end_i       <= '0';
transfer_start_i    <= '0';
transfer_end_i      <= '0';
eoc_ack_i           <= '0';
eot_ack_i           <= '0';
capture_mode        <= '0';
    case current_state is
        when WAIT_CAPTURE_START_ST =>
			capture_start_i     <= '0';
			capture_end_i       <= '0';
			transfer_start_i    <= '0';
			transfer_end_i      <= '0';
			eoc_ack_i           <= '0';
			eot_ack_i           <= '0';
			capture_mode        <= '1';
		
        when WAIT_CAPTURE_END_ST =>
			capture_start_i     <= '1';
			capture_end_i       <= '0';
			transfer_start_i    <= '0';
			transfer_end_i      <= '0';
			eoc_ack_i           <= '0';
			eot_ack_i           <= '0';
			capture_mode        <= '1';		
			
        when SEND_EOC_ACK_ST =>
			capture_start_i     <= '0';
			capture_end_i       <= '0';
			transfer_start_i    <= '0';
			transfer_end_i      <= '0';
			eoc_ack_i           <= '1';
			eot_ack_i           <= '0';
			capture_mode        <= '1';			
		
        when WAIT_TRANSFER_START_ST =>
			capture_start_i     <= '0';
			capture_end_i       <= '1';
			transfer_start_i    <= '0';
			transfer_end_i      <= '0';
			eoc_ack_i           <= '0';
			eot_ack_i           <= '0';
			capture_mode        <= '0';		
		
        when WAIT_TRANSFER_END_ST =>
			capture_start_i     <= '0';
			capture_end_i       <= '0';
			transfer_start_i    <= '1';
			transfer_end_i      <= '0';
			eoc_ack_i           <= '0';
			eot_ack_i           <= '0';
			capture_mode        <= '0';

        when SEND_EOT_ACK_ST =>
			capture_start_i     <= '0';
			capture_end_i       <= '0';
			transfer_start_i    <= '0';
			transfer_end_i      <= '0';
			eoc_ack_i           <= '0';
			eot_ack_i           <= '1';
			capture_mode        <= '0';			
		
        when END_ST =>
			capture_start_i     <= '0';
			capture_end_i       <= '0';
			transfer_start_i    <= '0';
			transfer_end_i      <= '1';
			eoc_ack_i           <= '0';
			eot_ack_i           <= '0';
			capture_mode        <= '0';
					
    end case;
end process;

-- Assign outputs.

-- END_REG
CAPTURE_END_REG     <= capture_end_i;
TRANSFER_END_REG    <= transfer_end_i;

-- Capture start:
-- Channel A : always used.
-- Channel B : used in dual and quad modes.
-- Channel C : used in quad mode.
-- Channel D : used in quad mode.
capture_start_cha <=    (CAPTURE_START_REG_r and capture_start_i);
capture_start_chb <=    (CAPTURE_START_REG_r and capture_start_i) when CH_MODE_REG_r = "01" else
                        (CAPTURE_START_REG_r and capture_start_i) when CH_MODE_REG_r = "10" else
                        '0';
capture_start_chc <=    (CAPTURE_START_REG_r and capture_start_i) when CH_MODE_REG_r = "10" else
                        '0';
capture_start_chd <=    (CAPTURE_START_REG_r and capture_start_i) when CH_MODE_REG_r = "10" else
                        '0';
                                             
eoc_ack <= eoc_ack_i;

-- Transfer ports.
transfer_start      <= transfer_start_i;
mem_dout_transfer   <= mem_dout_t;
eot_ack             <= eot_ack_i;

-- Memories.
mem_en_0    <= mem_en_0_i;
mem_we_0    <= mem_we_0_i;
mem_addr_0  <= mem_addr_0_i;
mem_din_0   <= mem_din_0_i;

mem_en_1    <= mem_en_1_i;
mem_we_1    <= mem_we_1_i;
mem_addr_1  <= mem_addr_1_i;
mem_din_1   <= mem_din_1_i;

mem_en_2    <= mem_en_2_i;
mem_we_2    <= mem_we_2_i;
mem_addr_2  <= mem_addr_2_i;
mem_din_2   <= mem_din_2_i;

mem_en_3    <= mem_en_3_i;
mem_we_3    <= mem_we_3_i;
mem_addr_3  <= mem_addr_3_i;
mem_din_3   <= mem_din_3_i;

end Behavioral;
