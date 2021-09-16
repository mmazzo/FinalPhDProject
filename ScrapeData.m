% Scrape data for whole contraction
days = {'stretch','control'};
levels = {'submax10','submax35'};
times = {'before','pre','post'};

% Preallocate before subject 1
data.subs = [];
data.days = [];
data.levels = [];
data.times = [];
% vectors depending on # of mus
PFvecs.w1.expl_perm_mean = zeros(114,100);
PFvecs.w5.expl_perm_mean = zeros(114,100);
% 1s windows vectors
 PFvecs.w1.f_sd = zeros(114,30);
 PFvecs.w1.cst_sd = zeros(114,30);
 PFvecs.w1.fpc_sd = zeros(114,30);
 PFvecs.w1.f_fpc_r = zeros(114,30);
 PFvecs.w1.f_fpc_lag = zeros(114,30);
 PFvecs.w1.fpc_cst_r = zeros(114,30);
 PFvecs.w1.fpc_cst_lag = zeros(114,30);
 PFvecs.w1.fpc_sumfpc_r = zeros(114,30);
 PFvecs.w1.fpc_sumfpc_lag = zeros(114,30);
 PFvecs.w1.sumfpc_cst_r = zeros(114,30);
 PFvecs.w1.sumfpc_cst_lag = zeros(114,30);
 PFvecs.w1.f_sumfpc_r = zeros(114,30);
 PFvecs.w1.f_sumfpc_lag = zeros(114,30);
% 5s windows vectors
 PFvecs.w5.f_sd = zeros(114,6);
 PFvecs.w5.cst_sd = zeros(114,6);
 PFvecs.w5.fpc_sd = zeros(114,6);
 PFvecs.w5.f_fpc_r = zeros(114,6);
 PFvecs.w5.f_fpc_lag = zeros(114,6);
 PFvecs.w5.fpc_cst_r = zeros(114,6);
 PFvecs.w5.fpc_cst_lag = zeros(114,6);
 PFvecs.w5.fpc_sumfpc_r = zeros(114,6);
 PFvecs.w5.fpc_sumfpc_lag = zeros(114,6);
 PFvecs.w5.sumfpc_cst_r = zeros(114,6);
 PFvecs.w5.sumfpc_cst_lag = zeros(114,6);
 PFvecs.w5.f_sumfpc_r = zeros(114,6);
 PFvecs.w5.f_sumfpc_lag = zeros(114,6);
 
count = 1;

%%
sublist = fields(XCdat);
for s = 1:length(sublist)
subject = sublist{s};
disp(subject)
subdat = XCdat.(subject);

