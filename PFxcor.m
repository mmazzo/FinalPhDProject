function [MUdata] = PFxcor(MUdata,fdat,muscles)
% Calculate cross correlation coefficients between force, PCA FCC and CST

% Manually select appropriate sections first
% Trim sections out of both that are flagged
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
    else % usable portions = 1
        keep = zeros(1,length(allflags));
        for i = 1:num
            keep(x(1):x(2)) = 1;
            if length(x) > 1
            x = x(3:end);
            end
        end
    end
else
    keep = zeros(1,length(allflags));
    keep(1:end) = 1; % whole contraction = 1
end
        
   
% ALL PFs COMBINED
% --------- Whole signal --------------------------------
cst = highpass(MUdata.cst(MUdata.start:MUdata.endd),0.75,2000);
cst = cst(keep ==1);
f = highpass(fdat.steady30.filt{1,1},0.72,2000);
f = f(keep ==1);
    % CST vs Force
    [sigcor,siglag] = xcorr(cst,f,2000,'coeff');
    [maxcor,ind] = max(sigcor);
    lag = siglag(ind);
        MUdata.xcorrs.w30.f_cst_r = maxcor;
        MUdata.xcorrs.w30.f_cst_lag = lag;

% --------- Reconstructed 30s ---------------------------
% 1-s windows (200 ms hanning window for reconstructed FPC)
fpc = MUdata.PCA.iter.w1.mergedfpc_smooth;
fpc = fpc(keep==1);
    % FPC vs Force
    [sigcor,siglag] = xcorr(fpc,f,2000,'coeff');
    [maxcor,ind] = max(sigcor);
    lag = siglag(ind);
        MUdata.xcorrs.w30.w1.f_fpc_r = maxcor;
        MUdata.xcorrs.w30.w1.f_fpc_lag = lag;

    % FPC vs CST
    [sigcor,siglag] = xcorr(fpc,cst,2000,'coeff');
    [maxcor,ind] = max(sigcor);
    lag = siglag(ind);
        MUdata.xcorrs.w30.w1.fpc_cst_r = maxcor;
        MUdata.xcorrs.w30.w1.fpc_cst_lag = lag;
        
% 5-s windows (200 ms han ning window for reconstructed FPC)
fpc = MUdata.PCA.iter.w5.mergedfpc_smooth;
fpc = fpc(keep==1);

    % FPC vs Force
    [sigcor,siglag] = xcorr(fpc,f,2000,'coeff');
    [maxcor,ind] = max(sigcor);
    lag = siglag(ind);
        MUdata.xcorrs.w30.w5.f_fpc_r = maxcor;
        MUdata.xcorrs.w30.w5.f_fpc_lag = lag;

    % FPC vs CST
    [sigcor,siglag] = xcorr(fpc,cst,2000,'coeff');
    [maxcor,ind] = max(sigcor);
    lag = siglag(ind);
        MUdata.xcorrs.w30.w5.fpc_cst_r = maxcor;
        MUdata.xcorrs.w30.w5.fpc_cst_lag = lag;

% --------- 1-s Windows --------------------------
if isfield(MUdata.w1,'bad_wins')
    % FPC vs force
    if isfield(MUdata.PCA.iter.w1,'coeffs_mean')
        for w = 1:30
            if MUdata.w1.bad_wins(w) == 1 % 1 = bad
            else
                fpc = normalize(MUdata.PCA.iter.w1.coeffs_mean{1,w}(end,:));
                f = highpass(MUdata.w1.f_secs{w},0.75,2000);
                % Do XC
                [sigcor,siglag] = xcorr(fpc,f,2000,'coeff');
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
                f = highpass(MUdata.w1.f_secs{1,w},0.75,2000);
                % Do XC
                [sigcor,siglag] = xcorr(cst,f,2000,'coeff');
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
            [sigcor,siglag] = xcorr(fpc,cst,2000,'coeff');
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

%     % CST vs FPC derived from 30s continuous PCA
%         for w = 1:30
%             cst = highpass(MUdata.w1.cst_secs{w},0.75,2000);
%             fpc = MUdata.PCA.iter.w30.w1.fpc_secs{w}; 
%             % Do XC
%             [sigcor,siglag] = xcorr(fpc,cst,'coeff');
%             [maxcor,ind] = max(sigcor);
%             lag = siglag(ind);
%             MUdata.xcorrs.w1.fpc30_cst_r(w) = maxcor;
%             MUdata.xcorrs.w1.fpc30_cst_lag(w) = lag;
%         end  
% 
%      % Force vs FPC derived from 30s merged PCA
%         for w = 1:30
%             f = highpass(MUdata.w1.f_secs{1,w},0.75,2000);
%             fpc = normalize(MUdata.PCA.iter.w30.w1.fpc_secs{w}); 
%             % Do XC
%             [sigcor,siglag] = xcorr(fpc,f,'coeff');
%             [maxcor,ind] = max(sigcor);
%             lag = siglag(ind);
%             MUdata.xcorrs.w1.f_fpc30_r(w) = maxcor;
%             MUdata.xcorrs.w1.f_fpc30_lag(w) = lag;
%         end   
        
