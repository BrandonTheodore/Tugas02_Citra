function M = methodCatalog()
%METHODCATALOG Daftar metode yang tersedia di program.
%   Setiap entri berisi:
%     id       : kunci internal metode
%     label    : nama yang ditampilkan di GUI
%     params   : nama parameter (maks. 5) yang dapat diubah di GUI
%     defaults : nilai default parameter

    M = [ ...
      entry('ilpf',   'B. Ideal Low-Pass Filter',        {'D0 (cut-off)'},                       60)
      entry('glpf',   'B. Gaussian Low-Pass Filter',     {'D0 (cut-off)'},                       60)
      entry('blpf',   'B. Butterworth Low-Pass Filter',  {'D0 (cut-off)', 'n (orde)'},           [60 2])
      entry('ihpf',   'C. Ideal High-Pass Filter',       {'D0 (cut-off)'},                       30)
      entry('ghpf',   'C. Gaussian High-Pass Filter',    {'D0 (cut-off)'},                       30)
      entry('bhpf',   'C. Butterworth High-Pass Filter', {'D0 (cut-off)', 'n (orde)'},           [30 2])
      entry('bright', 'D. Peningkatan Kecerahan',        {'k (penguatan)', 'D0'},                [3 100])
      entry('ibrf',   'E. Ideal Bandreject',             {'D0 (radius pita)', 'W (lebar pita)'}, [40 10])
      entry('bbrf',   'E. Butterworth Bandreject',       {'D0 (radius pita)', 'W (lebar pita)', 'n (orde)'}, [40 10 2])
      entry('gbrf',   'E. Gaussian Bandreject',          {'D0 (radius pita)', 'W (lebar pita)'}, [40 10])
      entry('notch',  'E. Notch Reject',                 {'D0 (radius notch)', 'n (orde)'},      [8 2])
      entry('motion', 'F. Motion Blur: Inverse & Wiener', ...
            {'panjang L', 'sudut (derajat)', 'threshold |H| (inverse)', 'radius (inverse, 0 = tanpa)', 'K / NSR (Wiener)'}, ...
            [15 0 0.05 0 0.01])
    ];
end

function e = entry(id, label, params, defaults)
    e = struct('id', id, 'label', label, 'params', {params}, 'defaults', defaults);
end
