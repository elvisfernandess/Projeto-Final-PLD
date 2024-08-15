library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY semaforo IS
    PORT(
        clk      : IN  std_logic;
        rst      : IN  std_logic;
        start    : IN  std_logic;
		r1       : OUT std_logic;   -- Saída para o sinal vermelho do primeiro semáforo
        y1       : OUT std_logic;   -- Saída para o sinal amarelo do primeiro semáforo
        g1       : OUT std_logic;   -- Saída para o sinal verde do primeiro semáforo
        r2       : OUT std_logic;   -- Saída para o sinal vermelho do segundo semáforo
        y2       : OUT std_logic;   -- Saída para o sinal amarelo do segundo semáforo
        g2       : OUT std_logic;    -- Saída para o sinal verde do segundo semáforo
        counter  : OUT INTEGER         -- Sinal de contador 1
    );
END ENTITY semaforo;

ARCHITECTURE state_machine OF semaforo IS

    TYPE state IS (YY, RG, RY, GR, YR);  -- Estados incluídos
    SIGNAL pr_state, nx_state : state;
    SIGNAL count       : INTEGER RANGE 0 TO 500;  -- Máximo de ciclos ajustado conforme o maior tempo necessário
    SIGNAL count_limit : INTEGER;  -- Limite de contagem específico para cada estado

BEGIN

    -- Processo de transição de estados e contagem
    PROCESS(rst, clk)
    BEGIN
        IF rst = '1' THEN
            pr_state <= YY;
            count <= 0;
        ELSIF (clk'event AND clk = '1') THEN
            -- Permanecer no estado atual até que a contagem seja concluída
            IF count < count_limit THEN
                count <= count + 1;
            ELSE
                -- Resetar a contagem ao término do tempo do estado
                count <= 0;
                pr_state <= nx_state;
            END IF;
        END IF;
    END PROCESS;

    -- Lógica de transição de estado e definição de tempo
    PROCESS(pr_state, start)
    BEGIN
        CASE pr_state IS
            WHEN YY =>
                IF start = '1' THEN
                    count_limit <= 180;   -- 3 segundos (60 ciclos/segundo)
                    nx_state <= RG;
                ELSE
                    nx_state <= YY;
                END IF;

            WHEN RG =>
                count_limit <= 300;       -- 5 segundos
                nx_state <= RY;           -- Transição para o próximo estado após 5 segundos

            WHEN RY =>
                count_limit <= 60;        -- 1 segundo
                nx_state <= GR;           -- Transição para o próximo estado após 1 segundo

            WHEN GR =>
                count_limit <= 240;       -- 4 segundos
                nx_state <= YR;           -- Transição para o próximo estado após 4 segundos

            WHEN YR =>
                count_limit <= 60;        -- 1 segundo
                nx_state <= YY;           -- Retorna ao estado inicial após 1 segundo
        END CASE;
    END PROCESS;

    -- Saída do contador
    counter <= count;
	
	-- Controle das luzes do semáforo baseado no estado atual
    PROCESS(pr_state)
    BEGIN
        -- Estado padrão de todas as luzes
        r1 <= '0';    -- Desativa o sinal vermelho do primeiro semáforo
        r2 <= '0';    -- Desativa o sinal vermelho do segundo semáforo
        y1 <= '1';    -- Ativa o sinal amarelo do primeiro semáforo
        y2 <= '1';    -- Ativa o sinal amarelo do segundo semáforo
        g1 <= '0';    -- Desativa o sinal verde do primeiro semáforo
        g2 <= '0';    -- Desativa o sinal verde do segundo semáforo

        CASE pr_state IS
            WHEN RG =>  
                r1 <= '1';    -- Ativa o sinal vermelho do primeiro semáforo
                r2 <= '0';    -- Desativa o sinal vermelho do segundo semáforo
                y1 <= '0';    -- Desativa o sinal amarelo do primeiro semáforo
                y2 <= '0';    -- Desativa o sinal amarelo do segundo semáforo
                g1 <= '0';    -- Desativa o sinal verde do primeiro semáforo
                g2 <= '1';    -- Ativa o sinal verde do segundo semáforo

            WHEN RY =>  
                r1 <= '1';    -- Ativa o sinal vermelho do primeiro semáforo
                r2 <= '0';    -- Desativa o sinal vermelho do segundo semáforo
                y1 <= '0';    -- Desativa o sinal amarelo do primeiro semáforo
                y2 <= '1';    -- Ativa o sinal amarelo do segundo semáforo
                g1 <= '0';    -- Desativa o sinal verde do primeiro semáforo
                g2 <= '0';    -- Desativa o sinal verde do segundo semáforo

            WHEN GR =>  
                r1 <= '0';    -- Desativa o sinal vermelho do primeiro semáforo
                r2 <= '1';    -- Ativa o sinal vermelho do segundo semáforo
                y1 <= '0';    -- Desativa o sinal amarelo do primeiro semáforo
                y2 <= '0';    -- Desativa o sinal amarelo do segundo semáforo
                g1 <= '1';    -- Ativa o sinal verde do primeiro semáforo
                g2 <= '0';    -- Desativa o sinal verde do segundo semáforo

            WHEN YR =>  
                r1 <= '0';    -- Desativa o sinal vermelho do primeiro semáforo
                r2 <= '1';    -- Ativa o sinal vermelho do segundo semáforo
                y1 <= '1';    -- Ativa o sinal amarelo do primeiro semáforo
                y2 <= '0';    -- Desativa o sinal amarelo do segundo semáforo
                g1 <= '0';    -- Desativa o sinal verde do primeiro semáforo
                g2 <= '0';    -- Desativa o sinal verde do segundo semáforo

            WHEN OTHERS =>
                -- Estado padrão de todas as luzes
				r1 <= '0';    -- Desativa o sinal vermelho do primeiro semáforo
				r2 <= '0';    -- Desativa o sinal vermelho do segundo semáforo
				y1 <= '1';    -- Ativa o sinal amarelo do primeiro semáforo
				y2 <= '1';    -- Ativa o sinal amarelo do segundo semáforo
				g1 <= '0';    -- Desativa o sinal verde do primeiro semáforo
				g2 <= '0';    -- Desativa o sinal verde do segundo semáforo
        END CASE;
    END PROCESS;

END ARCHITECTURE state_machine;
