library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity semaforo_testbench is
end entity semaforo_testbench;

architecture stimulus of semaforo_testbench is
    signal clk      : std_logic;
    signal rst      : std_logic;
    signal start    : std_logic;
	SIGNAL r1       : std_logic;          -- Sinal de saída para o vermelho do primeiro semáforo
    SIGNAL y1       : std_logic;          -- Sinal de saída para o amarelo do primeiro semáforo
    SIGNAL g1       : std_logic;          -- Sinal de saída para o verde do primeiro semáforo
    SIGNAL r2       : std_logic;          -- Sinal de saída para o vermelho do segundo semáforo
    SIGNAL y2       : std_logic;          -- Sinal de saída para o amarelo do segundo semáforo
    SIGNAL g2       : std_logic;          -- Sinal de saída para o verde do segundo semáforo
    signal counter  : INTEGER;

begin

    -- Instância do DUT (Design Under Test)
    dut : entity work.semaforo
        port map(
            clk      => clk,
            rst      => rst,
            start    => start,
            r1       => r1,     
            r2       => r2,     
            y1       => y1,     
            y2       => y2,     
            g1       => g1,     
            g2       => g2,     
            counter  => counter
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
        rst <= '1';                       -- Ativa reset
        wait for 10 ns;
        rst <= '0';                       -- Libera reset após 10 ns
        wait;
    end process stimulus_process_reset;

    -- Processo para controlar o sinal start
    start_process : process
    begin
        start <= '0';
        wait for 30 ns;                   -- Espera 30 ns antes de ativar o start
        start <= '1';
        wait;
    end process start_process;
	
end architecture stimulus;
