%% Limpiar
clc; clear all; close all;

% Leer imagen
I = imread('imagenParcial2.jpg.jpeg');

% Convertir a escala de grises
I_Gray1 = rgb2gray(I);

figure;
subplot(2,2,1);
imshow(I_Gray1);
title('Original Gris');

% Convertir a double para evitar problemas
I_double = double(I_Gray1);

%% ----------- SOBEL -----------

% Sobel Horizontal
Sobel_H = [1 2 1;
           0 0 0;
          -1 -2 -1];

% Sobel Vertical
Sobel_V = [1 0 -1;
           2 0 -2;
           1 0 -1];

% Aplicar convolución
Gx = conv2(I_double, Sobel_H, 'same');
Gy = conv2(I_double, Sobel_V, 'same');

% Combinar resultados
Sobel_Result = abs(Gx) + abs(Gy);

% Normalizar para visualizar
Sobel_Result = uint8(Sobel_Result);

subplot(2,2,2);
imshow(Sobel_Result);
title('Sobel combinado');

%% ----------- LAPLACIANO -----------

Laplaciano = [1 1 1;
              1 -8 1;
              1 1 1];

Lap_Result = conv2(I_double, Laplaciano, 'same');

% Valor absoluto para visualizar mejor
Lap_Result = abs(Lap_Result);
Lap_Result = uint8(Lap_Result);

subplot(2,2,3);
imshow(Lap_Result);
title('Laplaciano 8 vecinos');