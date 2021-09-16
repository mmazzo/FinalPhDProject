function [F,COHT,pCSI_all,pCSI] = pCSI_COH(firing,LW,fsamp,Iter)
% Most updated by M.M. - Feb 2021

PxxT1 = 0;
PyyT1 = 0;
PxyT1 = 0;
pCSI_all = [];

count = (floor(size(firing,1))/2);

if count < 1
    F = NaN;
    COHT = NaN;
    pCSI_all = NaN;
    pCSI = NaN;
else

    for mu = 1:count % for each number of MUs inclused in the CSTs
        for i = 1:Iter
            
            group = randperm(size(firing,1));
            group1 = group(1:round(end/2));
            group2 = group(round(end/2)+1:end);

            group1 = group1(1:mu);
            group2 = group2(1:mu);

            % original dev vecchio approach
            [Pxx,F] = cpsd(detrend(sum(firing(group1(1:mu),:),1)),detrend(sum(firing(group1(1:mu),:),1)),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
            [Pyy,F] = cpsd(detrend(sum(firing(group2(1:mu),:),1)),detrend(sum(firing(group2(1:mu),:),1)),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
            [Pxy,F] = cpsd(detrend(sum(firing(group1(1:mu),:),1)),detrend(sum(firing(group2(1:mu),:),1)),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
            
            PxxT1 = PxxT1 + Pxx;
            PyyT1 = PyyT1 + Pyy;
            PxyT1 = PxyT1 + Pxy;
            
            coh = abs(Pxy).^2./(Pxx.*Pyy);  
            pCSI_all(mu,i) = mean(coh(F>0.1 & F<5));
            
            coht = abs(PxyT1).^2./(PxxT1.*PyyT1);
            pCSI_all_t(mu,i) = mean(coht(F>0.1 & F<5));
        end

        COHT(mu,:) = abs(PxyT1).^2./(PxxT1.*PyyT1);
        pCSI(mu,:) = mean(COHT(mu,F>0.1 & F<5));

    end
end
end
