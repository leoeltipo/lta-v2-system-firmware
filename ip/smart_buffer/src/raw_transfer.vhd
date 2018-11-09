----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/03/2018 03:00:23 PM
-- Design Name: 
-- Module Name: raw_transfer - Behavioral
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

entity raw_transfer is
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
end raw_transfer;

architecture Behavioral of raw_transfer is

-- Constants.
constant BUF_SIZE_1 : integer := 2**N;
constant BUF_SIZE_2 : integer := BUF_SIZE_1/2;
constant BUF_SIZE_4 : integer := BUF_SIZE_2/2;

-- Registers.
signal CHA_SEL_REG_r         : STD_LOGIC_VECTOR (1 downto 0);
signal CHB_SEL_REG_r         : STD_LOGIC_VECTOR (1 downto 0);
signal CHC_SEL_REG_r         : STD_LOGIC_VECTOR (1 downto 0);
signal CHD_SEL_REG_r         : STD_LOGIC_VECTOR (1 downto 0);        
signal CH_MODE_REG_r        : STD_LOGIC_VECTOR (1 downto 0);     		
signal SPEED_CTRL_REG_r     : STD_LOGIC_VECTOR (15 downto 0);
signal RESET_REG_r          : STD_LOGIC;

-- Number of transfers.
signal ntran        : unsigned (2 downto 0);
signal ntran_r      : unsigned (2 downto 0);
signal cnt_ntran    : unsigned (2 downto 0);

-- Pointers.
signal ptr_start_s_cha      : signed (N+2 downto 0);
signal ptr_start_s_norm_cha : signed (N+2 downto 0);
signal ptr_cha              : unsigned (N-1 downto 0);

signal ptr_start_s_chb      : signed (N+2 downto 0);
signal ptr_start_s_norm_chb : signed (N+2 downto 0);
signal ptr_chb              : unsigned (N-1 downto 0);

signal ptr_start_s_chc      : signed (N+2 downto 0);
signal ptr_start_s_norm_chc : signed (N+2 downto 0);
signal ptr_chc              : unsigned (N-1 downto 0);

signal ptr_start_s_chd      : signed (N+2 downto 0);
signal ptr_start_s_norm_chd : signed (N+2 downto 0);
signal ptr_chd              : unsigned (N-1 downto 0);

-- Pointer to the actual address of the memory.
signal ptr_i                : unsigned (N-1 downto 0);
signal ptr_r                : unsigned (N-1 downto 0);

-- Actual number of samples.
signal nsamp_i              : unsigned (N downto 0);
signal nsamp_r              : unsigned (N downto 0);
signal cnt_nsamp            : unsigned (N downto 0);

-- One clock delay on address due to memory pipeline.
signal mem_addr_i : std_logic_vector (N-1 DOWNTO 0);
signal mem_addr_r : std_logic_vector (N-1 DOWNTO 0);

-- Offset.
signal offset_r : unsigned (N downto 0);

-- Maximum number of samples.
signal max_nsamp : unsigned (N downto 0);

-- Speed control.
signal cnt_delay : unsigned (15 downto 0);

-- State machine.
type fsm_state is ( INIT_ST,
                    COMPUTE_PTR_ST,
                    READ_IN_ST,
                    WRITE_OUT_ST,
					WAIT_DELAY_ST,
                    SEND_EOT_ST,
                    WAIT_EOT_ACK_ST,
                    END_ST);
signal current_state, next_state : fsm_state;

-- State signals.
signal init_state           : std_logic;
signal compute_ptr_state    : std_logic;
signal read_in_state        : std_logic;
signal write_out_state      : std_logic;
signal wait_delay_state     : std_logic;

-- Data out.
-- 20 bits from memory (18 sample, 2 header).
-- 2 bits channel id.
signal ready_out_i  : std_logic;
signal data_out_i   : std_logic_vector (21 downto 0);
signal data_out_r   : std_logic_vector (21 downto 0); 

-- eot.
signal eot_i : std_logic;

-- MSBs of memory for correct addressing (circular buffer mode).
signal addr_msb_i : std_logic_vector (1 downto 0);                    

begin

