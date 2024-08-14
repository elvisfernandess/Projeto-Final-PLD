library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY tlc IS
    PORT (
        clk   : IN  std_logic;
        stby  : IN  std_logic;
        test  : IN  std_logic;
        r1    : OUT std_logic;
        y1    : OUT std_logic;
        g1    : OUT std_logic;
        r2    : OUT std_logic;
        y2    : OUT std_logic;
        g2    : OUT std_logic
    );
END ENTITY tlc;

ARCHITECTURE behavior OF tlc IS
    -- Constantes de tempo
    CONSTANT timeMAX : INTEGER := 270;
    CONSTANT timeRG  : INTEGER := 180;
    CONSTANT timeRY  : INTEGER := 30;
    CONSTANT timeGR  : INTEGER := 270;
    CONSTANT timeYR  : INTEGER := 30;
    CONSTANT timeTEST : INTEGER := 60;
    
    TYPE state IS (YY, RY, GR, YR, RG);
    SIGNAL pr_state, nx_state : state;
    SIGNAL time: INTEGER RANGE 0 TO 270; -- Valor máximo baseado no maior tempo
    SIGNAL count : INTEGER RANGE 0 TO 270; -- Ajustar para o tempo máximo

    -- Sinais do divisor de clock
    SIGNAL clk_div : std_logic;
    SIGNAL clk_div_count : INTEGER;

BEGIN

    -- Instância do divisor de clock
    clk_div_inst : ENTITY work.clock_divisor
        PORT MAP (
            clk_in  => clk,
            rst     => '0', -- Assume que o reset não está sendo usado no divisor de clock
            clk_out => clk_div,
            count_out => clk_div_count
        );

    -- Seção inferior da máquina de estados:
    PROCESS(clk_div, stby)
    BEGIN
        IF stby = '1' THEN
            pr_state <= YY;
            count <= 0;
        ELSIF (clk_div'event AND clk_div = '1') THEN
            count <= count + 1;
            IF (count = time) THEN
                pr_state <= nx_state;
                count <= 0;
            END IF;
        END IF;
    END PROCESS;

    -- Seção superior da máquina de estados:
    PROCESS(pr_state, test)
    BEGIN
        CASE pr_state IS
            WHEN RG =>
                r1 <= '1';
                r2 <= '0';
                y1 <= '0';
                y2 <= '0';
                g1 <= '0';
                g2 <= '1';
                nx_state <= RY;
                IF (test = '0') THEN
                    time <= timeRG;
                ELSE
                    time <= timeTEST;
                END IF;

            WHEN RY =>
                r1 <= '1';
                r2 <= '0';
                y1 <= '0';
                y2 <= '1';
                g1 <= '0';
                g2 <= '0';
                nx_state <= GR;
                IF (test = '0') THEN
                    time <= timeRY;
                ELSE
                    time <= timeTEST;
                END IF;

            WHEN GR =>
                r1 <= '0';
                r2 <= '1';
                y1 <= '0';
                y2 <= '0';
                g1 <= '1';
                g2 <= '0';
                nx_state <= YR;
                IF (test = '0') THEN
                    time <= timeGR;
                ELSE
                    time <= timeTEST;
                END IF;

            WHEN YR =>
                r1 <= '0';
                r2 <= '1';
                y1 <= '1';
                y2 <= '0';
                g1 <= '0';
                g2 <= '0';
                nx_state <= RG;
                IF (test = '0') THEN
                    time <= timeYR;
                ELSE
                    time <= timeTEST;
                END IF;

            WHEN YY =>
                r1 <= '0';
                r2 <= '0';
                y1 <= '1';
                y2 <= '1';
                g1 <= '0';
                g2 <= '0';
                nx_state <= RY;
                -- Sem atualização de tempo no estado YY, transição imediata para RY
        END CASE;
    END PROCESS;

END ARCHITECTURE behavior;
