%% PUNTO 2: Umbralización y Morfología
clc; 
clear all; 
close all;

img = imread('Image2.jpeg');
if size(img, 3) == 3
    img = rgb2gray(img);
end

% 1. Umbralización Otsu
nivel_otsu = graythresh(img); % 
bin_otsu = imbinarize(img, nivel_otsu);

% 2. Umbralización Adaptativa
bin_adapt = imbinarize(img, 'adaptive');

% Elemento estructurante
se = strel('disk', 2); %

% Aplicación de morfología
otsu_open = imopen(bin_otsu, se);
otsu_close = imclose(bin_otsu, se);

adapt_open = imopen(bin_adapt, se);
adapt_close = imclose(bin_adapt, se);

% Visualización
figure;
imshow(img); title('Original');

figure;
imshow(bin_otsu); title(['Otsu (lvl: ', num2str(nivel_otsu, '%.2f'), ')']);

figure;
imshow(bin_adapt); title('Adaptativa');

figure;
imshow(otsu_open); title('Otsu + Apertura');

figure;
imshow(adapt_open); title('Adaptativa + Apertura');

figure;
imshow(otsu_close); title('Otsu + Cierre');

figure;
imshow(adapt_close); title('Adaptativa + Cierre');

%% Guardar imagenes resultantes:
imwrite(im2uint8(bin_otsu), 'Otsu.jpg');
imwrite(im2uint8(bin_adapt), 'Adaptativa.jpg');
imwrite(im2uint8(otsu_open), 'Otsu + Apertura.jpg');
imwrite(im2uint8(adapt_open), 'Adaptativa + Apertura.jpg');
imwrite(im2uint8(otsu_close), 'Otsu + Cierre.jpg');
imwrite(im2uint8(adapt_close), 'Adaptativa + Cierre.jpg');