% Run loops
for d = 1:2
    day = days{d};
    for l = 1:2
        level = levels{l};
        for t = 1:length(times)
            time = times{t};
            % --------- For each time / level / day -----------
            MUdata = subdat.(day).(level).(time);
            if isempty(MUdata)
                data.subs{count,1} = subject;
                data.days{count,1} = day;
                data.levels{count,1} = level;
                data.times{count,1} = time;

                PFvecs.subs{count,1} = subject;
                PFvecs.days{count,1} = day;
                PFvecs.levels{count,1} = level;
                PFvecs.times{count,1} = time;
                count = count+1;
            else
            % --------- Include info --------------------------
            data.subs{count,1} = subject;
            data.days{count,1} = day;
            data.levels{count,1} = level;
            data.times{count,1} = time;
            
            PFvecs.subs{count,1} = subject;
            PFvecs.days{count,1} = day;
            PFvecs.levels{count,1} = level;
            PFvecs.times{count,1} = time;
            
            % --------- Windowed / Vectors --------------------
            % Explained by FPC
            if isfield(MUdata.w1,'expl_perm_mean')
            PFvecs.w1.expl_perm_mean(count,1:length(MUdata.w1.expl_perm_mean)) = MUdata.w1.expl_perm_mean;
            end
            if isfield(MUdata.w5,'expl_perm_mean')
            PFvecs.w5.expl_perm_mean(count,1:length(MUdata.w5.expl_perm_mean)) = MUdata.w5.expl_perm_mean;
            end
            % SD in CST
            PFvecs.w1.cst_sd(count,:) = MUdata.w1.cst_sd;
                PFvecs.w5.cst_sd(count,:) = MUdata.w5.cst_sd;
            % SD for force
            PFvecs.w1.f_sd(count,:) = MUdata.w1.f_sd;
                PFvecs.w5.f_sd(count,:) = MUdata.w5.f_sd;
            % Cross-correlations
            if isfield(MUdata,'w30')
            % Xcorrs - 1-s windows
            if isfield(MUdata.w1,'f_fpc_r')
                PFvecs.w1.f_fpc_r(count,1:length(MUdata.w1.f_fpc_r)) = MUdata.w1.f_fpc_r;
                PFvecs.w1.f_fpc_lag(count,1:length(MUdata.w1.f_fpc_lag)) = MUdata.w1.f_fpc_lag;
                PFvecs.w1.fpc_cst_r(count,1:length(MUdata.w1.fpc_cst_r)) = MUdata.w1.fpc_cst_r;
                PFvecs.w1.fpc_cst_lag(count,1:length(MUdata.w1.fpc_cst_lag)) = MUdata.w1.fpc_cst_lag;
            end
            if isfield(MUdata.w1,'sumfpc_cst_r')
                PFvecs.w1.sumfpc_cst_r(count,1:length(MUdata.w1.sumfpc_cst_r)) = MUdata.w1.sumfpc_cst_r;
                PFvecs.w1.sumfpc_cst_lag(count,1:length(MUdata.w1.sumfpc_cst_lag)) = MUdata.w1.sumfpc_cst_lag;
                PFvecs.w1.f_sumfpc_r(count,1:length(MUdata.w1.f_sumfpc_r)) = MUdata.w1.f_sumfpc_r;
                PFvecs.w1.f_sumfpc_lag(count,1:length(MUdata.w1.f_sumfpc_lag)) = MUdata.w1.f_sumfpc_lag;
            end
            if isfield(MUdata.w1,'f_cst_r')
            PFvecs.w1.f_cst_r(count,1:length(MUdata.w1.f_cst_r)) = MUdata.w1.f_cst_r;
            PFvecs.w1.f_cst_lag(count,1:length(MUdata.w1.f_cst_lag)) = MUdata.w1.f_cst_lag;
            end
            % Xcorrs - 5-s windows
            if isfield(MUdata.w5,'f_fpc_r')
                PFvecs.w5.f_fpc_r(count,1:length(MUdata.w5.f_fpc_r)) = MUdata.w5.f_fpc_r;
                PFvecs.w5.f_fpc_lag(count,1:length(MUdata.w5.f_fpc_lag)) = MUdata.w5.f_fpc_lag;
                PFvecs.w5.fpc_cst_r(count,1:length(MUdata.w5.fpc_cst_r)) = MUdata.w5.fpc_cst_r;
                PFvecs.w5.fpc_cst_lag(count,1:length(MUdata.w5.fpc_cst_lag)) = MUdata.w5.fpc_cst_lag;
            end
            if isfield(MUdata.w5,'sumfpc_cst_r')
                PFvecs.w5.sumfpc_cst_r(count,1:length(MUdata.w5.sumfpc_cst_r)) = MUdata.w5.sumfpc_cst_r;
                PFvecs.w5.sumfpc_cst_lag(count,1:length(MUdata.w5.sumfpc_cst_lag)) = MUdata.w5.sumfpc_cst_lag;
                PFvecs.w5.f_sumfpc_r(count,1:length(MUdata.w5.f_sumfpc_r)) = MUdata.w5.f_sumfpc_r;
                PFvecs.w5.f_sumfpc_lag(count,1:length(MUdata.w5.f_sumfpc_lag)) = MUdata.w5.f_sumfpc_lag;
            end
            if isfield(MUdata.w5,'f_cst_r')
            PFvecs.w5.f_cst_r(count,1:length(MUdata.w5.f_cst_r)) = MUdata.w5.f_cst_r;
            PFvecs.w5.f_cst_lag(count,1:length(MUdata.w5.f_cst_lag)) = MUdata.w5.f_cst_lag;
            end
            % SDs - Both windows
            if isfield(MUdata.w1,'fpc_sd')
                PFvecs.w1.fpc_sd(count,1:length(MUdata.w1.fpc_sd)) = MUdata.w1.fpc_sd;
            end
            if isfield(MUdata.w5,'fpc_sd')
                    PFvecs.w5.fpc_sd(count,1:length(MUdata.w5.fpc_sd)) = MUdata.w5.fpc_sd;
            end
                PFvecs.w1.f_sd(count,1:length(MUdata.w1.f_sd)) = MUdata.w1.f_sd;
                    PFvecs.w5.f_sd(count,1:length(MUdata.w5.f_sd)) = MUdata.w5.f_sd;
                PFvecs.w1.cst_sd(count,1:length(MUdata.w1.cst_sd)) = MUdata.w1.cst_sd;
                    PFvecs.w5.cst_sd(count,1:length(MUdata.w5.cst_sd)) = MUdata.w5.cst_sd;
            
            % --------- Single data points --------------------
            % w30
            if isfield(MUdata.w30,'f_cst_r')
                data.w30.f_cst_r{count,1} = MUdata.w30.f_cst_r;
            else
                data.w30.f_cst_r{count,1} = [];
            end
            if isfield(MUdata.w30,'f_cst_lag')
                data.w30.f_cst_lag{count,1} = MUdata.w30.f_cst_lag;
            else
                data.w30.f_cst_lag{count,1} = [];
            end
            if isfield(MUdata.w30,'f_sd')
               data.w30.f_sd{count,1} = MUdata.w30.f_sd;
            else
               data.w30.f_sd{count,1} = [];
            end
            if isfield(MUdata.w30, 'cst_sd')
                data.w30.cst_sd{count,1} = MUdata.w30.cst_sd;
            else
                data.w30.cst_sd{count,1} = [];
            end
            if isfield(MUdata.w30,'w1')
                if isfield(MUdata.w30.w1,'fpc_sd')
                    data.w30.w1.fpc_sd{count,1} = MUdata.w30.w1.fpc_sd;
                else
                    data.w30.w1.fpc_sd{count,1} = [];
                end
            else
               data.w30.w1.fpc_sd{count,1} = [];
            end
            if isfield(MUdata.w30,'w5')
                if isfield(MUdata.w30.w5,'fpc_sd')
                    data.w30.w5.fpc_sd{count,1} = MUdata.w30.w5.fpc_sd;
                else
                    data.w30.w5.fpc_sd{count,1} = [];
                end
            else
               data.w30.w5.fpc_sd{count,1} = [];
            end
                % reconstructed from 1-s windows
                if isfield(MUdata.w30,'w1')
                    if isfield(MUdata.w30.w1,'f_fpc_r')
                    data.w30.w1.f_fpc_r{count,1} = MUdata.w30.w1.f_fpc_r;
                    data.w30.w1.f_fpc_lag{count,1} = MUdata.w30.w1.f_fpc_lag;
                    data.w30.w1.fpc_cst_r{count,1} = MUdata.w30.w1.fpc_cst_r;
                    data.w30.w1.fpc_cst_lag{count,1} = MUdata.w30.w1.fpc_cst_lag;
                    else
                    data.w30.w1.f_fpc_r{count,1} = [];
                    data.w30.w1.f_fpc_lag{count,1} = [];
                    data.w30.w1.fpc_cst_r{count,1} = [];
                    data.w30.w1.fpc_cst_lag{count,1} = [];
                    
                    end
                    if isfield(MUdata.w30.w1,'fpc_sumfpc_r')
                    data.w30.w1.fpc_sumfpc_r{count,1} = MUdata.w30.w1.fpc_sumfpc_r;
                    data.w30.w1.fpc_sumfpc_lag{count,1} = MUdata.w30.w1.fpc_sumfpc_lag;
                    else
                    data.w30.w1.fpc_sumfpc_r{count,1} = [];
                    data.w30.w1.fpc_sumfpc_lag{count,1} = [];
                    end
                    if isfield(MUdata.w30.w1,'sumfpc_cst_r')
                    data.w30.w1.sumfpc_cst_r{count,1} = MUdata.w30.w1.sumfpc_cst_r;
                    data.w30.w1.sumfpc_cst_lag{count,1} = MUdata.w30.w1.sumfpc_cst_lag;
                    else
                    data.w30.w1.sumfpc_cst_r{count,1} = [];
                    data.w30.w1.sumfpc_cst_lag{count,1} = [];
                    end
                    if isfield(MUdata.w30.w1,'f_sumfpc_r')
                    data.w30.w1.f_sumfpc_r{count,1} = MUdata.w30.w1.f_sumfpc_r;
                    data.w30.w1.f_sumfpc_lag{count,1} = MUdata.w30.w1.f_sumfpc_lag;
                    else
                    data.w30.w1.f_sumfpc_r{count,1} = [];
                    data.w30.w1.f_sumfpc_lag{count,1} = [];
                    end
                end
                
                % 5-s windows
                if isfield(MUdata.w30,'w5')
                    if isfield(MUdata.w30.w5,'f_fpc_r')
                    data.w30.w5.f_fpc_r{count,1} = MUdata.w30.w5.f_fpc_r;
                    data.w30.w5.f_fpc_lag{count,1} = MUdata.w30.w5.f_fpc_lag;
                    data.w30.w5.fpc_cst_r{count,1} = MUdata.w30.w5.fpc_cst_r;
                    data.w30.w5.fpc_cst_lag{count,1} = MUdata.w30.w5.fpc_cst_lag;
                    else
                    data.w30.w5.f_fpc_r{count,1} = [];
                    data.w30.w5.f_fpc_lag{count,1} = [];
                    data.w30.w5.fpc_cst_r{count,1} = [];
                    data.w30.w5.fpc_cst_lag{count,1} = [];
                    end
                    if isfield(MUdata.w30.w5,'fpc_sumfpc_r')
                    data.w30.w5.fpc_sumfpc_r{count,1} = MUdata.w30.w5.fpc_sumfpc_r;
                    data.w30.w5.fpc_sumfpc_lag{count,1} = MUdata.w30.w5.fpc_sumfpc_lag;
                    else
                    data.w30.w5.fpc_sumfpc_r{count,1} = [];
                    data.w30.w5.fpc_sumfpc_lag{count,1} = [];
                    end
                    if isfield(MUdata.w30.w5,'sumfpc_cst_r')
                    data.w30.w5.sumfpc_cst_r{count,1} = MUdata.w30.w5.sumfpc_cst_r;
                    data.w30.w5.sumfpc_cst_lag{count,1} = MUdata.w30.w5.sumfpc_cst_lag;
                    else
                    data.w30.w5.sumfpc_cst_r{count,1} = [];
                    data.w30.w5.sumfpc_cst_lag{count,1} = [];
                    end
                    if isfield(MUdata.w30.w5,'f_sumfpc_r')
                    data.w30.w5.f_sumfpc_r{count,1} = MUdata.w30.w5.f_sumfpc_r;
                    data.w30.w5.f_sumfpc_lag{count,1} = MUdata.w30.w5.f_sumfpc_lag;
                    else
                    data.w30.w5.f_sumfpc_r{count,1} = [];
                    data.w30.w5.f_sumfpc_lag{count,1} = [];
                    end
                end
            else
                
            % No section of contraction manually selected
                % SDs - Both windows
                PFvecs.w1.fpc_sd(count,1:length(MUdata.w1.fpc_sd)) = MUdata.w1.fpc_sd;
                    PFvecs.w5.fpc_sd(count,1:length(MUdata.w5.fpc_sd)) = MUdata.w5.fpc_sd;
                PFvecs.w1.f_sd(count,1:length(MUdata.w1.f_sd)) = MUdata.w1.f_sd;
                    PFvecs.w5.f_sd(count,1:length(MUdata.w5.f_sd)) = MUdata.w5.f_sd;
                PFvecs.w1.cst_sd(count,1:length(MUdata.w1.cst_sd)) = MUdata.w1.cst_sd;
                    PFvecs.w5.cst_sd(count,1:length(MUdata.w5.cst_sd)) = MUdata.w5.cst_sd;
            end
            
            % ------ SD across individual contractions ------------------
             % Deviation across single contractions - 5-s windows
                if isfield(MUdata,'w1')
                    if isfield(MUdata.w1,'f_fpc_r')
                    temp = MUdata.w1.f_fpc_r; temp(temp ==0) = NaN;
                    data.w1.f_fpc_r_sd{count,1} = nanstd(temp); %
                    data.w1.f_fpc_r_min{count,1} = nanmin(temp); %
                    data.w1.f_fpc_r_max{count,1} = nanmax(temp); %
                    else
                    data.w1.f_fpc_r_sd{count,1} = [];
                    data.w1.f_fpc_r_min{count,1} = [];
                    data.w1.f_fpc_r_max{count,1} = [];
                    end
                    if isfield(MUdata.w1,'f_cst_r')
                    temp = MUdata.w1.f_cst_r; temp(temp ==0) = NaN;
                    data.w1.f_cst_r_sd{count,1} = nanstd(temp); %
                    data.w1.f_cst_r_min{count,1} = nanmin(temp); %
                    data.w1.f_cst_r_max{count,1} = nanmax(temp); %
                    else
                    data.w1.f_cst_r_sd{count,1} = [];
                    data.w1.f_cst_r_min{count,1} = [];
                    data.w1.f_cst_r_max{count,1} = [];
                    end
                end
            
            % Deviation across single contractions - 5-s windows
            if isfield(MUdata,'w5')
                if isfield(MUdata.w5,'f_fpc_r')
                temp = MUdata.w5.f_fpc_r; temp(temp ==0) = NaN;
                data.w5.f_fpc_r_sd{count,1} = nanstd(temp); %
                data.w5.f_fpc_r_min{count,1} = nanmin(temp); %
                data.w5.f_fpc_r_max{count,1} = nanmax(temp); %
                else
                data.w5.f_fpc_r_sd{count,1} = [];
                data.w5.f_fpc_r_min{count,1} = [];
                data.w5.f_fpc_r_max{count,1} = [];
                end
                if isfield(MUdata.w5,'f_cst_r')
                temp = MUdata.w5.f_cst_r; temp(temp ==0) = NaN;
                data.w5.f_cst_r_sd{count,1} = nanstd(temp); %
                data.w5.f_cst_r_min{count,1} = nanmin(temp); %
                data.w5.f_cst_r_max{count,1} = nanmax(temp); %
                else
                data.w5.f_cst_r_sd{count,1} = [];
                data.w5.f_cst_r_min{count,1} = [];
                data.w5.f_cst_r_max{count,1} = [];
                end
            end
            
            % Mean % Expl. derived from maximum # of MUs
            % 1-s windows
            if isfield(MUdata.w1,'expl_perm')
                temp = []; vals = [];
                for r = 1:size(MUdata.w1.expl_perm,1)
                    temp = MUdata.w1.expl_perm(r,:);
                    temp = temp(~isnan(temp));
                    if isempty(temp)
                    else
                    vals(r) = temp(end);
                    end
                end
                vals(vals==0) = NaN;
                data.w1.expl_max_mean{count,1} = nanmean(vals);
                data.w1.expl_max_sd{count,1} = nanstd(vals);
                data.w1.expl_max_min{count,1} = nanmin(vals);
                data.w1.expl_max_max{count,1} = nanmax(vals);
            else
            end
            % 5-s windows
            if isfield(MUdata.w5,'expl_perm')
                temp = []; vals = [];
                for r = 1:size(MUdata.w5.expl_perm,1)
                    temp = MUdata.w5.expl_perm(r,:);
                    temp = temp(~isnan(temp));
                    if isempty(temp)
                    else
                    vals(r) = temp(end);
                    end
                end
                vals(vals==0) = NaN;
                data.w5.expl_max_mean{count,1} = nanmean(vals);
                data.w5.expl_max_sd{count,1} = nanstd(vals);
                data.w5.expl_max_min{count,1} = nanmin(vals);
                data.w5.expl_max_max{count,1} = nanmax(vals);
                
            else
            end
            
            % Discharge Char. Calculations
            data.meanDR{count,1} = MUdata.MeanDR;
            data.meanCVISI{count,1} = MUdata.MeanCVISI;
            data.meanSDISI{count,1} = MUdata.MeanSDISI;
            % ------ Count -------
            count = count+1;
            end
        end
    end
