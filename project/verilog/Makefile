pixelTop:
	iverilog -g2012 -o pixelTop -c pixelTop.fl
	vvp -n pixelTop

pixelState:
	iverilog -g2012 -o pixelState -c pixelState.fl
	vvp -n pixelState

ysfsm_pixelState:
	-rm pixelState.png
	yosys pixelState.ys
	dot pixelState.dot -Tpng > pixelState.png

clean:
	-rm *_netlist.v
	-rm *.dot
	-rm *.png
	-rm *.vcd
	-rm pixelTop
	-rm pixelState
	-rm write_file.txt


