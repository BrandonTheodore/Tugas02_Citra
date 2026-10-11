function R = wienerFilter(H, K)
%WIENERFILTER Fungsi transfer penapis Wiener.
%       R = conj(H) / (|H|^2 + K)
%   K = noise-to-signal ratio (NSR). K = 0 sama dengan inverse filter,
%   K lebih besar menekan derau tetapi hasil menjadi lebih blur.

    R = conj(H) ./ (abs(H).^2 + K);
end
