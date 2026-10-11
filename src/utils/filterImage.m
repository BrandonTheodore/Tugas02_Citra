function out = filterImage(img, H)
%FILTERIMAGE Menerapkan fungsi transfer H(u,v) pada citra di ranah frekuensi.
%   1. F = fftshift(fft2(f))        (spektrum dengan frekuensi nol di tengah)
%   2. G = H .* F
%   3. g = real(ifft2(ifftshift(G)))
%   H berukuran sama dengan citra dan sudah terpusat. Citra berwarna
%   diproses per kanal RGB.

    out = zeros(size(img));
    for c = 1:size(img, 3)
        F = fftshift(fft2(double(img(:, :, c))));
        out(:, :, c) = real(ifft2(ifftshift(H .* F)));
    end
    out = uint8(out);       % dibulatkan dan dipotong ke [0,255]
end
