%% Covariance in XCorrs across multiple contractions
times = {'before','pre','post'};
level = 'submax10';
day = 'control';

xcors.expl = zeros(3,100);

%% Assign

    t = 2;

%% Then run code:
    time = times{t};
    PFdata.(day).(level).MUdata.(time).PCA.iter.w30 = PCAiterfunc30_allPFs(PFdata.(day).(level).MUdata.(time));
%% Force data
    fdat = PFdata.(day).(level).force.(time).steady30.filt{1,1};
    fdat = highpass(fdat,0.75,2000);
    % Cross correlations
        % Force vs 30-s PCA first coeff (FPC)
        dat = PFdata.(day).(level).MUdata.(time).PCA.iter.w30.coeffs_mean(end,:);
            [r] = xcorr(dat, fdat,1000,'coeff');
            xcors.force_fpc(t) = max(r);
        % Force vs CST
        dat2 = PFdata.(day).(level).MUdata.(time).cst(PFdata.(day).(level).MUdata.(time).start:PFdata.(day).(level).MUdata.(time).endd);
        dat2 = highpass(dat2,0.75,2000);
            [r] = xcorr(dat2, fdat,1000,'coeff');
            xcors.force_cst(t) = max(r);
        % CST vs FPC
        [r] = xcorr(dat, dat2,1000,'coeff');
        xcors.fpc_cst(t) = max(r);
    % Variability in each
        xcors.sd.cst(t) = std(dat2);
        xcors.sd.fpc(t) = std(dat);
        xcors.sd.force(t) = std(fdat);
        xcors.expl(t,1:length(PFdata.(day).(level).MUdata.(time).PCA.iter.w30.explained_means)) = PFdata.(day).(level).MUdata.(time).PCA.iter.w30.explained_means;

%%
xcors.expl(xcors.expl == 0) = NaN;

DATA.control10 = xcors;
xcors = [];

%% Scatter plots
lens(1,1:3) = sum(~isnan(DATA.stretch10.expl),2);
lens(2,1:3) = sum(~isnan(DATA.stretch35.expl),2);
lens(3,1:3) = sum(~isnan(DATA.control10.expl),2);
lens(4,1:3) = sum(~isnan(DATA.control35.expl),2);
n = min(min(lens));

%%
figure(1)
set(gcf, 'Renderer', 'painters');
t = tiledlayout('flow');
title(t,'Cross Correlations vs % Explained (10% open / 35% filled)')
nexttile
    scatter(DATA.stretch10.expl(:,n),DATA.stretch10.force_fpc,'r')
    hold on;
    scatter(DATA.stretch35.expl(:,n),DATA.stretch35.force_fpc,'r','filled')
    scatter(DATA.control35.expl(:,n),DATA.control35.force_fpc,'r','filled')
    scatter(DATA.control10.expl(:,n),DATA.control10.force_fpc,'r')
    xlabel('% Explained')
    ylabel('Force vs FPC XCorr')
nexttile
    scatter(DATA.stretch10.expl(:,n),DATA.stretch10.force_cst,'b')
    hold on;
    scatter(DATA.stretch35.expl(:,n),DATA.stretch35.force_cst,'b','filled')
    scatter(DATA.control35.expl(:,n),DATA.control35.force_cst,'b','filled')
    scatter(DATA.control10.expl(:,n),DATA.control10.force_cst,'b')
    xlabel('% Explained')
    ylabel('Force vs CST XCorr')
nexttile
    scatter(DATA.stretch10.expl(:,n),DATA.stretch10.fpc_cst,'g')
    hold on;
    scatter(DATA.stretch35.expl(:,n),DATA.stretch35.fpc_cst,'g','filled')
    scatter(DATA.control35.expl(:,n),DATA.control35.fpc_cst,'g','filled')
    scatter(DATA.control10.expl(:,n),DATA.control10.fpc_cst,'g')
    xlabel('% Explained')
    ylabel('CST vs FPC XCorr')
