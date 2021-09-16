% 1 second windows - Individual Motor Units - PCA plots - Comparing raw & smoothed FCCs, etc.
day = 'stretch';
level = 'submax35';
time = 'post';
mus = 'MG';
win = 'w1';


%% PCA with raw vs smoothed IDR lines and CST
tiledlayout(6,5)
for w = 1:30
    nexttile
    num = size(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).coeffs_mean{1,w},1);
    yyaxis left
    plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).coeffs_mean{1,w}(num,:),'b-')
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.(win).coeffs_mean{1,w}(num,:),'r')
    yyaxis right
    s = PFdata.(day).(level).MUdata.(time).(win).starts(w);
    e = PFdata.(day).(level).MUdata.(time).(win).endds(w);
    plot(PFdata.(day).(level).MUdata.(time).(mus).cst(s:e),'k-');
end

            
%% IDRs
clear('rawidrs','idrfilts')

 % IDRs
    for mu = 1:length(PFdata.(day).(level).MUdata.(time).(mus).rawlines)
        len = length(PFdata.(day).(level).MUdata.(time).(mus).binary);
        isivec = PFdata.(day).(level).MUdata.(time).(mus).binary_ISI;
        isivec(isivec == 0) = NaN;
        if isempty(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
        elseif isnan(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
        else
            rawidrs(mu,:) = PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu};
            temp = PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu};
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

%% Start and end for windows
clear('MUvec','MUvecRaw','fcc_raw','fcc_smooth','cors_smooth','cors_raw')

for w = 1:30
    
    s = PFdata.(day).(level).MUdata.(time).(win).starts(w);
    e = PFdata.(day).(level).MUdata.(time).(win).endds(w);
    num = size(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).coeffs_mean{1,w},1);

    % Comparisons with individual MUs and grouped
    
    MUvec = idrfilts(:,s:e);
    MUvecRaw = rawidrs(:,s:e);
    fcc_raw = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).coeffs_mean{1,w}(num,:);
    fcc_smooth = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.(win).coeffs_mean{1,w}(num,:);
    for mu = 1:size(MUvec,1)
        if sum(MUvec(mu,:)) == 0
        else
        % Cross correlation between individual MUs and FCC
        [r,lag] = xcorr(MUvecRaw(mu,:),fcc_raw,200,'normalized');
        [cors_raw(w,mu),ind] = max(r); lag_raw(w,mu) = lag(ind);
        [r,lag] = xcorr(MUvec(mu,:),fcc_smooth,200,'normalized');
        [cors_smooth(w,mu),ind] = max(r); lag_smooth(w,mu) = lag(ind);
        end
    end
end

%% Plot xcorrs across contraction
    cors_smooth(cors_smooth == 0) = NaN;
    cors_raw(cors_raw == 0) = NaN;

    
tiledlayout(2,2)
    nexttile(1)
        boxplot(cors_smooth',1:30)
        title('Smooth')
    nexttile(2)
        boxplot(cors_raw',1:30)
        title('Raw')
    nexttile(3)
        histogram(cors_smooth,15)
    nexttile(4)
        histogram(cors_raw,15)
%% Scatter between % explained by FPC and mean cross-correlations between indiv Mus and FPC

for w = 1:30
    lens(w) = length(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).explained_means{w});
end
n = min(lens);

for w = 1:30 % RAW PCA
    raw_exp(w) = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).explained_means{w}(n);
    smoothed_exp(w) = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.(win).explained_means{w}(n);
end

%% 
tiledlayout(2,2)
set(gcf, 'Renderer', 'painters');
nexttile
    scatter(nanmean(cors_raw,2),raw_exp,'r') 
    xlabel('Mean xcorr between smoothed IDRs and FPC')
    ylabel('Mean % explained by FPC')
    title('RAW - Mean XCorr between individual MUs and FPC ~ Mean % explained by FPC')
    legend('1-s windows')
