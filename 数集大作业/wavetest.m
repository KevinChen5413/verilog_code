clc;
clear;
close all;

data = load('dds_iq_out.txt');

n = data(:,1);
y_re = data(:,2);
y_im = data(:,3);

figure;
plot(n, y_re);
grid on;
xlabel('Sample Index');
ylabel('y\_re');
title('DDS Output Real Part: cos');

figure;
plot(n, y_im);
grid on;
xlabel('Sample Index');
ylabel('y\_im');
title('DDS Output Imag Part: sin');

figure;
plot(y_re, y_im);
grid on;
axis equal;
xlabel('y\_re');
ylabel('y\_im');
title('Complex DDS Trajectory');