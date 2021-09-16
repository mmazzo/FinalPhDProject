% PF calculations within for loops for each subject file
%% Select folder -------------------
% dname = uigetdir();
% cd(dname)
% % Get files
% files = dir('*.mat');
% files = {files.name};
% filepath = strcat(dname,'/');

%subs = {'1','2','3','4','5','7','8','9','10','11','12','15','16','17','19','20','21','22','23'};

            %% Raw lines
%             days = {'stretch','control'};
%             levels = {'submax10','submax35'};
% 
%                 for i = 1:length(files)
% 
%                     filename = files{i};
%                     load(filename);
%                     disp(filename)
%              days = {'stretch','control'};
%              levels = {'submax10','submax35'};
%                     for d = 1:2
%                         day = days{d};
%                         for l = 1:2
%                             level = levels{l};
%                                 % Calculate raw IDR lines
%                                 PFdata.(day).(level).MUdata.before = IDRlinesRaw(PFdata.(day).(level).MUdata.before);
%                                 PFdata.(day).(level).MUdata.pre = IDRlinesRaw(PFdata.(day).(level).MUdata.pre);
%                                 PFdata.(day).(level).MUdata.post = IDRlinesRaw(PFdata.(day).(level).MUdata.post);
% 
%                         end
%                     end   
%     % 
%                 clearvars -except PFdata days levels muscles filename files filepath
%                 save(filename)
%                 end

            %% pCSI
%             muscles = {'MG','LG','SOL'};
%             days = {'stretch','control'};
%             levels = {'submax10','submax35'};
% 
%                 for d = 1:2 % 1:2
%                     day = days{d};
%                     for l = 1:2
%                         level = levels{l};
%                         % Calculate pCSI values
%                         PFdata.(day).(level).MUdata.before = pCSIfunc_old(PFdata.(day).(level).MUdata.before,PFdata.(day).(level).force.before);
%                         disp(horzcat(day,' - ',level,' - Before Complete'))
%                         PFdata.(day).(level).MUdata.pre = pCSIfunc_old(PFdata.(day).(level).MUdata.pre,PFdata.(day).(level).force.pre);
%                         disp(horzcat(day,' - ',level,' - Pre Complete'))
%                         PFdata.(day).(level).MUdata.post = pCSIfunc_old(PFdata.(day).(level).MUdata.post,PFdata.(day).(level).force.post);
%                         disp(horzcat(day,' - ',level,' - Post Complete'))
%                     end
%                 end   


%% PCA and PCAiter
% days = {'stretch','control'};
% levels = {'submax10','submax35'};
% 
% 
% i = 31; %:length(files)
% 
% filename = files{i};


%% Assign day & level
% muscles = {'MG','LG','SOL'};
% days = {'stretch','control'};
% levels = {'submax10','submax35'};
% 
d = 2;
day = days{d};

l = 2;
level = levels{l};
% 
% 
% %      1   ------------ Simple PCA -----------------
            % PCA with MAX MU NUM for each muscle and total PFs
            PFdata.(day).(level).MUdata.before = pcafunc(PFdata.(day).(level).MUdata.before,PFdata.(day).(level).force.before);
            PFdata.(day).(level).MUdata.pre = pcafunc(PFdata.(day).(level).MUdata.pre,PFdata.(day).(level).force.pre);
            PFdata.(day).(level).MUdata.post = pcafunc(PFdata.(day).(level).MUdata.post,PFdata.(day).(level).force.post);
            % PCA with MAX MU NUM for NON-SMOOTHED IDRS for each muscle and total PFs
            PFdata.(day).(level).MUdata.before = pcafuncRaw(PFdata.(day).(level).MUdata.before,PFdata.(day).(level).force.before);
            PFdata.(day).(level).MUdata.pre = pcafuncRaw(PFdata.(day).(level).MUdata.pre,PFdata.(day).(level).force.pre);
            PFdata.(day).(level).MUdata.post = pcafuncRaw(PFdata.(day).(level).MUdata.post,PFdata.(day).(level).force.post);
            disp('All Simple PCAs Complete')
%             
%%           ------------ Iterative PCA -----------------
            % PCAiter for each muscle and total PFs
            PFdata.(day).(level).MUdata.before = PCAiterfunc(PFdata.(day).(level).MUdata.before,PFdata.(day).(level).force.before);
            disp(horzcat('Iterative PCA - ',day,' - ',level,' - Before Complete'))
            PFdata.(day).(level).MUdata.pre = PCAiterfunc(PFdata.(day).(level).MUdata.pre,PFdata.(day).(level).force.pre);
            disp(horzcat('Iterative PCA - ',day,' - ',level,' - Pre Complete'))
            PFdata.(day).(level).MUdata.post = PCAiterfunc(PFdata.(day).(level).MUdata.post,PFdata.(day).(level).force.post);
            disp(horzcat('Iterative PCA - ',day,' - ',level,' - Post Complete'))
