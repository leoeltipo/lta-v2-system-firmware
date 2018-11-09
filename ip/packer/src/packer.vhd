----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2018 02:00:14 PM
-- Design Name: 
-- Module Name: packer - Behavioral
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

entity packer is
    Port ( rst : in STD_LOGIC;
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
           dout : out STD_LOGIC_VECTOR (63 downto 0));
end packer;

architecture Behavioral of packer is

-- ID: 0, 1, 2 and 3.
component raw_rw is
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
end component;

-- ID: 4, 5, 6 and 7.
component raw_smart_buffer_rw is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           ready_in : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (21 downto 0);
           START_REG : in STD_LOGIC;
           dready : out STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (63 downto 0));
end component;

-- ID: 8, 9 10 and 11.
component pix_rw is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           ready_a : in STD_LOGIC;
           data_a : in STD_LOGIC_VECTOR (31 downto 0);
           ready_b : in STD_LOGIC;
           data_b : in STD_LOGIC_VECTOR (31 downto 0);
           ready_c : in STD_LOGIC;
           data_c : in STD_LOGIC_VECTOR (31 downto 0);
           ready_d : in STD_LOGIC;
           data_d : in STD_LOGIC_VECTOR (31 downto 0);
           SOURCE_REG : in STD_LOGIC_VECTOR (3 downto 0);
           START_REG : in STD_LOGIC;
           dready : out STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (63 downto 0));
end component;

-- ID: 12, 13, 14 and 15.
component pix_seq_1ch_rw is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           ready_a : in STD_LOGIC;
           data_a : in STD_LOGIC_VECTOR (31 downto 0);
           ready_b : in STD_LOGIC;
           data_b : in STD_LOGIC_VECTOR (31 downto 0);
           ready_c : in STD_LOGIC;
           data_c : in STD_LOGIC_VECTOR (31 downto 0);
           ready_d : in STD_LOGIC;
           data_d : in STD_LOGIC_VECTOR (31 downto 0);
           START_REG : in STD_LOGIC;
           dready : out STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (63 downto 0);
           ack_dout : in STD_LOGIC);
end component;

signal dready_raw : std_logic;
signal dout_raw : std_logic_vector (63 downto 0);

signal dready_raw_smart_buffer : std_logic;
signal dout_raw_smart_buffer : std_logic_vector (63 downto 0);

signal dready_pix : std_logic;
signal dout_pix : std_logic_vector (63 downto 0);

signal dready_pix_seq_1ch : std_logic;
signal dout_pix_seq_1ch : std_logic_vector (63 downto 0);
signal ack_dout_pix_seq_1ch : std_logic; 

signal dready_i : std_logic;
signal dout_i : std_logic_vector (63 downto 0);
signal dout_r : std_logic_vector (63 downto 0);

signal dack_i : std_logic;

signal ready_i : std_logic;
signal write_out_e : std_logic;

signal cnt : unsigned (3 downto 0);

-- State machine.
type fsm_state is (INIT,WRITE_OUT,SEND_READY1,SEND_READY2,WAIT_ACK);
signal current_state, next_state : fsm_state;

begin

raw_rw_i : raw_rw
    Port map ( 
        rst         => rst,
        clk         => clk,
        ready_a     => rready_a,
        data_a      => rdata_a,
        ready_b     => rready_b,
        data_b      => rdata_b,
        ready_c     => rready_c,
        data_c      => rdata_c,
        ready_d     => rready_d,
        data_d      => rdata_d,
        header      => header,
        SOURCE_REG  => SOURCE_REG,
        START_REG   => START_REG,
        dready      => dready_raw,
        dout        => dout_raw
        );
           
raw_smart_buffer_rw_i : raw_smart_buffer_rw
    Port map ( 
        rst         => rst,
        clk         => clk,
        ready_in    => rready_smart_buffer,
        data_in     => rdata_smart_bufffer,
        START_REG   => START_REG,
        dready      => dready_raw_smart_buffer,
        dout        => dout_raw_smart_buffer
        );
                                                                                                                                                    
pix_rw_i : pix_rw
    Port map ( 
        rst         => rst,
        clk         => clk,
        ready_a     => pready_a,
        data_a      => pdata_a,
        ready_b     => pready_b,
        data_b      => pdata_b,
        ready_c     => pready_c,
        data_c      => pdata_c,
        ready_d     => pready_d,
        data_d      => pdata_d,
        SOURCE_REG  => SOURCE_REG,
        START_REG   => START_REG,
        dready      => dready_pix,
        dout        => dout_pix
        );           

