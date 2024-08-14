-- Biblioteca IEEE para tipos e operações padrão
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;    -- Biblioteca para tipos e operações de lógica digital
USE ieee.numeric_std.ALL;       -- Biblioteca para operações numéricas

-- Entidade que define o divisor de clock
ENTITY clock_divisor IS
    PORT (
        clk_in  : IN  std_logic;   -- Clock de entrada de 60 Hz (input)
        rst     : IN  std_logic;   -- Sinal de reset (input)
        clk_out : OUT std_logic;   -- Clock de saída mais lento (output)
        count_out : OUT INTEGER    -- Saída do contador
    );
END ENTITY clock_divisor;

-- Arquitetura que implementa o comportamento do divisor de clock
ARCHITECTURE behavior OF clock_divisor IS
    -- Constante que define o divisor para ajustar a frequência de saída
    CONSTANT DIVISOR : INTEGER := 60; -- Número de pulsos do clock de entrada necessários para um pulso do clock de saída
    
    -- Sinal interno para contar os pulsos do clock de entrada
    SIGNAL count : INTEGER := 0;
    SIGNAL sig_clk_out : std_logic := '0';  -- Inicializa o sinal do clock de saída
BEGIN

    -- Processo sensível ao clock de entrada e ao sinal de reset
    PROCESS(clk_in, rst)
    BEGIN
        -- Se o sinal de reset estiver ativo (alto), reinicia o contador e define o clock de saída como 0
        IF rst = '1' THEN
            count <= 0;
            sig_clk_out <= '0';
        -- Se houver uma borda de subida no clock de entrada
        ELSIF rising_edge(clk_in) THEN
            -- Se o contador atingir o valor do divisor, alterna o sinal do clock de saída e reinicia o contador
            IF count = DIVISOR - 1 THEN
                sig_clk_out <= NOT sig_clk_out; -- Alterna o sinal do clock de saída
                count <= 0; -- Reinicializa o contador
            ELSE
                -- Incrementa o contador
                count <= count + 1;
            END IF;
        END IF;
    END PROCESS;
    
    -- Atribui o sinal interno ao sinal de saída
    clk_out <= sig_clk_out;
    count_out <= count;  -- Atribui o valor do contador à saída

END ARCHITECTURE behavior;
