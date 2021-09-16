function [MUdata,fdat] = PFxcor1(MUdata,fdat,muscles,l)
% Calculate cross correlation coefficients between force, PCA FCC and CST
% Uses newly adjusted force based on first XC between force and CST for windowed cross-correlations!

% First check marks:
if MUdata.start == fdat.steady30.start
else
   fdat.steady30.start = MUdata.start;
   disp('MUdata.start & fdat.start are DIFFERENT')
end

if MUdata.endd == fdat.steady30.endd
else
   fdat.steady30.endd = MUdata.endd;
end

% Manually select appropriate sections first & trim sections out of both that are flagged
    fl = [];
    for m = 1:length(muscles)
        mus = muscles{m};
        fl = vertcat(fl,MUdata.(mus).flags);
    end
    % Flags for all PFs
    if size(fl,1) == 1
        allflags = fl;
    else
    allflags = sum(fl);
    end
    allflags(allflags>1) = 1;
    
% Only use steady 30s portion
allflags = allflags(MUdata.start:MUdata.endd);

% Manually select continuous subset to use
num =[];
if sum(allflags) > 0
   fig = figure(1);
   fig.Position = [100 100 1000 400];
         yyaxis left
         area(allflags)
         yyaxis right
         plot(MUdata.cst(MUdata.start:MUdata.endd),'k-'); hold on;
         num = inputdlg('How many sections to keep?');
         num = str2num(cell2mat(num));
         if num == 0
         else
         [x,~] = ginput(num*2);
         end
    waitfor(fig)

    if num == 0 % aka no usable portions of contraction
    MUdata.sectioned = NaN;
    else % usable portions = 1
        keep = zeros(1,length(allflags));
        for i = 1:num
            keep(x(1):x(2)) = 1;
            if length(x) > 1
            x = x(3:end);
            end
        end
        MUdata.sectioned = 1;
    end
else
    keep = zeros(1,length(allflags));
    keep(1:end) = 1; % whole contraction = 1
    MUdata.sectioned = 0;
end

if num == 0
    % Skip this contraction
    MUdata.xcorrs = [];
    fdat.hp_filt{1,l} = highpass(fdat.filt{1,l},0.72,2000);
    fdat.steady30.hp_filt{1,l} = fdat.hp_filt{1,l}(fdat.steady30.start:fdat.steady30.endd);
    MUdata.w30.cst_sd = [];
    MUdata.PCA.iter.w30.w1.fpc_sd = [];
    MUdata.PCA.iter.w30.w5.fpc_sd = [];    
