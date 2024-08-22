-------------------------------------------------------------------
-- Name        : de10_lite.vhd
-- Author      : 
-- Version     : 0.1
-- Copyright   : Departamento de Eletrônica, Florianópolis, IFSC
-- Description : Projeto base DE10-Lite
-------------------------------------------------------------------
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Importando o pacote de conversão BCD para 7 segmentos
use work.bcd_to_7seg_pkg.all;

entity de10_lite is 
    port (
        ---------- CLOCK ----------
        ADC_CLK_10: in std_logic;
        MAX10_CLK1_50: in std_logic;
        MAX10_CLK2_50: in std_logic;
        
        ----------- SDRAM ------------
        DRAM_ADDR: out std_logic_vector (12 downto 0);
        DRAM_BA: out std_logic_vector (1 downto 0);
        DRAM_CAS_N: out std_logic;
        DRAM_CKE: out std_logic;
        DRAM_CLK: out std_logic;
        DRAM_CS_N: out std_logic;        
        DRAM_DQ: inout std_logic_vector(15 downto 0);
        DRAM_LDQM: out std_logic;
        DRAM_RAS_N: out std_logic;
        DRAM_UDQM: out std_logic;
        DRAM_WE_N: out std_logic;
        
        ----------- SEG7 ------------
        HEX0: out std_logic_vector(7 downto 0);
        HEX1: out std_logic_vector(7 downto 0);
        HEX2: out std_logic_vector(7 downto 0);
        HEX3: out std_logic_vector(7 downto 0);
        HEX4: out std_logic_vector(7 downto 0);
        HEX5: out std_logic_vector(7 downto 0);

        ----------- KEY ------------
        KEY: in std_logic_vector(1 downto 0);

        ----------- LED ------------
        LEDR: out std_logic_vector(9 downto 0);

        ----------- SW ------------
        SW: in std_logic_vector(9 downto 0);

        ----------- VGA ------------
        VGA_B: out std_logic_vector(3 downto 0);
        VGA_G: out std_logic_vector(3 downto 0);
        VGA_HS: out std_logic;
        VGA_R: out std_logic_vector(3 downto 0);
        VGA_VS: out std_logic;
    
        ----------- Accelerometer ------------
        GSENSOR_CS_N: out std_logic;
        GSENSOR_INT: in std_logic_vector(2 downto 1);
        GSENSOR_SCLK: out std_logic;
        GSENSOR_SDI: inout std_logic;
        GSENSOR_SDO: inout std_logic;
    
        ----------- Arduino ------------
        ARDUINO_IO: inout std_logic_vector(15 downto 0);
        ARDUINO_RESET_N: inout std_logic
    );
end entity;


architecture rtl of de10_lite is

    -- Sinais para os semáforos e contadores
    signal clk           : std_logic;
    signal rst           : std_logic;
    signal start         : std_logic;
    signal r1            : std_logic;
    signal y1            : std_logic;
    signal g1            : std_logic;
    signal r2            : std_logic;
    signal y2            : std_logic;
    signal g2            : std_logic;
    signal tempo_contagem: unsigned(15 downto 0);
    signal count_out     : unsigned(7 downto 0);
    signal clk_div       : std_logic := '0';
    signal source        : std_logic_vector(15 downto 0);
    signal probe         : std_logic_vector(7 downto 0);
    signal tempo_contagem1: unsigned(7 downto 0);
    signal tempo_contagem2: unsigned(7 downto 0);
    signal counter1      : unsigned(7 downto 0);
    signal counter2      : unsigned(7 downto 0);
    signal event_counter1 : unsigned(7 downto 0);
    signal event_counter2 : unsigned(7 downto 0);
    signal signal_counter_probe : unsigned(7 downto 0);
    signal signal_counter : unsigned(7 downto 0);

    -- Sinais para os displays de 7 segmentos
    signal hex0_data : std_logic_vector(7 downto 0);
    signal hex1_data : std_logic_vector(7 downto 0);
    signal hex2_data : std_logic_vector(7 downto 0);
    signal hex3_data : std_logic_vector(7 downto 0);
    signal hex4_data : std_logic_vector(7 downto 0);
    signal hex5_data : std_logic_vector(7 downto 0);

    component unnamed is
        port (
            source : out std_logic_vector(15 downto 0);                    -- source
            probe  : in  std_logic_vector(7 downto 0) := (others => 'X')  -- probe
        );
    end component unnamed;
    
    component counter is
        generic (
            DATA_WIDTH_OUT : integer := 7
        );
        port (
            clk       : in std_logic; 
            aclr_n    : in std_logic; 
            count_out : out unsigned(DATA_WIDTH_OUT downto 0)
        );
    end component counter;

begin
    u0 : component unnamed
        port map(
            source => source,
            probe  => probe
        );

    probe <= std_logic_vector(signal_counter);
    signal_counter <= signal_counter_probe;
    tempo_contagem1 <= unsigned(source(7 downto 0));
    tempo_contagem2 <= unsigned(source(15 downto 8));
    tempo_contagem <= unsigned(source);

    -- Divisor de Clock para gerar um sinal de clock mais lento
    process(MAX10_CLK1_50)
        variable counter : integer := 0;
    begin
        if rising_edge(MAX10_CLK1_50) then
            counter := counter + 1;
            if counter = 50000000 then 
                clk_div <= not clk_div;
                counter := 0;
            end if;
        end if;
    end process;

    -- Contador síncrono
    u_counter : counter
    generic map (
        DATA_WIDTH_OUT => 7
    )
    port map (
        clk       => clk_div,
        aclr_n    => SW(2),
        count_out => count_out
    );

    -- Instância do DUT 
    dut : entity work.semaforo
        port map(
            clk	     => clk_div,
            rst     => SW(1),
            start   => SW(0),
            tempo_contagem => tempo_contagem,
            r1      => LEDR(0),
            r2      => LEDR(1),
            y1      => LEDR(2),
            y2      => LEDR(3),
            g1      => LEDR(4),
            g2      => LEDR(5),
            counter1 => counter1,
            counter2 => counter2,
            event_counter1 => event_counter1,
            event_counter2 => event_counter2
        );

    -- Convertendo os valores de contagem para displays de 7 segmentos
    process(counter1, counter2, event_counter1, event_counter2)
    begin
        -- Display HEX0 e HEX1 mostram counter1
        hex0_data <= convert_8bits_to_dual_7seg(std_logic_vector(counter1))(7 downto 0);
        hex1_data <= convert_8bits_to_dual_7seg(std_logic_vector(counter1))(15 downto 8);

        -- Display HEX2 e HEX3 mostram counter2
        hex2_data <= convert_8bits_to_dual_7seg(std_logic_vector(counter2))(7 downto 0);
        hex3_data <= convert_8bits_to_dual_7seg(std_logic_vector(counter2))(15 downto 8);

        -- Display HEX4 e HEX5 mostram os contadores de eventos
        hex4_data <= convert_8bits_to_dual_7seg(std_logic_vector(event_counter1))(7 downto 0);
        hex5_data <= convert_8bits_to_dual_7seg(std_logic_vector(event_counter2))(7 downto 0);
    end process;

    -- Atribuindo os valores convertidos aos displays
    HEX0 <= hex0_data;
    HEX1 <= hex1_data;
    HEX2 <= hex2_data;
    HEX3 <= hex3_data;
    HEX4 <= hex4_data;
    HEX5 <= hex5_data;

end architecture rtl;
