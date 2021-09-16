function [MUdata] = calcSD_force(MUdata,fdat,level)
% MUdata = dat = PFdata.(day).(level).MUdata.(time)
% fdat = = PFdata.stretch.(level).force.(time)
% Calculate SD for force for individual contractions
if contains(level,'submax35')
    l = 2;
elseif contains(level,'submax10')
    l = 1;
end

% FORCE - High pass filtered!
    hpf_f = highpass(fdat.filt{1,l},0.75,2000);
    if length(fdat.hp_filt{1,1}) > hpf_f
       hpf_f = fdat.hp_filt{1,l};
    end
    if sum(fdat.allflags) > 0
       if length(hpf_f) < length(fdat.allflags)
           allflags = fdat.allflags(1:length(hpf_f));
           allflags = allflags(fdat.steady30.start:fdat.steady30.endd);
       else
           allflags = fdat.allflags(fdat.steady30.start:fdat.steady30.endd);
       end
    end
    
    % 30s window
    hpf_f = hpf_f(fdat.steady30.start:fdat.steady30.endd);
    if sum(fdat.allflags) > 0
        hpf_f = hpf_f(allflags == 0);
    end
        
    MUdata.w30.hpf_f_sd = std(hpf_f);
    MUdata.w30.hpf_f_mean = mean(hpf_f);
    MUdata.w30.hpf_f_cv = (MUdata.w30.hpf_f_sd/MUdata.w30.hpf_f_mean)*100;
  
    % Reset force variable
    hpf_f = highpass(fdat.filt{1,l},0.75,2000);
       if length(fdat.hp_filt{1,1}) > hpf_f
        hpf_f = fdat.hp_filt{1,l};
       end
    for w = 1:30 % 1 s windows
        if MUdata.w1.bad_wins(w) == 1
            s = MUdata.w1.starts(w);
            e = MUdata.w1.endds(w);
            MUdata.w1.hpf_f_sd(w) = NaN;
            MUdata.w1.hpf_f_mean(w) = NaN;
            MUdata.w1.hpf_f_cv(w) = NaN;
            MUdata.w1.hpf_f_secs{w} = hpf_f(s:e);
        else
        s = MUdata.w1.starts(w);
        e = MUdata.w1.endds(w);
        MUdata.w1.hpf_f_sd(w) = std(hpf_f(s:e));
        MUdata.w1.hpf_f_mean(w) = mean(hpf_f(s:e));
        MUdata.w1.hpf_f_cv(w) = (MUdata.w1.hpf_f_sd(w)/MUdata.w1.hpf_f_mean(w))*100;
        MUdata.w1.hpf_f_secs{w} = hpf_f(s:e);
        end
    end
    
    for w = 1:6 % 5 s windows
        if MUdata.w5.bad_wins(w) == 1
            s = MUdata.w5.starts(w);
            e = MUdata.w5.endds(w);
            MUdata.w5.hpf_f_sd(w) = NaN;
            MUdata.w5.hpf_f_mean(w) = NaN;
            MUdata.w5.hpf_f_cv(w) = NaN;
            MUdata.w5.hpf_f_secs{w} = hpf_f(s:e);
        else
        s = MUdata.w5.starts(w);
        e = MUdata.w5.endds(w);
        MUdata.w5.hpf_f_sd(w) = std(hpf_f(s:e));
        MUdata.w5.hpf_f_mean(w) = mean(hpf_f(s:e));
        MUdata.w5.hpf_f_cv(w) = (MUdata.w5.hpf_f_sd(w)/MUdata.w5.hpf_f_mean(w))*100;
        MUdata.w5.hpf_f_secs{w} = hpf_f(s:e);
        end
    end
    
    
% ------ FORCE - RAW! ------
    ff = fdat.filt{1,l};
    if length(ff) < length(fdat.hp_filt{1,1})
        b = length(fdat.hp_filt{1,1})-length(ff);
        buff = zeros(b,1);
        ff = vertcat(buff,ff);
    end
    if sum(fdat.allflags) > 0
       if length(ff) < length(fdat.allflags)
           allflags = fdat.allflags(1:length(ff));
           allflags = allflags(fdat.steady30.start:fdat.steady30.endd);
       else
           allflags = fdat.allflags(fdat.steady30.start:fdat.steady30.endd);
       end
    end
    % 30s window
    ff = ff(fdat.steady30.start:fdat.steady30.endd);
    if sum(fdat.allflags) > 0
        ff = ff(allflags == 0);
    end
        
    MUdata.w30.f_sd = std(ff);
    MUdata.w30.f_mean = mean(ff);
    MUdata.w30.f_cv = (MUdata.w30.f_sd/MUdata.w30.f_mean)*100;
    
    % Reset force variable
    ff = fdat.filt{1,l};
        if length(ff) < length(fdat.hp_filt{1,1})
            b = length(fdat.hp_filt{1,1})-length(ff);
            buff = zeros(b,1);
            ff = vertcat(buff,ff);
        end
    
    for w = 1:30 % 1 s windows
        if MUdata.w1.bad_wins(w) == 1
            s = MUdata.w1.starts(w);
            e = MUdata.w1.endds(w);
            MUdata.w1.f_sd(w) = NaN;
            MUdata.w1.f_mean(w) = NaN;
            MUdata.w1.f_cv(w) = NaN;
            MUdata.w1.f_secs{w} = ff(s:e);
        else
        s = MUdata.w1.starts(w);
        e = MUdata.w1.endds(w);
        MUdata.w1.f_sd(w) = std(ff(s:e));
        MUdata.w1.f_mean(w) = mean(ff(s:e));
        MUdata.w1.f_cv(w) = (MUdata.w1.f_sd(w)/MUdata.w1.f_mean(w))*100;
        MUdata.w1.f_secs{w} = ff(s:e);
        end
    end
    
    for w = 1:6 % 5 s windows
        if MUdata.w5.bad_wins(w) == 1
            s = MUdata.w5.starts(w);
            e = MUdata.w5.endds(w);
            MUdata.w5.f_sd(w) = NaN;
            MUdata.w5.f_mean(w) = NaN;
            MUdata.w5.f_cv(w) = NaN;
            MUdata.w5.f_secs{w} = ff(s:e);
        else
        s = MUdata.w5.starts(w);
        e = MUdata.w5.endds(w);
        MUdata.w5.f_sd(w) = std(ff(s:e));
        MUdata.w5.f_mean(w) = mean(ff(s:e));
        MUdata.w5.f_cv(w) = (MUdata.w5.f_sd(w)/MUdata.w5.f_mean(w))*100;
        MUdata.w5.f_secs{w} = ff(s:e);
        end
    end
    
    
end