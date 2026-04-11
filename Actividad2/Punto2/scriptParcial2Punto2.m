% ============================================================
% PUNTO 2 - Especificación de Histograma
% Visión Artificial - Momento Evaluativo 2
% ============================================================
clc; clear; close all;

%% 1. Cargar imágenes
img_color = imread('imagenParcial2.jpg.jpeg');
img_gris  = rgb2gray(img_color);
ref       = imread('Referencia.tif');

if size(ref, 3) == 3
    ref = rgb2gray(ref);
end

%% 2. Calcular histogramas (sin toolbox)
niveles = 0:255;
hist_orig = histc(double(img_gris(:)), niveles);
hist_ref  = histc(double(ref(:)),      niveles);

%% 3. Calcular CDFs
cdf_orig = cumsum(hist_orig) / numel(img_gris);
cdf_ref  = cumsum(hist_ref)  / numel(ref);

%% 4. Construir tabla de mapeo
tabla_mapeo = zeros(256, 1, 'uint8');
for i = 1:256
    [~, j] = min(abs(cdf_ref - cdf_orig(i)));
    tabla_mapeo(i) = uint8(j - 1);
end

%% 5. Aplicar el mapeo
img_especificada = tabla_mapeo(double(img_gris) + 1);

%% 6. Calcular histograma resultante
hist_esp = histc(double(img_especificada(:)), niveles);

%% 7. Visualización - Referencia
figure('Name', 'Referencia');
subplot(1,2,1);
imshow(ref); title('Imagen de Referencia (escala de grises)');
subplot(1,2,2);
bar(niveles, hist_ref, 'FaceColor', [0.2 0.4 0.8], 'EdgeColor', 'none');
title('Histograma de la Referencia');
xlabel('Nivel de intensidad'); ylabel('Frecuencia');

%% 8. Visualización - Resultado
figure('Name', 'Especificacion');
subplot(1,2,1);
imshow(img_especificada); title('Imagen resultante (especificacion)');
subplot(1,2,2);
bar(niveles, hist_esp, 'FaceColor', [0.2 0.7 0.3], 'EdgeColor', 'none');
title('Histograma de la imagen especificada');
xlabel('Nivel de intensidad'); ylabel('Frecuencia');

%% 9. Guardar imágenes
imwrite(ref,              'ref_gris.png');
imwrite(img_especificada, 'imagen_especificada.png');

disp('¡Listo! Imágenes guardadas.');