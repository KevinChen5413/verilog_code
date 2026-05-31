今日学习
1.initial语句(常用在测试文件中)
在仿真的初始状态对各变量进行初始化
在测试文件中生成激励波形作为电路的仿真信号

initial
   begin
    ina = 6'b000000;
    #10 ina = 6'b011001;  // #10代表相对于前一条语句的延迟时间  `timescale 10ns/1ns代表时间单位为10ns,精度是1ns
    #10 ina = 6'b011011;
    #10 ina = 6'b011000;
    #10 ina = 6'b001000;
   end

变量初始化
.....
parameter size = 16;
reg[3:0] addr;
reg reg1;
reg[7:0] memory[15:0]; //存储器有十六个单元，每个单元可以装8位
initial
   begin
    reg1 =0;
    for(addr=0;addr<size;addr=addr+1);
       memory[addr]=0;
   end
.....

2.块语句
串行块 并行块

begin end顺序进行

产生一个时序波形
parameter d = 50;
   reg[7:0] r;
   begin
     #d r=8'h55;
     #d r=8'hE2;
     #d r=8'h00;
     #d r=8'hF7;
     #d -> end_wave; //触发事件end_wave
   end  //每条语句的延迟时间d是相对于前一条语句的仿真时间

fork
    ...
join
这个语句好像无法在quartus中使用

3.赋值语句
连续赋值语句 用于对wire型变量赋值  输入变了输出立刻变
module or2(a,b,c)
   input a,b;
   output c;
   wire c; //wire!!! 但是这个wire可以缺省
   assign c= a|b;
endmodule

过程赋值语句
非阻塞型赋值方式 <=  //当这个块结束的时候，才能对变量完成赋值操作
always @(posedge clk)
   begin
    b<=a;
    c<=b;
   end

阻塞型赋值方式(这个似乎并不常用,千万别乱用...因为不符合硬件原理)
always @(posedge clk)
   begin
    b=a;
    c=b;   //阻塞赋值在该语句结束时就完成赋值操作
   end


module or2(a,b,c)
   input a,b;
   output c;
   reg c;
   always @(a or b)
      c= a|b;
endmodule

4.条件语句

if-else
格式1
if(表达式) 语句1;
格式2
if(表达式) 语句1;
else 语句2;
格式3
if(表达式1) 语句1;
else if(表达式2) 语句2;
else if(表达式3) 语句3;

条件语句可以简写
if(!expression) <==> if(expression != 1)

