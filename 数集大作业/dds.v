module dds(
    input clk,
    input rst_n,
    input [19:0] freq_k,
    output signed [15:0] y_re,
    output signed [15:0] y_im,

    input [19:0] duty_ctrl,
    output signed [15:0] square_wave,
    output signed [15:0] triangle_wave
);

    wire [23:0] theta;
    wire [1:0] phase_flag;

    phase_gen u_phase_gen(
        .clk(clk),
        .rst_n(rst_n),
        .freq_k(freq_k),
        .theta(theta),
        .phase_flag(phase_flag),
        .duty_ctrl(duty_ctrl),
        .square_wave(square_wave),
        .triangle_wave(triangle_wave)
    );

    cordic u_cordic(
        .clk(clk),
        .rst_n(rst_n),
        .theta(theta),
        .phase_flag(phase_flag),
        .y_re(y_re),
        .y_im(y_im)
    );

endmodule