% Testing pCSI inputs again
% Comparing FFTs with different numbers of motor units & determining the
% slope of the log function (inverse exponential) to estimate PCI (Negro et al. 2016, JAP)
%
% binarydata:  From PFdata files
% -----------------------------------------------------------

% Random permutations of MUs
% n = total # of MUs identified
% n2 = half of n

binarydata = PFdata.stretch.submax10.MUdata.pre.MG.binary(:,PFdata.stretch.submax10.MUdata.pre.start:PFdata.stretch.submax10.MUdata.pre.endd);

rem = [];
for r = 1:size(binarydata,1)
    if sum(binarydata(r,:)) == 0
        rem = horzcat(rem,r);
    end
end

binary = binarydata;
binary(rem,:) = [];

n = size(binary,1); 
n2 = floor(n/2);
noverlap = 0;
fs = 2000;

PxxT1.DV.w1 = 0;
PyyT1.DV.w1 = 0;
PxyT1.DV.w1 = 0;

PxxT1.DV.w12 = 0;
PyyT1.DV.w12 = 0;
PxyT1.DV.w12 = 0;

PxxT1.NH = 0;
PyyT1.NH = 0;
PxyT1.NH = 0;

pCSI_all.NH = [];
pCSI_all.DV.w1 = [];
pCSI_all.DV.w12 = [];

%% 100 iterations of 1 vs 1 MUs, 2 vs 2 MUs.. up to 12 vs 12 MUs
% (12 permutations)
for p = 1:n2
    disp(p);
    for i = 1:100
        % Select two samples
        samp = datasample(binary,p*2,1,'Replace',false);
        samp1 = sum(samp(1:p,:),1);
        samp2 = sum(samp(p+1:end,:),1);
        % Calculate coherence between two samples
        % 1 sec sections, no overlap - No Hanning window
