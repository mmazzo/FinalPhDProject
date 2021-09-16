% Covariance between estimates

% Data
day = 'stretch';
level = 'submax10';
win = 'w1';

l(1) = length(PFdata.(day).(level).MUdata.before.MG.PCA.iter.(win).explained_mean(~isnan(PFdata.(day).(level).MUdata.before.MG.PCA.iter.(win).explained_mean)));
l(2) = length(PFdata.(day).(level).MUdata.pre.MG.PCA.iter.(win).explained_mean(~isnan(PFdata.(day).(level).MUdata.pre.MG.PCA.iter.(win).explained_mean)));
l(3) = length(PFdata.(day).(level).MUdata.post.MG.PCA.iter.(win).explained_mean(~isnan(PFdata.(day).(level).MUdata.post.MG.PCA.iter.(win).explained_mean)));
N = min(l); % maximum number of MUs
Nhalf = floor(N/2);
% pCSI
    % Estimated number of MUs at coh = 1
    PCSI_1(1) = PFdata.(day).(level).MUdata.before.MG.pCSI.(win).xcoh1;
    PCSI_1(2) = PFdata.(day).(level).MUdata.pre.MG.pCSI.(win).xcoh1;
    PCSI_1(3) = PFdata.(day).(level).MUdata.post.MG.pCSI.(win).xcoh1;
    % Increase in pCSI between 1 v 1 MU and N vs N:
    PCSI_2(1) = PFdata.(day).(level).MUdata.before.MG.pCSI.(win).pCSI(Nhalf)-PFdata.(day).(level).MUdata.before.MG.pCSI.(win).pCSI(1);
    PCSI_2(2) = PFdata.(day).(level).MUdata.pre.MG.pCSI.(win).pCSI(Nhalf)-PFdata.(day).(level).MUdata.pre.MG.pCSI.(win).pCSI(1);
    PCSI_2(3) = PFdata.(day).(level).MUdata.post.MG.pCSI.(win).pCSI(Nhalf)-PFdata.(day).(level).MUdata.post.MG.pCSI.(win).pCSI(1);
    % Absolute pCSI at N
    PCSI_3(1) = PFdata.(day).(level).MUdata.before.MG.pCSI.(win).pCSI(Nhalf);
    PCSI_3(2) = PFdata.(day).(level).MUdata.pre.MG.pCSI.(win).pCSI(Nhalf);
    PCSI_3(3) = PFdata.(day).(level).MUdata.post.MG.pCSI.(win).pCSI(Nhalf);
    
    
    
% PCA
    % Estimated % expl asymptote for iterative PCA
    PCA_1(1) = PFdata.(day).(level).MUdata.before.MG.PCA.iter.(win).pseudoA;
    PCA_1(2) = PFdata.(day).(level).MUdata.pre.MG.PCA.iter.(win).pseudoA;
    PCA_1(3) = PFdata.(day).(level).MUdata.post.MG.PCA.iter.(win).pseudoA;
    % Absolute % expl at N
    PCA_2(1) = PFdata.(day).(level).MUdata.before.MG.PCA.iter.(win).explained_mean(N);
    PCA_2(2) = PFdata.(day).(level).MUdata.pre.MG.PCA.iter.(win).explained_mean(N);
    PCA_2(3) = PFdata.(day).(level).MUdata.post.MG.PCA.iter.(win).explained_mean(N);
   
%% Normalize
PCSI_1 = normalize(PCSI_1);
PCSI_2 = normalize(PCSI_2);
PCSI_3 = normalize(PCSI_3);
PCA_1 = normalize(PCA_1);
PCA_2 = normalize(PCA_2);

%% Plot
figure(1)
tiledlayout(1,2)
nexttile
    plot(PCSI_2,'y');
    hold on;
    plot(PCSI_3,'k');
    plot(PCA_1,'b');
    plot(PCA_2,'c');
    title('Higher Values = Higher Proportion of Common Input')
    legend('pCSI - Increase in Coh','pCSI - Coh at N','PCA - % Expl asymptote','PCA - % Expl at N')
    
