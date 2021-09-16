%% Manual check of steps in pCSI
binary = PFdata.stretch.submax10.MUdata.pre.MG.binary(:,22740:94350);
rem = [];
for mu = 1:size(binary,1)
    if sum(binary(mu,:)) == 0
        rem = horzcat(rem,mu);
    end    
end
firing = binary;
firing(rem,:) = [];
k1 = floor(size(firing,1)/2);

group = randperm(size(firing,1));
group1 = group(1:round(end/2));
group2 = group(round(end/2)+1:end);

group1 = group1(1:k1);
group2 = group2(1:k1);
            
%%
hw = hanning(800);
dat1 = conv(detrend(sum(firing(group1(1:k1),:),1)),hw,'same');
dat2 = conv(detrend(sum(firing(group2(1:k1),:),1)),hw,'same');

%%
plot(dat1)
hold on;
plot(dat2)
%%
LW = 1;
fsamp = 2000;

PxxT1 = 0;
PyyT1 = 0;
PxyT1 = 0;
pCSI_all = [];

[Pxx,F] = cpsd(detrend(sum(firing(group1(1:k1),:),1)),detrend(sum(firing(group1(1:k1),:),1)),2000,0,10*fsamp,fsamp);
[Pyy,F] = cpsd(detrend(sum(firing(group2(1:k1),:),1)),detrend(sum(firing(group2(1:k1),:),1)),2000,0,10*fsamp,fsamp);
[Pxy,F] = cpsd(detrend(sum(firing(group1(1:k1),:),1)),detrend(sum(firing(group2(1:k1),:),1)),2000,0,10*fsamp,fsamp);
PxxT1 = PxxT1 + Pxx;
PyyT1 = PyyT1 + Pyy;
PxyT1 = PxyT1 + Pxy;

coh = abs(Pxy).^2./(Pxx.*Pyy);    
pCSI_all = mean(coh(F>0.1 & F<5));
%%
tiledlayout(1,4)
nexttile
    plot(F,Pxx,'r'); xlim([0 25]);
    xlabel('Frequency (Hz)');
    ylabel('Coherence');
    title('Pxx (Group 1)')
nexttile
    plot(F,Pyy,'r'); xlim([0 25]);
    xlabel('Frequency (Hz)');
    ylabel('Coherence');
    title('Pxx (Group 2)')
nexttile
    plot(F,Pxy,'k'); xlim([0 25]);
    xlabel('Frequency (Hz)');
    ylabel('Coherence');
    title('Pxy (Group 1 x Group 2)')
nexttile
    plot(F,coh); xlim([0 25]);
    xlabel('Frequency (Hz)');
    ylabel('Coherence');
    title('Cross Coherence');
    ylim([0 1]);
%%
figure(1)
    plot(PFdata.stretch.submax10.MUdata.before.SOL.PCA.iter.w1.fit(2:50),'r'); hold on;
    %plot(PFdata.stretch.submax10.MUdata.pre.SOL.PCA.iter.w1.fit(2:50),'b');
    plot(PFdata.stretch.submax10.MUdata.post.SOL.PCA.iter.w1.fit(2:50),'g');
    ylim([0 100]);
    ylabel('% Explained');
    xlabel('# of MUs included in PCA');
    
%%
figure(2)
    plot(PFdata.stretch.submax10.MUdata.before.SOL.pCSI.w1.pCSI,'r'); hold on;
    plot(PFdata.stretch.submax10.MUdata.pre.SOL.pCSI.w1.pCSI,'b')
    plot(PFdata.stretch.submax10.MUdata.post.SOL.pCSI.w1.pCSI,'g')
    xlim([0 8])
    ylim([0 1])
    ylabel('Coherence');
    xlabel('# MU Pairs');
%%
before = PFdata.stretch.submax10.MUdata.before.SOL.PCA.w1.explained_mean(1)
pre = PFdata.stretch.submax10.MUdata.pre.SOL.PCA.w1.explained_mean(1)
post = PFdata.stretch.submax10.MUdata.post.SOL.PCA.w1.explained_mean(1)