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

clearvars -except 'submax10'


%% Calculate new IDRlinesRaw for each time point  
    %submax10.before.MUdata = IDRlinesRaw(submax10.before.MUdata,submax10.muscles);
    submax10.pre.MUdata = IDRlinesRaw(submax10.pre.MUdata,submax10.muscles);
    %submax10.post.MUdata = IDRlinesRaw(submax10.post.MUdata,submax10.muscles);
%% ------------ MG -------------
% Calculate PLDS estimate of CI for each force level
    submax10.before.MUdata.MG.binary_logical = logical(submax10.before.MUdata.MG.binary);
    usePLDS(submax10.before.MUdata.MG)
    submax10.before.MUdata.MG.PLDS = PLDSout;
    
% Calculating new residuals
    % Create new CST with 150 ms hanning window
    hann_window = hann(300);
    submax10.before.MUdata.MG.cst150 = conv(submax10.before.MUdata.MG.cst_unfilt,hann_window);
    %submax10.before.MUdata.MG = muresidnew(submax10.before.MUdata.MG);
    submax10.before.MUdata.MG = muresid_discrete(submax10.before.MUdata.MG);
     
%% ------------ LG ------------
% Calculate PLDS estimate of CI for each force level
    submax10.before.MUdata.LG.binary_logical = logical(submax10.before.MUdata.LG.binary);
    usePLDS(submax10.before.MUdata.LG)
    submax10.before.MUdata.LG.PLDS = PLDSout;
% Calculating new residuals
    % Create new CST with 150 ms hanning window
    hann_window = hann(300);
    submax10.before.MUdata.LG.cst150 = conv(submax10.before.MUdata.LG.cst_unfilt,hann_window);
    %submax10.before.MUdata.LG = muresidnew(submax10.before.MUdata.LG);
    submax10.before.MUdata.LG = muresid_discrete(submax10.before.MUdata.LG);
 
%% ------------ SOL ------------
% Calculate PLDS estimate of CI for each force level
    submax10.before.MUdata.SOL.binary_logical = logical(submax10.before.MUdata.SOL.binary);
    usePLDS(submax10.before.MUdata.SOL)
    submax10.before.MUdata.SOL.PLDS = PLDSout;

% Calculating new residuals
    % Create new CST with 150 ms hanning window
    hann_window = hann(300);
    submax10.before.MUdata.SOL.cst150 = conv(submax10.before.MUdata.SOL.cst_unfilt,hann_window);
    %submax10.before.MUdata.SOL = muresidnew(submax10.before.MUdata.SOL);
    submax10.before.MUdata.SOL = muresid_discrete(submax10.before.MUdata.SOL);

%%  ------------------------------ 35% MVC --------------------------------
% Load new file - 35% force level

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
    %submax35.pre.MUdata = IDRlinesRaw(submax35.pre.MUdata,submax35.muscles);
    %submax35.post.MUdata = IDRlinesRaw(submax35.post.MUdata,submax35.muscles);

%% ------------ MG -------------
% Calculate PLDS estimate of CI for each force level
    submax35.before.MUdata.MG.binary_logical = logical(submax35.before.MUdata.MG.binary);
    usePLDS(submax35.before.MUdata.MG)
    submax35.before.MUdata.MG.PLDS = PLDSout;
    
% Calculating new residuals
    % Create new CST with 150 ms hanning window
    hann_window = hann(300);
    submax35.before.MUdata.MG.cst150 = conv(submax35.before.MUdata.MG.cst_unfilt,hann_window);
    %submax35.before.MUdata.MG = muresidnew(submax35.before.MUdata.MG);
    submax35.before.MUdata.MG = muresid_discrete(submax35.before.MUdata.MG);
     
% ------------ LG ------------
% Calculate PLDS estimate of CI for each force level
    submax35.before.MUdata.LG.binary_logical = logical(submax35.before.MUdata.LG.binary);
    usePLDS(submax35.before.MUdata.LG)
    submax35.before.MUdata.LG.PLDS = PLDSout;
