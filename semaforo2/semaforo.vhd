library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY semaforo IS
    PORT(
        clk              : IN  std_logic;
        rst              : IN  std_logic;
        start            : IN  std_logic;
        pedestre         : IN  std_logic;  -- Chave para contagem de pedestres
        carro            : IN  std_logic;  -- Chave para contagem de carros
        r1               : OUT std_logic;  -- Sinal vermelho do semáforo
        y1               : OUT std_logic;  -- Sinal amarelo do semáforo
        g1               : OUT std_logic;  -- Sinal verde do semáforo
        ped_count        : OUT UNSIGNED(7 DOWNTO 0); -- Display para contagem de pedestres
        car_count        : OUT UNSIGNED(7 DOWNTO 0); -- Display para contagem de carros
        time_display     : OUT UNSIGNED(7 DOWNTO 0)  -- Display para tempo de cada estado
    );
END ENTITY semaforo;

ARCHITECTURE state_machine OF semaforo IS

    TYPE state IS (RED, YELLOW, GREEN);
    SIGNAL pr_state, nx_state : state;
    SIGNAL count              : UNSIGNED(7 DOWNTO 0);
    SIGNAL count_limit        : UNSIGNED(7 DOWNTO 0);
    SIGNAL ped_count_sig, car_count_sig : UNSIGNED(7 DOWNTO 0);

BEGIN

    -- Processo de transição de estados e contagem
    PROCESS(rst, clk)
    BEGIN
        IF rst = '1' THEN
            pr_state <= RED;
            count    <= (others => '0');
            ped_count_sig <= (others => '0');
            car_count_sig <= (others => '0');
        ELSIF rising_edge(clk) THEN
            IF count > 0 THEN
                count <= count - 1;
            ELSE
                pr_state <= nx_state;
                count <= count_limit;
            END IF;

            -- Contagem de pedestres apenas no estado RED
            IF pr_state = RED AND pedestre = '1' THEN
                ped_count_sig <= ped_count_sig + 1;
				car_count_sig <= (others => '0');
            END IF;

            -- Contagem de carros apenas nos estados YELLOW e GREEN
            IF (pr_state = YELLOW OR pr_state = GREEN) AND carro = '1' THEN
                car_count_sig <= car_count_sig + 1;
				ped_count_sig <= (others => '0');
            END IF;

        END IF;
    END PROCESS;

    -- Lógica de transição de estado, contagem de pedestres e carros
    PROCESS(pr_state, start, pedestre, carro)
    BEGIN
        CASE pr_state IS
            WHEN RED =>
                count_limit <= "00001010";  -- Exemplo: 10 ciclos de clock para o estado RED
                IF start = '1' THEN
                    nx_state <= YELLOW;
                ELSE
                    nx_state <= RED;
                END IF;
                

            WHEN YELLOW =>
                count_limit <= "00000100";  -- Exemplo: 4 ciclos de clock para o estado YELLOW
                nx_state <= GREEN;
                

            WHEN GREEN =>
                count_limit <= "00001000";  -- Exemplo: 8 ciclos de clock para o estado GREEN
                nx_state <= RED;
                
        END CASE;
    END PROCESS;

    ped_count <= ped_count_sig;
    car_count <= car_count_sig;
    time_display <= count;  -- Display mostra o tempo restante do estado atual

    -- Controle das luzes do semáforo baseado no estado atual
    PROCESS(pr_state)
    BEGIN
        CASE pr_state IS
            WHEN RED =>
                r1 <= '1';
                y1 <= '0';
                g1 <= '0';
            WHEN YELLOW =>
                r1 <= '0';
                y1 <= '1';
                g1 <= '0';
            WHEN GREEN =>
                r1 <= '0';
                y1 <= '0';
                g1 <= '1';
        END CASE;
    END PROCESS;

END ARCHITECTURE state_machine;
