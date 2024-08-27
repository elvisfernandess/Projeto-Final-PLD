# SEMÁFORO
## ESPECIFICAÇÕES

### PORTAS DE ENTRADA
 - clk:      Porta de entrada do tipo std_logic responsável pelo clock. 
 - rst:      Porta de entrada do tipo std_logic responsável pelo rst. 
 - start:    Porta de entrada do tipo std_logic responsável por iniciar o sistema. 
 - carro:    Porta de entrada do tipo std_logic responsável pela contagem de carros. 
 - pedestre: Porta de entrada do tipo std_logic responsável pela contagem de pessoas. 

### PORTAS DE SAÍDA
 - r1:       Porta de entrada do tipo std_logic responsável pelo clock.
 - y1
 - g1
 - ped_count
 - car_count
- time_display
 - visual_display: Porta de saída do tipo unsigned responsável visualizar os segmentos .


### ESTADOS

**RED**
 - Deve ser contabilizado o tempo do estado e mostrado no display;
 - Deve ser contabilizado quantas pessoas atravessam e mostrado no display (utilizar uma chave);
 - O tempo do estado deve ser decrementado e chegar até 0;
 - Quando chegar em 0, o estado é alterado para o próximo estado.

**YELLOW**
 - Deve ser contabilizado o tempo do estado e mostrado no display;
 - Não deve  ser contabilizado quantas pessoas atravessam e e não deve ser mostradomostrado no display (utilizar uma chave);
 - Deve  ser contabilizado o número de carros que passam e mostrado no display (utilizar uma chave);
 - O tempo do estado deve ser decrementado e chegar até 0;
 - Quando chegar em 0, o estado é alterado para o próximo estado.

**GREEN**
 - Deve ser contabilizado o tempo do estado e mostrado no display;
 - Não deve  ser contabilizado quantas pessoas atravessam e mostrado no display (utilizar uma chave);
 - Deve  ser contabilizado o número de carros que passam e mostrado no display (utilizar uma chave);
 - O tempo do estado deve ser decrementado e chegar até 0;
 - Quando chegar em 0, o estado é alterado para o próximo estado.





