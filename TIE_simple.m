function phase = TIE_simple(dIdz, I0, lambda, pixel_size)

    % Wavenumber
    k = 2*pi / lambda;

    % Avoid divide-by-zero
    I0(I0 < 1e-6) = 1e-6;

    % RHS of Poisson equation
    RHS = -k * dIdz ./ I0;

    % Size
    [Ny, Nx] = size(RHS);

    % Frequency coordinates
    fx = (-Nx/2:Nx/2-1)/(Nx*pixel_size);
    fy = (-Ny/2:Ny/2-1)/(Ny*pixel_size);
    [FX, FY] = meshgrid(fx, fy);

    % Laplacian in Fourier domain
    K2 = (2*pi*FX).^2 + (2*pi*FY).^2;

    % Avoid divide-by-zero
    K2(K2 == 0) = 1e-10;

    % FFT solve
    RHS_f = fftshift(fft2(RHS));
    phase_f = RHS_f ./ (-K2);

    % Inverse FFT
    phase = real(ifft2(ifftshift(phase_f)));

    % Remove DC offset
    phase = phase - mean(phase(:));

end
