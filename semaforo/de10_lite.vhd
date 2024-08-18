-------------------------------------------------------------------
-- Name        : de0_lite.vhd
-- Author      : 
-- Version     : 0.1
-- Copyright   : Departamento de Eletrônica, Florianópolis, IFSC
-- Description : Projeto base DE10-Lite
-------------------------------------------------------------------
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity de10_lite is 
	port (
		---------- CLOCK ----------
		ADC_CLK_10:	in std_logic;
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

    signal clk           : std_logic;
    signal rst           : std_logic;
    signal start         : std_logic;
    signal r1            : std_logic;         -- Sinal de saída para o vermelho do primeiro semáforo
    signal y1            : std_logic;         -- Sinal de saída para o amarelo do primeiro semáforo
    signal g1            : std_logic;         -- Sinal de saída para o verde do primeiro semáforo
    signal r2            : std_logic;         -- Sinal de saída para o vermelho do segundo semáforo
    signal y2            : std_logic;         -- Sinal de saída para o amarelo do segundo semáforo
    signal g2            : std_logic;         -- Sinal de saída para o verde do segundo semáforo
    signal tempo_contagem: unsigned(15 downto 0);
    signal count_out     : unsigned(7 downto 0);
    signal clk_div       : std_logic := '0'; -- Sinal de clock dividido
    signal source        : std_logic_vector(15 downto 0);
    signal probe         : std_logic_vector(7 downto 0);
    signal tempo_contagem1: unsigned(7 downto 0);
    signal tempo_contagem2: unsigned(15 downto 8);
    signal counter1      : unsigned(7 downto 0);
    signal counter2      : unsigned(7 downto 0);
	 signal signal_counter_probe : unsigned(7 DOWNTO 0); -- Sinal de contador do tipo unsigned
	 signal signal_counter : unsigned(7 DOWNTO 0); -- Sinal de contador do tipo unsigned

	
	component unnamed is
		port (
			source : out std_logic_vector(15 downto 0);                    -- source
			probe  : in  std_logic_vector(7 downto 0) := (others => 'X')  -- probe
		);
	end component unnamed;
	

	
begin

	    u0 : component unnamed
        port map(
            source => source,           -- sources.source
            probe  => probe             --  probes.probe
        );
		  
	 probe <= std_logic_vector(signal_counter);
	 signal_counter <=signal_counter_probe;
    tempo_contagem1 <= unsigned(source(7 downto 0));
    tempo_contagem2 <= unsigned(source(15 downto 8));
    tempo_contagem <= unsigned(source);


	
	    -- Divisor de Clock para gerar um sinal de clock mais lento
    process(MAX10_CLK1_50)
        variable counter : integer := 0;
    begin
        if rising_edge(MAX10_CLK1_50) then
            counter := counter + 1;
            if counter = 50000000 then -- Ajuste este valor conforme necessário
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
        clk       => clk_div, -- Usando o clock dividido
        aclr_n    => SW(2),  -- Evita reset contínuo
        count_out => count_out
    );
	
	    -- Instância do DUT (Design Under Test)
    dut : entity work.semaforo
        port map(
            clk     => clk_div,
            rst     => SW(1),
            start   => SW(0),
				tempo_contagem => tempo_contagem,
            r1      => LEDR(0),
            r2      => LEDR(1),
            y1      => LEDR(2),
            y2      => LEDR(3),
            g1      => LEDR(4),
            g2      => LEDR(5),
				counter1 => counter1, -- Conecte o contador correto aqui
				counter2 => counter2  -- Conecte o contador correto aqui
				
        );
	
end architecture rtl;

