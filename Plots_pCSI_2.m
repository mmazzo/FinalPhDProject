%% Create cell array for smoothed histogram plot below
% Selecting variables to plot
mus = 'SOL';
%time = 'before';
level = 'submax10';
day = 'control';
window = 'w1';

% Data 1
for r = 1:size(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI_all,1)
    data1{r} = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI_all(r,:);
end
% Data 2
for r = 1:size(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI_all,1)
    data2{r} = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI_all(r,:);
end
%% Generate smoothed histogram with kernel smoothing
nbins = 25;

% Create figure
    fh = figure();
% Compute axes positions with contigunous edges
    n1 = numel(data1); n2 = numel(data2); ns = [n1,n2];
    [n,~] = min(ns);
    margins = [.13 .13 .12 .15]; %left, right, bottom, top
    height = (1-sum(margins(3:4)))/n; % height of each subplot
    width = 1-sum(margins(1:2)); %width of each sp
    vPos = linspace(margins(3),1-margins(4)-height,n); %vert pos of each sp
% Plot the histogram fits (normal density function)
    subHand = gobjects(1,n);
    histHand1 = gobjects(2,n);
    histHand2 = gobjects(2,n);
    yLabs = {'1','2','3','4','5'};
    for i = 1:n
        subHand(i) = axes('position',[margins(1),vPos(i),width,height]); 
        histHand1(:,i) = histfit(data1{i},nbins,'kernel');
        hold on;
        histHand2(:,i) = histfit(data2{i},nbins,'kernel');
    end
% Link the subplot x-axes
    linkaxes(subHand,'x')
% Extend density curves to edges of xlim and fill.
    % This is easier, more readable (and maybe faster) to do in a loop. 
    xl = xlim(subHand(end));
    colors = jet(n); % Use any colormap you want
    for i = 1:n
        x1 = [xl(1),histHand1(2,i).XData,xl([2,1])]; 
        y1 = [0,histHand1(2,i).YData,0,0]; 
        fillHand = fill(subHand(i),x1,y1,colors(i,:),'FaceAlpha',0.2,'EdgeColor','k','LineWidth',1);
        hold on;
        x2 = [xl(1),histHand2(2,i).XData,xl([2,1])]; 
        y2 = [0,histHand2(2,i).YData,0,0]; 
        fillHand = fill(subHand(i),x2,y2,colors(i,:),'FaceAlpha',0.6,'EdgeColor','k','LineWidth',1);
        % Add vertical ref lines at xtick of bottom axis
        %arrayfun(@(t)xline(subHand(i),t),subHand(1).XTick); %req. >=r2018b
        % Add y axis labels
            ylh = ylabel(subHand(i),yLabs{i}); 
            %set(ylh,'Rotation',0,'HorizontalAlignment','right','VerticalAlignment','middle')
    end
% Cosmetics
    % Delete histogram bars & original density curves 
    delete(histHand1)
    delete(histHand2)
    % remove axes (all but bottom) and 
    % add vertical ref lines at x ticks of bottom axis
    set(subHand(1),'Box','off')
    arrayfun(@(i)set(subHand(i).XAxis,'Visible','off'),2:n)
    set(subHand,'YTick',[])
    set(subHand,'XLim',xl)

%%
%% Comparing time points on same day
% Create plot
    tiledlayout(2,1)
    nexttile
        histogram(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI_all,'FaceAlpha',0.2,'FaceColor',[1 0 0])
        hold on;
        histogram(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI_all,'FaceAlpha',0.5,'FaceColor',[1 0 0])
        xlabel('Coherence')
        ylabel('Count')
        legend('Trial 1','Trial 2');
    nexttile
        plot(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI,'Color',[1 0.6 0.6])
        ylim([0 0.9]);
        xlim([0 20]);
        hold on;
        plot(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI,'Color',[1 0 0])
        ylim([0 0.8]);
        xlim([0 20]);
        ylabel('Coherence')
        xlabel('# motor unit  Pairs')
        legend('Trial 1','Trial 2', 'Trial 3');