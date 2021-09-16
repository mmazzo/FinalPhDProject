function [MUdat] = muresidnew(MUdat)  
    if isempty(MUdat)
    else
    % Lag between individual IDRs and CST are corrrected first with xcorr   
        
    % Residuals between CST and original raw IDR lines
    % Residuals between PLDS output and original raw IDR lines

    % Also all normalized TWICE:
        % to same scale of -1 to +1
        % then
        % to have a mean of 0

    % High pass filter signals (better than detrendnonlin
    % polynomial detrending up to 9th order)
     fc = 0.75;   % 1.5 Hz cutoff                                 
     fsamp = 2000;                                  
     [filt2, filt1] = butter(4,fc/fsamp/2,'high');

        for mu = 1:length(MUdat.MUPulses)
            tempflags = cell(1,length(MUdat.MUPulses));
            if isempty(MUdat.MUPulses{1,mu})
                residualsCST.h400.steady30.means(mu,1) = 0;
                residualsCST.h400.steady30.res(mu,:) = zeros(1,60001);
                residualsCST.h400.means(mu,1) = 0;
                residualsCST.h400.res{mu} = [];

                residualsCST.h150.steady30.means(mu,1) = 0;
                residualsCST.h150.steady30.res(mu,:) = zeros(1,60001);
                residualsCST.h150.means(mu,1) = 0;
                residualsCST.h150.res{mu} = [];

                residualsPLDS.steady30.means(mu,1) = 0;
                residualsPLDS.steady30.res(mu,:) = zeros(1,60001);
                residualsPLDS.means(mu,1) = 0;
                residualsPLDS.res{mu} = [];
            else
                % Across steady portion ONLY
                ind1 = MUdat.steady30.start;
                ind2 = MUdat.steady30.endd;
                if 0 < sum(isnan(MUdat.rawlines{1,mu}(ind1:ind2)))
                    residualsCST.h400.steady30.res(mu,:) = repelem(NaN,60001);
                    residualsCST.h150.steady30.res(mu,:) = repelem(NaN,60001);
                    residualsPLDS.steady30.res(mu,:) = repelem(NaN,60001);
                else
                    if isnan(MUdat.cst)
                    else
                    residualsCST.h400.steady30.HPF.rawlines(mu,:) = normalize(normalize(filtfilt(filt2,filt1,MUdat.rawlines{1,mu}(ind1:ind2)),'range', [-1 1]),'center');
                    residualsCST.h400.steady30.HPF.cst = normalize(normalize(filtfilt(filt2,filt1,MUdat.cst(ind1:ind2)),'range', [-1 1]),'center');
                    residualsCST.h400.steady30.res(mu,:) = residualsCST.h400.steady30.HPF.rawlines(mu,:) - residualsCST.h400.steady30.HPF.cst;
                    residualsCST.h400.steady30.means(mu,1) = nanmean(abs(residualsCST.h400.steady30.res(mu,:)));
                    residualsCST.h400.steady30.sums(mu,1) = nansum(abs(residualsCST.h400.steady30.res(mu,:)));

                    residualsCST.h150.steady30.HPF.rawlines(mu,:) = normalize(normalize(filtfilt(filt2,filt1,MUdat.rawlines{1,mu}(ind1:ind2)),'range', [-1 1]),'center');
                    residualsCST.h150.steady30.HPF.cst = normalize(normalize(filtfilt(filt2,filt1,MUdat.cst150(ind1:ind2)),'range', [-1 1]),'center');
                    residualsCST.h150.steady30.res(mu,:) = residualsCST.h150.steady30.HPF.rawlines(mu,:) - residualsCST.h150.steady30.HPF.cst;
                    residualsCST.h150.steady30.means(mu,1) = nanmean(abs(residualsCST.h150.steady30.res(mu,:)));
                    residualsCST.h150.steady30.sums(mu,1) = nansum(abs(residualsCST.h150.steady30.res(mu,:)));

                    residualsPLDS.steady30.HPF.rawlines(mu,:) = normalize(normalize(filtfilt(filt2,filt1,MUdat.rawlines{1,mu}(ind1:ind2)),'range', [-1 1]),'center');
                    residualsPLDS.steady30.HPF.PLDS = normalize(normalize(filtfilt(filt2,filt1,MUdat.PLDS.raw(ind1:ind2)),'range', [-1 1]),'center');
                    residualsPLDS.steady30.res(mu,:) = residualsPLDS.steady30.HPF.rawlines(mu,:) - residualsPLDS.steady30.HPF.PLDS;
                    residualsPLDS.steady30.means(mu,1) = nanmean(abs(residualsPLDS.steady30.res(mu,:)));
                    residualsPLDS.steady30.sums(mu,1) = nansum(abs(residualsPLDS.steady30.res(mu,:)));
                    end
                end
                % Whole time active
                if isnan(MUdat.cst)
                else
                    % Across active portion only
                    ind3 = find(~isnan(MUdat.rawlines{1,mu}),1,'first');
                    ind4 = find(~isnan(MUdat.rawlines{1,mu}),1,'last');
                    tempflags{mu} = MUdat.flags(ind3:ind4);
                        if isnan(MUdat.cst)
                        else
                            residualsCST.h400.HPF.rawlines{mu} = normalize(normalize(filtfilt(filt2, filt1,MUdat.rawlines{1,mu}(ind3:ind4)),'range', [-1 1]),'center');
                            residualsCST.h400.HPF.cst{mu} = normalize(normalize(filtfilt(filt2, filt1,MUdat.cst(ind3:ind4)),'range', [-1 1]),'center');
                            residualsCST.h400.res{mu} =  residualsCST.h400.HPF.rawlines{mu} - residualsCST.h400.HPF.cst{mu};
                            residualsCST.h400.means(mu,1) = nanmean(abs(residualsCST.h400.res{mu}));
                            residualsCST.h400.sums(mu,1) = nansum(abs(residualsCST.h400.res{mu}));

                            residualsCST.h150.HPF.rawlines{mu} = normalize(normalize(filtfilt(filt2, filt1,MUdat.rawlines{1,mu}(ind3:ind4)),'range', [-1 1]),'center');
                            residualsCST.h150.HPF.cst{mu} = normalize(normalize(filtfilt(filt2, filt1,MUdat.cst150(ind3:ind4)),'range', [-1 1]),'center');
                            residualsCST.h150.res{mu} =  residualsCST.h150.HPF.rawlines{mu} - residualsCST.h150.HPF.cst{mu};
                            residualsCST.h150.means(mu,1) = nanmean(abs(residualsCST.h150.res{mu}));
                            residualsCST.h150.sums(mu,1) = nansum(abs(residualsCST.h150.res{mu}));

                            residualsPLDS.HPF.rawlines{mu} = normalize(normalize(filtfilt(filt2, filt1,MUdat.rawlines{1,mu}(ind3:ind4)),'range', [-1 1]),'center');
                            residualsPLDS.HPF.PLDS{mu} = normalize(normalize(filtfilt(filt2, filt1,MUdat.PLDS.raw(ind3:ind4)),'range', [-1 1]),'center');
                            residualsPLDS.res{mu} =  residualsPLDS.HPF.rawlines{mu} - residualsPLDS.HPF.PLDS{mu};
                            residualsPLDS.means(mu,1) = nanmean(abs(residualsPLDS.res{mu}));
                            residualsPLDS.sums(mu,1) = nansum(abs(residualsPLDS.res{mu}));
                        end
                end
            end
        end

        % Remove NaNs
            residualsCST.h400.steady30.means(residualsCST.h400.steady30.means == 0) = NaN; 
            residualsCST.h400.means(residualsCST.h400.means == 0) = NaN;    
            residualsCST.h400.steady30.sums(residualsCST.h400.steady30.sums == 0) = NaN; 
            residualsCST.h400.sums(residualsCST.h400.sums == 0) = NaN; 

            residualsCST.h150.steady30.means(residualsCST.h150.steady30.means == 0) = NaN; 
            residualsCST.h150.means(residualsCST.h150.means == 0) = NaN;    
            residualsCST.h150.steady30.sums(residualsCST.h150.steady30.sums == 0) = NaN; 
            residualsCST.h150.sums(residualsCST.h150.sums == 0) = NaN; 

            residualsPLDS.steady30.means(residualsPLDS.steady30.means == 0) = NaN; 
            residualsPLDS.means(residualsPLDS.means == 0) = NaN;    
            residualsPLDS.steady30.sums(residualsPLDS.steady30.sums == 0) = NaN; 
            residualsPLDS.sums(residualsPLDS.sums == 0) = NaN; 

            % Remove flagged sections before saving:
            steadyflag = MUdat.flags(MUdat.steady30.start:MUdat.steady30.endd);

            for mu = 1:length(residualsCST.h400.steady30.means)
                if isempty(residualsCST.h400.steady30.means(mu,1))
                else
                residualsCST.h400.steady30.means(mu,1) = nanmean(abs(residualsCST.h400.steady30.res(mu,steadyflag == 0)));
                residualsCST.h400.steady30.sums(mu,1) = nansum(abs(residualsCST.h400.steady30.res(mu,steadyflag == 0)));

                residualsCST.h150.steady30.means(mu,1) = nanmean(abs(residualsCST.h150.steady30.res(mu,steadyflag == 0)));
                residualsCST.h150.steady30.sums(mu,1) = nansum(abs(residualsCST.h150.steady30.res(mu,steadyflag == 0)));

                residualsPLDS.steady30.means(mu,1) = nanmean(abs(residualsPLDS.steady30.res(mu,steadyflag == 0)));
                residualsPLDS.steady30.sums(mu,1) = nansum(abs(residualsPLDS.steady30.res(mu,steadyflag == 0)));
                end
            end

            % Whole contraction
            for mu = 1:length(residualsCST.h400.means)
                if isnan(residualsCST.h400.means(mu,1))
                else
                    if isempty(tempflags{mu})
                    else
                    residualsCST.h400.res{mu} = residualsCST.h400.res{mu}(tempflags{mu} == 0); 
                    residualsCST.h400.means(mu,1) = nanmean(abs(residualsCST.h400.res{mu}(tempflags{mu} == 0)));
                    residualsCST.h400.sums(mu,1) = nansum(abs(residualsCST.h400.res{mu}(tempflags{mu} == 0)));

                    residualsCST.h150.res{mu} = residualsCST.h150.res{mu}(tempflags{mu} == 0); 
                    residualsCST.h150.means(mu,1) = nanmean(abs(residualsCST.h150.res{mu}(tempflags{mu} == 0)));
                    residualsCST.h150.sums(mu,1) = nansum(abs(residualsCST.h150.res{mu}(tempflags{mu} == 0)));

                    residualsPLDS.res{mu} = residualsPLDS.res{mu}(tempflags{mu} == 0); 
                    residualsPLDS.means(mu,1) = nanmean(abs(residualsPLDS.res{mu}(tempflags{mu} == 0)));
                    residualsPLDS.sums(mu,1) = nansum(abs(residualsPLDS.res{mu}(tempflags{mu} == 0)));
                    end
                end
            end

            residualsCST.h400.HPF.MUflags = tempflags;
            residualsCST.h150.HPF.MUflags = tempflags;
            residualsPLDS.HPF.MUflags = tempflags;
            MUdat.residualsCST = residualsCST;
            MUdat.residualsPLDS = residualsPLDS;
    end
end