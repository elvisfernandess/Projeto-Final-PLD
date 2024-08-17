#Cria biblioteca do projeto
vlib work

#compila projeto: todos os aquivo. Ordem é importante
vcom semaforo.vhd semaforo_testbench.vhd

#Simula (work é o diretorio, semaforo_testbench é o nome da entity)
vsim -voptargs="+acc" -t ns work.semaforo_testbench

#Mosta forma de onda
view wave

#Adiciona ondas específicas
add wave -radix binary  /clk
add wave -radix binary  /rst
add wave -radix binary  /start
add wave -radix binary  /tempo_contagem
add wave -radix uns  /counter
add wave /dut/pr_state
add wave -radix binary  /r1
add wave -radix binary  /y1
add wave -radix binary  /g1
add wave -radix binary  /r2
add wave -radix binary  /y2
add wave -radix binary  /g2

#Simula até um 500ns
run 2500

wave zoomfull
write wave wave.ps