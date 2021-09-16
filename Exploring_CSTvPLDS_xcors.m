% Compare CST and PLDS for SFU data
muscles = {'MG','LG','SOL'};
submax10.force = force;
submax10.muscles = muscles;

submax10.before.MUdata = before.MUdata;
submax10.before.force = before.force;
submax10.pre.MUdata = pre.MUdata;
submax10.pre.force = pre.force;
submax10.post.MUdata = post.MUdata;
submax10.post.force = post.force;

clearvars -except 'submax10' 'submax35'


%% Calculate new IDRlinesRaw for each time point  
    submax10.before.MUdata = IDRlinesRaw(submax10.before.MUdata,submax10.muscles);
    submax10.pre.MUdata = IDRlinesRaw(submax10.pre.MUdata,submax10.muscles);
    submax10.post.MUdata = IDRlinesRaw(submax10.post.MUdata,submax10.muscles);
%% ------------ MG -------------
% Calculate PLDS estimate of CI for each force level
    submax10.before.MUdata.MG.binary_logical = logical(submax10.before.MUdata.MG.binary);
    usePLDS(submax10.before.MUdata.MG)
    submax10.before.MUdata.MG.PLDS = PLDSout; 
%% ------------ LG ------------
% Calculate PLDS estimate of CI for each force level
    submax10.before.MUdata.LG.binary_logical = logical(submax10.before.MUdata.LG.binary);
    usePLDS(submax10.before.MUdata.LG)
    submax10.before.MUdata.LG.PLDS = PLDSout;
%% ------------ SOL ------------
% Calculate PLDS estimate of CI for each force level
    submax10.before.MUdata.SOL.binary_logical = logical(submax10.before.MUdata.SOL.binary);
    usePLDS(submax10.before.MUdata.SOL)
    submax10.before.MUdata.SOL.PLDS = PLDSout;
%%  ------------------------------ 35% MVC --------------------------------
% Load new file - 35% force level
muscles = {'MG','LG','SOL'};
submax35.force = force;
submax35.muscles = muscles;

submax35.before.MUdata = before.MUdata;
submax35.before.force = before.force;
submax35.pre.MUdata = pre.MUdata;
submax35.pre.force = pre.force;
submax35.post.MUdata = post.MUdata;
submax35.post.force = post.force;

clearvars -except 'submax10' 'submax35'

%% Calculate new IDRlinesRaw for each time point  
    submax35.before.MUdata = IDRlinesRaw(submax35.before.MUdata,submax35.muscles);
    submax35.pre.MUdata = IDRlinesRaw(submax35.pre.MUdata,submax35.muscles);
    submax35.post.MUdata = IDRlinesRaw(submax35.post.MUdata,submax35.muscles);

%% ------------ MG -------------
% Calculate PLDS estimate of CI for each force level
    submax35.before.MUdata.MG.binary_logical = logical(submax35.before.MUdata.MG.binary);
    usePLDS(submax35.before.MUdata.MG)
    submax35.before.MUdata.MG.PLDS = PLDSout;  
% ------------ LG ------------
% Calculate PLDS estimate of CI for each force level
    submax35.before.MUdata.LG.binary_logical = logical(submax35.before.MUdata.LG.binary);
    usePLDS(submax35.before.MUdata.LG)
    submax35.before.MUdata.LG.PLDS = PLDSout;
% ------------ SOL ------------
% Calculate PLDS estimate of CI for each force level
    submax35.before.MUdata.SOL.binary_logical = logical(submax35.before.MUdata.SOL.binary);
    usePLDS(submax35.before.MUdata.SOL)
    submax35.before.MUdata.SOL.PLDS = PLDSout; 
%% 
clear('PLDSout');

%% Calculating xcors WITHOUT PLDS
submax35.before.MUdata.LG = muCIScors(submax35.before.MUdata.LG);
submax35.before.MUdata.MG = muCIScors(submax35.before.MUdata.MG);
submax35.before.MUdata.SOL = muCIScors(submax35.before.MUdata.SOL);

