%% Cargar imagen
img = im2double(imread('ImagenE3.jpg'));
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

%% Canal R
figure; imshow(R); title('Canal R');
imwrite(R, 'canal_R.png');

%% Canal G
figure; imshow(G); title('Canal G');
imwrite(G, 'canal_G.png');

%% Canal B
figure; imshow(B); title('Canal B');
imwrite(B, 'canal_B.png');

%% CMYK
K_cmyk = 1 - max(img, [], 3);
den = 1 - K_cmyk;
den(den == 0) = 1e-10;
C_cmyk = max(0, min(1, (1 - R - K_cmyk) ./ den));
M_cmyk = max(0, min(1, (1 - G - K_cmyk) ./ den));
Y_cmyk = max(0, min(1, (1 - B - K_cmyk) ./ den));

%% Canal C
figure; imshow(C_cmyk); title('Canal C');
imwrite(C_cmyk, 'canal_C.png');

%% Canal M
figure; imshow(M_cmyk); title('Canal M');
imwrite(M_cmyk, 'canal_M.png');

%% Canal Y
figure; imshow(Y_cmyk); title('Canal Y');
imwrite(Y_cmyk, 'canal_Y.png');

%% Canal K
figure; imshow(K_cmyk); title('Canal K');
imwrite(K_cmyk, 'canal_K.png');

%% HSI - Saturacion
minRGB = min(img, [], 3);
S_hsi = 1 - (3 ./ (R + G + B + 1e-10)) .* minRGB;
S_hsi = max(0, min(1, S_hsi));
figure; imshow(S_hsi); title('Saturacion');
imwrite(S_hsi, 'canal_Saturacion.png');

%% HSI - Tono
num = 0.5 * ((R - G) + (R - B));
den_h = sqrt((R - G).^2 + (R - B) .* (G - B));
den_h(den_h == 0) = 1e-10;
theta = acos(max(-1, min(1, num ./ den_h)));
H_hsi = theta;
H_hsi(B > G) = 2*pi - theta(B > G);
H_hsi = H_hsi / (2*pi);
figure; imshow(H_hsi); title('Tono');
imwrite(H_hsi, 'canal_Tono.png');

%% HSI - Intensidad
I_hsi = (R + G + B) / 3;
figure; imshow(I_hsi); title('Intensidad');
imwrite(I_hsi, 'canal_Intensidad.png');

disp('Las 10 imagenes fueron generadas exitosamente.');