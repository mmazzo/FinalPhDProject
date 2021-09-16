% SD of FCC, CST, force and individual IDR lines
day = 'stretch';
level = 'submax10';
time = 'pre';
mus = 'MG';
win = 'w1';


%% SD of FCC, CST, force and individual IDR lines
fcc = [];
% SFU15 stretch 10% post - Flip window #17
    PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w1.coeff_mean{17} = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w1.coeff_mean{17}*-1;
% fcc
    for w = 1:30
        fcc_sd(w) = std(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w1.coeff_mean{w});
        fcc_mean(w) = mean(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w1.coeff_mean{w});
        fcc_cv(w) = (fcc_sd(w)/fcc_mean(w))*100;
        fcc = horzcat(fcc,PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w1.coeff_mean{w});
    end
% cst
    ss = PFdata.(day).(level).MUdata.(time).(mus).steady30.start;
    se = PFdata.(day).(level).MUdata.(time).(mus).steady30.endd;
    cstS = highpass(PFdata.(day).(level).MUdata.(time).(mus).cst(ss:se),0.75,2000);
    cst = highpass(PFdata.(day).(level).MUdata.(time).(mus).cst,0.75,2000);
    for w = 1:30
        s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
        e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
        cst_sd(w) = std(cst(s:e));
        cst_mean(w) = mean(cst(s:e));
        cst_cv(w) = (cst_sd(w)/cst_mean(w))*100;
    end
    
% force - high pass filtered!
hpf_f = highpass(PFdata.(day).(level).force.(time).filt{1,1},0.75,2000);
    for w = 1:30
        s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
        e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
        f_sd(w) = std(hpf_f(s:e));
        f_mean(w) = mean(hpf_f(s:e));
        f_cv(w) = (f_sd(w)/f_mean(w))*100;
    end
    
