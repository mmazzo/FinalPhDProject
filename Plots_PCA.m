% Plot PCA analysis results for one subject, one day
level = 'submax10';
max = 100;

figure(1)
tiledlayout(2,4)
day = 'stretch';
    nexttile
        % MG
        plot(PFdata.(day).(level).MUdata.before.MG.PCA.w1.explained_means,'r')
        hold on;
        plot(PFdata.(day).(level).MUdata.pre.MG.PCA.w1.explained_means,'b')
        plot(PFdata.(day).(level).MUdata.post.MG.PCA.w1.explained_means,'g')
        xlim([0 6]); ylim([0 max]);
        title('MG');
        legend('Trial 1','Trial 2','Trial 3');
        xlabel('PCA Component #')
        ylabel('% of Variance Explained')
    nexttile
        % LG
        plot(PFdata.(day).(level).MUdata.before.LG.PCA.w1.explained_means,'k')
        hold on;
        plot(PFdata.(day).(level).MUdata.pre.LG.PCA.w1.explained_means,'b')
        plot(PFdata.(day).(level).MUdata.post.LG.PCA.w1.explained_means,'g')
        xlim([0 6]); ylim([0 max]);
        title('LG');
    nexttile
        % SOL
        plot(PFdata.(day).(level).MUdata.before.SOL.PCA.w1.explained_means,'k')
        hold on;
        plot(PFdata.(day).(level).MUdata.pre.SOL.PCA.w1.explained_means,'b')
        plot(PFdata.(day).(level).MUdata.post.SOL.PCA.w1.explained_means,'g')
        xlim([0 6]); ylim([0 max]);
        title('SOL');
    nexttile
        % All
        plot(PFdata.(day).(level).MUdata.before.PCA.w1.explained_means,'k')
        hold on;
        plot(PFdata.(day).(level).MUdata.pre.PCA.w1.explained_means,'b')
        plot(PFdata.(day).(level).MUdata.post.PCA.w1.explained_means,'g')
        xlim([0 6]); ylim([0 max]);
        title('ALL PFs');

        
day = 'control';
    nexttile
    % MG
    plot(PFdata.(day).(level).MUdata.before.MG.PCA.w1.explained_means,'r')
    hold on;
    plot(PFdata.(day).(level).MUdata.pre.MG.PCA.w1.explained_means,'b')
    plot(PFdata.(day).(level).MUdata.post.MG.PCA.w1.explained_means,'g')
    xlim([0 6]); ylim([0 max]);
    title('MG');
        legend('Trial 1','Trial 2','Trial 3');
        xlabel('PCA Component #')
        ylabel('% of Variance Explained')
nexttile
    % LG
    plot(PFdata.(day).(level).MUdata.before.LG.PCA.w1.explained_means,'k')
    hold on;
    plot(PFdata.(day).(level).MUdata.pre.LG.PCA.w1.explained_means,'b')
    plot(PFdata.(day).(level).MUdata.post.LG.PCA.w1.explained_means,'g')
    xlim([0 6]); ylim([0 max]);
    title('LG');
nexttile
    % SOL
    plot(PFdata.(day).(level).MUdata.before.SOL.PCA.w1.explained_means,'k')
    hold on;
    plot(PFdata.(day).(level).MUdata.pre.SOL.PCA.w1.explained_means,'b')
    plot(PFdata.(day).(level).MUdata.post.SOL.PCA.w1.explained_means,'g')
    xlim([0 6]); ylim([0 max]);
    title('SOL');
nexttile
    % All
    plot(PFdata.(day).(level).MUdata.before.PCA.w1.explained_means,'k')
    hold on;
    plot(PFdata.(day).(level).MUdata.pre.PCA.w1.explained_means,'b')
    plot(PFdata.(day).(level).MUdata.post.PCA.w1.explained_means,'g')
    xlim([0 6]); ylim([0 max]);
    title('ALL PFs');
    
