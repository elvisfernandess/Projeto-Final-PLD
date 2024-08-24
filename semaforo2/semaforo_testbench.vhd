library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity semaforo_testbench is
end entity semaforo_testbench;

architecture stimulus of semaforo_testbench is
    signal clk           : std_logic;				-- Sinal de clock
    signal rst           : std_logic;				-- Sinal de reset
    signal start         : std_logic;				-- Sinal para a chave de start
	signal pedestre      : std_logic;				-- Sinal para a chave para contagem de pedestres
	signal carro   	     : std_logic;				-- Sinal para a chave para contagem de carros
	signal r1      	     : std_logic;          		-- Sinal de saída para o vermelho do primeiro semáforo
    signal y1            : std_logic;          		-- Sinal de saída para o amarelo do primeiro semáforo
    signal g1            : std_logic;          		-- Sinal de saída para o verde do primeiro semáforo
    signal ped_count  	 : unsigned(7 DOWNTO 0); 	-- Sinal de contador de pedestres 
	signal car_count  	 : unsigned(7 DOWNTO 0); 	-- Sinal de contador de carros
	signal time_display  : unsigned(7 DOWNTO 0); 	-- Sinal de contador de tempo de estados do semáforo

begin

    -- Instância do DUT (Design Under Test)
    dut : entity work.semaforo
        port map(
            clk          => clk,
            rst          => rst,
            start        => start,
			pedestre     => pedestre,
            carro        => carro,
            r1           => r1,
            y1           => y1,
            g1           => g1,
            ped_count    => ped_count,
			car_count    => car_count,
			time_display => time_display
        );

    -- Geração do clock de 10 ns (50 MHz)
    stimulus_process_clk : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process stimulus_process_clk;

    -- Processo para resetar o sistema
    stimulus_process_reset : process
    begin
        rst <= '1';                     -- Ativa reset
        wait for 10 ns;
        rst <= '0';                     -- Libera reset após 10 ns
        wait;
    end process stimulus_process_reset;

    -- Processo para controlar o sinal start
    start_process : process
    begin
        start <= '0';
        wait for 30 ns;                 -- Espera 30 ns antes de ativar o start
        start <= '1';
        wait;
    end process start_process;
	
	-- Processo para controlar o sinal da contagem de pedestres
    pedestre_process : process
    begin
        pedestre <= '0';
        wait for 30 ns;                 -- Espera 30 ns antes de ativar o sinal de pedestres
        pedestre <= '1';
        wait;
    end process pedestre_process;
	
	-- Processo para controlar o sinal da contagem de carros
    carro_process : process
    begin
        carro <= '0';
        wait for 30 ns;                 -- Espera 30 ns antes de ativar o sinal de carros
        carro <= '1';
        wait;
    end process carro_process;
	
end architecture stimulus;
