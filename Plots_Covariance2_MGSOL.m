%% Comparing MG to SOL
day = 'control';
level = 'submax10';
time = 'post';


%% MG
% SD of FCC, CST, force and individual IDR lines
MG_fcc = [];
% fcc
    for w = 1:30
        if isempty(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.coeffs_mean{w})
        elseif isnan(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.coeffs_mean{w})
        else
        MG_fcc_sd(w) = std(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.coeffs_mean{w}(end,:));
        MG_fcc_mean(w) = mean(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.coeffs_mean{w}(end,:));
        MG_fcc_cv(w) = (MG_fcc_sd(w)/MG_fcc_mean(w))*100;
        MG_fcc = horzcat(MG_fcc,PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.coeffs_mean{w}(end,:));
        end
    end
% cst
    ss = PFdata.(day).(level).MUdata.(time).MG.steady30.start;
    se = PFdata.(day).(level).MUdata.(time).MG.steady30.endd;
    MG_cstS = highpass(PFdata.(day).(level).MUdata.(time).MG.cst(ss:se),0.75,2000);
    MG_cst = highpass(PFdata.(day).(level).MUdata.(time).MG.cst,0.75,2000);
    for w = 1:30
        if isempty(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.coeffs_mean{w})
        elseif isnan(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.coeffs_mean{w})
        else
        s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
        e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
        MG_cst_sd(w) = std(MG_cst(s:e));
        MG_cst_mean(w) = mean(MG_cst(s:e));
        MG_cst_cv(w) = (MG_cst_sd(w)/MG_cst_mean(w))*100;
        end
    end
    
% force - high pass filtered!
hpf_f = highpass(PFdata.(day).(level).force.(time).filt{1,1},0.75,2000);
    for w = 1:30
        if isempty(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.coeffs_mean{w})
        elseif isnan(PFdata.(day).(level).MUdata.(time).MG.PCA.iter.w1.coeffs_mean{w})
        else
        s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
        e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
        f_sd(w) = std(hpf_f(s:e));
        f_mean(w) = mean(hpf_f(s:e));
        f_cv(w) = (f_sd(w)/f_mean(w))*100;
        end
    end
    
% IDRs
for mu = 1:length(PFdata.(day).(level).MUdata.(time).MG.rawlines)
    len = length(PFdata.(day).(level).MUdata.(time).MG.binary);
    isivec = PFdata.(day).(level).MUdata.(time).MG.binary_ISI;
    isivec(isivec == 0) = NaN;
    if isempty(PFdata.(day).(level).MUdata.(time).MG.rawlines{mu})
    elseif isnan(PFdata.(day).(level).MUdata.(time).MG.rawlines{mu})
    else
        temp = PFdata.(day).(level).MUdata.(time).MG.rawlines{mu};
        start = find(~isnan(temp),1,'first');
        endd = find(~isnan(temp),1,'last');
        temp = temp(start:endd);
        tempR = highpass(temp,0.75,2000);
        temp = conv(temp,hann(800),'same');
        temp = highpass(temp,0.75,2000);
        nans1 = repelem(NaN,start-1);
        nans2 = repelem(NaN,(len-endd));
        MG_idrfilts(mu,:) = horzcat(nans1,temp,nans2);
        MG_idrsRaw(mu,:) = horzcat(nans1,tempR,nans2);
        for w = 1:30
            s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
            e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
            MG_idr_smooth_sd(mu,w) = nanstd(MG_idrfilts(mu,s:e));
            MG_idr_raw_sd(mu,w) = nanstd(MG_idrsRaw(mu,s:e));
            temp3 = isivec(mu,s:e);
            MG_isi_sd(mu,w) = nanstd(temp3);
        end
    end
end
MG_idr_smooth_sd(MG_idr_smooth_sd == 0) = NaN;
MG_idr_raw_sd(MG_idr_raw_sd == 0) = NaN;
MG_isi_sd(MG_isi_sd == 0) = NaN;

% Heatmap of cross-covariance values for SD of each window
t = xcov(f_sd,MG_fcc_sd,'normalized');
    xcovs(1,2) = t(30);
t = xcov(f_sd,MG_cst_sd,'normalized');
    xcovs(1,3) = t(30);
