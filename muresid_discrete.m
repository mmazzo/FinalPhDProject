function [MUdat] = muresid_discrete(MUdat)  
if isempty(MUdat)
else
% -------- STEPS ----------------------------------------
%   1. High-pass filter signals (1.5 hz)

%   2. Two normalization options
%           1. to same scale of -1 to +1
%               then
%           2. to have a mean of 0

%   3. Lag between individual IDRs and PLDS/CST are corrrected with xcorr

%   4. Discrete AP times ampled from fitlered, normalized signals to find
%      diffs between single MU activities and estimates of common input

% ----------------------------------------------------------------
     fc = 1.5;                                 
     fsamp = 2000;                                  
     [filt2, filt1] = butter(4,fc/fsamp/2,'high');

       
% ------------- xcorr with all MUs first --------------------------------
if isnan(MUdat.cst)
else
    for mu = 1:length(MUdat.rawlines)
    % Across active portion
    ind3 = find(~isnan(MUdat.rawlines{1,mu}),1,'first');
    ind4 = find(~isnan(MUdat.rawlines{1,mu}),1,'last');
    tempflags{mu} = MUdat.flags(ind3:ind4);
    if isempty(ind3) || isempty(ind4)
    else
    % HPF   
    MU_hpf = filtfilt(filt2,filt1,MUdat.rawlines{1,mu}(ind3:ind4));
    CST_hpf = filtfilt(filt2,filt1,MUdat.cst(ind3:ind4));
    PLDS_hpf = filtfilt(filt2,filt1,MUdat.PLDS.raw(ind3:ind4));
    % Use xcorr results to shift MU
        % PLDS xcorr
        [sigcor,siglag] = xcorr(MU_hpf,PLDS_hpf,'coeff');
            [maxcor,ind] = max(sigcor);
            PLDSmaxcors(mu,1) = maxcor;
            t = siglag(ind);
            if isnan(maxcor)
            PLDSlags(mu,1) = NaN;
            else
            PLDSlags(mu,1) = t;
            end
        % CST xcorr
        [sigcor,siglag] = xcorr(MU_hpf,CST_hpf,'coeff');
            [maxcor,ind] = max(sigcor);
            CSTmaxcors(mu,1) = maxcor;
            t = siglag(ind);
            if isnan(maxcor)
            CSTlags(mu,1) = NaN;
            else
            CSTlags(mu,1) = t;
            end
    end
    end
    PLDSmeanlag = round(nanmean(PLDSlags));
    PLDSmeancors = nanmean(PLDSmaxcors);
    CSTmeanlag = round(nanmean(CSTlags));
    CSTmeancors = nanmean(CSTmaxcors);
end

clear('mu');
% ----------- Shift CST and PLDS based on mean lags -----------------
MUdat.PLDS.shifted = MUdat.PLDS.raw((-PLDSmeanlag):end);
MUdat.cst_shifted = MUdat.cst((-CSTmeanlag):end);

