% Compare FCC, CST and Force

%%
yyaxis left
plot(MUdata.MG.cst)
yyaxis right
plot(fdat.filt{1,1})
%%
fdat = fdatPo;

new = [];
for w = 1:6
    temp = MUdata.MG.PCA.w5.coeffs{1,w}(:,1)';
    new = horzcat(new,temp);
end
new = highpass(new,0.75,2000);
new = new(1:60001);

fo = [];
for w = 1:6
    temp = fdat.MG.w5.forces{1,w};
    fo = horzcat(fo,temp);
end
fo = highpass(fo,0.75,2000);
fo = fo(1:60001);
%% Concatenated 5s windows
t = tiledlayout(3,1);
nexttile
title(t,'SFU01 MG Stretch Submax 10');
    yyaxis left
    plot(new,'r')
    ylim([-0.04 0.04]);
    yyaxis right
    plot(fo,'k')
    %plot(fdat.filt{1,1}(MUdata.start:MUdata.endd),'k')
    legend('Coeffs','Force');
        [sc,~] = xcorr(new,fo,'coeff');
        [maxc,~] = max(sc);
        title(strcat('R= ',string(maxc)));
nexttile
    yyaxis left
    plot(highpass(MUdata.MG.cst(MUdata.start:MUdata.endd),0.75,2000),'b')
    yyaxis right
    plot(new,'r')
    legend('CST','Coeffs');
        [sc,~] = xcorr(new,highpass(MUdata.MG.cst(MUdata.start:MUdata.endd),0.75,2000),'coeff');
        [maxc,~] = max(sc);
        title(strcat('R= ',string(maxc)));
nexttile
    yyaxis left
    plot(highpass(MUdata.MG.cst(MUdata.start:MUdata.endd),0.75,2000),'b')
    yyaxis right
    plot(fo,'k')
    %plot(fdat.filt{1,1}(MUdata.start:MUdata.endd),'k')
    legend('CST','Force');
        [sc,~] = xcorr(fo,highpass(MUdata.MG.cst(MUdata.start:MUdata.endd),0.75,2000),'coeff');
        [maxc,~] = max(sc);
        title(strcat('R= ',string(maxc)));

%% PCA of full 30s window
idrs = [];
    fs = 2000;
    len = length(MUdata.MG.binary);
    for mu = 1:length(MUdata.MG.rawlines)
        temp = MUdata.MG.rawlines{mu};
        start = find(~isnan(temp),1,'first');
        endd = find(~isnan(temp),1,'last');
        if isempty(temp)
        else
            temp = temp(start:endd);
            temp = conv(temp,hann(800),'same');
            nans1 = repelem(NaN,start-1);
            nans2 = repelem(NaN,(len-endd));
            temp2 = highpass(temp, 0.75, fs);
            idrs(mu,:) = horzcat(nans1,temp2,nans2);
        end
    end
    
%% Plot all detrended IDRs
for mu = 1:size(idrs,1)
    plot(idrs(mu,:))
    hold on;
end

%% PCA of full 30s window
idrsec = idrs(:,MUdata.start:MUdata.endd);
rem = [];
for mu = 1:size(idrsec,1)
%     if sum(isnan(idrsec(mu,:))) > 0
%         rem = horzcat(rem,mu);
%     elseif
    if sum((idrsec(mu,:))) == 0
        rem = horzcat(rem,mu);
    end
end
% Remove empty IDRs
idrdat = idrsec;
idrdat(rem,:) = [];

% Plot to check

for mu = 1:size(idrdat,1)
    plot(idrdat(mu,:))
    hold on;
end
%%
[coeff,score,lat,tsq,expl,muu] = pca(idrdat);

%% PCA of full 30s window
t = tiledlayout(3,1);
nexttile
title(t, 'SFU01 MG Stretch Submax 10');
    yyaxis left
    plot(highpass(coeff(:,1),0.75,2000),'r')
    yyaxis right
    plot(highpass(fdat.filt{1,1}(MUdata.start:MUdata.endd),0.75,2000),'k')
    legend('Coeffs','Force');
        [sc,~] = xcorr(highpass(coeff(:,1),0.75,2000),highpass(fdat.filt{1,1}(MUdata.start:MUdata.endd),0.75,2000),'coeff');
        [maxc,~] = max(sc);
        title(strcat('R= ',string(maxc)));
nexttile
    yyaxis left
    plot(highpass(MUdata.MG.cst(MUdata.start:MUdata.endd),0.75,2000),'b')
    yyaxis right
    plot(highpass(coeff(:,1),0.75,2000),'r')
    legend('CST','Coeffs');
        [sc,~] = xcorr(highpass(MUdata.MG.cst(MUdata.start:MUdata.endd),0.75,2000),highpass(coeff(:,1),0.75,2000),'coeff');
        [maxc,~] = max(sc);
        title(strcat('R= ',string(maxc)));
nexttile
    yyaxis left
    plot(highpass(MUdata.MG.cst(MUdata.start:MUdata.endd),0.75,2000),'b')
    yyaxis right
    plot(highpass(fdat.filt{1,1}(MUdata.start:MUdata.endd),0.75,2000),'k')
    legend('CST','Force');
        [sc,~] = xcorr(highpass(MUdata.MG.cst(MUdata.start:MUdata.endd),0.75,2000),highpass(fdat.filt{1,1}(MUdata.start:MUdata.endd),0.75,2000),'coeff');
        [maxc,~] = max(sc);
        title(strcat('R= ',string(maxc)));
        
%%
plot(PFdata.stretch.submax10.MUdata.pre.MG.pCSI.w5.pCSI,'b')
hold on
plot(PFdata.stretch.submax10.MUdata.post.MG.pCSI.w5.pCSI,'g')
xlim([0 12]);
ylim([0 1]);
ylabel('Coherence');
xlabel('Number of MU Pairs');
legend('Trial 2','Trial 3');
%% PCA iterations
p1 = plot(PFdata.stretch.submax10.MUdata.pre.MG.PCA.iter.w5.fit,'b');
hold on;
p2 = plot(PFdata.stretch.submax10.MUdata.post.MG.PCA.iter.w5.fit,'g');
ylim([0 100]);
xlim([0 23]);
ylabel('% Explained');
xlabel('Number of MUs in PCA');
legend('Trial 2','Trial 3');