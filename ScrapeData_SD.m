% ScrapeData SD
days = {'stretch','control'};
levels = {'submax10','submax35'};
times = {'before','pre','post'};

% Preallocate before subject 1
data.subs = [];
data.days = [];
data.levels = [];
data.times = [];

% 30s single values
 data.w30.cst_sd = [];
 data.w30.f_sd = [];
 data.w30.hpf_cst_sd = [];
 data.w30.cst_mean = [];
 data.w30.cst_cv = [];
 data.w30.hpf_f_sd = [];
 data.w30.hpf_f_mean = [];
 data.w30.hpf_f_cv = [];
 data.w30.f_mean = [];
 data.w30.f_cv = [];

% 1s windows vectors
 vecdata.w1.cst_sd = zeros(114,30);
 vecdata.w1.cst_mean = zeros(114,30);
 vecdata.w1.cst_cv = zeros(114,30);
 vecdata.w1.f_sd = zeros(114,30);
 vecdata.w1.f_mean = zeros(114,30);
 vecdata.w1.f_cv = zeros(114,30);
 vecdata.w1.hpf_cst_sd = zeros(114,30);
 vecdata.w1.hpf_f_sd = zeros(114,30);
 vecdata.w1.bad_wins = zeros(114,30);

% 5s windows vectors
 vecdata.w5.cst_sd = zeros(114,6);
 vecdata.w5.cst_mean = zeros(114,6);
 vecdata.w5.cst_cv = zeros(114,6);
 vecdata.w5.f_sd = zeros(114,6);
 vecdata.w5.f_mean = zeros(114,6);
 vecdata.w5.f_cv = zeros(114,6);
 vecdata.w5.hpf_cst_sd = zeros(114,6);
 vecdata.w5.hpf_f_sd = zeros(114,6);
 vecdata.w5.bad_wins = zeros(114,30);
 
count = 1;

%%
sublist = fields(SDdat);
for s = 1:length(sublist)
subject = sublist{s};
disp(subject)
subdat = SDdat.(subject);

% Run loops
for d = 1:2
    day = days{d};
    for l = 1:2
        level = levels{l};
        for t = 1:length(times)
            time = times{t};
            if isfield(subdat.(day).(level),(time))
                % --------- For each time / level / day -----------
                MUdata = subdat.(day).(level).(time);
                if isempty(MUdata)
                    data.subs{count,1} = subject;
                    data.days{count,1} = day;
                    data.levels{count,1} = level;
                    data.times{count,1} = time;

                    vecdata.subs{count,1} = subject;
                    vecdata.days{count,1} = day;
                    vecdata.levels{count,1} = level;
                    vecdata.times{count,1} = time;
                    count = count+1;
                else
                % --------- Include info --------------------------
                data.subs{count,1} = subject;
                data.days{count,1} = day;
                data.levels{count,1} = level;
                data.times{count,1} = time;

                vecdata.subs{count,1} = subject;
                vecdata.days{count,1} = day;
                vecdata.levels{count,1} = level;
                vecdata.times{count,1} = time;

                % --------- Data --------------------
                    % ----- w30 ------
                     data.w30.cst_sd{count,1} = MUdata.w30.cst_sd;
                     data.w30.f_sd{count,1} = MUdata.w30.f_sd;
                     data.w30.hpf_cst_sd{count,1} = MUdata.w30.hpf_cst_sd;
                     data.w30.cst_mean{count,1} = MUdata.w30.cst_mean;
                     data.w30.cst_cv{count,1} = MUdata.w30.cst_cv;
                     data.w30.hpf_f_sd{count,1} = MUdata.w30.hpf_f_sd;
                     data.w30.hpf_f_mean{count,1} = MUdata.w30.hpf_f_mean;
                     data.w30.hpf_f_cv{count,1} = MUdata.w30.hpf_f_cv;
                     data.w30.f_mean{count,1} = MUdata.w30.f_mean;
                     data.w30.f_cv{count,1} = MUdata.w30.f_cv;

                    % ----- w1 -----
                     vecdata.w1.cst_sd(count,1:length(MUdata.w1.cst_sd)) = MUdata.w1.cst_sd;
                     vecdata.w1.cst_mean(count,1:length(MUdata.w1.cst_mean)) = MUdata.w1.cst_mean;
                     vecdata.w1.cst_cv(count,1:length(MUdata.w1.cst_cv)) = MUdata.w1.cst_cv;
                     vecdata.w1.f_sd(count,1:length(MUdata.w1.f_sd)) = MUdata.w1.f_sd;
                     vecdata.w1.f_mean(count,1:length(MUdata.w1.f_mean)) = MUdata.w1.f_mean;
                     vecdata.w1.f_cv(count,1:length(MUdata.w1.f_cv)) = MUdata.w1.f_cv;
                     vecdata.w1.hpf_cst_sd(count,1:length(MUdata.w1.hpf_cst_sd)) = MUdata.w1.hpf_cst_sd;
                     vecdata.w1.hpf_f_sd(count,1:length(MUdata.w1.hpf_f_sd)) = MUdata.w1.hpf_f_sd;
                     vecdata.w1.bad_wins(count,1:length(MUdata.w1.bad_wins)) = MUdata.w1.bad_wins;

                    % ----- w5 -----
                     vecdata.w5.cst_sd(count,1:length(MUdata.w5.cst_sd)) = MUdata.w5.cst_sd;
                     vecdata.w5.cst_mean(count,1:length(MUdata.w5.cst_mean)) = MUdata.w5.cst_mean;
                     vecdata.w5.cst_cv(count,1:length(MUdata.w5.cst_cv)) = MUdata.w5.cst_cv;
                     vecdata.w5.f_sd(count,1:length(MUdata.w5.f_sd)) = MUdata.w5.f_sd;
                     vecdata.w5.f_mean(count,1:length(MUdata.w5.f_mean)) = MUdata.w5.f_mean;
                     vecdata.w5.f_cv(count,1:length(MUdata.w5.f_cv)) = MUdata.w5.f_cv;
                     vecdata.w5.hpf_cst_sd(count,1:length(MUdata.w5.hpf_cst_sd)) = MUdata.w5.hpf_cst_sd;
                     vecdata.w5.hpf_f_sd(count,1:length(MUdata.w5.hpf_f_sd)) = MUdata.w5.hpf_f_sd;
                     vecdata.w5.bad_wins(count,1:length(MUdata.w5.bad_wins)) = MUdata.w5.bad_wins;
                % ------ Count -------
                count = count+1;
                end
            else
            count = count+1;
            end
        end
    end