% Calculating new residuals
    % Create new CST with 150 ms hanning window
    hann_window = hann(300);
    submax35.before.MUdata.LG.cst150 = conv(submax35.before.MUdata.LG.cst_unfilt,hann_window);
    %submax35.before.MUdata.LG = muresidnew(submax35.before.MUdata.LG);
    submax35.before.MUdata.LG = muresid_discrete(submax35.before.MUdata.LG);
 
% ------------ SOL ------------
% Calculate PLDS estimate of CI for each force level
    submax35.before.MUdata.SOL.binary_logical = logical(submax35.before.MUdata.SOL.binary);
    usePLDS(submax35.before.MUdata.SOL)
    submax35.before.MUdata.SOL.PLDS = PLDSout;

% Calculating new residuals
    % Create new CST with 150 ms hanning window
    hann_window = hann(300);
    submax35.before.MUdata.SOL.cst150 = conv(submax35.before.MUdata.SOL.cst_unfilt,hann_window);
    %submax35.before.MUdata.SOL = muresidnew(submax35.before.MUdata.SOL);
    submax35.before.MUdata.SOL = muresid_discrete(submax35.before.MUdata.SOL);
      
%% 
clear('PLDSout', 'hann_window');

%% %%%%%%%%%%%%%%%%%%%%%%% Aggregating %%%%%%%%%%%%%%%%%%%%%%%%%%

