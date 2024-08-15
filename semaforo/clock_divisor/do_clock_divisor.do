#Cria biblioteca do projeto
vlib work

#compila projeto: todos os aquivo. Ordem é importante
vcom clock_divisor.vhd clock_divisor_tb.vhd

#Simula (work é o diretorio, testbench é o nome da entity)
vsim -voptargs="+acc" -t ns work.clock_divisor_tb

#Mosta forma de onda
view wave

# Adiciona ondas específicas
add wave -radix binary  /clk_in
add wave -radix binary  /rst
add wave -radix binary  /clk_out
add wave -radix uns  /count_out


#Simula até um 10000ns
run 100000

wave zoomfull
write wave wave.ps