nexttile
    scatter(nanmedian(cors_raw,2),raw_exp,'r') 
    title('RAW - Median XCorr between individual MUs and FPC ~ Mean % explained by FPC')
    xlabel('Median xcorr between raw IDRs and FPC')
    ylabel('Mean % explained by FPC')
    legend('1-s windows')
nexttile
    scatter(nanmean(cors_smooth,2),smoothed_exp,'b') 
    xlabel('Mean xcorr between smoothed IDRs and FPC')
    ylabel('Mean % explained by FPC')
    title('SMOOTH - Mean XCorr between individual MUs and FPC ~ Mean % explained by FPC')
    legend('1-s windows')
nexttile
    scatter(nanmedian(cors_smooth,2),smoothed_exp,'b') 
    title('SMOOTH - Median XCorr between individual MUs and FPC ~ Mean % explained by FPC')
    xlabel('Median xcorr between smoothed IDRs and FPC')
    ylabel('Mean % explained by FPC')
    legend('1-s windows')
    
%% SD for CST or FPC at those windows?
for w = 1:30
    s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
    e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
    cstvec = highpass(PFdata.(day).(level).MUdata.(time).(mus).cst(s:e),0.75,2000);
        cst_std(w) = std(cstvec);
    fpcvec_raw = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).coeffs_mean{w}(n,:);
        fpc_raw_std(w) = std(fpcvec_raw);
    fpcvec_smooth = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.(win).coeffs_mean{w}(n,:);
        fpc_smooth_std(w) = std(fpcvec_smooth);
end

%% REGRESSIONS 1 - RAW IDR DATA

t = tiledlayout(2,3);
title(t,'RAW IDRs')
set(gcf, 'Renderer', 'painters');
nexttile(1)
    scatter(nanmedian(cors_raw,2),cst_std,'r','filled') 
    xlabel('Median xcorr between smoothed IDRs and FPC')
    ylabel('SD for HPF CST')
    title('Median XCorr between individual MUs and FPC ~ SD for CST at that window')
    legend('1-s windows')
nexttile(4)
    scatter(nanmedian(cors_raw,2),fpc_raw_std,'r','filled') 
    title('Median XCorr between individual MUs and FPC ~ SD for FPC')
    xlabel('Median xcorr between smoothed IDRs and FPC')
    ylabel('SD for FPC')
    legend('1-s windows')
nexttile(2)
    scatter(nanmean(cors_raw,2),cst_std,'b','filled') 
    xlabel('Mean xcorr between smoothed IDRs and FPC')
    ylabel('SD for HPF CST')
    title('Mean XCorr between individual MUs and FPC ~ SD for CST at that window')
    legend('1-s windows')
nexttile(5)
    scatter(nanmean(cors_raw,2),fpc_raw_std,'b','filled') 
    title('Mean XCorr between individual MUs and FPC ~ SD for FPC')
    xlabel('Mean xcorr between smoothed IDRs and FPC')
    ylabel('SD for FPC')
    legend('1-s windows')
nexttile(3)
    scatter(raw_exp,cst_std,'g','filled') 
    xlabel('Mean % explained by FPC')
    ylabel('SD for HPF CST')
    title('Mean % Explained by FPC ~ SD for CST at that window')
    legend('1-s windows')
nexttile(6)
    scatter(raw_exp,fpc_raw_std,'g','filled') 
    title('Mean % Explained by FPC ~ SD for FPC')
    ylabel('SD for FPC')
    xlabel('Mean % explained by FPC')
    legend('1-s windows')  
    
    
%% REGRESSIONS 1 - SMOOTH IDR DATA

t = tiledlayout(2,3);
title(t,'SMOOTHED IDRs')
set(gcf, 'Renderer', 'painters');
nexttile(1)
    scatter(nanmedian(cors_smooth,2),cst_std,'r','filled') 
    xlabel('Median xcorr between smoothed IDRs and FPC')
    ylabel('SD for HPF CST')
    title('Median XCorr between individual MUs and FPC ~ SD for CST at that window')
    legend('1-s windows')
