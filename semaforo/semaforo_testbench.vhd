library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity semaforo_testbench is
end entity semaforo_testbench;

architecture stimulus of semaforo_testbench is
    signal clk     : std_logic;
    signal rst     : std_logic;
    signal start   : std_logic;
	signal tempo_contagem   : unsigned(15 DOWNTO 0);
    signal r1      : std_logic;         -- Sinal de saída para o vermelho do primeiro semáforo
    signal y1      : std_logic;         -- Sinal de saída para o amarelo do primeiro semáforo
    signal g1      : std_logic;         -- Sinal de saída para o verde do primeiro semáforo
    signal r2      : std_logic;         -- Sinal de saída para o vermelho do segundo semáforo
    signal y2      : std_logic;         -- Sinal de saída para o amarelo do segundo semáforo
    signal g2      : std_logic;         -- Sinal de saída para o verde do segundo semáforo
    signal counter1 : unsigned(7 DOWNTO 0); -- Sinal de contador do tipo unsigned
	signal counter2 : unsigned(7 DOWNTO 0); -- Sinal de contador do tipo unsigned
	signal event_counter1 : unsigned(7 DOWNTO 0); -- Sinal do contador de eventos do primeiro semáforo
	signal event_counter2 : unsigned(7 DOWNTO 0); -- Sinal do contador de eventos do segundo semáforo

begin

    -- Instância do DUT (Design Under Test)
    dut : entity work.semaforo
        port map(
            clk     => clk,
            rst     => rst,
            start   => start,
			tempo_contagem => tempo_contagem,
            r1      => r1,
            r2      => r2,
            y1      => y1,
            y2      => y2,
            g1      => g1,
            g2      => g2,
            counter1 => counter1,
			counter2 => counter2,
			event_counter1 => event_counter1,
			event_counter2 => event_counter2
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
	
	-- Processo para controlar o tempo_contagem de cada semáforo
stimulus_process_tempo_contagem : process
begin
    -- Definir o valor completo de tempo_contagem e dividir para ambos os semáforos
    tempo_contagem <= "0000000000000000"; -- Exemplo: parte mais significativa para o semáforo 1 e parte menos significativa para o semáforo 2

    --wait for 100 ns;

    -- Mudar o valor de tempo_contagem para outra configuração de ciclos
    --tempo_contagem <= x"9632"; -- Outro exemplo de configuração

    --wait for 100 ns;

    wait;
end process stimulus_process_tempo_contagem;

end architecture stimulus;
