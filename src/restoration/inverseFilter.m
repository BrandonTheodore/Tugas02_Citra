function R = inverseFilter(H, thr, radius)
%INVERSEFILTER Fungsi transfer inverse filter R(u,v) = 1 / H(u,v).
%   F^(u,v) = G(u,v) / H(u,v) tidak stabil ketika |H| sangat kecil karena
%   derau ikut dikuatkan, sehingga dibatasi dengan dua cara:
%   thr    : frekuensi dengan |H| < thr dibuang (R = 0)
%   radius : hanya frekuensi dalam radius ini yang direstorasi, memakai
%            Butterworth low-pass orde 10 (0 = tanpa pembatasan radius)

    R = zeros(size(H));
    ok = abs(H) >= thr;
    R(ok) = 1 ./ H(ok);

    if radius > 0
        [M, N] = size(H);
        R = R .* lowpassFilter('butterworth', M, N, radius, 10);
    end
end
