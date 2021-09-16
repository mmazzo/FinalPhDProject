day = 'stretch';
level = 'submax10';
time = 'before';
mus = 'MG';


%% PCA iteration plots
tiledlayout(1,3)
set(gcf, 'Renderer', 'painters');
nexttile
    % 1s windows
    cm = jet(30);
    for p = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means)
        plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_means{p}(2:end),'Color','b');
        hold on;
        plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean(2:end),'k','LineWidth',2);
    end
    ylim([0 100])
    xlabel('# of Motor Units Contributing to PCA')
    ylabel('% of Variance Explained by FCC')
    legend('Window 1');
nexttile
    % 5s windows
    cm = jet(30);
    for p = 1:length(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained_means)
        plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained_means{p}(2:end),'Color','r');
        hold on;
        plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained_mean(2:end),'k','LineWidth',2);
    end
    ylim([0 100])
    xlabel('# of Motor Units Contributing to PCA')
    ylabel('% of Variance Explained by FCC')
    legend('Window 1');
    title('% Explained by FCC for each window as a function of # MUs included')
% 1s vs 5s windows
std1 = zeros(30,19);
vec = zeros(30,19);
for s = 1:30
    num = length(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w1.explained_means{s});
    vec(s,1:num) = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w1.explained_means{s};
    vec(vec == 0) = NaN;
    std1(s,1:19) = nanstd(vec);
end
std1(std1 == 0) = NaN;
std1 = nanmean(std1); std1(2) = 0;

std2 = zeros(6,19);
vec = zeros(6,19);
for s = 1:6
    num = length(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained_means{s});
    vec(s,1:num) = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained_means{s};
    vec(vec == 0) = NaN;
    std2(s,1:19) = nanstd(vec);
end
std2(std2 == 0) = NaN;
std2 = nanmean(std2); std2(2) = 0;

std1 = std1(2:end);
std2 = std2(2:end);

nexttile
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean(2:19),'b','LineWidth',2); hold on; 
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained_mean(2:18),'r','LineWidth',2);
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean(2:19)+std1,'b');
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean(2:19)-std1,'b');
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained_mean(2:18)+std2(1:17),'r');
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained_mean(2:18)-std2(1:17),'r');
    ylim([0 100])
    xlim([0 19])
    legend('1-s Window','5-s Window');
    xlabel('# of Motor Units Contributing to PCA')
    ylabel('% of Variance Explained by FCC')

%% Comparing muscles
% All-PFs coherence compared to each muscle individually
    % Selecting variables to plot
    level = 'submax10';
    day = 'stretch';
    window = 'w1';

% Create Plot
tiledlayout(1,3)
nexttile
    time = 'before';
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean,'r')
    %ylim([0 1]);
    %xlim([0 30]);
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.explained_mean,'b')
    plot(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.explained_mean,'g')
    plot(PFdata.(day).(level).MUdata.(time).PCA.iter.w1.explained_mean,'k')
nexttile
    time = 'pre';
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean,'r')
    %ylim([0 1]);
    %xlim([0 30]);
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.explained_mean,'b')
    plot(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.explained_mean,'g')
    plot(PFdata.(day).(level).MUdata.(time).PCA.iter.w1.explained_mean,'k')
    legend('MG','LG','SOL','All PFs');
nexttile
    time = 'post';
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.explained_mean,'r')
    %ylim([0 1]);
    %xlim([0 30]);
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.explained_mean,'b')
    plot(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.explained_mean,'g')
    plot(PFdata.(day).(level).MUdata.(time).PCA.iter.w1.explained_mean,'k')
    

%% Plot fitted curves for three contractions
plot(PFdata.(day).(level).MUdata.before.MG.PCA.iter.w1.fit,'r')
hold on;
plot(PFdata.(day).(level).MUdata.pre.MG.PCA.iter.w1.fit,'b')
plot(PFdata.(day).(level).MUdata.post.MG.PCA.iter.w1.fit,'g')

%%  just one window
time = 'before';
win = 3;

num = length(PFdata.(day).submax10.MUdata.(time).MG.PCA.iter.w5.explained{win});
stdev = zeros(1,num);

set(gcf, 'Renderer', 'painters');
for i = 1:num
   temp = PFdata.(day).submax10.MUdata.(time).MG.PCA.iter.w5.explained{win}{i};
   if isempty(temp)
       stdev(i) = [];
   else
       stdev(i) = std(temp);
   end
end

stdev(stdev == 0) = NaN;
m = PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained_means{win};
m(m == 0) = 100;

