function [out] = PCAiterfunc30_allPFs(MUdata)
% PCA Function to use for individual muscles & composite PFs
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
        else
            temp = temp(start:endd);
            temp = conv(temp,hann(800),'same');
            nans1 = repelem(NaN,start-1);
            nans2 = repelem(NaN,(len-endd));
            temp2 = highpass(temp, 0.75, fs);
            idrs(mu,:) = horzcat(nans1,temp2,nans2);
        end
    end
    
if exist('idrs','var') == 1
    if isempty(idrs)
    out = [];
    else
    PFidrs = vertcat(PFidrs,idrs);
    end
    
end
end

% ------------- For all PFs combined ---------------------------------
    out = [];
    rem = []; idrdat = [];
    ws = MUdata.start;
    we = MUdata.start + (30*2000);
        % skip to next window if any flags in this one = 1
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
                out.coeffs = NaN;
                out.explained = NaN;
                %out.latentvar = NaN;
                %out.mu = NaN;
            else
            % Run PCA for that window
            pcadat = PCAiter(idrdat,100);
                out.coeffs = pcadat.coeff_all;
                out.explained = pcadat.expl_all;
                %out.latentvar = pcadat.latentvar_all;
                out.coeffs_mean = pcadat.coeff_mean;
                out.explained_means = pcadat.expl_mean;
                %out.latentvar_means = pcadat.latentvar_mean;
            end

% ----------------------------------------------------------------
end
