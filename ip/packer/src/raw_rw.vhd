----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2018 02:07:02 PM
-- Design Name: 
-- Module Name: raw_rw - Behavioral
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

entity raw_rw is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           ready_a : in STD_LOGIC;
           data_a : in STD_LOGIC_VECTOR (17 downto 0);
           ready_b : in STD_LOGIC;
           data_b : in STD_LOGIC_VECTOR (17 downto 0);
           ready_c : in STD_LOGIC;
           data_c : in STD_LOGIC_VECTOR (17 downto 0);
           ready_d : in STD_LOGIC;
           data_d : in STD_LOGIC_VECTOR (17 downto 0);
           header : in STD_LOGIC_VECTOR (1 downto 0);
           SOURCE_REG : in STD_LOGIC_VECTOR (3 downto 0);
           START_REG : in STD_LOGIC;
           dready : out STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (63 downto 0));
end raw_rw;

architecture Behavioral of raw_rw is

component synchronizer is 
	generic (
		N : Integer := 2
	);
	port (
		rst		    : in std_logic;
		clk 		: in std_logic;
		data_in		: in std_logic;
		data_out	: out std_logic
	);
end component;

signal ready_a_resync   : std_logic;
signal ready_b_resync : std_logic;
signal ready_c_resync : std_logic;
signal ready_d_resync : std_logic;
signal data_a_d         : std_logic_vector (data_a'length - 1 downto 0);
signal data_a_dd        : std_logic_vector (data_a'length - 1 downto 0);
signal data_b_d         : std_logic_vector (data_b'length - 1 downto 0);
signal data_b_dd        : std_logic_vector (data_b'length - 1 downto 0);
signal data_c_d         : std_logic_vector (data_c'length - 1 downto 0);
signal data_c_dd        : std_logic_vector (data_c'length - 1 downto 0);
signal data_d_d         : std_logic_vector (data_d'length - 1 downto 0);
signal data_d_dd        : std_logic_vector (data_d'length - 1 downto 0);
signal header_resync    : std_logic_vector (1 downto 0);

signal read_in : std_logic;
signal ready_i : std_logic;
signal data_i : std_logic_vector (17 downto 0);

signal data_r : std_logic_vector (17 downto 0);
signal data_rr : std_logic_vector (17 downto 0);
signal data_rrr : std_logic_vector (17 downto 0);

signal cnt : unsigned (1 downto 0);

signal dready_r : std_logic;
signal read_out_s : std_logic;
signal dout_i : std_logic_vector (63 downto 0);
signal dout_r : std_logic_vector (63 downto 0);

signal zeros_4 : std_logic_vector (3 downto 0) := "0000";

-- State machine.
type fsm_state is (INIT,READ,WAIT_END,CHECK_CNT,READ_OUT);
signal current_state, next_state : fsm_state;

begin

-- ready_a_resync.
ready_a_resync_i : synchronizer 
	generic map (
		N => 2
	)
	port map (
		rst		    => rst,
		clk 		=> clk,
		data_in		=> ready_a,
		data_out	=> ready_a_resync
	);

-- ready_b_resync.
ready_b_resync_i : synchronizer 
	generic map (
		N => 2
	)
	port map (
		rst		    => rst,
		clk 		=> clk,
		data_in		=> ready_b,
		data_out	=> ready_b_resync
	);
	
-- ready_c_resync.
ready_c_resync_i : synchronizer 
	generic map (
		N => 2
	)
	port map (
		rst		    => rst,
		clk 		=> clk,
		data_in		=> ready_c,
		data_out	=> ready_c_resync
	);
	
-- ready_d_resync.
ready_d_resync_i : synchronizer 
	generic map (
		N => 2
	)
	port map (
		rst		    => rst,
		clk 		=> clk,
		data_in		=> ready_d,
		data_out	=> ready_d_resync
	);
		
-- NOTE: header vector can be re-synced as bits do not change simultaneously.		
-- header_0_resync.
header_0_resync_i : synchronizer 
    generic map (
        N => 2
    )
    port map (
        rst         => rst,
        clk         => clk,
        data_in     => header(0),
        data_out    => header_resync(0)
    );
        	
-- header_1_resync.
header_1_resync_i : synchronizer 
    generic map (
        N => 2
    )
    port map (
        rst         => rst,
        clk         => clk,
        data_in     => header(1),
        data_out    => header_resync(1)
    );
	
process (rst,clk)
begin
    if (rst = '1') then
        -- State register.
        current_state <= INIT;
        
        -- 2 clk pipe for re-sync.
        data_a_d    <= (others => '0');
        data_a_dd   <= (others => '0'); 
        data_b_d    <= (others => '0');
        data_b_dd   <= (others => '0');
        data_c_d    <= (others => '0');
        data_c_dd   <= (others => '0');
        data_d_d    <= (others => '0');
        data_d_dd   <= (others => '0');
        
        -- Data registers (store last 3 samples).                
        data_r <= (others => '0');
        data_rr <= (others => '0');
        data_rrr <= (others => '0');
        
        -- Counter.
        cnt <= (others => '0');
        
        dready_r <= '0';
        dout_r <= (others => '0');
    elsif (clk'event and clk = '1') then
        -- State register.
        current_state <= next_state;
        
        -- 2 clk pipe for re-sync.
        data_a_d    <= data_a;
        data_a_dd   <= data_a_d;
        data_b_d    <= data_b;
        data_b_dd   <= data_b_d;
        data_c_d    <= data_c;
        data_c_dd   <= data_c_d;
        data_d_d    <= data_d;
        data_d_dd   <= data_d_d;                        
        
        -- Data registers (last 3 samples).
        if (read_in = '1') then
            data_r <= data_i;
            data_rr <= data_r;
            data_rrr <= data_rr;
            if (cnt < to_unsigned(2,cnt'length)) then
                cnt <= cnt + 1;
            else
                cnt <= (others => '0');
            end if;           
        end if;
        if (read_out_s = '1') then
            dout_r <= dout_i;
        end if;
        dready_r <= read_out_s;
    end if;
end process;

-- Input mux.
ready_i <=  ready_a_resync when SOURCE_REG = "0000" else
            ready_b_resync when SOURCE_REG = "0001" else
            ready_c_resync when SOURCE_REG = "0010" else
            ready_d_resync when SOURCE_REG = "0011" else
            ready_a_resync;
            
data_i <=   data_a_dd when SOURCE_REG = "0000" else
            data_b_dd when SOURCE_REG = "0001" else
            data_c_dd when SOURCE_REG = "0010" else
            data_d_dd when SOURCE_REG = "0011" else
            data_a_dd;            

-- Output packet.
dout_i <=   zeros_4 & "0000" & header_resync & data_r & data_rr & data_rrr when SOURCE_REG = "0000" else
            zeros_4 & "0001" & header_resync & data_r & data_rr & data_rrr when SOURCE_REG = "0001" else
            zeros_4 & "0010" & header_resync & data_r & data_rr & data_rrr when SOURCE_REG = "0010" else
            zeros_4 & "0011" & header_resync & data_r & data_rr & data_rrr when SOURCE_REG = "0011" else
            zeros_4 & "0000" & header_resync & data_r & data_rr & data_rrr;
            
-- Next state logic.
process(current_state,ready_i,START_REG)
begin
    case current_state is        
        when INIT =>
            if (START_REG = '1') then
                if (ready_i = '0') then
                    next_state <= INIT;
                else
                    next_state <= READ;
                end if;
            end if;
            
        when READ =>            
            next_state <= WAIT_END;           
            
        when WAIT_END =>
            if (ready_i = '1') then
                next_state <= WAIT_END;
            else
                next_state <= CHECK_CNT;
            end if;
            
        when CHECK_CNT =>
            if (cnt = "10") then
                next_state <= READ_OUT;
            else
                next_state <= INIT;
            end if;
       
        when READ_OUT =>
            next_state <= INIT;            
    end case;
end process;

-- Output logic.
process(current_state)
begin
read_in <= '0';
read_out_s <= '0';
    case current_state is
        when INIT =>
            read_in <= '0';
            read_out_s <= '0';
            
        when READ =>
            read_in <= '1';
            read_out_s <= '0';            
            
        when WAIT_END =>
            read_in <= '0';
            read_out_s <= '0';
            
        when CHECK_CNT =>
            read_in <= '0';
            read_out_s <= '0';
                
        when READ_OUT =>
            read_in <= '0';
            read_out_s <= '1';                            
    end case;
end process;

-- Assign outputs.
dready <= dready_r;
dout <= dout_r;

end Behavioral;
