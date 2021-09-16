% Gather MU numbers during steady 30 portion
days = {'stretch','control'};
levels = {'submax10','submax35'};
times = {'before','pre','post'};

for d = 1
    day = days{d};
    for l = 1:2
        level = levels{l};
        for t = 1:length(times)
            time = times{t};
            % --------- For each time / level / day -----------
            MUdata = PFdata.(day).(level).MUdata.(time);
            idx = MUdata.binaryidx;
            % --------- Gather all flags ----------------------
            muscles = {};
            if isempty(MUdata.MG)
            else
                muscles = [muscles,{'MG'}];
            end
            if isempty(MUdata.LG)
            else
                muscles = [muscles,{'LG'}];
            end
            if isempty(MUdata.SOL)
            else
                muscles = [muscles,{'SOL'}];
            end
            
            fl = [];
            for m = 1:length(muscles)
                mus = muscles{m};
                fl = vertcat(fl,MUdata.(mus).flags);
            end
            
            if size(fl,1) == 1
                allflags = fl;
            else
            allflags = sum(fl);
            end
            allflags(allflags>1) = 1;
            
            % --------- Whole 30-s section --------------------
                % Remove empties
                steady30 = MUdata.binary(:,MUdata.start:MUdata.endd);
                rem = [];
                for mu = 1:size(steady30,1)
                    if sum(steady30(mu,:)) == 0
                        rem(mu) = 1;
                    else
                        rem(mu) = 0;
                    end
                end
                idx = idx(rem==0);
                for line = 1:length(idx)
                    idx{line} = upper(idx{line});
                end
                % Count
                counts.(day).(level).w30(t,1) = sum(contains(idx,'MG'));
                counts.(day).(level).w30(t,2) = sum(contains(idx,'LG'));
                counts.(day).(level).w30(t,3) = sum(contains(idx,'SOL'));
                
           % --------- 1-s Windows --------------------
           for w = 1:30
             idx = MUdata.binaryidx;
             s = MUdata.w1.starts(w);
             e = MUdata.w1.endds(w);
             if sum(allflags(s:e)) == 0
                binsec = MUdata.binary(:,s:e);
                % Remove empties
                rem = [];
                for mu = 1:size(MUdata.binary,1)
                    if sum(binsec(mu,:)) == 0
                        rem(mu) = 1;
                    else
                        rem(mu) = 0;
                    end
                end
                idx = idx(rem==0);
                for line = 1:length(idx)
                    idx{line} = upper(idx{line});
                end
                % Count
                counts.(day).(level).w1{t,1}(w,1) = sum(contains(idx,'MG'));
                counts.(day).(level).w1{t,1}(w,2) = sum(contains(idx,'LG'));
                counts.(day).(level).w1{t,1}(w,3) = sum(contains(idx,'SOL'));
             end
           end
           % --------- 5 s windows ---------------
            for w = 1:6
             idx = MUdata.binaryidx;
             s = MUdata.w5.starts(w);
             e = MUdata.w5.endds(w);
             if sum(allflags(s:e)) == 0
                binsec = MUdata.binary(:,s:e);
                % Remove empties
                rem = [];
                for mu = 1:size(MUdata.binary,1)
                    if sum(binsec(mu,:)) == 0
                        rem(mu) = 1;
                    else
                        rem(mu) = 0;
                    end
                end
                idx = idx(rem==0);
                for line = 1:length(idx)
                    idx{line} = upper(idx{line});
                end
                % Count
                counts.(day).(level).w5{t,1}(w,1) = sum(contains(idx,'MG'));
                counts.(day).(level).w5{t,1}(w,2) = sum(contains(idx,'LG'));
                counts.(day).(level).w5{t,1}(w,3) = sum(contains(idx,'SOL'));
             end
           end
        end
    end
end

disp('Done with Counts')

%%
MUcount.SFU22 = counts;

%% 
    MUcount.SFU23.stretch = counts.stretch;
%%
    MUcount.SFU23.control = counts.control;
%%
clearvars -except MUcount

