clc;
clear;
close all;

data = load('wave_out.txt');

n = data(:,1);
square_wave = data(:,2);
triangle_wave = data(:,3);

fs = 50e6;
t = n / fs;

figure;
stairs(t * 1e6, square_wave);
grid on;
xlabel('Time / us');
ylabel('square\_wave');
title('Duty Adjustable Square Wave');

figure;
plot(t * 1e6, triangle_wave);
grid on;
xlabel('Time / us');
ylabel('triangle\_wave');
title('Triangle Wave');