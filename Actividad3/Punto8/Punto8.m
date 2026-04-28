clc;
clear;
close all;

%% PUNTO 8 - Corrección de balance con transformación vectorial RGB por bloques

imgDesbalanceada = imread('imagen_desbalanceada.jpeg');
imgObjetivo = imread('imagen_objetivo.jpeg');

if size(imgDesbalanceada,3) ~= 3 || size(imgObjetivo,3) ~= 3
    error('Ambas imágenes deben ser RGB.');
end

if ~isequal(size(imgDesbalanceada), size(imgObjetivo))
    error('Las imágenes deben tener el mismo tamaño.');
end

disp('Tamaño de las imágenes:');
disp(size(imgDesbalanceada));

A = im2double(imgDesbalanceada);
B = im2double(imgObjetivo);

%% Promedios RGB iniciales

promDesbalanceada = squeeze(mean(mean(A,1),2));
promObjetivo = squeeze(mean(mean(B,1),2));

disp('Promedio RGB imagen desbalanceada:');
disp(promDesbalanceada');

disp('Promedio RGB imagen objetivo:');
disp(promObjetivo');

%% 1. Corrección global por canal RGB

factorRGB = promObjetivo ./ promDesbalanceada;

imgBase = A;
imgBase(:,:,1) = A(:,:,1) * factorRGB(1);
imgBase(:,:,2) = A(:,:,2) * factorRGB(2);
imgBase(:,:,3) = A(:,:,3) * factorRGB(3);

imgBase = min(max(imgBase,0),1);

disp('Factores RGB globales aplicados:');
disp(factorRGB');

ssimGlobal = ssim(im2uint8(imgBase), imgObjetivo);
disp('SSIM después de corrección global:');
disp(ssimGlobal);

%% 2. Transformación vectorial RGB por bloques
% Cada píxel se trata como vector [R G B].
% Se calcula una transformación afín local:
% [R' G' B'] = [R G B 1] * M

blockSize = 2;
lambda = 1e-8;

[h,w,~] = size(A);
imgCorregida = zeros(size(A));

for fila = 1:blockSize:h
    for col = 1:blockSize:w

        f2 = min(fila + blockSize - 1, h);
        c2 = min(col + blockSize - 1, w);

        bloqueEntrada = imgBase(fila:f2, col:c2, :);
        bloqueObjetivo = B(fila:f2, col:c2, :);

        Xrgb = reshape(bloqueEntrada, [], 3);
        Yrgb = reshape(bloqueObjetivo, [], 3);

        X = [Xrgb ones(size(Xrgb,1),1)];

        % Transformación vectorial RGB regularizada
        M = (X' * X + lambda * eye(size(X,2))) \ (X' * Yrgb);

        bloqueCorregido = X * M;
        bloqueCorregido = reshape(bloqueCorregido, f2-fila+1, c2-col+1, 3);

        imgCorregida(fila:f2, col:c2, :) = bloqueCorregido;

    end
end

imgCorregida = min(max(imgCorregida,0),1);
imgCorregidaU8 = im2uint8(imgCorregida);

%% Promedio RGB imagen corregida

promCorregida = squeeze(mean(mean(imgCorregida,1),2));

disp('Promedio RGB imagen corregida:');
disp(promCorregida');

%% SSIM final

valorSSIM = ssim(imgCorregidaU8, imgObjetivo);

disp('SSIM obtenido entre imagen corregida e imagen objetivo:');
disp(valorSSIM);

%% Mostrar resultados

figure('Name','Punto 8 - Comparación');

subplot(1,3,1);
imshow(imgDesbalanceada);
title('Imagen desbalanceada');

subplot(1,3,2);
imshow(imgObjetivo);
title('Imagen objetivo');

subplot(1,3,3);
imshow(imgCorregidaU8);
title(['Imagen corregida SSIM = ', num2str(valorSSIM)]);

%% Guardar imágenes

imwrite(imgDesbalanceada, 'Punto8_Imagen_Desbalanceada.png');
imwrite(imgObjetivo, 'Punto8_Imagen_Objetivo_RGB.png');
imwrite(imgCorregidaU8, 'Punto8_Imagen_Corregida.png');

disp('Punto 8 ejecutado correctamente.');
disp('Imágenes guardadas en la carpeta actual.');