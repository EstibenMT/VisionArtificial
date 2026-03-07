clc; clear; close all;

%% 1) Leer imágenes
inputRGB = imread("Input.tif");     % Imagen de entrada
ref      = imread("Output.tif");    % Imagen de referencia

%% 2) Revisar dimensiones y tipo (recomendación #1 del enunciado)
disp("=== INFO DE IMAGENES ===");
disp("Input:");
disp(size(inputRGB));
disp(class(inputRGB));

disp("Referencia (Output):");
disp(size(ref));
disp(class(ref));

% Si por alguna razón no coinciden tamaños, se ajusta
if size(inputRGB,1) ~= size(ref,1) || size(inputRGB,2) ~= size(ref,2)
    inputRGB = imresize(inputRGB, [size(ref,1) size(ref,2)]);
end

%% 3) Paso 1: Transformación a escala de grises
gray = rgb2gray(inputRGB);

%% 4) Paso 2: Transformación negativa
% imcomplement invierte intensidades (255 - valor)
neg = imcomplement(gray);

%% 5) Paso 3: Transformación Gamma
% Para aplicar gamma correctamente, trabajamos en double (0..1)
neg_double = im2double(neg);
% --- Gamma = 1.5
gamma1_5_double = neg_double .^ 1.5;
gamma1_5_img    = im2uint8(gamma1_5_double);

% --- Gamma = 2
gamma2_double = neg_double .^ 2;
gamma2_img    = im2uint8(gamma2_double);


% --- Gamma = 2.5
gamma2_5_double = neg_double .^ 2.5;
gamma2_5_img    = im2uint8(gamma2_5_double);

%% 6) Calcular SSIM
% Para SSIM es buena práctica comparar en double (0..1)ambos
ref_double   = im2double(ref);

% --- Gamma = 1.5
ssim_g1_5 = ssim(im2double(gamma1_5_img), ref_double);
ssim_g1_5_pct = ssim_g1_5 * 100;

% --- Gamma = 2
ssim_g2 = ssim(im2double(gamma2_img), ref_double);
ssim_g2_pct = ssim_g2 * 100;


% --- Gamma = 2.5
ssim_g2_5 = ssim(im2double(gamma2_5_img), ref_double);
ssim_g2_5_pct = ssim_g2_5 * 100;


%-------------------------------------------------------------

fprintf("\nSSIM obtenido_G_1.5 = %.4f (%.2f%%)\n", ssim_g1_5, ssim_g1_5_pct);
fprintf("\nSSIM obtenido_G_2.0 = %.4f (%.2f%%)\n", ssim_g2, ssim_g2_pct);
fprintf("\nSSIM obtenido_G_2.5 = %.4f (%.2f%%)\n", ssim_g2_5, ssim_g2_5_pct);
%% 7) Mostrar imágenes intermedias (esto te sirve para el informe)
figure("Name","Resultados - Imágenes");
subplot(2,2,1); imshow(inputRGB); title("1) Input (RGB)");
subplot(2,2,2); imshow(gray);     title("2) Escala de grises");
subplot(2,2,3); imshow(neg);      title("3) Negativo");
subplot(2,2,4); imshow(gamma2_5_img);title("4) Gamma (g=2.5) - Final");

%% 8) Comparación visual con la referencia
figure("Name","Comparación Final vs Referencia (Gamma = 1.5)");
subplot(1,2,1); imshow(ref);        title("Referencia (Output.tif)");
subplot(1,2,2); imshow(gamma1_5_img); title(sprintf("Gamma=1.5 (SSIM %.2f%%)", ssim_g1_5_pct));

figure("Name","Comparación Final vs Referencia (Gamma = 2)");
subplot(1,2,1); imshow(ref);        title("Referencia (Output.tif)");
subplot(1,2,2); imshow(gamma2_img); title(sprintf("Gamma=2 (SSIM %.2f%%)", ssim_g2_pct));

figure("Name","Comparación Final vs Referencia (Gamma = 2.5)");
subplot(1,2,1); imshow(ref);       title("Referencia (Output.tif)");
subplot(1,2,2); imshow(gamma2_5_img); title(sprintf("Gamma=2.5 (SSIM %.2f%%)", ssim_g2_5_pct));

%% 9) (Opcional recomendado) Histogramas para justificar el efecto
figure("Name","Histogramas");
subplot(2,2,1);
imhist(gray);
title("Histograma - Grises");
xlabel("Intensidad (0 = negro, 255 = blanco)");
ylabel("Cantidad de píxeles");

subplot(2,2,2);
imhist(neg);
title("Histograma - Negativo");
xlabel("Intensidad (0 = negro, 255 = blanco)");
ylabel("Cantidad de píxeles");

subplot(2,2,3);
imhist(gamma2_5_img);
title("Histograma - Gamma final (g = 2.5)");
xlabel("Intensidad (0 = negro, 255 = blanco)");
ylabel("Cantidad de píxeles");

subplot(2,2,4);
imhist(ref);
title("Histograma - Referencia");
xlabel("Intensidad (0 = negro, 255 = blanco)");
ylabel("Cantidad de píxeles");