nexttile(4)
    scatter(nanmedian(cors_smooth,2),fpc_smooth_std,'r','filled') 
    title('Median XCorr between individual MUs and FPC ~ SD for FPC')
    xlabel('Median xcorr between smoothed IDRs and FPC')
    ylabel('SD for FPC')
    legend('1-s windows')
nexttile(2)
    scatter(nanmean(cors_smooth,2),cst_std,'b','filled') 
    xlabel('Mean xcorr between smoothed IDRs and FPC')
    ylabel('SD for HPF CST')
    title('Mean XCorr between individual MUs and FPC ~ SD for CST at that window')
    legend('1-s windows')
nexttile(5)
    scatter(nanmean(cors_smooth,2),fpc_smooth_std,'b','filled') 
    title('Mean XCorr between individual MUs and FPC ~ SD for FPC')
    xlabel('Mean xcorr between smoothed IDRs and FPC')
    ylabel('SD for FPC')
    legend('1-s windows')
nexttile(3)
    scatter(smoothed_exp,cst_std,'g','filled') 
    xlabel('Mean % explained by FPC')
    ylabel('SD for HPF CST')
    title('Mean % Explained by FPC ~ SD for CST at that window')
    legend('1-s windows')
nexttile(6)
    scatter(smoothed_exp,fpc_smooth_std,'g','filled') 
    title('Mean % Explained by FPC ~ SD for FPC')
    ylabel('SD for FPC')
    xlabel('Mean % explained by FPC')
    legend('1-s windows')  
        
    
    
%% SMOOTHED - xcorr / regressions
[r,lag] = xcorr(nanmedian(cors_smooth,2),cst_std,200,'normalized');
[xcors.smooth.musmn_cst,ind] = max(r); lags.smooth.musmn_cst = lag(ind);
    model = fitlm(nanmedian(cors_smooth,2),cst_std);

[r,lag] = xcorr(nanmedian(cors_smooth,2),fpc_smooth_std,200,'normalized');
[xcors.smooth.musmn_fpc,ind] = max(r); lags.smooth.musmn_fpc = lag(ind);
    model = fitlm(nanmedian(cors_smooth,2),fpc_smooth_std);

[r,lag] = xcorr(nanmean(cors_smooth,2),cst_std,200,'normalized');
[xcors.smooth.musmed_cst,ind] = max(r); lags.smooth.musmed_cst = lag(ind);
    model = fitlm(nanmean(cors_smooth,2),cst_std);

[r,lag] = xcorr(nanmean(cors_smooth,2),fpc_smooth_std,200,'normalized') ;
[xcors.smooth.musmed_fpc,ind] = max(r); lags.smooth.musmed_fpc = lag(ind);
    model = fitlm(nanmean(cors_smooth,2),fpc_smooth_std);

[r,lag] = xcorr(smoothed_exp,cst_std,200,'normalized');
[xcors.smooth.expl_cst,ind] = max(r); lags.smooth.expl_cst = lag(ind);
    model = fitlm(smoothed_exp,cst_std);

[r,lag] = xcorr(smoothed_exp,fpc_smooth_std,200,'normalized');
[xcors.smooth.expl_fpc,ind] = max(r); lags.smooth.expl_fpc = lag(ind);
    model = fitlm(smoothed_exp,fpc_smooth_std);
 
%% RAW   xcorrs / regressions
[r,lag] = xcorr(nanmedian(cors_raw,2),cst_std,200,'normalized');
[xcors.raw.musmn_cst,ind] = max(r); lags.raw.musmn_cst = lag(ind);
    model = fitlm(nanmedian(cors_raw,2),cst_std);

[r,lag] = xcorr(nanmedian(cors_raw,2),fpc_raw_std,200,'normalized');
[xcors.raw.musmn_fpc,ind] = max(r); lags.raw.musmn_fpc = lag(ind);
    model = fitlm(nanmedian(cors_raw,2),fpc_raw_std);

[r,lag] = xcorr(nanmean(cors_raw,2),cst_std,200,'normalized');
[xcors.raw.musmed_cst,ind] = max(r); lags.raw.musmed_cst = lag(ind);
    model = fitlm(nanmean(cors_raw,2),cst_std);