t = xcov(f_sd,nanmean(MG_idr_smooth_sd),'normalized');
    xcovs(1,4) = t(30);
t = xcov(f_sd,nanmean(MG_isi_sd),'normalized');
    xcovs(1,5) = t(30);
t = xcov(f_sd,nanmean(MG_idr_raw_sd),'normalized');
    xcovs(1,6) = t(30);
t = xcov(f_sd,f_sd,'normalized');
    xcovs(1,1) = t(30);

t = xcov(MG_fcc_sd,MG_fcc_sd,'normalized');
    xcovs(2,2) = t(30);
t = xcov(MG_fcc_sd,MG_cst_sd,'normalized');
    xcovs(2,3) = t(30);
t = xcov(MG_fcc_sd,nanmean(MG_idr_smooth_sd),'normalized');
    xcovs(2,4) = t(30);
t = xcov(MG_fcc_sd,nanmean(MG_isi_sd),'normalized');
    xcovs(2,5) = t(30);
t = xcov(MG_fcc_sd,nanmean(MG_idr_raw_sd),'normalized');
    xcovs(2,6) = t(30);
t = xcov(MG_fcc_sd,f_sd,'normalized');
    xcovs(2,1) = t(30);

t = xcov(MG_cst_sd,MG_fcc_sd,'normalized');
    xcovs(3,2) = t(30);
t = xcov(MG_cst_sd,MG_cst_sd,'normalized');
    xcovs(3,3) = t(30);
t = xcov(MG_cst_sd,nanmean(MG_idr_smooth_sd),'normalized');
    xcovs(3,4) = t(30);
t = xcov(MG_cst_sd,nanmean(MG_isi_sd),'normalized');
    xcovs(3,5) = t(30);
t = xcov(MG_cst_sd,nanmean(MG_idr_raw_sd),'normalized');
    xcovs(3,6) = t(30);
t = xcov(MG_cst_sd,f_sd,'normalized');
    xcovs(3,1) = t(30);

t = xcov(nanmean(MG_idr_smooth_sd),MG_fcc_sd,'normalized');
    xcovs(4,2) = t(30);
t = xcov(nanmean(MG_idr_smooth_sd),MG_cst_sd,'normalized');
    xcovs(4,3) = t(30);
t = xcov(nanmean(MG_idr_smooth_sd),nanmean(MG_idr_smooth_sd),'normalized');
    xcovs(4,4) = t(30);
t = xcov(nanmean(MG_idr_smooth_sd),nanmean(MG_isi_sd),'normalized');
    xcovs(4,5) = t(30);
t = xcov(nanmean(MG_idr_smooth_sd),nanmean(MG_idr_raw_sd),'normalized');
    xcovs(4,6) = t(30);
t = xcov(nanmean(MG_idr_smooth_sd),f_sd,'normalized');
    xcovs(4,1) = t(30);

t = xcov(nanmean(MG_isi_sd),MG_fcc_sd,'normalized');
    xcovs(5,2) = t(30);
t = xcov(nanmean(MG_isi_sd),MG_cst_sd,'normalized');
    xcovs(5,3) = t(30);
t = xcov(nanmean(MG_isi_sd),nanmean(MG_idr_smooth_sd),'normalized');
    xcovs(5,4) = t(30);
t = xcov(nanmean(MG_isi_sd),nanmean(MG_isi_sd),'normalized');
    xcovs(5,5) = t(30);
t = xcov(nanmean(MG_isi_sd),nanmean(MG_idr_raw_sd),'normalized');
    xcovs(5,6) = t(30);
t = xcov(nanmean(MG_isi_sd),f_sd,'normalized');
    xcovs(5,1) = t(30);
    
t = xcov(nanmean(MG_idr_raw_sd),MG_fcc_sd,'normalized');
    xcovs(6,2) = t(30);
t = xcov(nanmean(MG_idr_raw_sd),MG_cst_sd,'normalized');
    xcovs(6,3) = t(30);
t = xcov(nanmean(MG_idr_raw_sd),nanmean(MG_idr_smooth_sd),'normalized');
    xcovs(6,4) = t(30);
