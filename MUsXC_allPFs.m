function [MUdata] = MUsXC_allPFs(MUdata,muscles)
% MUdata = PFdata.(day).(level).MUdata.(time)
% Calculate cross-correlation between individual MUs and the FPCs/CST
% for ALL PFs
warning('off','all')
% --------- Individual Muscles ----------------------------------------
PFidrfilts = [];
PFrawidrs = [];
for m = 1:length(muscles)
    mus = muscles{m};
    % Recreate single MU IDR lines used in FPC analysis
    for mu = 1:length(MUdata.(mus).rawlines)
        len = length(MUdata.(mus).binary);
        isivec = MUdata.(mus).binary_ISI;
        isivec(isivec == 0) = NaN;
        if isempty(MUdata.(mus).rawlines{mu})
        elseif isnan(MUdata.(mus).rawlines{mu})
        else
            rawidrs(mu,:) = MUdata.(mus).rawlines{mu};
            temp = MUdata.(mus).rawlines{mu};
            start = find(~isnan(temp),1,'first');
            endd = find(~isnan(temp),1,'last');
            temp = temp(start:endd);
            raw = highpass(temp,0.75,2000);
            temp = conv(temp,hann(800),'same');
            temp = highpass(temp,0.75,2000);
            nans1 = repelem(NaN,start-1);
            nans2 = repelem(NaN,(len-endd));
            idrfilts(mu,:) = horzcat(nans1,temp,nans2);
            rawidrs(mu,:) = horzcat(nans1,raw,nans2);
        end
    end
    PFidrfilts = vertcat(PFidrfilts,idrfilts);
    PFrawidrs = vertcat(PFrawidrs,rawidrs);
end

idrfilts = PFidrfilts;
rawidrs = PFrawidrs;

