function fig = FrequencyApp(datasetDir)
%FREQUENCYAPP GUI pemrosesan citra dalam ranah frekuensi (Tugas 2 IF4073).
%   1. Pilih citra (dan citra referensi sebagai pembanding, opsional).
%   2. Pilih metode dan parameter, klik "Proses".
%   3. Untuk notch reject, klik spike pada spektrum masukan untuk
%      menambahkan lokasi notch.

    if nargin < 1 || isempty(datasetDir)
        datasetDir = fullfile(fileparts(fileparts(fileparts(mfilename('fullpath')))), 'dataset');
    end

    catalog = methodCatalog();
    img = [];        % citra masukan
    ref = [];        % citra referensi
    res = [];        % hasil applyMethod
    lastDir = datasetDir;

    fig = uifigure('Name', 'Tugas 2 IF4073 - Pemrosesan Citra dalam Ranah Frekuensi', 'Position', [40 40 1300 740]);
    g = uigridlayout(fig, [1 2]);
    g.ColumnWidth = {250, '1x'};

    % ---------------- panel kiri: kontrol ----------------
    left = uigridlayout(g, [21 1]);
    left.RowHeight = [{26, 18, 26, 18, 18, 22}, repmat({18, 22}, 1, 6), {26, 26, '1x'}];
    left.RowSpacing = 4;
    left.Padding = [4 4 4 4];

    uibutton(left, 'Text', 'Pilih Citra...', 'ButtonPushedFcn', @(~, ~) onOpen());
    lblImg = uilabel(left, 'Text', '-');
    uibutton(left, 'Text', 'Pilih Citra Referensi...', 'ButtonPushedFcn', @(~, ~) onOpenRef());
    lblRef = uilabel(left, 'Text', 'Referensi: -');

    uilabel(left, 'Text', 'Metode:');
    ddMethod = uidropdown(left, 'Items', {catalog.label}, 'ItemsData', {catalog.id}, ...
        'ValueChangedFcn', @(~, ~) onMethodChanged());

    paramLbl = gobjects(5, 1);
    paramFld = gobjects(5, 1);
    for k = 1:5
        paramLbl(k) = uilabel(left, 'Text', '');
        paramFld(k) = uieditfield(left, 'numeric');
    end
    lblNotch = uilabel(left, 'Text', 'Lokasi notch "dx,dy; dx,dy" (klik spektrum):');
    fldNotch = uieditfield(left, 'text');

    uibutton(left, 'Text', 'Proses', 'FontWeight', 'bold', 'ButtonPushedFcn', @(~, ~) onProcess());
    uibutton(left, 'Text', 'Simpan Hasil', 'ButtonPushedFcn', @(~, ~) onSave());
    txtInfo = uitextarea(left, 'Editable', 'off');

    % ---------------- panel kanan: tampilan ----------------
    right = uigridlayout(g, [2 3]);
    ax = gobjects(6, 1);
    for k = 1:6
        ax(k) = uiaxes(right);
        disableDefaultInteractivity(ax(k));
    end
    onMethodChanged();

    % ======================= callback =======================
    function onOpen()
        [f, p] = uigetfile({'*.png;*.jpg;*.jpeg;*.bmp;*.tif', 'Citra'}, 'Pilih citra', lastDir);
        figure(fig);
        if isequal(f, 0), return; end
        lastDir = p;
        img = readImageUint8(fullfile(p, f));
        lblImg.Text = f;
        res = [];
        fldNotch.Value = '';

        % parameter motion blur dari nama berkas, mis. "..._L19_A20.png"
        t = regexp(f, '_L(\d+)_A(-?\d+)', 'tokens', 'once');
        if ~isempty(t)
            ddMethod.Value = 'motion';
            onMethodChanged();
            paramFld(1).Value = str2double(t{1});
            paramFld(2).Value = str2double(t{2});
        end
        refresh();
    end

    function onOpenRef()
        [f, p] = uigetfile({'*.png;*.jpg;*.jpeg;*.bmp;*.tif', 'Citra'}, 'Pilih citra referensi', lastDir);
        figure(fig);
        if isequal(f, 0), return; end
        ref = readImageUint8(fullfile(p, f));
        lblRef.Text = ['Referensi: ' f];
        refresh();
    end

    function onMethodChanged()
        m = catalog(strcmp({catalog.id}, ddMethod.Value));
        for i = 1:5
            if i <= numel(m.params)
                paramLbl(i).Text = m.params{i};
                paramFld(i).Value = m.defaults(i);
                paramLbl(i).Visible = 'on';
                paramFld(i).Visible = 'on';
            else
                paramLbl(i).Visible = 'off';
                paramFld(i).Visible = 'off';
            end
        end
        isNotch = strcmp(m.id, 'notch');
        lblNotch.Visible = isNotch;
        fldNotch.Visible = isNotch;
        res = [];
        refresh();
    end

    function onProcess()
        if isempty(img)
            uialert(fig, 'Pilih citra terlebih dahulu.', 'Info');
            return;
        end
        m = catalog(strcmp({catalog.id}, ddMethod.Value));
        params = m.defaults;
        for i = 1:numel(params)
            params(i) = paramFld(i).Value;
        end
        pts = reshape(sscanf(regexprep(fldNotch.Value, '[;,]', ' '), '%f'), 2, [])';

        try
            res = applyMethod(img, m.id, params, pts);
        catch err
            uialert(fig, err.message, 'Error');
            return;
        end
        refresh();

        % ringkasan metode, parameter, dan PSNR terhadap referensi
        lines = {m.label};
        for i = 1:numel(params)
            lines{end+1} = sprintf('%s = %g', m.params{i}, params(i)); %#ok<AGROW>
        end
        if strcmp(m.id, 'notch')
            lines{end+1} = ['notch = ' fldNotch.Value];
        end
        if isequal(size(ref), size(img))
            lines{end+1} = sprintf('PSNR masukan = %.2f dB', psnrDb(img, ref));
            if isempty(res.out2)
                lines{end+1} = sprintf('PSNR hasil = %.2f dB', psnrDb(res.out, ref));
            else
                lines{end+1} = sprintf('PSNR inverse = %.2f dB', psnrDb(res.out, ref));
                lines{end+1} = sprintf('PSNR Wiener = %.2f dB', psnrDb(res.out2, ref));
            end
        end
        txtInfo.Value = lines;
    end

    function onSave()
        if isempty(res), return; end
        [f, p] = uiputfile('*.png', 'Simpan hasil', 'hasil.png');
        figure(fig);
        if isequal(f, 0), return; end
        if isempty(res.out2)
            imwrite(res.out, fullfile(p, f));
        else
            [~, n] = fileparts(f);
            imwrite(res.out,  fullfile(p, [n '_inverse.png']));
            imwrite(res.out2, fullfile(p, [n '_wiener.png']));
        end
    end

    function onSpectrumClick()
        % lokasi klik relatif terhadap pusat spektrum
        [M, N, ~] = size(img);
        pt = round(ax(2).CurrentPoint(1, 1:2));
        dx = pt(1) - (floor(N / 2) + 1);
        dy = pt(2) - (floor(M / 2) + 1);
        txtInfo.Value = {sprintf('Klik spektrum: dx = %d, dy = %d', dx, dy), ...
                         sprintf('Jarak dari pusat D = %.1f', hypot(dx, dy))};
        if strcmp(ddMethod.Value, 'notch')
            fldNotch.Value = strtrim(sprintf('%s %d,%d;', fldNotch.Value, dx, dy));
        end
    end

    function refresh()
        % menggambar ulang keenam axes sesuai metode dan hasil terakhir
        isMotion = strcmp(ddMethod.Value, 'motion');
        if isMotion
            titles = {'Citra Terdegradasi', 'Spektrum Citra Terdegradasi', '|H(u,v)| Fungsi Degradasi', ...
                      'Hasil Inverse Filtering', 'Hasil Wiener Filtering', 'Citra Referensi'};
        else
            titles = {'Citra Masukan', 'Spektrum Masukan', 'Penapis H(u,v)', ...
                      'Citra Hasil', 'Spektrum Hasil', 'Citra Referensi'};
        end

        pic = cell(1, 6);
        pic{6} = ref;
        if ~isempty(img)
            pic{1} = img;
            pic{2} = logSpectrum(img);
        end
        if ~isempty(res)
            pic{3} = uint8(255 * abs(res.H) / max(abs(res.H(:))));
            pic{4} = res.out;
            if isMotion
                pic{5} = res.out2;
            else
                pic{5} = logSpectrum(res.out);
            end
        end

        for i = 1:6
            h = showImage(ax(i), pic{i}, titles{i});
            if i == 2 && ~isempty(h)
                h.ButtonDownFcn = @(~, ~) onSpectrumClick();
            end
        end
    end
end

% ======================= fungsi bantu =======================
function v = psnrDb(a, b)
    v = 10 * log10(255^2 / mean((double(a(:)) - double(b(:))).^2));
end