%%    
figure(2)
set(gcf, 'Renderer', 'painters');
t2 = tiledlayout('flow');
title(t2,'Cross Correlations vs SD (10% open / 35% filled)')
nexttile
    scatter(DATA.stretch10.sd.fpc,DATA.stretch10.force_fpc,'r')
    hold on;
    scatter(DATA.stretch35.sd.fpc,DATA.stretch35.force_fpc,'r','filled')
    scatter(DATA.control10.sd.fpc,DATA.control10.force_fpc,'r')
    scatter(DATA.control35.sd.fpc,DATA.control35.force_fpc,'r','filled')
    xlabel('SD for FPC')
    ylabel('Force vs FPC XCorr')
nexttile
    scatter(DATA.stretch10.sd.cst,DATA.stretch10.force_cst,'b')
    hold on;
    scatter(DATA.stretch35.sd.cst,DATA.stretch35.force_cst,'b','filled')
    scatter(DATA.control10.sd.cst,DATA.control10.force_cst,'b')
    scatter(DATA.control35.sd.cst,DATA.control35.force_cst,'b','filled')
    xlabel('SD for CST')
    ylabel('Force vs CST XCorr')
nexttile
    scatter(DATA.stretch10.sd.force,normalize(DATA.stretch10.sd.cst),'k','filled')
    hold on;
    scatter(DATA.stretch35.sd.force,normalize(DATA.stretch35.sd.cst),'k','filled')
    scatter(DATA.control10.sd.force,normalize(DATA.control10.sd.cst),'k','filled')
    scatter(DATA.control35.sd.force,normalize(DATA.control35.sd.cst),'k','filled')
    scatter(DATA.stretch10.sd.force,normalize(DATA.stretch10.sd.fpc),'k')
    scatter(DATA.stretch35.sd.force,normalize(DATA.stretch35.sd.fpc),'k')
    scatter(DATA.control10.sd.force,normalize(DATA.control10.sd.fpc),'k')
    scatter(DATA.control35.sd.force,normalize(DATA.control35.sd.fpc),'k')
    xlabel('SD for Force')
    ylabel('Normalized SD for CST and FPC')
    title('SD for CST = Filled / SD for FPC = Open (')
%%
figure(3)
set(gcf, 'Renderer', 'painters');
t3 = tiledlayout('flow');
title(t3,'SD vs % Explained (10% open / 35% filled)')
nexttile
    scatter(DATA.stretch10.expl(:,n),DATA.stretch10.sd.fpc,'r')
    hold on;
    scatter(DATA.stretch35.expl(:,n),DATA.stretch35.sd.fpc,'r','filled')
    scatter(DATA.control10.expl(:,n),DATA.control10.sd.fpc,'r')
    scatter(DATA.control35.expl(:,n),DATA.control35.sd.fpc,'r','filled')
    xlabel('% Explained')
    ylabel('SD for FPC')
nexttile
    scatter(DATA.stretch10.expl(:,n),DATA.stretch10.sd.cst,'b')
    hold on;
    scatter(DATA.stretch35.expl(:,n),DATA.stretch35.sd.cst,'b','filled')
    scatter(DATA.control10.expl(:,n),DATA.control10.sd.cst,'b')
    scatter(DATA.control35.expl(:,n),DATA.control35.sd.cst,'b','filled')
    xlabel('% Explained')
    ylabel('SD for CST')
nexttile
    scatter(DATA.stretch10.expl(:,n),DATA.stretch10.sd.force,'g')
    hold on;
    scatter(DATA.stretch35.expl(:,n),DATA.stretch35.sd.force,'g','filled')
    scatter(DATA.control10.expl(:,n),DATA.control10.sd.force,'g')
    scatter(DATA.control35.expl(:,n),DATA.control35.sd.force,'g','filled')
    xlabel('% Explained')
    ylabel('SD for force')
    