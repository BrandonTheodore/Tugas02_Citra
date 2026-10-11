function H = notchRejectFilter(M, N, pts, D0, n)
%NOTCHREJECTFILTER Butterworth notch reject filter H(u,v) berukuran M x N.
%   pts = matriks K x 2 berisi lokasi spike [dx dy] relatif terhadap pusat
%   spektrum. Karena spektrum simetris, pasangan (-dx,-dy) ikut ditolak:
%       H = prod_k 1/(1 + (D0/Dk)^(2n)) * 1/(1 + (D0/D-k)^(2n))
%   D0 = radius notch, n = orde (n besar mendekati notch ideal).

    if nargin < 5 || isempty(n), n = 2; end

    H = ones(M, N);
    for k = 1:size(pts, 1)
        Dk  = distanceGrid(M, N,  pts(k, 1),  pts(k, 2));
        Dmk = distanceGrid(M, N, -pts(k, 1), -pts(k, 2));
        H = H ./ (1 + (D0 ./ Dk).^(2 * n)) ./ (1 + (D0 ./ Dmk).^(2 * n));
    end
end
