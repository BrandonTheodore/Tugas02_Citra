function D = distanceGrid(M, N, dx, dy)
%DISTANCEGRID Jarak D(u,v) setiap titik frekuensi ke suatu titik pusat.
%   Pusat spektrum mengikuti fftshift, yaitu (floor(M/2)+1, floor(N/2)+1).
%   dx, dy = pergeseran titik pusat (kolom, baris), dipakai oleh notch filter.

    if nargin < 3, dx = 0; end
    if nargin < 4, dy = 0; end

    [x, y] = meshgrid(1:N, 1:M);
    cx = floor(N / 2) + 1 + dx;
    cy = floor(M / 2) + 1 + dy;
    D = sqrt((x - cx).^2 + (y - cy).^2);
end
