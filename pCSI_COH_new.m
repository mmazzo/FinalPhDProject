function [pCSIdata] = pCSI_COH_new(firing,LW,fsamp,Iter)
% Most updated by M.M. - Feb 2021

PxxT1 = 0;
PyyT1 = 0;
PxyT1 = 0;
pCSI_all = [];

count = floor(size(firing,1)/2);

if count < 1
%     F = NaN;
%     COHT = NaN;
%     pCSI_all = NaN;
%     pCSI = NaN;
else

    for k1 = 1:count
        for t = 1:Iter
    %   ['Pairs = ' num2str(k1) '  Iteration N = ' num2str(t) ]
            group = randperm(size(firing,1));
            group1 = group(1:round(end/2));
            group2 = group(round(end/2)+1:end);

            group1 = group1(1:k1);
            group2 = group2(1:k1);

            % original dev vecchio approach
            [Pxx,F] = cpsd(detrend(sum(firing(group1(1:k1),:),1)),detrend(sum(firing(group1(1:k1),:),1)),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
            [Pyy,F] = cpsd(detrend(sum(firing(group2(1:k1),:),1)),detrend(sum(firing(group2(1:k1),:),1)),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
            [Pxy,F] = cpsd(detrend(sum(firing(group1(1:k1),:),1)),detrend(sum(firing(group2(1:k1),:),1)),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
            PxxT1 = PxxT1 + Pxx; % get added together every iteration?
            PyyT1 = PyyT1 + Pyy;
            PxyT1 = PxyT1 + Pxy;
            Pxx1 = 0 + Pxx; % Just add to 0 to get rid of imaginary numbers
            Pyy1 = 0 + Pyy;
            Pxy1 = 0 + Pxy;

            pCSIdata.coh_raw(t,:) = abs(Pxy).^2./(Pxx.*Pyy); % with imaginaries
            pCSIdata.coh_real(t,:) = abs(Pxy1).^2./(Pxx1.*Pyy1); % without imaginaries
            pCSIdata.coh_add(t,:) = abs(PxyT1).^2./(PxxT1.*PyyT1); % Added iteratively
            
            pCSIdata.pCSI_raw(k1,t) = mean(pCSIdata.coh_raw(F>0.1 & F<5));
            pCSIdata.pCSI_real(k1,t) = mean(pCSIdata.coh_real(F>0.1 & F<5));
            pCSIdata.pCSI_add(k1,t) = mean(pCSIdata.coh_add(F>0.1 & F<5));
        end

        pCSIdata.COH_add(k1,:) = abs(PxyT1).^2./(PxxT1.*PyyT1); % All iterations added together
        pCSIdata.pCSI_add_mean(k1,:) = mean(pCSIdata.COH_add(k1,F>0.1 & F<5)); % Using sum of all iterations
        
        pCSIdata.COH_raw(k1,:) = mean(pCSIdata.coh_raw); % Mean of all iterations
        pCSIdata.pCSI_raw_mean(k1,:) = mean(pCSIdata.COH_raw(k1,F>0.1 & F<5)); % mean value 0-5 Hz
        
        pCSIdata.COH_real(k1,:) = mean(pCSIdata.coh_real); % Mean of all iterations
        pCSIdata.pCSI_real_mean(k1,:) = mean(pCSIdata.COH_real(k1,F>0.1 & F<5)); % mean value 0-5 Hz

    end
end
end