-- Number of transfers.
ntran <=    to_unsigned(1,ntran'length) when CH_MODE_REG_r = "00" else
            to_unsigned(2,ntran'length) when CH_MODE_REG_r = "01" else
            to_unsigned(4,ntran'length) when CH_MODE_REG_r = "10" else
            to_unsigned(1,ntran'length);

-- Maximum number of samples.
max_nsamp <=    to_unsigned(BUF_SIZE_1,max_nsamp'length) when CH_MODE_REG_r = "00" else
                to_unsigned(BUF_SIZE_2,max_nsamp'length) when CH_MODE_REG_r = "01" else
                to_unsigned(BUF_SIZE_4,max_nsamp'length) when CH_MODE_REG_r = "10" else
                to_unsigned(BUF_SIZE_1,max_nsamp'length);
                
-- Pointer calculation.
ptr_start_s_cha         <=  to_signed(to_integer(unsigned(ptr_last_cha)),ptr_start_s_cha'length) - 
                            to_signed(to_integer(unsigned(nsamp_cha)),ptr_start_s_cha'length);
ptr_start_s_norm_cha    <=  ptr_start_s_cha when ptr_start_s_cha >=0 else
                            ptr_start_s_cha + to_signed(to_integer(max_nsamp),ptr_start_s_cha'length);
ptr_cha                 <=  to_unsigned(to_integer(ptr_start_s_norm_cha),ptr_cha'length);                                                                                                      

ptr_start_s_chb         <=  to_signed(to_integer(unsigned(ptr_last_chb)),ptr_start_s_chb'length) - 
                            to_signed(to_integer(unsigned(nsamp_chb)),ptr_start_s_chb'length);
ptr_start_s_norm_chb    <=  ptr_start_s_chb when ptr_start_s_chb >=0 else
                            ptr_start_s_chb + to_signed(to_integer(max_nsamp),ptr_start_s_chb'length);
ptr_chb                 <=  to_unsigned(to_integer(ptr_start_s_norm_chb),ptr_chb'length);                                                                          

ptr_start_s_chc         <=  to_signed(to_integer(unsigned(ptr_last_chc)),ptr_start_s_chc'length) - 
                            to_signed(to_integer(unsigned(nsamp_chc)),ptr_start_s_chc'length);
ptr_start_s_norm_chc    <=  ptr_start_s_chc when ptr_start_s_chc >=0 else
                            ptr_start_s_chc + to_signed(to_integer(max_nsamp),ptr_start_s_chc'length);
ptr_chc                 <=  to_unsigned(to_integer(ptr_start_s_norm_chc),ptr_chc'length);                                                                          

ptr_start_s_chd         <=  to_signed(to_integer(unsigned(ptr_last_chd)),ptr_start_s_chd'length) - 
                            to_signed(to_integer(unsigned(nsamp_chd)),ptr_start_s_chd'length);
ptr_start_s_norm_chd    <=  ptr_start_s_chd when ptr_start_s_chd >=0 else
                            ptr_start_s_chd + to_signed(to_integer(max_nsamp),ptr_start_s_chd'length);
ptr_chd                 <=  to_unsigned(to_integer(ptr_start_s_norm_chd),ptr_chd'length);

-- Mux for pointer.
ptr_i <=    ptr_cha when cnt_ntran = to_unsigned(1,cnt_ntran'length) else
            ptr_chb when cnt_ntran = to_unsigned(2,cnt_ntran'length) else
            ptr_chc when cnt_ntran = to_unsigned(3,cnt_ntran'length) else
            ptr_chd when cnt_ntran = to_unsigned(4,cnt_ntran'length) else
            ptr_cha;
            
-- Mux for number of samples.
nsamp_i <=  unsigned(nsamp_cha) when cnt_ntran = to_unsigned(1,cnt_ntran'length) else
            unsigned(nsamp_chb) when cnt_ntran = to_unsigned(2,cnt_ntran'length) else
            unsigned(nsamp_chc) when cnt_ntran = to_unsigned(3,cnt_ntran'length) else
            unsigned(nsamp_chd) when cnt_ntran = to_unsigned(4,cnt_ntran'length) else
            unsigned(nsamp_cha);

-- Addr MSB mux.
-- NOTE: the numbers in cnt_ntran must be added 1!!
-- First transaction, 2
-- Second transaction, 3
-- Third transaction, 4
-- Fourth transaction, 5
addr_msb_i <=   ptr_r(N-1)  &  ptr_r(N-2)   when ( (CH_MODE_REG_r = "00") ) else
                '0'         &  ptr_r(N-2)   when ( (CH_MODE_REG_r = "01") and (cnt_ntran = to_unsigned(2,cnt_ntran'length)) ) else
                '1'         &  ptr_r(N-2)   when ( (CH_MODE_REG_r = "01") and (cnt_ntran = to_unsigned(3,cnt_ntran'length)) ) else
                '0'         & '0'           when ( (CH_MODE_REG_r = "10") and (cnt_ntran = to_unsigned(2,cnt_ntran'length)) ) else
                '0'         & '1'           when ( (CH_MODE_REG_r = "10") and (cnt_ntran = to_unsigned(3,cnt_ntran'length)) ) else
                '1'         & '0'           when ( (CH_MODE_REG_r = "10") and (cnt_ntran = to_unsigned(4,cnt_ntran'length)) ) else
                '1'         & '1'           when ( (CH_MODE_REG_r = "10") and (cnt_ntran = to_unsigned(5,cnt_ntran'length)) ) else
                "00";  

-- data_out_i.
-- +1 cnt_ntran.     
data_out_i <=   CHA_SEL_REG_r & mem_dout when cnt_ntran = to_unsigned(2,cnt_ntran'length) else 
                CHB_SEL_REG_r & mem_dout when cnt_ntran = to_unsigned(3,cnt_ntran'length) else
                CHC_SEL_REG_r & mem_dout when cnt_ntran = to_unsigned(4,cnt_ntran'length) else
                CHD_SEL_REG_r & mem_dout when cnt_ntran = to_unsigned(5,cnt_ntran'length) else
                CHA_SEL_REG_r & mem_dout;                		
  
-- Address memory generation.
mem_addr_i <= addr_msb_i & std_logic_vector(ptr_r(N-3 downto 0));
       		
-- Registers.
process (rst, clk)
begin
    if ( rst = '1' ) then
        -- State register.
        current_state <= INIT_ST;
        
        -- Registers.
        CHA_SEL_REG_r       <= (others => '0');
        CHB_SEL_REG_r       <= (others => '0');
        CHC_SEL_REG_r       <= (others => '0');
        CHD_SEL_REG_r       <= (others => '0');        
        CH_MODE_REG_r       <= (others => '0');
        SPEED_CTRL_REG_r    <= (others => '0');
        RESET_REG_r         <= '0';
        
        -- Number of transfers.
        ntran_r <= (others => '0');
        cnt_ntran <= (others => '0');
        
        -- Number of samples.
        cnt_nsamp <= (others => '0');
        
        -- Pointer to memory's address.
        ptr_r <= (others => '0');
        
        -- Actual number of samples.
        nsamp_r <= (others => '0');
        
        -- Speed control.
        cnt_delay <= (others => '0');
        
        -- Data out.
        data_out_r <= (others => '0');
        
        -- Offset.
        offset_r <= (others => '0');
        
        -- 1 clock cycle delay on mem_addr due to memory pipeline.
        mem_addr_r <= (others => '0');
    
    elsif ( rising_edge(clk) ) then
        -- State register.
        current_state <= next_state;
    
        -- Registers.
        CHA_SEL_REG_r       <= CHA_SEL_REG;        
        CHB_SEL_REG_r       <= CHB_SEL_REG;
        CHC_SEL_REG_r       <= CHC_SEL_REG;
        CHD_SEL_REG_r       <= CHD_SEL_REG;
        CH_MODE_REG_r       <= CH_MODE_REG;      		
        SPEED_CTRL_REG_r    <= SPEED_CTRL_REG;
        RESET_REG_r         <= RESET_REG;          
	
	   -- 1 clock cycle delay on mem_addr due to memory pipeline.
	   mem_addr_r <= mem_addr_i;
	   
	   if ( init_state = '1') then
	       ntran_r     <= ntran;
	       cnt_ntran   <= to_unsigned(1,cnt_ntran'length);
	       offset_r    <= (others => '0');	       	       
	   elsif ( compute_ptr_state = '1' ) then
	       -- Load starting pointer and number of samples.	       	                
           ptr_r    <= ptr_i + resize(offset_r,ptr_i'length);
           offset_r <= offset_r + max_nsamp;       
	       
	       if (nsamp_i > max_nsamp ) then
	           nsamp_r <= max_nsamp;
	       else
	           nsamp_r <= nsamp_i;
	       end if;
	       
	       -- Increment number of transfers counter.
	       cnt_ntran <= cnt_ntran + 1;
	       
	       -- Reset samples counter.
	       cnt_nsamp <= (others => '0');
	   elsif ( read_in_state = '1' ) then
	       cnt_nsamp   <= cnt_nsamp + 1;
	       cnt_delay   <= (others => '0');	       
	       ptr_r <= ptr_r + 1;	             
	   elsif ( write_out_state = '1' ) then
	       data_out_r <= data_out_i;
	   elsif ( wait_delay_state = '1' ) then
	       cnt_delay <= cnt_delay + 1;	         	       	       
	   end if;
    end if;
end process;

-- Next state logic.
process (current_state, RESET_REG_r, transfer_start, cnt_delay, SPEED_CTRL_REG_r, cnt_nsamp, nsamp_r, cnt_ntran, ntran_r, eot_ack)
begin
    case current_state is
        when INIT_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            elsif ( transfer_start = '0' ) then
                next_state <= INIT_ST;
            else
                next_state <= COMPUTE_PTR_ST;
            end if;
            
        when COMPUTE_PTR_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            else
                next_state <= READ_IN_ST;
            end if;
            
        when READ_IN_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            else                
                next_state <= WRITE_OUT_ST;
            end if;
        
        when WRITE_OUT_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            else
                next_state <= WAIT_DELAY_ST;
            end if;                
                
        when WAIT_DELAY_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;                        
            -- Wait until delay has finished.
            elsif ( cnt_delay < unsigned(SPEED_CTRL_REG_r) ) then           
                next_state <= WAIT_DELAY_ST;    
            else
				-- Check is there are more samples to send for the current transfer.
                if ( cnt_nsamp < nsamp_r ) then
                    next_state <= READ_IN_ST;
                else
                    -- Check if there are more transactions pending.
                    if ( cnt_ntran <= ntran_r ) then
                        next_state <= COMPUTE_PTR_ST;
                    else
                        next_state <= SEND_EOT_ST;
                    end if;            
                end if;
            end if;
        
        when SEND_EOT_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;        
            elsif ( eot_ack = '0' ) then
                next_state <= SEND_EOT_ST;
            else
                next_state <= WAIT_EOT_ACK_ST;
            end if;
        
        when WAIT_EOT_ACK_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            elsif ( eot_ack = '1' ) then
                next_state <= WAIT_EOT_ACK_ST;
            else 
                next_state <= END_ST;
            end if;
            
        when END_ST =>
            if ( RESET_REG_r = '1' ) then
                next_state <= INIT_ST;
            elsif ( transfer_start = '1' ) then
                next_state <= END_ST;
            else
                next_state <= INIT_ST;
            end if;
    end case;
end process;
            
-- Output Logic.
process (current_state)
begin
init_state          <= '0';
compute_ptr_state   <= '0';
read_in_state       <= '0';
write_out_state     <= '0';
wait_delay_state    <= '0';
eot_i               <= '0';
    case current_state is
        when INIT_ST =>
			init_state          <= '1';
			compute_ptr_state   <= '0';
			read_in_state       <= '0';
			write_out_state     <= '0';
			wait_delay_state    <= '0';
			eot_i               <= '0';
			
        when COMPUTE_PTR_ST =>
			init_state          <= '0';
			compute_ptr_state   <= '1';
			read_in_state       <= '0';
			write_out_state     <= '0';
			wait_delay_state    <= '0';			
			eot_i               <= '0';		
		
        when READ_IN_ST =>       
			init_state          <= '0';
			compute_ptr_state   <= '0';
			read_in_state       <= '1';
			write_out_state     <= '0';
			wait_delay_state    <= '0';
			eot_i               <= '0';
			
        when WRITE_OUT_ST =>
			init_state          <= '0';
			compute_ptr_state   <= '0';
			read_in_state       <= '0';
			write_out_state     <= '1';
			wait_delay_state    <= '0';
			eot_i               <= '0';		
		
        when WAIT_DELAY_ST =>          
			init_state          <= '0';
			compute_ptr_state   <= '0';
			read_in_state       <= '0';
			write_out_state     <= '0';
			wait_delay_state    <= '1';
			eot_i               <= '0';
		
        when SEND_EOT_ST =>
			init_state          <= '0';
			compute_ptr_state   <= '0';
			read_in_state       <= '0';
			write_out_state     <= '0';
			wait_delay_state    <= '0';
			eot_i               <= '1';		
		
        when WAIT_EOT_ACK_ST =>
			init_state          <= '0';
			compute_ptr_state   <= '0';
			read_in_state       <= '0';
			write_out_state     <= '0';
			wait_delay_state    <= '0';
			eot_i               <= '0';		
		
        when END_ST =>    
			init_state          <= '0';
			compute_ptr_state   <= '0';
			read_in_state       <= '0';
			write_out_state     <= '0';
			wait_delay_state    <= '0';
			eot_i               <= '0';		
		
    end case;
end process;


-- Assign outputs.
mem_en      <= read_in_state;
mem_we(0)   <= '0'; 
--mem_addr    <= addr_msb_i & std_logic_vector(ptr_r(N-3 downto 0));                            
mem_addr    <= mem_addr_r;

ready_out_i <= wait_delay_state;       

-- +1 cnt_ntran.       
ready_out <=  ready_out_i;
data_out  <=  data_out_r;
			               
-- EOT signals.
eot <= eot_i;
            
end Behavioral;
