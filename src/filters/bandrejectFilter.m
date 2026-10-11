function H = bandrejectFilter(type, M, N, D0, W, n)
%BANDREJECTFILTER Fungsi transfer bandreject filter H(u,v) berukuran M x N.
%   ideal       : H = 0 jika D0 - W/2 <= D <= D0 + W/2, selain itu 1
%   butterworth : H = 1 / (1 + (D W / (D^2 - D0^2))^(2n))
%   gaussian    : H = 1 - exp(-((D^2 - D0^2) / (D W))^2)
%   D0 = radius pita yang ditolak, W = lebar pita, n = orde Butterworth.

    if nargin < 6 || isempty(n), n = 2; end

    D = distanceGrid(M, N);
    switch type
        case 'ideal'
            H = double(D < D0 - W / 2 | D > D0 + W / 2);
        case 'butterworth'
            H = 1 ./ (1 + ((D * W) ./ (D.^2 - D0^2)).^(2 * n));
        case 'gaussian'
            H = 1 - exp(-((D.^2 - D0^2) ./ (D * W)).^2);
    end
end
