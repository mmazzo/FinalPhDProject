% Looking closer at the pCSI script
% Example data - SFU01 Submax35 Stretch Pre
%%
for i = 1:size(firing,1)
    if sum(firing(i,:)) == 0
        rem(i,1) = 1;
    else
        rem(i,1) = 0;
    end
end

%
firing = firing(~rem,:);
firing = firing(:,25000:88000);
%%
tiledlayout(1,2)
nexttile
plot(F,Pxx,'g'); hold on;
plot(F, Pyy,'b');
plot(F,Pxy,'k');
xlim([0 25]);
legend('Pxx','Pyy','Pxy'); 
%legend('Pxx','Pyy');

nexttile
plot(F,PxxT1,'g'); hold on;
plot(F, PyyT1,'b');
plot(F,PxyT1,'k');
xlim([0 25]);
legend('PxxT1','PyyT1','PxyT1');

%% 
tiledlayout(1,3)
nexttile
    plot(F,coh)
    xlim([0 25]);
    legend('coh');
nexttile
    plot(F,abs(PxyT1).^2)
    xlim([0 25])
    legend('abs(PxyT1).^2');
nexttile
    plot(F,Pxx.*Pyy)
    xlim([0 25]);
    legend('Pxx.*Pyy');
    
%% final products
tiledlayout(1,2)
nexttile
for p = 1:(floor(size(firing,1))/2)
    plot(F, COHT(p,:));
    hold on;
    xlim([0 25]);
end    

nexttile
    plot(pCSI);
    ylim([0 1]);
    xlim([0 20]);

%% Compare one sample to FFT
sig1 = detrend(sum(firing(group1(1:k1),:),1));
sig2 = detrend(sum(firing(group2(1:k1),:),1));

%% PSD 1
hw = hanning(round(LW*fsamp));

tiledlayout(2,1)
nexttile
    plot(conv(sig1,hw,'same')); hold on;
    plot(conv(sig2,hw,'same'))

[pxx1,f] = pwelch(sig1,hw,0,10*fsamp,fsamp);
[pxx2,f] = pwelch(sig2,hw,0,10*fsamp,fsamp);

nexttile
    plot(f,pxx1,'Color','blue') 
    xlim([0 25]);
    %ylim([0 5]);
    title('Frequency Spectrum Plot')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
    hold on;
    plot(f,pxx2, 'Color','red')
