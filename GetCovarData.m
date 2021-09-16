% Collect metrics for pCSI and PCA for good MG data people

% Load file

%% Select time
day = 'stretch';
level = 'submax10';
win = 'w1';

%% Data
l(1) = length(PFdata.(day).(level).MUdata.before.MG.PCA.iter.(win).explained_mean(~isnan(PFdata.(day).(level).MUdata.before.MG.PCA.iter.(win).explained_mean)));
l(2) = length(PFdata.(day).(level).MUdata.pre.MG.PCA.iter.(win).explained_mean(~isnan(PFdata.(day).(level).MUdata.pre.MG.PCA.iter.(win).explained_mean)));
l(3) = length(PFdata.(day).(level).MUdata.post.MG.PCA.iter.(win).explained_mean(~isnan(PFdata.(day).(level).MUdata.post.MG.PCA.iter.(win).explained_mean)));
N = min(l); % maximum number of MUs
Nhalf = floor(N/2);
s = size(PCSI_1,1)+1;

% Record subject
sub(s) = 9;
% pCSI
    % Estimated number of MUs at coh = 1
    PCSI_1(s,1) = PFdata.(day).(level).MUdata.before.MG.pCSI.(win).xcoh1;
    PCSI_1(s,2) = PFdata.(day).(level).MUdata.pre.MG.pCSI.(win).xcoh1;
    PCSI_1(s,3) = PFdata.(day).(level).MUdata.post.MG.pCSI.(win).xcoh1;
    % Increase in pCSI between 1 v 1 MU and N vs N:
    PCSI_2(s,1) = PFdata.(day).(level).MUdata.before.MG.pCSI.(win).pCSI(Nhalf)-PFdata.(day).(level).MUdata.before.MG.pCSI.(win).pCSI(1);
    PCSI_2(s,2) = PFdata.(day).(level).MUdata.pre.MG.pCSI.(win).pCSI(Nhalf)-PFdata.(day).(level).MUdata.pre.MG.pCSI.(win).pCSI(1);
    PCSI_2(s,3) = PFdata.(day).(level).MUdata.post.MG.pCSI.(win).pCSI(Nhalf)-PFdata.(day).(level).MUdata.post.MG.pCSI.(win).pCSI(1);
    % Absolute pCSI at N
    PCSI_3(s,1) = PFdata.(day).(level).MUdata.before.MG.pCSI.(win).pCSI(Nhalf);
    PCSI_3(s,2) = PFdata.(day).(level).MUdata.pre.MG.pCSI.(win).pCSI(Nhalf);
    PCSI_3(s,3) = PFdata.(day).(level).MUdata.post.MG.pCSI.(win).pCSI(Nhalf);
    