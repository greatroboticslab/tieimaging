clear; clc; close all;

%% ============================================================
%  TIE Phase Retrieval - Clean 3D Surface Reconstruction
%% ============================================================

%% Step 1: Load & Preprocess
I_plus  = imread('zplus copy.JPG');
I0      = imread('I04 copy.JPG');
I_minus = imread('zminus copy.JPG');

if size(I_plus,3)  == 3; I_plus  = rgb2gray(I_plus);  end
if size(I0,3)      == 3; I0      = rgb2gray(I0);       end
if size(I_minus,3) == 3; I_minus = rgb2gray(I_minus);  end

I_plus  = double(I_plus);
I0      = double(I0);
I_minus = double(I_minus);

I_plus  = imresize(I_plus,  size(I0));
I_minus = imresize(I_minus, size(I0));

% Crop central region
[M_full, N_full] = size(I0);
crop_frac = 0.70;
r1 = round(M_full*(1-crop_frac)/2);
c1 = round(N_full*(1-crop_frac)/2);
r2 = r1 + round(M_full*crop_frac) - 1;
c2 = c1 + round(N_full*crop_frac) - 1;
I_plus  = I_plus(r1:r2, c1:c2);
I0      = I0(r1:r2, c1:c2);
I_minus = I_minus(r1:r2, c1:c2);

% Normalize each image to its own mean
I_plus  = I_plus  / mean(I_plus(:));
I0      = I0      / mean(I0(:));
I_minus = I_minus / mean(I_minus(:));

[M, N] = size(I0);
fprintf('Image size: %d x %d\n', M, N);

%% Gaussian smooth helper
smooth2d = @(img, sigma) conv2(img, ...
    (exp(-linspace(-3*sigma,3*sigma,2*ceil(3*sigma)+1).^2/(2*sigma^2)))' * ...
     (exp(-linspace(-3*sigma,3*sigma,2*ceil(3*sigma)+1).^2/(2*sigma^2))) / ...
    sum(reshape((exp(-linspace(-3*sigma,3*sigma,2*ceil(3*sigma)+1).^2/(2*sigma^2)))' * ...
     (exp(-linspace(-3*sigma,3*sigma,2*ceil(3*sigma)+1).^2/(2*sigma^2))),1,[])), 'same');

%% Step 2: Parameters
dz         = 0.5e-2;
lambda     = 532e-9;
pixel_size = 5e-6;

%% Step 3: dI/dz with heavy pre-smoothing
sigma_input = 8;                          % heavy pre-smooth to kill JPEG noise
I_plus_s  = smooth2d(I_plus,  sigma_input);
I_minus_s = smooth2d(I_minus, sigma_input);
I0_s      = smooth2d(I0,      sigma_input);

dIdz = (I_plus_s - I_minus_s) / (2 * dz);

% Coordinate grids
[X, Y] = meshgrid(1:N, 1:M);
Xn = (X - N/2) / (N/2);
Yn = (Y - M/2) / (M/2);

% 4th order polynomial background removal
A_bg = [ones(M*N,1), Xn(:), Yn(:), ...
        Xn(:).^2, Yn(:).^2, Xn(:).*Yn(:), ...
        Xn(:).^3, Yn(:).^3, Xn(:).^2.*Yn(:), Xn(:).*Yn(:).^2, ...
        Xn(:).^4, Yn(:).^4, Xn(:).^2.*Yn(:).^2];

dIdz_corr = dIdz - reshape(A_bg * (A_bg \ dIdz(:)), M, N);
dIdz_corr = smooth2d(dIdz_corr, 6);      % smooth after background removal

%% Step 4: TIE Solver
epsilon      = 0.1;
I0_w         = I0_s ./ (I0_s.^2 + epsilon^2);
rhs          = -(2*pi/lambda) * (dIdz_corr .* I0_w);
rhs          = rhs - mean(rhs(:));

[kx, ky]     = meshgrid((-N/2:N/2-1)/(N*pixel_size), (-M/2:M/2-1)/(M*pixel_size));
kx = fftshift(kx); ky = fftshift(ky);
k2           = kx.^2 + ky.^2;

