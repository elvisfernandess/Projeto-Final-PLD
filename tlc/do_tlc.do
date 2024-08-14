#Cria biblioteca do projeto
vlib work

#compila projeto: todos os aquivo. Ordem é importante
vcom clock_divisor.vhd tlc.vhd tlc_tb.vhd 

#Simula (work é o diretorio, testbench é o nome da entity)
vsim -voptargs="+acc" -t ns work.tlc_tb

#Mosta forma de onda
view wave

# Adiciona ondas específicas
add wave -radix binary  /test
add wave -radix binary  /stby
add wave -radix binary  /clk
add wave -radix binary  /r1
add wave -radix binary  /y1
add wave -radix binary  /g1
add wave -radix binary  /r2
add wave -radix binary  /y2
add wave -radix binary  /g2
add wave -radix uns  /count

add wave /dut/pr_state

#Simula até um 10000ns
run 100000

wave zoomfull
write wave wave.ps