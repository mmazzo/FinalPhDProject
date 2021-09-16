function [MUdata] = pcafuncRaw(MUdata,fdat)
% PCA Function to use for individual muscles & composite PFs
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
% NO SMOOTHING OF IDR LINES, only detrending
warning('off','all')
PFidrs = [];
% --------- Individual Muscles -----------------------------------------
for m = 1:length(muscles)
    mus = muscles{m};
    % Smooth and detrend signals
    %   - 400ms hanning window and High pass filter all IDRs
    %   - 0.75 hz high pass filter "to remove offsets and trends" (Negro 2009)
    fs = 2000;
    len = length(MUdata.(mus).binary);
    for mu = 1:length(MUdata.(mus).rawlines)
        temp = MUdata.(mus).rawlines{mu};
        start = find(~isnan(temp),1,'first');
        endd = find(~isnan(temp),1,'last');
        if isempty(temp)
        else
            temp = temp(start:endd);
            %temp = conv(temp,hann(800),'same');
            nans1 = repelem(NaN,start-1);
            nans2 = repelem(NaN,(len-endd));
            temp2 = highpass(temp, 0.75, fs);
            idrs(mu,:) = horzcat(nans1,temp2,nans2);
        end
    end
    
if exist('idrs','var') == 1    
    PFidrs = vertcat(PFidrs,idrs);

% --------- PCA of smoothed, detrended IDR lines - 1s windows --------- 
    win = 2000;
    num = 30;
    rem = [];
    % Preallocate
    MUdata.(mus).PCA.raw.w1.coeffs = {};
    MUdata.(mus).PCA.raw.w1.explained = {};
    MUdata.(mus).PCA.raw.w1.score = {};
    MUdata.(mus).PCA.raw.w1.latentvar = {};
    MUdata.(mus).PCA.raw.w1.tsq = {};
    MUdata.(mus).PCA.raw.w1.mu = {};
    for w = 1:num
        ws = MUdata.start + (w*win) - win;
            MUdata.w1.raw.starts(w) = ws;
        we = ws + win;
            MUdata.w1.raw.endds(w) = we;
        % skip to next window if any flags in this one = 1
        if sum(MUdata.(mus).flags(ws:we)) == 0
            % Subset idrs
            idrsec = idrs(:,ws:we);
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
                MUdata.(mus).PCA.raw.w1.coeffs{w} = {};
                MUdata.(mus).PCA.raw.w1.explained{w} = {};
                MUdata.(mus).PCA.raw.w1.score{w} = {};
                MUdata.(mus).PCA.raw.w1.latentvar{w} = {};
                MUdata.(mus).PCA.raw.w1.tsq{w} = {};
                MUdata.(mus).PCA.raw.w1.mu{w} = {};
            else
            % Run PCA for that window
            [coeff,score,lat,tsq,expl,muu] = pca(idrdat,'centered',false);
            MUdata.(mus).PCA.raw.w1.coeffs{w} = coeff;
            MUdata.(mus).PCA.raw.w1.explained{w} = expl;
            MUdata.(mus).PCA.raw.w1.score{w} = score;
            MUdata.(mus).PCA.raw.w1.latentvar{w} = lat;
            MUdata.(mus).PCA.raw.w1.tsq{w} = tsq;
            MUdata.(mus).PCA.raw.w1.mu{w} = muu;
            end
        else
            MUdata.(mus).PCA.raw.w1.coeffs{w} = {};
            MUdata.(mus).PCA.raw.w1.explained{w} = {};
            MUdata.(mus).PCA.raw.w1.score{w} = {};
            MUdata.(mus).PCA.raw.w1.latentvar{w} = {};
            MUdata.(mus).PCA.raw.w1.tsq{w} = {};
            MUdata.(mus).PCA.raw.w1.mu{w} = {};
        end
        rem = [];
        idrdat = [];
    end