[r,lag] = xcorr(nanmean(cors_raw,2),fpc_raw_std,200,'normalized') ;
[xcors.raw.musmed_fpc,ind] = max(r); lags.raw.musmed_fpc = lag(ind);
    model = fitlm(nanmean(cors_raw,2),fpc_raw_std);

[r,lag] = xcorr(raw_exp,cst_std,200,'normalized');
[xcors.raw.expl_cst,ind] = max(r); lags.raw.expl_cst = lag(ind);
    model = fitlm(raw_exp,cst_std);

[r,lag] = xcorr(raw_exp,fpc_raw_std,200,'normalized');
[xcors.raw.expl_fpc,ind] = max(r); lags.raw.expl_fpc = lag(ind);
    model = fitlm(raw_exp,fpc_raw_std);
    
    
%% Zoom in on certain windows
        % Raw FPC vs smoothed FPC vs CST
            tiledlayout(6,5)
            for w = 1:30
                nexttile
                yyaxis left
                    num = size(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).coeffs_mean{1,w},1);
                    plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.(win).coeffs_mean{1,w}(num,:),'-b','linewidth',2)
                    hold on;
                    plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).coeffs_mean{1,w}(num,:),'-r','linewidth',2)
                    title(string(w))
                yyaxis right
                    s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
                    e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
                    cstvec = highpass(PFdata.(day).(level).MUdata.(time).(mus).cst(s:e),0.75,2000);
                    plot(cstvec,'-k','linewidth',2);
            end
            set(gcf, 'Renderer', 'painters');
            
%% Covariance between almost all measures

plot(normalize(raw_exp),'y');  %raw
hold on;
plot(normalize(smoothed_exp),'b');  %smoothed
plot(normalize(cst_std),'c');
plot(normalize(fpc_raw_std),'g'); % raw
plot(normalize(fpc_smooth_std),'m'); % smoothed
plot(normalize(nanmedian(cors_smooth,2)),'k');
plot(normalize(nanmedian(cors_raw,2)),'r');
legend('raw % exp','smooth % exp','sd for cst','sd for raw fpc','sd for smoothed fpc','median smooth xcors','median raw xcors');
set(gcf, 'Renderer', 'painters');


%% ISI regressions - Comparing the above estimates and sd for ISI 
% * * * Use CovariancePlots2.mat to generate data * * *

tiledlayout('flow')
nexttile
    scatter(nanmedian(isi_sd,1),nanmedian(cors_raw,2),'filled','r')
    xlabel('Median SD for ISIs')
    ylabel('Median Xcorr between RAW IDRs and FPC')
nexttile
    scatter(nanmedian(isi_sd,1),nanmedian(cors_smooth,2),'filled')
    xlabel('Median SD for ISIs')
    ylabel('Median Xcorr between SMOOTH IDRs and FPC')
nexttile
    scatter(nanmedian(isi_sd,1),normalize(fpc_raw_std),'filled','r')
    xlabel('Median SD for ISIs')
    ylabel('SD for RAW FPC')
    ylim([-0.7 0.45])
nexttile
    scatter(nanmedian(isi_sd,1),normalize(fpc_smooth_std),'filled')
    xlabel('Median SD for ISIs')
    ylabel('SD for SMOOTH FPC')
    ylim([-0.7 0.45])
nexttile
    scatter(nanmedian(isi_sd,1),cst_std,'filled')
    xlabel('MedianSD for ISIs')
    ylabel('SD for CST')
nexttile
    scatter(raw_exp,nanmedian(isi_sd,1),'filled','r')
    ylabel('MedianSD for ISIs')
    xlabel('% Explained by RAW IDRs')
nexttile
    scatter(smoothed_exp,nanmedian(isi_sd,1),'filled')
    ylabel('MedianSD for ISIs')
    xlabel('% Explained by sMOOTH IDRs')
set(gcf, 'Renderer', 'painters');