t = xcov(nanmean(MG_idr_raw_sd),nanmean(MG_isi_sd),'normalized');
    xcovs(6,5) = t(30);
t = xcov(nanmean(MG_idr_raw_sd),nanmean(MG_idr_raw_sd),'normalized');
    xcovs(6,6) = t(30);
t = xcov(nanmean(MG_idr_smooth_sd),f_sd,'normalized');
    xcovs(6,1) = t(30);
%% SOL
% SD of FCC, CST, force and individual IDR lines
SOL_fcc = [];
% fcc
    for w = 1:30
        if isempty(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.coeffs_mean{w})
        elseif isnan(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.coeffs_mean{w})
        else
        SOL_fcc_sd(w) = std(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.coeffs_mean{w}(end,:));
        SOL_fcc_mean(w) = mean(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.coeffs_mean{w}(end,:));
        SOL_fcc_cv(w) = (SOL_fcc_sd(w)/SOL_fcc_mean(w))*100;
        SOL_fcc = horzcat(SOL_fcc,PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.coeffs_mean{w}(end,:));
        end
    end
% cst
    ss = PFdata.(day).(level).MUdata.(time).SOL.steady30.start;
    se = PFdata.(day).(level).MUdata.(time).SOL.steady30.endd;
    SOL_cstS = highpass(PFdata.(day).(level).MUdata.(time).SOL.cst(ss:se),0.75,2000);
    SOL_cst = highpass(PFdata.(day).(level).MUdata.(time).SOL.cst,0.75,2000);
    for w = 1:30
        if isempty(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.coeffs_mean{w})
        elseif isnan(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.coeffs_mean{w})
        else
        s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
        e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
        SOL_cst_sd(w) = std(SOL_cst(s:e));
        SOL_cst_mean(w) = mean(SOL_cst(s:e));
        SOL_cst_cv(w) = (SOL_cst_sd(w)/SOL_cst_mean(w))*100;
        end
    end
    
% force - high pass filtered!
hpf_f = highpass(PFdata.(day).(level).force.(time).filt{1,1},0.75,2000);
    for w = 1:30
        if isempty(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.coeffs_mean{w})
        elseif isnan(PFdata.(day).(level).MUdata.(time).SOL.PCA.iter.w1.coeffs_mean{w})
        else
        s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
        e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
        f_sd(w) = std(hpf_f(s:e));
        f_mean(w) = mean(hpf_f(s:e));
        f_cv(w) = (f_sd(w)/f_mean(w))*100;
        end
    end
    
% IDRs
for mu = 1:length(PFdata.(day).(level).MUdata.(time).SOL.rawlines)
    len = length(PFdata.(day).(level).MUdata.(time).SOL.binary);
    isivec = PFdata.(day).(level).MUdata.(time).SOL.binary_ISI;
    isivec(isivec == 0) = NaN;
    if isempty(PFdata.(day).(level).MUdata.(time).SOL.rawlines{mu})
    elseif isnan(PFdata.(day).(level).MUdata.(time).SOL.rawlines{mu})
    else
        temp = PFdata.(day).(level).MUdata.(time).SOL.rawlines{mu};
        start = find(~isnan(temp),1,'first');
        endd = find(~isnan(temp),1,'last');
        temp = temp(start:endd);
        tempR = highpass(temp,0.75,2000);
        temp = conv(temp,hann(800),'same');
        temp = highpass(temp,0.75,2000);
        nans1 = repelem(NaN,start-1);
        nans2 = repelem(NaN,(len-endd));
        SOL_idrfilts(mu,:) = horzcat(nans1,temp,nans2);
        SOL_idrsRaw(mu,:) = horzcat(nans1,tempR,nans2);
        for w = 1:30
            s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
            e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
            SOL_idr_smooth_sd(mu,w) = nanstd(SOL_idrfilts(mu,s:e));
            SOL_idr_raw_sd(mu,w) = nanstd(SOL_idrsRaw(mu,s:e));
            temp3 = isivec(mu,s:e);
            SOL_isi_sd(mu,w) = nanstd(temp3);
        end
    end