%             [Pxx.NH,F.NH] = cpsd(detrend(samp1),detrend(samp1),fs,0,10*fs,fs);
%             [Pyy.NH,F.NH] = cpsd(detrend(samp2),detrend(samp2),fs,0,10*fs,fs);
%             [Pxy.NH,F.NH] = cpsd(detrend(samp1),detrend(samp2),fs,0,10*fs,fs);
%             PxxT1.NH = PxxT1.NH + Pxx.NH;
%             PyyT1.NH = PyyT1.NH + Pyy.NH;
%             PxyT1.NH = PxyT1.NH + Pxy.NH;
        
        % del vecchio approach - CSPD - 1 s window
            [Pxx.DV.w1,F.DV.w1] = cpsd(detrend(samp1),detrend(samp1),hanning(fs),0,10*fs,fs);
            [Pyy.DV.w1,F.DV.w1] = cpsd(detrend(samp2),detrend(samp2),hanning(fs),0,10*fs,fs);
            [Pxy.DV.w1,F.DV.w1] = cpsd(detrend(samp1),detrend(samp2),hanning(fs),0,10*fs,fs);
            PxxT1.DV.w1 =PxxT1.DV.w1 + Pxx.DV.w1;
            PyyT1.DV.w1 = PyyT1.DV.w1 + Pyy.DV.w1;
            PxyT1.DV.w1 = PxyT1.DV.w1 + Pxy.DV.w1;
            
        % del vecchio approach - CSPD - 0.5 s window
            [Pxx.DV.w12,F.DV.w12] = cpsd(detrend(samp1),detrend(samp1),hanning(fs/2),0,10*fs,fs);
            [Pyy.DV.w12,F.DV.w12] = cpsd(detrend(samp2),detrend(samp2),hanning(fs/2),0,10*fs,fs);
            [Pxy.DV.w12,F.DV.w12] = cpsd(detrend(samp1),detrend(samp2),hanning(fs/2),0,10*fs,fs);
            PxxT1.DV.w12 =PxxT1.DV.w12 + Pxx.DV.w12;
            PyyT1.DV.w12 = PyyT1.DV.w12 + Pyy.DV.w12;
            PxyT1.DV.w12 = PxyT1.DV.w12 + Pxy.DV.w12;
       
                % magnitude squared coherence
                coh.DV.w1 = abs(Pxy.DV.w1).^2./(Pxx.DV.w1.*Pyy.DV.w1);  
                % Mean coherence value between 0-5 Hz
                pCSI_all.DV.w1(p,i) = mean(coh.DV.w1(F.DV.w1>0.1 & F.DV.w1<5));
               
                % magnitude squared coherence
                coh.DV.w12 = abs(Pxy.DV.w12).^2./(Pxx.DV.w12.*Pyy.DV.w12);  
                % Mean coherence value between 0-5 Hz
                pCSI_all.DV.w12(p,i) = mean(coh.DV.w12(F.DV.w12>0.1 & F.DV.w12<5));
               
                % magnitude squared coherence
                %coh.NH = abs(Pxy.NH).^2./(Pxx.NH.*Pyy.NH);  
                % Mean coherence value between 0-5 Hz
                %pCSI_all.NH(p,i) = mean(coh,NH(F.NH>0.1 & F.NH<5));
        
        
    end
    % Mean of each permutation option acros frequencies
    COHT.DV.w1(p,:) = abs(PxyT1.DV.w1).^2./(PxxT1.DV.w1.*PyyT1.DV.w1);
    % Mean coherence of the 100 iterations for each permutation
    pCSI.DV.w1(p,:) = mean(COHT.DV.w1(p,F.DV.w1>0.1 & F.DV.w1<5)); % between 0.1 Hz and 5 Hz
    
    % Mean of each permutation option acros frequencies
    COHT.DV.w12(p,:) = abs(PxyT1.DV.w12).^2./(PxxT1.DV.w12.*PyyT1.DV.w12);
    % Mean coherence of the 100 iterations for each permutation
    pCSI.DV.w12(p,:) = mean(COHT.DV.w12(p,F.DV.w12>0.1 & F.DV.w12<5)); % between 0.1 Hz and 5 Hz
    
    
    % Mean of each permutation option acros frequencies
    %COHT.NH(p,:) = abs(PxyT1.NH).^2./(PxxT1.NH.*PyyT1.NH);
    % Mean coherence of the 100 iterations for each permutation
    %pCSI.NH(p,:) = mean(COHT.NH(p,F.NH>0.1 & F.NH<5)); % between 0.1 Hz and 5 Hz
end

%% Visualize avg coherence across frequencies 0-50 Hz for each permutation
figure(1)
tiledlayout(1,3)
nexttile
title('1-s Windows')
    for i = 1:n2
        plot(F.DV.w1,COHT.DV.w1(i,:),'r')
        xlim([0 25])
        hold on
    end
nexttile
title('0.5-s Windows')
    for i = 1:n2
        plot(F.DV.w12,COHT.DV.w12(i,:),'b')
        xlim([0 25])
        hold on
    end

% Visualize pCSI vs. # MUs plot
nexttile
    plot(pCSI.DV.w1,'r')
    hold on
    plot(pCSI.DV.w12,'b')
    ylim([0 1])
    legend('DV 1-s Window','DV 0.5-s Window')

%% 2 and 5 s windows

binarydata = PFdata.stretch.submax10.MUdata.pre.MG.binary(:,PFdata.stretch.submax10.MUdata.pre.start:PFdata.stretch.submax10.MUdata.pre.endd);


rem = [];
for r = 1:size(binarydata,1)
    if sum(binarydata(r,:)) == 0
        rem = horzcat(rem,r);
    end
end

binary = binarydata;
binary(rem,:) = [];

n = size(binary,1); 
n2 = floor(n/2);
noverlap = 0;
fs = 2000;

PxxT1.DV.w2 = 0;
PyyT1.DV.w2 = 0;
PxyT1.DV.w2 = 0;

