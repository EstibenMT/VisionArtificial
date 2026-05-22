clc;
clear;
close all;

%% PUNTO 3 - Segmentación kmeans con características de color, bordes y morfología

%% 1. Cargar imagen
if exist('Image3.png','file')
    imgRGB_original = imread('Image3.png');
elseif exist('../Image3.png','file')
    imgRGB_original = imread('../Image3.png');
else
    error('No se encontró Image3.png. Verifique la ubicación del archivo.');
end

if size(imgRGB_original,3) ~= 3
    error('La imagen debe ser RGB.');
end

imgRGB = im2double(imgRGB_original);

[filas, columnas, canales] = size(imgRGB);

disp('Tamaño de la imagen:');
disp(size(imgRGB));

%% 2. Separar canales RGB
R = imgRGB(:,:,1);
G = imgRGB(:,:,2);
B = imgRGB(:,:,3);

%% 3. Filtro de detección de bordes a cada canal RGB
sobelX = [-1 0 1; -2 0 2; -1 0 1];
sobelY = [-1 -2 -1; 0 0 0; 1 2 1];

edgeR_x = imfilter(R, sobelX, 'replicate');
edgeR_y = imfilter(R, sobelY, 'replicate');
edgeR = mat2gray(sqrt(edgeR_x.^2 + edgeR_y.^2));

edgeG_x = imfilter(G, sobelX, 'replicate');
edgeG_y = imfilter(G, sobelY, 'replicate');
edgeG = mat2gray(sqrt(edgeG_x.^2 + edgeG_y.^2));

edgeB_x = imfilter(B, sobelX, 'replicate');
edgeB_y = imfilter(B, sobelY, 'replicate');
edgeB = mat2gray(sqrt(edgeB_x.^2 + edgeB_y.^2));

imgBordesRGB = cat(3, edgeR, edgeG, edgeB);

%% 4. Operación morfológica a cada canal RGB
SE = strel('disk', 5);

openR = imopen(R, SE);
openG = imopen(G, SE);
openB = imopen(B, SE);

imgAperturaRGB = cat(3, openR, openG, openB);

%% 5. Perfil morfológico adicional Top-Hat
topR = imtophat(R, SE);
topG = imtophat(G, SE);
topB = imtophat(B, SE);

imgTopHatRGB = cat(3, mat2gray(topR), mat2gray(topG), mat2gray(topB));

%% 6. Construcción de matriz de características
X_color = reshape(imgRGB, [], 3);
X_bordes = reshape(imgBordesRGB, [], 3);
X_apertura = reshape(imgAperturaRGB, [], 3);
X_tophat = reshape(imgTopHatRGB, [], 3);

X = [X_color X_bordes X_apertura X_tophat];

disp('Tamaño de la matriz de características X:');
disp(size(X));

%% 7. Normalizar características
X = double(X);
X(~isfinite(X)) = 0;

mediaX = mean(X,1);
desvX = std(X,0,1);
desvX(desvX == 0) = 1;

X = (X - mediaX) ./ desvX;

normas = sqrt(sum(X.^2,2));
filasCero = normas == 0;
X(filasCero,:) = eps;

%% 8. Aplicar kmeans
rng(0);

k = 5;
distancia = 'cosine';
replicas = 10;
maxIter = 1000;

opts = statset( ...
    'MaxIter', maxIter, ...
    'Display', 'final', ...
    'UseParallel', false);

idx = kmeans(X, k, ...
    'Distance', distancia, ...
    'Replicates', replicas, ...
    'MaxIter', maxIter, ...
    'Start', 'plus', ...
    'Options', opts);

imgSegmentada = reshape(idx, filas, columnas);

%% 9. Mostrar resultados
figure('Name','Punto 3 - Imagen Original');
imshow(imgRGB);
title('Imagen original RGB');

figure('Name','Punto 3 - Bordes por canal RGB');
imshow(imgBordesRGB);
title('Características de bordes RGB');

figure('Name','Punto 3 - Apertura Morfológica RGB');
imshow(imgAperturaRGB);
title('Apertura morfológica por canal RGB');

figure('Name','Punto 3 - Top-Hat RGB');
imshow(imgTopHatRGB);
title('Perfil morfológico Top-Hat RGB');

figure('Name','Punto 3 - Imagen Segmentada kmeans');
imagesc(imgSegmentada);
axis image off;
colormap(hsv(k));
colorbar;
title('Imagen segmentada con kmeans');

figure('Name','Punto 3 - Comparación General');

subplot(2,3,1);
imshow(imgRGB);
title('Original RGB');

subplot(2,3,2);
imshow(imgBordesRGB);
title('Bordes RGB');

subplot(2,3,3);
imshow(imgAperturaRGB);
title('Apertura RGB');

subplot(2,3,4);
imshow(imgTopHatRGB);
title('Top-Hat RGB');

subplot(2,3,5);
imagesc(imgSegmentada);
axis image off;
colormap(hsv(k));
title('Segmentación kmeans');

subplot(2,3,6);
imshow(label2rgb(imgSegmentada, hsv(k), 'k'));
title('Segmentación coloreada');

%% 10. Guardar imágenes
imwrite(imgRGB, 'P3_Imagen_Original_RGB.png');
imwrite(imgBordesRGB, 'P3_Bordes_RGB.png');
imwrite(imgAperturaRGB, 'P3_Apertura_Morfologica_RGB.png');
imwrite(imgTopHatRGB, 'P3_TopHat_RGB.png');
imwrite(label2rgb(imgSegmentada, hsv(k), 'k'), 'P3_Imagen_Segmentada_HSV.png');

saveas(gcf, 'P3_Comparacion_General.png');

%% 11. Mostrar parámetros usados
disp('Parámetros usados en kmeans:');
disp(['Número de clusters: ', num2str(k)]);
disp(['Distancia: ', distancia]);
disp(['Réplicas: ', num2str(replicas)]);
disp(['Máximo de iteraciones: ', num2str(maxIter)]);
disp('Imágenes guardadas en la carpeta Punto3.');