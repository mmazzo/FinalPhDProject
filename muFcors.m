function [MUdat] = muFcors(MUdat,force)  
if isempty(MUdat)
else

% ------------- Filters ------------------------------------------------
     fc = 0.75;                                 
     fsamp = 2000;                                  
     [filt2, filt1] = butter(4,fc/fsamp/2,'high');

     hann_window = hann(800); 
% -------------  -------------------------------
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
    force_hpf = filtfilt(filt2,filt1,force(ind3:ind4));
        MUdat.xcors.whole.force_hpf{mu} = force_hpf;
    % ------------- Whole time active --------------------------------
        % CST xcorr
        [sigcor,siglag] = xcorr(SmMU_hpf,force_hpf,'coeff');
            [maxcor,ind] = max(sigcor);
            MUdat.xcors.whole.Fmaxcors(mu,1) = maxcor;
            MUdat.xcors.whole.Flag(mu,1) = siglag(ind);
    
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
    MUdat.xcors.steady30.force_hpf{mu} = MUdat.xcors.whole.force_hpf{mu}(ind1:ind2);

    % Redo xcorrs
        % CST xcorr
        [sigcor,siglag] = xcorr(SmMU_hpf,force_hpf,'coeff');
            [maxcor,ind] = max(sigcor);
            MUdat.xcors.steady30.Fmaxcors(mu,1) = maxcor;
            MUdat.xcors.steady30.Flag(mu,1) = siglag(ind);
    % ------- TO DO: COMPUTE XCORR WITH OVERLAPPING SEGMENTS ---------
    end
end
% --------- Remove 0s --------------------------------
end
