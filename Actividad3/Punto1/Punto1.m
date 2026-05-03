% Punto 1 - Conversión a escala de grises con mapa de color negativo de jet

% Leer la imagen original
img = imread('ImagenE3.jpg');

% Convertir de RGB a escala de grises
img_gray = rgb2gray(img);

% Crear el mapa de color negativo de jet
neg_jet = 1 - jet(256);

% Graficar la imagen con el mapa de color negativo de jet
figure;
imshow(img_gray, neg_jet);
title('Imagen en escala de grises con mapa negativo de jet');
colorbar;

% Identificar la tripleta RGB para intensidad uint8 = 159
% En el mapa negativo de jet, el índice 159 corresponde a la fila 160
nivel = 159;  % valor uint8 (0-255)
indice = nivel + 1;

tripleta_rgb = neg_jet(indice, :);

fprintf('Tripleta RGB para intensidad uint8 = 159:\n');
fprintf('R = %.4f, G = %.4f, B = %.4f\n', tripleta_rgb(1), tripleta_rgb(2), tripleta_rgb(3));