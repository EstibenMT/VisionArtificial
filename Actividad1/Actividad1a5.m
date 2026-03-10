%% Limpiar
clc, clear, close all;

I = imread ('pezhombre.png');
img = imread ('pezhombre.png');
I = im2double(I);
I = im2uint8(I);

if size(img,1) ~= 1024 || size(img,2) ~= 1024
    img = imresize(img, [1024 1024]);
end

I = img;
whos I
imfinfo('pezhombre.png')

%% Visualizacion

% Imagen Completa

image(I);    % Visualizacion 
axis off;    % Quita los ejes
axis image;  % Configura los ejes para obtener pixeles 

%% Punto 1:

% Filas: 100-739 | Columnas: 200-559
img_recortada = img(100:739, 200:559, :);

figure;
imshow(img_recortada);

[alto_orig, ancho_orig, ~] = size(img);
[alto_rec, ancho_rec, ~] = size(img_recortada);

% Relación de aspecto = Ancho / Alto
ra_original = ancho_orig / alto_orig;
ra_recortada = ancho_rec / alto_rec;

fprintf('Relación de aspecto original: %.4f (1:1)\n', ra_original);
fprintf('Relación de aspecto recortada: %.4f\n', ra_recortada);


%% Punto 2:

% Reordenar canales a GBR 
img_gbr = I(:, :, [2 3 1]); 
figure, imshow(img_gbr);

% Efecto espejo horizontal 
img_espejo = I(:, end:-1:1, :);
figure, imshow(img_espejo);

% Inversión vertical 
img_invertida = I(end:-1:1, :, :);
figure, imshow(img_invertida);

%% Punto 3:

% Generar la Imagen original en Escala de Grises
I_Gray1 = rgb2gray(I);  
figure;
subplot, imshow(I_Gray1); title('Original Gris');

% Transformaciones Logaritmicas 

% Imagen T. Gamma γ = 0.4
gamma_04 = im2uint8(imadjust(I_Gray1, [], [], 0.4)); 
figure;
subplot, imshow(gamma_04); title('Imagen T. Gamma γ = 0.4');

% Imagen T. Gamma γ = 1.6
gamma_16 = im2uint8(imadjust(I_Gray1, [], [], 1.6));
figure;
subplot, imshow(gamma_16); title('Imagen T. Gamma γ = 1.6');

% Imagen T. Logaritmica
log_img = im2uint8(mat2gray(log(1 + double(I_Gray1))));
figure;
subplot, imshow(log_img); title('Imagen T. Logaritmica');


%% Punto 4: Transformaciones Lineales a Trozos

% Mostrar la Imagen Original en Escala de Grises
figure;
subplot; imshow(I_Gray1); title('Original Gris');

% Funcion Lineal a Trozos
f_trozos = @(im, r1, r2, s1, s2) uint8(interp1([0, r1, r2, 255], [0, s1, s2, 255], double(im)));

% 1:
trozos1 = f_trozos(I_Gray1, 10, 50, 35, 95);
figure;
subplot; imshow(trozos1); title('Trozos: 10, 50, 35, 95');

% 2:
trozos2 = f_trozos(I_Gray1, 60, 120, 35, 95); 
figure;
subplot; imshow(trozos2); title('Trozos: 60, 120, 35, 95');

% 3:
trozos3 = f_trozos(I_Gray1, 150, 200, 35, 95); 
figure;
subplot; imshow(trozos3); title('Trozos: 150, 200, 35, 95');

%% Punto 5: Transformaciones de Fraccionamiento de Gris

% Mostrar la Imagen Original en Escala de Grises
figure;
subplot; imshow(I_Gray1); title('Original Gris');

% Realce en rango [A-B] a 255 y lo demas a 0
f_frac = @(im, A, B) uint8((im >= A & im <= B) * 255);

% Aplicar transformaciones
% 1:
frac1 = f_frac(I_Gray1, 20, 85); 
figure;
subplot; imshow(frac1); title('A = 20, B = 85');

% 2:
frac2 = f_frac(I_Gray1, 120, 155); 
figure;
subplot; imshow(frac2); title('A = 120, B = 155');

% 3:
frac3 = f_frac(I_Gray1, 185, 230);
figure;
subplot; imshow(frac3); title('A = 185, B = 230');