% --------- 5-s Windows --------------------------
if isfield(MUdata.w5,'bad_wins')
    % FPC vs force
    if isfield(MUdata.PCA.iter.w5,'coeffs_mean')
        for w = 1:6
            if MUdata.w5.bad_wins(w) == 1 % 1 = bad
            else
            fpc = normalize(MUdata.PCA.iter.w5.coeffs_mean{1,w}(end,:));
            f = highpass(MUdata.w5.f_secs{w},0.75,2000);
            % Do XC
            [sigcor,siglag] = xcorr(fpc,f,2000,'coeff');
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
            f = highpass(MUdata.w5.f_secs{1,w},0.75,2000);
            % Do XC
            [sigcor,siglag] = xcorr(cst,f,2000,'coeff');
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
            [sigcor,siglag] = xcorr(fpc,cst,2000,'coeff');
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
%     % CST vs FPC derived from 30s continuous PCA
%         for w = 1:6
%             cst = highpass(MUdata.w5.cst_secs{w},0.75,2000);
%             fpc = MUdata.PCA.iter.w30.w5.fpc_secs{w}; 
%             % Do XC
%             [sigcor,siglag] = xcorr(fpc,cst,'coeff');
%             [maxcor,ind] = max(sigcor);
%             lag = siglag(ind);
%             MUdata.xcorrs.w5.fpc30_cst_r(w) = maxcor;
%             MUdata.xcorrs.w5.fpc30_cst_lag(w) = lag;
%         end  
% 
%      % Force vs FPC derived from 30s continuous PCA
%         for w = 1:6
%             f = highpass(MUdata.w5.f_secs{1,w},0.75,2000);
%             fpc = normalize(MUdata.PCA.iter.w30.w5.fpc_secs{w}); 
%             % Do XC
%             [sigcor,siglag] = xcorr(fpc,f,'coeff');
%             [maxcor,ind] = max(sigcor);
%             lag = siglag(ind);
%             MUdata.xcorrs.w5.f_fpc30_r(w) = maxcor;
%             MUdata.xcorrs.w5.f_fpc30_lag(w) = lag;
%         end    
        