% --------- PCA of smoothed, detrended IDR lines - 5s windows ---------
    win = 10000;
    num = 6;
    rem = [];
    % Preallocate
    MUdata.(mus).PCA.raw.w5.coeffs = {};
    MUdata.(mus).PCA.raw.w5.explained = {};
    MUdata.(mus).PCA.raw.w5.score = {};
    MUdata.(mus).PCA.raw.w5.latentvar = {};
    MUdata.(mus).PCA.raw.w5.tsq = {};
    MUdata.(mus).PCA.raw.w5.mu = {};
    for w = 1:num
        ws = MUdata.start + (w*win) - win;
            MUdata.w5.raw.starts(w) = ws;
        we = ws + win;
            MUdata.w5.raw.endds(w) = we;
        % skip to next window if any flags in this one = 1
        if sum(MUdata.(mus).flags(ws:we)) == 0
            % Subset idrs
            idrsec = idrs(:,ws:we);
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
                MUdata.(mus).PCA.raw.w5.coeffs{w} = {};
                MUdata.(mus).PCA.raw.w5.explained{w} = {};
                MUdata.(mus).PCA.raw.w5.score{w} = {};
                MUdata.(mus).PCA.raw.w5.latentvar{w} = {};
                MUdata.(mus).PCA.raw.w5.tsq{w} = {};
                MUdata.(mus).PCA.raw.w5.mu{w} = {};
            else
            % Run PCA for that window
            [coeff,score,lat,tsq,expl,muu] = pca(idrdat,'centered',false);
            MUdata.(mus).PCA.raw.w5.coeffs{w} = coeff;
            MUdata.(mus).PCA.raw.w5.explained{w} = expl;
            MUdata.(mus).PCA.raw.w5.score{w} = score;
            MUdata.(mus).PCA.raw.w5.latentvar{w} = lat;
            MUdata.(mus).PCA.raw.w5.tsq{w} = tsq;
            MUdata.(mus).PCA.raw.w5.mu{w} = muu;
            end
        else
            MUdata.(mus).PCA.raw.w5.coeffs{w} = {};
            MUdata.(mus).PCA.raw.w5.explained{w} = {};
            MUdata.(mus).PCA.raw.w5.score{w} = {};
            MUdata.(mus).PCA.raw.w5.latentvar{w} = {};
            MUdata.(mus).PCA.raw.w5.tsq{w} = {};
            MUdata.(mus).PCA.raw.w5.mu{w} = {};
        end
        rem = [];
    end
    
% ------------- Averages for muscle per window length ------------------    
    % 1-s window length
    for w = 1:30
        if isempty(MUdata.(mus).PCA.raw.w1.explained{w})
            emptyind(w) = 1;
        else
            emptyind(w) = 0;
            if length(MUdata.(mus).PCA.raw.w1.explained{w}) < 5
                zz = repelem(0,5-length(MUdata.(mus).PCA.raw.w1.explained{w}))';
                exp1(w,1:5) = vertcat(MUdata.(mus).PCA.raw.w1.explained{w}(1:end),zz);
                lat1(w,1:5) = vertcat(MUdata.(mus).PCA.raw.w1.latentvar{w}(1:end),zz);
            else
            exp1(w,1:5) = MUdata.(mus).PCA.raw.w1.explained{w}(1:5);
            lat1(w,1:5) = MUdata.(mus).PCA.raw.w1.latentvar{w}(1:5);   
            end
        end
    end
    if exist('exp1','var') == 0
        MUdata.(mus).PCA.raw.w1.explained_means = NaN;
        MUdata.(mus).PCA.raw.w1.latentvar_means = NaN;
    else
        exp1(exp1==0) = NaN;
        lat1(lat1==0) = NaN;
        MUdata.(mus).PCA.raw.w1.explained_means = nanmean(exp1);
        MUdata.(mus).PCA.raw.w1.latentvar_means = nanmean(lat1);
    end
    % 5-s window length
    for w = 1:6
        if isempty(MUdata.(mus).PCA.raw.w5.explained{w})
            emptyind(w) = 1;
        else
            emptyind(w) = 0;
            if length(MUdata.(mus).PCA.raw.w5.explained{w}) < 5
                zz = repelem(0,5-length(MUdata.(mus).PCA.raw.w5.explained{w}))';
                exp2(w,1:5) = vertcat(MUdata.(mus).PCA.raw.w5.explained{w}(1:end),zz);
                lat2(w,1:5) = vertcat(MUdata.(mus).PCA.raw.w5.latentvar{w}(1:end),zz);
            else
            exp2(w,1:5) = MUdata.(mus).PCA.raw.w5.explained{w}(1:5);
            lat2(w,1:5) = MUdata.(mus).PCA.raw.w5.latentvar{w}(1:5);
            end
        end
    end
    if exist('exp2','var') == 0
        MUdata.(mus).PCA.raw.w5.explained_means = NaN;
        MUdata.(mus).PCA.raw.w5.latentvar_means = NaN;
    else
        exp2(exp2==0) = NaN;
        lat2(lat2==0) = NaN;
        MUdata.(mus).PCA.raw.w5.explained_means = nanmean(exp2);
        MUdata.(mus).PCA.raw.w5.latentvar_means = nanmean(lat2);
    end
    clear('exp1','exp2');
