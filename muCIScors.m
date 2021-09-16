function [MUdat] = muCIScors(MUdat)  
if isempty(MUdat)
else
% -------- STEPS -------------------------------------------------------
%   1. Compute new CST with "same" bidirectional filter specified

% ------------- Filters ------------------------------------------------
     fc = 0.75; % Like negro 2009                                 
     fsamp = 2000;                                  
     [filt2, filt1] = butter(4,fc/fsamp/2,'high');

     hann_window = hann(800); 
% -------------  -------------------------------
MUdat.cst_bi = conv(MUdat.cst_unfilt,hann_window,'same');

if isnan(MUdat.cst)
else
    for mu = 1:length(MUdat.rawlines)
    % Across active portion
    ind3 = find(~isnan(MUdat.rawlines{1,mu}),1,'first');
    ind4 = find(~isnan(MUdat.rawlines{1,mu}),1,'last');
    tempflags{mu} = MUdat.flags(ind3:ind4);
    if isempty(ind3) || isempty(ind4)
    else
    % Hanning window smoothed
    SmMU = conv(MUdat.rawlines{1,mu}(ind3:ind4),hann_window,'same');
        MUdat.xcors.whole.SmMU{mu} = SmMU;

    % HPF   
    SmMU_hpf = filtfilt(filt2,filt1,SmMU);
        MUdat.xcors.whole.SmMU_hpf{mu} = SmMU_hpf;
    CST_hpf = filtfilt(filt2,filt1,MUdat.cst_bi(ind3:ind4));
        MUdat.xcors.whole.CST_hpf{mu} = CST_hpf;
    % ------------- Whole time active --------------------------------
        % CST xcorr
        [sigcor,siglag] = xcorr(SmMU_hpf,CST_hpf,'coeff');
            [maxcor,ind] = max(sigcor);
            MUdat.xcors.whole.CSTmaxcors(mu,1) = maxcor;
            MUdat.xcors.whole.CSTlag(mu,1) = siglag(ind);
    
    %  -------- Across steady portion ONLY ---------------------------
    indS = MUdat.steady30.start;
    indE = MUdat.steady30.endd;
    ind1 = indS-ind3;
    if ind1 < 0
        ind1 = 1;
    else
    end
    
    if indE < ind4
        %ind2 = indE;
        ind2 = 60000+ind1;
    else
        %ind2 = ind4;
        ind2 = ind4-ind3;
    end
    
    if ind2 > length(MUdat.xcors.whole.SmMU_hpf{mu})
       ind2 = length(MUdat.xcors.whole.SmMU_hpf{mu});
    else
    end
    
    % Subset between ind 1 and ind 2
    MUdat.xcors.steady30.SmMU_hpf{mu} = MUdat.xcors.whole.SmMU_hpf{mu}(ind1:ind2);
    MUdat.xcors.steady30.CST_hpf{mu} = MUdat.xcors.whole.CST_hpf{mu}(ind1:ind2);

    % Redo xcorrs
        % CST xcorr
        [sigcor,siglag] = xcorr(SmMU_hpf,CST_hpf,'coeff');
            [maxcor,ind] = max(sigcor);
            MUdat.xcors.steady30.CSTmaxcors(mu,1) = maxcor;
            MUdat.xcors.steady30.CSTlag(mu,1) = siglag(ind);
    % ------- TO DO: COMPUTE XCORR WITH OVERLAPPING SEGMENTS ---------
    end
    end
end
% --------- Remove 0s --------------------------------
end