pix_seq_1ch_rw_i : pix_seq_1ch_rw
    Port map ( 
        rst         => rst,
        clk         => clk,
        ready_a     => pready_a,
        data_a      => pdata_a,
        ready_b     => pready_b,
        data_b      => pdata_b,
        ready_c     => pready_c,
        data_c      => pdata_c,
        ready_d     => pready_c,
        data_d      => pdata_d,
        START_REG => START_REG,
        dready      => dready_pix_seq_1ch,
        dout        => dout_pix_seq_1ch,
        ack_dout    => ack_dout_pix_seq_1ch                       
        );
        
ack_dout_pix_seq_1ch <= ready_i;
         
-- Mux.
-- SOURCE:
-- 0 : RAW CHA (real time).
-- 1 : RAW CHB (real time).
-- 2 : RAW CHC (real time).
-- 3 : RAW CHD (real time).
-- 4 : RAW from Smart Buffer.
-- 5 : CDS CHA.
-- 6 : CDS CHB.
-- 7 : CDS CHC.
-- 8 : CDS CHD.
-- 9 : CDS 4 channels, sequential, one channel at a time.
dready_i <= dready_raw                  when SOURCE_REG = "0000" else
            dready_raw                  when SOURCE_REG = "0001" else
            dready_raw                  when SOURCE_REG = "0010" else
            dready_raw                  when SOURCE_REG = "0011" else
            dready_raw_smart_buffer     when SOURCE_REG = "0100" else
            dready_pix                  when SOURCE_REG = "0101" else
            dready_pix                  when SOURCE_REG = "0110" else
            dready_pix                  when SOURCE_REG = "0111" else
            dready_pix                  when SOURCE_REG = "1000" else            
            dready_pix_seq_1ch          when SOURCE_REG = "1001" else
            dready_raw;

dout_i <=   std_logic_vector(cnt) & dout_raw(59 downto 0)               when SOURCE_REG = "0000" else
            std_logic_vector(cnt) & dout_raw(59 downto 0)               when SOURCE_REG = "0001" else
            std_logic_vector(cnt) & dout_raw(59 downto 0)               when SOURCE_REG = "0010" else
            std_logic_vector(cnt) & dout_raw(59 downto 0)               when SOURCE_REG = "0011" else
            std_logic_vector(cnt) & dout_raw_smart_buffer(59 downto 0)  when SOURCE_REG = "0100" else
            std_logic_vector(cnt) & dout_pix(59 downto 0)               when SOURCE_REG = "0101" else
            std_logic_vector(cnt) & dout_pix(59 downto 0)               when SOURCE_REG = "0110" else
            std_logic_vector(cnt) & dout_pix(59 downto 0)               when SOURCE_REG = "0111" else
            std_logic_vector(cnt) & dout_pix(59 downto 0)               when SOURCE_REG = "1000" else            
            std_logic_vector(cnt) & dout_pix_seq_1ch (59 downto 0)      when SOURCE_REG = "1001" else
            std_logic_vector(cnt) & dout_raw(59 downto 0);
                    
-- Ack signal.
dack_i <= dack;                    
                    
process (rst,clk)
begin
    if (rst = '1') then
        current_state <= INIT;
        dout_r <= (others => '0');
        cnt <= (others => '0');
    elsif (clk'event and clk = '1') then
        current_state <= next_state;
        if (write_out_e = '1') then
            dout_r <= dout_i;
            cnt <= cnt + 1;
        end if;
    end if;
end process;

-- Next state logic.
process (current_state, dready_i,dack_i,START_REG)
begin
    case current_state is
        when INIT =>
            if (START_REG = '1') then
                if (dready_i = '1') then
                    next_state <= WRITE_OUT;
                else
                    next_state <= INIT;
                end if;
            end if;                
            
        when WRITE_OUT =>
            next_state <= SEND_READY1;
            
        when SEND_READY1 =>
            next_state <= SEND_READY2;
            
        when SEND_READY2 =>
            next_state <= WAIT_ACK;
            
        when WAIT_ACK =>
            if (dack_i = '1') then
                next_state <= INIT;
            else
                next_state <= WAIT_ACK;            
            end if;

    end case;
end process;

-- Output logic.
process (current_state)
begin
write_out_e <= '0';
ready_i <= '0';
    case current_state is
        when INIT =>
            write_out_e <= '0';
            ready_i <= '0';
            
        when WRITE_OUT =>
            write_out_e <= '1';
            ready_i <= '0';
            
        when SEND_READY1 =>
            write_out_e <= '0';
            ready_i <= '1';
            
        when SEND_READY2 =>
            write_out_e <= '0';
            ready_i <= '1';            
                
        when WAIT_ACK =>
            write_out_e <= '0';
            ready_i <= '0';
      
    end case;
end process;

-- Assign outputs.
dready <= ready_i;
dout <= dout_r;                 

end Behavioral;
