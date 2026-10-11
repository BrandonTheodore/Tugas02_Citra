function H = highpassFilter(type, M, N, D0, n)
%HIGHPASSFILTER Fungsi transfer high-pass filter H(u,v) berukuran M x N.
%   H_hp = 1 - H_lp, sehingga:
%   ideal       : H = 0 jika D <= D0, selain itu 1
%   gaussian    : H = 1 - exp(-D^2 / (2 D0^2))
%   butterworth : H = 1 / (1 + (D0/D)^(2n))

    if nargin < 5 || isempty(n), n = 2; end
    H = 1 - lowpassFilter(type, M, N, D0, n);
end
