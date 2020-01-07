// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By David Bar-On  June 2018 

module byterec 	
 ( 
   input	   logic  clk,
	input	   logic  resetN, 
	input	   logic  din_new,
	input	   logic  [7:0] din,
   output  logic [8:0]	keyCode,	
   output  logic 	make,	
   output  logic 	brake	
	 
  ) ;


     enum  logic [3:0] { idle_ST     ,   // initial state
                   sample_nor_ST     ,   // sample out reg of normal scan
                   new_make_ST       ,   // anounce out new make
                   wait_rel_ST       ,   // wait for code after release code
                   sample_rel_ST     ,   // sample out new code of released key
                   new_break_ST      ,   // anounce out new make
                   wait_ext_ST       ,   // wait for code after extended code
                   sample_ext_ST     ,   // sample out new extended code
                   wait_ext_rel_ST   ,   // wait for code after ext-rel code
                   sample_ext_rel_ST }   // sample out new extended-rel code
	 present_state , next_state;


  logic extended  ; // extended bit acts as msb of code table
  logic oe  ; // output enable of output register

  
  // commade decoder    code classifier (combinatorial)
		assign nor_code  = (( din > 16'd00 ) &&  ( din < 16'd132 ))  ; // normal code up to 131
		assign ext_code  =  ( din == 16'd224 ); // extended code E0
		assign rel_code  =  ( din == 16'd240 ) ; // relese code   F0

						
        // E1 -- part of scan code of key 126 (Pause-Break)
        // 00 - buffer overflow (
        // AA - keyboad passed self test
        // EE - response to echo command
        // FA - keyboad acknowledge command
        // FC - 2 bad messages in a row
        // FE - reserved message
  
// next state and output latch 
	always_ff @(posedge clk or negedge resetN)
	begin: fsm_sync_proc
		if (resetN == 1'b0) begin 
			present_state <= idle_ST ; 
			keyCode <= 8'h00 ;
  		end 	
		else begin 
	     present_state <= next_state;
        if (oe == 1'b1) 
				keyCode <= { extended, {din [7:0]}} ;
		end  
	end // end fsm_sync_proc
 
   
 
  // combinational part of state machine (moore)
   always_comb  
   begin
      // default outputs (to avoid latches)
      make  = 1'b0 ;
      brake = 1'b0 ;
      oe    = 1'b0 ;
      extended   = 1'b0 ;
		next_state = present_state ;
	
      case (present_state )
  
      idle_ST : begin 
 //   ----------------------
           if (din_new == 1'b1) 
			  begin; 
               if ( nor_code )
                  next_state = sample_nor_ST ;
						else if (rel_code )
							next_state = wait_rel_ST ;
							else if (ext_code )
								next_state = wait_ext_ST ;
			 end  
      end  
		
      sample_nor_ST : begin
 //   ----------------------
          oe = 1'b1 ;
          next_state = new_make_ST ;
		end
		
      new_make_ST : begin
 //    ----------------------
          make    = 1'b1 ;
          next_state = idle_ST ;
		end 
			 
     wait_rel_ST : begin
   //        ----------------------
          if  (din_new == 1'b1) 
			  begin 
               if (nor_code ) 
                  next_state = sample_rel_ST ;
               else
                  next_state = idle_ST ;
          end  
      end 
  

    sample_rel_ST : begin
 //  ----------------------
         oe = 1'b1 ;
         next_state = new_break_ST ;
	end 
 
    new_break_ST : begin
 //    ----------------------
         brake   = 1'b1 ;
         next_state = idle_ST ;
 end 
 
 wait_ext_ST : begin
 //    ----------------------
         if (din_new == 1'b1 ) 
				begin 	
			      if   ( nor_code ) 
                  next_state <= sample_ext_ST ;
               else if (rel_code ) 
                  next_state = wait_ext_rel_ST ;
               else
                  next_state = idle_ST ;
         end ;
   end  
	
sample_ext_ST : begin
//        ----------------------
         oe  = 1'b1 ;
         extended = 1'b1 ;
         next_state = new_make_ST ;
 end  

 wait_ext_rel_ST : begin
     //        ----------------------
        if (din_new == 1'b1 )
		   begin  
               if (nor_code ) 
                  next_state = sample_ext_rel_ST ;
               else
                  next_state = idle_ST ;
         end  
   
  end  

  sample_ext_rel_ST : begin
 //  ----------------------
          oe  = 1'b1 ;
            extended = 1'b1 ;
            next_state = new_break_ST ;
  end 
   default : begin   
  //      ----------------------
          next_state = idle_ST ;  // bad states recover
 end 
			
endcase
 
end // comb  
 
 
endmodule