PxxT1.DV.w5 = 0;
PyyT1.DV.w5 = 0;
PxyT1.DV.w5 = 0;

pCSI_all.NH = [];
pCSI_all.DV.w2 = [];
pCSI_all.DV.w5 = [];

% 100 iterations of 1 vs 1 MUs, 2 vs 2 MUs.. up to 12 vs 12 MUs
% (12 permutations)
for p = 1:n2
    disp(p);
    for i = 1:100
        % Select two samples
        samp = datasample(binary,p*2,1,'Replace',false);
        samp1 = sum(samp(1:p,:),1);
        samp2 = sum(samp(p+1:end,:),1);
        % Calculate coherence between two samples
        
        % del vecchio approach - CSPD - 2 s window
            [Pxx.DV.w2,F.DV.w2] = cpsd(detrend(samp1),detrend(samp1),hanning(fs*2),0,10*fs,fs);
            [Pyy.DV.w2,F.DV.w2] = cpsd(detrend(samp2),detrend(samp2),hanning(fs*2),0,10*fs,fs);
            [Pxy.DV.w2,F.DV.w2] = cpsd(detrend(samp1),detrend(samp2),hanning(fs*2),0,10*fs,fs);
            PxxT1.DV.w2 =PxxT1.DV.w2 + Pxx.DV.w2;
            PyyT1.DV.w2 = PyyT1.DV.w2 + Pyy.DV.w2;
            PxyT1.DV.w2 = PxyT1.DV.w2 + Pxy.DV.w2;
            
        % del vecchio approach - CSPD - 5 s window
            [Pxx.DV.w5,F.DV.w5] = cpsd(detrend(samp1),detrend(samp1),hanning(fs*5),0,10*fs,fs);
            [Pyy.DV.w5,F.DV.w5] = cpsd(detrend(samp2),detrend(samp2),hanning(fs*5),0,10*fs,fs);
            [Pxy.DV.w5,F.DV.w5] = cpsd(detrend(samp1),detrend(samp2),hanning(fs*5),0,10*fs,fs);
            PxxT1.DV.w5 =PxxT1.DV.w5 + Pxx.DV.w5;
            PyyT1.DV.w5 = PyyT1.DV.w5 + Pyy.DV.w5;
            PxyT1.DV.w5 = PxyT1.DV.w5 + Pxy.DV.w5;
       
                % magnitude squared coherence
                coh.DV.w2 = abs(Pxy.DV.w2).^2./(Pxx.DV.w2.*Pyy.DV.w2);  
                % Mean coherence value between 0-5 Hz
                pCSI_all.DV.w2(p,i) = mean(coh.DV.w2(F.DV.w2>0.1 & F.DV.w2<5));
               
                % magnitude squared coherence
                coh.DV.w5 = abs(Pxy.DV.w5).^2./(Pxx.DV.w5.*Pyy.DV.w5);  
                % Mean coherence value between 0-5 Hz
                pCSI_all.DV.w5(p,i) = mean(coh.DV.w5(F.DV.w5>0.1 & F.DV.w5<5));
               
        
    end
    % Mean of each permutation option acros frequencies
    COHT.DV.w2(p,:) = abs(PxyT1.DV.w2).^2./(PxxT1.DV.w2.*PyyT1.DV.w2);
    % Mean coherence of the 100 iterations for each permutation
    pCSI.DV.w2(p,:) = mean(COHT.DV.w2(p,F.DV.w2>0.1 & F.DV.w2<5)); % between 0.1 Hz and 5 Hz
    
    % Mean of each permutation option acros frequencies
    COHT.DV.w5(p,:) = abs(PxyT1.DV.w5).^2./(PxxT1.DV.w5.*PyyT1.DV.w5);
    % Mean coherence of the 100 iterations for each permutation
    pCSI.DV.w5(p,:) = mean(COHT.DV.w5(p,F.DV.w5>0.1 & F.DV.w5<5)); % between 0.1 Hz and 5 Hz
    
    