end
end

%% Table - data
datatable = table(data.subs,data.days,data.levels,data.times,...
    data.w30.cst_sd, data.w30.f_sd,data.w30.hpf_cst_sd,data.w30.cst_mean,data.w30.cst_cv,...
    data.w30.hpf_f_sd,data.w30.hpf_f_mean,data.w30.hpf_f_cv,data.w30.f_mean,data.w30.f_cv);

%% Table - vecdata
% W1 - Create PFVecs table in long format
count = 1;
for i = 1:(114*2)
    for w = 1:30
        data1{count,1} = vecdata.subs{i};
        data1{count,2} = vecdata.days{i};
        data1{count,3} = vecdata.levels{i};
        data1{count,4} = vecdata.times{i};
        data1{count,5} = vecdata.w1.cst_sd(i,w);
        data1{count,6} = vecdata.w1.cst_mean(i,w);
        data1{count,7} = vecdata.w1.cst_cv(i,w);
        data1{count,8} = vecdata.w1.f_sd(i,w);
        data1{count,9} = vecdata.w1.f_mean(i,w);
        data1{count,10} = vecdata.w1.f_cv(i,w);
        data1{count,11} = vecdata.w1.hpf_cst_sd(i,w);
        data1{count,12} = vecdata.w1.hpf_f_sd(i,w);
        data1{count,13} = vecdata.w1.bad_wins(i,w);
        data1{count,14} = w;
        count = count+1;
    end
end

%% W5 - Create PFVecs table in long format
count = 1;
for i = 1:(114*2)
    for w = 1:6
        data5{count,1} = vecdata.subs{i};
        data5{count,2} = vecdata.days{i};
        data5{count,3} = vecdata.levels{i};
        data5{count,4} = vecdata.times{i};
        data5{count,5} = vecdata.w5.cst_sd(i,w);
        data5{count,6} = vecdata.w5.cst_mean(i,w);
        data5{count,7} = vecdata.w5.cst_cv(i,w);
        data5{count,8} = vecdata.w5.f_sd(i,w);
        data5{count,9} = vecdata.w5.f_mean(i,w);
        data5{count,10} = vecdata.w5.f_cv(i,w);
        data5{count,11} = vecdata.w5.hpf_cst_sd(i,w);
        data5{count,12} = vecdata.w5.hpf_f_sd(i,w);
        data5{count,13} = vecdata.w5.bad_wins(i,w);
        data5{count,14} = w;
        count = count+1;
    end
end

%%
writetable(datatable,'SDdata_w30.csv');

d1 = table(data1);
d5 = table(data5);

writetable(d1,'SDdata_w1.csv');
writetable(d5,'SDdata_w5.csv');