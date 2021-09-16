% pCSI plots

% Comparing 1s and 5s windows
    % Selecting variables to plot
    mus = 'MG';
    time = 'pre';
    level = 'submax10';
    day = 'control';
    window = 'w1';
    
for s = 1:length(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w1.pCSI)
    std1(s) = std(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w1.pCSI_all(s,:));
end

for s = 1:length(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w5.pCSI)
    std2(s) = std(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w5.pCSI_all(s,:));
end
std1 = std1';
std2 = std2';
% Create Plot
figure(1)
set(gcf, 'Renderer', 'painters');
    tiledlayout(2,2)

    nexttile
        histogram(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w1.pCSI_all,'FaceAlpha',0.5,'FaceColor',[1 0 0])
        hold on;
        histogram(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w5.pCSI_all,'FaceAlpha',0.5,'FaceColor',[0 0 1])
    nexttile
        plot(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w1.pCSI,'r','linewidth',2)
        hold on;
        plot(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w1.pCSI + std1,'r');
        plot(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w1.pCSI - std1,'r');
        ylim([0 0.9]);
        xlim([0 20]);
        plot(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w5.pCSI,'b','linewidth',2)
        plot(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w5.pCSI + std1,'b');
        plot(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w5.pCSI - std1,'b');
        ylim([0 0.9]);
        xlim([0 20]);
        legend('1-s windows','5-s windows');
        title('pCSI vs. # MU pairs')
        xlabel('Motor unit pairs')
        ylabel('mean Coherence 0-5 Hz')
    nexttile
        cm = hot(size(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w1.COHT,1));
        for p = 1:size(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w1.COHT,1)
            plot(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w1.F,PFdata.(day).(level).MUdata.(time).(mus).pCSI.w1.COHT(p,:),'color',cm(p,:))
            hold on;
        end
        xlim([0 25]);
        title('Coherence for 1-s windows');
        xlabel('Coherence')
        ylabel('Frequency (Hz)')
    nexttile
        cm = cool(size(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w5.COHT,1));
        for p = 1:size(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w5.COHT,1)
            plot(PFdata.(day).(level).MUdata.(time).(mus).pCSI.w5.F,PFdata.(day).(level).MUdata.(time).(mus).pCSI.w5.COHT(p,:),'color',cm(p,:))
            hold on;
        end
        xlim([0 25]);
        title('Coherence for 5-s windows');
        xlabel('Coherence')
        ylabel('Frequency (Hz)')

%% Comparing time points on same day
% Select variables
    mus = 'MG';
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
% STDs
for i = 1:size(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI_all,1)
    std1(i) = std(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI_all(i,:));
end
for i = 1:size(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI_all,1)
    std2(i) = std(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI_all(i,:));
end
for i = 1:size(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI_all,1)
    std3(i) = std(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI_all(i,:));
end
   std1 = std1';
   std2 = std2';
   std3 = std3';

% Create plot
    tiledlayout(2,1)
    nexttile
        histogram(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI_all,'FaceAlpha',0.5,'FaceColor',[1 0 0])
        hold on;
        histogram(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI_all,'FaceAlpha',0.5,'FaceColor',[0 0 1])
        histogram(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI_all,'FaceAlpha',0.5,'FaceColor',[0 1 0])
        xlabel('Coherence')
        ylabel('Count')
        legend('Trial 1','Trial 2', 'Trial 3');
    nexttile
        plot(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI,'r','linewidth',2)
        hold on;
            plot(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI + std1,'r')
            plot(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI - std1,'r')
        ylim([0 0.9]);
        xlim([0 20]);
        plot(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI,'b','linewidth',2)
            plot(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI + std2,'b')
            plot(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI - std2,'b')
        plot(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI,'g','linewidth',2)
            plot(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI + std3,'g')
            plot(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI - std3,'g')
        ylim([0 0.8]);
        xlim([0 20]);
        ylabel('Coherence')
        xlabel('# motor unit  Pairs')
        legend('Trial 1','Trial 2', 'Trial 3');
%% Overlapping histograms
cm = jet(size(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI_all,1));
for p = 1:size(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI_all,1)
    histogram(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI_all(p,:),10,'FaceAlpha',0.2,'FaceColor',cm(p,:));
    hold on;
end

%% Create cell array for smoothed histogram plot below
for r = 1:size(PFdata.(day).(level).MUdata.before.(mus).pCSI.w5.pCSI_all,1)
    data{r} = PFdata.(day).(level).MUdata.before.(mus).pCSI.w5.pCSI_all(r,:);
end

%% Generate smoothed histogram with kernel smoothing
nbins = 25;

% Create figure
    fh = figure();
