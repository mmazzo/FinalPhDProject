% PCA values depend on # of motor units included in analysis!
% Fewer motor units = arbitrarily higher % explained values
idrdat1 = PFdata.control.submax35.MUdata.before.MG.binary;
rem = [];
for mu = 1:size(idrdat1,1)
    if sum(idrdat1(mu,:)) == 0
        rem = horzcat(rem,mu);
    end
end
idrdat1(rem,:) = [];
%%
plotSpikeRaster(logical(idrdat1),'PlotType','vertline','VertSpikeHeight',0.5);

%% section & pca
idrdat1 = idrdat1(:,54900:54900+2000);
[coeff1,score1,lat1,tsq1,expl1,muu1] = pca(idrdat1);

% Random 6 MUs
num = floor(size(idrdat1,1)/2);
idrdat2 = idrdat1(1:num,:);
[coeff2,score2,lat2,tsq2,expl2,muu2] = pca(idrdat2);

%% plot
plot(expl1); hold on; plot(expl2);
xlim([0 6]);
ylim([0 50]);