phi_fft      = fft2(rhs) ./ (-4*pi^2*(k2 + 1e8));
phi_fft(1,1) = 0;
phase        = real(ifft2(phi_fft));
phase        = phase - mean(phase(:));
phase        = smooth2d(phase, 6);        % smooth phase

% Background removal from phase
phase_corr   = phase - reshape(A_bg * (A_bg \ phase(:)), M, N);

%% Step 5: Height + Final Smoothing
height_nm    = (lambda * phase_corr / (4*pi)) * 1e9;
height_nm    = smooth2d(height_nm, 25);  % final heavy smooth
height_nm    = height_nm - mean(height_nm(:));

fprintf('\nHeight range: %.2f nm\n', max(height_nm(:)) - min(height_nm(:)));
fprintf('Std: %.2f nm\n', std(height_nm(:)));

%% Step 6: 2D Height Map
figure('Name','Height Map','Color','k');
imagesc(height_nm); 
colormap(jet); 
cb = colorbar; cb.Color = 'w'; cb.Label.String = 'Height (nm)'; cb.Label.Color = 'w';
title('Surface Height Map','Color','w','FontSize',12);
xlabel('X (pixels)','Color','w'); ylabel('Y (pixels)','Color','w');
set(gca,'Color','k','XColor','w','YColor','w'); axis image;

%% Step 7: 3D Surface — Profilometer Style
figure('Name','3D Surface','Color','k','Position',[50 50 1000 750]);

% Downsample
ds = max(1, round(min(M,N)/300));
Xd = X(1:ds:end, 1:ds:end) * pixel_size * 1e6;   % pixels -> microns
Yd = Y(1:ds:end, 1:ds:end) * pixel_size * 1e6;
Hd = height_nm(1:ds:end, 1:ds:end);

surf(Xd, Yd, Hd, 'EdgeColor','none');
shading interp;

% Terrain colormap: blue-teal-green-yellow-red (profilometer style)
cmap = [
    0.05 0.20 0.50;
    0.10 0.40 0.55;
    0.15 0.58 0.45;
    0.25 0.68 0.30;
    0.50 0.75 0.20;
    0.75 0.80 0.15;
    0.92 0.82 0.20;
    0.95 0.65 0.25;
    0.90 0.40 0.30;
    0.80 0.20 0.25];
colormap(interp1(linspace(0,1,size(cmap,1)), cmap, linspace(0,1,256)));

% Dual lighting for terrain depth
lighting gouraud;
material([0.35 0.75 0.25 15]);
light('Position',[ 1  0.5  2], 'Style','infinite','Color',[1.00 0.95 0.80]);
light('Position',[-1 -0.5  1], 'Style','infinite','Color',[0.25 0.30 0.50]);

view(225, 30);   % diamond angle like profilometer
axis tight;

% Styled axes
set(gca,'Color','k','XColor',[0.6 0.6 0.6],'YColor',[0.6 0.6 0.6],...
    'ZColor',[0.6 0.6 0.6],'GridColor',[0.25 0.25 0.25],'FontSize',10);
xlabel('X (\mum)','Color',[0.7 0.7 0.7],'FontSize',11);
ylabel('Y (\mum)','Color',[0.7 0.7 0.7],'FontSize',11);
zlabel('Height (nm)','Color',[0.7 0.7 0.7],'FontSize',11);
title('Surface Reconstruction','Color','w','FontSize',14,'FontWeight','bold');
cb2 = colorbar; cb2.Color = [0.7 0.7 0.7];
cb2.Label.String = 'Height (nm)'; cb2.Label.Color = [0.7 0.7 0.7];
cb2.FontSize = 9;

%% Step 8: Diagnostics figure
figure('Name','Diagnostics','Position',[100 100 1200 400]);
subplot(1,3,1); imagesc(I0);       colormap(gca,gray); colorbar; title('I0');              axis image;
subplot(1,3,2); imagesc(dIdz_corr);colormap(gca,gray); colorbar; title('dI/dz (cleaned)'); axis image;
subplot(1,3,3); imagesc(phase_corr);colormap(gca,jet); colorbar; title('Phase');            axis image;