nexttile
    plot(PCSI_1,'r');
    legend('pCSI - # MUs at Coh = 1')
    title('Higher Values = Lower Proportion of Common Input')
%% Save data between files
day = 'stretch';
win = 'w1';
level = 'submax10';

S.MG.before.pCSI = PFdata.(day).(level).MUdata.before.MG.pCSI.(win).pCSI;
S.MG.pre.pCSI = PFdata.(day).(level).MUdata.pre.MG.pCSI.(win).pCSI;
S.MG.post.pCSI = PFdata.(day).(level).MUdata.post.MG.pCSI.(win).pCSI;

S.MG.before.PCA = PFdata.(day).(level).MUdata.before.MG.PCA.iter.(win).explained_mean;
S.MG.pre.PCA = PFdata.(day).(level).MUdata.pre.MG.PCA.iter.(win).explained_mean;
S.MG.post.PCA = PFdata.(day).(level).MUdata.post.MG.PCA.iter.(win).explained_mean;

S.LG.before.pCSI = PFdata.(day).(level).MUdata.before.LG.pCSI.(win).pCSI;
S.LG.pre.pCSI = PFdata.(day).(level).MUdata.pre.LG.pCSI.(win).pCSI;
S.LG.post.pCSI = PFdata.(day).(level).MUdata.post.LG.pCSI.(win).pCSI;

S.LG.before.PCA = PFdata.(day).(level).MUdata.before.LG.PCA.iter.(win).explained_mean;
S.LG.pre.PCA = PFdata.(day).(level).MUdata.pre.LG.PCA.iter.(win).explained_mean;
S.LG.post.PCA = PFdata.(day).(level).MUdata.post.LG.PCA.iter.(win).explained_mean;

S.SOL.before.pCSI = PFdata.(day).(level).MUdata.before.SOL.pCSI.(win).pCSI;
S.SOL.pre.pCSI = PFdata.(day).(level).MUdata.pre.SOL.pCSI.(win).pCSI;
S.SOL.post.pCSI = PFdata.(day).(level).MUdata.post.SOL.pCSI.(win).pCSI;

S.SOL.before.PCA = PFdata.(day).(level).MUdata.before.SOL.PCA.iter.(win).explained_mean;
S.SOL.pre.PCA = PFdata.(day).(level).MUdata.pre.SOL.PCA.iter.(win).explained_mean;
S.SOL.post.PCA = PFdata.(day).(level).MUdata.post.SOL.PCA.iter.(win).explained_mean;

%%
day = 'control';
win = 'w1';
level = 'submax10';

C.MG.before.pCSI = PFdata.(day).(level).MUdata.before.MG.pCSI.(win).pCSI;
C.MG.pre.pCSI = PFdata.(day).(level).MUdata.pre.MG.pCSI.(win).pCSI;
C.MG.post.pCSI = PFdata.(day).(level).MUdata.post.MG.pCSI.(win).pCSI;

C.MG.before.PCA = PFdata.(day).(level).MUdata.before.MG.PCA.iter.(win).explained_mean;
C.MG.pre.PCA = PFdata.(day).(level).MUdata.pre.MG.PCA.iter.(win).explained_mean;
C.MG.post.PCA = PFdata.(day).(level).MUdata.post.MG.PCA.iter.(win).explained_mean;

C.LG.before.pCSI = PFdata.(day).(level).MUdata.before.LG.pCSI.(win).pCSI;
C.LG.pre.pCSI = PFdata.(day).(level).MUdata.pre.LG.pCSI.(win).pCSI;
C.LG.post.pCSI = PFdata.(day).(level).MUdata.post.LG.pCSI.(win).pCSI;

C.LG.before.PCA = PFdata.(day).(level).MUdata.before.LG.PCA.iter.(win).explained_mean;
C.LG.pre.PCA = PFdata.(day).(level).MUdata.pre.LG.PCA.iter.(win).explained_mean;
C.LG.post.PCA = PFdata.(day).(level).MUdata.post.LG.PCA.iter.(win).explained_mean;

