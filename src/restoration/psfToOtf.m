function H = psfToOtf(psf, M, N)
%PSFTOOTF Fungsi degradasi H(u,v) terpusat berukuran M x N dari sebuah PSF.
%   PSF diletakkan pada citra nol M x N, lalu digeser agar titik tengahnya
%   berada di (1,1) supaya hasil restorasi tidak ikut bergeser.

    [m, n] = size(psf);
    h = zeros(M, N);
    h(1:m, 1:n) = psf;
    h = circshift(h, -floor([m n] / 2));
    H = fftshift(fft2(h));
end