end
SOL_idr_smooth_sd(SOL_idr_smooth_sd == 0) = NaN;
SOL_idr_raw_sd(SOL_idr_raw_sd == 0) = NaN;
SOL_isi_sd(SOL_isi_sd == 0) = NaN;

% Heatmap of cross-covariance values for SD of each window
t = xcov(f_sd,SOL_fcc_sd,'normalized');
    SOLxcovs(1,2) = t(30);
t = xcov(f_sd,SOL_cst_sd,'normalized');
    SOLxcovs(1,3) = t(30);
t = xcov(f_sd,nanmean(SOL_idr_smooth_sd),'normalized');
    SOLxcovs(1,4) = t(30);
t = xcov(f_sd,nanmean(SOL_isi_sd),'normalized');
    SOLxcovs(1,5) = t(30);
t = xcov(f_sd,nanmean(SOL_idr_raw_sd),'normalized');
    SOLxcovs(1,6) = t(30);
t = xcov(f_sd,f_sd,'normalized');
    SOLxcovs(1,1) = t(30);

t = xcov(SOL_fcc_sd,SOL_fcc_sd,'normalized');
    SOLxcovs(2,2) = t(30);
t = xcov(SOL_fcc_sd,SOL_cst_sd,'normalized');
    SOLxcovs(2,3) = t(30);
t = xcov(SOL_fcc_sd,nanmean(SOL_idr_smooth_sd),'normalized');
    SOLxcovs(2,4) = t(30);
t = xcov(SOL_fcc_sd,nanmean(SOL_isi_sd),'normalized');
    SOLxcovs(2,5) = t(30);
t = xcov(SOL_fcc_sd,nanmean(SOL_idr_raw_sd),'normalized');
    SOLxcovs(2,6) = t(30);
t = xcov(SOL_fcc_sd,f_sd,'normalized');
    SOLxcovs(2,1) = t(30);

t = xcov(SOL_cst_sd,SOL_fcc_sd,'normalized');
    SOLxcovs(3,2) = t(30);
t = xcov(SOL_cst_sd,SOL_cst_sd,'normalized');
    SOLxcovs(3,3) = t(30);
t = xcov(SOL_cst_sd,nanmean(SOL_idr_smooth_sd),'normalized');
    SOLxcovs(3,4) = t(30);
t = xcov(SOL_cst_sd,nanmean(SOL_isi_sd),'normalized');
    SOLxcovs(3,5) = t(30);
t = xcov(SOL_cst_sd,nanmean(SOL_idr_raw_sd),'normalized');
    SOLxcovs(3,6) = t(30);
t = xcov(SOL_cst_sd,f_sd,'normalized');
    SOLxcovs(3,1) = t(30);

t = xcov(nanmean(SOL_idr_smooth_sd),SOL_fcc_sd,'normalized');
    SOLxcovs(4,2) = t(30);
t = xcov(nanmean(SOL_idr_smooth_sd),SOL_cst_sd,'normalized');
    SOLxcovs(4,3) = t(30);
t = xcov(nanmean(SOL_idr_smooth_sd),nanmean(SOL_idr_smooth_sd),'normalized');
    SOLxcovs(4,4) = t(30);
t = xcov(nanmean(SOL_idr_smooth_sd),nanmean(SOL_isi_sd),'normalized');
    SOLxcovs(4,5) = t(30);
t = xcov(nanmean(SOL_idr_smooth_sd),nanmean(SOL_idr_raw_sd),'normalized');
    SOLxcovs(4,6) = t(30);
t = xcov(nanmean(SOL_idr_smooth_sd),f_sd,'normalized');
    SOLxcovs(4,1) = t(30);

t = xcov(nanmean(SOL_isi_sd),SOL_fcc_sd,'normalized');
    SOLxcovs(5,2) = t(30);
t = xcov(nanmean(SOL_isi_sd),SOL_cst_sd,'normalized');
    SOLxcovs(5,3) = t(30);
t = xcov(nanmean(SOL_isi_sd),nanmean(SOL_idr_smooth_sd),'normalized');
    SOLxcovs(5,4) = t(30);
t = xcov(nanmean(SOL_isi_sd),nanmean(SOL_isi_sd),'normalized');
    SOLxcovs(5,5) = t(30);
