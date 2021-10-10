%IMAGE TO TXT%
clc, clear all, close all;

image = imread('./cameraman.tif');
file = fopen('./cameraman.txt', 'w');

[row, col] = size(image);

for i = 1 : row
    for j = 1 : col
        if i == row && j == col
            fprintf(file, '%d', image(i,j));
        else
            fprintf(file, '%d\n', image(i,j));
        end
    end
end

fclose(file);