else
MUdata.(mus).PCA = [];
end
end
    
% ------------- For all PFs combined ---------------------------------
if exist('PFidrs','var') == 1 
% --------- PCA of smoothed, detrended IDR lines - 1s windows --------
    win = 2000;
    num = 30;
    rem = [];
    % Preallocate
    MUdata.PCA.raw.w1.coeffs = {};
    MUdata.PCA.raw.w1.explained = {};
    MUdata.PCA.raw.w1.score = {};
    MUdata.PCA.raw.w1.latentvar = {};
    MUdata.PCA.raw.w1.tsq = {};
    MUdata.PCA.raw.w1.mu = {};
    for w = 1:num
        ws = MUdata.start + (w*win) - win;
        we = ws + win;
        % skip to next window if any flags in this one = 1
        if sum(fdat.allflags(ws:we)) == 0
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
                MUdata.PCA.raw.w1.coeffs{w} = {};
                MUdata.PCA.raw.w1.explained{w} = {};
                MUdata.PCA.raw.w1.score{w} = {};
                MUdata.PCA.raw.w1.latentvar{w} = {};
                MUdata.PCA.raw.w1.tsq{w} = {};
                MUdata.PCA.raw.w1.mu{w} = {};
            else
            % Run PCA for that window
            [coeff,score,lat,tsq,expl,muu] = pca(idrdat,'centered',false);
            MUdata.PCA.raw.w1.coeffs{w} = coeff;
            MUdata.PCA.raw.w1.explained{w} = expl;
            MUdata.PCA.raw.w1.score{w} = score;
            MUdata.PCA.raw.w1.latentvar{w} = lat;
            MUdata.PCA.raw.w1.tsq{w} = tsq;
            MUdata.PCA.raw.w1.mu{w} = muu;
            end
        else
            MUdata.PCA.raw.w1.coeffs{w} = {};
            MUdata.PCA.raw.w1.explained{w} = {};
            MUdata.PCA.raw.w1.score{w} = {};
            MUdata.PCA.raw.w1.latentvar{w} = {};
            MUdata.PCA.raw.w1.tsq{w} = {};
            MUdata.PCA.raw.w1.mu{w} = {};
        end
        rem = [];
        idrdat = [];
    end

