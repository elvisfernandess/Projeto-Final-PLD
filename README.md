# SEMÁFORO
## 1 ESPECIFICAÇÕES

### 1.1 PORTAS DE ENTRADA
 - clk: Porta de entrada (interno) do tipo std_logic responsável pelo clock. 
 - rst: Porta de entrada (interno) do tipo std_logic responsável pelo rst. 
 - start: Porta de entrada (chave) do tipo std_logic responsável por iniciar o sistema. 
 - carro: Porta de entrada (chave) do tipo std_logic responsável pela contagem de carros. 
 - pedestre: Porta de entrada (chave) do tipo std_logic responsável pela contagem de pessoas. 

### 1.2 PORTAS DE SAÍDA
 - r1: Porta de saída (LED) do tipo std_logic responsável sinal vermelho do semáforo.
 - y1: Porta de saída (LED) do tipo std_logic responsável sinal amarelo do semáforo.
 - g1: Porta de saída (LED) do tipo std_logic responsável sinal verde do semáforo.
 - ped_count: Porta de saída (DISPLAY 7 SEGMENTOS) do tipo unsigned responsável pela visualização da contagem de pedestres.
 - car_count: Porta de saída (DISPLAY 7 SEGMENTOS) do tipo unsigned responsável pela visualização da contagem de carros.
 - time_display: Porta de saída (DISPLAY 7 SEGMENTOS) do tipo unsigned responsável pela visualização do tempo de cada estado.
 - visual_display: Porta de saída (DISPLAY 7 SEGMENTOS) do tipo unsigned responsável visualizar os segmentos.


### 1.3 ESTADOS

**STARTT**
 - Estado STARTT criado com valor 0, para que ele vá para o estado IDLE imediatamente, garantindo com que o estado RED assuma o valor do estado IDLE;

**START**
 - Estado IDLE para garantir a contagem total do estado RED.
 - Sem o estado IDLE, o estado RED utiliza a mesma contagem de tempo IDLE

**RED**
 - Deve ser contabilizado o tempo do estado e mostrado no display;
 - Deve ser contabilizado quantas pessoas atravessam e mostrado no displaY;
 - Não deve ser contabilizado quantas pessoas atravessam e mostrado no display;
 - O tempo do estado deve ser decrementado e chegar até 0;
 - Quando chegar em 0, o estado é alterado para o próximo estado.

**YELLOW**
 - Deve ser contabilizado o tempo do estado e mostrado no display;
 - Não deve  ser contabilizado quantas pessoas atravessam;
 - Deve  ser contabilizado o número de carros que passam e mostrado no display;
 - O tempo do estado deve ser decrementado e chegar até 0;
 - Quando chegar em 0, o estado é alterado para o próximo estado.

**GREEN**
 - Deve ser contabilizado o tempo do estado e mostrado no display;
 - Não deve  ser contabilizado quantas pessoas atravessam e mostrado no display;
 - Deve  ser contabilizado o número de carros que passam e mostrado no display;
 - O tempo do estado deve ser decrementado e chegar até 0;
 - Quando chegar em 0, o estado é alterado para o próximo estado.

## 2 PINAGEM

**Leds**
 - LEDR (0) --> r1
 - LEDR (1) --> y1
 - LEDR (2) --> g1

**Chaves**
 - SW(0) --> start
 - SW(1) --> rst
 - SW(8) --> carro
 - SW(9) --> pedestre

**Displays**

 - HEX0 --> ped_count.
 - HEX1 --> car_count.
 - HEX2 --> time_display.
 - HEX4 --> segmentos de time_display (15 a 8).
 - HEX5 --> segmentos de time_display (7 a 0).








