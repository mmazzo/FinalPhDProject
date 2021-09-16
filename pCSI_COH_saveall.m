function [F,COHT,pCSI_all,pCSI] = pCSI_COH_saveall(firing,LW,fsamp,Iter,windows)
% Most updated by M.M. - Feb 2021

for win = 1:length(windows.starts)
    s = windows.starts(win);
    e = windows.endds(win);

    subset_binary = firing(:,s:e);

    for k = 1:size(subset_binary,1)
        if nansum(subset_binary(k,:)) == 0
            keeps(k) = 0;
        else
            keeps(k) = 1;
        end
    end

    keeps = logical(keeps);
    subset_binary = subset_binary(keeps,:);

    % other vars
    PxxT1 = 0;
    PyyT1 = 0;
    PxyT1 = 0;

    count = (floor(size(firing,1))/2);

    if count < 1
    else

        for numMUs = 1:count
            % for each number of Mus contributin got each CST
            for i = 1:Iter
                % for 100 iterations each
                group = randperm(size(firing,1));
                group1 = group(1:round(end/2));
                group2 = group(round(end/2)+1:end);

                group1 = group1(1:numMUs);
                group2 = group2(1:numMUs);

                % original dev vecchio approach
                [Pxx,F] = cpsd(detrend(sum(firing(group1(1:numMUs),:),1)),detrend(sum(firing(group1(1:numMUs),:),1)),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
                [Pyy,F] = cpsd(detrend(sum(firing(group2(1:numMUs),:),1)),detrend(sum(firing(group2(1:numMUs),:),1)),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
                [Pxy,F] = cpsd(detrend(sum(firing(group1(1:numMUs),:),1)),detrend(sum(firing(group2(1:numMUs),:),1)),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
                PxxT1 = PxxT1 + Pxx;
                PyyT1 = PyyT1 + Pyy;
                PxyT1 = PxyT1 + Pxy;

                cohtemp = abs(Pxy).^2./(Pxx.*Pyy);  
                coh{win}{numMUs,i} = cohtemp;
                pCSI_all{win}(numMUs,i) = mean(cohtemp(F>0.1 & F<5));
                coh_additive{win}{numMUs,i} = abs(PxyT1).^2./(PxxT1.*PyyT1);
                pCSI_additive(numMUs,i) = mean(coh_additive{win}{numMUs,i}(F>0.1 & F<5));
            end

            COHTtemp(numMUs,:) = abs(PxyT1).^2./(PxxT1.*PyyT1);
            COHT{win}(numMUs,:) = COHTtemp(numMUs,:);
            pCSI{win}(numMUs,:) = mean(COHTtemp(numMUs,F>0.1 & F<5));
        end
    end
end
