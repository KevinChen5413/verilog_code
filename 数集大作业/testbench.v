`timescale 1ns/1ps

module testbench ();

    reg clk;
    reg rst_n;
    reg [19:0] freq_k;
    reg [19:0] duty_ctrl;

    wire signed [15:0] y_re;
    wire signed [15:0] y_im;
    wire signed [15:0] square_wave;
    wire signed [15:0] triangle_wave;

    integer fp_iq;
    integer fp_wave;
    integer sample_cnt;

    initial begin
        clk <= 1'b0;
        rst_n <= 1'b0;
        freq_k <= 20'd10486;
        //duty_ctrl = 20'd262144; //25%
        duty_ctrl = 20'd524288; //50%
        //duty_ctrl = 20'd786432; //75%
        //duty_ctrl = 20'hffffff; //100%
        sample_cnt <= 0;

        fp_iq = $fopen("dds_iq_out.txt", "w");
        fp_wave = $fopen("wave_out.txt" , "w");

        #100;
        rst_n <= 1'b1;

        #10000;
        $fclose(fp_iq);
        $fclose(fp_wave);
        $stop;
    end

    always #10 clk <= ~clk;

    always @(posedge clk) begin
        if(rst_n) begin
            sample_cnt <= sample_cnt + 1;

            if(sample_cnt > 25) begin
                $fwrite(fp_iq, "%0d %0d %0d\n", sample_cnt, $signed(y_re), $signed(y_im));
                $fwrite(fp_wave , "%0d %0d %0d\n", sample_cnt, $signed(square_wave), $signed(triangle_wave));
            end
        end
    end

    dds u1(
        .clk(clk),
        .rst_n(rst_n),
        .freq_k(freq_k),
        .duty_ctrl(duty_ctrl),
        .y_re(y_re),
        .y_im(y_im),
        .square_wave(square_wave),
        .triangle_wave(triangle_wave)
    );

endmodule