%%
figure(2)
% Plot PCA analysis results for one subject, one day
tiledlayout(2,4)
day = 'stretch';
    nexttile
        % MG
        plot(PFdata.(day).(level).MUdata.before.MG.PCA.raw.w1.explained_means,'k')
        hold on;
        plot(PFdata.(day).(level).MUdata.pre.MG.PCA.raw.w1.explained_means,'r')
        plot(PFdata.(day).(level).MUdata.post.MG.PCA.raw.w1.explained_means,'m')
        xlim([0 6]); ylim([0 max]);
        title('MG');
    nexttile
        % LG
        plot(PFdata.(day).(level).MUdata.before.LG.PCA.raw.w1.explained_means,'k')
        hold on;
        plot(PFdata.(day).(level).MUdata.pre.LG.PCA.raw.w1.explained_means,'r')
        plot(PFdata.(day).(level).MUdata.post.LG.PCA.raw.w1.explained_means,'m')
        xlim([0 6]); ylim([0 max]);
        title('LG');
    nexttile
        % SOL
        plot(PFdata.(day).(level).MUdata.before.SOL.PCA.raw.w1.explained_means,'k')
        hold on;
        plot(PFdata.(day).(level).MUdata.pre.SOL.PCA.raw.w1.explained_means,'r')
        plot(PFdata.(day).(level).MUdata.post.SOL.PCA.raw.w1.explained_means,'m')
        xlim([0 6]); ylim([0 max]);
        title('SOL');
    nexttile
        % All
        plot(PFdata.(day).(level).MUdata.before.PCA.raw.w1.explained_means,'k')
        hold on;
        plot(PFdata.(day).(level).MUdata.pre.PCA.raw.w1.explained_means,'r')
        plot(PFdata.(day).(level).MUdata.post.PCA.raw.w1.explained_means,'m')
        xlim([0 6]); ylim([0 max]);
        title('ALL PFs');

        
day = 'control';
    nexttile
    % MG
    plot(PFdata.(day).(level).MUdata.before.MG.PCA.raw.w1.explained_means,'k')
    hold on;
    plot(PFdata.(day).(level).MUdata.pre.MG.PCA.raw.w1.explained_means,'r')
    plot(PFdata.(day).(level).MUdata.post.MG.PCA.raw.w1.explained_means,'m')
    xlim([0 6]); ylim([0 max]);
    title('MG');
nexttile
    % LG
    plot(PFdata.(day).(level).MUdata.before.LG.PCA.raw.w1.explained_means,'k')
    hold on;
    plot(PFdata.(day).(level).MUdata.pre.LG.PCA.raw.w1.explained_means,'r')
    plot(PFdata.(day).(level).MUdata.post.LG.PCA.raw.w1.explained_means,'m')
    xlim([0 6]); ylim([0 max]);
    title('LG');
nexttile
    % SOL
    plot(PFdata.(day).(level).MUdata.before.SOL.PCA.raw.w1.explained_means,'k')
    hold on;
    plot(PFdata.(day).(level).MUdata.pre.SOL.PCA.raw.w1.explained_means,'r')
    plot(PFdata.(day).(level).MUdata.post.SOL.PCA.raw.w1.explained_means,'m')
    xlim([0 6]); ylim([0 max]);
    title('SOL');
nexttile
    % All
    plot(PFdata.(day).(level).MUdata.before.PCA.raw.w1.explained_means,'k')
    hold on;
    plot(PFdata.(day).(level).MUdata.pre.PCA.raw.w1.explained_means,'r')
    plot(PFdata.(day).(level).MUdata.post.PCA.raw.w1.explained_means,'m')
    xlim([0 6]); ylim([0 max]);
    title('ALL PFs');
    
%% Association between smoothed and raw FCC values?
muscles = {'MG','LG','SOL'};
days = {'stretch','control'};
times = {'before','pre','post'};

c(1,:) = [0 1 0];
c(2,:) = [1 0 0];
c(3,:) = [0 0 1];

tiledlayout(2,2)
nexttile
for m = 1:3
    for d = 1:2
        for t = 1:3
        time = times{t};
        day = days{d};
        mus = muscles{m};
            scatter(PFdata.(day).submax35.MUdata.(time).(mus).PCA.w1.explained_means(:,1),PFdata.(day).submax35.MUdata.(time).(mus).PCA.raw.w1.explained_means(:,1),'MarkerEdgeColor',c(m,:))
            hold on;
        xlabel('% Explained Smoothed');
        ylabel('% Explained Raw');
        title('35% MVC - 1s Windows');
        end
    end
