%% Get windowed CV for ISI

% --- CHANGE THIS ---
subject = 'SFU23';
count = length(data.subs)+1;

%% AUTOMATIC
days = fieldnames(PFdata);
for d = 1:length(days)
    day = days{d};
    levels = fieldnames(PFdata.(day));
    for l = 1:length(levels)
        level = levels{l};
        for t = 1:3
            times = fieldnames(PFdata.(day).(level).MUdata);
            time = times{t};
            disp(strcat(day,{' - '},level,{' - '},time,{' - '}))
            % Muscles vector
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

            data.subs{count,1} = subject;
            data.days{count,1} = day;
            data.levels{count,1} = level;
            data.times{count,1} = time;

            % Calculate CV for ISI at each window
            isivec = [];
            meanvec = [];
            sdvec = [];
            for m = 1:length(muscles)
                mus = muscles{m};
                W1isivec = [];
                W1meanvec = [];
                W1sdvec = [];
                W5isivec = [];
                W5meanvec = [];
                W5sdvec = [];
                for mu = 1:length(PFdata.(day).(level).MUdata.(time).(mus).orig_ISI)
                    temp = PFdata.(day).(level).MUdata.(time).(mus).binary_ISI(mu,:);
                    % 1-s windows
                    for w = 1:30
                        if isfield(PFdata.(day).(level).MUdata.(time).w1,'bad_wins')
                            if PFdata.(day).(level).MUdata.(time).w1.bad_wins(w) == 1
                            else
                                temp2 = temp(PFdata.(day).(level).MUdata.(time).w1.starts(w):PFdata.(day).(level).MUdata.(time).w1.endds(w));
                                wtemp = temp2(temp2 ~= 0);
                                W1CVs(mu,w) = (std(wtemp)/mean(wtemp))*100;
                                W1SDs(mu,w) = std(wtemp);
                                W1meanDRs(mu,w) = (1/mean(wtemp))*1000;
                            end
                        else
                            W1CVs = [];
                            W1SDs = [];
                            W1meanDRs = [];
                        end
                    end 
                    % 5-s windows
                    for w = 1:6
                        if isfield(PFdata.(day).(level).MUdata.(time).w5,'bad_wins')
                            if PFdata.(day).(level).MUdata.(time).w5.bad_wins(w) == 1
                            else
                                temp2 = temp(PFdata.(day).(level).MUdata.(time).w5.starts(w):PFdata.(day).(level).MUdata.(time).w5.endds(w));
                                wtemp = temp2(temp2 ~= 0);
                                W5CVs(mu,w) = (std(wtemp)/mean(wtemp))*100;
                                W5SDs(mu,w) = std(wtemp);
                                W5meanDRs(mu,w) = (1/mean(wtemp))*1000;
                            end
                        else
                            W5CVs = [];
                            W5SDs = [];
                            W5meanDRs = [];
                        end
                    end 
                end
                W1isivec = vertcat(W1isivec,W1CVs);
                W1meanvec = vertcat(W1meanvec,W1meanDRs);
                W1sdvec = vertcat(W1sdvec,W1SDs);
                W5isivec = vertcat(W5isivec,W5CVs);
                W5meanvec = vertcat(W5meanvec,W5meanDRs);
                W5sdvec = vertcat(W5sdvec,W5SDs);
            end
            data.w1.CVISI(count,1:size(W1isivec,2)) = nanmean(W1isivec);
            data.w1.meanDR(count,1:size(W1meanvec,2)) = nanmean(W1meanvec);
            data.w1.SDISI(count,1:size(W1sdvec,2)) = nanmean(W1sdvec);
            data.w5.CVISI(count,1:size(W5isivec,2)) = nanmean(W5isivec);
            data.w5.meanDR(count,1:size(W5meanvec,2)) = nanmean(W5meanvec);
            data.w5.SDISI(count,1:size(W5sdvec,2)) = nanmean(W5sdvec);
            count = count+1;
        end
    end
end
%%
save('WindowedDischChars.mat','data');
clearvars -except data

%%
t = table(data.subs,data.days,data.levels,data.times,...
    data.w1.CVISI,data.w1.meanDR,data.w1.SDISI);

writetable(t,'WindowedDischargeChars_w1.csv')

%%
t = table(data.subs,data.days,data.levels,data.times,...
    data.w5.CVISI,data.w5.meanDR,data.w5.SDISI);

writetable(t,'WindowedDischargeChars_w5.csv')