%             
% %%      2   ------------ Raw ---------------------------      
%             % PCAiter for NON-SMOOTHED IDRS for each muscle and total PFs
%             PFdata.(day).(level).MUdata.before = PCAiterfuncRaw(PFdata.(day).(level).MUdata.before,PFdata.(day).(level).force.before);
%             disp(horzcat('Raw Iterative PCA - ',day,' - ',level,' - Before Complete'))
%             PFdata.(day).(level).MUdata.pre = PCAiterfuncRaw(PFdata.(day).(level).MUdata.pre,PFdata.(day).(level).force.pre);
%             disp(horzcat('Raw Iterative PCA - ',day,' - ',level,' - Pre Complete'))
%             PFdata.(day).(level).MUdata.post = PCAiterfuncRaw(PFdata.(day).(level).MUdata.post,PFdata.(day).(level).force.post);
%             disp(horzcat('Raw Iterative PCA - ',day,' - ',level,' - Post Complete'))
%             
% %%         ------------ Curve fitting -----------------
%             % PFcurvefits for both metrics
% %             PFdata.(day).(level).MUdata.before = PFcurvefits(PFdata.(day).(level).MUdata.before);
% %             disp(horzcat('Curve Fitting - ',day,' - ',level,' - Before Complete'))
% %             PFdata.(day).(level).MUdata.pre = PFcurvefits(PFdata.(day).(level).MUdata.pre);
% %             disp(horzcat('Curve Fitting - ',day,' - ',level,' - Pre Complete'))
% %             PFdata.(day).(level).MUdata.post = PFcurvefits(PFdata.(day).(level).MUdata.post);
% %             disp(horzcat('Curve Fitting - ',day,' - ',level,' - Post Complete'))
%         % end
%    % end   

 
% %
% filename = uigetfile();
% load(filename);
% disp(filename)

%% Next
days = {'stretch','control'};
levels = {'submax10','submax35'};
times = {'before','pre','post'};

% --- CHANGE THESE ---
subject = 'SFU11';
day = 'stretch';
l = 1;

