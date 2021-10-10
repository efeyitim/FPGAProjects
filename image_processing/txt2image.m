%TXT TO IMAGE%
clc, clear all, close all;

image = imread('./cameraman.tif');
imshow(image)
[row, col] = size(image);

file = fopen('./cameraman_result.txt', 'r');
image_res = fscanf(file, '%d');

coef = [-1 -2 -1; 0 0 0; 1 2 1];

new_image = zeros(row, col);
for k = 1 : 8
    if k == 1
        filename = './cameraman_mirror.txt';
    elseif k == 2
        filename = './cameraman_reverse.txt';
    elseif k == 3
        filename = './cameraman_negative.txt';
    elseif k == 4
        filename = './cameraman_threshold.txt';
    elseif k == 5
        filename = './cameraman_brightnessup.txt';
    elseif k == 6
        filename = './cameraman_brightnessdown.txt';
    elseif k == 7
        filename = './cameraman_contrastup.txt';
    elseif k == 8
        filename = './cameraman_contrastdown.txt';
    end
    
    file = fopen(filename, 'r');
    image_res = fscanf(file, '%d');
    for i = 1 : row
        for j = 1 : col
            new_image(i, j) = image_res((i - 1) * col + j);
        end
    end
    figure('name', filename), imshow(uint8(new_image))
end

fclose(file);