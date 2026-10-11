function R = applyMethod(img, id, p, pts)
%APPLYMETHOD Menjalankan satu metode dari methodCatalog pada citra.
%   p   = vektor parameter sesuai urutan di methodCatalog
%   pts = lokasi notch [dx dy] (hanya untuk 'notch')
%   Hasil R berisi:
%     H    : fungsi penapis / fungsi degradasi terpusat
%     out  : citra hasil (untuk 'motion' = hasil inverse filtering)
%     out2 : hasil Wiener filtering (hanya 'motion')
%     psf  : PSF motion blur (hanya 'motion')

    if nargin < 4, pts = []; end
    [M, N, ~] = size(img);
    R = struct('H', [], 'out', [], 'out2', [], 'psf', []);

    switch id
        case 'ilpf',   H = lowpassFilter('ideal', M, N, p(1));
        case 'glpf',   H = lowpassFilter('gaussian', M, N, p(1));
        case 'blpf',   H = lowpassFilter('butterworth', M, N, p(1), p(2));
        case 'ihpf',   H = highpassFilter('ideal', M, N, p(1));
        case 'ghpf',   H = highpassFilter('gaussian', M, N, p(1));
        case 'bhpf',   H = highpassFilter('butterworth', M, N, p(1), p(2));
        case 'bright', H = brightnessFilter(M, N, p(1), p(2));
        case 'ibrf',   H = bandrejectFilter('ideal', M, N, p(1), p(2));
        case 'bbrf',   H = bandrejectFilter('butterworth', M, N, p(1), p(2), p(3));
        case 'gbrf',   H = bandrejectFilter('gaussian', M, N, p(1), p(2));
        case 'notch'
            if isempty(pts)
                error('Isi lokasi notch terlebih dahulu (klik spike pada spektrum).');
            end
            H = notchRejectFilter(M, N, pts, p(1), p(2));
        case 'motion'
            R.psf  = motionPsf(p(1), p(2));
            R.H    = psfToOtf(R.psf, M, N);
            R.out  = filterImage(img, inverseFilter(R.H, p(3), p(4)));
            R.out2 = filterImage(img, wienerFilter(R.H, p(5)));
            return;
    end

    R.H = H;
    R.out = filterImage(img, H);
end
