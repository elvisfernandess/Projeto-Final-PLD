-- Testbench para o controlador de semáforo (tlc)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tlc_tb IS
END ENTITY tlc_tb;

ARCHITECTURE tb OF tlc_tb IS

    -- Constantes
    CONSTANT clk_period : time := 10 ns; -- Período do clock
    CONSTANT timeMAX    : INTEGER := 270;
    CONSTANT timeRG     : INTEGER := 180;
    CONSTANT timeRY     : INTEGER := 30;
    CONSTANT timeGR     : INTEGER := 270;
    CONSTANT timeYR     : INTEGER := 30;
    CONSTANT timeTEST   : INTEGER := 60;

    -- Sinais
    SIGNAL clk   : std_logic := '0';
    SIGNAL stby  : std_logic;
    SIGNAL test  : std_logic;
    SIGNAL r1    : std_logic;
    SIGNAL y1    : std_logic;
    SIGNAL g1    : std_logic;
    SIGNAL r2    : std_logic;
    SIGNAL y2    : std_logic;
    SIGNAL g2    : std_logic;
    SIGNAL count : INTEGER := 0; -- Sinal contador para o testbench

BEGIN

    -- Instanciar a Unidade Sob Teste (UUT)
    dut: ENTITY work.tlc
        PORT MAP (
            clk    => clk,
            stby   => stby,
            test   => test,
            r1     => r1,
            r2     => r2,
            y1     => y1,
            y2     => y2,
            g1     => g1,
            g2     => g2
        );

    -- Gera um clock
    stimulus_process_clk : process
    begin
        clk <= '0';
        wait for 5 ns;                  -- Tempo de espera reduzido para permitir uma verificação mais frequente do match
        clk <= '1';                     -- Alternando o clock
        wait for 5 ns;
    end process stimulus_process_clk;

-- Processo para gerenciar o estado de standby
stby_process : PROCESS
BEGIN
    -- Ativar o modo de standby
    stby <= '1';
    WAIT FOR 2 * clk_period; -- Aguardar dois ciclos de clock
    stby <= '0';

    -- Permitir tempo para a máquina de estados inicializar e transitar do estado inicial (YY) para o estado RG
    WAIT FOR (timeRG + 2) * clk_period; -- Tempo suficiente para cobrir o estado RG e a transição

    -- Testar o tempo no estado RG e transição para RY
    WAIT FOR (timeRG + timeRY + 2) * clk_period; -- Tempo suficiente para cobrir o estado RG e RY

    -- Testar o tempo no estado RY e transição para GR
    WAIT FOR (timeRG + timeRY + timeGR + 2) * clk_period; -- Tempo suficiente para cobrir o estado RY e GR

    -- Testar o tempo no estado GR e transição para YR
    WAIT FOR (timeRG + timeRY + timeGR + timeYR + 2) * clk_period; -- Tempo suficiente para cobrir o estado GR e YR

    -- Testar o tempo no estado YR e transição para RG
    WAIT FOR (timeRG + timeRY + timeGR + timeYR + timeRG + 2) * clk_period; -- Tempo suficiente para cobrir o estado YR e RG

    -- Permitir mais tempo para observar as transições completas no modo normal
    WAIT FOR timeMAX * clk_period; -- Tempo suficiente para cobrir todos os estados no modo normal

    
END PROCESS stby_process;


    -- Processo paralelo para alternar o sinal de teste
    test_process : PROCESS
    BEGIN
        -- Testar o modo normal
        test <= '0';
        WAIT FOR 2 * clk_period;
        test <= '1';
        WAIT FOR 2 * clk_period;
        
        -- Testar o modo de teste
        test <= '0';
        WAIT FOR (timeTEST + 2) * clk_period; -- Tempo suficiente para cobrir o tempo de teste
        test <= '1';
        WAIT FOR (timeTEST + 2) * clk_period;


    END PROCESS test_process;

    -- Processo de contador
    counter_process : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            count <= count + 1;
            IF count = 270 THEN
                count <= 0; -- Redefinir contador se necessário
            END IF;
        END IF;
    END PROCESS counter_process;

END ARCHITECTURE tb;
