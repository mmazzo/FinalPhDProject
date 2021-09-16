% Visualize Synce-SE triggers & divide force signals into appropriate segments
%           AFTER intervention
% Import .mat files exported from Spike2
% Saves .mat file with force sections
% ------------------------------------------------------------------------------------------

%cd('C:\Users\Borelli\Desktop\SFU\');
%addpath(genpath('C:\Users\Borelli\Desktop\SFU\'));

[filename, filepath] = uigetfile;
datastruct = load(filename);

storedvars = fieldnames(datastruct) ;
    % Force
    forcestruct = storedvars{1};
    forcedat = datastruct.(forcestruct);
    force = forcedat.values;
    % SyncSE
    SyncSEstruct = storedvars{2};
    SyncSE = datastruct.(SyncSEstruct);
    SyncSE.times = (SyncSE.times)*2000;

file = split(filename,'.'); file = file{1,1};
clear('filename','datastruct','forcestruct','SyncSEstruct','storedvars');

% ---------------------------------------------------------------------------------------- 
% Filter signals
% Save unfiltered signal
force_unfilt = force;

fc = 20;         % Filter cutoff = 20 Hz
sf = 2000;           % Sampling frequency (rate) = 2000 Hz
[filt2, filt1] = butter(2,fc/sf/2,'low');      % Apply 2nd order Butterworth filter
force = filtfilt(filt2, filt1, force);           % doubles to create 4th order

clear('filt1','filt2','fc','sf');

% ---------------------------------------------------------------------------------------- 
% Convert SyncSE signal into vertical lines:
    numtrig = nnz(~SyncSE.level);   % Number of times "level" array = 0
        for i = 1:numtrig
            j = i*2;
            temptrig(1,i) = SyncSE.times(j,1);
            % Clear any duplicate triggers
            if i > 1
                if temptrig(1,i)-temptrig(1,i-1) < 1000 %closer than 0.5s
                   temptrig(1,i) = NaN;
                else
                end
            else
            end
        end
        temptrig = temptrig(~isnan(temptrig));
        clear('j','numtrig');
        

% Plot to visualize signals
fig = figure(1);
yyaxis left
    plot(force);
    set(gcf,'Position',[100 700 1300 400])
yyaxis right
    hold on;
    for j = 1:length(temptrig)
        xpt = temptrig(1,j);
        plot([xpt xpt], [0 1]);
    end  
  
  % Select three areas as "baseline" force
  title('Select three sections to define baseline:');
  for i = 1:6
    [temp,] = ginput(1); base.ind(1,i) = round(temp(1,1));
  end
  base.mean(1,1) = mean(force(base.ind(1,1):base.ind(1,2)));
  base.mean(1,2) = mean(force(base.ind(1,3):base.ind(1,4)));
  base.mean(1,3) = mean(force(base.ind(1,5):base.ind(1,6)));
  base.mean = mean(base.mean(1,:));
  
  % Adjust for baseline mean
  force = force - base.mean;
  force_unfilt = force_unfilt - base.mean;
  
  clear('i');  
  
% ---------------------------------------------------------------------------------------- 
% Add missing triggers to divide force
% Missing triggers?
miss = inputdlg('How many triggers are missing?');
miss = str2num(miss{1,1});

% Add new ones
for i = 1:miss
    [temp,] = ginput(1);
    miss(1,i) = round(temp(1,1));
end

clear('i','temp');

% Rising edge of square waveform (1 at rest, 0 when depressed)
%  Index at trigger = 0

% Loop for # of triggers
    numtrig = nnz(~SyncSE.level);   % Number of times "level" array = 0
        for i = 1:numtrig
            j = i*2;
            SyncSE.trig(1,i) = SyncSE.times(j,1);
            % Clear any duplicate triggers
            if i > 1
                if SyncSE.trig(1,i)-SyncSE.trig(1,i-1) < 1000 %closer than 0.5s
                   SyncSE.trig(1,i) = NaN;
                else
                end
            else
            end
        end
        SyncSE.trig = SyncSE.trig(~isnan(SyncSE.trig));
        
        clear('j')

% Add manually added triggers
SyncSE.trig = [miss,SyncSE.trig];
SyncSE.trig = sort(SyncSE.trig);
        
% Adjust to match OTB EMG trigger
offset = (0.0332*2000); % 33.2 ms offset
        % Force trigger is 33.2 ms ahead of OTB recorded trigger b/c of
        % wired connection vs. transmitter -> receiver then SE -> laptop
trig = SyncSE.trig+(offset);

close(fig);

%% ----------------------------------------------------------------------------------------  
% Check for unwanted triggers
fig = figure(1);
yyaxis left
    plot(force);
    set(gcf,'Position',[100 700 1300 400])
yyaxis right 
        hold on;
        for j = 1:length(trig)
            xpt = trig(1,j);
            plot([xpt xpt], [0 1]);
        end

% User input: Y or N remove trigger?
answer = questdlg('Do you need to remove any extra/unwanted triggers?', ...
	'Extra Trigger?', ...
	'Yes','No','No');
    % Handle response
    switch answer
        case 'Yes'
            rem = 1;
        case 'No'
            rem = 0;
    end

        % Remove extra/unwanted trigger 
        if rem == 1
           % Trigger number to remove
           n = inputdlg('Trigger numbers to remove? Separate by commas:');
           n = str2num(n{1,1});
           SyncSE.trig(n) = [];
           trig(n) = [];
        else
        end

        close(fig);

%% ----------------------------------------------------------------------------------------
% Plot and define sections for multiple MVCs
fig = figure(1);            
plot(force,'color', 'black', 'LineWidth',1)
title('Trigger = start of MVC section. Click = end MVC section.');
set(gcf,'Position',[100 700 1300 400])
hold on;

        % Plot Sync trigger inputs
        for i = 1:length(SyncSE.trig)
            line([SyncSE.trig(1,i) SyncSE.trig(1,i)] , [-0.2 1])
        end

        clear('i')

% Number of MVCs?
num = inputdlg('Number of MVCs:');
num = str2num(num{1,1});


% Make selections for MVCs

for i = 1:num
    [ind,] = ginput(1);
    ind = round(ind(1,1));  
    % first MVC is marked by 5th trigger
    MVCind(i,1) = round(trig(1,(i+4))); % 4 triggers before MVCs (before and after each submax contr)
    MVCind(i,2) = ind;
end
    % MVCind = reshape(MVCind,2,[])';
    clear('i','clicks','ind')

% Use triggers to define sections for submaximal contractions
    % 2 pre-MVC submax contractions
        preind(1,1) = round(trig(1,1));
        preind(1,2) = round(trig(1,2));
        preind(2,1) = round(trig(1,3));
        preind(2,2) = round(trig(1,4));

% Relative or Absolute first for post-MVC contractions?

answer = questdlg('Absolute or relative contractions first?', ...
	'First: Abs or Rel', ...
	'Absolute','Relative','Cancel');
% Handle response
switch answer
    case 'Absolute'
        order = 1;
    case 'Relative'
        order = 2;
    case 'Cancel'
end

%% Based on order, use triggers to define sections
if order == 1
    %disp('abs first')
        % Make selections for 2 Absolute post-MVC contractions
            postind.abs(1,1) = round(trig(1,5+num));
            postind.abs(1,2) = round(trig(1,6+num));
            postind.abs(2,1) = round(trig(1,7+num));
            postind.abs(2,2) = round(trig(1,8+num));
        % THEN make selections for 2 Relative post-MVC contractions 
            postind.rel(1,1) = round(trig(1,9+num));
            postind.rel(1,2) = round(trig(1,10+num));
            postind.rel(2,1) = round(trig(1,11+num));
            postind.rel(2,2) = round(trig(1,12+num));
elseif order == 2
    %disp('rel first')
        % Make selections for 2 Relative post-MVC contractions
            postind.rel(1,1) = round(trig(1,5+num));
            postind.rel(1,2) = round(trig(1,6+num));
            postind.rel(2,1) = round(trig(1,7+num));
            postind.rel(2,2) = round(trig(1,8+num));
        % THEN make selections for 2 Absolute post-MVC contractions   
            postind.abs(1,1) = round(trig(1,9+num));
            postind.abs(1,2) = round(trig(1,10+num));
            postind.abs(2,1) = round(trig(1,11+num));
            postind.abs(2,2) = round(trig(1,12+num));
else
    disp('error')
end   

%% Cut force signal into sections

% MVCs
for i = 1:num
    MVCs.filt{1,i} = force(MVCind(i,1):MVCind(i,2),1);
    MVCs.unfilt{1,i} = force_unfilt(MVCind(i,1):MVCind(i,2),1);
end

% pre-MVC submax
for i = 1:2
    submax_pre.filt{1,i} = force(preind(i,1):preind(i,2),1);
    submax_pre.unfilt{1,i} = force_unfilt(preind(i,1):preind(i,2),1);
end

% post-MVC submax
for i = 1:2
    submax_post.rel.filt{1,i} = force(postind.rel(i,1):postind.rel(i,2),1);
    submax_post.abs.filt{1,i} = force(postind.abs(i,1):postind.abs(i,2),1);
    submax_post.rel.unfilt{1,i} = force_unfilt(postind.rel(i,1):postind.rel(i,2),1);
    submax_post.abs.unfilt{1,i} = force_unfilt(postind.abs(i,1):postind.abs(i,2),1);
end
%%
close(fig);

% Save
% Save to correct folder as new file or append to existing with other muscles:
%  if contains(filepath,'Stretch') == 1
%      savepath = '/Users/melissamazzo/Desktop/SFU Study Data Processing/Force Output - Stretch';
%  else
%      savepath = '/Users/melissamazzo/Desktop/SFU Study Data Processing/Force Output - Balance';
%  end
% 
% % Path to folder
% cd(savepath);

after.indMVC = MVCind; after.indpost = postind; 
after.indpre = preind; after.MVCs = MVCs;
after.submax_pre = submax_pre; after.submax_ind_pre = preind;
after.submax_post = submax_post; after.submax_ind_post = postind;
after.force = force; after.force_unfilt = force_unfilt;
after.trig = trig; after.order = order;

newfile = strcat('Force_',file,'_split.mat');
save(newfile,'after')
%
cd(filepath);
clear all