submax35.pre.MUdata.LG = muCIScors(submax35.pre.MUdata.LG);
submax35.pre.MUdata.MG = muCIScors(submax35.pre.MUdata.MG);
submax35.pre.MUdata.SOL = muCIScors(submax35.pre.MUdata.SOL);

submax35.post.MUdata.LG = muCIScors(submax35.post.MUdata.LG);
submax35.post.MUdata.MG = muCIScors(submax35.post.MUdata.MG);
submax35.post.MUdata.SOL = muCIScors(submax35.post.MUdata.SOL);

%% Xcorr with force
    submax35.before.MUdata.MG = muFcors(submax35.before.MUdata.MG,submax35.force.before.submax.filt{1,2});
    submax35.before.MUdata.LG = muFcors(submax35.before.MUdata.LG,submax35.force.before.submax.filt{1,2});
    submax35.before.MUdata.SOL = muFcors(submax35.before.MUdata.SOL,submax35.force.before.submax.filt{1,2});

    submax35.pre.MUdata.MG = muFcors(submax35.pre.MUdata.MG,submax35.force.after.submax_pre.filt{1,2});
    submax35.pre.MUdata.LG = muFcors(submax35.pre.MUdata.LG,submax35.force.after.submax_pre.filt{1,2});
    submax35.pre.MUdata.SOL = muFcors(submax35.pre.MUdata.SOL,submax35.force.after.submax_pre.filt{1,2});

    submax35.post.MUdata.MG = muFcors(submax35.post.MUdata.MG,submax35.force.after.submax_post.abs.filt{1,2});
    submax35.post.MUdata.LG = muFcors(submax35.post.MUdata.LG,submax35.force.after.submax_post.abs.filt{1,2});
    submax35.post.MUdata.SOL = muFcors(submax35.post.MUdata.SOL,submax35.force.after.submax_post.abs.filt{1,2});

%% Plotting
%dat10 = 21:35;
dat35 = 1:19;

% Xcorrs vs RTs
figure(1)
tiledlayout(1,3)
nexttile
    scatter(submax35.pre.MUdata.MG.steady30.CV_ISI(dat35),submax35.pre.MUdata.MG.xcors.steady30.CSTmaxcors(dat35)); hold on;
    ylabel('MU activity  - CC -  CST');
    xlabel('CV ISI');
nexttile
    scatter(cell2mat(submax35.pre.MUdata.MG.RTs.force(dat35)),submax35.pre.MUdata.MG.xcors.steady30.CSTmaxcors(dat35)); hold on;
    ylabel('Indiv. MU activity  - CC -  CST');
    xlabel('Recruitment Threshold');
nexttile
    scatter(cell2mat(submax35.pre.MUdata.MG.RTs.force(dat35)),submax35.pre.MUdata.MG.steady30.CV_ISI(dat35)); hold on;
    ylabel('CV ISI');
    xlabel('Recruitment Threshold');
% with force
figure(2)   
tiledlayout(1,3)
nexttile
    scatter(submax35.pre.MUdata.MG.xcors.steady30.Fmaxcors(dat35),submax35.pre.MUdata.MG.steady30.CV_ISI(dat35),'r'); hold on;
    xlabel('Indiv. MU activity  - CC -  Force');
    ylabel('CV ISI');
nexttile
    scatter(cell2mat(submax35.pre.MUdata.MG.RTs.force(dat35)),submax35.pre.MUdata.MG.xcors.steady30.Fmaxcors(dat35),'r'); hold on;
    ylabel('Indiv. MU activity   - CC -  Force');
    xlabel('Recruitment Threshold');
nexttile
    scatter(submax35.pre.MUdata.MG.xcors.steady30.CSTmaxcors(dat35),submax35.pre.MUdata.MG.xcors.steady30.Fmaxcors(dat35),'r'); hold on;
    xlabel('Indiv. MU activity  - CC -  CST');
    ylabel('Indiv. MU activity  - CC -  Force');
