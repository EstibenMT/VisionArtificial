%% PUNTO 4: Problema de Conteo
clc; 
clear all; 
close all;

img4 = imread('Image4.jpeg');
if size(img4, 3) == 3
    img4 = rgb2gray(img4);
end

% 1. Filtrado para eliminar ruido tipo "grano"
img_filtro = medfilt2(img4, [3 3]);

figure;
imshow(img_filtro); title('paso 1: Filtro de Mediana (Ruido reducido)');

% 2. SEGMENTACIÓN: Metodo Adaptativa
% Aporta: Separa objetos de fondo incluso si hay sombras desiguales
bin = imbinarize(img_filtro, 'adaptive', 'Sensitivity', 0.5);
bin = imcomplement(bin); %Invertir a que los objetos sean blancos

figure;
imshow(bin); title('paso 2: Metodo Adaptativa');

% 3. MORFOLOGÍA: Limpieza y consolidación
% Aporta: 'imopen' quita el ruido residual, 'imfill' cierra huecos internos
se = strel('disk', 3); % Definimos elemento estructurante circular
bin_limpia = imopen(bin, se); % Eliminamos puntos pequeños (ruido)
bin_final = imfill(bin_limpia, 'holes'); % Rellenamos vacíos dentro de los objetos

figure;
imshow(bin_final); title(['3. Morfología y Conteo: ', num2str(num), ' objetos']);

% 4. CONTEO: Etiquetado de componentes
% Aporta: Identifica y agrupa los píxeles conectados como objetos únicos
[L, num] = bwlabel(bin_final); 
disp(['El número de elementos contados es: ', num2str(num)]);

% Mostrar el resultado numérico en consola
figure;
imshow(label2rgb(L, 'jet', 'k', 'shuffle'));
title(['Conteo final: ', num2str(num)]);

%% Guardar imagenes resultantes:
imwrite(im2uint8(img_filtro), 'Paso 1 Filtrado.jpg');
imwrite(im2uint8(bin), 'Paso 2 Segmentacion.jpg');
imwrite(im2uint8(bin_final), 'Paso 3 Morfologia.jpg');
imwrite(im2uint8(label2rgb(L, 'jet', 'k', 'shuffle')), 'Paso 4 Conteo.jpg');

