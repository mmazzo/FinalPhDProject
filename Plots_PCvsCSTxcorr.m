% Single muscle - Xcorr between motor units and CST
% SFU02 Control Submax 35 Before
mus = 'MG';

% How similar are single MU correlations with CST when smoothed vs raw?
scatter(PFdata.control.submax35.MUdata.before.(mus).w30.MUsXC_CSTraw,...
    PFdata.control.submax35.MUdata.before.(mus).w30.MUsXC_CSTsmooth)

%% How similar are single MU correlations with CST across windows?
figrue(1)
tiledlayout(2,1)
% Smoothed
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTsmooth,2)
    plot(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTsmooth(:,mu))
    hold on;
end

% Raw
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTraw,2)
    plot(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTraw(:,mu))
    hold on;
end

figure(2)
% Correlation between smoooth and raw
for mu = 1:size(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTraw,2)
    scatter(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTraw(:,mu),PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTsmooth(:,mu))
    hold on;
end

%% FPC vs CST MUsXCs
tiledlayout(1,2)
% Smooth
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTsmooth,2)
    scatter(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTsmooth(:,mu),...
        PFdata.control.submax35.MUdata.before.(mus).PCA.iter.w30.w1.MUsXCsmooth(:,mu))
    hold on;
end
xlabel('Smooth CST MUsXC')
ylabel('Smooth FPC MUsXC')

% Raw
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTraw,2)
    scatter(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTraw(:,mu),...
        PFdata.control.submax35.MUdata.before.(mus).PCA.iter.w30.w1.MUsXCraw(:,mu))
    hold on;
end
xlabel('Raw CST MUsXC')
ylabel('Raw FPC MUsXC')

%% Xcorr vs % explained
for w = 1:30 % 6 MUs
    expl(w) = PFdata.control.submax35.MUdata.before.MG.PCA.iter.w1.explained_means{w}(6);
end

t = tiledlayout(2,2);
title(t, 'Cross correlations between MUs and CST/FPC - 1s Windows - 6 MUs');

% Smooth
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTsmooth,2)
    scatter(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTsmooth(:,mu), expl)
    hold on;
end
title('CST Smooth MUsXC')
xlabel('MUsXC between CST and Smoothed IDR Lines')
ylabel('% Explained by FPC')

% Raw
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTraw,2)
    scatter(PFdata.control.submax35.MUdata.before.(mus).w1.MUsXC_CSTraw(:,mu), expl)
    hold on;
end
title('CST Raw MUsXC')
xlabel('MUsXC between CST and Raw IDR Lines')
ylabel('% Explained by FPC')

% Smooth
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.(mus).PCA.iter.w30.w1.MUsXCsmooth,2)
    scatter(PFdata.control.submax35.MUdata.before.(mus).PCA.iter.w30.w1.MUsXCsmooth(:,mu), expl)
    hold on;
end
title('FPC Smooth MUsXC')
xlabel('MUsXC between FPC and Smoothed IDR Lines')
ylabel('% Explained by FPC')

% Raw
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.(mus).PCA.iter.w30.w1.MUsXCraw,2)
    scatter(PFdata.control.submax35.MUdata.before.(mus).PCA.iter.w30.w1.MUsXCraw(:,mu), expl)
    hold on;
end
title('FPC Raw MUsXC')
xlabel('MUsXC between FPC and Raw IDR Lines')
ylabel('% Explained by FPC')






%% ALL PFs - Xcorr between motor units and CST
% SFU02 Control Submax 35 Before

% How similar are single MU correlations with CST when smoothed vs raw?
scatter(PFdata.control.submax35.MUdata.before.w30.MUsXC_CSTraw,...
    PFdata.control.submax35.MUdata.before.w30.MUsXC_CSTsmooth)

%% How similar are single MU correlations with CST across windows?
figure(1)
tiledlayout(2,1)
% Smoothed
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTsmooth,2)
    plot(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTsmooth(:,mu))
    hold on;
end


% Raw
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTraw,2)
    plot(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTraw(:,mu))
    hold on;
end

figure(2)
% Correlation between smoooth and raw
for mu = 1:size(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTraw,2)
    scatter(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTraw(:,mu),PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTsmooth(:,mu))
    hold on;
end

%% FPC vs CST MUsXCs
tiledlayout(1,2)
% Smooth
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTsmooth,2)
    scatter(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTsmooth(:,mu),...
        PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCsmooth(:,mu))
    hold on;
end
xlabel('Smooth MUsXC CST')
ylabel('Smooth MUsXC FPC')

% Raw
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTraw,2)
    scatter(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTraw(:,mu),...
        PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCraw(:,mu))
    hold on;
end
xlabel('Raw MUsXC CST')
ylabel('Raw MUsXC FPC')
%% Xcorr vs % explained
for w = 1:30 % 6 MUs
    expl(w) = PFdata.control.submax35.MUdata.before.PCA.iter.w1.explained_means{w}(6);
