一.verilog的门级描述
not and nand or xor xnor buf bufif1 bufif0 notif1 notif0
如何调用

assign out = (in1 & ~cntrl1 & ~cntrl2)....
系统级描述
assign out = ctrl1 ? (ctrl2? in4:in3):(ctrl2? in2:in1);  //ctrl1=1执行:前的语句,ctrl1=2执行:后的语句

二.综合设计
module gate2(F,A,B,C,D);
   output F;
   input A,B,C,D;
   assign F= (~(A&B))|(B&C&D);
endmodule

module gate3(f,a,b,c,d);
   output f;
   input a,b,c,d;
   always @(a or b or c or d)
      begin
        f = (~(a&b)) | (b&c&d);
      end

译码器
module decoder_38(out,in);
   output[7:0] out;
   input[2:0] in;
   reg[7:0] out;
   always @(in)
      begin
         case(in)
            3'd0:out=8'b11111110;
            ...
         endcase
      end
endmodule


module les_test(clk,rst,led);
   input clk;
   input rst;
   output[7:0] led;

   reg[24:0] led_light_cnt=25'd0;
   reg[7:0] led_status = 8'b00000000;

   always@(posedge clk)
   begin
      if(!rstn)
         led_light_cnt <= 
   end
