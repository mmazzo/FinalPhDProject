% Chosing iteration # for PCAs
figure(3)
for p = 1:size(idrdat,1)
    plot(idrdat(p,:));
    hold on;
end

%% 
expl_mean_100 = expl_mean;
%%
plot(expl_mean_10)
xlim([2 20])
hold on;
plot(expl_mean_20)
plot(expl_mean_30)
plot(expl_mean_50)
plot(expl_mean_100)
legend('10','20','30','50','100');
%% latent variance
cm = jet(length(latentvar_all));
for p = 2:length(latentvar_all)
    plot(latentvar_all{p},'Color',cm(p,:));
    hold on;
end

%% Hotelling?s T-squared statistic is a statistical measure 
%  of the multivariate distance of each observation from 
%  the center of the data set.

cm = jet(length(tsq_all));
for p = 2:length(tsq_all)
    plot(tsq_all{p},'Color',cm(p,:));
    hold on;
end

%% Mean coefficient at different windows
win = 9;
cm = jet(size(MUdata.MG.PCA.iter.w1.coeffs_mean{win},1));
for p = 2:size(MUdata.MG.PCA.iter.w1.coeffs_mean{win},1)
plot(MUdata.MG.PCA.iter.w1.coeffs_mean{win}(p,:),'Color',cm(p,:))
hold on;
plot(mean(MUdata.MG.PCA.iter.w1.coeffs_mean{win}(2:end,:),1),'k','LineWidth',2);
end
xlabel('Timepoint (2000 Hz)')
ylabel('AU')
legend('2 MUs');
title('Coefficients derived from different numbers of MUs in PCA - Window 9');
%% Latent variance
cm = jet(length(MUdata.MG.PCA.iter.w1.latentvar_mean));
for p = 2:length(MUdata.MG.PCA.iter.w1.latentvar_mean)
plot(MUdata.MG.PCA.iter.w1.latentvar_mean{p}(2:end),'Color',cm(p,:))
hold on;
end
title('Latent variance during each 1-s window')
xlabel('# of Motor Units Contributing to PCA')
ylabel('Latent variance')
legend('Window 1');
%% Mean % explained
cm = jet(30);
for p = 1:30
    plot(mean_expl(p,2:end),'Color',cm(p,:));
    hold on;
    mean_expl(mean_expl == 0) = NaN;
    temp = nanmean(mean_expl);
    plot(temp(2:end),'k','LineWidth',2);
end
ylim([30 100])
xlabel('# of Motor Units Contributing to PCA')
ylabel('% of Variance Explained by FCC')
legend('Window 1');
title('% Explained by FCC for each window as a function of # MUs included');
%% Modeling exponential decay
mean_expl(mean_expl == 0) = NaN;
meanline = nanmean(mean_expl);
meanline = meanline(2:end-1);
%%
x = 1:length(meanline);

fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0],...
               'Upper',[100,length(meanline)],...
               'StartPoint',[1 100]);
ft = fittype('a*exp(-x)+b','options',fo);
g = 'a*exp(-x)+b';
f1 = fit(x',meanline',g);
plot(f1,x',meanline')

%%
xdata = ...
 [0.9 1.5 13.8 19.8 24.1 28.2 35.2 60.3 74.6 81.3];
ydata = ...
 [455.2 428.6 124.1 67.3 43.2 28.1 13.1 -0.4 -1.3 -1.5];
f = @(x,xdata) x(1)*(exp(-x(2)*xdata)+c);
%st = [100,1];
D = lsqcurvefit(f,[1 1],xdata,ydata);
Z = f(D,xdata);
plot(xdata,Z)
grid on
hold on
plot(xdata,ydata,['g','o'])

%%
x = ...
 [0.9 1.5 13.8 19.8 24.1 28.2 35.2 60.3 74.6 81.3];
ydata = ...
 [455.2 428.6 124.1 67.3 43.2 28.1 13.1 -0.4 -1.3 -1.5];

g = 'a*exp(-x)+b';
f1 = fit(x',ydata',g);
plot(f1,x',ydata')

%%

plot(beforeline,'r'); hold on; plot(preline,'b'); plot(postline,'g');
legend('Trial 1','Trial 2','Trial 3');
xlabel('# of Motor Units Contributing to PCA')
ylabel('% of Variance Explained by FCC')

%% 