% --- --- --- --- ----
for t = 3
    level = levels{l};
    time = times{t};
    disp(strcat({' --- '},time,{' --- '}))
    % NEXTCALCS
    [PFdata.(day).(level).MUdata.(time),PFdata.(day).(level).force.(time)] = nextcalcs(PFdata.(day).(level).MUdata.(time),PFdata.(day).(level).force.(time),level);

    muscles = {};
        if isempty(PFdata.(day).(level).MUdata.(time).MG)
        else
            muscles = [muscles,{'MG'}];
        end
        if isempty(PFdata.(day).(level).MUdata.(time).LG)
        else
            muscles = [muscles,{'LG'}];
        end
        if isempty(PFdata.(day).(level).MUdata.(time).SOL)
        else
            muscles = [muscles,{'SOL'}];
        end

    % Pull xcorrs data & SD data
        XCdat.(subject).(day).(level).(time) = PFdata.(day).(level).MUdata.(time).xcorrs;
        % CST and Force
        XCdat.(subject).(day).(level).(time).w30.cst_sd = PFdata.(day).(level).MUdata.(time).w30.cst_sd;
        XCdat.(subject).(day).(level).(time).w30.f_sd = PFdata.(day).(level).MUdata.(time).w30.f_sd;
        XCdat.(subject).(day).(level).(time).w1.cst_sd = PFdata.(day).(level).MUdata.(time).w1.cst_sd;
        XCdat.(subject).(day).(level).(time).w1.f_sd = PFdata.(day).(level).MUdata.(time).w1.f_sd;
        XCdat.(subject).(day).(level).(time).w5.cst_sd = PFdata.(day).(level).MUdata.(time).w5.cst_sd;
        XCdat.(subject).(day).(level).(time).w5.f_sd = PFdata.(day).(level).MUdata.(time).w5.f_sd;
        % FPC
        if isfield(PFdata.(day).(level).MUdata.(time).PCA.iter.w1,'fpc_sd')
        XCdat.(subject).(day).(level).(time).w1.fpc_sd = PFdata.(day).(level).MUdata.(time).PCA.iter.w1.fpc_sd;
        end
        if isfield(PFdata.(day).(level).MUdata.(time).PCA.iter.w5,'fpc_sd')
        XCdat.(subject).(day).(level).(time).w5.fpc_sd = PFdata.(day).(level).MUdata.(time).PCA.iter.w5.fpc_sd;
        end
        XCdat.(subject).(day).(level).(time).w30.w1.fpc_sd = PFdata.(day).(level).MUdata.(time).PCA.iter.w30.w1.fpc_sd;
        XCdat.(subject).(day).(level).(time).w30.w5.fpc_sd = PFdata.(day).(level).MUdata.(time).PCA.iter.w30.w5.fpc_sd;
    % Pull FPC data
        % w1 - Mean % explained for each # of MUs within each window
        if isfield(PFdata.(day).(level).MUdata.(time).PCA.iter.w1,'explained_means')
            temp30 = zeros(30,100);
            for w = 1:length(PFdata.(day).(level).MUdata.(time).PCA.iter.w1.explained_means)
                if isempty(PFdata.(day).(level).MUdata.(time).PCA.iter.w1.explained_means{w})
                else
                    n = length(PFdata.(day).(level).MUdata.(time).PCA.iter.w1.explained_means{w});
                    temp30(w,1:n) = PFdata.(day).(level).MUdata.(time).PCA.iter.w1.explained_means{w};
                end
            end
            temp30(temp30 == 0) = NaN;
            XCdat.(subject).(day).(level).(time).w1.expl_perm = temp30;
            XCdat.(subject).(day).(level).(time).w1.expl_perm_mean = PFdata.(day).(level).MUdata.(time).PCA.iter.w1.explained_mean;
        else
        end
        % w5 - Mean % explained for each # of MUs within each window
        if isfield(PFdata.(day).(level).MUdata.(time).PCA.iter.w5,'explained_means')
            temp30 = zeros(6,100);
            for w = 1:length(PFdata.(day).(level).MUdata.(time).PCA.iter.w5.explained_means)
                if isempty(PFdata.(day).(level).MUdata.(time).PCA.iter.w5.explained_means{w})
                else
                    n = length(PFdata.(day).(level).MUdata.(time).PCA.iter.w5.explained_means{w});
                    temp30(w,1:n) = PFdata.(day).(level).MUdata.(time).PCA.iter.w5.explained_means{w};
                end
            end
            temp30(temp30 == 0) = NaN;
            XCdat.(subject).(day).(level).(time).w5.expl_perm = temp30;
            XCdat.(subject).(day).(level).(time).w5.expl_perm_mean = PFdata.(day).(level).MUdata.(time).PCA.iter.w1.explained_mean;
        else
        end
    % Pull means across steady section
    % Discharge Char. Calculations
        % Mean DR
            temp = [];
            for m = 1:length(muscles)
                mus = muscles{m};
                temp = horzcat(temp,PFdata.(day).(level).MUdata.(time).(mus).steady30.Mean_DR);
            end
        XCdat.(subject).(day).(level).(time).MeanDR = nanmean(temp);
        % Mean CV for ISI
            temp = [];
            for m = 1:length(muscles)
                mus = muscles{m};
                temp = horzcat(temp,PFdata.(day).(level).MUdata.(time).(mus).steady30.CV_ISI);
            end
        XCdat.(subject).(day).(level).(time).MeanCVISI = nanmean(temp);
        % Mean SD for ISI
            temp = [];
            for m = 1:length(muscles)
                mus = muscles{m};
                temp = horzcat(temp,PFdata.(day).(level).MUdata.(time).(mus).steady30.SD_ISI);
            end
        XCdat.(subject).(day).(level).(time).MeanSDISI = nanmean(temp);

end


%%
clearvars -except XCdat

%%
save('XCdat.mat','XCdat')

%% SD for force & CST data

subject = 'SFU22';

days = {'stretch','control'};
levels = {'submax10','submax35'};
times = {'before','pre','post'};

for d = 2
    day = days{d};
    for l = 2
        level = levels{l};
        for t = 2
            time = times{t};
            % ------ Calculations -------
            if isnan(PFdata.(day).(level).MUdata.(time).sectioned)
            else
                [PFdata.(day).(level).MUdata.(time)] = calcSD_CST(PFdata.(day).(level).MUdata.(time),PFdata.(day).(level).force.(time));
                [PFdata.(day).(level).MUdata.(time)] = calcSD_force(PFdata.(day).(level).MUdata.(time),PFdata.(day).(level).force.(time),level);
                % ------ Save in structure -------
                SDdat.(subject).(day).(level).(time).w30 = PFdata.(day).(level).MUdata.(time).w30;
                SDdat.(subject).(day).(level).(time).w1 = PFdata.(day).(level).MUdata.(time).w1;
                SDdat.(subject).(day).(level).(time).w5 = PFdata.(day).(level).MUdata.(time).w5;
            end
        end
    end
end
disp('Calculations done')
%%
clearvars -except SDdat
    
save('SDdat.mat','SDdat')







%%

plot(PFdata.(day).(level).force.(time).allflags);
hold on;
for p = 1:30
xline(PFdata.(day).(level).MUdata.(time).w1.starts(p),'r');
end
%% 29,28,25
PFdata.(day).(level).MUdata.(time).w5.bad_wins = zeros(1,6);
%%
PFdata.(day).(level).MUdata.(time).w5.bad_wins(2:6) = 1;
