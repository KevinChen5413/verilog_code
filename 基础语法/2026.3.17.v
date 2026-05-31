/*
3.4运算符

1、算术运算符 + - * / %
2、逻辑运算符 
@@逻辑与运算
||逻辑或
！逻辑非  逻辑非的优先级最高
逻辑运算符把操作数当作逻辑变量：非0的操作数被认为是真(1'b1) 0被认为是假(1'b0) 不确定的操作数，如4'bxx00
可能是0，也可能不是0，所以4'bxx00等效于1'bx 但是4'bxx11肯定是真变量，应该是1'b1

(a>b)&&(b>c)
(a==b)||(x==y)
(!a)||(a>b)

3、位运算符
~按位取反
&按位与
|按位或
^按位异或
^~按位同或

4、关系运算符
< <= > >= 结果为1就是真，0就是反
5、等式运算
==等于 !=不等于 ===全等 !==不全等 
注意:  ==运算符，两个操作数必须逐位相等，结果才是1  x==x的结果是不定值
       用===运算符，两个操作数相应的位数完全一致，则结果为1  x===x结果是1，不是x！即使x是未知数
例： if(A == 1'bx) $display("AisX") 当A为不定值时，if(A == 1'bx)的运算结果为x，该语句不执行
     if(A === 1'bx) $dispaly("AisX") 当A是不定值，1'bx也是不定值，if(A === 1'bx)的结果为1，语句会执行

6、缩位运算符
& ~& | `~| ^ ~^
缩位运算符必须放在操作数前面
reg[3:0] a;
b = |a; ooo这就是缩位 //这个b= |a语句实际上就是 b = ((a[0] | a[1]) | a[2]) | a[3]
运算结果缩减为了1位二进制数

7、移位运算符
>>右移  <<左移
A >> n  将操作数右移或者左移n位，同时用n个0填补移出的空位
例：4'b1001 >> 3 = 4'b0001;
   4'b1001 << 1 = 5'b10010;
   4'b1001 << 2 = 6'b100100;
   将操作数右移或者左移n位，相当于操作数除以或者乘以2^n次方

8、条件运算符
格式  信号=条件 ? 表达式1:表达式2 //当条件为真，信号取表达式1的值；条件为假，信号取表达式2的值
例:  assign out = sel? in1:in0;  sel为1，输出in1 这就是2选1数据选择器

9、位拼接运算符{}
用于将几个信号的某些位拼接起来，表示一个整体信号
例1: output[3:0] sum;
     output cout;
     input[3:0] ina,inb;
     input cin;
     assign {cout,sum} = ina+inb+cin; cout和sum位拼接
例2: {a,b[3:0],w,3'b101}

还可以用 {4{w}}等价于{w,w,w,w}
还可以用 {b,3{a,b}}={b,{a,b},{a,b},{a,b}}

*/


/*语句
1、always语句 在仿真过程中被反复执行
always块中的被赋值的只能是register型变量（reg,integer,real,time）
格式  always <时序控制> <语句>
例: always @ (posedge clk or negedge clear)  //上升沿 或 清零信号clear的下降沿
    begin
      if(!clear) 
        qout=0;
      else
        qout=1;
    end

如果对信号进行赋值，那就必须要写信号声明 reg[7:0] counter;

敏感信号可以是单个信号也可以是多个信号，多个信号中间要用or



*/

always可以是边沿触发,也可以是电平触发
always@ (a or b or c)
begin
     ...
end

always块中有多个信号时,必须采用if   else if的语句,否则时钟会出现混乱,无法编译
例如
always @ (posedge min_clk or negedge reset)
begin
     if(reset)
     min <= 0;
     else if(min=8'h59)  //当reset=0且min=8'h59的时候才能进行下一行 等价于reset=1'b0 and min=8'h59
       begin
          min <= 0;
          h_clk <= 1;
       end
     end

在一个语句块中的所有always块都是并行的

module parall(q,a,clk);
   output q,a;
   input clk;
   reg q,a;  //这个就相当于寄存器了，类似于vhdl
   always @ (posedge clk)
      begin
          a= ~q;
      end
   always @ (posedge clk)
      begin
          q = ~q;
      end
endmodule


module hex_counter_top(
    input   wire            clk,          // 系统时钟 27MHz
    input   wire            rst_n,        // 复位信号
    input   wire            key_add,      // 加1按键
    output  wire [1:0]      DI,
    output  wire [1:0]      SCK,
    output  wire [1:0]      RCK
);

    reg key_add_r0,key_add_r1;

    always@(posedge clk or negedge rst_n)
    begin
       if(!rst_n)
            key_add_r0 <= 1'b0;
            key_add_r1 <= 1'b0;
       else
            key_add_r0 <= key_add;
            key_add_r1 <= key_add_r0;
    end

    wire key_add_pos;
    assign key_add_pos = key_add_r0 & (~key_add_r1);
    reg [3:0] cnt;
    always@(posedge clk or negedge rst_n)
    begin
      if(!rst_n)
         cnt <= 4'd0;
      else if(key_add_pos)
         cnt <= (cnt==4'd15) ? 4'd0 : cnt+1'b1;
    end

    wire [15:0] scan_cnt;
    scan_timer u_scan_timer(
       .clk (clk),
       .rst_n (rst_n),
       .cnt (scan_cnt)
    );

    digital_ctrl u_digital_ctrl(
       .clk  (clk),
       .rst_n (rst_n),
       .scan_cnt (scan_cnt),
       .data_in (cnt),
       .DI (DI),
       .SCK (SCK),
       .RCK (RCK)
    );
endmodule    