end

%% Visualize avg coherence across frequencies 0-50 Hz for each permutation
figure(1)
tiledlayout(2,2)
nexttile
    for i = 1:n2
        plot(F.DV.w1,COHT.DV.w1(i,:),'r')
        xlim([0 25])
        hold on
    end
    title('1-s Windows')
nexttile
    for i = 1:n2
        plot(F.DV.w12,COHT.DV.w12(i,:),'b')
        xlim([0 25])
        hold on
    end
    title('0.5-s Windows')
nexttile
    for i = 1:n2
        plot(F.DV.w2,COHT.DV.w2(i,:),'g')
        xlim([0 25])
        hold on
    end
    title('2-s Windows')
nexttile
    for i = 1:n2
        plot(F.DV.w5,COHT.DV.w5(i,:),'c')
        xlim([0 25])
        hold on
    end
    title('5-s Windows')

% Visualize pCSI vs. # MUs plot
figure(2)
    plot(pCSI.DV.w12,'b') 
        hold on
    plot(pCSI.DV.w1,'r')
    plot(pCSI.DV.w2,'g')
    plot(pCSI.DV.w5,'c')
    ylim([0 1])
    legend('DV 0.5-s Window','DV 1-s Window','DV 2-s Window','DV 5-s Window')

%% Pxy for 11 MUs
tiledlayout(1,3)
nexttile
plot(F.DV.w12,PxxT1.DV.w12,'b')
xlim([0 25]);
hold on;
plot(F.DV.w1,PxxT1.DV.w1,'r')
plot(F.DV.w2,PxxT1.DV.w2,'g')
plot(F.DV.w5,PxxT1.DV.w5,'c')
ylabel('Cross Power');
xlabel('Frequency (Hz)');
title('Pxx: Autocorrelation');
ylim([-0.01 0.18]);
%legend('DV 0.5-s Window','DV 1-s Window','DV 2-s Window','DV 5-s Window')

nexttile
plot(F.DV.w12,PyyT1.DV.w12,'b')
xlim([0 25]);
hold on;
plot(F.DV.w1,PyyT1.DV.w1,'r')
plot(F.DV.w2,PyyT1.DV.w2,'g')
plot(F.DV.w5,PyyT1.DV.w5,'c')
ylabel('Cross Power');
title('Pyy: Autocorrelation');
xlabel('Frequency (Hz)');
ylim([-0.01 0.18]);
%legend('DV 0.5-s Window','DV 1-s Window','DV 2-s Window','DV 5-s Window')

nexttile
plot(F.DV.w12,PxyT1.DV.w12,'b')
xlim([0 25]);
hold on;
plot(F.DV.w1,PxyT1.DV.w1,'r')
plot(F.DV.w2,PxyT1.DV.w2,'g')
plot(F.DV.w5,PxyT1.DV.w5,'c')
ylabel('Cross Power');
title('Pxy: Cross correlation');
xlabel('Frequency (Hz)');
legend('DV 0.5-s Window','DV 1-s Window','DV 2-s Window','DV 5-s Window')
ylim([-0.01 0.18]);

%%

plot(F.DV.w12,abs(PxyT1.DV.w12).^2,'b')
xlim([0 5]);
hold on;
plot(F.DV.w1,abs(PxyT1.DV.w1).^2,'r')
plot(F.DV.w2,abs(PxyT1.DV.w2).^2,'g')
plot(F.DV.w5,abs(PxyT1.DV.w5).^2,'c')
ylabel('Cross Power?');
title('|Pxy|^2 (Numerator)');
xlabel('Frequency (Hz)');
legend('DV 0.5-s Window','DV 1-s Window','DV 2-s Window','DV 5-s Window')
%ylim([-0.0001 0.005]);

