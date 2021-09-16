%% Xcorrs plots

x1 = repelem(1,30);
x2 = repelem(2,30);
boxplot(vertcat(MUdata.xcorrs.w1.f_fpc_r,MUdata.xcorrs.w1.f_fpc30_r)');
hold on;
scatter(x1,MUdata.xcorrs.w1.f_fpc_r);
scatter(x2,MUdata.xcorrs.w1.f_fpc30_r);

%%
x1 = repelem(1,30);
x2 = repelem(2,30);
boxplot(vertcat(MUdata.xcorrs.w1.fpc_cst_r,MUdata.xcorrs.w1.fpc30_cst_r)');
hold on;
scatter(x1,MUdata.xcorrs.w1.fpc_cst_r);
scatter(x2,MUdata.xcorrs.w1.fpc30_cst_r);

%%
x1 = repelem(1,30);
x2 = repelem(2,30);
boxplot(vertcat(MUdata.xcorrs.w1.fpc_cst_r,MUdata.xcorrs.w1.fpc30_cst_r)');
hold on;
scatter(x1,MUdata.xcorrs.w1.fpc_cst_r);
scatter(x2,MUdata.xcorrs.w1.fpc30_cst_r);


%%
tiledlayout(6,5)
for w = 1:30
    nexttile
    plot(highpass(MUdata.w1.cst_secs{w},0.75,2000),'r-');
    hold on;
    plot(normalize(dat.PCA.iter.w30.w1.fpc_secs{w}),'b-');
end

%% Relation between between force & FPC xcorrs / force & CST xcorrs
scatter(MUdata.xcorrs.w1.f_fpc_r,MUdata.xcorrs.w1.f_cst_r)

%% 3d relation between all 3 xcorrs
scatter3(MUdata.xcorrs.w1.f_fpc_r,MUdata.xcorrs.w1.f_cst_r,MUdata.xcorrs.w1.fpc_cst_r)

%% Force & FPC xcorr and SD for force
scatter(MUdata.xcorrs.w1.f_fpc_r,MUdata.w1.f_sd)

%% compared with % explained by FPC
for w = 1:30
    expl(w) = MUdata.PCA.w1.explained{w}(1);
end


scatter(expl,MUdata.xcorrs.w1.fpc_cst_r)
scatter(expl,MUdata.xcorrs.w1.f_fpc_r)
scatter(expl,MUdata.xcorrs.w1.f_cst_r)

%% coherence
f = highpass(fdat.steady30.filt{1,1},0.75,2000);
fpc = MUdata.PCA.iter.w30.coeffs{end}(1,:);

PxxT1 = 0;
PyyT1 = 0;
PxyT1 = 0;

[Pxx,F] = cpsd(f,f,hanning(2000),0,10*fsamp,fsamp);
[Pyy,F] = cpsd(fpc,fpc,hanning(2000),0,10*fsamp,fsamp);
[Pxy,F] = cpsd(f,fpc,hanning(2000),0,10*fsamp,fsamp);
            
PxxT1 = PxxT1 + Pxx;
PyyT1 = PyyT1 + Pyy;
PxyT1 = PxyT1 + Pxy;
            
coh = abs(Pxy).^2./(Pxx.*Pyy); 

tiledlayout(1,3)
nexttile
    plot(F,coh); xlim([0 20]);
    title('Cross-coherence')
nexttile
    Fs = 2000;
    L = length(f);
    t = L/Fs;
    Y = fft(f);

    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    Freq = Fs*(0:(L/2))/L;
    
    plot(Freq,P1) 
    title('Single-Sided Amplitude Spectrum of S(t)')
    xlabel('f (Hz)'); xlim([0 20]);
    ylabel('|P1(f)|')
nexttile
    Fs = 2000;
    L = length(fpc);
    t = L/Fs;
    Y = fft(fpc);

    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    Freq = Fs*(0:(L/2))/L;
    
    plot(Freq,P1) 
    title('Single-Sided Amplitude Spectrum of S(t)')
    xlabel('f (Hz)'); xlim([0 20]);
    ylabel('|P1(f)|')

%%

figure(1)
    plot(MUdata.PCA.iter.w30.explained_means(2:end))
    title('Whole PF PCA')
    
figure(2)
tiledlayout(2,1)
nexttile
yyaxis right
    plot(highpass(MUdata.MG.cst(MUdata.MG.steady30.start:MUdata.MG.steady30.endd),0.75,2000),'g-')
    hold on;
    yyaxis left
    plot(highpass(MUdata.SOL.cst(MUdata.SOL.steady30.start:MUdata.SOL.steady30.endd),0.75,2000),'c-')
    title('CSTs')
nexttile
    yyaxis left
    plot(MUdata.MG.PCA.iter.w30.coeffs{end}(1,:),'g-')
    hold on;
    plot(MUdata.SOL.PCA.iter.w30.coeffs{end}(1,:),'c-')
    title('FPCs')
    yyaxis right
    plot(highpass(fdat.steady30.filt{1,1},0.75,2000),'k-')
    
%% xcorr between them
rs = xcorr(highpass(MUdata.MG.cst(MUdata.MG.steady30.start:MUdata.MG.steady30.endd),0.75,2000),highpass(MUdata.SOL.cst(MUdata.SOL.steady30.start:MUdata.SOL.steady30.endd),0.75,2000),200,'coeff');
max(rs)

rs = xcorr(MUdata.MG.PCA.iter.w30.coeffs{end}(1,:),MUdata.SOL.PCA.iter.w30.coeffs{end}(1,:),200,'coeff');
max(rs)

rs = xcorr(highpass(MUdata.MG.cst(MUdata.MG.steady30.start:MUdata.MG.steady30.endd),0.75,2000),highpass(fdat.steady30.filt{1,1},0.75,2000),200,'coeff');
max(rs)

rs = xcorr(highpass(MUdata.SOL.cst(MUdata.SOL.steady30.start:MUdata.SOL.steady30.endd),0.75,2000),highpass(fdat.steady30.filt{1,1},0.75,2000),200,'coeff');
max(rs)

rs = xcorr(highpass(MUdata.cst(MUdata.start:MUdata.endd),0.75,2000),highpass(fdat.steady30.filt{1,1},0.75,2000),200,'coeff');
max(rs)

%% Comparing muscles FPCs
tiledlayout(3,1)
nexttile
    plot(MUdata.xcorrs.w1.MGSOL.f_fpc_r)
nexttile
    yyaxis left
    plot(MUdata.MG.PCA.iter.w30.w1.fpc_sd,'c-');
    hold on;
    plot(MUdata.SOL.PCA.iter.w30.w1.fpc_sd,'g-')
    yyaxis right
    plot(MUdata.w1.f_sd,'k-')
%% SD for MG FPC vs SD for SOL FPC vs SD for force
tiledlayout(1,2)
nexttile
    scatter3(MUdata.MG.PCA.iter.w30.w1.fpc_sd,MUdata.SOL.PCA.iter.w30.w1.fpc_sd,MUdata.w1.f_sd)
    xlabel('SD for MG FPC')
    ylabel('SD for SOL FPC')
    zlabel('SD for Force')
nexttile
    scatter(MUdata.w1.f_sd, MUdata.PCA.iter.w30.w1.fpc_sd)
    xlabel('SD for Force')
    ylabel('SD for All FPs FPC')
    
%% Comparing muscles CSTs
tiledlayout(3,1)
nexttile
    plot(MUdata.xcorrs.w1.MGSOL.f_cst_r)
nexttile
    yyaxis left
    plot(MUdata.MG.PCA.iter.w30.w1.cst_sd,'c-');
    hold on;
    plot(MUdata.SOL.PCA.iter.w30.w1.cst_sd,'g-')
    yyaxis right
    plot(MUdata.w1.f_sd,'k-')
%% SD for MG FPC vs SD for SOL FPC vs SD for force
tiledlayout(1,2)
nexttile
    scatter3(MUdata.MG.w1.cst_sd,MUdata.SOL.w1.cst_sd,MUdata.w1.f_sd)
    xlabel('SD for MG CST')
    ylabel('SD for SOL CST')
    zlabel('SD for Force')
nexttile
    scatter(MUdata.w1.f_sd, MUdata.w1.cst_sd)
    xlabel('SD for Force')
    ylabel('SD for All FPs CST')
    
%% % explained
for w = 1:30
    expl(w) = MUdata.PCA.iter.w1.explained_means{w}(end);
    explMG(w) = MUdata.MG.PCA.iter.w1.explained_means{w}(end);
    explSOL(w) = MUdata.SOL.PCA.iter.w1.explained_means{w}(end);
end

% Compared to SD for force and SD for CST
figure(1)
scatter3(MUdata.w1.f_sd, MUdata.w1.cst_sd,expl)
    xlabel('SD for Force')
    ylabel('SD for All FPs CST')
    zlabel('% Explained')
    
% All PFs sompared to SOL and MG combined
figure(2)
scatter3(expl,explMG,explSOL)
    xlabel('All PFs')
    ylabel('MG')
    zlabel('SOL')