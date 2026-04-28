clc;
clear;
close all;

%% PUNTO 6
% Ecualización del histograma en el espacio HSI

%% 1. Cargar imagen RGB
imgRGB_original = imread('ImagenE3.jpg');

if size(imgRGB_original,3) ~= 3
    error('La imagen cargada no es RGB. Debe tener 3 canales.');
end

disp('Tamaño de la imagen original:');
disp(size(imgRGB_original));

imgRGB = im2double(imgRGB_original);

%% 2. Convertir RGB a HSI
imgHSI = rgb2hsi_custom(imgRGB);

H = imgHSI(:,:,1);
S = imgHSI(:,:,2);
I = imgHSI(:,:,3);

%% 3. Ecualizar el histograma del canal de Intensidad
I_eq = histeq(I);

%% 4. Reconstruir imagen HSI con intensidad ecualizada
imgHSI_ecualizada = cat(3, H, S, I_eq);

%% 5. Convertir HSI ecualizada a RGB
imgRGB_ecualizada = hsi2rgb_custom(imgHSI_ecualizada);

imgRGB_ecualizada = min(max(imgRGB_ecualizada, 0), 1);

%% 6. Mostrar imagen original RGB individual
figure('Name','Punto 6 - Imagen Original RGB');
imshow(imgRGB);
title('Imagen original RGB');

%% 7. Mostrar imagen ecualizada HSI individual
figure('Name','Punto 6 - Imagen Ecualizada HSI');
imshow(imgRGB_ecualizada);
title('Imagen ecualizada en HSI');

%% 8. Comparación imagen original vs imagen ecualizada
figure('Name','Punto 6 - Comparación RGB vs HSI Ecualizada');
subplot(1,2,1);
imshow(imgRGB);
title('Imagen original RGB');

subplot(1,2,2);
imshow(imgRGB_ecualizada);
title('Imagen ecualizada en HSI');

%% 9. Mostrar intensidad original individual
figure('Name','Punto 6 - Intensidad Original');
imshow(I);
title('Intensidad original');

%% 10. Mostrar intensidad ecualizada individual
figure('Name','Punto 6 - Intensidad Ecualizada');
imshow(I_eq);
title('Intensidad ecualizada');

%% 11. Comparación intensidad original vs intensidad ecualizada
figure('Name','Punto 6 - Comparación de Intensidades');
subplot(1,2,1);
imshow(I);
title('Intensidad original');

subplot(1,2,2);
imshow(I_eq);
title('Intensidad ecualizada');

%% 12. Guardar imágenes en la misma carpeta del script
imwrite(imgRGB, 'Punto6_Imagen_Original_RGB.png');
imwrite(imgRGB_ecualizada, 'Punto6_Imagen_Ecualizada_HSI.png');
imwrite(I, 'Punto6_Intensidad_Original.png');
imwrite(I_eq, 'Punto6_Intensidad_Ecualizada.png');

disp('Punto 6 ejecutado correctamente.');
disp('Imágenes guardadas en la carpeta actual.');

%% ============================================================
%% FUNCIÓN RGB A HSI
%% ============================================================

function imgHSI = rgb2hsi_custom(imgRGB)

    R = imgRGB(:,:,1);
    G = imgRGB(:,:,2);
    B = imgRGB(:,:,3);

    I = (R + G + B) / 3;

    minRGB = min(min(R,G),B);
    S = 1 - (3 ./ (R + G + B + eps)) .* minRGB;

    numerador = 0.5 * ((R - G) + (R - B));
    denominador = sqrt((R - G).^2 + (R - B).*(G - B)) + eps;

    theta = acos(numerador ./ denominador);

    H = theta;
    H(B > G) = 2*pi - H(B > G);

    H = H / (2*pi);
    H(S == 0) = 0;

    imgHSI = cat(3, H, S, I);

end

%% ============================================================
%% FUNCIÓN HSI A RGB
%% ============================================================

function imgRGB = hsi2rgb_custom(imgHSI)

    H = imgHSI(:,:,1) * 2*pi;
    S = imgHSI(:,:,2);
    I = imgHSI(:,:,3);

    R = zeros(size(H));
    G = zeros(size(H));
    B = zeros(size(H));

    % Sector 1: 0 <= H < 120 grados
    idx = (H >= 0) & (H < 2*pi/3);

    B(idx) = I(idx) .* (1 - S(idx));
    R(idx) = I(idx) .* ...
        (1 + (S(idx) .* cos(H(idx))) ./ (cos(pi/3 - H(idx)) + eps));
    G(idx) = 3*I(idx) - (R(idx) + B(idx));

    % Sector 2: 120 <= H < 240 grados
    idx = (H >= 2*pi/3) & (H < 4*pi/3);

    H2 = H - 2*pi/3;

    R(idx) = I(idx) .* (1 - S(idx));
    G(idx) = I(idx) .* ...
        (1 + (S(idx) .* cos(H2(idx))) ./ (cos(pi/3 - H2(idx)) + eps));
    B(idx) = 3*I(idx) - (R(idx) + G(idx));

    % Sector 3: 240 <= H <= 360 grados
    idx = (H >= 4*pi/3) & (H <= 2*pi);

    H3 = H - 4*pi/3;

    G(idx) = I(idx) .* (1 - S(idx));
    B(idx) = I(idx) .* ...
        (1 + (S(idx) .* cos(H3(idx))) ./ (cos(pi/3 - H3(idx)) + eps));
    R(idx) = 3*I(idx) - (G(idx) + B(idx));

    imgRGB = cat(3, R, G, B);
    imgRGB = min(max(imgRGB, 0), 1);

end