%% Punto 1 - Detección de Bordes con Filtros Kirsch N y W

clc;
clear;
close all;

%% Lectura de la imagen
img = imread('Image1.jpeg');

%% Conversión a escala de grises
if size(img,3) == 3
    gray = rgb2gray(img);
else
    gray = img;
end

gray = double(gray);

%% Máscaras de Kirsch

% Kirsch Norte (N)
kirschN = [ 5  5  5;
           -3  0 -3;
           -3 -3 -3];

% Kirsch Oeste (W)
kirschW = [ 5 -3 -3;
            5  0 -3;
            5 -3 -3];

%% Aplicación de convolución
resultN = conv2(gray, kirschN, 'same');
resultW = conv2(gray, kirschW, 'same');

%% Normalización para visualización
resultN = uint8(255 * mat2gray(abs(resultN)));
resultW = uint8(255 * mat2gray(abs(resultW)));

%% Mostrar resultados
figure;

subplot(1,3,1);
imshow(uint8(gray));
title('Imagen en Escala de Grises');

subplot(1,3,2);
imshow(resultN);
title('Filtro Kirsch N');

subplot(1,3,3);
imshow(resultW);
title('Filtro Kirsch W');