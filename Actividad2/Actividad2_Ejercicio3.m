clc;
clear;
close all;

%% =========================================================
% PUNTO 3 - MOMENTO EVALUATIVO 2
%
% Genera 34 imágenes:
% 1  imagen original en gris
% 3  imágenes con ruido
% 27 imágenes filtradas
% 3  imágenes con mejor filtro
%
% Total = 34 imágenes
%% =========================================================

%% -----------------------------
% 1. CONFIGURACIÓN
%% -----------------------------
nombreImagen = 'imagenParcial2.jpg.jpeg';
carpetaSalida = 'Imagenes_Salida_Punto3';

if ~exist(carpetaSalida, 'dir')
    mkdir(carpetaSalida);
end

%% -----------------------------
% 2. LEER Y VALIDAR IMAGEN
%% -----------------------------
if ~isfile(nombreImagen)
    error('No se encontró el archivo "%s". Verifique el nombre o la ubicación.', nombreImagen);
end

I = imread(nombreImagen);
dimensiones = size(I);

if ndims(I) ~= 3 || dimensiones(1) ~= 1024 || dimensiones(2) ~= 1024 || dimensiones(3) ~= 3
    error(['La imagen no cumple con las dimensiones solicitadas. ', ...
           'Se esperaba 1024x1024x3 y se encontró %s.'], mat2str(size(I)));
end

disp('Validación correcta: la imagen tiene tamaño 1024x1024x3.');

%% -----------------------------
% 3. CONVERTIR A ESCALA DE GRIS
%% -----------------------------
Igris = rgb2gray(I);
Igris_d = im2double(Igris);

imwrite(Igris_d, fullfile(carpetaSalida, '00_Imagen_Original_Gris.png'));

%% -----------------------------
% 4. GENERAR RUIDOS
%% -----------------------------
a = 0.10;

ruidoUniforme = (2*a) * rand(size(Igris_d)) - a;
I_ruido_uniforme = Igris_d + ruidoUniforme;
I_ruido_uniforme = min(max(I_ruido_uniforme, 0), 1);

I_ruido_gaussiano = imnoise(Igris_d, 'gaussian');
I_ruido_salpimienta = imnoise(Igris_d, 'salt & pepper');

imwrite(I_ruido_uniforme,   fullfile(carpetaSalida, '01_Ruido_Uniforme.png'));
imwrite(I_ruido_gaussiano,  fullfile(carpetaSalida, '02_Ruido_Gaussiano.png'));
imwrite(I_ruido_salpimienta, fullfile(carpetaSalida, '03_Ruido_SalPimienta.png'));

imagenesRuido = {I_ruido_uniforme, I_ruido_gaussiano, I_ruido_salpimienta};
nombresRuido = {'RuidoUniforme', 'RuidoGaussiano', 'RuidoSalPimienta'};

%% -----------------------------
% 5. DEFINIR FILTROS
%% -----------------------------
filtros = {};
nombresFiltros = {};

filtros{end+1} = fspecial('average', [3 3]);
nombresFiltros{end+1} = 'Promedio_3x3';

filtros{end+1} = fspecial('average', [5 5]);
nombresFiltros{end+1} = 'Promedio_5x5';

filtros{end+1} = fspecial('average', [7 7]);
nombresFiltros{end+1} = 'Promedio_7x7';

filtros{end+1} = fspecial('gaussian', [3 3], 0.5);
nombresFiltros{end+1} = 'Gauss_3x3_sigma_0_5';

filtros{end+1} = fspecial('gaussian', [5 5], 0.5);
nombresFiltros{end+1} = 'Gauss_5x5_sigma_0_5';

filtros{end+1} = fspecial('gaussian', [7 7], 0.5);
nombresFiltros{end+1} = 'Gauss_7x7_sigma_0_5';

filtros{end+1} = fspecial('gaussian', [3 3], 1.9);
nombresFiltros{end+1} = 'Gauss_3x3_sigma_1_9';

filtros{end+1} = fspecial('gaussian', [5 5], 1.9);
nombresFiltros{end+1} = 'Gauss_5x5_sigma_1_9';

filtros{end+1} = fspecial('gaussian', [7 7], 1.9);
nombresFiltros{end+1} = 'Gauss_7x7_sigma_1_9';

numFiltros = length(filtros);
numRuidos = length(imagenesRuido);

%% -----------------------------
% 6. APLICAR FILTROS Y GUARDAR 27 IMÁGENES
%% -----------------------------
SSIM_resultados = zeros(numFiltros, numRuidos);
imagenesFiltradas = cell(numFiltros, numRuidos);

contadorArchivo = 4;

