clc;
clear;
close all;

%% PUNTO 7
% Filtro de realce de bordes laplaciano de 4 vecinos sobre imagen RGB

%% 1. Cargar imagen RGB
imgRGB_original = imread('ImagenE3.jpg');

% Validar que sea RGB
if size(imgRGB_original,3) ~= 3
    error('La imagen cargada no es RGB. Debe tener 3 canales.');
end

disp('Tamaño de la imagen original:');
disp(size(imgRGB_original));

% Convertir a double en rango [0,1]
imgRGB = im2double(imgRGB_original);

%% 2. Definir máscara laplaciana de 4 vecinos
%  0 -1  0
% -1  4 -1
%  0 -1  0
mascaraLaplaciana = [0 -1 0; -1 4 -1; 0 -1 0];

%% 3. Separar canales
R = imgRGB(:,:,1);
G = imgRGB(:,:,2);
B = imgRGB(:,:,3);

%% 4. Aplicar filtro laplaciano por canal
lapR = imfilter(R, mascaraLaplaciana, 'replicate');
lapG = imfilter(G, mascaraLaplaciana, 'replicate');
lapB = imfilter(B, mascaraLaplaciana, 'replicate');

imgLaplaciana = cat(3, lapR, lapG, lapB);

%% 5. Realce controlado (AJUSTE CLAVE)
alpha = 0.2; % controla la intensidad del realce

imgRGB_filtrada = imgRGB + alpha * imgLaplaciana;

% Limitar valores al rango válido
imgRGB_filtrada = min(max(imgRGB_filtrada, 0), 1);

%% 6. Mostrar imagen original
figure('Name','Punto 7 - Imagen Original RGB');
imshow(imgRGB);
title('Imagen original RGB');

%% 7. Mostrar imagen filtrada
figure('Name','Punto 7 - Imagen Filtrada Laplaciana');
imshow(imgRGB_filtrada);
title('Imagen filtrada - Laplaciano 4 vecinos');

%% 8. Comparación (IMPORTANTE PARA EL INFORME)
figure('Name','Punto 7 - Comparación');
subplot(1,2,1);
imshow(imgRGB);
title('Imagen original RGB');

subplot(1,2,2);
imshow(imgRGB_filtrada);
title('Imagen filtrada');

%% 9. Guardar imágenes (en misma carpeta)
imwrite(imgRGB, 'Punto7_Imagen_Original_RGB.png');
imwrite(imgRGB_filtrada, 'Punto7_Imagen_Filtrada_Laplaciano.png');

disp('Punto 7 ejecutado correctamente.');
disp('Imágenes guardadas en la carpeta actual.');