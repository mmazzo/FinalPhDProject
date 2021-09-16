% PCA iter plots to compare times/etc
day = 'control';
level = 'submax35';
mus = 'MG';


%% PCA iteration plots - compare different times
set(gcf, 'Renderer', 'painters');
    % time 1
    cm = jet(30);
    time = 'before';
    for p = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means)
        plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p}(2:end),'Color','b');
        hold on;
        plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean(2:end),'b','LineWidth',2);
    end
    ylim([0 100])
    xlabel('# of Motor Units Contributing to PCA')
    ylabel('% of Variance Explained by FCC')
    % time 2
    cm = jet(30);
    time = 'pre';
    for p = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means)
        plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p}(2:end),'Color','r');
        hold on;
        plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean(2:end),'r','LineWidth',2);
    end
    ylim([0 100])
    xlabel('# of Motor Units Contributing to PCA')
    ylabel('% of Variance Explained by FCC')
    title('% Explained by FCC for each window as a function of # MUs included')
    % time 3
    cm = jet(30);
    time = 'post';
    for p = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means)
        plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p}(2:end),'Color','g');
        hold on;
        plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean(2:end),'g','LineWidth',2);
    end
    ylim([0 100])
    xlabel('# of Motor Units Contributing to PCA')
    ylabel('% of Variance Explained by FCC')
    legend('Before', 'Pre', 'Post');
    title('% Explained by FCC for each window as a function of # MUs included')
    
%% SD across MU #
time = 'before';
vec = [];
    for w = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means)
        for mu = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{w})
            vec(mu,w) = PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{w}(mu);
        end
    end
vec(vec == 0) = NaN;
std1 = nanstd(vec');

time = 'pre';
vec = [];
    for w = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means)
        for mu = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{w})
            vec(mu,w) = PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{w}(mu);
        end
    end
vec(vec == 0) = NaN;
std2 = nanstd(vec');


time = 'post';
vec = [];
    for w = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means)
        for mu = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{w})
            vec(mu,w) = PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{w}(mu);
        end
    end
vec(vec == 0) = NaN;
std3 = nanstd(vec');

plot(std1,'b'); hold on;
plot(std2,'r')
plot(std3,'g')

%% Boxplots at certain MU number

mu = 6;

tiledlayout(1,3)
nexttile
    time = 'before';
    for p = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means)
        if isempty(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p})
        else
        boxdat(p) = PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p}(mu);
        hold on;
        scatter(1,PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p}(mu),'r');
        scatter(1,PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean(mu),'k','filled');
        end
    end
    boxplot(boxdat)
    ylim([30 100])
nexttile
    time = 'pre';
    for p = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means)
        if isempty(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p})
        else
        boxdat(p) = PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p}(mu);
        hold on;
        scatter(1,PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p}(mu),'r');
        scatter(1,PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean(mu),'k','filled');
        end
    end
    boxplot(boxdat)
    ylim([30 100])
nexttile
    time = 'post';
    for p = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means)
        if isempty(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p})
        else
        boxdat(p) = PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p}(mu);
        hold on;
        scatter(1,PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p}(mu),'r');
        scatter(1,PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean(mu),'k','filled');
        end
    end
    boxplot(boxdat)
    ylim([30 100])