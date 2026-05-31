一、//三态驱动器
module trist2 (out,in,enable);
   output out;
   input in,enable;
   bufif1 mybuf(out,in,enable);  //bufif1是门元件关键字，它实际上是一个三态门(这是verilog语言中自带的模块)mybuf是我重新命名的元件名
   //真值表 enable必须为1的时候，输入为1，输出为1；输入为0，输出也为0；enable=0
endmodule

二、//第二种写法
module trist1(out,in,enable);  //顶层模块
   output out;
   input in,enable;
   mytri tir_inst(out,in,enable);
endmodule

module mytri(out,in,enable);
   output out;
   input in,enable;
   assign out = enable ? in:'bz;
   //if enable=1,则out=in,or为高阻态，这部分相当于自己定义了一个三态门
endmodule

//between module and endmodule,必须有端口定义，i/o说明，信号类型说明，功能描述

/* 1.用assign语句
    assign x = (b & ~c);
   2.元件例化
    and myand5 (f,a,b,c);  引用了一个三输入与门，必须注意，每个实例元件的名字必须唯一，以避免和其他的调用元件实例混淆
   3.用always块语句 （一般用于描述时序逻辑电路）
    always @(posedge clk) 每当上升沿到来，执行一遍块内语句 positive and negative
       begin
          if(load)  load=1置数
             out = data;  同步置数
          else
             out = data+1+cin;
       end
   4.需要注意的是，always块语句与assign语句是同时进行的，assign语句一定要放在always块语句之外
*/


/*基本数据类型
1.integer整数形
二进制b,十进制d,十六进制h,八进制o
例如:8'b11000101等价于8'hc5

2.x表示不定值，z表示高阻态
当用二进制表示时，已标明位宽的数若用x或z表示某些位，则只有在最左边的x和z具有扩展性
例如: 8'bzx = 8'bzzzz_xxxx;8'b1x = 8'0000_001x

3. ?是z的一种表示符号，在case语句中使用？表示高阻态
例如: casez(select)
        4'b???1 : out =a;  如果最低位为1，就把a赋值给out
        4'b??1? : out =b;
        4'b?1?? : out =c;
        4'b1??? : out =d;
      endcase
4.负数
在位宽前添加一个减号，如： -8'd5 5的补码，就是8'b11111011
较长的数字之间可以用下划线隔开  16'b1010_1011_1101_1111

parameter参数形(常量)
用parameter来定义一个标识符，代表一个常量
格式 parameter 参数名 = 表达式
parameter width =16;
parameter pai = 3.14;
parameter byte_size = 8; byte_msb = byte_size - 1;

reg寄存器形
wire线形
*/

/*变量
常用的是网络型nets type,寄存器型register type,数组memory type
一.网络型表示门电路等实体之间的物理连接
1.wire,tri连线类型
在模块中，wire往往不用写
wire 数据1，数据2，...
wire[n-1:0] 数据1，数据2，数据m  (一共有m条总线，每条总线的位宽为n)

2.register型 (寄存器型)
对应触发器、寄存器等能够保持状态的元件，常常用来表示过程块语句
常用register型变量：reg integer real time
register型与nets型的区别：register型变量需要被明确赋值，并且在被重新赋值之前一直保持原值
register型变量必须通过过程赋值语句进行赋值，不能通过assign赋值

3.reg型变量
往往代表触发器
reg 数据名1，数据名2，数据n
reg[n-1:0] 数据1，... ，数据m

4.memory型
由若干个相同宽度的reg型向量构成的数组
memory型变量可以描述RAM ROM和reg文件
reg[n-1:0]每个存储单元位宽为n

memory型和reg型变量不一样
例：
reg[n-1:0] rega; //一个n位的寄存器
reg mema [n-1:0]; //由n个1位的寄存器组成的存储器 mema为存储单元名

赋值方式也不一样：一个n位的寄存器可以用一条赋值语句进行赋值，一个完整的存储器则不行
rega = 0；合法
mema = 0；不合法
mema[8]= 1;
mema[1023:0] = 0;这两种方式都是合法的

*/