else
    % ALL PFs COMBINED
    % --------- Whole signal --------------------------------
    cst = highpass(MUdata.cst(MUdata.start:MUdata.endd),0.75,2000);
    cst = cst(keep ==1);
            % save var
            MUdata.xcorrs.w30.cst_used = cst;
    fwhole = highpass(fdat.filt{1,l},0.72,2000);
    f = fwhole(fdat.steady30.start:fdat.steady30.endd);
    f = f(keep ==1);
        % CST vs Force
        [sigcor,siglag] = xcorr(cst,f,2000,'coeff');
        [maxcor,ind] = max(sigcor);
        lag1 = siglag(ind);
            MUdata.xcorrs.w30.f_cst_r = maxcor;
            MUdata.xcorrs.w30.f_cst_lag = lag1;
            
    % sd for cst section
    MUdata.w30.cst_sd = std(cst);
    % save cst section
    MUdata.w30.hpf_cst_used = cst;
            
    % !!!!!!!!!!!!!!!        
    % ------ Adjust all signals based on whole 30-s cross correlation lag ----

    if lag1 < 0
        newfwhole = fwhole(abs(lag1):end);
    else
        pad = repelem(0,abs(lag1));
        newfwhole = vertcat(pad',fwhole);
    end
    
    % save var
    fdat.hp_filt{1,l} = newfwhole;
    
    % Section for analysis
    newf = newfwhole(fdat.steady30.start:fdat.steady30.endd);
    newf = newf(keep==1);

    if num > 0
        newf = newf(1:length(cst));
    end

    % save var
    fdat.steady30.hp_filt{1,l} = newf;
    MUdata.xcorrs.w30.f_used = newf;
    
    % --------- Reconstructed 30s ---------------------------
    % 1-s windows (200 ms hanning window for reconstructed FPC)
    if ~isfield(MUdata.PCA.iter.w1,'mergedfpc_smooth')
    else
    fpc = MUdata.PCA.iter.w1.mergedfpc_smooth(1:60001);
    fpc = fpc(keep==1);
        % save var
        MUdata.xcorrs.w30.w1.fpc_used = fpc;
        % Quick std calculation
        MUdata.PCA.iter.w30.w1.fpc_sd = std(fpc);
          
        % FPC vs Force
        [sigcor,siglag] = xcorr(fpc,newf,200,'coeff');
        [maxcor,ind] = max(sigcor);
        lag = siglag(ind);
            MUdata.xcorrs.w30.w1.f_fpc_r = maxcor;
            MUdata.xcorrs.w30.w1.f_fpc_lag = lag;

        % FPC vs CST
        [sigcor,siglag] = xcorr(fpc,cst,200,'coeff');
        [maxcor,ind] = max(sigcor);
        lag = siglag(ind);
            MUdata.xcorrs.w30.w1.fpc_cst_r = maxcor;
            MUdata.xcorrs.w30.w1.fpc_cst_lag = lag;
    end
    % 5-s windows (200 ms han ning window for reconstructed FPC)
    if ~isfield(MUdata.PCA.iter.w5,'mergedfpc_smooth')
    else
        fpc = MUdata.PCA.iter.w5.mergedfpc_smooth(1:60001);
        fpc = fpc(keep==1);
        % Quick std calculation
        MUdata.PCA.iter.w30.w5.fpc_sd = std(fpc);
        % save var
        MUdata.xcorrs.w30.w5.fpc_used = fpc;

            % FPC vs Force
            [sigcor,siglag] = xcorr(fpc,newf,200,'coeff');
            [maxcor,ind] = max(sigcor);
            lag = siglag(ind);
                MUdata.xcorrs.w30.w5.f_fpc_r = maxcor;
                MUdata.xcorrs.w30.w5.f_fpc_lag = lag;

            % FPC vs CST
            [sigcor,siglag] = xcorr(fpc,cst,200,'coeff');
            [maxcor,ind] = max(sigcor);
            lag = siglag(ind);
                MUdata.xcorrs.w30.w5.fpc_cst_r = maxcor;
                MUdata.xcorrs.w30.w5.fpc_cst_lag = lag;
    end
    
    % --------- 1-s Windows --------------------------
    if isfield(MUdata.w1,'bad_wins')
        % FPC vs force
        if isfield(MUdata.PCA.iter.w1,'coeffs_mean')
            for w = 1:30
                if MUdata.w1.bad_wins(w) == 1 % 1 = bad
                else
                    fsec = newfwhole(MUdata.w1.starts(w):MUdata.w1.endds(w));
                    fpc = normalize(MUdata.PCA.iter.w1.coeffs_mean{1,w}(end,:));
                    % Do XC
                    [sigcor,siglag] = xcorr(fpc,fsec,200,'coeff');
                    [maxcor,ind] = max(sigcor);
                    lag = siglag(ind);
                    MUdata.xcorrs.w1.f_fpc_r(w) = maxcor;
                    MUdata.xcorrs.w1.f_fpc_lag(w) = lag;
                end
            end 
        else
        end

        % CST vs force
            for w = 1:30
                if MUdata.w1.bad_wins(w) == 1 % 1 = bad
                else
                    cst = highpass(MUdata.w1.cst_secs{w},0.75,2000);
                    fsec = newfwhole(MUdata.w1.starts(w):MUdata.w1.endds(w));
                    % Do XC
                    [sigcor,siglag] = xcorr(cst,fsec,200,'coeff');
                    [maxcor,ind] = max(sigcor);
                    lag = siglag(ind);
                    MUdata.xcorrs.w1.f_cst_r(w) = maxcor;
                    MUdata.xcorrs.w1.f_cst_lag(w) = lag;
                end  
            end

        % CST vs FPC
        if isfield(MUdata.PCA.iter.w1,'coeffs_mean')
            for w = 1:30
                if MUdata.w1.bad_wins(w) == 1 % 1 = bad
                else
                cst = highpass(MUdata.w1.cst_secs{w},0.75,2000);
                fpc = MUdata.PCA.iter.w1.coeffs_mean{1,w}(end,:);
                % Do XC
                [sigcor,siglag] = xcorr(fpc,cst,200,'coeff');
                [maxcor,ind] = max(sigcor);
                lag = siglag(ind);
                MUdata.xcorrs.w1.fpc_cst_r(w) = maxcor;
                MUdata.xcorrs.w1.fpc_cst_lag(w) = lag;
                end
            end
        else
        end
    else
    end

    % --------- 5-s Windows --------------------------
    if isfield(MUdata.w5,'bad_wins')
        % FPC vs force
        if isfield(MUdata.PCA.iter.w5,'coeffs_mean')
            for w = 1:6
                if MUdata.w5.bad_wins(w) == 1 % 1 = bad
                else
                fpc = normalize(MUdata.PCA.iter.w5.coeffs_mean{1,w}(end,:));
                fsec = newfwhole(MUdata.w5.starts(w):MUdata.w5.endds(w));
                % Do XC
                [sigcor,siglag] = xcorr(fpc,fsec,200,'coeff');
                [maxcor,ind] = max(sigcor);
                lag = siglag(ind);
                MUdata.xcorrs.w5.f_fpc_r(w) = maxcor;
                MUdata.xcorrs.w5.f_fpc_lag(w) = lag;
                end 
            end
        else
        end

        % CST vs force
            for w = 1:6
                if MUdata.w5.bad_wins(w) == 1 % 1 = bad
                else
                cst = highpass(MUdata.w5.cst_secs{w},0.75,2000);
                fsec = newfwhole(MUdata.w5.starts(w):MUdata.w5.endds(w));
                % Do XC
                [sigcor,siglag] = xcorr(cst,fsec,200,'coeff');
                [maxcor,ind] = max(sigcor);
                lag = siglag(ind);
                MUdata.xcorrs.w5.f_cst_r(w) = maxcor;
                MUdata.xcorrs.w5.f_cst_lag(w) = lag;
                end  
            end

        % CST vs FPC
        if isfield(MUdata.PCA.iter.w5,'coeffs_mean')
            for w = 1:6
                if MUdata.w5.bad_wins(w) == 1 % 1 = bad
                else
                cst = highpass(MUdata.w5.cst_secs{w},0.75,2000);
                fpc = MUdata.PCA.iter.w5.coeffs_mean{1,w}(end,:);
                % Do XC
                [sigcor,siglag] = xcorr(fpc,cst,200,'coeff');
                [maxcor,ind] = max(sigcor);
                lag = siglag(ind);
                MUdata.xcorrs.w5.fpc_cst_r(w) = maxcor;
                MUdata.xcorrs.w5.fpc_cst_lag(w) = lag;
                end  
            end
        else
        end
    else
    end

% ----------- Summing individual muscle PCAs instead ------------
    % Sum coeffs for all three muscles
    PCAs.w1.MG = []; PCAs.w1.LG = []; PCAs.w1.SOL = [];
    PCAs.w5.MG = []; PCAs.w5.LG = []; PCAs.w5.SOL = [];
    % 1-s window
    for m = 1:length(muscles)
        mus = muscles{m};
        if isfield(MUdata.(mus).PCA.iter.w1,'coeffs_mean')
            for w = 1:30 %length(MUdata.(mus).PCA.iter.w1.coeffs_mean)
                if MUdata.(mus).w1.bad_wins(w) == 1 % 1 = bad
                    vec = repelem(0,2000);
                else
                    vec = MUdata.(mus).PCA.iter.w1.coeffs_mean{w}(end,:);
                end
                PCAs.w1.(mus) = horzcat(PCAs.w1.(mus),vec);
            end
            PCAs.w1.(mus) = PCAs.w1.(mus)(1:60001);
        else
        end
    end
    % 5-s window
    for m = 1:length(muscles)
        mus = muscles{m};
        if isfield(MUdata.(mus).PCA.iter.w5,'coeffs_mean')
            if isfield(MUdata.(mus).w5,'bad_wins')
                for w = 1:6 %length(MUdata.(mus).PCA.iter.w5.coeffs_mean)
                    if MUdata.(mus).w5.bad_wins(w) == 1 % 1 = bad
                        vec = repelem(0,10000);
                    else
                        vec = MUdata.(mus).PCA.iter.w5.coeffs_mean{w}(end,:);
                    end
                    PCAs.w5.(mus) = horzcat(PCAs.w5.(mus),vec);
                end
            PCAs.w5.(mus) = PCAs.w5.(mus)(1:60001);
            else
            end
        else
        end
    end

    % Find # active
    if sum(contains(muscles,'MG')) >0
        for mu = 1:size(MUdata.MG.binary)
            temp = MUdata.MG.binary(mu,:);
            if sum(temp(MUdata.start:MUdata.endd)) == 0
                count(mu) = 0;
            else
                count(mu) = 1;
            end
        end
        mglen = sum(count);
    else
        mglen = [];
    end

    if sum(contains(muscles,'LG')) >0
        count = [];
        for mu = 1:size(MUdata.LG.binary)
            temp = MUdata.LG.binary(mu,:);
            if sum(temp(MUdata.start:MUdata.endd)) == 0
                count(mu) = 0;
            else
                count(mu) = 1;
            end
        end
        lglen = sum(count);
    else
        lglen = [];
    end

    if sum(contains(muscles,'SOL')) >0
        count = [];
        for mu = 1:size(MUdata.SOL.binary)
            temp = MUdata.SOL.binary(mu,:);
            if sum(temp(MUdata.start:MUdata.endd)) == 0
                count(mu) = 0;
            else
                count(mu) = 1;
            end
        end
        sollen = sum(count);
    else
        sollen = [];
    end

    % 1-s windows - sum together
    temp = [];
    if isempty(PCAs.w1.MG)
    else
        temp = PCAs.w1.MG*mglen;
    end
    
    if isempty(PCAs.w1.LG)
    elseif isempty(temp)
        temp = PCAs.w1.LG*lglen;
    else
        temp = temp+(PCAs.w1.LG*lglen);
    end
    
    if isempty(PCAs.w1.SOL)
    elseif isempty(temp)
        temp = PCAs.w1.SOL*sollen;
    else
        temp = temp+(PCAs.w1.SOL*sollen);
    end
    MUdata.PCA.iter.w1.sumPFs = temp;
    
    % 5s windows
    temp2 = [];
    if isempty(PCAs.w5.MG)
    else
        temp2 = PCAs.w5.MG*mglen;
    end
    
    if isempty(PCAs.w5.LG)
    elseif isempty(temp2)
       temp2 = PCAs.w5.LG*lglen;
    else
       temp2 = temp2+(PCAs.w5.LG*lglen);
    end
    
    if isempty(PCAs.w5.SOL)
    elseif isempty(temp2)
        temp2 = PCAs.w5.SOL*sollen;
    else
        temp2 = temp2+PCAs.w5.SOL*sollen;
    end
    MUdata.PCA.iter.w5.sumPFs = temp2;

    % -------- Now do cross correlations with the summed FPC ---------------
    cst = highpass(MUdata.cst(MUdata.start:MUdata.endd),0.75,2000);
    cst = cst(keep ==1);
%    fwhole = highpass(fdat.filt{1,l},0.72,2000);
%     f = fwhole(fdat.steady30.start:fdat.steady30.endd);
%     f = f(keep ==1);
        % --------- Reconstructed 30s ---------------------------
        % 1-s windows (200 ms hanning window for reconstructed FPC)
        fpc = MUdata.PCA.iter.w1.sumPFs;
        if isempty(fpc)
        else
            fpc = fpc(keep==1);

            % FPC vs Force
            [sigcor,siglag] = xcorr(fpc,newf,200,'coeff');
            [maxcor,ind] = max(sigcor);
            lag = siglag(ind);
                MUdata.xcorrs.w30.w1.f_sumfpc_r = maxcor;
                MUdata.xcorrs.w30.w1.f_sumfpc_lag = lag;

            % FPC vs CST
            [sigcor,siglag] = xcorr(fpc,cst,200,'coeff');
            [maxcor,ind] = max(sigcor);
            lag = siglag(ind);
                MUdata.xcorrs.w30.w1.sumfpc_cst_r = maxcor;
                MUdata.xcorrs.w30.w1.sumfpc_cst_lag = lag;

            % FPC vs summed FPC
            oldfpc = MUdata.PCA.iter.w1.mergedfpc_smooth;
            oldfpc = oldfpc(keep==1);

            [sigcor,siglag] = xcorr(fpc,oldfpc,200,'coeff');
            [maxcor,ind] = max(sigcor);
            lag = siglag(ind);
                MUdata.xcorrs.w30.w1.fpc_sumfpc_r = maxcor;
                MUdata.xcorrs.w30.w1.fpc_sumfpc_lag = lag;
        end

      % 5-s windows (200 ms han ning window for reconstructed FPC)
        fpc = MUdata.PCA.iter.w5.sumPFs;
        if isempty(fpc)
        else
            fpc = fpc(keep==1);

            % FPC vs Force
            [sigcor,siglag] = xcorr(fpc,newf,200,'coeff');
            [maxcor,ind] = max(sigcor);
            lag = siglag(ind);
                MUdata.xcorrs.w30.w5.f_sumfpc_r = maxcor;
                MUdata.xcorrs.w30.w5.f_sumfpc_lag = lag;

            % FPC vs CST
            [sigcor,siglag] = xcorr(fpc,cst,200,'coeff');
            [maxcor,ind] = max(sigcor);
            lag = siglag(ind);
                MUdata.xcorrs.w30.w5.sumfpc_cst_r = maxcor;
                MUdata.xcorrs.w30.w5.sumfpc_cst_lag = lag;

            % FPC vs summed FPC
            if ~isfield(MUdata.PCA.iter.w5,'mergedfpc_smooth')
            else
            oldfpc = MUdata.PCA.iter.w5.mergedfpc_smooth;
            oldfpc = oldfpc(keep==1);

            [sigcor,siglag] = xcorr(fpc,oldfpc,200,'coeff');
            [maxcor,ind] = max(sigcor);
            lag = siglag(ind);
                MUdata.xcorrs.w30.w1.fpc_sumfpc_r = maxcor;
                MUdata.xcorrs.w30.w1.fpc_sumfpc_lag = lag;
            end
        end

    % --- WINDOWED XCORS with SUMMED FPC ---------------- 
       % --------- 1-s Windows --------------------------
        fpc = MUdata.PCA.iter.w1.sumPFs;
        %fpc = fpc(keep==1);
        if isempty(fpc)
        else
            starts = MUdata.w1.starts-MUdata.w1.starts(1)+1;
            endds = MUdata.w1.endds-MUdata.w1.starts(1);

            if isfield(MUdata.w1,'bad_wins')
                % FPC vs force
                if isfield(MUdata.PCA.iter.w1,'coeffs_mean')
                    for w = 1:30
                        if MUdata.w1.bad_wins(w) == 1 % 1 = bad
                        else
                            fpcsec = fpc(starts(w):endds(w));
                            fsec = newfwhole(MUdata.w1.starts(w):MUdata.w1.endds(w)-1);
                            % Do XC
                            [sigcor,siglag] = xcorr(fpcsec,fsec,2000,'coeff');
                            [maxcor,ind] = max(sigcor);
                            lag = siglag(ind);
                            MUdata.xcorrs.w1.f_sumfpc_r(w) = maxcor;
                            MUdata.xcorrs.w1.f_sumfpc_lag(w) = lag;
                        end
                    end 
                else
                end

                % CST vs FPC
                if isfield(MUdata.PCA.iter.w1,'coeffs_mean')
                    for w = 1:30
                        if MUdata.w1.bad_wins(w) == 1 % 1 = bad
                        else
                        cst = highpass(MUdata.w1.cst_secs{w}(1:end-1),0.75,2000);
                        fpcsec = fpc(starts(w):endds(w));
                        % Do XC
                        [sigcor,siglag] = xcorr(fpcsec,cst,200,'coeff');
                        [maxcor,ind] = max(sigcor);
                        lag = siglag(ind);
                        MUdata.xcorrs.w1.sumfpc_cst_r(w) = maxcor;
                        MUdata.xcorrs.w1.sumfpc_cst_lag(w) = lag;
                        end
                    end
                else
                end
            else
            end
        end

        % --------- 5-s Windows --------------------------
        starts = MUdata.w5.starts-MUdata.w5.starts(1)+1;
        endds = MUdata.w5.endds-MUdata.w5.starts(1);

        if isempty(fpc)
        else
            if isfield(MUdata.w5,'bad_wins')
                % FPC vs force
                if isfield(MUdata.PCA.iter.w5,'coeffs_mean')
                    for w = 1:6
                        if MUdata.w5.bad_wins(w) == 1 % 1 = bad
                        else
                        fpcsec = fpc(starts(w):endds(w));
                        fsec = newfwhole(MUdata.w5.starts(w):MUdata.w5.endds(w)-1);
                        % Do XC
                        [sigcor,siglag] = xcorr(fpcsec,fsec,200,'coeff');
                        [maxcor,ind] = max(sigcor);
                        lag = siglag(ind);
                        MUdata.xcorrs.w5.f_sumfpc_r(w) = maxcor;
                        MUdata.xcorrs.w5.f_sumfpc_lag(w) = lag;
                        end 
                    end
                else
                end

                % CST vs FPC
                if isfield(MUdata.PCA.iter.w5,'coeffs_mean')
                    for w = 1:6
                        if MUdata.w5.bad_wins(w) == 1 % 1 = bad
                        else
                        cst = highpass(MUdata.w5.cst_secs{w}(1:end-1),0.75,2000);
                        fpcsec = fpc(starts(w):endds(w));
                        % Do XC
                        [sigcor,siglag] = xcorr(fpcsec,cst,200,'coeff');
                        [maxcor,ind] = max(sigcor);
                        lag = siglag(ind);
                        MUdata.xcorrs.w5.sumfpc_cst_r(w) = maxcor;
                        MUdata.xcorrs.w5.sumfpc_cst_lag(w) = lag;
                        end  
                    end
                else
                end
            else
            end
        end
end
end