例:模60的BCD码加法计数器
module count60(qout,cout,data,load,cin,reset,clk);
   output [7:0] qout;
   output cout;
   input [7:0] data;
   input load,cin,reset,clk;
   reg [7:0] qout;
   always @ (posedge clk)
      begin
        if(reset)  qout = 0;
        else if (load)  qout = data;
        else if (cin)
           begin
            if(qout [3:0] == 9) //低位是否为9
               begin
                qout [3:0] = 0;
                if(qout [7:4] == 5)
                   qout [7:4] = 0;
                else
                   qout [7:4] = qout[7:4] + 1;
               end
            else
               qout [3:0] = qout [3:0] + 1;  //低位不为9，低位加1
           end
       end
    assign cout = ((qout == 8'h59) &cin) ? 1:0;  //进位输出
endmodule

5.case语句
case(敏感表达式)
   值1 : 语句1;
   ......
   值n : 语句n;
   default : 语句n+1;
endcase
//一个case中只能有一个default
//值1到n必须互不相同,位宽必须相同

例:四选1数据选择器
module mux4_1(out,a,b,c,d,select1,select0);
   output out;
   input a,b,c,d,select1,select0;
   reg out;
   always @(a or b or c or d or select1 or select0)
      case({select1,select0})  //这个是位拼接符！回忆一下啊
         2'b00:out = a;
         2'b01:out = b;
         2'b10:out = c;
         2'b11:out = d;
         default:out = 1'b0;
      endcase
endmodule

6.casex和casex语句
case语句每一位都是确定的,casez语句某些位的值为高阻态z,casex语句某些位的值为z或者x
可以用?来表示z或者x

例:用casez描述的数据选择器
module mux_z(out,a,b,c,d,select);
   input a,b,c,d;
   output out;
   input [3:0] select;
   reg out;
   always @ (select[3:0] or a or b or c or d)
   begin
     casez(select)
        4'b???1 : out=a;
        4'b??1? : out=b;
        4'b?1?? : out=c;
        4'b1??? : out=d;
     endcase
   end
endmodule

例:BCD码-七段译码器 共阴极
module decode4_7(a,b,c,d,e,f,g,indec)
output a,b,c,d,e,f,g;
input [3:0] indec;
reg a,b,c,d,e,f,g;
always @(indec)
   begin
     case(indec)
        4'd0 :{a,b,c,d,e,f,g} = 7'b1111110;
        4'd1 :{a,b,c,d,e,f,g} = 7'b0110000;
        4'd2 :{a,b,c,d,e,f,g} = 7'b1101101;
        4'd3 :{a,b,c,d,e,f,g} = 7'b1111001;
        4'd4 :{a,b,c,d,e,f,g} = 7'b0110011;
        4'd5 :{a,b,c,d,e,f,g} = 7'b1011011;
        4'd6 :{a,b,c,d,e,f,g} = 7'b1011111;
        4'd7 :{a,b,c,d,e,f,g} = 7'b1110000;
        4'd8 :{a,b,c,d,e,f,g} = 7'b1111111;
        4'd9 :{a,b,c,d,e,f,g} = 7'b1111011;
        default :{a,b,c,d,e,f,g} = 7'bx;
     endcase
   end 
endmodule

7.条件描述完整性
条件要完整,否则会生成锁存器
always@ (sel[1:0] or a or b)
   case(sel[1:0])
      2'b00: q<=a;
      2'b11: q<=b;
      default: q<= 1'b0;
   endcase

8.for语句
for(循环变量赋初值;循环执行条件;循环变量增值)
执行语句

1->2->3->2->3...... 直到执行条件为假,则跳出循环
例:for语句描述7人表决器,大于等于4人就通过
module vote7 (pass,vote);
   output pass;
   input[6:0] vote;
   reg[2:0] sum;  //sum为reg型变量，统计赞成人数
   integer i;  //信号类型声明，32位有符号数
   reg pass;
   always @(vote)  //只要有人按了vote，就执行语句
      begin
         sum=0;
         for(i=0 ; i<=6 ; i=i+1) //注意不能写i++
            if(vote[i])  
            sum=sum+1; //只要第i个人赞成，sum就加1
         if(sum[2])  //也可以写为if(sum[2:0] >= 3'd4)
            pass = 1;  //sum是3位，第三位为1，至少为100，代表有4个人投了赞成，表决通过
         else
            pass = 0;
      end
endmodule

9.repeat语句
repeat(循环次数表达式)
   begin
    ...
   end

if(rotate)
   repeat(8)
      begin
         tmp = data[15];
         data = {data << 1,tmp}; //data循环左移了8次
      end

10.while语句
有条件地执行一条或者多条语句
while (循环执行条件条件表达式)
   begin
    ...
   end

//循环条件为真，执行后面的语句。然后继续判断循环执行表达式是否为真，为真就继续执行，如果是假就不执行
//while语句一般用在测试文件中

例:用while语句对一个8位二进制数中值为1的位进行计数
module count1s(count,rega,clk);
   output[3:0] count;
   input[7:0] rega;
   input clk;
   reg[3:0] count;
   always @(posedge clk)
      begin:count1  //块名
         reg[7:0] tempreg; //中间变量
         count = 0;
         tempreg = rega;
         while(tempreg)
            begin
                if(tempreg[0])
                   count = count +1;  //只要tempreg最低位为1，那么count加1
                tempreg = tempreg >> 1; //右移1位
            end
      end
endmodule

11.forever语句
无条件连续执行forever后面的语句
还是用在测试文件中,一般用在initial语句块
initial
   begin:Clocking
     clk=0;
     forever #10 clk= !clk;
   end
initial 
   begin:Stimulus //激励
      ...
      disable Clocking; //停止时钟
   end