% Compute axes positions with contigunous edges
    n = numel(data); 
    margins = [.13 .13 .12 .15]; %left, right, bottom, top
    height = (1-sum(margins(3:4)))/n; % height of each subplot
    width = 1-sum(margins(1:2)); %width of each sp
    vPos = linspace(margins(3),1-margins(4)-height,n); %vert pos of each sp
% Plot the histogram fits (normal density function)
    subHand = gobjects(1,n);
    histHand = gobjects(2,n);
    yLabs = {'1','2','3','4','5','6','7','8','9'};
    for i = 1:n
        subHand(i) = axes('position',[margins(1),vPos(i),width,height]); 
        histHand(:,i) = histfit(data{i},nbins,'kernel');
    end
% Link the subplot x-axes
    linkaxes(subHand,'x')
% Extend density curves to edges of xlim and fill.
    % This is easier, more readable (and maybe faster) to do in a loop. 
    xl = xlim(subHand(end));
    colors = jet(n); % Use any colormap you want
    for i = 1:n
        x = [xl(1),histHand(2,i).XData,xl([2,1])]; 
        y = [0,histHand(2,i).YData,0,0]; 
        fillHand = fill(subHand(i),x,y,colors(i,:),'FaceAlpha',0.4,'EdgeColor','k','LineWidth',1);
        % Add vertical ref lines at xtick of bottom axis
        arrayfun(@(t)xline(subHand(i),t),subHand(1).XTick); %req. >=r2018b
        % Add y axis labels
            ylh = ylabel(subHand(i),yLabs{i}); 
            %set(ylh,'Rotation',0,'HorizontalAlignment','right','VerticalAlignment','middle')
    end
% Cosmetics
    % Delete histogram bars & original density curves 
    delete(histHand)
    % remove axes (all but bottom) and 
    % add vertical ref lines at x ticks of bottom axis
    set(subHand(1),'Box','off')
    arrayfun(@(i)set(subHand(i).XAxis,'Visible','off'),2:n)
    set(subHand,'YTick',[])
    set(subHand,'XLim',xl)
title('pCSI coherence distributions created by 100 iterations of each # of pairs of MUs');
    
%% All-PFs coherence compared to each muscle individually
    % Selecting variables to plot
    level = 'submax10';
    day = 'control';
    window = 'w1';

% Create Plot
tiledlayout(1,3)
nexttile
    time = 'before';
    plot(PFdata.(day).(level).MUdata.(time).MG.pCSI.w1.pCSI,'r')
    ylim([0 1]);
    xlim([0 30]);
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).LG.pCSI.w1.pCSI,'b')
    plot(PFdata.(day).(level).MUdata.(time).SOL.pCSI.w1.pCSI,'g')
    plot(PFdata.(day).(level).MUdata.(time).pCSI.w1.pCSI,'k')
nexttile
    time = 'pre';
    plot(PFdata.(day).(level).MUdata.(time).MG.pCSI.w1.pCSI,'r')
    ylim([0 1]);
    xlim([0 30]);
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).LG.pCSI.w1.pCSI,'b')
    plot(PFdata.(day).(level).MUdata.(time).SOL.pCSI.w1.pCSI,'g')
    plot(PFdata.(day).(level).MUdata.(time).pCSI.w1.pCSI,'k')
    legend('MG','LG','SOL','All PFs');
nexttile
    time = 'post';
    plot(PFdata.(day).(level).MUdata.(time).MG.pCSI.w1.pCSI,'r')
    ylim([0 1]);
    xlim([0 30]);
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).LG.pCSI.w1.pCSI,'b')
    plot(PFdata.(day).(level).MUdata.(time).SOL.pCSI.w1.pCSI,'g')
    plot(PFdata.(day).(level).MUdata.(time).pCSI.w1.pCSI,'k')
    
%% Comparing same muscle on different days

    % Selecting variables to plot
    mus = 'MG';
    time = 'before';
    level = 'submax10';
    window = 'w1';

