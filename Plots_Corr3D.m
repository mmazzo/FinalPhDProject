% 3-way correlation plots: For both Smoothed and Raw
%   Windows with the greatest standard deviation of the FPC also have the
%   highest % explained by the FPC and the highest median cross-correlation between
%   individual MUs and the FPC

%% 1-s Windows - Smooth
tiledlayout(2,3)
% 2D plot between:
%   - Median Smoothed MU-FPC correlation
%   - SD for Smoothed FPC
    dat1 = nanmedian(dat.MG.PCA.iter.w30.w1.MUsXCsmooth,2);
    dat1 = dat1(1:end); % ~=9
    dat2 = dat.MG.PCA.iter.w30.w1.fpc_sd;
    dat2 = dat2(1:end);

nexttile
    f = fitlm(dat1,dat2);
    plot(f)
    title(strcat('Median Smooth MU-FPC Correlation vs. SD for Smooth FPC - ',string(f.Rsquared.Ordinary)))

% 3D plot between:
%   - Median MU-FPC correlation
%   - SD for FPC
%   - % Explained by FPC
    for w = 1:30
        %if w == 9
        %else
        dat3(w) = dat.MG.PCA.iter.w1.explained_means{w}(6);
        %end
    end
    dat3 = dat3(1:end);

nexttile
    scatter3(dat1,dat2,dat3)

% 2D plot between:
%   - SD for Raw FPC
%   - % Explained by raw FPC
nexttile
    f2 = fitlm(dat2,dat3);
    plot(f2)
    title(strcat('SD for FPC vs. % Explained by FPC - ',string(f2.Rsquared.Ordinary)))

%% 1-s Windows - RAW
%tiledlayout(1,3)
% 2D plot between:
%   - Median Raw MU-FPC correlation
%   - SD for Raw FPC
    dat1 = nanmedian(dat.MG.PCA.iter.w30.w1.MUsXCraw,2);
    dat1 = dat1(1:end ~=9);
    dat2 = dat.MG.PCA.iter.raw.w30.w1.fpc_sd;
    dat2 = dat2(1:end ~=9);

nexttile
    f = fitlm(dat1,dat2);
    plot(f)
    title(strcat('Median Raw MU-FPC Correlation vs. SD for Raw FPC - ', string(f.Rsquared.Ordinary)))

% 3D plot between:
%   - Median Raw MU-FPC correlation
%   - SD for Raw FPC
%   - % Explained by raw FPC
    for w = 1:30
        if w == 9
        else
        dat3(w) = dat.MG.PCA.iter.raw.w1.explained_means{w}(10);
        end
    end
    dat3 = dat3(1:end ~=9);

nexttile
    scatter3(dat1,dat2,dat3)

% 2D plot between:
%   - SD for Raw FPC
%   - % Explained by raw FPC
nexttile
    f2 = fitlm(dat2,dat3);
    plot(f2)
    title(strcat('SD for Raw FPC vs. % Explained by Raw FPC - ',string(f2.Rsquared.Ordinary)))
    
    
%% 5-s Windows - Smooth
dat1 = []; dat2 = []; dat3 = [];
tiledlayout(2,3)
% 2D plot between:
%   - Median Smoothed MU-FPC correlation
%   - SD for Smoothed FPC
    dat1 = nanmedian(dat.MG.PCA.iter.w30.w5.MUsXCsmooth,2);
    dat1 = dat1(1:end ~=2);
    dat2 = dat.MG.PCA.iter.w30.w5.fpc_sd;
    dat2 = dat2(1:end ~=2);

nexttile
    f = fitlm(dat1,dat2);
    plot(f)
    title(strcat('Median Smooth MU-FPC Correlation vs. SD for Smooth FPC - ',string(f.Rsquared.Ordinary)))

% 3D plot between:
%   - Median MU-FPC correlation
%   - SD for FPC
%   - % Explained by FPC
    for w = 1:6
        if w == 2
        else
        dat3(w) = dat.MG.PCA.iter.w5.explained_means{w}(10);
        end
    end
    dat3 = dat3(1:end ~=2);

nexttile
    scatter3(dat1,dat2,dat3)

% 2D plot between:
%   - SD for Raw FPC
%   - % Explained by raw FPC
nexttile
    f2 = fitlm(dat2,dat3);
    plot(f2)
    title(strcat('SD for FPC vs. % Explained by FPC - ',string(f2.Rsquared.Ordinary)))

%% 5-s Windows - RAW
%tiledlayout(1,3)
% 2D plot between:
%   - Median Raw MU-FPC correlation
%   - SD for Raw FPC
    dat1 = nanmedian(dat.MG.PCA.iter.w30.w5.MUsXCraw,2);
    dat1 = dat1(1:end ~=2);
    dat2 = dat.MG.PCA.iter.raw.w30.w5.fpc_sd;
    dat2 = dat2(1:end ~=2);

nexttile
    f = fitlm(dat1,dat2);
    plot(f)
    title(strcat('Median Raw MU-FPC Correlation vs. SD for Raw FPC - ', string(f.Rsquared.Ordinary)))

% 3D plot between:
%   - Median Raw MU-FPC correlation
%   - SD for Raw FPC
%   - % Explained by raw FPC
    for w = 1:6
        if w == 2
        else
        dat3(w) = dat.MG.PCA.iter.raw.w5.explained_means{w}(10);
        end
    end
    dat3 = dat3(1:end ~=2);

nexttile
    scatter3(dat1,dat2,dat3)

% 2D plot between:
%   - SD for Raw FPC
%   - % Explained by raw FPC
nexttile
    f2 = fitlm(dat2,dat3);
    plot(f2)
    title(strcat('SD for Raw FPC vs. % Explained by Raw FPC - ',string(f2.Rsquared.Ordinary)))