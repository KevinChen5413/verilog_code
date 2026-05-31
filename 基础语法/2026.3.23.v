1.task语句
当希望能对一些信号进行运算并且输出多个结果，宜采用任务结构
任务定义:
task<任务名>
端口和数据类型声明语句
其他语句；
endtask

//任务调用:  <任务名> (端口1，端口2，...)
//注意任务的定义和调用必须在一个module里，一个任务可以调用其他任务和函数
//任务只能在相同模块内定义和调用

例:
task my_task;
   input a,b;
   inout c;  //可以用来输入，也可以用来输出
   output d,e;
   ...
   <语句>
   ...
   c = foo1;
   d = foo2;
   e = foo5;
endtask

任务调用  my_task(v,w,x,y,z) //任务启动时，由v,w,x传入的变量赋给了a,b,c;任务完成后,输出通过c,d,e赋给了x,y,z

例:通过任务调用完成4个4位二进制输入数据的冒泡程序
module sort4(ra,rb,rc,rd,a,b,c,d);
   input[3:0] a,b,c,d;
   output[3:0] ra,rb,rc,rd;
   reg[3:0] ra,rb,rc,rd;
   reg[3:0] va,vb,vc,vd;  //中间变量，用于存放两个数据比较的结果
   always @(a or b or c or d)
      begin
         {va,vb,vc,vd} = {a,b,c,d};
         //任务调用
         sort2(va,vc);  //比较va和vc，较小的数据存入va
         sort2(vb,vd);  //存入vb
         sort2(va,vb);  //将va，vb比较，较小的放到va(最小数)
         sort2(vc,vd);  //较小的数存入vc，此时vd是最大的
         sort2(vb,vc);  //较小的数放到vb
         {ra,rb,rc,rd} = {va,vb,vc,vd};
      end
    task sort2;  //感觉很像自定义函数调用
       inout[3:0] x,y;  //双向类型
       reg[3:0] tmp;
       if(x>y)
          begin
            tmp = x; 
            x=y;
            y=tmp;  //这一套下来相当于数值对调
          end
    endtask
endmodule

2.function语句
函数在模块内部定义，通常在本模块调用
//定义
function<位宽或类型说明>函数名
端口声明;
局部变量定义;
其他语句;
endfunction
//调用
<函数名> (<表达式> <表达式>);  //与函数定义中的输入变量一一对应

//函数的定义不能包含任何时间控制语句 #延迟 @事件控制 wait等待
//函数不能调用任务
//定义函数至少要有一个输入变量，并且必须有一条赋值语句，给函数中的一个内部寄存器赋予函数的结果，该内部寄存器与函数同名

例1:对一个8位二进制数中的0的个数进行计数
module count0_function(number,rega);
   input[7:0] rega;
   output[7:0] number;

   function[7:0] gefun;
      input[7:0] x;
      reg[7:0] count;
      integer i;
         begin
             count = 0;
             for(i=0 ; i<=7 ; i=i+1)
                if(x[i] == 1'b0)  count = count+1;  //第i位为0，那么count就加1
             gefun = count;  //判断了8次后把count赋值给gefun
         end
   endfunction

   assign number = gefun(rega);  //调用函数
endmodule

例2:用函数实现8-3优先编码器
module code8_3(din,dout);
   input[7:0] din;
   output[2:0] dout;

   function[2:0] code;
     input[7:0] din;
     if(din[7])  code=3'd7;
     else if(din[6])  code=3'd6;
     else if(din[5])  code=3'd5;
     else if(din[4])  code=3'd4;
     else if(din[3])  code=3'd3;
     else if(din[2])  code=3'd2;
     else if(din[1])  code=3'd1;
     else if(din[0])  code=3'd0;
   endfunction

   assign dout = code(din);
endmodule

3.宏定义define
//编译向导语句以英文符号"`"开头，是键盘左上角esc下面的那个符号
格式 `define 标识符(宏名) 字符串(宏内容)

`define IN ina+inb+inc+ind //建议在定义宏名时尽量用大写
//用一个有含义的名字代替一个没有含义的数字和符号
//宏的定义范围是整个源文件
//引用定义的宏名时，必须在前面加上符号"`"
注意:完全不需要在后面加分号，否则会把分号也加进去了
例如:
  `define Expression a+b+c+d;
  assign out = `Expression + e;
  //相当于 assign out = a+b+c+d;+e; 语法错误

module test;
   reg a,b,c;
   wire out;
   `define A a+b
   `define C c+`A
   assign out = `C;
endmodule

4.文件包含 `include语句
格式:  `include "文件名"
`include "file2.v"

例：16位加法器

`include "adder.v"

module adder_16(cout,sum,a,b,cin)
   output cout;
   parameter my_size = 16;
   output [my_size-1:0] sum;
   input [my_size-1:0] a,b;
   input cin;
   adder #(my_size) my_adder(cout,sum,a,b,cin);  //#()语句为参数例化，在调用过程中把my_size传输到size里，强制让函数里的size=1变成了16
endmodule

/*1位加法器
module adder(a,b,cin,cout,sum);
   output cout;
   parameter size = 1;
   output[size-1:0] sum;
   input[size-1:0] a,b;
   input cin;
   assign{cout,sum} = a+b+cin;
endmodule
*/
注意: `include "aaa.v" "bbb.v"非法
//如果被包含的文件和该文件不在同一个文件下，必须把文件路径指明

5.时间尺度语句 `timescale
`timescale <时间单位>/<时间精度>

`timescale 10ns/1ns
...
reg sel;
initial 
  begin
    #10 sel=0;  //在10ns*10时刻，sel变量被赋值为0
    #10 sel=1;  //在10ns*20时刻,...
  end