% % --------- Comparing muscles --------------------------
% if isfield(MUdata,'MG')
%     if ~isnan(MUdata.MG.cst)
%     fpc_MG = normalize(MUdata.MG.PCA.iter.w30.coeffs{end}(1,:));
%     end
% end
% 
% if isfield(MUdata,'LG')
%     if ~isnan(MUdata.LG.cst)
%     fpc_LG = normalize(MUdata.LG.PCA.iter.w30.coeffs{end}(1,:));
%     end
% end
% 
% if isfield(MUdata,'SOL')
%     if ~isnan(MUdata.SOL.cst)
%     fpc_SOL = normalize(MUdata.SOL.PCA.iter.w30.coeffs{end}(1,:));
%     end
% end
% 
%     % MG vs LG
%     if exist('fpc_MG') && exist('fpc_LG')
%         % Full 30s
%         [sigcor,siglag] = xcorr(fpc_MG,fpc_LG,'coeff');
%         [maxcor,ind] = max(sigcor);
%         lag = siglag(ind);
%             MUdata.xcorrs.w30.MGLG.f_cst_r = maxcor;
%             MUdata.xcorrs.w30.MGLG.f_cst_lag = lag;
%         % 1-s Windows
%             for w = 1:30
%                 fpcMG = normalize(MUdata.MG.PCA.iter.w1.coeffs{1,w}{end}(1,:));
%                 fpcLG = normalize(MUdata.LG.PCA.iter.w1.coeffs{1,w}{end}(1,:));
%                 % Do XC
%                 [sigcor,siglag] = xcorr(fpcMG,fpcLG,'coeff');
%                 [maxcor,ind] = max(sigcor);
%                 lag = siglag(ind);
%                 MUdata.xcorrs.w1.MGLG.f_fpc_r(w) = maxcor;
%                 MUdata.xcorrs.w1.MGLG.f_fpc_lag(w) = lag;
%             end 
%         % 5-s Windows
%             for w = 1:6
%                 fpcMG = normalize(MUdata.MG.PCA.iter.w5.coeffs{1,w}{end}(1,:));
%                 fpcLG = normalize(MUdata.LG.PCA.iter.w5.coeffs{1,w}{end}(1,:));
%                 % Do XC
%                 [sigcor,siglag] = xcorr(fpcMG,fpcLG,'coeff');
%                 [maxcor,ind] = max(sigcor);
%                 lag = siglag(ind);
%                 MUdata.xcorrs.w5.MGLG.f_fpc_r(w) = maxcor;
%                 MUdata.xcorrs.w5.MGLG.f_fpc_lag(w) = lag;
%             end 
%     end
%     
%     % MG vs SOL
%     if exist('fpc_MG') && exist('fpc_SOL')
%         % Full 30s
%         [sigcor,siglag] = xcorr(fpc_MG,fpc_SOL,'coeff');
%         [maxcor,ind] = max(sigcor);
%         lag = siglag(ind);
%             MUdata.xcorrs.w30.MGSOL.f_cst_r = maxcor;
%             MUdata.xcorrs.w30.MGSOL.f_cst_lag = lag;
%         % 1-s Windows
%             for w = 1:30
%                 fpcMG = normalize(MUdata.MG.PCA.iter.w1.coeffs{1,w}{end}(1,:));
%                 fpcSOL = normalize(MUdata.SOL.PCA.iter.w1.coeffs{1,w}{end}(1,:));
%                 % Do XC
%                 [sigcor,siglag] = xcorr(fpcMG,fpcSOL,'coeff');
%                 [maxcor,ind] = max(sigcor);
%                 lag = siglag(ind);
%                 MUdata.xcorrs.w1.MGSOL.f_fpc_r(w) = maxcor;
%                 MUdata.xcorrs.w1.MGSOL.f_fpc_lag(w) = lag;
%             end 
%         % 5-s Windows
%             for w = 1:6
%                 fpcMG = normalize(MUdata.MG.PCA.iter.w5.coeffs{1,w}{end}(1,:));
%                 fpcSOL = normalize(MUdata.SOL.PCA.iter.w5.coeffs{1,w}{end}(1,:));
%                 % Do XC
%                 [sigcor,siglag] = xcorr(fpcMG,fpcSOL,'coeff');
%                 [maxcor,ind] = max(sigcor);
%                 lag = siglag(ind);
%                 MUdata.xcorrs.w5.MGSOL.f_fpc_r(w) = maxcor;
%                 MUdata.xcorrs.w5.MGSOL.f_fpc_lag(w) = lag;
%             end 
%     end
%     
%     % SOL vs LG
%     if exist('fpc_SOL') && exist('fpc_LG')
%         % Full 30s
%         [sigcor,siglag] = xcorr(fpc_SOL,fpc_LG,'coeff');
%         [maxcor,ind] = max(sigcor);
%         lag = siglag(ind);
%             MUdata.xcorrs.w30.SOLLG.f_cst_r = maxcor;
%             MUdata.xcorrs.w30.SOLLG.f_cst_lag = lag;
%         % 1-s Windows
%             for w = 1:30
%                 fpcSOL = normalize(MUdata.SOL.PCA.iter.w1.coeffs{1,w}{end}(1,:));
%                 fpcLG = normalize(MUdata.LG.PCA.iter.w1.coeffs{1,w}{end}(1,:));
%                 % Do XC
%                 [sigcor,siglag] = xcorr(fpcSOL,fpcLG,'coeff');
%                 [maxcor,ind] = max(sigcor);
%                 lag = siglag(ind);
%                 MUdata.xcorrs.w1.SOLLG.f_fpc_r(w) = maxcor;
%                 MUdata.xcorrs.w1.SOLLG.f_fpc_lag(w) = lag;
%             end 
%         % 5-s Windows
%             for w = 1:6
%                 fpcSOL = normalize(MUdata.SOL.PCA.iter.w5.coeffs{1,w}{end}(1,:));
%                 fpcLG = normalize(MUdata.LG.PCA.iter.w5.coeffs{1,w}{end}(1,:));
%                 % Do XC
%                 [sigcor,siglag] = xcorr(fpcSOL,fpcLG,'coeff');
%                 [maxcor,ind] = max(sigcor);
%                 lag = siglag(ind);
%                 MUdata.xcorrs.w5.SOLLG.f_fpc_r(w) = maxcor;
%                 MUdata.xcorrs.w5.SOLLG.f_fpc_lag(w) = lag;
%             end 
%     end
end
