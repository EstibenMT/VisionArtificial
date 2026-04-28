clc;
clear;
close all;

%% PUNTO 5
% Transformación lineal a trozos sobre el componente Cian en CMY

%% 1. Cargar imagen RGB
imgRGB = imread('ImagenE3.jpg');

% Validar dimensiones
disp('Tamaño de la imagen original:');
disp(size(imgRGB));

% Convertir imagen a double en rango [0,1]
imgRGB_double = im2double(imgRGB);

%% 2. Convertir RGB a CMY
% Según el modelo CMY:
% C = 1 - R
% M = 1 - G
% Y = 1 - B

imgCMY = imcomplement(imgRGB_double);

% Separar componentes
C = imgCMY(:,:,1);
M = imgCMY(:,:,2);
Y = imgCMY(:,:,3);

%% 3. Aplicar transformación lineal a trozos al componente Cian
% Parámetros:
% r1 = 60, r2 = 120, s1 = 80, s2 = 210.
% Como la imagen fue convertida con im2double, se normalizan a [0,1].

r1 = 60/255;
r2 = 120/255;
s1 = 80/255;
s2 = 210/255;

disp('Parámetros normalizados utilizados:');
disp([r1 r2 s1 s2]);

C_transformado = transformacionLinealTrozos(C, r1, s1, r2, s2);

%% 4. Reconstruir imagen CMY
imgCMY_transformada = cat(3, C_transformado, M, Y);

%% 5. Convertir CMY a RGB
imgRGB_transformada = imcomplement(imgCMY_transformada);

% Asegurar que los valores estén en el rango válido [0,1]
imgRGB_transformada = min(max(imgRGB_transformada, 0), 1);

%% 6. Mostrar resultados

figure('Name','Punto 5 - Imagen Original RGB');
imshow(imgRGB_double);
title('Imagen original RGB');

figure('Name','Punto 5 - Componente Cian Original');
imshow(C);
title('Componente Cian original');

figure('Name','Punto 5 - Componente Cian Transformado');
imshow(C_transformado);
title('Componente Cian con transformación lineal a trozos');

figure('Name','Punto 5 - Imagen Transformada');
imshow(imgRGB_transformada);
title('Imagen transformada - Cian modificado');

%% 7. Comparación para el informe

figure('Name','Comparación Punto 5');
subplot(1,2,1);
imshow(imgRGB_double);
title('Imagen original RGB');

subplot(1,2,2);
imshow(imgRGB_transformada);
title('Imagen transformada');

%% 8. Guardar imágenes resultantes

imwrite(imgRGB_double, 'Punto5_Imagen_Original_RGB.png');
imwrite(imgRGB_transformada, 'Punto5_Imagen_Transformada_RGB.png');
imwrite(C, 'Punto5_Componente_Cian_Original.png');
imwrite(C_transformado, 'Punto5_Componente_Cian_Transformado.png');

disp('Punto 5 ejecutado correctamente.');
disp('Imágenes guardadas para el informe.');

%% FUNCIÓN LOCAL
function salida = transformacionLinealTrozos(entrada, r1, s1, r2, s2)

    salida = zeros(size(entrada));

    % Tramo 1: valores entre 0 y r1
    idx1 = entrada <= r1;
    salida(idx1) = (s1 / r1) * entrada(idx1);

    % Tramo 2: valores entre r1 y r2
    idx2 = entrada > r1 & entrada <= r2;
    salida(idx2) = ((s2 - s1) / (r2 - r1)) * (entrada(idx2) - r1) + s1;

    % Tramo 3: valores mayores que r2
    idx3 = entrada > r2;
    salida(idx3) = ((1 - s2) / (1 - r2)) * (entrada(idx3) - r2) + s2;

end