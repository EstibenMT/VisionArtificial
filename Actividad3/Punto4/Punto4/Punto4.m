clc; 
clear all; 
close all;

% Leer la imagen original
imgRGB = imread('ImagenE3.jpg');
imgDouble = im2double(imgRGB);

% Paso 1: Convertir de RGB a YIQ
imgYIQ = rgb2ntsc(imgDouble); 

Y = imgYIQ(:,:,1);
I = imgYIQ(:,:,2);
Q = imgYIQ(:,:,3);

% Paso 2: Transformación Gamma a la Luminancia (Y) con gamma = 1.7
Y_trans = Y.^1.7;

% Paso 3: Transformar el componente I multiplicándolo por -1
I_trans = I * -1;

% Paso 4: Reconstruir la imagen YIQ
imgYIQ_mod = cat(3, Y_trans, I_trans, Q);

% Paso 5: Convertir de nuevo a RGB
imgRGB_final = ntsc2rgb(imgYIQ_mod);

figure;
imshow(imgRGB);
title('Imagen Original');

figure;
imshow(imgRGB_final);
title('Imagen Transformada');

%% Guardar imagenes resultantes:
imwrite(im2uint8(imgRGB_final), 'resultado4_Imagen Transformada.jpg');
