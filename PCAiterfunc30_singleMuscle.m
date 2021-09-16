function [out] = PCAiterfunc30_singleMuscle(MUdata)
% PCA Function to use for individual muscles & composite PFs
warning('off','all')
% --------- Individual Muscle -----------------------------------------
    % Smooth and detrend signals
    %   - 400ms hanning window and High pass filter all IDRs
    %   - 0.75 hz high pass filter "to remove offsets and trends" (Negro 2009)
    fs = 2000;
    len = length(MUdata.binary);
    idrs = [];
    for mu = 1:length(MUdata.rawlines)
        temp = MUdata.rawlines{mu};
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
    
    
% --------- PCA of smoothed, detrended IDR lines - Whole 30s --------- 
        rem = [];
        ws = MUdata.steady30.start;
        we = MUdata.steady30.start + (30*2000);
        % skip to next window if any flags in this one = 1
        % if sum(MUdata.flags(ws:we)) == 0
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
                out.coeffs = {};
                out.explained = {};
            else
            % Run PCA for that window
            [pcadat] = PCAiter(idrdat,100);
                out.coeffs = pcadat.coeff_all;
                out.explained = pcadat.expl_all;
                out.coeffs_mean = pcadat.coeff_mean;
                out.explained_means = pcadat.expl_mean;
            end
        %else
            out.explained = {};
            out.latentvar = {};
        %end

% ----------------------------------------------------------------
end