t = xcov(nanmean(SOL_isi_sd),nanmean(SOL_idr_raw_sd),'normalized');
    SOLxcovs(5,6) = t(30);
t = xcov(nanmean(SOL_isi_sd),f_sd,'normalized');
    SOLxcovs(5,1) = t(30);
    
t = xcov(nanmean(SOL_idr_raw_sd),SOL_fcc_sd,'normalized');
    SOLxcovs(6,2) = t(30);
t = xcov(nanmean(SOL_idr_raw_sd),SOL_cst_sd,'normalized');
    SOLxcovs(6,3) = t(30);
t = xcov(nanmean(SOL_idr_raw_sd),nanmean(SOL_idr_smooth_sd),'normalized');
    SOLxcovs(6,4) = t(30);
t = xcov(nanmean(SOL_idr_raw_sd),nanmean(SOL_isi_sd),'normalized');
    SOLxcovs(6,5) = t(30);
t = xcov(nanmean(SOL_idr_raw_sd),nanmean(SOL_idr_raw_sd),'normalized');
    SOLxcovs(6,6) = t(30);
t = xcov(nanmean(SOL_idr_smooth_sd),f_sd,'normalized');
    SOLxcovs(6,1) = t(30);

%% % LG
% SD of FCC, CST, force and individual IDR lines
LG_fcc = [];
% fcc
    for w = 1:30
        if isempty(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.coeffs_mean{w})
        elseif isnan(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.coeffs_mean{w})
        else
        LG_fcc_sd(w) = std(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.coeffs_mean{w}(end,:));
        LG_fcc_mean(w) = mean(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.coeffs_mean{w}(end,:));
        LG_fcc_cv(w) = (LG_fcc_sd(w)/LG_fcc_mean(w))*100;
        LG_fcc = horzcat(LG_fcc,PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.coeffs_mean{w}(end,:));
        end
    end
% cst
    ss = PFdata.(day).(level).MUdata.(time).LG.steady30.start;
    se = PFdata.(day).(level).MUdata.(time).LG.steady30.endd;
    LG_cstS = highpass(PFdata.(day).(level).MUdata.(time).LG.cst(ss:se),0.75,2000);
    LG_cst = highpass(PFdata.(day).(level).MUdata.(time).LG.cst,0.75,2000);
    for w = 1:30
        if isempty(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.coeffs_mean{w})
        elseif isnan(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.coeffs_mean{w})
        else
        s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
        e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
        LG_cst_sd(w) = std(LG_cst(s:e));
        LG_cst_mean(w) = mean(LG_cst(s:e));
        LG_cst_cv(w) = (LG_cst_sd(w)/LG_cst_mean(w))*100;
        end
    end
    
% force - high pass filtered!
hpf_f = highpass(PFdata.(day).(level).force.(time).filt{1,1},0.75,2000);
    for w = 1:30
        if isempty(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.coeffs_mean{w})
        elseif isnan(PFdata.(day).(level).MUdata.(time).LG.PCA.iter.w1.coeffs_mean{w})
        else
        s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
        e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
        f_sd(w) = std(hpf_f(s:e));
        f_mean(w) = mean(hpf_f(s:e));
        f_cv(w) = (f_sd(w)/f_mean(w))*100;
        end
    end
    
% IDRs
for mu = 1:length(PFdata.(day).(level).MUdata.(time).LG.rawlines)
    len = length(PFdata.(day).(level).MUdata.(time).LG.binary);
    isivec = PFdata.(day).(level).MUdata.(time).LG.binary_ISI;
    isivec(isivec == 0) = NaN;
    if isempty(PFdata.(day).(level).MUdata.(time).LG.rawlines{mu})
    elseif isnan(PFdata.(day).(level).MUdata.(time).LG.rawlines{mu})
    else
        temp = PFdata.(day).(level).MUdata.(time).LG.rawlines{mu};
        start = find(~isnan(temp),1,'first');
        endd = find(~isnan(temp),1,'last');
        temp = temp(start:endd);
        tempR = highpass(temp,0.75,2000);
        temp = conv(temp,hann(800),'same');
        temp = highpass(temp,0.75,2000);
        nans1 = repelem(NaN,start-1);
        nans2 = repelem(NaN,(len-endd));
        LG_idrfilts(mu,:) = horzcat(nans1,temp,nans2);
        LG_idrsRaw(mu,:) = horzcat(nans1,tempR,nans2);
        for w = 1:30
            s = PFdata.(day).(level).MUdata.(time).w1.starts(w);
            e = PFdata.(day).(level).MUdata.(time).w1.endds(w);
            LG_idr_smooth_sd(mu,w) = nanstd(LG_idrfilts(mu,s:e));
            LG_idr_raw_sd(mu,w) = nanstd(LG_idrsRaw(mu,s:e));
            temp3 = isivec(mu,s:e);
            LG_isi_sd(mu,w) = nanstd(temp3);
        end
    end
