dat = pre;

%% Spread of IDR lines compared to CST after HPF & normalizing
fc = 0.75;                                 
fsamp = 2000;                                  
[filt2, filt1] = butter(4,fc/fsamp/2,'high');

cst_new = conv(dat.MUdata.MG.cst_unfilt,hann(800),'same');
dat.MUdata = IDRlinesRaw(dat.MUdata,muscles);
%lines = dat.MUdata.MG.lines;
rawlines = dat.MUdata.MG.rawlines;
%% 
for p = 1:length(rawlines)
    smlines{p} = conv(rawlines{p},hann(800),'same');
end

%%
%lines = rawlines;
lines = smlines;

lines = lines([1,2,3,4,5,6,7,10,11,12,13,14]);
%%
cm = jet(length(lines));

tiledlayout(4,1)
nexttile
    yyaxis left
    for p = 1:length(lines)
        plot(lines{p},'-','color',cm(p,:))
        hold on;
    end
    yyaxis right
    plot(cst_new,'k','LineWidth',1.5)
    ylim([0 60]);
nexttile
    yyaxis left
    for p = 1:length(lines)
        ind1 = find(~isnan(lines{p}),1,'first');
            pad = repelem(NaN,ind1-1);
        ind2 = find(~isnan(lines{p}),1,'last');
        line = lines{p}(ind1:ind2);
        temp = filtfilt(filt2,filt1,line);
        newline1{p} = horzcat(pad,temp);
        plot(newline1{p},'-','color',cm(p,:));
        hold on;
    end
    yyaxis right
    plot(filtfilt(filt2,filt1,cst_new),'k','LineWidth',1);
    title('HPF Only');
nexttile
    yyaxis left
    for p = 1:length(lines)
        ind1 = find(~isnan(lines{p}),1,'first');
            pad = repelem(NaN,ind1-1);
        ind2 = find(~isnan(lines{p}),1,'last');
        line = lines{p}(ind1:ind2);
        temp = normalize(filtfilt(filt2,filt1,line),'center');
        newline2{p} = horzcat(pad,temp);
        plot(newline2{p},'-','color',cm(p,:));
        hold on;
    end
    yyaxis right
    plot(normalize(filtfilt(filt2,filt1,cst_new),'center'),'k','LineWidth',1);
    title('HPF + Normalize to Center');
nexttile
    for p = 1:length(lines)
        ind1 = find(~isnan(lines{p}),1,'first');
            pad = repelem(NaN,ind1-1);
        ind2 = find(~isnan(lines{p}),1,'last');
        line = lines{p}(ind1:ind2);
        temp = normalize(normalize(filtfilt(filt2,filt1,line),'range',[-1 1]),'center');
        newline3{p} = horzcat(pad,temp);
        plot(newline3{p},'-','color',cm(p,:));
        hold on;
        plot(normalize(normalize(filtfilt(filt2,filt1,cst_new),'range',[-1 1]),'center'),'k','LineWidth',1);
        title('HPF + Normalize to Center + Range of -1 to +1');
    end
    
    %%
    for l = 1:length(lines)
        len = length(newline1{p}) - length(lines{p});
        pad = repelem(NaN,abs(len));
        lines1(p,:) = horzcat(newline1{p},pad);
        lines2(p,:) = horzcat(newline2{p},pad);
        lines3(p,:) = horzcat(newline3{p},pad);
    end
%% Find residuals
for mu = 1:length(lines)
    residuals1(mu,:) = lines1(mu,:) - filtfilt(filt2,filt1,cst_new);
    residuals2(mu,:) = lines1(mu,:) - normalize(filtfilt(filt2,filt1,cst_new),'center');
    residuals3(mu,:) = lines1(mu,:) - normalize(normalize(filtfilt(filt2,filt1,cst_new),'range',[-1 1]),'center');
end            
residuals1(isnan(residuals1)) = 0;
residuals2(isnan(residuals3)) = 0;
residuals3(isnan(residuals3)) = 0;

residuals1sum = sum(abs(residuals1));
residuals1meam = mean(abs(residuals1));
residuals2sum = sum(abs(residuals2));
residuals2mean = mean(abs(residuals2));
residuals3sum = sum(abs(residuals3));
residuals3mean = mean(abs(residuals3));
%% plot residuals
tiledlayout(2,1)
nexttile
    y = normalize(normalize(filtfilt(filt2,filt1,cst_new),'range',[-1 1]),'center')*10;
    yy = conv(residuals3sum,hann(800),'same')/10000;
    sd = yy/2;
    x = 1:numel(y);
    p = patch([x fliplr(x)], [y-sd  fliplr(y+sd)], [0  0.7  0.8]);
    p.FaceAlpha = 0.5;
    hold on;
    plot(x, y, 'k', 'LineWidth', 2);
    text(2000,-35,num2str(round(sum(residuals3sum/10000))));
nexttile
    plot(residuals3sum)

