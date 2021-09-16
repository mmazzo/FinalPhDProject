% After using pCSIfuncIter.m
tiledlayout(1,3)

nexttile
    plot(F,pCSIdata.COH_add,'r')
    xlim([0 25])
    title('Additive')

nexttile
    plot(F,pCSIdata.COH_real,'b')
    xlim([0 25])
    title('Real')

nexttile
    plot(F,pCSIdata.COH_raw,'c')
    xlim([0 25])
    title('Raw')
%% After using pCSIfuncIter.m

tiledlayout(5,6)
for p = 1:30
    nexttile
    if isempty(dat.MG.pCSI.iter.w1.COHT{p})
    else
    plot(dat.MG.pCSI.iter.w1.F,MUdata.MG.pCSI.iter.w1.COHT{p})
    ylim([0 1])
    xlim([0 25])
    title(string(dat.MG.pCSI.iter.w1.pCSI{1,p}(4)))
    end
end
    
%% Explained by FPC?  Raw? Smooth?
for w = 1:30
    if isempty(dat.MG.pCSI.iter.w1.pCSI{1,w})
    else
        pCSI(w) = dat.MG.pCSI.iter.w1.pCSI{1,w}(4);
        expl(w) = dat.MG.PCA.iter.w1.explained_means{w}(10);
        expl_raw(w) = dat.MG.PCA.iter.raw.w1.explained_means{w}(10);
    end
end

%%
scatter(pCSI,expl)

%% Only 0-2 Hz
for w = 1:30
    if isempty(MUdata.MG.pCSI.iter.w1.COHT{1,w})
    else
        temp = MUdata.MG.pCSI.iter.w1.COHT{1,w}(4,:);
        pCSI_2(w) = mean(temp(MUdata.MG.pCSI.iter.w1.F>0.1 & MUdata.MG.pCSI.iter.w1.F<2));
    end
end

scatter(pCSI_2,expl)

%% 0-??? Hz
top = 15;
for w = 1:30
    if isempty(MUdata.MG.pCSI.iter.w1.COHT{1,w})
    else
        temp = MUdata.MG.pCSI.iter.w1.COHT{1,w}(4,:);
        pCSI_range(w) = mean(temp(MUdata.MG.pCSI.iter.w1.F>0.1 & MUdata.MG.pCSI.iter.w1.F<top));
    end
end

scatter(pCSI_range,expl)

%%
sd_dat = dat.MG.PCA.iter.w30.w1.fpc_sd;
scatter(pCSI,sd_dat)

%% diff in pCSI

for w = 1:30
    if isempty(MUdata.MG.pCSI.iter.w1.pCSI{1,w})
    else
        pCSI_diff(w) = MUdata.MG.pCSI.iter.w1.pCSI{1,w}(4) - MUdata.MG.pCSI.iter.w1.pCSI{1,w}(1);
        pCSI_auc(w) = trapz(MUdata.MG.pCSI.iter.w1.pCSI{1,w}(1:4));
    end
end