% ----------- For each motor unit ------------------------------------                
for mu = 1:length(MUdat.MUPulses)
    if isempty(MUdat.MUPulses{1,mu})
    % do soemthing here or no?
    else
    
    % ------------- Whole time active --------------------------------
    ind3 = find(~isnan(MUdat.rawlines{1,mu}),1,'first');
    ind4 = find(~isnan(MUdat.rawlines{1,mu}),1,'last');
    tempflags{mu} = MUdat.flags(ind3:ind4);
    % Filtering
        % HPF   
        MUdat.HPF.MU_hpf{mu} = filtfilt(filt2,filt1,MUdat.rawlines{1,mu}(ind3:ind4));
        MUdat.HPF.MU_hpf_orig{mu} = MUdat.HPF.MU_hpf{mu};
        MUdat.HPF.CST_hpf{mu} = filtfilt(filt2,filt1,MUdat.cst_shifted(ind3:ind4));
        MUdat.HPF.CST_hpf_orig{mu} = MUdat.HPF.CST_hpf{mu};
        MUdat.HPF.PLDS_hpf{mu} = filtfilt(filt2,filt1,MUdat.PLDS.shifted(ind3:ind4));
        MUdat.HPF.PLDS_hpf_orig{mu} = MUdat.HPF.PLDS_hpf{mu};
        % Normalized to [-1 +1 scale]
        MUdat.HPF.MU_hpf_norm1{mu} = normalize(MUdat.HPF.MU_hpf{mu},'center');
        MUdat.HPF.CST_hpf_norm1{mu} = normalize(MUdat.HPF.CST_hpf{mu},'center');
        MUdat.HPF.PLDS_hpf_norm1{mu} = normalize(MUdat.HPF.PLDS_hpf{mu},'center');
        % Normalized again to have mean of 0
        MUdat.HPF.MU_hpf_norm2{mu} = normalize(normalize(MUdat.HPF.MU_hpf_norm1{mu},'range',[-1 1]),'center');
        MUdat.HPF.CST_hpf_norm2{mu} = normalize(normalize(MUdat.HPF.CST_hpf_norm1{mu},'range',[-1 1]),'center');
        MUdat.HPF.PLDS_hpf_norm2{mu} = normalize(normalize(MUdat.HPF.PLDS_hpf_norm1{mu},'range',[-1 1]),'center');
    
    % TO DO - REMOVE FLAGGED SECTIONS
    
    % Discretize MU lines
        MUdat.HPF.times{mu} = MUdat.MUPulses{1,mu}(2:end-1)-(ind3-1);
        MUdat.HPF.IDRs_hpf{mu} = MUdat.HPF.MU_hpf{mu}(MUdat.HPF.times{mu});
        MUdat.HPF.IDRs_hpf_norm1{mu} = MUdat.HPF.MU_hpf_norm1{mu}(MUdat.HPF.times{mu});
        MUdat.HPF.IDRs_hpf_norm2{mu} = MUdat.HPF.MU_hpf_norm2{mu}(MUdat.HPF.times{mu});
        
    % Find data in CST and PLDS at these points
        MUdat.HPF.CST_hpf{mu} = MUdat.HPF.CST_hpf{mu}(MUdat.HPF.times{mu});
        MUdat.HPF.CST_hpf_norm1{mu} = MUdat.HPF.CST_hpf_norm1{mu}(MUdat.HPF.times{mu});
        MUdat.HPF.CST_hpf_norm2{mu} = MUdat.HPF.CST_hpf_norm2{mu}(MUdat.HPF.times{mu});
        MUdat.HPF.PLDS_hpf{mu} = MUdat.HPF.PLDS_hpf{mu}(MUdat.HPF.times{mu});
        MUdat.HPF.PLDS_hpf_norm1{mu} = MUdat.HPF.PLDS_hpf_norm1{mu}(MUdat.HPF.times{mu});
        MUdat.HPF.PLDS_hpf_norm2{mu} = MUdat.HPF.PLDS_hpf_norm2{mu}(MUdat.HPF.times{mu});
        
    % Calculate residuals
        MUdat.residualsCST.HPF{mu} = MUdat.HPF.IDRs_hpf{mu} - MUdat.HPF.CST_hpf{mu};
        MUdat.residualsCST.HPF_norm1{mu} = MUdat.HPF.IDRs_hpf_norm1{mu} - MUdat.HPF.CST_hpf_norm1{mu};
        MUdat.residualsCST.HPF_norm2{mu} = MUdat.HPF.IDRs_hpf_norm2{mu} - MUdat.HPF.CST_hpf_norm2{mu};
        MUdat.residualsPLDS.HPF{mu} = MUdat.HPF.IDRs_hpf{mu} - MUdat.HPF.PLDS_hpf{mu};
        MUdat.residualsPLDS.HPF_norm1{mu} = MUdat.HPF.IDRs_hpf_norm1{mu} - MUdat.HPF.PLDS_hpf_norm1{mu};
        MUdat.residualsPLDS.HPF_norm2{mu} = MUdat.HPF.IDRs_hpf_norm2{mu} - MUdat.HPF.PLDS_hpf_norm2{mu};
        
     % Means 
       MUdat.residualsCST.HPF_means(mu,1) = nanmean(abs(MUdat.residualsCST.HPF{mu}));
       MUdat.residualsCST.HPF_norm1_means(mu,1) = nanmean(abs(MUdat.residualsCST.HPF_norm1{mu}));
       MUdat.residualsCST.HPF_norm2_means(mu,1) = nanmean(abs(MUdat.residualsCST.HPF_norm2{mu}));
       MUdat.residualsPLDS.HPF_means(mu,1) = nanmean(abs(MUdat.residualsPLDS.HPF{mu}));
       MUdat.residualsPLDS.HPF_norm1_means(mu,1) = nanmean(abs(MUdat.residualsPLDS.HPF_norm1{mu}));
       MUdat.residualsPLDS.HPF_norm2_means(mu,1) = nanmean(abs(MUdat.residualsPLDS.HPF_norm2{mu}));
    
    %  -------- Across steady portion ONLY ---------------------------
    indS = MUdat.steady30.start;
    indE = MUdat.steady30.endd;
    ind1 = indS-ind3;
    if ind1 < 0
        ind1 = ind3;
    end
    if indE < ind4
        ind2 = indE;
    else
        ind2 = ind4;
    end
    
    % Figure out which data points are between these two indices
    temptimes = MUdat.MUPulses{1,mu}(2:end-1);
    inds = ind1<temptimes<ind2;
    
    % Subset betwen ind 1 and ind 2
        MUdat.residualsCST.steady30.HPF{mu} = MUdat.residualsCST.HPF{mu}(inds);
        MUdat.residualsCST.steady30.HPF_norm1{mu}  = MUdat.residualsCST.HPF_norm1{mu}(inds);
        MUdat.residualsCST.steady30.HPF_norm2{mu}  = MUdat.residualsCST.HPF_norm2{mu}(inds);
        MUdat.residualsPLDS.steady30.HPF{mu} = MUdat.residualsPLDS.HPF{mu}(inds);
        MUdat.residualsPLDS.steady30.HPF_norm1{mu} = MUdat.residualsPLDS.HPF_norm1{mu}(inds);
        MUdat.residualsPLDS.steady30.HPF_norm2{mu} = MUdat.residualsPLDS.HPF_norm2{mu}(inds);
    % Means      
    MUdat.residualsCST.steady30.HPF_means(mu,1) = nanmean(abs(MUdat.residualsCST.steady30.HPF{mu}));
    MUdat.residualsCST.steady30.HPF_norm1_means(mu,1) = nanmean(abs(MUdat.residualsCST.steady30.HPF_norm1{mu}));
    MUdat.residualsCST.steady30.HPF_norm2_means(mu,1) = nanmean(abs(MUdat.residualsCST.steady30.HPF_norm2{mu}));
    MUdat.residualsPLDS.steady30.HPF_means(mu,1) = nanmean(abs(MUdat.residualsPLDS.steady30.HPF{mu}));
    MUdat.residualsPLDS.steady30.HPF_norm1_means(mu,1) = nanmean(abs(MUdat.residualsPLDS.steady30.HPF_norm1{mu}));
    MUdat.residualsPLDS.steady30.HPF_norm2_means(mu,1) = nanmean(abs(MUdat.residualsPLDS.steady30.HPF_norm2{mu}));
    
    end
