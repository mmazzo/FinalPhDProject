% Individual Motor Units - CST vs individual motor units
level = 'submax10';
time = 'before';
mus = 'MG';

%% IDRs
clear('rawidrs','idrfilts')

 % IDRs
    for mu = 1:length(PFdata.(day).(level).MUdata.(time).(mus).rawlines)
        len = length(PFdata.(day).(level).MUdata.(time).(mus).binary);
        isivec = PFdata.(day).(level).MUdata.(time).(mus).binary_ISI;
        isivec(isivec == 0) = NaN;
        if isempty(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
        elseif isnan(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
        else
            temp = PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu};
            start = find(~isnan(temp),1,'first');
            endd = find(~isnan(temp),1,'last');
            temp = temp(start:endd);
            temp = conv(temp,hann(800),'same');
            temp = highpass(temp,0.75,2000);
            nans1 = repelem(NaN,start-1);
            nans2 = repelem(NaN,(len-endd));
            idrfilts(mu,:) = horzcat(nans1,temp,nans2);
        end
    end

%% Correlation with smoothed idrs
s30 = PFdata.(day).(level).MUdata.(time).(mus).steady30.start;
e30 = PFdata.(day).(level).MUdata.(time).(mus).steady30.endd;
cst = PFdata.(day).(level).MUdata.(time).(mus).cst(s30:e30);
idrs = idrfilts(:,s30:e30);
for mu = 1:size(MUvec,1)
    [r,lag] = xcorr(idrs(mu,:),cst,200,'normalized');
    [cors_smooth(mu),ind] = max(r); lag_smooth(mu) = lag(ind);
end

    %% Plot xcorr against RT
    cors_smooth(cors_smooth == 0) = NaN;
    rts = cell2mat(PFdata.(day).(level).MUdata.(time).(mus).RTs.force);
    meanDRs = PFdata.(day).(level).MUdata.(time).(mus).steady30.Mean_DR;
    for mu = 1:length(PFdata.(day).(level).MUdata.(time).(mus).MUPulses)
        pulses(mu) = length(PFdata.(day).(level).MUdata.(time).(mus).MUPulses{mu});
    end
    num = length(cors_smooth);

    tiledlayout(1,3)
    nexttile
        for w = 1:6
            hold on;
            rtvec = rts(1:num);
            idx = isnan(rtvec); idx2 = isnan(cors_smooth(w,:));
            idx = idx+idx2';
                %f = polyfit(rtvec(~idx),cors_smooth(w,~idx)',1);
                %plot(rtvec(~idx),f,'r')
            %scatter(rts(1:num),cors_smooth(w,:))
            scatter(normalize(rtvec(~idx)),normalize(cors_smooth(w,~idx)))
        end
        title('RTs')
    nexttile
        for w = 1:6
            drvec = meanDRs(1:num);
            idx = isnan(drvec); idx2 = isnan(cors_smooth(w,:));
            idx = idx+idx2;
            scatter(normalize(drvec(~idx)),normalize(cors_smooth(w,~idx)))
            hold on;
        end
        title('Mean DRs')
    nexttile
        for w = 1:6
            pvec = pulses(1:num);
            idx = isnan(pvec); idx2 = isnan(cors_smooth(w,:));
            idx = idx+idx2;
            scatter(normalize(pvec(~idx)),normalize(cors_smooth(w,~idx)))
            hold on;
        end
        title('# Discharges')