end
end
%%
datatable = table(data.subs,data.days,data.levels,data.times,data.meanDR,...
    data.meanCVISI,data.meanSDISI,...
    data.w30.f_sd,data.w30.w1.fpc_sd,...
    data.w30.w5.fpc_sd,data.w30.cst_sd,...
    data.w1.expl_max_mean,data.w5.expl_max_mean,...
    data.w30.f_cst_r,data.w30.f_cst_lag,...
    data.w30.w1.f_fpc_r,data.w30.w1.f_fpc_lag,...
    data.w30.w1.fpc_cst_r,data.w30.w1.fpc_cst_lag,...
    data.w30.w1.fpc_sumfpc_r,data.w30.w1.fpc_sumfpc_lag,...
    data.w30.w1.sumfpc_cst_r,data.w30.w1.sumfpc_cst_lag,...
    data.w30.w1.f_sumfpc_r,data.w30.w1.f_sumfpc_lag,...
    data.w30.w5.f_fpc_r,data.w30.w5.f_fpc_lag,...
    data.w30.w5.fpc_cst_r,data.w30.w5.fpc_cst_lag,...
    data.w30.w5.sumfpc_cst_r,data.w30.w5.sumfpc_cst_lag,...
    data.w30.w5.f_sumfpc_r,data.w30.w5.f_sumfpc_lag,...
    data.w1.f_fpc_r_sd, data.w1.f_fpc_r_min, data.w1.f_fpc_r_max,...
    data.w1.f_cst_r_sd, data.w1.f_cst_r_min, data.w1.f_cst_r_max,...
    data.w5.f_fpc_r_sd, data.w5.f_fpc_r_min, data.w5.f_fpc_r_max,...
    data.w5.f_cst_r_sd, data.w5.f_cst_r_min, data.w5.f_cst_r_max,...
    data.w1.expl_max_sd, data.w1.expl_max_min,data.w1.expl_max_max,...
    data.w5.expl_max_sd, data.w5.expl_max_min,data.w5.expl_max_max);
