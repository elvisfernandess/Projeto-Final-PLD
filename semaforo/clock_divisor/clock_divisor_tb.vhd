-- Biblioteca IEEE para tipos e operações padrão
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY clock_divisor_tb IS
    -- Testbench não possui portas
END ENTITY clock_divisor_tb;

ARCHITECTURE behavior OF clock_divisor_tb IS
    -- Sinais para conectar ao DUT (Device Under Test)
    SIGNAL clk_in  : std_logic := '0';   -- Clock de entrada
    SIGNAL rst     : std_logic := '0';   -- Sinal de reset
    SIGNAL clk_out : std_logic;          -- Clock de saída mais lento
    SIGNAL count_out : INTEGER;          -- Sinal de contagem do DUT

    -- Frequência do clock de entrada
    CONSTANT clk_period : TIME := 16.67 ns; -- Aproximadamente 60 Hz

BEGIN

    -- Instância do DUT (Device Under Test)
    dut: ENTITY work.clock_divisor
        PORT MAP (
            clk_in  => clk_in,
            rst     => rst,
            clk_out => clk_out,
            count_out => count_out
        );

    -- Processo para gerar o sinal de clock
    stimulus_process_clk : process
    begin
        clk_in <= '0';              -- Define o clock como 0
        wait for clk_period / 2;   -- Espera metade do período do clock
        clk_in <= '1';             -- Alterna o clock para 1
        wait for clk_period / 2;   -- Espera metade do período do clock
    end process stimulus_process_clk;

    -- Processo para estímulos para o sinal reset
    stimulus_process_reset : process
    begin
        rst <= '1';
        wait for 2 * clk_period;   -- Aguarda dois períodos de clock antes de aplicar os estímulos
        rst <= '0';
        wait;
    end process stimulus_process_reset;

END ARCHITECTURE behavior;
