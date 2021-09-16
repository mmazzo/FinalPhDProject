function [MUdata] = PFcurvefits(MUdata)
% Fit exponential/power curves to PCA and pCSI data
muscles = {};
    if isempty(MUdata.MG)
    else
        muscles = [muscles,{'MG'}];
    end
    if isempty(MUdata.LG)
    else
        muscles = [muscles,{'LG'}];
    end
    if isempty(MUdata.SOL)
    else
        muscles = [muscles,{'SOL'}];
    end
% --------- Individual Muscles -----------------------------------------
for m = 1:length(muscles)
    mus = muscles{m};
    % pCSI
    if ~isfield(MUdata.(mus),'pCSI')
    else
        fn = fieldnames(MUdata.(mus).pCSI);
        for d = 1:length(fn)
            dat = fn{d};
            if ~isfield(MUdata.(mus).pCSI,dat)
                MUdata.(mus).pCSI.(dat).pCSI = NaN;
                MUdata.(mus).pCSI.(dat).fit = NaN;
                MUdata.(mus).pCSI.(dat).gof = NaN;
                MUdata.(mus).pCSI.(dat).coeffs = NaN;
                MUdata.(mus).pCSI.(dat).xcoh1 = NaN;
            else
                if ~isfield(MUdata.(mus).pCSI.(dat),'pCSI')
                MUdata.(mus).pCSI.(dat).pCSI = NaN;
                MUdata.(mus).pCSI.(dat).fit = NaN;
                MUdata.(mus).pCSI.(dat).gof = NaN;
                MUdata.(mus).pCSI.(dat).coeffs = NaN;
                MUdata.(mus).pCSI.(dat).xcoh1 = NaN;
                elseif isnan(MUdata.(mus).pCSI.(dat).pCSI)
                MUdata.(mus).pCSI.(dat).pCSI = NaN;
                MUdata.(mus).pCSI.(dat).fit = NaN;
                MUdata.(mus).pCSI.(dat).gof = NaN;
                MUdata.(mus).pCSI.(dat).coeffs = NaN;
                MUdata.(mus).pCSI.(dat).xcoh1 = NaN;
                else
                [MUdata.(mus).pCSI.(dat).fit,MUdata.(mus).pCSI.(dat).gof,MUdata.(mus).pCSI.(dat).coeffs, MUdata.(mus).pCSI.(dat).xcoh1] = expoFit(MUdata.(mus).pCSI.(dat).pCSI);
                end
            end
        end
    end
        clear('fn','dat');
    % PCA  
    if ~isfield(MUdata.(mus),'PCA')
    else
        fn = fieldnames(MUdata.(mus).PCA);
        for d = 1:length(fn)
            dat = fn{d};
            if contains(dat,'iter')
                if ~isfield(MUdata.(mus).PCA.(dat),'w1')
                   % MUdata.(mus).PCA.(dat).w1 = NaN;
                   % MUdata.(mus).PCA.(dat).raw = NaN;
                else
                    [MUdata.(mus).PCA.(dat).w1.fit,MUdata.(mus).PCA.(dat).w1.gof,MUdata.(mus).PCA.(dat).w1.coeffs, MUdata.(mus).PCA.(dat).w1.pseudoA] = expodecayFit(MUdata.(mus).PCA.(dat).w1.explained_mean);
                    if isfield(MUdata.(mus).PCA.(dat).w1,'raw')
                    [MUdata.(mus).PCA.(dat).raw.w1.fit,MUdata.(mus).PCA.(dat).raw.w1.gof,MUdata.(mus).PCA.(dat).raw.w1.coeffs, MUdata.(mus).PCA.(dat).raw.w1.pseudoA] = expodecayFit(MUdata.(mus).PCA.(dat).raw.w1.explained_mean);
                    end
                end
                if ~isfield(MUdata.(mus).PCA.(dat),'w5')
                   % MUdata.(mus).PCA.(dat).w5 = NaN;
                   % MUdata.(mus).PCA.(dat).raw.w5 = NaN;
                else
                    [MUdata.(mus).PCA.(dat).w5.fit,MUdata.(mus).PCA.(dat).w5.gof,MUdata.(mus).PCA.(dat).w5.coeffs, MUdata.(mus).PCA.(dat).w5.pseudoA] = expodecayFit(MUdata.(mus).PCA.(dat).w5.explained_mean);
                    if isfield(MUdata.(mus).PCA.(dat).w5,'raw')
                    [MUdata.(mus).PCA.(dat).raw.w5.fit,MUdata.(mus).PCA.(dat).raw.w5.gof,MUdata.(mus).PCA.(dat).raw.w5.coeffs, MUdata.(mus).PCA.(dat).raw.w5.pseudoA] = expodecayFit(MUdata.(mus).PCA.(dat).raw.w5.explained_mean);
                    end
                end
                elseif contains(dat,'raw')
                [MUdata.(mus).PCA.(dat).w1.fit,MUdata.(mus).PCA.(dat).w1.gof,MUdata.(mus).PCA.(dat).w1.coeffs, MUdata.(mus).PCA.(dat).w1.pseudoA] = expodecayFit(MUdata.(mus).PCA.(dat).w1.explained_means);
                [MUdata.(mus).PCA.(dat).w5.fit,MUdata.(mus).PCA.(dat).w5.gof,MUdata.(mus).PCA.(dat).w5.coeffs, MUdata.(mus).PCA.(dat).w5.pseudoA] = expodecayFit(MUdata.(mus).PCA.(dat).w5.explained_means);
            else
            end
        end
     end
   clear('fn','dat');
