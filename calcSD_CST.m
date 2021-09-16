function [MUdata] = calcSD_CST(MUdata,fdat)
% Calculate SD of FPCs, CST and individual IDR lines
% High-pass filter CST ands force first
warning('off','all')
% ------- DATA ----------
cst = highpass(MUdata.cst,0.75,2000);
cst = cst(MUdata.start:MUdata.endd);
cstorig = MUdata.cst;
cstorig = cstorig(MUdata.start:MUdata.endd);

% ------- CST whole 30s -------------
if MUdata.sectioned == 1
    allflags = fdat.allflags(MUdata.start:MUdata.endd);
    cst = cst(allflags == 0);
    cstorig = cstorig(allflags == 0);
end

% 30s window
MUdata.w30.hpf_cst_sd = std(cst);
MUdata.w30.cst_sd = std(cstorig);
MUdata.w30.cst_mean = mean(cstorig);
MUdata.w30.cst_cv = (MUdata.w30.cst_sd/MUdata.w30.cst_mean)*100;

% -------- CST sections - RAW & HPF CST! -----------------------
cst = highpass(MUdata.cst,0.75,2000);
cstorig = MUdata.cst;
% ---- Windowed ------
    for w = 1:30 % 1-s windows
        if MUdata.w1.bad_wins(w) == 1
        s = MUdata.w1.starts(w);
        e = MUdata.w1.endds(w);
        MUdata.w1.hpf_cst_sd(w) = NaN;
        MUdata.w1.cst_mean(w) = NaN;
        MUdata.w1.cst_sd(w) = NaN;
        MUdata.w1.cst_cv(w) = NaN;
        MUdata.w1.hpf_cst_secs{w} = cst(s:e); % HPC CST!
        MUdata.w1.cst_secs{w} = cstorig(s:e);
        else   
        s = MUdata.w1.starts(w);
        e = MUdata.w1.endds(w);
        MUdata.w1.hpf_cst_sd(w) = std(cst(s:e)); % HPF CST!
        MUdata.w1.cst_mean(w) = mean(cstorig(s:e)); % ORIG CST!
        MUdata.w1.cst_sd(w) = std(cst(s:e)); % ORIG CST!
        MUdata.w1.cst_cv(w) = (std(cstorig(s:e))/mean(cstorig(s:e)))*100; % ORIG!
        MUdata.w1.hpf_cst_secs{w} = cst(s:e); % HPC CST!
        MUdata.w1.cst_secs{w} = cstorig(s:e);
        end
    end

    for w = 1:6 % 5-s windows
        if MUdata.w5.bad_wins(w) == 1
        s = MUdata.w5.starts(w);
        e = MUdata.w5.endds(w);
        MUdata.w5.hpf_cst_sd(w) = NaN;
        MUdata.w5.cst_mean(w) = NaN;
        MUdata.w5.cst_sd(w) = NaN;
        MUdata.w5.cst_cv(w) = NaN;
        MUdata.w5.hpf_cst_secs{w} = cst(s:e); % HPC CST!
        MUdata.w5.cst_secs{w} = cstorig(s:e);
        else   
        s = MUdata.w5.starts(w);
        e = MUdata.w5.endds(w);
        MUdata.w5.hpf_cst_sd(w) = std(cst(s:e)); % HPF CST!
        MUdata.w5.cst_sd(w) = std(cst(s:e)); % ORIG CST!
        MUdata.w5.cst_mean(w) = mean(cstorig(s:e)); % ORIG CST!
        MUdata.w5.cst_cv(w) = (std(cstorig(s:e))/mean(cstorig(s:e)))*100; % ORIG!
        MUdata.w5.hpf_cst_secs{w} = cst(s:e); % HPF CST!
        MUdata.w5.cst_secs{w} = cstorig(s:e);
        end
    end
% -------------------------   
end
        