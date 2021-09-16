function [fdat] = forcefunc(MUdata,fdat,level)
% Calculate SD and CV for force across same windows as PCA script
% Detrend force section first
% Only the section where that muscle's motor units are active
% Removes flagged sections first!
warning('off','all')

if contains(level,'submax10')
    c = 1;
else
    c = 2;
end

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
    % Steady portion of force only
    force = fdat.filt{1,c}';
    % Convert to N
    force = force*618.987*0.23;
    if length(MUdata.(mus).flags) > length(force)
        flags = MUdata.(mus).flags(1:length(force));
    else
        flags = MUdata.(mus).flags;
        force = force(1:length(flags));
    end
    % Remove flagged sections
    force = force(flags == 0);
% --------- 1-s windows ---------------------------
    win = 2000;
    num = 30;
    for w = 1:num
        ws = MUdata.start + (w*win) - win;
            fdat.(mus).w1.starts(w) = ws;
        we = ws + win;
            fdat.(mus).w1.endds(w) = we;
        % skip to next window if any flags in this one = 1
        if sum(MUdata.(mus).flags(ws:we)) == 0
            % Subset force
            fsec = force(ws:we);
            fmean = mean(fsec);
            fsd = std(fsec);
            fcv = (fsd/fmean)*100;
            fvar = fsd^2;
            % If < 3 MUs are active
            if isempty(MUdata.(mus).PCA.w1.coeffs{w})
                fdat.(mus).w1.forces{w} = NaN;
                fdat.(mus).w1.means(w) = NaN;
                fdat.(mus).w1.sds(w) = NaN;
                fdat.(mus).w1.cvs(w) = NaN;
                fdat.(mus).w1.vars(w) = NaN;
            else
            % Run keep clacs for that window
                fdat.(mus).w1.forces{w} = fsec;
                fdat.(mus).w1.means(w) = fmean;
                fdat.(mus).w1.sds(w) = fsd;
                fdat.(mus).w1.cvs(w) = fcv;
                fdat.(mus).w1.vars(w) = fvar;
            end
        else
            fdat.(mus).w1.forces{w} = NaN;
            fdat.(mus).w1.means(w) = NaN;
            fdat.(mus).w1.sds(w) = NaN;
            fdat.(mus).w1.cvs(w) = NaN;
            fdat.(mus).w1.vars(w) = NaN;
        end
    end

% --------- 5-s windows ---------------------------
    win = 10000;
    num = 6;
    for w = 1:num
        ws = MUdata.start + (w*win) - win;
            fdat.(mus).w5.starts(w) = ws;
        we = ws + win;
            fdat.(mus).w5.endds(w) = we;
        % skip to next window if any flags in this one = 1
        if sum(MUdata.(mus).flags(ws:we)) == 0
            % Subset force
            fsec = force(ws:we);
            fmean = mean(fsec);
            fsd = std(fsec);
            fcv = (fsd/fmean)*100;
            fvar = fsd^2;
            % If < 3 MUs are active
            if isempty(MUdata.(mus).PCA.w5.coeffs{w})
                fdat.(mus).w5.forces{w} = NaN;
                fdat.(mus).w5.means(w) = NaN;
                fdat.(mus).w5.sds(w) = NaN;
                fdat.(mus).w5.cvs(w) = NaN;
                fdat.(mus).w5.vars(w) = NaN;
            else
            % Run keep clacs for that window
                fdat.(mus).w5.forces{w} = fsec;
                fdat.(mus).w5.means(w) = fmean;
                fdat.(mus).w5.sds(w) = fsd;
                fdat.(mus).w5.cvs(w) = fcv;
                fdat.(mus).w5.vars(w) = fvar;
            end
        else
            fdat.(mus).w5.forces{w} = NaN;
            fdat.(mus).w5.means(w) = NaN;
            fdat.(mus).w5.sds(w) = NaN;
            fdat.(mus).w5.cvs(w) = NaN;
            fdat.(mus).w5.vars(w) = NaN;
        end
    end
end 

% ------------- For all PFs combined ---------------------------------
  % Steady portion of force only
    force = fdat.filt{1,c}';
    % Convert to N
    force = force*618.987*0.23;
    if length(MUdata.(mus).flags) > length(force)
        flags = fdat.allflags(1:length(force));
    else
        flags = fdat.allflags;
        force = force(1:length(flags));
    end
    % Remove flagged sections
    force = force(flags == 0);
% --------- 1-s windows ---------------------------
    win = 2000;
    num = 30;
    for w = 1:num
        ws = MUdata.start + (w*win) - win;
            fdat.w1.starts(w) = ws;
        we = ws + win;
            fdat.w1.endds(w) = we;
        % skip to next window if any flags in this one = 1
        if sum(MUdata.(mus).flags(ws:we)) == 0
            % Subset force
            fsec = force(ws:we);
            fmean = mean(fsec);
            fsd = std(fsec);
            fcv = (fsd/fmean)*100;
            fvar = fsd^2;
            % If < 3 MUs are active
            if isempty(MUdata.(mus).PCA.w1.coeffs{w})
                fdat.w1.forces{w} = NaN;
                fdat.w1.means(w) = NaN;
                fdat.w1.sds(w) = NaN;
                fdat.w1.cvs(w) = NaN;
                fdat.w1.vars(w) = NaN;
            else
            % Run keep clacs for that window
                fdat.w1.forces{w} = fsec;
                fdat.w1.means(w) = fmean;
                fdat.w1.sds(w) = fsd;
                fdat.w1.cvs(w) = fcv;
                fdat.w1.vars(w) = fvar;
            end
        else
            fdat.w1.forces{w} = NaN;
            fdat.w1.means(w) = NaN;
            fdat.w1.sds(w) = NaN;
            fdat.w1.cvs(w) = NaN;
            fdat.w1.vars(w) = NaN;
        end
    end

% --------- 5-s windows ---------------------------
    win = 10000;
    num = 6;
    for w = 1:num
        ws = MUdata.start + (w*win) - win;
            fdat.w5.starts(w) = ws;
        we = ws + win;
            fdat.w5.endds(w) = we;
        % skip to next window if any flags in this one = 1
        if sum(flags(ws:we)) == 0
            % Subset force
            fsec = force(ws:we);
            fmean = mean(fsec);
            fsd = std(fsec);
            fcv = (fsd/fmean)*100;
            fvar = fsd^2;
            % If < 3 MUs are active
            if isempty(MUdata.PCA.w5.coeffs{w})
                fdat.w5.forces{w} = NaN;
                fdat.w5.means(w) = NaN;
                fdat.w5.sds(w) = NaN;
                fdat.w5.cvs(w) = NaN;
                fdat.w5.vars(w) = NaN;
            else
            % Run keep clacs for that window
                fdat.w5.forces{w} = fsec;
                fdat.w5.means(w) = fmean;
                fdat.w5.sds(w) = fsd;
                fdat.w5.cvs(w) = fcv;
                fdat.w5.vars(w) = fvar;
            end
        else
            fdat.w5.forces{w} = NaN;
            fdat.w5.means(w) = NaN;
            fdat.w5.sds(w) = NaN;
            fdat.w5.cvs(w) = NaN;
            fdat.w5.vars(w) = NaN;
        end
    end

end