end

t = tiledlayout(2,2);
title(t, 'Cross correlations between MUs and CST/FPC - 1s Windows - Max # MUs');

% Smooth
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTsmooth,2)
    scatter(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTsmooth(:,mu), expl)
    hold on;
end
title('CST Smooth MUsXC')
xlabel('MUsXC between CST and Smoothed IDR Lines')
ylabel('% Explained by FPC')

% Raw
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTraw,2)
    scatter(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTraw(:,mu), expl)
    hold on;
end
title('CST Raw MUsXC')
xlabel('MUsXC between CST and Raw IDR Lines')
ylabel('% Explained by FPC')

% Smooth
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCsmooth,2)
    scatter(PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCsmooth(:,mu), expl)
    hold on;
end
title('FPC Smooth MUsXC')
xlabel('MUsXC between FPC and Smoothed IDR Lines')
ylabel('% Explained by FPC')

% Raw
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCraw,2)
    scatter(PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCraw(:,mu), expl)
    hold on;
end
title('FPC Raw MUsXC')
xlabel('MUsXC between FPC and Raw IDR Lines')
ylabel('% Explained by FPC')

%% All PFs and SD for force
t = tiledlayout(2,2);
title(t, 'Cross correlations between MUs and CST/FPC - 1s Windows - SD for Force');

% Smooth
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTsmooth,2)
    scatter(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTsmooth(:,mu),...
        PFdata.control.submax35.MUdata.before.w1.f_sd)
    hold on;
end
title('CST Smooth MUsXC')
xlabel('MUsXC between CST and Smoothed IDR Lines')
ylabel('SD for Force')

% Raw
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTraw,2)
    scatter(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTraw(:,mu),...
        PFdata.control.submax35.MUdata.before.w1.f_sd)
    hold on;
end
title('CST Raw MUsXC')
xlabel('MUsXC between CST and Raw IDR Lines')
ylabel('SD for Force')

% Smooth
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCsmooth,2)
    scatter(PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCsmooth(:,mu),...
        PFdata.control.submax35.MUdata.before.w1.f_sd)
    hold on;
end
title('FPC Smooth MUsXC')
xlabel('MUsXC between FPC and Smoothed IDR Lines')
ylabel('SD for Force')

% Raw
nexttile
for mu = 1:size(PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCraw,2)
    scatter(PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCraw(:,mu),...
        PFdata.control.submax35.MUdata.before.w1.f_sd)
    hold on;
end
title('FPC Raw MUsXC')
xlabel('MUsXC between FPC and Raw IDR Lines')
ylabel('SD for Force')

%% Same thing but hexbin plots
% All PFs and SD for force
t = tiledlayout(2,2);
title(t, 'Cross correlations between MUs and CST/FPC - 1s Windows - SD for Force');

% Smooth
nexttile
x = [];
y = [];
for mu = 1:length(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTsmooth)
    tempy = PFdata.control.submax35.MUdata.before.w1.f_sd;
    y = horzcat(y,tempy);
    tempx = PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTsmooth(:,mu)';
    x = horzcat(x,tempx);
end
binscatter(x,y)

title('CST Smooth MUsXC')
xlabel('MUsXC between CST and Smoothed IDR Lines')
ylabel('SD for Force')

% Raw
nexttile
x = [];
y = [];
for mu = 1:length(PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTraw)
    tempy = PFdata.control.submax35.MUdata.before.w1.f_sd;
    y = horzcat(y,tempy);
    tempx = PFdata.control.submax35.MUdata.before.w1.MUsXC_CSTraw(:,mu)';
    x = horzcat(x,tempx);
end
binscatter(x,y)
title('CST Raw MUsXC')
xlabel('MUsXC between CST and Raw IDR Lines')
ylabel('SD for Force')

% Smooth
nexttile
x = [];
y = [];
for mu = 1:length(PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCsmooth)
    tempy = PFdata.control.submax35.MUdata.before.w1.f_sd;
    y = horzcat(y,tempy);
    tempx = PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCsmooth(:,mu)';
    x = horzcat(x,tempx);
end
binscatter(x,y)
title('FPC Smooth MUsXC')
xlabel('MUsXC between FPC and Smoothed IDR Lines')
ylabel('SD for Force')

% Raw
nexttile
x = [];
y = [];
for mu = 1:length(PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCraw)
    tempy = PFdata.control.submax35.MUdata.before.w1.f_sd;
    y = horzcat(y,tempy);
    tempx = PFdata.control.submax35.MUdata.before.PCA.iter.w30.w1.MUsXCraw(:,mu)';
    x = horzcat(x,tempx);
end
binscatter(x,y)
title('FPC Raw MUsXC')
xlabel('MUsXC between FPC and Raw IDR Lines')
ylabel('SD for Force')