for j = 1:numRuidos
    Iruido = imagenesRuido{j};

    for i = 1:numFiltros
        h = filtros{i};

        Ifiltrada = imfilter(Iruido, h, 'replicate', 'conv');
        imagenesFiltradas{i, j} = Ifiltrada;

        SSIM_resultados(i, j) = ssim(Ifiltrada, Igris_d);

        nombreArchivo = sprintf('%02d_%s_%s.png', contadorArchivo, nombresRuido{j}, nombresFiltros{i});
        imwrite(Ifiltrada, fullfile(carpetaSalida, nombreArchivo));

        contadorArchivo = contadorArchivo + 1;
    end
end

%% -----------------------------
% 7. TABLA SSIM
%% -----------------------------
SSIM_porcentaje = SSIM_resultados * 100;

tablaSSIM = array2table(SSIM_porcentaje, ...
    'VariableNames', {'RuidoUniforme', 'RuidoGaussiano', 'RuidoSalPimienta'}, ...
    'RowNames', nombresFiltros);

disp('==============================================================');
disp('TABLA DE SSIM (%)');
disp('==============================================================');
disp(tablaSSIM);

tablaExportar = table( ...
    nombresFiltros', ...
    SSIM_porcentaje(:,1), ...
    SSIM_porcentaje(:,2), ...
    SSIM_porcentaje(:,3), ...
    'VariableNames', {'Filtro','RuidoUniforme','RuidoGaussiano','RuidoSalPimienta'} ...
);

writetable(tablaExportar, fullfile(carpetaSalida, 'Tabla_SSIM_Punto3.csv'));

%% -----------------------------
% 8. ENCONTRAR Y GUARDAR LAS 3 MEJORES
%% -----------------------------
mejorSSIM = zeros(1, numRuidos);
indiceMejorFiltro = zeros(1, numRuidos);
mejoresImagenes = cell(1, numRuidos);

for j = 1:numRuidos
    [mejorSSIM(j), indiceMejorFiltro(j)] = max(SSIM_resultados(:, j));
    mejoresImagenes{j} = imagenesFiltradas{indiceMejorFiltro(j), j};
end

imwrite(mejoresImagenes{1}, fullfile(carpetaSalida, '31_MEJOR_RuidoUniforme.png'));
imwrite(mejoresImagenes{2}, fullfile(carpetaSalida, '32_MEJOR_RuidoGaussiano.png'));
imwrite(mejoresImagenes{3}, fullfile(carpetaSalida, '33_MEJOR_RuidoSalPimienta.png'));

%% -----------------------------
% 9. MOSTRAR MEJORES RESULTADOS
%% -----------------------------
disp(' ');
disp('==============================================================');
disp('MEJORES FILTROS POR CADA IMAGEN CON RUIDO');
disp('==============================================================');

for j = 1:numRuidos
    fprintf('\nTipo de ruido: %s\n', nombresRuido{j});
    fprintf('Mejor filtro: %s\n', nombresFiltros{indiceMejorFiltro(j)});
    fprintf('SSIM: %.4f (%.2f%%)\n', mejorSSIM(j), mejorSSIM(j) * 100);
end

%% -----------------------------
% 10. REPORTE TXT
%% -----------------------------
rutaTXT = fullfile(carpetaSalida, 'Reporte_Mejores_Filtros.txt');
fid = fopen(rutaTXT, 'w');

if fid == -1
    error('No fue posible crear el archivo de reporte TXT.');
end

fprintf(fid, 'REPORTE PUNTO 3\n');
fprintf(fid, '=============================\n\n');
fprintf(fid, 'Imagen validada correctamente con tamaño 1024x1024x3.\n\n');
fprintf(fid, 'Total de imágenes generadas: 34\n');
fprintf(fid, '1 original en gris + 3 con ruido + 27 filtradas + 3 mejores.\n\n');

for j = 1:numRuidos
    fprintf(fid, 'Tipo de ruido: %s\n', nombresRuido{j});
    fprintf(fid, 'Mejor filtro: %s\n', nombresFiltros{indiceMejorFiltro(j)});
    fprintf(fid, 'SSIM: %.4f (%.2f%%)\n', mejorSSIM(j), mejorSSIM(j) * 100);
    fprintf(fid, '\n');
end

fclose(fid);

%% -----------------------------
% 11. MENSAJE FINAL
%% -----------------------------
disp(' ');
disp('==============================================================');
disp('PROCESO TERMINADO CORRECTAMENTE');
disp(['Carpeta de salida: ' carpetaSalida]);
disp('Se generaron 34 imágenes en total.');
disp('==============================================================');