%%
plot(F.DV.w12,(PxxT1.DV.w12.*PyyT1.DV.w12),'b')
xlim([0 5]);
hold on;
plot(F.DV.w1,(PxxT1.DV.w1.*PyyT1.DV.w1),'r')
plot(F.DV.w2,(PxxT1.DV.w2.*PyyT1.DV.w2),'g')
plot(F.DV.w5,(PxxT1.DV.w5.*PyyT1.DV.w5),'c')
ylabel('Cross Power?');
title('Pxx.*Pyy (Denominator)');
xlabel('Frequency (Hz)');
legend('DV 0.5-s Window','DV 1-s Window','DV 2-s Window','DV 5-s Window')
%ylim([-0.001 0.03]);
%%
plot(F.DV.w12,COHT.DV.w12(11,:),'b');
hold on;
plot(F.DV.w1,COHT.DV.w1(11,:),'r');
plot(F.DV.w2,COHT.DV.w2(11,:),'g');
plot(F.DV.w5,COHT.DV.w5(11,:),'c');
xlim([0 25]);
ylabel('Coherence');
title('Coherence: 11 vs 11 MUs');
xlabel('Frequency (Hz)');
legend('DV 0.5-s Window','DV 1-s Window','DV 2-s Window','DV 5-s Window')

%% Only 1s windows
plot(F.DV.w1,abs(PxyT1.DV.w1).^2,'r');
hold on;
plot(F.DV.w1,(PxxT1.DV.w1.*PyyT1.DV.w1),'--r');
xlim([0 5]);
title('Numerator and denominator');
legend('|Pxy|^2 (Numerator)','Pxx.*Pyy (Denominator)');
xlabel('Frequency (Hz)');
ylabel('Cross Power?');

%% Coherence = at each time point, the solid line / the dotted line
final = (abs(PxyT1.DV.w1).^2)./(PxxT1.DV.w1.*PyyT1.DV.w1);

plot(F.DV.w1,final,'r')
xlim([0 5]);
ylim([0 1]);
xlabel('Coherence')
ylabel('Frequency (Hz)')








%% No Hanning window

binarydata = PFdata.stretch.submax10.MUdata.pre.MG.binary(:,PFdata.stretch.submax10.MUdata.pre.start:PFdata.stretch.submax10.MUdata.pre.endd);


rem = [];
for r = 1:size(binarydata,1)
    if sum(binarydata(r,:)) == 0
        rem = horzcat(rem,r);
    end
end

binary = binarydata;
binary(rem,:) = [];

n = size(binary,1); 
n2 = floor(n/2);
noverlap = 0;
fs = 2000;

PxxT1.NH = 0;
PyyT1.NH = 0;
PxyT1.NH = 0;

pCSI_all.NH = [];


% 100 iterations of 1 vs 1 MUs, 2 vs 2 MUs.. up to 11 vs 11 MUs
% (11 permutations)
for p = 1:n2
    disp(p);
    for i = 1:100
        % Select two samples
        samp = datasample(binary,p*2,1,'Replace',false);
        samp1 = sum(samp(1:p,:),1);
        samp2 = sum(samp(p+1:end,:),1);
        % Calculate coherence between two samples
        
        % del vecchio approach - CSPD - no hanning window
            [Pxx.NH,F.NH] = cpsd(detrend(samp1),detrend(samp1),fs,0,10*fs,fs);
            [Pyy.NH,F.NH] = cpsd(detrend(samp2),detrend(samp2),fs,0,10*fs,fs);
            [Pxy.NH,F.NH] = cpsd(detrend(samp1),detrend(samp2),fs,0,10*fs,fs);
            PxxT1.NH =PxxT1.NH + Pxx.NH;
            PyyT1.NH = PyyT1.NH + Pyy.NH;
            PxyT1.NH = PxyT1.NH + Pxy.NH;
            
                % magnitude squared coherence
                coh.NH = abs(Pxy.NH).^2./(Pxx.NH.*Pyy.NH);  
                % Mean coherence value between 0-5 Hz
                pCSI_all.NH(p,i) = mean(coh.NH(F.NH>0.1 & F.NH<5));
               
        
    end
    % Mean of each permutation option acros frequencies
    COHT.NH(p,:) = abs(PxyT1.NH).^2./(PxxT1.NH.*PyyT1.NH);
    % Mean coherence of the 100 iterations for each permutation
    pCSI.NH(p,:) = mean(COHT.NH(p,F.NH>0.1 & F.NH<5)); % between 0.1 Hz and 5 Hz
    
