function [MUdata] = calcSD_force_raw(MUdata,fdat,level)
% MUdata = dat = PFdata.(day).(level).MUdata.(time)
% fdat = = PFdata.stretch.(level).force.(time)
% Calculate SD for force for individual contractions
if contains(level,'submax35')
    l = 2;
elseif contains(level,'submax10')
    l = 1;
end

% FORCE - RAW!
    ff = fdat.filt{1,l};
    
    % 30s window
    MUdata.w30.f_sd = std(fdat.steady30.filt{1,l});
    MUdata.w30.f_cv = (MUdata.w30.f_sd/mean(fdat.steady30.filt{1,l}))*100;
    
    for w = 1:30 % 1 s windows
        s = MUdata.w1.starts(w);
        e = MUdata.w1.endds(w);
        MUdata.w1.f_sd(w) = std(ff(s:e));
        MUdata.w1.f_mean(w) = mean(ff(s:e));
        MUdata.w1.f_cv(w) = (MUdata.w1.f_sd(w)/MUdata.w1.f_mean(w))*100;
        MUdata.w1.f_secs{w} = ff(s:e);
    end
    
    for w = 1:6 % 5 s windows
        s = MUdata.w5.starts(w);
        e = MUdata.w5.endds(w);
        MUdata.w5.f_sd(w) = std(ff(s:e));
        MUdata.w5.f_mean(w) = mean(ff(s:e));
        MUdata.w5.f_cv(w) = (MUdata.w5.f_sd(w)/MUdata.w5.f_mean(w))*100;
        MUdata.w5.f_secs{w} = ff(s:e);
    end
    
end