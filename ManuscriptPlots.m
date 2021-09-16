% Publication plots - Example Data
% SFU15 Stretch 10 Before
day = 'stretch';
level = 'submax10';
time = 'before';

%% CST
    figure(1)
    plot(PFdata.(day).(level).MUdata.(time).MG.cst,'c');
    hold on;
    plot(PFdata.(day).(level).MUdata.(time).LG.cst,'b');
    plot(PFdata.(day).(level).MUdata.(time).SOL.cst,'g');
    plot(PFdata.(day).(level).MUdata.(time).cst,'k');
    
    figure(2)
    tiledlayout(2,1)
    nexttile
        s = PFdata.(day).(level).MUdata.(time).w5.starts(3);
        e = PFdata.(day).(level).MUdata.(time).w5.endds(3);
        plot(PFdata.(day).(level).MUdata.(time).MG.cst(s:e),'c');
        hold on;
        plot(PFdata.(day).(level).MUdata.(time).LG.cst(s:e),'b');
        plot(PFdata.(day).(level).MUdata.(time).SOL.cst(s:e),'g');
        plot(PFdata.(day).(level).MUdata.(time).cst(s:e),'k');
    nexttile
        plot(normalize(PFdata.(day).(level).MUdata.(time).MG.cst(s:e)),'c');
        hold on;
        plot(normalize(PFdata.(day).(level).MUdata.(time).LG.cst(s:e)),'b');
        plot(normalize(PFdata.(day).(level).MUdata.(time).SOL.cst(s:e)),'g');
        plot(normalize(PFdata.(day).(level).MUdata.(time).cst(s:e)),'k');
           
%% Force + Raster plot
mus = 'MG';

    plotSpikeRaster(logical(PFdata.(day).(level).MUdata.(time).binary_ordered),'PlotType','vertline', 'VertSpikeHeight',0.5);
        yyaxis right
    plot(PFdata.(day).(level).force.(time).filt{1,1});
        hold on;
        
        for i = 1:30
        xline(PFdata.stretch.submax10.MUdata.before.w1.starts(i),'Color','cyan');
        end
        xline(PFdata.stretch.submax10.MUdata.before.w1.endds(end),'Color','cyan')
        
        for ii = 1:6
        xline(PFdata.stretch.submax10.MUdata.before.w5.starts(ii),'Color','Red');
        end
        xline(PFdata.stretch.submax10.MUdata.before.w5.endds(end),'Color','Red')
%% force vs total PF cst
tiledlayout(3,1)
nexttile
    yyaxis left
    plot(PFdata.(day).(level).force.(time).filt{1,1},'k');
    yyaxis right
    plot(PFdata.(day).(level).MUdata.(time).cst,'r');
nexttile
    s = PFdata.(day).(level).MUdata.(time).w5.starts(3);
    e = PFdata.(day).(level).MUdata.(time).w5.endds(3);
    yyaxis left
    plot(PFdata.(day).(level).force.(time).filt{1,1}(s:e),'k');
    yyaxis right
    plot(PFdata.(day).(level).MUdata.(time).cst(s:e),'r');
nexttile
    yyaxis left
    rawcst = sum(PFdata.(day).(level).MUdata.(time).binary(:,s:e));
    plot(rawcst,'k');
    yyaxis right
    plot(PFdata.(day).(level).MUdata.(time).cst(s:e),'r');
%% All forces
tiledlayout(1,3)

nexttile
plot(PFdata.control.submax10.force.before.filt{1,1});
hold on;
plot(PFdata.control.submax35.force.before.filt{1,2});

nexttile
plot(PFdata.control.submax10.force.pre.filt{1,1});
hold on;
plot(PFdata.control.submax35.force.pre.filt{1,2});

nexttile
plot(PFdata.control.submax10.force.post.filt{1,1});
hold on;
plot(PFdata.control.submax35.force.post.filt{1,2});

%% Single motor units
day = 'stretch';
level = 'submax10';
time = 'before';
win = 3;

%% order by mean value
lines = [PFdata.(day).(level).MUdata.(time).MG.lines,PFdata.(day).(level).MUdata.(time).LG.lines,PFdata.(day).(level).MUdata.(time).SOL.lines];

s = PFdata.(day).(level).MUdata.(time).w5.starts(win);
e = PFdata.(day).(level).MUdata.(time).w5.endds(win);

for i = 1:length(lines)
    if isnan(lines{i})
    else
    pks(i) = max(lines{i});
    subset(i,:) = lines{i}(s:e);
    means(i) = nanmean(lines{i}(s:e));
    end
end

