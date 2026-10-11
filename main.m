function main(datasetDir)
%MAIN Titik masuk program Tugas 2 IF4073 - Pemrosesan Citra dalam Ranah Frekuensi.
%   main            -> membuka GUI dengan dataset di ./dataset
%   main(folder)    -> membuka GUI dengan folder dataset lain

    root = fileparts(mfilename('fullpath'));
    addpath(genpath(fullfile(root, 'src')));

    if nargin < 1 || isempty(datasetDir)
        datasetDir = fullfile(root, 'dataset');
    end
    FrequencyApp(datasetDir);
end
