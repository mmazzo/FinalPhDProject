function [MUdata] = MUsXC(MUdata,muscles)
% MUdata = PFdata.(day).(level).MUdata.(time)
% Calculate cross-correlation between individual MUs and the FPCs/CST
warning('off','all')
% --------- Individual Muscles ----------------------------------------
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

% ---------- FPC created using WINDOWS -------------------------------------
if sum(contains(fields(MUdata.(mus).w1),'bad_wins')) > 0
    % 1-s Windows
    for w = 1:30
        if MUdata.(mus).w1.bad_wins(w) == 1
        else
            if isempty(MUdata.(mus).PCA.iter.raw.w1.coeffs_mean{w})
                MUdata.(mus).w1.bad_wins(w) = 1;
            elseif isempty(MUdata.(mus).PCA.iter.w1.coeffs_mean{w})
                MUdata.(mus).w1.bad_wins(w) = 1;
            else
                % Subset data
                s = MUdata.w1.starts(w);
                e = MUdata.w1.endds(w);
                MUvec = idrfilts(:,s:e);
                MUvecRaw = rawidrs(:,s:e);
                fcc_raw = MUdata.(mus).PCA.iter.raw.w1.coeffs_mean{w}(end,:); % Use FPC from highest # of MUs
                fcc_smooth = MUdata.(mus).PCA.iter.w1.coeffs_mean{w}(end,:);

                % Cross-correlation
                for mu = 1:size(MUvec,1)
                    if sum(MUvec(mu,:)) == 0
                    else
                    % Cross correlation between individual MUs and FCC
                    [r,lag] = xcorr(MUvecRaw(mu,:),fcc_raw,200,'normalized'); % cutoff at 200 data poitns from 0 lag
                        [cors,ind] = max(r); lag = lag(ind);
                            MUdata.(mus).PCA.iter.w1.MUsXCraw(w,mu) = cors;
                            MUdata.(mus).PCA.iter.w1.MUsXCraw_lag(w,mu) = lag;
                    [r,lag] = xcorr(MUvec(mu,:),fcc_smooth,200,'normalized');
                        [cors,ind] = max(r); lag = lag(ind);
                            MUdata.(mus).PCA.iter.w1.MUsXCsmooth(w,mu) = cors;
                            MUdata.(mus).PCA.iter.w1.MUsXCsmooth_lag(w,mu) = lag;
                     end
                end
            end
        end
    end
    
    MUdata.(mus).PCA.iter.w1.MUsXCraw(MUdata.(mus).PCA.iter.w1.MUsXCraw == 0) = NaN;
    MUdata.(mus).PCA.iter.w1.MUsXCraw_lag(MUdata.(mus).PCA.iter.w1.MUsXCraw == 0) = NaN;
    MUdata.(mus).PCA.iter.w1.MUsXCsmooth(MUdata.(mus).PCA.iter.w1.MUsXCsmooth == 0) = NaN;
    MUdata.(mus).PCA.iter.w1.MUsXCsmooth_lag(MUdata.(mus).PCA.iter.w1.MUsXCsmooth == 0) = NaN;
else
end
     % 5-s Windows
if sum(contains(fields(MUdata.(mus).w5),'bad_wins')) > 0
    for w = 1:6
        if MUdata.(mus).w5.bad_wins(w) == 1
        else
            if isempty(MUdata.(mus).PCA.iter.raw.w5.coeffs_mean{w})
                MUdata.(mus).w5.bad_wins(w) = 1;
            elseif isempty(MUdata.(mus).PCA.iter.w5.coeffs_mean{w})
                MUdata.(mus).w5.bad_wins(w) = 1;
            else
                % Subset data
                s = MUdata.w5.starts(w);
                e = MUdata.w5.endds(w);
                MUvec = idrfilts(:,s:e);
                MUvecRaw = rawidrs(:,s:e);
                fcc_raw = MUdata.(mus).PCA.iter.raw.w5.coeffs_mean{w}(end,:); % Use FPC form highest # of MUs
                fcc_smooth = MUdata.(mus).PCA.iter.w5.coeffs_mean{w}(end,:);

                % Cross-correlation
                for mu = 1:size(MUvec,1)
                    if nansum(MUvec(mu,:)) == 0
                    else
                    % Cross correlation between individual MUs and FCC
                    [r,lag] = xcorr(MUvecRaw(mu,:),fcc_raw,200,'normalized'); % cutoff at 200 data poitns from 0 lag
                        [cors,ind] = max(r); lag = lag(ind);
                        
                            MUdata.(mus).PCA.iter.w5.MUsXCraw(w,mu) = cors;
                            MUdata.(mus).PCA.iter.w5.MUsXCraw_lag(w,mu) = lag;
                    [r,lag] = xcorr(MUvec(mu,:),fcc_smooth,200,'normalized');
                        [cors,ind] = max(r); lag = lag(ind);
                        
                            MUdata.(mus).PCA.iter.w5.MUsXCsmooth(w,mu) = cors;
                            MUdata.(mus).PCA.iter.w5.MUsXCsmooth_lag(w,mu) = lag;
                     end
                end
            end
        end
    end

    MUdata.(mus).PCA.iter.w5.MUsXCraw(MUdata.(mus).PCA.iter.w5.MUsXCraw == 0) = NaN;
    MUdata.(mus).PCA.iter.w5.MUsXCraw_lag(MUdata.(mus).PCA.iter.w5.MUsXCraw == 0) = NaN;
    MUdata.(mus).PCA.iter.w5.MUsXCsmooth(MUdata.(mus).PCA.iter.w5.MUsXCsmooth == 0) = NaN;
    MUdata.(mus).PCA.iter.w5.MUsXCsmooth_lag(MUdata.(mus).PCA.iter.w5.MUsXCsmooth == 0) = NaN;
