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

-- Importando o pacote de conversão BCD para 7 segmentos
use work.bcd_to_7seg_pkg.all;

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

		-- Sinais para os semáforos e contadores
		signal clk           : std_logic;					-- Sinal de clock
		signal rst           : std_logic;					-- Sinal de reset
		signal start         : std_logic;					-- Sinal para a chave de start
		signal pedestre      : std_logic;					-- Sinal para a chave para contagem de pedestres
		signal carro   	   : std_logic;					-- Sinal para a chave para contagem de carros
		signal r1      	   : std_logic;          		-- Sinal de saída para o vermelho do primeiro semáforo
		signal y1            : std_logic;          		-- Sinal de saída para o amarelo do primeiro semáforo
		signal g1            : std_logic;          		-- Sinal de saída para o verde do primeiro semáforo
		signal ped_count  	: unsigned(7 DOWNTO 0); 	-- Sinal de contador de pedestres 
		signal car_count  	: unsigned(7 DOWNTO 0); 	-- Sinal de contador de carros
		signal time_display  : unsigned(7 DOWNTO 0); 	-- Sinal de contador de tempo de estados do semáforo
		
		signal clk_div       : std_logic := '0';
		
		 -- Sinais para os displays de 7 segmentos
    signal hex0_data : std_logic_vector(7 downto 0);
    signal hex1_data : std_logic_vector(7 downto 0);
    signal hex2_data : std_logic_vector(7 downto 0);
		
begin
	
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

	
	    -- Instância do DUT (Design Under Test)
    dut : entity work.semaforo
        port map(
            clk          => clk_div,
            rst          => SW(1),
            start        => SW(0),
				pedestre     => SW(9),
            carro        => SW(8),
            r1           => LEDR(2),
            y1           => LEDR(1),
            g1           => LEDR(0),
            ped_count    => ped_count,
				car_count    => car_count,
				time_display => time_display
        );
	
	 -- Convertendo os valores de contagem para displays de 7 segmentos
    process(ped_count, car_count, time_display)
    begin
        -- Display HEX0 mostram ped_count
        hex0_data <= convert_8bits_to_dual_7seg(std_logic_vector(ped_count))(7 downto 0);
		  
		  -- Display HEX0 mostram car_count
        hex1_data <= convert_8bits_to_dual_7seg(std_logic_vector(car_count))(7 downto 0);

        -- Display HEX2 e HEX3 mostram counter2
        hex2_data <= convert_8bits_to_dual_7seg(std_logic_vector(time_display))(7 downto 0);
        
    end process;
	
 -- Atribuindo os valores convertidos aos displays
    HEX0 <= hex0_data;
    HEX1 <= hex1_data;
    HEX2 <= hex2_data;
	
	
end;