tiledlayout(1,2)
nexttile
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained_means{win} + stdev,'r')
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained_means{win} - stdev,'r')
    plot(m,'r','linewidth',2)
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.fit,'--k')
    ylim([50 100])
nexttile
    for p = 2:num
        for i = 1:100
        scatter(p,PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained{win}{p}(i),'c')
        hold on;
        end
    end
    plot(m,'r','linewidth',2)
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.fit,'--k')
    ylim([50 100])

%% PLot all coeffs for one window
figure(1)
time = 'before';
day = 'stretch';

set(gcf, 'Renderer', 'painters');
cm = jet(size(PFdata.(day).submax10.MUdata.(time).MG.PCA.iter.w5.coeffs_mean{win},1));
for i = 1:size(PFdata.(day).submax10.MUdata.(time).MG.PCA.iter.w5.coeffs_mean{win},1)
    temp = PFdata.(day).submax10.MUdata.(time).MG.PCA.iter.w5.coeffs_mean{win};
    plot(temp(i,:),'color',cm(i,:));
    hold on;
end

%% PLot all coeff itertions for one window
win = 3;
set(gcf, 'Renderer', 'painters');
cm = jet(size(PFdata.(day).submax10.MUdata.(time).MG.PCA.iter.w5.coeffs_mean{win},1));
for i = 1:size(PFdata.(day).submax10.MUdata.(time).MG.PCA.iter.w5.coeffs_mean{win},1)
    temp = PFdata.(day).submax10.MUdata.(time).MG.PCA.iter.w5.coeffs_mean{win};
    plot(temp(i,:),'color',cm(i,:));
    hold on;
end

%% All windows smoothed histograms

% Create cell array for smoothed histogram plot below

% single window
data = PFdata.(day).(level).MUdata.before.(mus).PCA.iter.w1.explained{3}(2:end);

% all windows
    data2 = cell(1,18);
    for w = 1:30
    temp = PFdata.(day).(level).MUdata.before.(mus).PCA.iter.w1.explained{w}(2:end);
        for c = 1:length(temp)
            data2{c} = horzcat(data2{c},temp{c});
        end
    end
    data = data2;
%% Generate smoothed histogram with kernel smoothing
nbins = 25;

set(gcf, 'Renderer', 'painters');

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
    yLabs = {'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18'};
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
title('PCA % explained distributions created by 100 iterations of each # of MUs included');
    
%% Comparing time points on same day
% Select variables
    mus = 'MG';
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
    
% calculate STD    
std1 = zeros(30,19);
vec = zeros(30,19);
for s = 1:30
    num = length(PFdata.(day).(level).MUdata.before.(mus).PCA.iter.w1.explained_means{s});
    vec(s,1:num) = PFdata.(day).(level).MUdata.before.(mus).PCA.iter.w1.explained_means{s};
    vec(vec == 0) = NaN;
    std1(s,1:19) = nanstd(vec);
end
std1(std1 == 0) = NaN;
std1 = nanmean(std1); std1(2) = 0;

std2 = zeros(30,30);
vec = zeros(30,30);
for s = 1:30
    num = length(PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.w1.explained_means{s});
    vec(s,1:num) = PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.w1.explained_means{s};
    vec(vec == 0) = NaN;
    std2(s,1:30) = nanstd(vec);
end
std2(std2 == 0) = NaN;
std2 = nanmean(std2); std2(2) = 0;

std3 = zeros(30,19);
vec = zeros(30,19);
for s = 1:30
    num = length(PFdata.(day).(level).MUdata.post.(mus).PCA.iter.w1.explained_means{s});
    vec(s,1:num) = PFdata.(day).(level).MUdata.post.(mus).PCA.iter.w1.explained_means{s};
    vec(vec == 0) = NaN;
    std3(s,1:19) = nanstd(vec);
end
std3(std3 == 0) = NaN;
std3 = nanmean(std3); std3(2) = 0;
 

% for histogram
dat1 = zeros(30,19);
for s = 1:30
    num = length(PFdata.(day).(level).MUdata.before.(mus).PCA.iter.w1.explained_means{s});
    dat1(s,1:num) = PFdata.(day).(level).MUdata.before.(mus).PCA.iter.w1.explained_means{s};
    dat1(dat1 == 0) = NaN;
end

dat2 = zeros(30,30);
for s = 1:30
    num = length(PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.w1.explained_means{s});
    dat2(s,1:num) = PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.w1.explained_means{s};
    dat2(dat2 == 0) = NaN;
end

dat3 = zeros(30,19);
for s = 1:30
    num = length(PFdata.(day).(level).MUdata.post.(mus).PCA.iter.w1.explained_means{s});
    dat3(s,1:num) = PFdata.(day).(level).MUdata.post.(mus).PCA.iter.w1.explained_means{s};
    dat3(dat3 == 0) = NaN;