%% Section where all active
plotSpikeRaster(logical(submax35.pre.MUdata.MG.binary),'PlotType','vertline','VertSpikeHeight',0.5);
%%
start = 79420;
endd = 98920;
%% FCC
% 400ms hanning window and High pass filter all IDRs
% 0.75 hz high pass filter "to remove offsets and trends" (negro 2009)
fs = 2000;
for mu = 1:length(submax35.post.MUdata.MG.rawlines)
    temp = submax35.post.MUdata.MG.rawlines{mu};
    if isempty(temp)
    else
        temp = temp(start:endd);
        temp = conv(temp,hann(800),'same');
        idrs(mu,:) = highpass(temp, 0.75, fs);
    end
end

%% FCC of smoothed, detrended IDR lines
rows = [12,14:21,23:31];
[coeff,score,latent,tsquared,explained,mu] = pca(idrs(rows,:));

% explained = % of the variance explained by each component
plot(explained);

%% Xcorr between different muscles CST and force
fc = 0.75;                                 
fsamp = 2000;                                  
[filt2, filt1] = butter(4,fc/fsamp/2,'high');

st = submax35.pre.MUdata.MG.steady30.start;
en = submax35.pre.MUdata.MG.steady30.endd;
fo = filtfilt(filt2,filt1,submax35.force.after.submax_pre.filt{1,1}(st:en));

% MG
    cstMG = filtfilt(filt2,filt1,submax35.pre.MUdata.MG.cst(st:en));
    [sigcorMG,siglagMG] = xcorr(cstMG,fo,'coeff');
    [maxcorMG,lagMG] = max(sigcorMG);
% LG
    cstLG = filtfilt(filt2,filt1,submax35.pre.MUdata.LG.cst(st:en));
    [sigcorLG,siglagLG] = xcorr(cstLG,fo,'coeff');
    [maxcorLG,lagLG] = max(sigcorLG);
% SOL
    cstSOL = filtfilt(filt2,filt1,submax35.pre.MUdata.SOL.cst(st:en));
    [sigcorSOL,siglagSOL] = xcorr(cstSOL,fo,'coeff');
    [maxcorSOL,lagSOL] = max(sigcorSOL);
% ALL
    cst = filtfilt(filt2,filt1,submax35.pre.MUdata.cst(st:en));
    [sigcor,siglag] = xcorr(cst,fo,'coeff');
    [maxcor,lag] = max(sigcor);

    
tiledlayout(4,1)   
nexttile
    yyaxis left
    plot(cstMG);
    yyaxis right
    plot(fo);
    title(maxcorMG);
nexttile
    yyaxis left
    plot(cstLG);
    yyaxis right
    plot(fo);
    title(maxcorLG);
nexttile
    yyaxis left
    plot(cstSOL);
    yyaxis right
    plot(fo);
    title(maxcorSOL);
nexttile
    yyaxis left
    plot(cst);
    yyaxis right
    plot(fo);
    title(maxcor);
    
%% Xcorr between different muscles CSTs
fc = 0.75;                                 
fsamp = 2000;                                  
[filt2, filt1] = butter(4,fc/fsamp/2,'high');

st = submax35.pre.MUdata.MG.steady30.start;
en = submax35.pre.MUdata.MG.steady30.endd;

% MG v LG
    cstMG = filtfilt(filt2,filt1,submax35.pre.MUdata.MG.cst(st:en));
    cstLG = filtfilt(filt2,filt1,submax35.pre.MUdata.MG.cst(st:en));
    [sigcorMGLG,siglagMGLG] = xcorr(cstMG,cstLG,'coeff');
    [maxcorMGLG,lagMGLG] = max(sigcorMGLG);
% MG v SOL
    [sigcorMGSOL,siglagMGSOL] = xcorr(cstMG,cstSOL,'coeff');
    [maxcorMGSOL,lagMGSOL] = max(sigcorMGSOL);
    
tiledlayout(4,1)   
nexttile
    yyaxis left
    plot(cstMG);
    yyaxis right
    plot(cstSOL);
    title(maxcorMGSOL);
nexttile
    yyaxis left
    plot(cstLG);
    yyaxis right
    plot(fo);
    title(maxcorLG);