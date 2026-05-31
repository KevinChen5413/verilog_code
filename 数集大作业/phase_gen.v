`include "parameters.v"

module phase_gen(
    input clk,
    input rst_n,
    input [19:0] freq_k,
    output [23:0] theta,
    output [1:0] phase_flag,

    //可调占空比方波和三角波
    input [19:0] duty_ctrl,//方波占空比控制字
    output signed [15:0] square_wave,
    output signed [15:0] triangle_wave
);

    reg [19:0] cnt;
    wire [17:0] cnt_post;

    localparam [22:0] twopi_Q20= 23'd6588397;//2*pai*2^20=6.283*1048576=6588397
    wire [40:0] theta_mul;

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0)
            cnt <= 20'd0;
        else
            cnt <= cnt + freq_k;
    end

    assign phase_flag = cnt[19:18]; //象限
    assign cnt_post = cnt[17:0]; //当前象限内部相位的位置

    assign theta_mul = cnt_post * twopi_Q20;
    assign theta = theta_mul >> 20;


    assign square_wave = (cnt < duty_ctrl) ? 16'sd20000 : -16'sd20000;

    wire [15:0] phase16;
    wire [15:0] tri_unsigned;
    wire signed [16:0] tri_center;

    assign phase16 = cnt[19:4];

    assign tri_unsigned = (phase16[15] == 1'b0) ?
                          {phase16[14:0], 1'b0} :
                          {~phase16[14:0], 1'b0};
    assign tri_center = $signed({1'b0 , tri_unsigned}) - 17'sd32768;

    assign triangle_wave = tri_center[16:1];
endmodule
