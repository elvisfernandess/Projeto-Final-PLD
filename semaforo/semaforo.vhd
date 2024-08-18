library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY semaforo IS
    PORT(
        clk              : IN  std_logic;
        rst              : IN  std_logic;
        start            : IN  std_logic;
        tempo_contagem   : IN  UNSIGNED(15 DOWNTO 0); -- Sinal de 16 bits dividido entre dois semáforos
        r1               : OUT std_logic;        -- Saída para o sinal vermelho do primeiro semáforo
        y1               : OUT std_logic;        -- Saída para o sinal amarelo do primeiro semáforo
        g1               : OUT std_logic;        -- Saída para o sinal verde do primeiro semáforo
        r2               : OUT std_logic;        -- Saída para o sinal vermelho do segundo semáforo
        y2               : OUT std_logic;        -- Saída para o sinal amarelo do segundo semáforo
        g2               : OUT std_logic;        -- Saída para o sinal verde do segundo semáforo
        counter1         : OUT UNSIGNED(7 DOWNTO 0); -- Contador do primeiro semáforo
        counter2         : OUT UNSIGNED(7 DOWNTO 0)  -- Contador do segundo semáforo
    );
END ENTITY semaforo;

ARCHITECTURE state_machine OF semaforo IS

    TYPE state IS (YY, RG, RY, GR, YR); -- Estados incluídos
    SIGNAL pr_state1, nx_state1 : state;
    SIGNAL pr_state2, nx_state2 : state;
    SIGNAL count1, count2       : UNSIGNED(7 DOWNTO 0);
    SIGNAL count_limit1, count_limit2 : UNSIGNED(7 DOWNTO 0); -- Limites de contagem para cada semáforo

BEGIN

    -- Processo de transição de estados e contagem para o primeiro semáforo
    PROCESS(rst, clk)
    BEGIN
        IF rst = '1' THEN
            pr_state1 <= YY;
            count1    <= (others => '0');
        ELSIF (clk'event AND clk = '1') THEN
            IF count1 < count_limit1 THEN
                count1 <= count1 + 1;
            ELSE
                count1    <= (others => '0');
                pr_state1 <= nx_state1;
            END IF;
        END IF;
    END PROCESS;

    -- Processo de transição de estados e contagem para o segundo semáforo
    PROCESS(rst, clk)
    BEGIN
        IF rst = '1' THEN
            pr_state2 <= YY;
            count2    <= (others => '0');
        ELSIF (clk'event AND clk = '1') THEN
            IF count2 < count_limit2 THEN
                count2 <= count2 + 1;
            ELSE
                count2    <= (others => '0');
                pr_state2 <= nx_state2;
            END IF;
        END IF;
    END PROCESS;

    -- Lógica de transição de estado e definição de tempo para o primeiro semáforo
    PROCESS(pr_state1, tempo_contagem, start)
    BEGIN
        count_limit1 <= tempo_contagem(15 DOWNTO 8); -- Usar parte mais significativa para o semáforo 1
        CASE pr_state1 IS
            WHEN YY =>
                IF start = '1' THEN
                    nx_state1 <= RG;
                ELSE
                    nx_state1 <= YY;
                END IF;

            WHEN RG =>
                nx_state1 <= RY;

            WHEN RY =>
                nx_state1 <= GR;

            WHEN GR =>
                nx_state1 <= YR;

            WHEN YR =>
                nx_state1 <= YY;
        END CASE;
    END PROCESS;

    -- Lógica de transição de estado e definição de tempo para o segundo semáforo
    PROCESS(pr_state2, tempo_contagem, start)
    BEGIN
        count_limit2 <= tempo_contagem(7 DOWNTO 0); -- Usar parte menos significativa para o semáforo 2
        CASE pr_state2 IS
            WHEN YY =>
                IF start = '1' THEN
                    nx_state2 <= RG;
                ELSE
                    nx_state2 <= YY;
                END IF;

            WHEN RG =>
                nx_state2 <= RY;

            WHEN RY =>
                nx_state2 <= GR;

            WHEN GR =>
                nx_state2 <= YR;

            WHEN YR =>
                nx_state2 <= YY;
        END CASE;
    END PROCESS;

    -- Saída dos contadores
    counter1 <= count1;
    counter2 <= count2;

    -- Controle das luzes do semáforo baseado no estado atual para o semáforo 1
    PROCESS(pr_state1)
    BEGIN
        CASE pr_state1 IS
            WHEN YY =>
                r1 <= '0';
                y1 <= '1';
                g1 <= '0';
            WHEN RG =>
                r1 <= '1';
                y1 <= '0';
                g1 <= '0';
            WHEN RY =>
                r1 <= '1';
                y1 <= '0';
                g1 <= '0';
            WHEN GR =>
                r1 <= '0';
                y1 <= '0';
                g1 <= '1';
            WHEN YR =>
                r1 <= '0';
                y1 <= '1';
                g1 <= '0';
        END CASE;
    END PROCESS;

    -- Controle das luzes do semáforo baseado no estado atual para o semáforo 2
    PROCESS(pr_state2)
    BEGIN
        CASE pr_state2 IS
            WHEN YY =>
                r2 <= '0';
                y2 <= '1';
                g2 <= '0';
            WHEN RG =>
                r2 <= '1';
                y2 <= '0';
                g2 <= '0';
            WHEN RY =>
                r2 <= '1';
                y2 <= '0';
                g2 <= '0';
            WHEN GR =>
                r2 <= '0';
                y2 <= '0';
                g2 <= '1';
            WHEN YR =>
                r2 <= '0';
                y2 <= '1';
                g2 <= '0';
        END CASE;
    END PROCESS;

END ARCHITECTURE state_machine;