end

%%
tiledlayout(1,3)

nexttile
plot(F.NH,abs(PxyT1.NH).^2,'k')
hold on;
plot(F.NH,(PxxT1.NH.*PyyT1.NH),'k--');
xlim([0 25])
legend('Numerator','Denominator');

nexttile
plot(F.NH,abs(PxyT1.NH).^2,'k')
hold on;
plot(F.NH,(PxxT1.NH.*PyyT1.NH),'k--');
xlim([0 5])
legend('Numerator','Denominator');
title('Zoomed on 0.1 - 5 Hz');

nexttile
final = (abs(PxyT1.NH).^2)./(PxxT1.NH.*PyyT1.NH);
plot(F.NH,final,'k')
xlim([0 5]);
ylim([0 1]);
xlabel('Coherence')
ylabel('Frequency (Hz)')

%%
t = tiledlayout(1,2);
title(t,'Effects of Hanning Window');
nexttile
plot(F.DV.w1,COHT.DV.w1,'r')
xlim([0 15]);
hold on;
plot(F.NH,COHT.NH,'k')
xlabel('Frequency (Hz)');
ylabel('Coherence');
legend('Hanning');


nexttile
plot(F.DV.w1,COHT.DV.w1,'r')
xlim([0 5]);
hold on;
plot(F.NH,COHT.NH,'k')
xlabel('Frequency (Hz)');
ylabel('Coherence');
title('Zoomed in on 0.1 - 5 Hz');

%% pwelch instead of autocorrelation cpsd
[Pxx.pwelch,F.pwelch] = pwelch(samp1,hanning(fs),0,10*fs,fs);

