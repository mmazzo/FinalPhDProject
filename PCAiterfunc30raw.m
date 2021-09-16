function [MUdata] = PCAiterfunc30raw(MUdata)
% PCA Function to use for individual muscles & composite PFs
% Uses ALL available MUs with more than 30 discharges to do PCA
warning('off','all')
PFidrs = [];
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
    % Smooth and detrend signals
    %   - 400ms hanning window and High pass filter all IDRs
    %   - 0.75 hz high pass filter "to remove offsets and trends" (Negro 2009)
    fs = 2000;
    len = length(MUdata.(mus).binary);
    idrs = [];
    for mu = 1:length(MUdata.(mus).rawlines)
        temp = MUdata.(mus).rawlines{mu};
        start = find(~isnan(temp),1,'first');
        endd = find(~isnan(temp),1,'last');
        if isempty(temp)
        elseif length(MUdata.(mus).MUPulses{mu}) < 30 % at least 30 APs
        else
            temp = temp(start:endd);
            %temp = conv(temp,hann(800),'same');    raw
            nans1 = repelem(NaN,start-1);
            nans2 = repelem(NaN,(len-endd));
            temp2 = highpass(temp, 0.75, fs);
            idrs(mu,:) = horzcat(nans1,temp2,nans2);
        end
    end
    
    if exist('idrs','var') == 1
        if isempty(idrs)
        else
        PFidrs = vertcat(PFidrs,idrs);
% --------- PCA of smoothed, detrended IDR lines - Whole 30s --------- 
        rem = [];
        ws = MUdata.start;
        we = MUdata.start + (30*2000);
            % Subset idrs
            idrsec = idrs(:,ws:we);
            for mu = 1:size(idrsec,1)
                if sum((idrsec(mu,:))) == 0
                    rem = horzcat(rem,mu);
                end
            end
            % Remove empty IDRs
            idrdat = idrsec;
            idrdat(rem,:) = [];
            % If < 3 MUs are active
            if size(idrdat,1) < 3
                MUdata.(mus).PCA.iter.raw.w30.coeffs = {};
                MUdata.(mus).PCA.iter.raw.w30.explained = {};
            else
            % Run PCA for that window
            [pcadat] = PCAiter(idrdat,100);
                if isstruct('pcadat')
                    MUdata.(mus).PCA.iter.raw.w30.coeffs = pcadat.coeff_all;
                    MUdata.(mus).PCA.iter.raw.w30.explained = pcadat.expl_all;
                    MUdata.(mus).PCA.iter.raw.w30.coeffs_mean = pcadat.coeff_mean;
                    MUdata.(mus).PCA.iter.raw.w30.explained_means = pcadat.expl_mean;
                else
                end
            end
        rem = [];
        idrdat = [];
        end
    end
end

% ------------- For all PFs combined ---------------------------------
    rem = [];
    ws = MUdata.start;
    we = MUdata.start + (30*2000);
            % Subset PFidrs
            idrsec = PFidrs(:,ws:we);
            for mu = 1:size(idrsec,1)
                if sum(isnan(idrsec(mu,:))) > 0
                    rem = horzcat(rem,mu);
                elseif sum((idrsec(mu,:))) == 0
                    rem = horzcat(rem,mu);
                end
            end
            % Remove empty IDRs
            idrdat = idrsec;
            idrdat(rem,:) = [];
            % If < 3 MUs are active
            if size(idrdat,1) < 3
                MUdata.PCA.iter.raw.w30.coeffs = {};
                MUdata.PCA.iter.raw.w30.explained = {};
            else
            % Run PCA for that window
            pcadat = PCAiter(idrdat,100);
                if isstruct('pcadat')
                    MUdata.PCA.iter.raw.w30.coeffs = pcadat.coeff_all;
                    MUdata.PCA.iter.raw.w30.explained = pcadat.expl_all;
                    MUdata.PCA.iter.raw.w30.coeffs_mean = pcadat.coeff_mean;
                    MUdata.PCA.iter.raw.w30.explained_means = pcadat.expl_mean;
                else
                end
            end
    
% ----------------------------------------------------------------
end

