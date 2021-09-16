% Scrape data for whole contraction
days = {'stretch','control'};
levels = {'submax10','submax35'};
times = {'before','pre','post'};

% Preallocate before subject 1
data.subs = [];
data.days = [];
data.levels = [];
data.times = [];
data.w1_expl = [];
data.w5_expl = [];

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
            
            % --------- Find length / MU number --------------------
            % Explained by FPC
            if isfield(MUdata.w1,'expl_perm')
                for w = 1:size(MUdata.w1.expl_perm,1)
                    temp = MUdata.w1.expl_perm(w,:);
                    lens1(w) = length(temp(~isnan(temp))) + 1;
                end
                mu1 = min(lens1);
                data.w1_MUnum(count,1) = mu1;
            end
            if isfield(MUdata.w5,'expl_perm')
               for w = 1:size(MUdata.w5.expl_perm,1)
                    temp = MUdata.w5.expl_perm(w,:);
                    lens5(w) = length(temp(~isnan(temp))) + 1;
                end
                mu5 = min(lens5);
                data.w5_MUnum(count,1) = mu5;
            end
            
            % --------- % Explained at each window based on minimum total MU number ------------
            % Mean % Expl. derived from maximum # of MUs
            % 1-s windows
            if isfield(MUdata.w1,'expl_perm')
                wins = length(MUdata.w1.expl_perm(:,mu1)');
                data.w1_expl(count,1:wins) = MUdata.w1.expl_perm(:,mu1)';
            else
            end
            % 5-s windows
            % 1-s windows
            if isfield(MUdata.w5,'expl_perm')
                wins = length(MUdata.w5.expl_perm(:,mu5)');
                data.w5_expl(count,1:wins) = MUdata.w5.expl_perm(:,mu5)';
            else
            end
            % ------ Count -------
            count = count+1;
            end
        end
    end
end
end
%%
datatable = table(data.subs,data.days,data.levels,data.times,data.w1_expl,data.w5_expl,data.w1_MUnum,data.w5_MUnum);
%%

writetable(datatable,'Explained_MUnum.csv');