out = (means~=0);
cm = flipud(jet(length(means(out))));
[~,ind] = sort(means(out),'descend');
subset = subset(out,:);
ind = ind';
nums = sortrows(ind);
for i = 1:length(ind)
    ii = ind(i);
    neword(ii) = nums(i);
end

% Plot
figure(1)
tiledlayout(3,1)
set(gcf, 'Renderer', 'painters');

nexttile
    for i = 1:size(subset,1)
        col = neword(i);
        plot(subset(i,:),'color',cm(col,:));
        hold on;
    end

nexttile
yyaxis right
    num = size(PFdata.(day).(level).MUdata.(time).PCA.iter.w5.coeffs_mean{win},1);
    plot(PFdata.(day).(level).MUdata.(time).PCA.iter.w5.coeffs_mean{win}(num,:));
    ylabel('Mean First PC Coeff')
yyaxis left
    % CST is 800 datapoints ahead
    pad =zeros(1,800);
    newcst = [pad,PFdata.(day).(level).MUdata.(time).cst];
    plot(highpass(newcst(s:e),0.75,2000))
    ylabel('CST')

nexttile
    for i = 1:size(subset,1)
        if sum(subset(i,:)) == 0
        elseif isnan(sum(subset(i,:)))
        else
        col = neword(i);
        plot(highpass(subset(i,:),0.75,2000),'color',cm(col,:));
        end
        hold on;
    end
%% Reorder & plot whole contraction
out = (pks~=0);
cm = flipud(jet(length(pks(out))));
[neworder,ind] = sort(pks(out),'descend');
lines = lines(out);
ind = ind';
nums = sortrows(ind);
for i = 1:length(ind)
    ii = ind(i);
    neword2(ii) = nums(i);
end
 
figure(2)
tiledlayout(2,1)
set(gcf, 'Renderer', 'painters');
nexttile
    yyaxis left
    for i = 1:size(lines,2)
        col = neword2(i);
        plot(lines{i},'-','color',cm(col,:)); 
        hold on;
    end
    yyaxis right
    plot(newcst,'black','linewidth',2)
    
nexttile
    yyaxis left
    for i = 1:size(subset,1)
        col = neword(i);
        plot(subset(i,:),'-','color',cm(col,:));
        hold on;
    end
    yyaxis right
    plot(newcst(s:e),'black','linewidth',2)

%%
win = 3;
s = PFdata.(day).(level).MUdata.(time).w5.starts(win);
e = PFdata.(day).(level).MUdata.(time).w5.endds(win);
plotSpikeRaster(logical(PFdata.(day).(level).MUdata.(time).binary_ordered(:,s:e)),'PlotType','vertline', 'VertSpikeHeight',0.5);
%%   
plot(PFdata.(day).(level).force.(time).filt{1,1}(s:e));

%% Plot all % explained lines
cm = jet(23);
% 35% MVC w5
dat = PFvecs.w1.expl_perm_mean;
dat(dat == 0) = NaN;
for p = 1:114
    % get subject number
    sub = PFvecs.subs{p};
    ss = split(sub,'U'); 
    if ss{2}(1) == '0'
        s = str2num(ss{2}(2));
    else
        s = str2num(ss{2}(1:2));
    end
    temp = dat(p,:);
    temp = temp(~isnan(temp));
    if length(temp) > 4
    checktemp = temp(end-4:end);
        if any(abs(diff(checktemp)) > 0.5)
            temp = temp(1:end-4);
        end
        if length(temp) < 3
        else
            xdat = 2:length(temp)+1;
            % Fit: Exponential decay
                [xData, yData] = prepareCurveData(xdat, temp);

                % Set up fittype and options.
                ft = fittype('power2');
                opts = fitoptions('Method', 'NonlinearLeastSquares');
                opts.Display = 'Off';
                opts.StartPoint = [132.017584800342 -0.351447188884657 -0.816513622725634];

                % Fit model to data.
                [fitresult, gof] = fit(xData, yData, ft, opts);

                % Save coefficients
                %coeffs = coeffvalues(fitresult);

                % Find the point at which the change in % variance explained with 
                %  an additional MU added to the analysis is < 0.1
                %         a = coeffs(1);
                %         b = coeffs(2);
                %         c = coeffs(3);
                % 
                %         for x = 1:500
                %             y(x) = a*(x^b)+c;
                %         end
                
                % get values
                ydat = fitresult(xData);
                plot(xData,ydat,'color',cm(s,:));  % plot(fitresult, xData, yData);
                hold on;
                xlim([0, 70]);
                ylim([0, 100]);
                
        end
    else
    end
end