else
end

% ------------ 30-s CONTINUOUS FPC -------------------------------------
%     % 1-s Windows
%     for w = 1:30
%         if MUdata.(mus).w1.bad_wins(w) == 1
%         else
%             % Subset data
%             s = MUdata.w1.starts(w);
%             e = MUdata.w1.endds(w);
%             MUvec = idrfilts(:,s:e);
%             MUvecRaw = rawidrs(:,s:e);
%             fcc_raw = MUdata.(mus).PCA.iter.raw.w30.w1.fpc_secs{w}; % Use FPC form highest # of MUs
%             fcc_smooth = MUdata.(mus).PCA.iter.w30.w1.fpc_secs{w};
% 
%             % Cross-correlation
%             for mu = 1:size(MUvec,1)
%                 if nansum(MUvec(mu,:)) == 0
%                 else
%                 % Cross correlation between individual MUs and FCC
%                 [r,lag] = xcorr(MUvecRaw(mu,:),fcc_raw,200,'normalized'); % cutoff at 200 data poitns from 0 lag
%                     [cors,ind] = max(r); lag = lag(ind);
%                     
%                         MUdata.(mus).PCA.iter.w30.w1.MUsXCraw(w,mu) = cors;
%                         MUdata.(mus).PCA.iter.w30.w1.MUsXCraw_lag(w,mu) = lag;
%                 [r,lag] = xcorr(MUvec(mu,:),fcc_smooth,200,'normalized');
%                     [cors,ind] = max(r); lag = lag(ind);
%                     
%                         MUdata.(mus).PCA.iter.w30.w1.MUsXCsmooth(w,mu) = cors;
%                         MUdata.(mus).PCA.iter.w30.w1.MUsXCsmooth_lag(w,mu) = lag;
%                 end
%             end
%         end
%     end
%     
%     MUdata.(mus).PCA.iter.w30.w1.MUsXCraw(MUdata.(mus).PCA.iter.w30.w1.MUsXCraw == 0) = NaN;
%     MUdata.(mus).PCA.iter.w30.w1.MUsXCraw_lag(MUdata.(mus).PCA.iter.w30.w1.MUsXCraw == 0) = NaN;
%     MUdata.(mus).PCA.iter.w30.w1.MUsXCsmooth(MUdata.(mus).PCA.iter.w30.w1.MUsXCsmooth == 0) = NaN;
%     MUdata.(mus).PCA.iter.w30.w1.MUsXCsmooth_lag(MUdata.(mus).PCA.iter.w30.w1.MUsXCsmooth == 0) = NaN;
% 
%      % 5-s Windows
%     for w = 1:6
%         if MUdata.(mus).w5.bad_wins(w) == 1
%         else
%             % Subset data
%             s = MUdata.w5.starts(w);
%             e = MUdata.w5.endds(w);
%             MUvec = idrfilts(:,s:e);
%             MUvecRaw = rawidrs(:,s:e);
%             fcc_raw = MUdata.(mus).PCA.iter.raw.w30.w5.fpc_secs{w}; % Use FPC form highest # of MUs
%             fcc_smooth = MUdata.(mus).PCA.iter.w30.w5.fpc_secs{w};
% 
%             % Cross-correlation
%             for mu = 1:size(MUvec,1)
%                 if nansum(MUvec(mu,:)) == 0
%                 else
%                 % Cross correlation between individual MUs and FCC
%                 [r,lag] = xcorr(MUvecRaw(mu,:),fcc_raw,200,'normalized'); % cutoff at 200 data poitns from 0 lag
%                     [cors,ind] = max(r); lag = lag(ind);
%                     
%                         MUdata.(mus).PCA.iter.w30.w5.MUsXCraw(w,mu) = cors;
%                         MUdata.(mus).PCA.iter.w30.w5.MUsXCraw_lag(w,mu) = lag;
%                 [r,lag] = xcorr(MUvec(mu,:),fcc_smooth,200,'normalized');
%                     [cors,ind] = max(r); lag = lag(ind);
%                     
%                         MUdata.(mus).PCA.iter.w30.w5.MUsXCsmooth(w,mu) = cors;
%                         MUdata.(mus).PCA.iter.w30.w5.MUsXCsmooth_lag(w,mu) = lag;
%                 end
%             end
%         end
%     end
%     
%         
%     MUdata.(mus).PCA.iter.w30.w5.MUsXCraw(MUdata.(mus).PCA.iter.w30.w5.MUsXCraw == 0) = NaN;
%     MUdata.(mus).PCA.iter.w30.w5.MUsXCraw_lag(MUdata.(mus).PCA.iter.w30.w5.MUsXCraw == 0) = NaN;
%     MUdata.(mus).PCA.iter.w30.w5.MUsXCsmooth(MUdata.(mus).PCA.iter.w30.w5.MUsXCsmooth == 0) = NaN;
%     MUdata.(mus).PCA.iter.w30.w5.MUsXCsmooth_lag(MUdata.(mus).PCA.iter.w30.w5.MUsXCsmooth == 0) = NaN;
%   
%     
    % ------------ CST -------------------------------------
    if length(MUdata.(mus).cst) == 1
    elseif isnan(MUdata.(mus).cst)
    else
        % Highpass filtered CST during steady 30
        cst = highpass(MUdata.(mus).cst,0.75,2000); 

        % 1-s Windows
        if sum(contains(fields(MUdata.(mus).w1),'bad_wins')) > 0
        for w = 1:30
            if MUdata.(mus).w1.bad_wins(w) == 1
            else
                % Subset data
                s = MUdata.w1.starts(w);
                e = MUdata.w1.endds(w);
                MUvec = idrfilts(:,s:e);
                MUvecRaw = rawidrs(:,s:e);
                cstvec = MUdata.(mus).w1.cst_secs{w};
                % Cross-correlation
                for mu = 1:size(MUvec,1)
                    if nansum(MUvec(mu,:)) == 0
                    else
                    % Cross correlation between individual MUs and CST
                    [r,lag] = xcorr(MUvecRaw(mu,:),cstvec,200,'normalized'); % cutoff at 200 data poitns from 0 lag
                        [cors,ind] = max(r); lag = lag(ind);
                            MUdata.(mus).w1.MUsXC_CSTraw(w,mu) = cors;
                            MUdata.(mus).w1.MUsXC_CSTraw_lag(w,mu) = lag;
                    [r,lag] = xcorr(MUvec(mu,:),cstvec,200,'normalized');
                        [cors,ind] = max(r); lag = lag(ind);
                            MUdata.(mus).w1.MUsXC_CSTsmooth(w,mu) = cors;
                            MUdata.(mus).w1.MUsXC_CSTsmooth_lag(w,mu) = lag;
                    end
                end
            end
        end

        MUdata.(mus).w1.MUsXC_CSTraw(MUdata.(mus).w1.MUsXC_CSTraw == 0) = NaN;
        MUdata.(mus).w1.MUsXC_CSTraw_lag(MUdata.(mus).w1.MUsXC_CSTraw == 0) = NaN;
        MUdata.(mus).w1.MUsXC_CSTsmooth(MUdata.(mus).w1.MUsXC_CSTsmooth == 0) = NaN;
        MUdata.(mus).w1.MUsXC_CSTsmooth_lag(MUdata.(mus).w1.MUsXC_CSTsmooth == 0) = NaN;
        else
        end
        % 5-s Windows
        if sum(contains(fields(MUdata.(mus).w5),'bad_wins')) > 0
         for w = 1:6
            if MUdata.(mus).w5.bad_wins(w) == 1
            else
                % Subset data
                s = MUdata.w5.starts(w);
                e = MUdata.w5.endds(w);
                MUvec = idrfilts(:,s:e);
                MUvecRaw = rawidrs(:,s:e);
                cstvec = MUdata.(mus).w5.cst_secs{w};
                % Cross-correlation
                for mu = 1:size(MUvec,1)
                    if nansum(MUvec(mu,:)) == 0
                    else
                    % Cross correlation between individual MUs and FCC
                    [r,lag] = xcorr(MUvecRaw(mu,:),cstvec,200,'normalized'); % cutoff at 200 data poitns from 0 lag
                        [cors,ind] = max(r); lag = lag(ind);
                            MUdata.(mus).w5.MUsXC_CSTraw(w,mu) = cors;
                            MUdata.(mus).w5.MUsXC_CSTraw_lag(w,mu) = lag;
                    [r,lag] = xcorr(MUvec(mu,:),cstvec,200,'normalized');
                        [cors,ind] = max(r); lag = lag(ind);
                            MUdata.(mus).w5.MUsXC_CSTsmooth(w,mu) = cors;
                            MUdata.(mus).w5.MUsXC_CSTsmooth_lag(w,mu) = lag;
                    end
                end
            end
        end


        MUdata.(mus).w5.MUsXC_CSTraw(MUdata.(mus).w5.MUsXC_CSTraw == 0) = NaN;
        MUdata.(mus).w5.MUsXC_CSTraw_lag(MUdata.(mus).w5.MUsXC_CSTraw == 0) = NaN;
        MUdata.(mus).w5.MUsXC_CSTsmooth(MUdata.(mus).w5.MUsXC_CSTsmooth == 0) = NaN;
        MUdata.(mus).w5.MUsXC_CSTsmooth_lag(MUdata.(mus).w5.MUsXC_CSTsmooth == 0) = NaN;
        else
        end

    % ------------ MUs - WHOLE TIME ACTIVE ------------------------------------
        % -------- CST --------------------------------------------------------
        % Highpass filtered CST during steady 30
        cst = highpass(MUdata.(mus).cst,0.75,2000); 
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
                    MUdata.(mus).w30.MUsXC_CSTraw(mu) = cors;
                    MUdata.(mus).w30.MUsXC_CSTraw_lag(mu) = lag;
            [r,lag] = xcorr(MUvec,cstvec,200,'normalized');
                [cors,ind] = max(r); lag = lag(ind);
                    MUdata.(mus).w30.MUsXC_CSTsmooth(mu) = cors;
                    MUdata.(mus).w30.MUsXC_CSTsmooth_lag(mu) = lag;
            end
        end


        MUdata.(mus).w30.MUsXC_CSTraw(MUdata.(mus).w30.MUsXC_CSTraw == 0) = NaN;
        MUdata.(mus).w30.MUsXC_CSTraw_lag(MUdata.(mus).w30.MUsXC_CSTraw == 0) = NaN;
        MUdata.(mus).w30.MUsXC_CSTsmooth(MUdata.(mus).w30.MUsXC_CSTsmooth == 0) = NaN;
        MUdata.(mus).w30.MUsXC_CSTsmooth_lag(MUdata.(mus).w30.MUsXC_CSTsmooth == 0) = NaN;

    %     % -------- FPC --------------------------------------------------------
    %     % Add NaNs to start of 30s FPC - Use FPC from highest # of MUs
    %     fcc_raw = horzcat(repelem(NaN,MUdata.w1.starts(1)-1),...
    %         MUdata.(mus).PCA.iter.w30.coeffs{end}(1,:));
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
    %                 MUdata.(mus).w30.MUsXC_FPCraw(mu) = cors;
    %                 MUdata.(mus).w30.MUsXC_FPCraw_lag(mu) = lag;
    %         [r,lag] = xcorr(MUvec,fccvec,200,'normalized');
    %             [cors,ind] = max(r); lag = lag(ind);
    %                 MUdata.(mus).w30.MUsXC_FPCsmooth(mu) = cors;
    %                 MUdata.(mus).w30.MUsXC_FPCsmooth_lag(mu) = lag;
    %         end
    %     end
    %     
    %     
    %     MUdata.(mus).w30.MUsXC_FPCraw(MUdata.(mus).w30.MUsXC_FPCraw == 0) = NaN;
    %     MUdata.(mus).w30.MUsXC_FPCraw_lag(MUdata.(mus).w30.MUsXC_FPCraw == 0) = NaN;
    %     MUdata.(mus).w30.MUsXC_FPCsmooth(MUdata.(mus).w30.MUsXC_FPCsmooth == 0) = NaN;
    %     MUdata.(mus).w30.MUsXC_FPCsmooth_lag(MUdata.(mus).w30.MUsXC_FPCsmooth == 0) = NaN;
    end
    
end
end