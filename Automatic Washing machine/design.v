// Code your design here
// Code your design here
// Code your design here
module automatic_washing_machine(
  input reset,clk, door_close, start, water_filled, detergent_added, cycle_timeout, drained, spin_timeout, 
  output reg door_lock, fill_value_on, soap_wash,motor_on, drain_value_on, water_wash, done); 
	
	//defining the states
	parameter check_door = 3'b000;
	parameter fill_water = 3'b001;
	parameter add_detergent =3'b010;
	parameter cycle = 3'b011;
	parameter drain_water = 3'b100;
	parameter spin = 3'b101;
	
	reg[2:0] current_state, next_state;
	
  always@(current_state or start or door_close or water_filled or detergent_added or drained or cycle_timeout or spin_timeout)
	begin
	case(current_state)
		check_door:
          if(start==1 && door_close==1)//means door_lock and fill water
			begin
				next_state = fill_water;
				motor_on = 0;
				fill_value_on = 0;
				drain_value_on = 0;
				door_lock = 1;
				soap_wash = 0;
				water_wash = 0;
				done = 0;
			end
			else  //else remains in same state
			begin
				next_state = current_state;
				motor_on = 0;
				fill_value_on = 0;
				drain_value_on = 0;
				door_lock = 0;
				soap_wash = 0;
				water_wash = 0;
				done = 0;
			end
			
      
			fill_water:
              if (water_filled==1)//if water is filled next state either adding  detergent or cycle based on soap_wash
				begin
                  if(soap_wash == 0) //if clothes are not washed by detergent than next state be add detergent else water wash takes place
                    begin
					next_state = add_detergent;
					motor_on = 0;
					fill_value_on = 0;
					drain_value_on = 0;
					door_lock = 1;
					soap_wash = 1;
					water_wash = 0;
					done = 0;
				    end
			      else
				    begin
					next_state = cycle;
					motor_on = 0;
					fill_value_on = 0;
					drain_value_on = 0;
					door_lock = 1;
					soap_wash = 1;
					water_wash = 1;
					done = 0;
				    end
                end
			 else
			   begin
				next_state = current_state;
				motor_on = 0;
				fill_value_on = 1;
				drain_value_on = 0;
				door_lock = 1;
				done = 0;
			   end
      
      
			add_detergent:
              if(detergent_added==1) //after adding detergent next step be washing by cycle and moter will be on
			begin
				next_state = cycle;
				motor_on = 1;
				fill_value_on = 0;
				drain_value_on = 0;
				door_lock = 1;
				soap_wash = 1;
				done = 0;
			end
			else
			begin
				next_state = current_state;
				motor_on = 0;
				fill_value_on = 0;
				drain_value_on = 0;
				door_lock = 1;
				soap_wash = 1;
				water_wash = 0;
				done = 0;
			end
      
      
			cycle:
              if(cycle_timeout == 1)//if wash completed motor off and next state be drain water
			begin
				next_state = drain_water;
				motor_on = 0;
				fill_value_on = 0;
				drain_value_on = 0;
				door_lock = 1;
				soap_wash = 1;
				done = 0;
			end
			else
			begin
				next_state = current_state;
				motor_on = 1;
				fill_value_on = 0;
				drain_value_on = 0;
				door_lock = 1;
				soap_wash = 1;
				done = 0;
			end
      
      
			drain_water:
              if(drained==1) //next state will be either fill_water or spin 
			 begin
               if(water_wash==0) //if water wash not takes place fill water again
				begin
					next_state = fill_water;
					motor_on = 0;
					fill_value_on = 0;
					drain_value_on = 0;
					door_lock = 1;
					soap_wash = 1;
					done = 0;
				end
				else
				begin
				next_state = spin;
					motor_on = 0;
					fill_value_on = 0;
					drain_value_on = 0;
					door_lock = 1;
					soap_wash = 1;
					water_wash = 1;
					done = 0;
				end
			end
			else
			begin
				next_state = current_state;
				motor_on = 0;
				fill_value_on = 0;
				drain_value_on = 1;
				door_lock = 1;
				soap_wash = 1;
				done = 0;
			end
      
      
			spin:
              if(spin_timeout==1) //if spine is completed means cloths are washed 
			begin
				next_state = door_close;
				motor_on = 0;
				fill_value_on = 0;
				drain_value_on = 0;
				door_lock = 0;
				soap_wash = 1;
				water_wash = 1;
				done = 1;
			end
			else
			begin
				next_state = current_state;
				motor_on = 0;
				fill_value_on = 0;
				drain_value_on = 1;
				door_lock = 1;
				soap_wash = 1;
				water_wash = 1;
				done = 0;
			end
      
      
			default:
				next_state = check_door;
				
			endcase
	end
	
	always@(posedge clk or negedge reset)
	begin
		if(reset)
		begin
			current_state<=3'b000;
		end
		else
		begin
			current_state<=next_state;
		end
	end
	
endmodule