% --------- PCA of smoothed, detrended IDR lines - 5s windows ---------
    win = 10000;
    num = 6;
    rem = [];
    % Preallocate
    MUdata.PCA.raw.w5.coeffs = {};
    MUdata.PCA.raw.w5.explained = {};
    MUdata.PCA.raw.w5.score = {};
    MUdata.PCA.raw.w5.latentvar = {};
    MUdata.PCA.raw.w5.tsq = {};
    MUdata.PCA.raw.w5.mu = {};
    for w = 1:num
        ws = MUdata.start + (w*win) - win;
            MUdata.w5.raw.starts(w) = ws;
        we = ws + win;
            MUdata.w5.raw.endds(w) = we;
        % skip to next window if any flags in this one = 1
        if sum(fdat.allflags(ws:we)) == 0
            % Subset idrs
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
                MUdata.PCA.raw.w5.coeffs{w} = {};
                MUdata.PCA.raw.w5.explained{w} = {};
                MUdata.PCA.raw.w5.score{w} = {};
                MUdata.PCA.raw.w5.latentvar{w} = {};
                MUdata.PCA.raw.w5.tsq{w} = {};
                MUdata.PCA.raw.w5.mu{w} = {};
            else
            % Run PCA for that window
            [coeff,score,lat,tsq,expl,muu] = pca(idrdat,'centered',false);
            MUdata.PCA.raw.w5.coeffs{w} = coeff;
            MUdata.PCA.raw.w5.explained{w} = expl;
            MUdata.PCA.raw.w5.score{w} = score;
            MUdata.PCA.raw.w5.latentvar{w} = lat;
            MUdata.PCA.raw.w5.tsq{w} = tsq;
            MUdata.PCA.raw.w5.mu{w} = muu;
            end
        else
            MUdata.PCA.raw.w5.coeffs{w} = {};
            MUdata.PCA.raw.w5.explained{w} = {};
            MUdata.PCA.raw.w5.score{w} = {};
            MUdata.PCA.raw.w5.latentvar{w} = {};
            MUdata.PCA.raw.w5.tsq{w} = {};
            MUdata.PCA.raw.w5.mu{w} = {};
        end
        rem = [];
    end
    
% ------------- Averages for muscle per window length ------------------    
    % 1-s window length
    for w = 1:30
        if isempty(MUdata.PCA.raw.w1.explained{w})
            emptyind(w) = 1;
        else
            emptyind(w) = 0;
            if length(MUdata.PCA.raw.w1.explained{w}) < 5
                zz = repelem(0,5-length(MUdata.PCA.raw.w1.explained{w}))';
                exp1(w,1:5) = vertcat(MUdata.PCA.raw.w1.explained{w}(1:end),zz);
                lat1(w,1:5) = vertcat(MUdata.PCA.raw.w1.latentvar{w}(1:end),zz);
            else
            exp1(w,1:5) = MUdata.PCA.raw.w1.explained{w}(1:5);
            lat1(w,1:5) = MUdata.PCA.raw.w1.latentvar{w}(1:5);   
            end
        end
    end
    if exist('exp1','var') == 0
        MUdata.PCA.raw.w1.explained_means = NaN;
        MUdata.PCA.raw.w1.latentvar_means = NaN;
    else
        exp1(exp1==0) = NaN;
        lat1(lat1==0) = NaN;
        MUdata.PCA.raw.w1.explained_means = nanmean(exp1);
        MUdata.PCA.raw.w1.latentvar_means = nanmean(lat1);
    end
    % 5-s window length
    for w = 1:6
        if isempty(MUdata.PCA.raw.w5.explained{w})
            emptyind(w) = 1;
        else
            emptyind(w) = 0;
            if length(MUdata.PCA.raw.w5.explained{w}) < 5
                zz = repelem(0,5-length(MUdata.PCA.raw.w5.explained{w}))';
                exp2(w,1:5) = vertcat(MUdata.PCA.raw.w5.explained{w}(1:end),zz);
                lat2(w,1:5) = vertcat(MUdata.PCA.raw.w5.latentvar{w}(1:end),zz);
            else
            exp2(w,1:5) = MUdata.PCA.raw.w5.explained{w}(1:5);
            lat2(w,1:5) = MUdata.PCA.raw.w5.latentvar{w}(1:5);
            end
        end
    end
    if exist('exp2','var') == 0
        MUdata.PCA.raw.w5.explained_means = NaN;
        MUdata.PCA.raw.w5.latentvar_means = NaN;
    else
        exp2(exp2==0) = NaN;
        lat2(lat2==0) = NaN;
        MUdata.PCA.raw.w5.explained_means = nanmean(exp2);
        MUdata.PCA.raw.w5.latentvar_means = nanmean(lat2);
    end
    clear('exp1','exp2');
% ----------------------------------------------------------------
else
MUdata.PCA = [];
end
end