function H = brightnessFilter(M, N, k, D0)
%BRIGHTNESSFILTER Penapis untuk mencerahkan citra di ranah frekuensi.
%   Kecerahan citra ditentukan oleh komponen DC F(0,0) (rata-rata
%   intensitas) dan frekuensi rendah di sekitarnya. Penapis ini menguatkan
%   komponen tersebut sebesar k dan membiarkan frekuensi tinggi (detail):
%       H = 1 + (k - 1) * exp(-D^2 / (2 D0^2))
%   k  = penguatan frekuensi rendah (k > 1 lebih terang)
%   D0 = lebar daerah frekuensi rendah yang dikuatkan. D0 kecil hanya
%        menguatkan DC (menambah konstanta), D0 besar mendekati perkalian
%        seluruh citra dengan k.

    D = distanceGrid(M, N);
    H = 1 + (k - 1) * exp(-(D.^2) / (2 * D0^2));
end