% ---------- FPC created using WINDOWS -------------------------------------
    % 1-s Windows
    for w = 1:30
        if MUdata.w1.bad_wins(w) == 1
        else
            if length(MUdata.PCA.iter.raw.w1.coeffs_mean) == 1
                MUdata.w1.bad_wins(w) = 1;
            elseif isempty(MUdata.PCA.iter.w1.coeffs_mean{w})
                MUdata.w1.bad_wins(w) = 1;
            else
                % Subset data
                s = MUdata.w1.starts(w);
                e = MUdata.w1.endds(w);
                MUvec = idrfilts(:,s:e);
                MUvecRaw = rawidrs(:,s:e);
                fcc_raw = MUdata.PCA.iter.raw.w1.coeffs_mean{w}(end,:); % Use FPC from highest # of MUs
                fcc_smooth = MUdata.PCA.iter.w1.coeffs_mean{w}(end,:);
                %cstsec = MUdata.w1.cst_secs{w};

                % Cross-correlation
                for mu = 1:size(MUvec,1)
                    if sum(MUvec(mu,:)) == 0
                    else
                    % Cross correlation between individual MUs and FCC
                    [r,lag] = xcorr(MUvecRaw(mu,:),fcc_raw,200,'normalized'); % cutoff at 200 data poitns from 0 lag
                        [cors,ind] = max(r); lag = lag(ind);
                            MUdata.PCA.iter.w1.MUsXCraw(w,mu) = cors;
                            MUdata.PCA.iter.w1.MUsXCraw_lag(w,mu) = lag;
                    [r,lag] = xcorr(MUvec(mu,:),fcc_smooth,200,'normalized');
                        [cors,ind] = max(r); lag = lag(ind);
                            MUdata.PCA.iter.w1.MUsXCsmooth(w,mu) = cors;
                            MUdata.PCA.iter.w1.MUsXCsmooth_lag(w,mu) = lag;
                     end
                end
            end
        end
    end
    
    MUdata.PCA.iter.w1.MUsXCraw(MUdata.PCA.iter.w1.MUsXCraw == 0) = NaN;
    MUdata.PCA.iter.w1.MUsXCraw_lag(MUdata.PCA.iter.w1.MUsXCraw == 0) = NaN;
    MUdata.PCA.iter.w1.MUsXCsmooth(MUdata.PCA.iter.w1.MUsXCsmooth == 0) = NaN;
    MUdata.PCA.iter.w1.MUsXCsmooth_lag(MUdata.PCA.iter.w1.MUsXCsmooth == 0) = NaN;


     % 5-s Windows
    for w = 1:6
        if MUdata.w5.bad_wins(w) == 1
        else
            if length(MUdata.PCA.iter.raw.w5.coeffs_mean) == 1
                MUdata.w5.bad_wins(w) = 1;
            elseif isempty(MUdata.PCA.iter.w5.coeffs_mean{w})
                MUdata.w5.bad_wins(w) = 1;
            else
                % Subset data
                s = MUdata.w5.starts(w);
                e = MUdata.w5.endds(w);
                MUvec = idrfilts(:,s:e);
                MUvecRaw = rawidrs(:,s:e);
                fcc_raw = MUdata.PCA.iter.raw.w5.coeffs_mean{w}(end,:); % Use FPC form highest # of MUs
                fcc_smooth = MUdata.PCA.iter.w5.coeffs_mean{w}(end,:);

                % Cross-correlation
                for mu = 1:size(MUvec,1)
                    if nansum(MUvec(mu,:)) == 0
                    else
                    % Cross correlation between individual MUs and FCC
                    [r,lag] = xcorr(MUvecRaw(mu,:),fcc_raw,200,'normalized'); % cutoff at 200 data poitns from 0 lag
                        [cors,ind] = max(r); lag = lag(ind);
                        
                            MUdata.PCA.iter.w5.MUsXCraw(w,mu) = cors;
                            MUdata.PCA.iter.w5.MUsXCraw_lag(w,mu) = lag;
                    [r,lag] = xcorr(MUvec(mu,:),fcc_smooth,200,'normalized');
                        [cors,ind] = max(r); lag = lag(ind);
                        
                            MUdata.PCA.iter.w5.MUsXCsmooth(w,mu) = cors;
                            MUdata.PCA.iter.w5.MUsXCsmooth_lag(w,mu) = lag;
                     end
                end
            end
        end
    end

    MUdata.PCA.iter.w5.MUsXCraw(MUdata.PCA.iter.w5.MUsXCraw == 0) = NaN;
    MUdata.PCA.iter.w5.MUsXCraw_lag(MUdata.PCA.iter.w5.MUsXCraw == 0) = NaN;
    MUdata.PCA.iter.w5.MUsXCsmooth(MUdata.PCA.iter.w5.MUsXCsmooth == 0) = NaN;
    MUdata.PCA.iter.w5.MUsXCsmooth_lag(MUdata.PCA.iter.w5.MUsXCsmooth == 0) = NaN;
    
    
