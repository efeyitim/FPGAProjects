clc, clear all, close all;

sin_file = fopen('./sin.txt', 'w');
f = 100000;
t = 1/f: 1/f : 2;

f1 = 10;
T1 = 1/f1;

f2 = 10000;
T2 = 1/f2;

% f_s = 10000;
% n_t = 1 / f_s : 1 / f_s : 2;
% 
% f_1 = 10;
% A = 1 * sin(2 * pi * n_t * f_1);
% D = round(2^20 * (A + 1));

signal1 = 0.5 * sin(2*pi*t/T1);
signal2 = 0.5 * sin(2*pi*t/T2);
signal = signal1 + signal2;
D = round(2^20 * (signal + 1));
figure, plot(D);

for i = 1:length(D)
    fprintf(sin_file, '%d\n', D(i));
end
fclose(sin_file)
