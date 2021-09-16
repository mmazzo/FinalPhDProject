% dname = uigetdir();
% cd(dname)
% % Get files
% files = dir('*.mat');
% files = {files.name};
% filepath = strcat(dname,'/');
times = {'before','pre','post'};

%%
count = 1;
%for i = 1
    %filename = files{i};
    %load(filename)
    days = fields(PFdata);
    for d = 1:length(days)
        day = days{d};
        levels = fields(PFdata.(day));
        for l = 1:length(levels)
        level = levels{l};
            for t = 1:3
                time = times{t};
                MUdata = PFdata.(day).(level).MUdata.(time);
                fdat = PFdata.(day).(level).force.(time);
                % check starts
                if MUdata.start == fdat.steady30.start
                   startcheck.day{count,1} = day;
                   startcheck.level{count,1} = level;
                   startcheck.time{count,1} = time;
                   startcheck.mismatch{count,1} = 0;
                   startcheck.diff{count,1} = NaN;
                else
                   startcheck.day{count,1} = day;
                   startcheck.level{count,1} = level;
                   startcheck.time{count,1} = time;
                   startcheck.mismatch{count,1} = 1;
                   startcheck.diff{count,1} = MUdata.start - fdat.steady30.start;
                end
                count = count+1;
            end
        end
    end
%end

%%
clearvars -except times