% % ------------ 30-s CONTINUOUS FPC -------------------------------------
%     % 1-s Windows
%     for w = 1:30
%         if MUdata.w1.bad_wins(w) == 1
%         else
%             % Subset data
%             s = MUdata.w1.starts(w);
%             e = MUdata.w1.endds(w);
%             MUvec = idrfilts(:,s:e);
%             MUvecRaw = rawidrs(:,s:e);
%             fcc_raw = MUdata.PCA.iter.raw.w30.w1.fpc_secs{w}; % Use FPC form highest # of MUs
%             fcc_smooth = MUdata.PCA.iter.w30.w1.fpc_secs{w};
% 
%             % Cross-correlation
%             for mu = 1:size(MUvec,1)
%                 if nansum(MUvec(mu,:)) == 0
%                 else
%                 % Cross correlation between individual MUs and FCC
%                 [r,lag] = xcorr(MUvecRaw(mu,:),fcc_raw,200,'normalized'); % cutoff at 200 data poitns from 0 lag
%                     [cors,ind] = max(r); lag = lag(ind);
%                     
%                         MUdata.PCA.iter.w30.w1.MUsXCraw(w,mu) = cors;
%                         MUdata.PCA.iter.w30.w1.MUsXCraw_lag(w,mu) = lag;
%                 [r,lag] = xcorr(MUvec(mu,:),fcc_smooth,200,'normalized');
%                     [cors,ind] = max(r); lag = lag(ind);
%                     
%                         MUdata.PCA.iter.w30.w1.MUsXCsmooth(w,mu) = cors;
%                         MUdata.PCA.iter.w30.w1.MUsXCsmooth_lag(w,mu) = lag;
%                 end
%             end
%         end
%     end
%     
%     MUdata.PCA.iter.w30.w1.MUsXCraw(MUdata.PCA.iter.w30.w1.MUsXCraw == 0) = NaN;
%     MUdata.PCA.iter.w30.w1.MUsXCraw_lag(MUdata.PCA.iter.w30.w1.MUsXCraw == 0) = NaN;
%     MUdata.PCA.iter.w30.w1.MUsXCsmooth(MUdata.PCA.iter.w30.w1.MUsXCsmooth == 0) = NaN;
%     MUdata.PCA.iter.w30.w1.MUsXCsmooth_lag(MUdata.PCA.iter.w30.w1.MUsXCsmooth == 0) = NaN;
% 
%      % 5-s Windows
%     for w = 1:6
%         if MUdata.w5.bad_wins(w) == 1
%         else
%             % Subset data
%             s = MUdata.w5.starts(w);
%             e = MUdata.w5.endds(w);
%             MUvec = idrfilts(:,s:e);
%             MUvecRaw = rawidrs(:,s:e);
%             fcc_raw = MUdata.PCA.iter.raw.w30.w5.fpc_secs{w}; % Use FPC form highest # of MUs
%             fcc_smooth = MUdata.PCA.iter.w30.w5.fpc_secs{w};
% 
%             % Cross-correlation
%             for mu = 1:size(MUvec,1)
%                 if nansum(MUvec(mu,:)) == 0
%                 else
%                 % Cross correlation between individual MUs and FCC
%                 [r,lag] = xcorr(MUvecRaw(mu,:),fcc_raw,200,'normalized'); % cutoff at 200 data poitns from 0 lag
%                     [cors,ind] = max(r); lag = lag(ind);
%                     
%                         MUdata.PCA.iter.w30.w5.MUsXCraw(w,mu) = cors;
%                         MUdata.PCA.iter.w30.w5.MUsXCraw_lag(w,mu) = lag;
%                 [r,lag] = xcorr(MUvec(mu,:),fcc_smooth,200,'normalized');
%                     [cors,ind] = max(r); lag = lag(ind);
%                     
%                         MUdata.PCA.iter.w30.w5.MUsXCsmooth(w,mu) = cors;
%                         MUdata.PCA.iter.w30.w5.MUsXCsmooth_lag(w,mu) = lag;
%                 end
%             end
%         end
%     end
%     
%         
%     MUdata.PCA.iter.w30.w5.MUsXCraw(MUdata.PCA.iter.w30.w5.MUsXCraw == 0) = NaN;
%     MUdata.PCA.iter.w30.w5.MUsXCraw_lag(MUdata.PCA.iter.w30.w5.MUsXCraw == 0) = NaN;
%     MUdata.PCA.iter.w30.w5.MUsXCsmooth(MUdata.PCA.iter.w30.w5.MUsXCsmooth == 0) = NaN;
%     MUdata.PCA.iter.w30.w5.MUsXCsmooth_lag(MUdata.PCA.iter.w30.w5.MUsXCsmooth == 0) = NaN;
%   
    
    % ------------ CST -------------------------------------
    % Highpass filtered CST during steady 30
    cst = highpass(MUdata.cst,0.75,2000); 

    % 1-s Windows
    for w = 1:30
        if MUdata.w1.bad_wins(w) == 1
        else
            % Subset data
            s = MUdata.w1.starts(w);
            e = MUdata.w1.endds(w);
            MUvec = idrfilts(:,s:e);
            MUvecRaw = rawidrs(:,s:e);
            cstvec = MUdata.w1.cst_secs{w};
            % Cross-correlation
            for mu = 1:size(MUvec,1)
                if nansum(MUvec(mu,:)) == 0
                else
                % Cross correlation between individual MUs and CST
                [r,lag] = xcorr(MUvecRaw(mu,:),cstvec,200,'normalized'); % cutoff at 200 data poitns from 0 lag
                    [cors,ind] = max(r); lag = lag(ind);
                        MUdata.w1.MUsXC_CSTraw(w,mu) = cors;
                        MUdata.w1.MUsXC_CSTraw_lag(w,mu) = lag;
                [r,lag] = xcorr(MUvec(mu,:),cstvec,200,'normalized');
                    [cors,ind] = max(r); lag = lag(ind);
                        MUdata.w1.MUsXC_CSTsmooth(w,mu) = cors;
                        MUdata.w1.MUsXC_CSTsmooth_lag(w,mu) = lag;
                end
            end
        end
    end
    
    MUdata.w1.MUsXC_CSTraw(MUdata.w1.MUsXC_CSTraw == 0) = NaN;
    MUdata.w1.MUsXC_CSTraw_lag(MUdata.w1.MUsXC_CSTraw == 0) = NaN;
    MUdata.w1.MUsXC_CSTsmooth(MUdata.w1.MUsXC_CSTsmooth == 0) = NaN;
    MUdata.w1.MUsXC_CSTsmooth_lag(MUdata.w1.MUsXC_CSTsmooth == 0) = NaN;

     % 5-s Windows
    for w = 1:6
        if MUdata.w5.bad_wins(w) == 1
        else
            % Subset data
            s = MUdata.w5.starts(w);
            e = MUdata.w5.endds(w);
            MUvec = idrfilts(:,s:e);
            MUvecRaw = rawidrs(:,s:e);
            cstvec = MUdata.w5.cst_secs{w};
            % Cross-correlation
            for mu = 1:size(MUvec,1)
                if nansum(MUvec(mu,:)) == 0
                else
                % Cross correlation between individual MUs and FCC
                [r,lag] = xcorr(MUvecRaw(mu,:),cstvec,200,'normalized'); % cutoff at 200 data poitns from 0 lag
                    [cors,ind] = max(r); lag = lag(ind);
                        MUdata.w5.MUsXC_CSTraw(w,mu) = cors;
                        MUdata.w5.MUsXC_CSTraw_lag(w,mu) = lag;
                [r,lag] = xcorr(MUvec(mu,:),cstvec,200,'normalized');
                    [cors,ind] = max(r); lag = lag(ind);
                        MUdata.w5.MUsXC_CSTsmooth(w,mu) = cors;
                        MUdata.w5.MUsXC_CSTsmooth_lag(w,mu) = lag;
                end
            end
        end
    end
    
        
    MUdata.w5.MUsXC_CSTraw(MUdata.w5.MUsXC_CSTraw == 0) = NaN;
    MUdata.w5.MUsXC_CSTraw_lag(MUdata.w5.MUsXC_CSTraw == 0) = NaN;
    MUdata.w5.MUsXC_CSTsmooth(MUdata.w5.MUsXC_CSTsmooth == 0) = NaN;
    MUdata.w5.MUsXC_CSTsmooth_lag(MUdata.w5.MUsXC_CSTsmooth == 0) = NaN;
    
    