end

% --------- All PFs -----------------------------------------
% pCSI
if ~isfield(MUdata,'pCSI')
else
    fn = fieldnames(MUdata.pCSI);
    for d = 1:length(fn)
        dat = fn{d};
        if length(dat) > 3
        [MUdata.pCSI.(dat).w1.fit,MUdata.pCSI.(dat).w1.gof,MUdata.pCSI.(dat).w1.coeffs, MUdata.pCSI.(dat).w1.xcoh1] = expoFit(MUdata.pCSI.(dat).w1.pCSI);
        [MUdata.pCSI.(dat).w5.fit,MUdata.pCSI.(dat).w5.gof,MUdata.pCSI.(dat).w5.coeffs, MUdata.pCSI.(dat).w5.xcoh1] = expoFit(MUdata.pCSI.(dat).w5.pCSI);
        elseif isnan(MUdata.pCSI.(dat).pCSI)
            % do nothing
        else
        [MUdata.pCSI.(dat).fit,MUdata.pCSI.(dat).gof,MUdata.pCSI.(dat).coeffs, MUdata.pCSI.(dat).xcoh1] = expoFit(MUdata.pCSI.(dat).pCSI);
        end
    end
end
% PCA 
if ~isfield(MUdata,'pCSI')
else
    fn = fieldnames(MUdata.PCA);
    for d = 1:length(fn)
        dat = fn{d};
        if contains(dat,'iter')
            if ~isfield(MUdata.PCA.(dat),'w1')
                %MUdata.PCA.(dat).w1 = NaN;
                %MUdata.PCA.(dat).raw = NaN;
            else
                [MUdata.PCA.(dat).w1.fit,MUdata.PCA.(dat).w1.gof,MUdata.PCA.(dat).w1.coeffs, MUdata.PCA.(dat).w1.pseudoA] = expodecayFit(MUdata.PCA.(dat).w1.explained_mean);
                if isfield(MUdata.PCA.(dat).w1,'raw')
                [MUdata.PCA.(dat).raw.w1.fit,MUdata.PCA.(dat).raw.w1.gof,MUdata.PCA.(dat).raw.w1.coeffs, MUdata.PCA.(dat).raw.w1.pseudoA] = expodecayFit(MUdata.PCA.(dat).raw.w1.explained_mean);
                end
            end
            if ~isfield(MUdata.PCA.(dat),'w5')
                %MUdata.PCA.(dat).w5 = NaN;
                %MUdata.PCA.(dat).raw.w5 = NaN;
            else
                [MUdata.PCA.(dat).w5.fit,MUdata.PCA.(dat).w5.gof,MUdata.PCA.(dat).w5.coeffs, MUdata.PCA.(dat).w5.pseudoA] = expodecayFit(MUdata.PCA.(dat).w5.explained_mean);
                if isfield(MUdata.PCA.(dat).w5,'raw')
                [MUdata.PCA.(dat).raw.w5.fit,MUdata.PCA.(dat).raw.w5.gof,MUdata.PCA.(dat).raw.w5.coeffs, MUdata.PCA.(dat).raw.w5.pseudoA] = expodecayFit(MUdata.PCA.(dat).raw.w5.explained_mean);
                end
            end
            elseif contains(dat,'raw')
            [MUdata.PCA.(dat).w1.fit,MUdata.PCA.(dat).w1.gof,MUdata.PCA.(dat).w1.coeffs, MUdata.PCA.(dat).w1.pseudoA] = expodecayFit(MUdata.PCA.(dat).w1.explained_means);
            [MUdata.PCA.(dat).w5.fit,MUdata.PCA.(dat).w5.gof,MUdata.PCA.(dat).w5.coeffs, MUdata.PCA.(dat).w5.pseudoA] = expodecayFit(MUdata.PCA.(dat).w5.explained_means);
        else
        end
    end
end

end