% PLDS
    pMG10 = submax10.before.MUdata.MG.residualsPLDS.steady30.HPF_norm1_means(submax10.before.MUdata.MG.residualsPLDS.steady30.HPF_norm1_means ~=0);
    pLG10 = submax10.before.MUdata.LG.residualsPLDS.steady30.HPF_norm1_means(submax10.before.MUdata.LG.residualsPLDS.steady30.HPF_norm1_means ~=0);
    pSOL10 = submax10.before.MUdata.SOL.residualsPLDS.steady30.HPF_norm1_means(submax10.before.MUdata.SOL.residualsPLDS.steady30.HPF_norm1_means ~=0);

    pmeans10 = vertcat(pMG10',pLG10',pSOL10');

    pMG35 = submax35.before.MUdata.MG.residualsPLDS.steady30.HPF_norm1_means(submax35.before.MUdata.MG.residualsPLDS.steady30.HPF_norm1_means ~=0);
    pLG35 = submax35.before.MUdata.LG.residualsPLDS.steady30.HPF_norm1_means(submax35.before.MUdata.LG.residualsPLDS.steady30.HPF_norm1_means ~=0);
    pSOL35 = submax35.before.MUdata.SOL.residualsPLDS.steady30.HPF_norm1_means(submax35.before.MUdata.SOL.residualsPLDS.steady30.HPF_norm1_means ~=0);

    pmeans35 = vertcat(pMG35',pLG35',pSOL35');
    
% CST
    cMG10 = submax10.before.MUdata.MG.residualsPLDS.steady30.HPF_norm1_means(submax10.before.MUdata.MG.residualsPLDS.steady30.HPF_norm1_means ~=0);
    cLG10 = submax10.before.MUdata.LG.residualsPLDS.steady30.HPF_norm1_means(submax10.before.MUdata.LG.residualsPLDS.steady30.HPF_norm1_means ~=0);
    cSOL10 = submax10.before.MUdata.SOL.residualsPLDS.steady30.HPF_norm1_means(submax10.before.MUdata.SOL.residualsPLDS.steady30.HPF_norm1_means ~=0);

    cmeans10 = vertcat(cMG10',cLG10',cSOL10');

    cMG35 = submax35.before.MUdata.MG.residualsPLDS.steady30.HPF_norm1_means(submax35.before.MUdata.MG.residualsPLDS.steady30.HPF_norm1_means ~=0);
    cLG35 = submax35.before.MUdata.LG.residualsPLDS.steady30.HPF_norm1_means(submax35.before.MUdata.LG.residualsPLDS.steady30.HPF_norm1_means ~=0);
    cSOL35 = submax35.before.MUdata.SOL.residualsPLDS.steady30.HPF_norm1_means(submax35.before.MUdata.SOL.residualsPLDS.steady30.HPF_norm1_means ~=0);

    cmeans35 = vertcat(cMG35',cLG35',cSOL35');
%% %%%%%%%%%%%%%%%%%%%%%%% Plotting %%%%%%%%%%%%%%%%%%%%%%%%%%
tiledlayout(2,2)
nexttile
    boxplot(pmeans10,'Color','r')
    ylim([0 0.5])
    title('10% MVC PLDS')
nexttile
    boxplot(pmeans35,'Color','r')
    ylim([0 0.5])
    title('35% MVC PLDS')
nexttile
    boxplot(cmeans10,'Color','b')
    ylim([0 0.5])
    title('10% MVC CST')
nexttile
    boxplot(cmeans35,'Color','b')
    ylim([0 0.5])
    title('35% MVC CST')

    
%% pCSI method to compare

[F10,COHT10,pCSI_all10,pCSI10] = pCSI_COH_updated_lowF(submax10.pre.MUdata.MG.binary,1,2000,100);
disp('10% pCSI Calculations Done');
[F35,COHT35,pCSI_all35,pCSI35] = pCSI_COH_updated_lowF(submax35.pre.MUdata.MG.binary,1,2000,100);
disp('35% pCSI Calculations Done');

%% 
cm1 = cool(size(COHT10,1));
cm2 = hot(size(COHT35,1));

figure(1)
tiledlayout(1,3)
nexttile
plot(pCSI10,'cyan'); xlim([0 20]); ylim([0 1]); hold on;
plot(pCSI35,'red'); xlim([0 20]); ylim([0 1]); hold on;
nexttile;
for i = 1:size(COHT10,1)
    plot(F10,COHT10(i,:),'color',cm1(i,:))
    xlim([0 25])
    ylim([0 1])
    title('10% MVC');
    hold on
end

nexttile;
for p = 1:size(COHT35,1)
    plot(F35,COHT35(p,:),'color',cm2(p,:))
    xlim([0 25])
    ylim([0 1])
    title('35% MVC');
    hold on
end

%% PLDS xcorr

for mu = 1:length(submax10.before.MUdata.MG.residualsPLDS.steady30.HPF.rawlines)

    [sigcor,siglag] = xcorr(submax10.before.MUdata.MG.residualsPLDS.steady30.HPF.rawlines(mu,:),...
        submax10.before.MUdata.MG.residualsPLDS.steady30.HPF.PLDS,'coeff');

        [maxcor,ind] = max(sigcor);
        maxcors(mu,1) = maxcor;
        t = siglag(ind);
        if isnan(maxcor)
        lags(mu,1) = NaN;
        else
        lags(mu,1) = t;
        end
        %Bt = abs(t(mu,1));
        
%          fig = figure(1);
%          plot(siglag, sigcor,[t t(mu,1)],[-0.5 1]);
%          text(t+100,0.5,['Lag: ' int2str(t)])
%          text(t+100,0.6,['Lag: ' int2str(maxcor)])
%          waitfor(fig);
end

meanlag = round(nanmean(lags)); % -214
meancors = nanmean(maxcors); %  0.3615

%% CST xcorr

for mu = 1:length(submax10.before.MUdata.MG.residualsCST.h400.steady30.HPF.rawlines)

    [sigcor,siglag] = xcorr(submax10.before.MUdata.MG.residualsCST.h400.steady30.HPF.rawlines(mu,:),...
        submax10.before.MUdata.MG.residualsCST.h400.steady30.HPF.cst,'coeff');

        [maxcor,ind] = max(sigcor);
        maxcors(mu,1) = maxcor;
        t = siglag(ind);
        if isnan(maxcor)
        lags(mu,1) = NaN;
        else
        lags(mu,1) = t;
        end
        %Bt = abs(t(mu,1));
        
%          fig = figure(1);
%          plot(siglag, sigcor,[t t(mu,1)],[-0.5 1]);
%          text(t+100,0.5,['Lag: ' int2str(t)])
%          text(t+100,0.6,['Lag: ' int2str(maxcor)])
%          waitfor(fig);
end

meanlag = round(nanmean(lags)); % - 118
meancors = nanmean(maxcors); %  0.6919