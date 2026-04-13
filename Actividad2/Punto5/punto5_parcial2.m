%% PUNTO 5: Realce de bordes Laplaciano
clc; 
clear all; 
close all;

I = imread('imagenParcial2.jpg.jpeg');

I_Gray1 = rgb2gray(I);

figure;
imshow(I_Gray1);
title('Original Gris');

% Definir máscaras de REALCE (Directas)
lap4 = [0 -1 0; -1 5 -1; 0 -1 0];
lap8 = [-1 -1 -1; -1 9 -1; -1 -1 -1];

realce4 = imfilter(I, lap4, 'replicate');
realce8 = imfilter(I, lap8, 'replicate');

figure;
imshow(I); title('Original');

figure;
imshow(realce4); title('Realce 4 Vecinos');

figure;
imshow(realce8); title('Realce 8 Vecinos');

%% Guardar imagenes resultantes:
imwrite(im2uint8(realce4), 'resultado_punto5_4vecinos.jpg');
imwrite(im2uint8(realce8), 'resultado_punto5_8vecinos.jpg');