end
LG_idr_smooth_sd(LG_idr_smooth_sd == 0) = NaN;
LG_idr_raw_sd(LG_idr_raw_sd == 0) = NaN;
LG_isi_sd(LG_isi_sd == 0) = NaN;

% Heatmap of cross-covariance values for SD of each window
t = xcov(f_sd,LG_fcc_sd,'normalized');
    LGxcovs(1,2) = t(30);
t = xcov(f_sd,LG_cst_sd,'normalized');
    LGxcovs(1,3) = t(30);
t = xcov(f_sd,nanmean(LG_idr_smooth_sd),'normalized');
    LGxcovs(1,4) = t(30);
t = xcov(f_sd,nanmean(LG_isi_sd),'normalized');
    LGxcovs(1,5) = t(30);
t = xcov(f_sd,nanmean(LG_idr_raw_sd),'normalized');
    LGxcovs(1,6) = t(30);
t = xcov(f_sd,f_sd,'normalized');
    LGxcovs(1,1) = t(30);

t = xcov(LG_fcc_sd,LG_fcc_sd,'normalized');
    LGxcovs(2,2) = t(30);
t = xcov(LG_fcc_sd,LG_cst_sd,'normalized');
    LGxcovs(2,3) = t(30);
t = xcov(LG_fcc_sd,nanmean(LG_idr_smooth_sd),'normalized');
    LGxcovs(2,4) = t(30);
t = xcov(LG_fcc_sd,nanmean(LG_isi_sd),'normalized');
    LGxcovs(2,5) = t(30);
t = xcov(LG_fcc_sd,nanmean(LG_idr_raw_sd),'normalized');
    LGxcovs(2,6) = t(30);
t = xcov(LG_fcc_sd,f_sd,'normalized');
    LGxcovs(2,1) = t(30);

t = xcov(LG_cst_sd,LG_fcc_sd,'normalized');
    LGxcovs(3,2) = t(30);
t = xcov(LG_cst_sd,LG_cst_sd,'normalized');
    LGxcovs(3,3) = t(30);
t = xcov(LG_cst_sd,nanmean(LG_idr_smooth_sd),'normalized');
    LGxcovs(3,4) = t(30);
t = xcov(LG_cst_sd,nanmean(LG_isi_sd),'normalized');
    LGxcovs(3,5) = t(30);
t = xcov(LG_cst_sd,nanmean(LG_idr_raw_sd),'normalized');
    LGxcovs(3,6) = t(30);
t = xcov(LG_cst_sd,f_sd,'normalized');
    LGxcovs(3,1) = t(30);

t = xcov(nanmean(LG_idr_smooth_sd),LG_fcc_sd,'normalized');
    LGxcovs(4,2) = t(30);
t = xcov(nanmean(LG_idr_smooth_sd),LG_cst_sd,'normalized');
    LGxcovs(4,3) = t(30);
t = xcov(nanmean(LG_idr_smooth_sd),nanmean(LG_idr_smooth_sd),'normalized');
    LGxcovs(4,4) = t(30);
t = xcov(nanmean(LG_idr_smooth_sd),nanmean(LG_isi_sd),'normalized');
    LGxcovs(4,5) = t(30);
t = xcov(nanmean(LG_idr_smooth_sd),nanmean(LG_idr_raw_sd),'normalized');
    LGxcovs(4,6) = t(30);
