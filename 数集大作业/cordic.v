`include "parameters.v"

module cordic(
    input clk,
    input rst_n,
    input signed [23:0] theta,
    input [1:0] phase_flag,
    output reg signed [15:0] y_re,
    output reg signed [15:0] y_im
);

    reg signed [15:0] x_r[18:0];//第i次旋转后的x_r坐标
    reg signed [15:0] y_r[18:0];
    reg signed [23:0] angle_remain[18:0];
    reg [1:0] phase[18:0];
//流水线
    always @(posedge clk or negedge rst_n) begin //初始
        if(rst_n == 1'b0) begin
            x_r[0] <= 0;
            y_r[0] <= 0;
            angle_remain[0] <= 0;
        end
        else begin
            x_r[0] <= `X_ORIGIN;
            y_r[0] <= 0;
            angle_remain[0] <= theta;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[1] <= 0;
            y_r[1] <= 0;
            angle_remain[1] <= 0;
        end
        else if(angle_remain[0] > 0) begin
            x_r[1] <= x_r[0] - y_r[0];
            y_r[1] <= y_r[0] + x_r[0];
            angle_remain[1] <= angle_remain[0] - `ANGLE_1;
        end
        else begin
            x_r[1] <= x_r[0] + y_r[0];
            y_r[1] <= y_r[0] - x_r[0];
            angle_remain[1] <= angle_remain[0] + `ANGLE_1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[2] <= 0;
            y_r[2] <= 0;
            angle_remain[2] <= 0;
        end
        else if(angle_remain[1] > 0) begin
            x_r[2] <= x_r[1] - (y_r[1] >>> 1);
            y_r[2] <= y_r[1] + (x_r[1] >>> 1);
            angle_remain[2] <= angle_remain[1] - `ANGLE_2;
        end
        else begin
            x_r[2] <= x_r[1] + (y_r[1] >>> 1);
            y_r[2] <= y_r[1] - (x_r[1] >>> 1);
            angle_remain[2] <= angle_remain[1] + `ANGLE_2;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[3] <= 0;
            y_r[3] <= 0;
            angle_remain[3] <= 0;
        end
        else if(angle_remain[2] > 0) begin
            x_r[3] <= x_r[2] - (y_r[2] >>> 2);
            y_r[3] <= y_r[2] + (x_r[2] >>> 2);
            angle_remain[3] <= angle_remain[2] - `ANGLE_3;
        end
        else begin
            x_r[3] <= x_r[2] + (y_r[2] >>> 2);
            y_r[3] <= y_r[2] - (x_r[2] >>> 2);
            angle_remain[3] <= angle_remain[2] + `ANGLE_3;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[4] <= 0;
            y_r[4] <= 0;
            angle_remain[4] <= 0;
        end
        else if(angle_remain[3] > 0) begin
            x_r[4] <= x_r[3] - (y_r[3] >>> 3);
            y_r[4] <= y_r[3] + (x_r[3] >>> 3);
            angle_remain[4] <= angle_remain[3] - `ANGLE_4;
        end
        else begin
            x_r[4] <= x_r[3] + (y_r[3] >>> 3);
            y_r[4] <= y_r[3] - (x_r[3] >>> 3);
            angle_remain[4] <= angle_remain[3] + `ANGLE_4;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[5] <= 0;
            y_r[5] <= 0;
            angle_remain[5] <= 0;
        end
        else if(angle_remain[4] > 0) begin
            x_r[5] <= x_r[4] - (y_r[4] >>> 4);
            y_r[5] <= y_r[4] + (x_r[4] >>> 4);
            angle_remain[5] <= angle_remain[4] - `ANGLE_5;
        end
        else begin
            x_r[5] <= x_r[4] + (y_r[4] >>> 4);
            y_r[5] <= y_r[4] - (x_r[4] >>> 4);
            angle_remain[5] <= angle_remain[4] + `ANGLE_5;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[6] <= 0;
            y_r[6] <= 0;
            angle_remain[6] <= 0;
        end
        else if(angle_remain[5] > 0) begin
            x_r[6] <= x_r[5] - (y_r[5] >>> 5);
            y_r[6] <= y_r[5] + (x_r[5] >>> 5);
            angle_remain[6] <= angle_remain[5] - `ANGLE_6;
        end
        else begin
            x_r[6] <= x_r[5] + (y_r[5] >>> 5);
            y_r[6] <= y_r[5] - (x_r[5] >>> 5);
            angle_remain[6] <= angle_remain[5] + `ANGLE_6;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[7] <= 0;
            y_r[7] <= 0;
            angle_remain[7] <= 0;
        end
        else if(angle_remain[6] > 0) begin
            x_r[7] <= x_r[6] - (y_r[6] >>> 6);
            y_r[7] <= y_r[6] + (x_r[6] >>> 6);
            angle_remain[7] <= angle_remain[6] - `ANGLE_7;
        end
        else begin
            x_r[7] <= x_r[6] + (y_r[6] >>> 6);
            y_r[7] <= y_r[6] - (x_r[6] >>> 6);
            angle_remain[7] <= angle_remain[6] + `ANGLE_7;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[8] <= 0;
            y_r[8] <= 0;
            angle_remain[8] <= 0;
        end
        else if(angle_remain[7] > 0) begin
            x_r[8] <= x_r[7] - (y_r[7] >>> 7);
            y_r[8] <= y_r[7] + (x_r[7] >>> 7);
            angle_remain[8] <= angle_remain[7] - `ANGLE_8;
        end
        else begin
            x_r[8] <= x_r[7] + (y_r[7] >>> 7);
            y_r[8] <= y_r[7] - (x_r[7] >>> 7);
            angle_remain[8] <= angle_remain[7] + `ANGLE_8;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[9] <= 0;
            y_r[9] <= 0;
            angle_remain[9] <= 0;
        end
        else if(angle_remain[8] > 0) begin
            x_r[9] <= x_r[8] - (y_r[8] >>> 8);
            y_r[9] <= y_r[8] + (x_r[8] >>> 8);
            angle_remain[9] <= angle_remain[8] - `ANGLE_9;
        end
        else begin
            x_r[9] <= x_r[8] + (y_r[8] >>> 8);
            y_r[9] <= y_r[8] - (x_r[8] >>> 8);
            angle_remain[9] <= angle_remain[8] + `ANGLE_9;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[10] <= 0;
            y_r[10] <= 0;
            angle_remain[10] <= 0;
        end
        else if(angle_remain[9] > 0) begin
            x_r[10] <= x_r[9] - (y_r[9] >>> 9);
            y_r[10] <= y_r[9] + (x_r[9] >>> 9);
            angle_remain[10] <= angle_remain[9] - `ANGLE_10;
        end
        else begin
            x_r[10] <= x_r[9] + (y_r[9] >>> 9);
            y_r[10] <= y_r[9] - (x_r[9] >>> 9);
            angle_remain[10] <= angle_remain[9] + `ANGLE_10;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[11] <= 0;
            y_r[11] <= 0;
            angle_remain[11] <= 0;
        end
        else if(angle_remain[10] > 0) begin
            x_r[11] <= x_r[10] - (y_r[10] >>> 10);
            y_r[11] <= y_r[10] + (x_r[10] >>> 10);
            angle_remain[11] <= angle_remain[10] - `ANGLE_11;
        end
        else begin
            x_r[11] <= x_r[10] + (y_r[10] >>> 10);
            y_r[11] <= y_r[10] - (x_r[10] >>> 10);
            angle_remain[11] <= angle_remain[10] + `ANGLE_11;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[12] <= 0;
            y_r[12] <= 0;
            angle_remain[12] <= 0;
        end
        else if(angle_remain[11] > 0) begin
            x_r[12] <= x_r[11] - (y_r[11] >>> 11);
            y_r[12] <= y_r[11] + (x_r[11] >>> 11);
            angle_remain[12] <= angle_remain[11] - `ANGLE_12;
        end
        else begin
            x_r[12] <= x_r[11] + (y_r[11] >>> 11);
            y_r[12] <= y_r[11] - (x_r[11] >>> 11);
            angle_remain[12] <= angle_remain[11] + `ANGLE_12;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[13] <= 0;
            y_r[13] <= 0;
            angle_remain[13] <= 0;
        end
        else if(angle_remain[12] > 0) begin
            x_r[13] <= x_r[12] - (y_r[12] >>> 12);
            y_r[13] <= y_r[12] + (x_r[12] >>> 12);
            angle_remain[13] <= angle_remain[12] - `ANGLE_13;
        end
        else begin
            x_r[13] <= x_r[12] + (y_r[12] >>> 12);
            y_r[13] <= y_r[12] - (x_r[12] >>> 12);
            angle_remain[13] <= angle_remain[12] + `ANGLE_13;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[14] <= 0;
            y_r[14] <= 0;
            angle_remain[14] <= 0;
        end
        else if(angle_remain[13] > 0) begin
            x_r[14] <= x_r[13] - (y_r[13] >>> 13);
            y_r[14] <= y_r[13] + (x_r[13] >>> 13);
            angle_remain[14] <= angle_remain[13] - `ANGLE_14;
        end
        else begin
            x_r[14] <= x_r[13] + (y_r[13] >>> 13);
            y_r[14] <= y_r[13] - (x_r[13] >>> 13);
            angle_remain[14] <= angle_remain[13] + `ANGLE_14;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[15] <= 0;
            y_r[15] <= 0;
            angle_remain[15] <= 0;
        end
        else if(angle_remain[14] > 0) begin
            x_r[15] <= x_r[14] - (y_r[14] >>> 14);
            y_r[15] <= y_r[14] + (x_r[14] >>> 14);
            angle_remain[15] <= angle_remain[14] - `ANGLE_15;
        end
        else begin
            x_r[15] <= x_r[14] + (y_r[14] >>> 14);
            y_r[15] <= y_r[14] - (x_r[14] >>> 14);
            angle_remain[15] <= angle_remain[14] + `ANGLE_15;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[16] <= 0;
            y_r[16] <= 0;
            angle_remain[16] <= 0;
        end
        else if(angle_remain[15] > 0) begin
            x_r[16] <= x_r[15] - (y_r[15] >>> 15);
            y_r[16] <= y_r[15] + (x_r[15] >>> 15);
            angle_remain[16] <= angle_remain[15] - `ANGLE_16;
        end
        else begin
            x_r[16] <= x_r[15] + (y_r[15] >>> 15);
            y_r[16] <= y_r[15] - (x_r[15] >>> 15);
            angle_remain[16] <= angle_remain[15] + `ANGLE_16;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[17] <= 0;
            y_r[17] <= 0;
            angle_remain[17] <= 0;
        end
        else if(angle_remain[16] > 0) begin
            x_r[17] <= x_r[16] - (y_r[16] >>> 16);
            y_r[17] <= y_r[16] + (x_r[16] >>> 16);
            angle_remain[17] <= angle_remain[16] - `ANGLE_17;
        end
        else begin
            x_r[17] <= x_r[16] + (y_r[16] >>> 16);
            y_r[17] <= y_r[16] - (x_r[16] >>> 16);
            angle_remain[17] <= angle_remain[16] + `ANGLE_17;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(rst_n == 1'b0) begin
            x_r[18] <= 0;
            y_r[18] <= 0;
            angle_remain[18] <= 0;
        end
        else if(angle_remain[17] > 0) begin
            x_r[18] <= x_r[17] - (y_r[17] >>> 17);
            y_r[18] <= y_r[17] + (x_r[17] >>> 17);
            angle_remain[18] <= angle_remain[17] - `ANGLE_18;
        end
        else begin
            x_r[18] <= x_r[17] + (y_r[17] >>> 17);
            y_r[18] <= y_r[17] - (x_r[17] >>> 17);
            angle_remain[18] <= angle_remain[17] + `ANGLE_18;
        end
    end

always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0) begin
        phase[0] <= 0;
        phase[1] <= 0;
        phase[2] <= 0;
        phase[3] <= 0;
        phase[4] <= 0;
        phase[5] <= 0;
        phase[6] <= 0;
        phase[7] <= 0;
        phase[8] <= 0;
        phase[9] <= 0;
        phase[10] <= 0;
        phase[11] <= 0;
        phase[12] <= 0;
        phase[13] <= 0;
        phase[14] <= 0;
        phase[15] <= 0;
        phase[16] <= 0;
        phase[17] <= 0;
        phase[18] <= 0;
    end
    else begin
        phase[0] <= phase_flag;
        phase[1] <= phase[0];
        phase[2] <= phase[1];
        phase[3] <= phase[2];
        phase[4] <= phase[3];
        phase[5] <= phase[4];
        phase[6] <= phase[5];
        phase[7] <= phase[6];
        phase[8] <= phase[7];
        phase[9] <= phase[8];
        phase[10] <= phase[9];
        phase[11] <= phase[10];
        phase[12] <= phase[11];
        phase[13] <= phase[12];
        phase[14] <= phase[13];
        phase[15] <= phase[14];
        phase[16] <= phase[15];
        phase[17] <= phase[16];
        phase[18] <= phase[17];
    end
end

always @(*) begin //坐标转换
    case(phase[18])
        2'b00 : begin
            y_re = x_r[18];
            y_im = y_r[18];
        end
        2'b01 : begin
            y_re = ~y_r[18] + 1;
            y_im = x_r[18];
        end
        2'b10 : begin
            y_re = ~x_r[18] + 1;
            y_im = ~y_r[18] + 1;
        end
        2'b11 : begin
            y_re = y_r[18];
            y_im = ~x_r[18] + 1;
        end
        default : begin
            y_re = x_r[18];
            y_im = y_r[18];
        end
    endcase
end

endmodule