% IDRs & ISIs
for mu = 1:length(PFdata.(day).(level).MUdata.(time).(mus).rawlines)
    len = length(PFdata.(day).(level).MUdata.(time).(mus).binary);
    isivec = PFdata.(day).(level).MUdata.(time).(mus).binary_ISI;
    isivec(isivec == 0) = NaN;
    if isempty(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
    elseif isnan(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
    else
        temp = PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu};
        start = find(~isnan(temp),1,'first');
        endd = find(~isnan(temp),1,'last');
        temp = temp(start:endd);
        tempR = highpass(temp,0.75,2000);
        temp = conv(temp,hann(800),'same');
        temp = highpass(temp,0.75,2000);
        nans1 = repelem(NaN,start-1);
        nans2 = repelem(NaN,(len-endd));
        idrfilts(mu,:) = horzcat(nans1,temp,nans2);
        idrsRaw(mu,:) = horzcat(nans1,tempR,nans2);
        for w = 1:30
            s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
            e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
            idr_smooth_sd(mu,w) = nanstd(idrfilts(mu,s:e));
            idr_raw_sd(mu,w) = nanstd(idrsRaw(mu,s:e));
            temp3 = isivec(mu,s:e);
            isi_sd(mu,w) = nanstd(temp3);
        end
    end
end
idr_smooth_sd(idr_smooth_sd == 0) = NaN;
idr_raw_sd(idr_raw_sd == 0) = NaN;
isi_sd(isi_sd == 0) = NaN;

% Heatmap of cross-covariance values for SD of each window
t = xcov(f_sd,fcc_sd,'normalized');
    xcovs(1,2) = t(30);
t = xcov(f_sd,cst_sd,'normalized');
    xcovs(1,3) = t(30);
t = xcov(f_sd,nanmean(idr_smooth_sd),'normalized');
    xcovs(1,4) = t(30);
t = xcov(f_sd,nanmean(isi_sd),'normalized');
    xcovs(1,5) = t(30);
t = xcov(f_sd,nanmean(idr_raw_sd),'normalized');
    xcovs(1,6) = t(30);
t = xcov(f_sd,f_sd,'normalized');
    xcovs(1,1) = t(30);

t = xcov(fcc_sd,fcc_sd,'normalized');
    xcovs(2,2) = t(30);
t = xcov(fcc_sd,cst_sd,'normalized');
    xcovs(2,3) = t(30);
t = xcov(fcc_sd,nanmean(idr_smooth_sd),'normalized');
    xcovs(2,4) = t(30);
t = xcov(fcc_sd,nanmean(isi_sd),'normalized');
    xcovs(2,5) = t(30);
t = xcov(fcc_sd,nanmean(idr_raw_sd),'normalized');
    xcovs(2,6) = t(30);
t = xcov(fcc_sd,f_sd,'normalized');
    xcovs(2,1) = t(30);

t = xcov(cst_sd,fcc_sd,'normalized');
    xcovs(3,2) = t(30);
t = xcov(cst_sd,cst_sd,'normalized');
    xcovs(3,3) = t(30);
t = xcov(cst_sd,nanmean(idr_smooth_sd),'normalized');
    xcovs(3,4) = t(30);
t = xcov(cst_sd,nanmean(isi_sd),'normalized');
    xcovs(3,5) = t(30);
t = xcov(cst_sd,nanmean(idr_raw_sd),'normalized');
    xcovs(3,6) = t(30);
t = xcov(cst_sd,f_sd,'normalized');
    xcovs(3,1) = t(30);

t = xcov(nanmean(idr_smooth_sd),fcc_sd,'normalized');
    xcovs(4,2) = t(30);
t = xcov(nanmean(idr_smooth_sd),cst_sd,'normalized');
    xcovs(4,3) = t(30);
t = xcov(nanmean(idr_smooth_sd),nanmean(idr_smooth_sd),'normalized');
    xcovs(4,4) = t(30);
t = xcov(nanmean(idr_smooth_sd),nanmean(isi_sd),'normalized');
    xcovs(4,5) = t(30);
t = xcov(nanmean(idr_smooth_sd),nanmean(idr_raw_sd),'normalized');
    xcovs(4,6) = t(30);
t = xcov(nanmean(idr_smooth_sd),f_sd,'normalized');
    xcovs(4,1) = t(30);

t = xcov(nanmean(isi_sd),fcc_sd,'normalized');
    xcovs(5,2) = t(30);
t = xcov(nanmean(isi_sd),cst_sd,'normalized');
    xcovs(5,3) = t(30);
t = xcov(nanmean(isi_sd),nanmean(idr_smooth_sd),'normalized');
    xcovs(5,4) = t(30);
t = xcov(nanmean(isi_sd),nanmean(isi_sd),'normalized');
    xcovs(5,5) = t(30);
t = xcov(nanmean(isi_sd),nanmean(idr_raw_sd),'normalized');
    xcovs(5,6) = t(30);
t = xcov(nanmean(isi_sd),f_sd,'normalized');
    xcovs(5,1) = t(30);
    
t = xcov(nanmean(idr_raw_sd),fcc_sd,'normalized');
    xcovs(6,2) = t(30);
t = xcov(nanmean(idr_raw_sd),cst_sd,'normalized');
    xcovs(6,3) = t(30);
t = xcov(nanmean(idr_raw_sd),nanmean(idr_smooth_sd),'normalized');
    xcovs(6,4) = t(30);
t = xcov(nanmean(idr_raw_sd),nanmean(isi_sd),'normalized');
    xcovs(6,5) = t(30);
t = xcov(nanmean(idr_raw_sd),nanmean(idr_raw_sd),'normalized');
    xcovs(6,6) = t(30);
t = xcov(nanmean(idr_smooth_sd),f_sd,'normalized');
    xcovs(6,1) = t(30);

%% Visualize all 1-s windows
figure(1)
tiledlayout(3,1)
nexttile
    plot(fcc,'r')
    xlim([0 60000])
    title('Merged 1-s windows of FCC')
nexttile
    plot(cstS,'b')
    xlim([0 60000])
    title('Continuous CST')
nexttile
    yyaxis left
    plot(fcc_sd,'r');
    yyaxis right
    plot(cst_sd,'b');
    hold on;
    xlim([1 30])
    title('SD for FCC and CST')

figure(2)
tiledlayout(4,1)
nexttile
    cm = jet(size(idrfilts,1));
    for p = 1:size(idrfilts,1)
        plot(idrfilts(p,ss:se),'color',cm(p,:))
        hold on;
    end
    xlim([0 60000])
    title('Individual smoothed, high-pass filtered IDR Lines')
nexttile
    for p = 1:size(idr_smooth_sd,1)
        yyaxis left
        plot(normalize(idr_smooth_sd(p,:)),'-c')
        hold on;
        yyaxis right
        plot(normalize(isi_sd(p,:)),'-g')
        xlim([1 30])
    end
    title('Green = ISIs / Cyan = Smoothed IDR lines')
nexttile
    plot(hpf_f(ss:se))
nexttile
    plot(f_sd,'k')
    xlim([1 30])
    
figure(3)
    plot(normalize(fcc_sd),'-r');
    hold on;
    plot(normalize(cst_sd),'-b');
    plot(normalize(nanmedian(idr_smooth_sd)),'-c');
    plot(normalize(nanmedian(isi_sd)),'-g');
    plot(normalize(f_sd),'-k')
    xlim([1 30])
    legend('SD FCC','SD CST','Median SD for Smoothed IDRs','Median SD for ISIs','SD Force');
    
figure(4)
    imagesc(xcovs)
    colormap(jet)
    
%%
yyaxis left
boxplot(idr_smooth_sd,'colors','c','Symbol','o');
hold on;
yyaxis right
boxplot(isi_sd,'colors','g','Symbol','o')
ylim([0 80])
title('Green = ISIs / Cyan = Smoothed IDR lines')

%% regressions
tiledlayout('flow')
nexttile
    scatter(f_sd,cst_sd)
    xlabel('SD for Force')
    ylabel('SD for CST')
nexttile
    scatter(f_sd,fcc_sd)
    xlabel('SD for Force')
    ylabel('SD for FPC')
nexttile
    scatter(cst_sd,fcc_sd)
    xlabel('SD for CST')
    ylabel('SD for FPC')
nexttile
    scatter(nanmedian(isi_sd),nanmedian(idr_smooth_sd),'r')
    xlabel('Median SD for ISI')
    ylabel('Median SD for Smoothed IDRs')
nexttile
    scatter(nanmedian(idr_raw_sd),nanmedian(idr_smooth_sd),'r')
    xlabel('Median SD for Raw IDRs')
    ylabel('Median SD for Smoothed IDRs')
nexttile
    scatter(nanmedian(isi_sd),nanmedian(idr_raw_sd))
    xlabel('Median SD for ISI')
    ylabel('Median SD for Raw IDRs')