end
    
% Create plot
    tiledlayout(2,1)
    nexttile
        histogram(dat1,'FaceAlpha',0.5,'FaceColor',[1 0 0])
        hold on;
        histogram(dat2,'FaceAlpha',0.5,'FaceColor',[0 0 1])
        histogram(dat3,'FaceAlpha',0.5,'FaceColor',[0 1 0])
        xlabel('% explained')
        ylabel('Count')
        legend('Trial 1','Trial 2', 'Trial 3');
    nexttile
        plot(PFdata.(day).(level).MUdata.before.(mus).PCA.iter.(window).explained_mean,'r','linewidth',2)
        hold on;
            plot(PFdata.(day).(level).MUdata.before.(mus).PCA.iter.(window).explained_mean(1:19)+std1,'r')
            plot(PFdata.(day).(level).MUdata.before.(mus).PCA.iter.(window).explained_mean(1:19)-std1,'r')
        plot(PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.(window).explained_mean,'b','linewidth',2)
            plot(PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.(window).explained_mean+std2,'b')
            plot(PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.(window).explained_mean-std2,'b')
        plot(PFdata.(day).(level).MUdata.post.(mus).PCA.iter.(window).explained_mean,'g','linewidth',2)
            plot(PFdata.(day).(level).MUdata.post.(mus).PCA.iter.(window).explained_mean(1:19)+std3,'g')
            plot(PFdata.(day).(level).MUdata.post.(mus).PCA.iter.(window).explained_mean(1:19)-std3,'g')
        %ylim([0 0.8]);
        %xlim([0 20]);
        ylabel('% explained')
        xlabel('# motor unit  Pairs')
       %legend('Trial 1','Trial 2', 'Trial 3');
       
%% Comparing force levels on same day
% Select variables
    mus = 'MG';
    day = 'control';
    window = 'w1';
    
% calculate STD    
std1 = zeros(30,19);
vec = zeros(30,19);
for s = 1:30
    num = length(PFdata.(day).submax10.MUdata.before.(mus).PCA.iter.w1.explained_means{s});
    vec(s,1:num) = PFdata.(day).submax10.MUdata.before.(mus).PCA.iter.w1.explained_means{s};
    vec(vec == 0) = NaN;
    std1(s,1:19) = nanstd(vec);
end
std1(std1 == 0) = NaN;
std1 = nanmean(std1); std1(2) = 0;

std2 = zeros(30,30);
vec = zeros(30,30);
for s = 1:30
    num = length(PFdata.(day).submax35.MUdata.pre.(mus).PCA.iter.w1.explained_means{s});
    vec(s,1:num) = PFdata.(day).submax35.MUdata.pre.(mus).PCA.iter.w1.explained_means{s};
    vec(vec == 0) = NaN;
    std2(s,1:30) = nanstd(vec);
end
std2(std2 == 0) = NaN;
std2 = nanmean(std2); std2(2) = 0;

% Create plot
        plot(PFdata.(day).submax10.MUdata.before.(mus).PCA.iter.(window).explained_mean,'r','linewidth',2)
        hold on;
            plot(PFdata.(day).submax10.MUdata.before.(mus).PCA.iter.(window).explained_mean(1:19)+std1,'r')
            plot(PFdata.(day).submax10.MUdata.before.(mus).PCA.iter.(window).explained_mean(1:19)-std1,'r')
        plot(PFdata.(day).submax35.MUdata.before.(mus).PCA.iter.(window).explained_mean,'b','linewidth',2)
            plot(PFdata.(day).submax35.MUdata.before.(mus).PCA.iter.(window).explained_mean+std2,'b')
            plot(PFdata.(day).submax35.MUdata.before.(mus).PCA.iter.(window).explained_mean-std2,'b')
        ylabel('% explained')
        xlabel('# motor unit  Pairs')
 