end
% --------- Remove 0s --------------------------------
   MUdat.residualsCST.HPF_means(MUdat.residualsCST.HPF_means == 0) = NaN;
   MUdat.residualsCST.HPF_norm1_means(MUdat.residualsCST.HPF_norm1_means == 0) = NaN;
   MUdat.residualsCST.HPF_norm2_means(MUdat.residualsCST.HPF_norm2_means == 0) = NaN;
   MUdat.residualsPLDS.HPF_means(MUdat.residualsPLDS.HPF_means == 0) = NaN;
   MUdat.residualsPLDS.HPF_norm1_means(MUdat.residualsPLDS.HPF_norm1_means == 0) = NaN;
   MUdat.residualsPLDS.HPF_norm2_means(MUdat.residualsPLDS.HPF_norm2_means == 0) = NaN;

   MUdat.residualsCST.steady30.HPF_means(MUdat.residualsCST.steady30.HPF_means ==0) = NaN;
   MUdat.residualsCST.steady30.HPF_norm1_means(MUdat.residualsCST.steady30.HPF_norm1_means == 0) = NaN;
   MUdat.residualsCST.steady30.HPF_norm2_means(MUdat.residualsCST.steady30.HPF_norm2_means == 0) = NaN;
   MUdat.residualsPLDS.steady30.HPF_means(MUdat.residualsPLDS.steady30.HPF_means == 0) = NaN;
   MUdat.residualsPLDS.steady30.HPF_norm1_means(MUdat.residualsPLDS.steady30.HPF_norm1_means == 0) = NaN;
   MUdat.residualsPLDS.steady30.HPF_norm2_means(MUdat.residualsPLDS.steady30.HPF_norm2_means == 0) = NaN;


end
end