% ------------ MUs - WHOLE TIME ACTIVE ------------------------------------
    % -------- CST --------------------------------------------------------
    % Highpass filtered CST during steady 30
    cst = highpass(MUdata.cst,0.75,2000); 
    % Cross-correlation
    for mu = 1:size(idrfilts,1)
        if nansum(idrfilts(mu,:)) == 0
        else
        % subset for only that section
        temp = idrfilts(mu,:);
        s = find(~isnan(temp),1,'first')+1;
        e = find(~isnan(temp),1,'last')-1;
            MUvec = idrfilts(mu,s:e);
            cstvec = cst(s:e);
        temp = rawidrs(mu,:);
        s = find(~isnan(temp),1,'first')+1;
        e = find(~isnan(temp),1,'last')-1;
            MUvecRaw = rawidrs(mu,s:e);
            cstvecRaw = cst(s:e);
        % Cross correlation between individual MUs and CST
        [r,lag] = xcorr(MUvecRaw,cstvecRaw,200,'normalized'); % cutoff at 200 data poitns from 0 lag
            [cors,ind] = max(r); lag = lag(ind);
                MUdata.w30.MUsXC_CSTraw(mu) = cors;
                MUdata.w30.MUsXC_CSTraw_lag(mu) = lag;
        [r,lag] = xcorr(MUvec,cstvec,200,'normalized');
            [cors,ind] = max(r); lag = lag(ind);
                MUdata.w30.MUsXC_CSTsmooth(mu) = cors;
                MUdata.w30.MUsXC_CSTsmooth_lag(mu) = lag;
        end
    end
    
    
    MUdata.w30.MUsXC_CSTraw(MUdata.w30.MUsXC_CSTraw == 0) = NaN;
    MUdata.w30.MUsXC_CSTraw_lag(MUdata.w30.MUsXC_CSTraw == 0) = NaN;
    MUdata.w30.MUsXC_CSTsmooth(MUdata.w30.MUsXC_CSTsmooth == 0) = NaN;
    MUdata.w30.MUsXC_CSTsmooth_lag(MUdata.w30.MUsXC_CSTsmooth == 0) = NaN;
    