% Create Plot
    tiledlayout(2,2)
    nexttile
        histogram(PFdata.stretch.(level).MUdata.(time).(mus).pCSI.w1.pCSI_all,'FaceAlpha',0.5,'FaceColor',[0 1 0])
        hold on;
        histogram(PFdata.control.(level).MUdata.(time).(mus).pCSI.w1.pCSI_all,'FaceAlpha',0.5,'FaceColor',[0 0 1])
        legend('Day 1','Day 2','Location','northwest');
        title('pCSI values')
        xlabel('Coherence')
        ylabel('Count')
    nexttile
        plot(PFdata.stretch.(level).MUdata.(time).(mus).pCSI.w1.pCSI,'g')
        ylim([0 0.9]);
        xlim([0 20]);
        hold on;
        plot(PFdata.control.(level).MUdata.(time).(mus).pCSI.w1.pCSI,'b')
        ylim([0 0.9]);
        xlim([0 20]);
        legend('Day 1','Day 2');
        title('pCSI vs. # MU pairs')
        xlabel('Motor unit pairs')
        ylabel('Mean Coherence 0-5 Hz')
    nexttile
        cm = jet(size(PFdata.stretch.(level).MUdata.(time).(mus).pCSI.w1.COHT,1));
        for p = 1:size(PFdata.stretch.(level).MUdata.(time).(mus).pCSI.w1.COHT,1)
            plot(PFdata.stretch.(level).MUdata.(time).(mus).pCSI.w1.F,PFdata.stretch.(level).MUdata.(time).(mus).pCSI.w1.COHT(p,:),'color',cm(p,:))
            hold on;
        end
        xlim([0 25]);
        title('Coherence for Day 1');
        xlabel('Coherence')
        ylabel('Frequency (Hz)')
    nexttile
        cm = jet(size(PFdata.control.(level).MUdata.(time).(mus).pCSI.w1.COHT,1));
        for p2 = 1:size(PFdata.control.(level).MUdata.(time).(mus).pCSI.w1.COHT,1)
            plot(PFdata.control.(level).MUdata.(time).(mus).pCSI.w1.F,PFdata.control.(level).MUdata.(time).(mus).pCSI.w1.COHT(p2,:),'color',cm(p2,:))
            hold on;
        end
        xlim([0 25]);
        title('Coherence for Day 2');
        xlabel('Coherence')
        ylabel('Frequency (Hz)')
%% Same day, different timepoints

    % Selecting variables to plot
    mus = 'MG';
    day = 'control';
    level = 'submax10';
    window = 'w1';

% Create Plot
    tiledlayout(2,2)
    nexttile
        histogram(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.pCSI_all,'FaceAlpha',0.5,'FaceColor',[0 1 0])
        hold on;
        histogram(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.pCSI_all,'FaceAlpha',0.5,'FaceColor',[0 0 1])
        legend('Trial 1','Trial 2','Location','northwest');
        title('pCSI values')
        xlabel('Coherence')
        ylabel('Count')
    nexttile
        plot(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.pCSI,'g')
        ylim([0 0.9]);
        xlim([0 20]);
        hold on;
        plot(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.pCSI,'b')
        ylim([0 0.9]);
        xlim([0 20]);
        legend('trial 1','Trial 2');
        title('pCSI vs. # MU pairs')
        xlabel('Motor unit pairs')
        ylabel('Mean Coherence 0-5 Hz')
    nexttile
        cm = jet(size(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.COHT,1));
        for p = 1:size(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.COHT,1)
            plot(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.F,PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.COHT(p,:),'color',cm(p,:))
            hold on;
        end
        xlim([0 25]);
        ylim([0 0.9]);
        title('Coherence for Trial 1');
        xlabel('Coherence')
        ylabel('Frequency (Hz)')
    nexttile
        cm = jet(size(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.COHT,1));
        for p2 = 1:size(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.COHT,1)
            plot(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.F,PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.COHT(p2,:),'color',cm(p2,:))
            hold on;
        end
        xlim([0 25]);
        ylim([0 0.9]);
        title('Coherence for Trial 2');
        xlabel('Coherence')
        ylabel('Frequency (Hz)')
        
%% Comparing force levels on same day
    % Selecting variables to plot
    mus = 'MG';
    time = 'before';
    day = 'stretch';
    window = 'w1';
    
for s = 1:length(PFdata.(day).submax10.MUdata.(time).(mus).pCSI.w1.pCSI)
    std1(s) = std(PFdata.(day).submax10.MUdata.(time).(mus).pCSI.w1.pCSI_all(s,:));
end

for s = 1:length(PFdata.(day).submax35.MUdata.(time).(mus).pCSI.w1.pCSI)
    std2(s) = std(PFdata.(day).submax35.MUdata.(time).(mus).pCSI.w1.pCSI_all(s,:));
