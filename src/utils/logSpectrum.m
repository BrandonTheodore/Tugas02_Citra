function S = logSpectrum(img)
%LOGSPECTRUM Magnitude spectrum terpusat dalam skala log untuk ditampilkan.
%   S = log(1 + |fftshift(fft2(f))|), diskalakan ke [0,255].
%   Citra berwarna dirata-ratakan dulu menjadi grayscale.

    f = mean(double(img), 3);
    S = log(1 + abs(fftshift(fft2(f))));
    S = uint8(255 * S / max(S(:)));
end
