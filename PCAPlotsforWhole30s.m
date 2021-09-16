
day = 'stretch';
time = 'before';
level = 'submax35';
%% PCA of WHOLE 30-second steady portion compared to windowed
set(gcf, 'Renderer', 'painters');
tiledlayout(2,1)
nexttile
    for p = 2:length(pcadat.expl_all)
%         for i = 1:100
%             scatter(p,pcadat.expl_all{p}(i))
%             hold on;
%         end
        boxdat(p,1:100) = pcadat.expl_all{p};
    end
    boxplot(boxdat'); hold on;
    plot(pcadat.expl_mean(2:end),'k','linewidth',2)
nexttile
    plot(pcadat.expl_mean(2:end),'k','linewidth',2)
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean(2:end),'r','linewidth',2)
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained_mean(2:end),'b','linewidth',2)
    legend('PCA of Whole steady 30 s','Iterative PCA - 1s Windows',...
        'Iterative PCA - 5s Windows');
%%
set(gcf, 'Renderer', 'painters');
cm = jet(16);
for p = 2:16
    hold on,
    plot(pcadat.coeff_mean(p,:),'color',cm(p,:))
    title('First PC coefficients')
end  
plot(pcadat.coeff_mean(17,:),'k');
% nexttile
%     plot(pcadat.coeff_mean(17,:),'k')
%     hold on;
%     % Mergedt 1 s FCC
%     fcc = [];
%     for w = 1:30
%         fcc = horzcat(fcc,PFdata.stretch.submax10.MUdata.before.MG.PCA.iter.w1.coeff_mean{w});
%     end
%     plot(fcc,'r');
%     % Merged 5 s FCC
%     fcc = [];
%     for w = 1:6
%         fcc = horzcat(fcc,PFdata.stretch.submax10.MUdata.before.MG.PCA.iter.w1.coeff_mean{w});
%     end
%     plot(fcc,'b');