%     % -------- FPC --------------------------------------------------------
%     % Add NaNs to start of 30s FPC - Use FPC form highest # of MUs
%     fcc_raw = horzcat(repelem(NaN,MUdata.w1.starts(1)-1),...
%         MUdata.PCA.iter.w30.coeffs{end}(1,:));
%     fcc_smooth = horzcat(repelem(NaN,MUdata.w1.starts(1)-1),...
%         MUdata.PCA.iter.raw.w30.coeffs{end}(1,:));
%     % Cross-correlation
%     for mu = 1:size(idrfilts,1)
%         if nansum(idrfilts(mu,:)) == 0
%         else
%         % subset for only that section
%         temp = idrfilts(mu,:);
%         s = find(~isnan(temp),1,'first')+1;
%         e = find(~isnan(temp),1,'last')-1;
%         if e > length(fcc_smooth)
%             e = length(fcc_smooth);
%         end
%             MUvec = idrfilts(mu,s:e);
%             fccvec = fcc_smooth(s:e);
%         temp = rawidrs(mu,:);
%         s = find(~isnan(temp),1,'first')+1;
%         e = find(~isnan(temp),1,'last')-1;
%         if e > length(fcc_raw)
%             e = length(fcc_raw);
%         end
%             MUvecRaw = rawidrs(mu,s:e);
%             fccvecRaw = fcc_raw(s:e);
%         % Cross correlation between individual MUs and CST
%         [r,lag] = xcorr(MUvecRaw,fccvecRaw,200,'normalized'); % cutoff at 200 data poitns from 0 lag
%             [cors,ind] = max(r); lag = lag(ind);
%                 MUdata.w30.MUsXC_FPCraw(mu) = cors;
%                 MUdata.w30.MUsXC_FPCraw_lag(mu) = lag;
%         [r,lag] = xcorr(MUvec,fccvec,200,'normalized');
%             [cors,ind] = max(r); lag = lag(ind);
%                 MUdata.w30.MUsXC_FPCsmooth(mu) = cors;
%                 MUdata.w30.MUsXC_FPCsmooth_lag(mu) = lag;
%         end
%     end
%     
%     
%     MUdata.w30.MUsXC_FPCraw(MUdata.w30.MUsXC_FPCraw == 0) = NaN;
%     MUdata.w30.MUsXC_FPCraw_lag(MUdata.w30.MUsXC_FPCraw == 0) = NaN;
%     MUdata.w30.MUsXC_FPCsmooth(MUdata.w30.MUsXC_FPCsmooth == 0) = NaN;
%     MUdata.w30.MUsXC_FPCsmooth_lag(MUdata.w30.MUsXC_FPCsmooth == 0) = NaN;

    
end