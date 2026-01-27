%date 26/01/2026
%created by - kuldeep saini 

clc;
clear;
close all;

% Read a color image
rgb_img = imread('cartoon_image.jpg');

% Resize image to reduce computation 

figure;
imshow(rgb_img);
title('Original Color Image');

% Convert RGB image to grayscale
gray_img = rgb2gray(rgb_img);
[rows, cols] = size(gray_img);

figure;
imshow(gray_img);
title('Grayscale Image');

% Convert grayscale image into column vector
img_vec = gray_img(:);

% Find unique gray levels
symbols = unique(img_vec);

% Calculate frequency of each symbol
freq = histcounts(img_vec, [symbols; max(symbols)+1]);

% Calculate probability
prob = freq / sum(freq);

% Sort symbols based on probability
[prob_sorted, idx] = sort(prob, 'descend');
symbols_sorted = symbols(idx);

% Shannon code length calculation
code_len = ceil(-log2(prob_sorted));

% Generate Shannon codes
shannon_code = cell(length(symbols_sorted),1);
cum_prob = 0;

for i = 1:length(symbols_sorted)
    shannon_code{i} = dec2bin(floor(cum_prob * 2^code_len(i)), code_len(i));
    cum_prob = cum_prob + prob_sorted(i);
end

% Encoding (store codes in cell array to avoid slow string growth)
encoded_bits = cell(length(img_vec),1);

for i = 1:length(img_vec)
    symbol_index = find(symbols_sorted == img_vec(i), 1);
    encoded_bits{i} = shannon_code{symbol_index};
end

% Final encoded bitstream
encoded_stream = [encoded_bits{:}];

% Reconstructed image (Shannon is lossless)
reconstructed_img = reshape(img_vec, rows, cols);

figure;
imshow(reconstructed_img);
title('Reconstructed Image after Shannon Coding');

% Compression calculation
original_bits   = numel(img_vec) * 8;
compressed_bits = length(encoded_stream);
compression_ratio = original_bits / compressed_bits;

fprintf('Original size (bits)   : %d\n', original_bits);
fprintf('Compressed size (bits) : %d\n', compressed_bits);
fprintf('Compression Ratio      : %.2f\n', compression_ratio);