end
std1 = std1';
std2 = std2';
% Create Plot
figure(1)
set(gcf, 'Renderer', 'painters');
    tiledlayout(2,2)

    nexttile
        histogram(PFdata.(day).submax10.MUdata.(time).(mus).pCSI.w1.pCSI_all,'FaceAlpha',0.5,'FaceColor',[1 0 0])
        hold on;
        histogram(PFdata.(day).submax35.MUdata.(time).(mus).pCSI.w5.pCSI_all,'FaceAlpha',0.5,'FaceColor',[0 0 1])
    nexttile
        plot(PFdata.(day).submax10.MUdata.(time).(mus).pCSI.w1.pCSI,'r','linewidth',2)
        hold on;
        plot(PFdata.(day).submax10.MUdata.(time).(mus).pCSI.w1.pCSI + std1,'r');
        plot(PFdata.(day).submax10.MUdata.(time).(mus).pCSI.w1.pCSI - std1,'r');
        ylim([0 0.9]);
        xlim([0 20]);
        plot(PFdata.(day).submax35.MUdata.(time).(mus).pCSI.w1.pCSI,'b','linewidth',2)
        plot(PFdata.(day).submax35.MUdata.(time).(mus).pCSI.w1.pCSI + std2,'b');
        plot(PFdata.(day).submax35.MUdata.(time).(mus).pCSI.w1.pCSI - std2,'b');
        ylim([0 0.9]);
        xlim([0 20]);
        legend('1-s windows','5-s windows');
        title('pCSI vs. # MU pairs')
        xlabel('Motor unit pairs')
        ylabel('mean Coherence 0-5 Hz')
    nexttile
        cm = hot(size(PFdata.(day).submax10.MUdata.(time).(mus).pCSI.w1.COHT,1));
        for p = 1:size(PFdata.(day).submax10.MUdata.(time).(mus).pCSI.w1.COHT,1)
            plot(PFdata.(day).submax10.MUdata.(time).(mus).pCSI.w1.F,PFdata.(day).submax10.MUdata.(time).(mus).pCSI.w1.COHT(p,:),'color',cm(p,:))
            hold on;
        end
        xlim([0 25]);
        title('Coherence for 10% mvc');
        xlabel('Coherence')
        ylabel('Frequency (Hz)')
    nexttile
        cm = cool(size(PFdata.(day).submax35.MUdata.(time).(mus).pCSI.w1.COHT,1));
        for p = 1:size(PFdata.(day).submax35.MUdata.(time).(mus).pCSI.w1.COHT,1)
            plot(PFdata.(day).submax35.MUdata.(time).(mus).pCSI.w1.F,PFdata.(day).submax35.MUdata.(time).(mus).pCSI.w1.COHT(p,:),'color',cm(p,:))
            hold on;
        end
        xlim([0 25]);
        title('Coherence for 35% mvc');
        xlabel('Coherence')
        ylabel('Frequency (Hz)')
        
%% All contractions to compare forces
        plot(PFdata.stretch.submax10.MUdata.before.(mus).pCSI.w1.pCSI,'r','linewidth',2)
            hold on;
        plot(PFdata.stretch.submax10.MUdata.pre.(mus).pCSI.w1.pCSI,'r','linewidth',2)
        plot(PFdata.stretch.submax10.MUdata.post.(mus).pCSI.w1.pCSI,'r','linewidth',2)
        plot(PFdata.control.submax10.MUdata.before.(mus).pCSI.w1.pCSI,'r','linewidth',2)
        plot(PFdata.control.submax10.MUdata.pre.(mus).pCSI.w1.pCSI,'r','linewidth',2)
        plot(PFdata.control.submax10.MUdata.post.(mus).pCSI.w1.pCSI,'r','linewidth',2)

        plot(PFdata.stretch.submax35.MUdata.before.(mus).pCSI.w1.pCSI,'b','linewidth',2)
        plot(PFdata.stretch.submax35.MUdata.pre.(mus).pCSI.w1.pCSI,'b','linewidth',2)
        plot(PFdata.stretch.submax35.MUdata.post.(mus).pCSI.w1.pCSI,'b','linewidth',2)
        plot(PFdata.control.submax35.MUdata.before.(mus).pCSI.w1.pCSI,'b','linewidth',2)
        plot(PFdata.control.submax35.MUdata.pre.(mus).pCSI.w1.pCSI,'b','linewidth',2)
        plot(PFdata.control.submax35.MUdata.post.(mus).pCSI.w1.pCSI,'b','linewidth',2)
        
        title('pCSI vs. # MU pairs')
        xlabel('Motor unit pairs')
        ylabel('mean Coherence 0-5 Hz')
        
%% whole contraction
mus = 'MG';
% plot 1
for p = 1:100
    scatter(1:9,PFdata.stretch.submax10.MUdata.before.(mus).pCSI.w5.pCSI_all(:,p),'r')
    hold on;
end

% plot 2
plot(PFdata.stretch.submax10.MUdata.before.(mus).pCSI.w5.pCSI,'k');

%% pCSI_COH again
test = [];
for i = 1:size(PFdata.stretch.submax10.MUdata.before.(mus).binary,1)
    if sum(PFdata.stretch.submax10.MUdata.before.(mus).binary(i,:)) == 0
    else
    test = vertcat(test,PFdata.stretch.submax10.MUdata.before.(mus).binary(i,:));
    end
end

[F,COHT,pCSI_all,pCSI] = pCSI_COH_new(test,5,2000,100);

%
for p = 1:100
    scatter(1:18,pCSI_all(:,p),'r')
    hold on;
end
% retry plot 2
plot(pCSI,'k');
hold on;
plot(PFdata.stretch.submax10.MUdata.before.(mus).pCSI.w5.pCSI,'r');