%%
header = {'subject','day','level','time','meanDR',...
    'meanCVISI','meanSDISI',...
    'f_sd','w1_fpc_sd',...
    'w5_fpc_sd','cst_sd',...
    'w1_expl_max_mean','w5_expl_max_mean',...
    'w30_f_cst_r','w30_f_cst_lag',...
    'w30_w1_f_fpc_r','w30_w1_f_fpc_lag',...
    'w30_w1_fpc_cst_r','w30_w1_fpc_cst_lag',...
    'w30_w1_fpc_sumfpc_r','w30_w1_fpc_sumfpc_lag',...
    'w30_w1_sumfpc_cst_r','w30_w1_sumfpc_cst_lag',...
    'w30_w1_f_sumfpc_r','w30_w1_f_sumfpc_lag',...
    'w30_w5_f_fpc_r','w30_w5_f_fpc_lag',...
    'w30_w5_fpc_cst_r','w30_w5_fpc_cst_lag',...
    'w30_w5_sumfpc_cst_r','w30_w5_sumfpc_cst_lag',...
    'w30_w5_f_sumfpc_r','w30_w5_f_sumfpc_lag',...
    'w1_f_fpc_r_sd','w1_f_fpc_r_min','w1_f_fpc_r_max',...
    'w1_f_cst_r_sd','w1_f_cst_r_min','w1_f_cst_r_max',...
    'w5_f_fpc_r_sd','w5_f_fpc_r_min','w5_f_fpc_r_max',...
    'w5_f_cst_r_sd','w5_f_cst_r_min','w5_f_cst_r_max',...
    'w1_expl_max_sd','w1_expl_max_min','w1_expl_max_max',...
    'w5_expl_max_sd','w5_expl_max_min','w5_expl_max_max'};
