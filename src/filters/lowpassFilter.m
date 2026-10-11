function H = lowpassFilter(type, M, N, D0, n)
%LOWPASSFILTER Fungsi transfer low-pass filter H(u,v) berukuran M x N.
%   ideal       : H = 1 jika D <= D0, selain itu 0
%   gaussian    : H = exp(-D^2 / (2 D0^2))
%   butterworth : H = 1 / (1 + (D/D0)^(2n))
%   D0 = frekuensi cut-off, n = orde Butterworth.

    if nargin < 5 || isempty(n), n = 2; end

    D = distanceGrid(M, N);
    switch type
        case 'ideal'
            H = double(D <= D0);
        case 'gaussian'
            H = exp(-(D.^2) / (2 * D0^2));
        case 'butterworth'
            H = 1 ./ (1 + (D / D0).^(2 * n));
    end
end
