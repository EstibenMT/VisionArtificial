clear; clc; close all;

% Cargar la imagen del frutero (1024x1024x3)
imagenOriginal = imread('imagenParcial2.jpg');

% Convertir a escala de grises
imagenGris = rgb2gray(imagenOriginal);

% Mostrar imagen en escala de grises
figure;
imshow(imagenGris);
title('Imagen en Escala de Grises');

% Calcular histograma h(r_k) = n_k
histogramaGris = imhist(imagenGris);

% Graficar histograma
figure;
bar(0:255, histogramaGris, 'FaceColor', [0.3 0.3 0.8], 'EdgeColor', 'none');
xlabel('Nivel de Intensidad (r_k)');
ylabel('Número de Píxeles (n_k)');
title('Histograma de la Imagen en Escala de Grises');
xlim([0 255]);

% Ecualizar la imagen
imagenEcualizada = histeq(imagenGris);

% Mostrar imagen ecualizada
figure;
imshow(imagenEcualizada);
title('Imagen Ecualizada');

% Calcular histograma de la imagen ecualizada
histogramaEcualizado = imhist(imagenEcualizada);

% Graficar histograma
figure;
bar(0:255, histogramaEcualizado, 'FaceColor', [0.8 0.3 0.3], 'EdgeColor', 'none');
xlabel('Nivel de Intensidad (r_k)');
ylabel('Número de Píxeles (n_k)');
title('Histograma de la Imagen Ecualizada');
xlim([0 255]);

%------------------------------------
% Histograma normalizado p(r_k) = n_k / n
[numFilas, numColumnas] = size(imagenGris);
totalPixeles = numFilas * numColumnas;

histogramaGris = imhist(imagenGris);
probNormalizadaGris = histogramaGris / totalPixeles;

% Nivel de mayor probabilidad en imagen gris
[maxProbGris, indiceMaxGris] = max(probNormalizadaGris);
nivelMaxProbGris = indiceMaxGris - 1;
fprintf('Nivel: %d\n', nivelMaxProbGris);
fprintf('Probabilidad: %.4f%%\n', maxProbGris * 100);

% Histograma normalizado de la imagen ecualizada
histogramaEcualizado = imhist(imagenEcualizada);
probNormalizadaEq = histogramaEcualizado / totalPixeles;

% Nivel de mayor probabilidad en imagen ecualizada
[maxProbEq, indiceMaxEq] = max(probNormalizadaEq);
nivelMaxProbEq = indiceMaxEq - 1;
fprintf('Nivel: %d\n', nivelMaxProbEq);
fprintf('Probabilidad: %.4f%%\n', maxProbEq * 100);

% Probabilidad del nivel 153
probNivel153 = probNormalizadaGris(154);
fprintf('Probabilidad: %.4f%%\n', probNivel153 * 100);