%% force levels - no std but all contractions
    mus = 'MG';
    window = 'w1';
        plot(PFdata.stretch.submax10.MUdata.before.(mus).PCA.iter.(window).explained_mean,'r','linewidth',2)
        hold on;
        plot(PFdata.stretch.submax10.MUdata.pre.(mus).PCA.iter.(window).explained_mean,'r','linewidth',2)
        plot(PFdata.stretch.submax10.MUdata.post.(mus).PCA.iter.(window).explained_mean,'r','linewidth',2)
        plot(PFdata.stretch.submax35.MUdata.before.(mus).PCA.iter.(window).explained_mean,'b','linewidth',2)
        plot(PFdata.stretch.submax35.MUdata.pre.(mus).PCA.iter.(window).explained_mean,'b','linewidth',2)
        plot(PFdata.stretch.submax35.MUdata.post.(mus).PCA.iter.(window).explained_mean,'b','linewidth',2)
        
        plot(PFdata.control.submax10.MUdata.before.(mus).PCA.iter.(window).explained_mean,'r','linewidth',2)
        hold on;
        plot(PFdata.control.submax10.MUdata.pre.(mus).PCA.iter.(window).explained_mean,'r','linewidth',2)
        plot(PFdata.control.submax10.MUdata.post.(mus).PCA.iter.(window).explained_mean,'r','linewidth',2)
        plot(PFdata.control.submax35.MUdata.before.(mus).PCA.iter.(window).explained_mean,'b','linewidth',2)
        plot(PFdata.control.submax35.MUdata.pre.(mus).PCA.iter.(window).explained_mean,'b','linewidth',2)
        plot(PFdata.control.submax35.MUdata.post.(mus).PCA.iter.(window).explained_mean,'b','linewidth',2)
        ylabel('% explained')
        xlabel('# motor unit  Pairs')
%% Comparing muscles with FITTED CURVES
% All-PFs coherence compared to each muscle individually
    % Selecting variables to plot
    level = 'submax10';
    day = 'stretch';
    window = 'w1';

% Create Plot
    time = 'before';
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.fit,'r')
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.fit,'b')
    plot(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.fit,'g')
    plot(PFdata.(day).(level).MUdata.(time).PCA.iter.w1.fit,'k')
    
% next plot
    time = 'pre';
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.fit,'r')
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.fit,'b')
    plot(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.fit,'g')
    plot(PFdata.(day).(level).MUdata.(time).PCA.iter.w1.fit,'k')
    legend('MG','LG','SOL','All PFs');

    % next plot
    time = 'post';
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.fit,'r')
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.fit,'b')
    plot(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.fit,'g')
    plot(PFdata.(day).(level).MUdata.(time).PCA.iter.w1.fit,'k')
    
%% Plot original data & fitted lines
day = 'stretch';
level = 'submax10';
time = 'before';
mus = 'MG';

% STD
std2 = zeros(6,19);
vec = zeros(6,19);
for s = 1:6
    num = length(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained_means{s});
    vec(s,1:num) = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained_means{s};
    vec(vec == 0) = NaN;
    std2(s,1:19) = nanstd(vec);
end
std2(std2 == 0) = NaN;
std2 = nanmean(std2); std2(2) = 0;

std2 = std2(2:end);

% plot 1
    plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained_mean(2:end),'k','linewidth',2)
    hold on;
    %plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained_mean + std2,'r')
    %plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained_mean - std2,'r')
    for p = 1:6
        plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained_means{p}(2:end),'r','linewidth',1)
    end
    % every iteration
    vec1 = zeros(6,19);
    for w = 1:6
        num = length(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained{w});
        vec1(w,1:num) = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained{w};
        vec2(vec2 == 0) = NaN;
    end
    
    for w = 1:6
        num = length(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained{w});
        for mu = 2:num
            dat = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained{w}{mu}(1:10);
            scatter(repelem(mu,10),dat,'r')
            hold on;
        end
    end
% plot 2
    plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.fit,'k')
    
%% Boxplots across # MUs
for w = 1:30
    % minimum highest # of MUs = 16
    boxdat(w,1:16) = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w1.explained_mean{w}(1:16);
end

boxplot(boxdat)


%% boxpot across contraction with explained %
for w = 1:30
    % minimum highest # of MUs = 16
    % arbitrarily chosing 10 MUs instead
    n = 10;
    longdat1(w,1:100) = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w1.explained{w}{n};
end

for w = 1:6
    % minimum highest # of MUs = 16
    % arbitrarily chosing 10 MUs instead
    n = 10;
    longdat5(w,1:100) = PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained{w}{n};
end

tiledlayout(2,1)
nexttile
    boxplot(longdat1')
    hold on;
    % scatter across whole contractions with mean values for min num MUs
    for w = 1:30
        scatter(w,PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w1.explained_means{w}(16),'k','filled');
        hold on;
    end
nexttile
    boxplot(longdat5')
    hold on;
    % scatter across whole contractions with mean values for min num MUs
    for w = 1:6
        scatter(w,PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.w5.explained_means{w}(16),'k','filled');
        hold on;
    end
    
%% whole contraction
    for w = 1:6
        for i = 1:16
        boxdat(i,w) = PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained_means{w}(i);
        end
    end
    boxplot(boxdat'); hold on;
    plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.explained_mean,'r','linewidth',2)
    %plot(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w5.fit,'--k')
    ylim([30 100])
    