scatter(pCSI,pCSI_diff)
%% smooth
tiledlayout(2,3)
nexttile
scatter(pCSI(1:end ~=9),expl(1:end ~=9))
    f1 = fitlm(pCSI(1:end ~=9),expl(1:end ~=9)');
    title(string(f1.Rsquared.Ordinary))
    xlim([0 1])
    ylim([0 100])
    xlabel('pCSI at 4 MU Pairs')
    ylabel('% Explained by FPC')
nexttile
scatter(pCSI_diff(1:end ~=9),expl(1:end ~=9)) % least linear relation?
    f2 = fitlm(pCSI_diff(1:end ~=9),expl(1:end ~=9));
    title(string(f2.Rsquared.Ordinary))
    xlim([0 0.5])
    ylim([0 100])
    xlabel('pCSI increase between 1 and 4 MU Pairs')
    ylabel('% Explained by FPC')
nexttile
scatter(pCSI_auc(1:end ~=9),expl(1:end ~=9))
    f3 = fitlm(pCSI_auc(1:end ~=9),expl(1:end ~=9));
    title(string(f3.Rsquared.Ordinary))
    xlim([0 2])
    ylim([0 100])
    xlabel('pCSI AUC')
    ylabel('% Explained by FPC')
% Raw
nexttile
scatter(pCSI(1:end ~=9),expl_raw(1:end ~=9))
    f4 = fitlm(pCSI(1:end ~=9),expl_raw(1:end ~=9));
    title(string(f4.Rsquared.Ordinary))
    xlim([0 1])
    ylim([0 100])
    xlabel('pCSI at 4 MU Pairs')
    ylabel('% Explained by RAW FPC')
nexttile
scatter(pCSI_diff(1:end ~=9),expl_raw(1:end ~=9)) % least linear relation?
    f5 = fitlm(pCSI_diff(1:end ~=9),expl_raw(1:end ~=9));
    title(string(f5.Rsquared.Ordinary))
    xlim([0 0.5])
    ylim([0 100])
    xlabel('pCSI increase between 1 and 4 MU Pairs')
    ylabel('% Explained by RAW FPC')
nexttile
scatter(pCSI_auc(1:end ~=9),expl_raw(1:end ~=9))
    f6 = fitlm(pCSI_auc(1:end ~=9),expl_raw(1:end ~=9));
    title(string(f6.Rsquared.Ordinary))
    xlim([0 2])
    ylim([0 100])
    xlabel('pCSI AUC')
    ylabel('% Explained by RAW FPC')
    
%% 
tiledlayout(1,2)
nexttile
    scatter(pCSI,dat.MG.w1.cst_sd)
    ylim([0 4])
nexttile
    scatter(pCSI,dat.MG.w1.cst_cv)
    %ylim([0 4])

scatter(pCSI,nanmedian(dat.MG.w1.cst_MUsXCsmooth'))

scatter(pCSI,dat.w1.f_cv)

%%
for w = 1:30
    if dat.MG.w1.bad_wins(w) == 1
    else
        rs = xcorr(dat.w1.f_secs{w},dat.MG.w1.cst_secs{w},200,'normalize');
        r(w) = max(rs);
    end
end

scatter(pCSI,r)

%%
tiledlayout(1,3)
nexttile
    scatter(dat.MG.PCA.iter.w1.fpc_sd(1:end ~=9),expl(1:end ~=9))
    f = fitlm(dat.MG.PCA.iter.w1.fpc_sd(1:end ~=9),expl(1:end ~=9));
    title(string(f.Rsquared.Ordinary))
    ylabel('% Explained')
    xlabel('SD for First PC')
    hold on;
    plot(f)
nexttile
    scatter(dat.MG.w1.cst_sd(1:end ~=9),expl(1:end ~=9))
    [f,s] = polyfit(dat.MG.w1.cst_sd(1:end ~=9),expl(1:end ~=9)',3);
    xd = linspace(min(dat.MG.w1.cst_sd(1:end ~=9)),max(dat.MG.w1.cst_sd(1:end ~=9)));
    [pol,err] = polyval(f,xd,s);
    ylabel('% Explained')
    xlabel('SD for CST')
    hold on;
    plot(xd,pol,'r')
nexttile
    scatter(dat.MG.w1.cst_sd(1:end ~=9),dat.MG.PCA.iter.w1.fpc_sd(1:end ~=9))
    [f,s] = polyfit(dat.MG.w1.cst_sd(1:end ~=9),dat.MG.PCA.iter.w1.fpc_sd(1:end ~=9),3);
    xd = linspace(min(dat.MG.w1.cst_sd(1:end ~=9)),max(dat.MG.w1.cst_sd(1:end ~=9)));
    [pol,err] = polyval(f,xd,s);
    %title(string(f.Rsquared.Ordinary))
    ylabel('SD for First PC')
    xlabel('SD for CST')
    hold on;
    plot(xd,pol,'r')
    
%%
tiledlayout(1,2)
nexttile
scatter(expl(1:end ~=9),dat.w1.f_sd(1:end ~=9))
    f = fitlm(expl(1:end ~=9),dat.w1.f_sd(1:end ~=9));
    title(string(f.Rsquared.Ordinary))
    xlabel('% Explained by FPC')
    ylabel('SD for HPF Force')
nexttile
scatter(pCSI(1:end ~=9),dat.w1.f_sd(1:end ~=9))
    f = fitlm(pCSI(1:end ~=9),dat.w1.f_sd(1:end ~=9));
    title(string(f.Rsquared.Ordinary))
    xlabel('pCSI at 4 MU pairs')
    ylabel('SD for HPF Force')
%scatter(pCSI(1:end ~=9),expl(1:end ~=9))

%% boxplot with MU xcorr
tiledlayout(1,3)
nexttile
    boxplot(dat.MG.PCA.iter.w1.MUsXCsmooth')
    hold on;
    ydat = dat.MG.PCA.iter.w1.MUsXCsmooth';
    ydat = ydat(1:10,:);
    xdat = repmat(1:30,size(ydat,1),1);
    scatter(xdat(:),ydat(:),'r','filled','jitter','on','jitterAmount',0.15)
    title('MUsXC with FPC Smooth')

nexttile
    mu_sd = nanstd(dat.MG.PCA.iter.w1.MUsXCsmooth');
    scatter(mu_sd(1:end ~=9),expl(1:end ~=9))
    xlabel('SD for MUs cross correlation with FPC')
    ylabel('% Explained by FPC')
nexttile
    scatter(mu_sd(1:end ~=9),dat.MG.PCA.iter.w1.fpc_sd(1:end ~=9))
    xlabel('SD for MUs cross correlation with FPC')
    ylabel('SD for FPC')
    
%% Smooth
tiledlayout(1,2)
nexttile
    scatter(dat.MG.PCA.iter.w1.MUsXCsmooth(:), dat.MG.w1.SDidrs(:))
    xlabel('MUsXCSmooth')
    ylabel('SD for smoothed idrs')
nexttile
    scatter(mu_sd, nanstd(dat.MG.w1.SDidrs))
    xlabel('SD for MUsXCSmooth')
    ylabel('SD for SD for smoothed idrs')
%% Smooth
tiledlayout(1,2)
nexttile
    scatter(dat.MG.PCA.iter.w1.MUsXCsmooth(:), dat.MG.w1.SDisi(:))
    xlabel('MUsXCSmooth')
    ylabel('SD for isi')
    ylim([0 400])
nexttile
    scatter(mu_sd, nanstd(dat.MG.w1.SDisi))
    
%% RAW
mu_sd = nanstd(dat.MG.PCA.iter.w1.MUsXCraw');
    
tiledlayout(1,2)
nexttile
    scatter(dat.MG.PCA.iter.w1.MUsXCraw(:), dat.MG.w1.SDidrsRaw(:))
    xlabel('MUsXCraw')
    ylabel('SD for raw idrs')
nexttile
    scatter(mu_sd, nanstd(dat.MG.w1.SDidrs))
    xlabel('SD for MUsXCraw')
    ylabel('SD for SD for raw idrs')
%% RAW
tiledlayout(1,2)
nexttile
    scatter(dat.MG.PCA.iter.w1.MUsXCraw(:), dat.MG.w1.SDisi(:))
    xlabel('MUsXCraw')
    ylabel('SD for isi')
    ylim([0 400])
nexttile
    scatter(mu_sd, nanstd(dat.MG.w1.SDisi))
    xlabel('SD for MUsXCraw')
    ylabel('SD for SD for isi')
    ylim([0 110])
    
%% 
scatter(nanmean(dat.MG.w1.SDisi),expl)
scatter(nanmean(dat.MG.w1.SDisi),pCSI)
scatter(nanstd(dat.MG.w1.SDisi),pCSI)
%%
tiledlayout(1,3)
nexttile
    d = nanmedian(dat.MG.w1.SDisi);
    scatter(d(1:end ~= 9),dat.MG.w1.cst_sd(1:end ~=9))
    f = fitlm(d(1:end ~= 9),dat.MG.w1.cst_sd(1:end ~=9));
    title(string(f.Rsquared.Ordinary));
    xlabel('Median SD for ISI');
    ylabel('SD for CST')
nexttile
    d = nanmedian(dat.MG.w1.SDisi);
    scatter(d(1:end ~= 9),dat.MG.PCA.iter.w1.fpc_sd(1:end ~=9))
    f = fitlm(d(1:end ~= 9),dat.MG.PCA.iter.w1.fpc_sd(1:end ~=9));
    title(string(f.Rsquared.Ordinary));
    xlabel('Median SD for ISI');
    ylabel('SD for FPC')
nexttile
    d = nanmedian(dat.MG.w1.SDisi);
    scatter(d(1:end ~= 9),expl(1:end ~=9))
    f = fitlm(d(1:end ~= 9),expl(1:end ~=9));
    title(string(f.Rsquared.Ordinary));
    xlabel('Median SD for ISI');
    ylabel('% Explained by first PC')
%%
tiledlayout(1,3)
nexttile
    d = nanmedian(dat.MG.PCA.iter.w1.MUsXCsmooth');
    scatter(d(1:end ~=9),expl(1:end ~=9))
    xlabel('Median MUs XC Smooth');
    ylabel('% Explained by first PC')
nexttile
    scatter(d(1:end ~=9),dat.MG.PCA.iter.w1.fpc_sd(1:end ~=9))
    xlabel('Median MUs XC Smooth');
    ylabel('SD for first PC')
nexttile
    scatter(d(1:end ~=9),dat.MG.w1.cst_sd(1:end ~=9))
    xlabel('Median MUs XC Smooth');
    ylabel('SD for CST')    