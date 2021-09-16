% PCA with 200ms window
w = 2;

%% 1-s windows
tiledlayout(1,3)
nexttile
    plot(MUdata.MG.PCA.iter.w1.explained_mean)
    ylim([40 100])
nexttile
    plot(MUdata.MG.PCA.iter.w1_200.explained_mean)
nexttile
    plot(MUdata.MG.PCA.iter.raw.w1.explained_mean)
    ylim([40 100])
    
tiledlayout(4,1)
nexttile
    plot(MUdata.MG.PCA.iter.w1.coeff_mean{w})
nexttile
    plot(MUdata.MG.PCA.iter.w1_200.coeff_mean{w})
nexttile
    plot(MUdata.MG.PCA.iter.raw.w1.coeff_mean{w})
nexttile
    plot(fdat.filt{1,1}(MUdata.w1.starts(w):MUdata.w1.endds(w)))
    
%% 5-s windows
tiledlayout(1,3)
nexttile
    plot(MUdata.MG.PCA.iter.w5.explained_mean)
    ylim([40 100])
nexttile
    plot(MUdata.MG.PCA.iter.w5_200.explained_mean)
nexttile
    plot(MUdata.MG.PCA.iter.raw.w5.explained_mean)
    ylim([40 100])
    
tiledlayout(4,1)
nexttile
    plot(MUdata.MG.PCA.iter.w5.coeff_mean{w})
nexttile
    plot(MUdata.MG.PCA.iter.w5_200.coeff_mean{w})
nexttile
    plot(MUdata.MG.PCA.iter.raw.w5.coeff_mean{w})
nexttile
    plot(fdat.filt{1,1}(MUdata.w5.starts(w):MUdata.w5.endds(w)))