function psf = motionPsf(len, theta)
%MOTIONPSF PSF motion blur berupa garis lurus.
%   len   = panjang gerakan (piksel)
%   theta = arah gerakan (derajat) terhadap sumbu x citra. Karena sumbu y
%           citra mengarah ke bawah, sudut positif tampak searah jarum jam
%           (sesuai dengan data uji).
%   Piksel yang dilewati garis diberi bobot sama lalu dinormalisasi
%   sehingga jumlah PSF = 1.

    half = (len - 1) / 2;
    r = ceil(half);
    psf = zeros(2 * r + 1);

    t = linspace(-half, half, 10 * ceil(len) + 1);
    x = round(t * cosd(theta));
    y = round(t * sind(theta));
    psf(sub2ind(size(psf), y + r + 1, x + r + 1)) = 1;
    psf = psf / sum(psf(:));
end
