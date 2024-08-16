-------------------------------------------------------
--! Tarefa 07: contador
--! Aluno: Elvis Fernandes
--! Data: 23/03/2022
--! Arquivo: counter.vhd
-------------------------------------------------------

-- Escreva o código para um contador de 2 bits com controle assíncrono.

-- A saída vai para ``00'' imediatamente quando aclr_n é baixo.
-- Se aclr_n não é baixo, o contador é incrementado em 1 na subida do clock.
-- Use uma variável.
-- aclr_n tem prioridade sobre a verificação da subida do clk.
-- Use  pacotes STD_LOGIC_1164 e STD_LOGIC_UNSIGNED.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    generic (
        DATA_WIDTH_OUT : integer := 1    -- Largura padrão de count_out
    );
    port (
        clk       : in std_logic; 
        aclr_n    : in std_logic; 
        count_out : out unsigned(DATA_WIDTH_OUT downto 0) -- Saída do contador
    );
end entity counter;

architecture behavioral of counter is
begin
    process (clk, aclr_n)
        variable q_var : unsigned(DATA_WIDTH_OUT downto 0);
    begin
        if aclr_n = '0' then
            q_var := (others => '0');
        elsif rising_edge(clk) then
            q_var := q_var + 1;
        end if;
        count_out <= q_var;
    end process;
end architecture behavioral;