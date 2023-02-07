// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
module test_machine();
	reg reset,clk, door_close, start, water_filled, detergent_added, cycle_timeout, drained, spin_timeout;
	wire door_lock, fill_value_on, soap_wash,motor_on, drain_value_on, water_wash, done; 
	
	
  automatic_washing_machine tb( reset,clk, door_close, start, water_filled, detergent_added, cycle_timeout, drained, spin_timeout, door_lock, fill_value_on, soap_wash,motor_on, drain_value_on, water_wash, done);

  initial 
    begin 
      $dumpfile("dump.vcd");
      $dumpvars;
    end
	
	
	initial
		
	begin
	clk = 0;
		reset = 1;
		start = 0;
		door_close = 0;
		water_filled = 0;
		drained = 0;
		detergent_added = 0;
		cycle_timeout = 0;
		spin_timeout = 0;
		
		#5 reset=0;
		#5 start=1;door_close=1;
		#10 water_filled=1;
		#10 detergent_added=1;
		 //water_filled=0;
		#10 cycle_timeout=1;
		//detergent_added=0;
		#10 drained=1;
		//cycle_timeout=0;
		#10 spin_timeout=1;
		//drained=0;
		
	end
	
	always
	begin
		#5 clk = ~clk;
	end
	
	initial
	begin
      $monitor("Time=%d, Clock=%b, Reset=%b, start=%b, door_close=%b, water_filled=%b, detergent_added=%b, cycle_timeout=%b, drained=%b, spin_timeout=%b, door_lock=%b, motor_on=%b, fill_valve_on=%b, drain_valve_on=%b, soap_wash=%b, water_wash=%b, done=%b",$time, clk, reset, start, door_close, water_filled, detergent_added, cycle_timeout, drained, spin_timeout, door_lock, motor_on, fill_value_on, drain_value_on, soap_wash, water_wash, done);
	end
  
    initial 
      #90 $stop;
endmodule