yyaxis left
plot(F.pwelch,Pxx.pwelch,'Color',[0.7176    0.2745    1.0]')
xlim([0 25])
yyaxis right
plot(F.DV.w1,Pxx.DV.w1,'r')
legend('pwelch','cpsd')

%% fft
x = samp1;
Fs = 2000;
L = length(x);
t = L/Fs;
Y = fft(x);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

x2 = samp2;
Fs = 2000;
L = length(x2);
t = L/Fs;
Y = fft(x2);

P3 = abs(Y/L);
P4 = P3(1:L/2+1);
P4(2:end-1) = 2*P4(2:end-1);
f2 = Fs*(0:(L/2))/L;

tiledlayout(1,2)
nexttile
    plot(f,P1,'Color',[1.0000    0.4118    0.1608])
    title('Frequency Spectrum Plot')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    xlim([0.1 25])
    hold on;
    plot(f2,P4,'Color',[0.4941    0.1843    0.5569])
nexttile
    plot(f,P1,'Color',[1.0000    0.4118    0.1608])
    title('Frequency Spectrum Plot')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    xlim([0.1 5])
    hold on;
    plot(f2,P4,'Color',[0.4941    0.1843    0.5569])
    
    
    
%% how to make pwelch and fft equivalent = example
N = 94144;
x = randn(1,N);
pwr1 = pwelch(x,ones(1,N),0,N,1,'twosided');
y = fft(x);
pwr2 = abs(y).^2;
plot(pwr1);
hold
plot(pwr2*max(pwr1)/max(pwr2),'r--');
%% Sample discharge train inputs
tiledlayout(4,1)
nexttile
plot(samp1,'Color',[1.0000    0.4118    0.1608])
xlim([0 60000]);
title('Sample 1')
nexttile
plot(samp2,'Color',[0.4941    0.1843    0.5569])
xlim([0 60000 ]);
title('Sample 2')
nexttile
plot(samp1,'Color',[1.0000    0.4118    0.1608])
xlim([3000 5000]);
nexttile
plot(samp2,'Color',[0.4941    0.1843    0.5569])
xlim([3000 5000]);
%% Example of hannign window applied
samp1hann = conv(samp1(3000:5000),hanning(fs),'same');
plot(samp1hann,'Color',[1.0000    0.4118    0.1608])
hold on;
samp2hann = conv(samp2(3000:5000),hanning(fs),'same');
plot(samp2hann,'Color',[0.4941    0.1843    0.5569])
xlabel('Time (dpts)')
ylabel('AU')
title('1-s section with hanning window')
%%
samp1hann = [];
samp2hann = [];
st = [];
endd = [];

num = floor(length(samp1)/2000);
for s = 1:num
    st = (num-1)*2000;
    endd = st+2000;
    temp1 = conv(samp1(st:endd),hanning(fs),'same');
    samp1hann = horzcat(samp1hann,temp1);
    temp2 = conv(samp2(st:endd),hanning(fs),'same');
    samp2hann = horzcat(samp2hann,temp2);
end

plot(samp1hann,'Color',[1.0000    0.4118    0.1608])
hold on;
plot(samp2hann,'Color',[0.4941    0.1843    0.5569])
xlabel('Time (dpts)')
ylabel('AU')
xlim([0 60000]);
title('Non-overlapping 1-s hanning-windowed sections')

%%
PxxT1.halfoverlap = 0;
PyyT1.halfoverlap = 0;
PxyT1.halfoverlap = 0;

for p = 1:n2
    disp(p);
    for i = 1:100
        % Select two samples
        samp = datasample(binary,p*2,1,'Replace',false);
        samp1 = sum(samp(1:p,:),1);
        samp2 = sum(samp(p+1:end,:),1);
        % Calculate coherence between two samples   
            [Pxx.halfoverlap,F.halfoverlap] = cpsd(detrend(samp1),detrend(samp1),hanning(fs),1000,10*fs,fs);
            [Pyy.halfoverlap,F.halfoverlap] = cpsd(detrend(samp2),detrend(samp2),hanning(fs),1000,10*fs,fs);
            [Pxy.halfoverlap,F.halfoverlap] = cpsd(detrend(samp1),detrend(samp2),hanning(fs),1000,10*fs,fs);
            PxxT1.halfoverlap =PxxT1.halfoverlap + Pxx.halfoverlap;
            PyyT1.halfoverlap = PyyT1.halfoverlap + Pyy.halfoverlap;
            PxyT1.halfoverlap = PxyT1.halfoverlap + Pxy.halfoverlap;
            
                % magnitude squared coherence
                coh.halfoverlap = abs(Pxy.halfoverlap).^2./(Pxx.halfoverlap.*Pyy.halfoverlap);  
                % Mean coherence value between 0-5 Hz
                pCSI_all.halfoverlap(p,i) = mean(coh.halfoverlap(F.halfoverlap>0.1 & F.halfoverlap<5));
               
    end
    % Mean of each permutation option acros frequencies
    COHT.halfoverlap(p,:) = abs(PxyT1.halfoverlap).^2./(PxxT1.halfoverlap.*PyyT1.halfoverlap);
    % Mean coherence of the 100 iterations for each permutation
    pCSI.halfoverlap(p,:) = mean(COHT.halfoverlap(p,F.halfoverlap>0.1 & F.halfoverlap<5)); % between 0.1 Hz and 5 Hz
    
end

%%
plot(F.halfoverlap,COHT.halfoverlap,'c')
xlim([0 5])
hold on;
plot(F.DV.w1,COHT.DV.w1,'r')
ylabel('Coherence');
xlabel('Frequency (Hz)');
legend('Half-window overlap')

%%