datatable.Properties.VariableNames = header;

%%
writetable(datatable,'SingleValsData.csv');


%% Merge & Export PFvecs data

% W1 - Create PFVecs table in long format
count = 1;
for i = 1:(114*2)
    for w = 1:30
        data{count,1} = PFvecs.subs{i};
        data{count,2} = PFvecs.days{i};
        data{count,3} = PFvecs.levels{i};
        data{count,4} = PFvecs.times{i};
        data{count,5} = PFvecs.w1.f_sd(i,w);
        data{count,6} = PFvecs.w1.cst_sd(i,w);
        data{count,7} = PFvecs.w1.fpc_sd(i,w);
        data{count,8} = PFvecs.w1.f_cst_r(i,w);
        data{count,9} = PFvecs.w1.fpc_cst_r(i,w);
        data{count,10} = PFvecs.w1.f_fpc_r(i,w);
        data{count,11} = w;
        count = count+1;
    end
end

%%
t = table(data);
writetable(t,'PFvecsLong_W1.csv');

%% W5 - Create PFVecs table in long format
count = 1;
for i = 1:(114*2)
    for w = 1:6
        data{count,1} = PFvecs.subs{i};
        data{count,2} = PFvecs.days{i};
        data{count,3} = PFvecs.levels{i};
        data{count,4} = PFvecs.times{i};
        data{count,5} = PFvecs.w5.f_sd(i,w);
        data{count,6} = PFvecs.w5.cst_sd(i,w);
        data{count,7} = PFvecs.w5.fpc_sd(i,w);
        data{count,8} = PFvecs.w5.f_cst_r(i,w);
        data{count,9} = PFvecs.w5.fpc_cst_r(i,w);
        data{count,10} = PFvecs.w5.f_fpc_r(i,w);
        data{count,11} = w;
        count = count+1;
    end
end

%%
t = table(data);
writetable(t,'PFvecsLong_W5.csv');