t = xcov(nanmean(LG_idr_smooth_sd),f_sd,'normalized');
    LGxcovs(4,1) = t(30);

t = xcov(nanmean(LG_isi_sd),LG_fcc_sd,'normalized');
    LGxcovs(5,2) = t(30);
t = xcov(nanmean(LG_isi_sd),LG_cst_sd,'normalized');
    LGxcovs(5,3) = t(30);
t = xcov(nanmean(LG_isi_sd),nanmean(LG_idr_smooth_sd),'normalized');
    LGxcovs(5,4) = t(30);
t = xcov(nanmean(LG_isi_sd),nanmean(LG_isi_sd),'normalized');
    LGxcovs(5,5) = t(30);
t = xcov(nanmean(LG_isi_sd),nanmean(LG_idr_raw_sd),'normalized');
    LGxcovs(5,6) = t(30);
t = xcov(nanmean(LG_isi_sd),f_sd,'normalized');
    LGxcovs(5,1) = t(30);
    
t = xcov(nanmean(LG_idr_raw_sd),LG_fcc_sd,'normalized');
    LGxcovs(6,2) = t(30);
t = xcov(nanmean(LG_idr_raw_sd),LG_cst_sd,'normalized');
    LGxcovs(6,3) = t(30);
t = xcov(nanmean(LG_idr_raw_sd),nanmean(LG_idr_smooth_sd),'normalized');
    LGxcovs(6,4) = t(30);
t = xcov(nanmean(LG_idr_raw_sd),nanmean(LG_isi_sd),'normalized');
    LGxcovs(6,5) = t(30);
t = xcov(nanmean(LG_idr_raw_sd),nanmean(LG_idr_raw_sd),'normalized');
    LGxcovs(6,6) = t(30);
t = xcov(nanmean(LG_idr_smooth_sd),f_sd,'normalized');
    LGxcovs(6,1) = t(30);

%% Visualize all 1-s windows
set(gcf, 'Renderer', 'painters');
figure(1)
tiledlayout(4,1)
nexttile
    plot(MG_fcc,'c'); hold on;
    plot(SOL_fcc,'g')
    plot(LG_fcc,'b')
    xlim([0 60000])
    title('Merged 1-s windows of FCC')
nexttile
    plot(normalize(MG_cstS),'c'); hold on;
    plot(normalize(SOL_cstS),'g')
    plot(normalize(LG_cstS),'b')
    xlim([0 60000])
    title('Continuous CST')
nexttile
    yyaxis left
    plot(MG_fcc_sd,'c-'); hold on;
    yyaxis right
    plot(SOL_fcc_sd,'g-');
    plot(LG_fcc_sd,'b-');
    xlim([1 30])
    title('SD for FCC')
nexttile
    yyaxis left
    plot(MG_cst_sd,'c-'); hold on;
    yyaxis right
    plot(SOL_cst_sd,'g-');
    plot(LG_cst_sd,'b-');
    xlim([1 30])
    title('SD for CST')

%%
set(gcf, 'Renderer', 'painters');
tiledlayout(2,1)
nexttile
    boxplot(MG_idr_smooth_sd,'colors','c','Symbol',''); hold on;
    boxplot(LG_idr_smooth_sd,'colors','b','Symbol','');
    boxplot(SOL_idr_smooth_sd,'colors','g','Symbol','');
    ylim([0 800])
    title('SO for Smoothed IDRs: Blue = LG, Cyan = MG, green = SOL')
nexttile
    boxplot(MG_isi_sd,'colors','c','Symbol',''); hold on;
    boxplot(SOL_isi_sd,'colors','g','Symbol','')
    boxplot(LG_isi_sd,'colors','b','Symbol','')
    ylim([0 50])
    title('SD for ISIs')


%% regressions
scatter(f_sd,MG_cst_sd)
scatter(f_sd,MG_fcc_sd)
scatter(MG_cst_sd,MG_fcc_sd)
scatter(nanmean(MG_isi_sd),nanmean(MG_idr_smooth_sd),'r')
scatter(nanmean(MG_idr_raw_sd),nanmean(MG_idr_smooth_sd),'r')
scatter(nanmean(MG_isi_sd),nanmean(MG_idr_raw_sd))

