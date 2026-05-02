% Punto 3 - Transformación en espacio YCbCr (sin toolbox)

% Leer imagen
img_rgb = imread('ImagenE3.jpg');
img_double = double(img_rgb);

R = img_double(:,:,1);
G = img_double(:,:,2);
B = img_double(:,:,3);

% Paso 1: Convertir RGB a YCbCr manualmente (estándar BT.601)
Y  =  16  + (65.481*R + 128.553*G + 24.966*B) / 255;
Cb =  128  + (-37.797*R - 74.203*G + 112.000*B) / 255;
Cr =  128  + (112.000*R - 93.786*G - 18.214*B) / 255;

% Paso 2: Aplicar negativo de transformación logarítmica sobre Cb
c = 255 / log(1 + 255);
Cb_log = c * log(1 + Cb);
Cb_modificado = 255 - Cb_log;

% Paso 3: Reconstruir YCbCr con Cb modificado
% Paso 4: Convertir YCbCr modificado de vuelta a RGB manualmente
Y2  = Y;
Cb2 = Cb_modificado;
Cr2 = Cr;

R2 = (298.082*Y2 + 408.583*Cr2) / 256 - 222.921;
G2 = (298.082*Y2 - 100.291*Cb2 - 208.120*Cr2) / 256 + 135.576;
B2 = (298.082*Y2 + 516.412*Cb2) / 256 - 276.836;

% Clipear valores al rango [0, 255] y convertir a uint8
R2 = uint8(min(max(R2, 0), 255));
G2 = uint8(min(max(G2, 0), 255));
B2 = uint8(min(max(B2, 0), 255));

img_transformada = cat(3, R2, G2, B2);

% Mostrar imágenes
figure;
subplot(1,2,1);
imshow(img_rgb);
title('Imagen original RGB');

subplot(1,2,2);
imshow(img_transformada);
title('Imagen transformada (Paso 4)');