end

nexttile
for m = 1:3
    for d = 1:2
        for t = 1:3
        time = times{t};
        day = days{d};
        mus = muscles{m};
            scatter(PFdata.(day).submax10.MUdata.(time).(mus).PCA.w1.explained_means(:,1),PFdata.(day).submax10.MUdata.(time).(mus).PCA.raw.w1.explained_means(:,1),'MarkerEdgeColor',c(m,:))
            hold on;
        xlabel('% Explained Smoothed');
        ylabel('% Explained Raw');
        title('10% MVC - 1s Windows');
        end
    end
end

nexttile
for m = 1:3
    for d = 1:2
        for t = 1:3
        time = times{t};
        day = days{d};
        mus = muscles{m};
            scatter(PFdata.(day).submax35.MUdata.(time).(mus).PCA.w5.explained_means(:,1),PFdata.(day).submax35.MUdata.(time).(mus).PCA.raw.w5.explained_means(:,1),'MarkerEdgeColor',c(m,:))
            hold on;
        xlabel('% Explained Smoothed');
        ylabel('% Explained Raw');
        title('35% MVC - 5s Windows');
        end
    end
end

nexttile
for m = 1:3
    for d = 1:2
        for t = 1:3
        time = times{t};
        day = days{d};
        mus = muscles{m};
            scatter(PFdata.(day).submax10.MUdata.(time).(mus).PCA.w5.explained_means(:,1),PFdata.(day).submax10.MUdata.(time).(mus).PCA.raw.w5.explained_means(:,1),'MarkerEdgeColor',c(m,:))
            hold on;
        xlabel('% Explained Smoothed');
        ylabel('% Explained Raw');
        title('10% MVC - 5s Windows');
        end
    end
end

%% Histograms of FCC % explained
for i = 1:30
dat1(i,1) = PFdata.stretch.submax10.MUdata.before.MG.PCA.w1.explained{i}(1);
dat2(i,1) = PFdata.stretch.submax10.MUdata.before.SOL.PCA.w1.explained{i}(1);
%dat2(i,1) = PFdata.stretch.submax10.MUdata.pre.MG.PCA.w1.explained{i}(1);
%dat3(i,1) = PFdata.stretch.submax10.MUdata.post.MG.PCA.w1.explained{i}(1);
end

histogram(dat1,10,'FaceColor',[0 0 1],'FaceAlpha',0.5);
hold on;
histogram(dat2,10,'FaceColor',[0 1 0],'FaceAlpha',0.5);
%histogram(dat2,10,'FaceColor',[0 1 0],'FaceAlpha',0.5);
%histogram(dat3,10,'FaceColor',[1 0 0],'FaceAlpha',0.5);

%% Boxplots
for i = 1:30
dat1(i,1) = PFdata.stretch.submax10.MUdata.before.MG.PCA.w1.explained{i}(1);
dat2(i,1) = PFdata.stretch.submax10.MUdata.before.SOL.PCA.w1.explained{i}(1);
%dat2(i,1) = PFdata.stretch.submax10.MUdata.pre.MG.PCA.w1.explained{i}(1);
%dat3(i,1) = PFdata.stretch.submax10.MUdata.post.MG.PCA.w1.explained{i}(1);
end

boxplot([dat1,dat2]);
hold on;
xs1 = repelem(1,30)';
xs2 = repelem(2,30)';
scatter(xs1,dat1)
scatter(xs2,dat2)
xlabel('MG','SOL')

%% 
nbins = 25;
tiledlayout(2,1)
nexttile
    h1 = histfit(dat1,nbins,'kernel');
    h1(1).FaceColor = [0 0 1];
    h1(1).FaceAlpha = 0.5;
    h1(2).Color = [0 0 1];
    xlim([0 100]);
    xline(mean(dat1),'LineWidth',2);
    title('MG - 1s Windows');
nexttile
    h2 = histfit(dat2,nbins,'kernel');
    h2(1).FaceColor = [0 1 0];
    h2(1).FaceAlpha = 0.5;
    h2(2).Color = [0 1 0];
    xlim([0 100]);
    xline(mean(dat2),'LineWidth',2);
    title('SOL - 1s Windows');
    xlabel('% Explained by FCC (values from all 30 windows)');