C.SOL.before.pCSI = PFdata.(day).(level).MUdata.before.SOL.pCSI.(win).pCSI;
C.SOL.pre.pCSI = PFdata.(day).(level).MUdata.pre.SOL.pCSI.(win).pCSI;
C.SOL.post.pCSI = PFdata.(day).(level).MUdata.post.SOL.pCSI.(win).pCSI;

C.SOL.before.PCA = PFdata.(day).(level).MUdata.before.SOL.PCA.iter.(win).explained_mean;
C.SOL.pre.PCA = PFdata.(day).(level).MUdata.pre.SOL.PCA.iter.(win).explained_mean;
C.SOL.post.PCA = PFdata.(day).(level).MUdata.post.SOL.PCA.iter.(win).explained_mean;

%% 
figure(1)
set(gcf, 'Renderer', 'painters');

t = tiledlayout(3,2);
title(t,'Day 1')
nexttile
    plot(S.MG.before.PCA,'color',cm(1,:))
    hold on;
    plot(S.MG.pre.PCA,'color',cm(2,:))
    plot(S.MG.post.PCA,'color',cm(3,:))
    title('MG')
nexttile
    plot(S.MG.before.pCSI,'color',cm(1,:))
    hold on;
    plot(S.MG.pre.pCSI,'color',cm(2,:))
    plot(S.MG.post.pCSI,'color',cm(3,:))
    title('MG')
nexttile
    plot(S.LG.before.PCA,'color',cm(1,:))
    hold on;
    plot(S.LG.pre.PCA,'color',cm(2,:))
    plot(S.LG.post.PCA,'color',cm(3,:))
    title('LG')
nexttile
    plot(S.LG.before.pCSI,'color',cm(1,:))
    hold on;
    plot(S.LG.pre.pCSI,'color',cm(2,:))
    plot(S.LG.post.pCSI,'color',cm(3,:))
    title('LG')
nexttile
    plot(S.SOL.before.PCA,'color',cm(1,:))
    hold on;
    plot(S.SOL.pre.PCA,'color',cm(2,:))
    plot(S.SOL.post.PCA,'color',cm(3,:))
    title('SOL')
nexttile
    plot(S.SOL.before.pCSI,'color',cm(1,:))
    hold on;
    plot(S.SOL.pre.pCSI,'color',cm(2,:))
    plot(S.SOL.post.pCSI,'color',cm(3,:))
    title('SOL')


figure(2)
set(gcf, 'Renderer', 'painters');
t = tiledlayout(3,2);
title(t,'Day 2')
nexttile
    plot(C.MG.before.PCA,'color',cm(1,:))
    hold on;
    plot(C.MG.pre.PCA,'color',cm(2,:))
    plot(C.MG.post.PCA,'color',cm(3,:))
    title('MG')
nexttile
    plot(C.MG.before.pCSI,'color',cm(1,:))
    hold on;
    plot(C.MG.pre.pCSI,'color',cm(2,:))
    plot(C.MG.post.pCSI,'color',cm(3,:))
    title('MG')
nexttile
    plot(C.LG.before.PCA,'color',cm(1,:))
    hold on;
    plot(C.LG.pre.PCA,'color',cm(2,:))
    plot(C.LG.post.PCA,'color',cm(3,:))
    title('LG')
nexttile
    plot(C.LG.before.pCSI,'color',cm(1,:))
    hold on;
    plot(C.LG.pre.pCSI,'color',cm(2,:))
    plot(C.LG.post.pCSI,'color',cm(3,:))
    title('LG')
nexttile
    plot(C.SOL.before.PCA,'color',cm(1,:))
    hold on;
    plot(C.SOL.pre.PCA,'color',cm(2,:))
    plot(C.SOL.post.PCA,'color',cm(3,:))
    title('SOL')
nexttile
    plot(C.SOL.before.pCSI,'color',cm(1,:))
    hold on;
    plot(C.SOL.pre.pCSI,'color',cm(2,:))
    plot(C.SOL.post.pCSI,'color',cm(3,:))
    title('SOL')