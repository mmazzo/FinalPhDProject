function [F,COHT,pCSI_all,pCSI] = pCSI_COH_diffmuscles(firing1,firing2,LW,fsamp,Iter)

PxxT1 = 0;
PyyT1 = 0;
PxyT1 = 0;
pCSI_all = [];

nums = [floor(size(firing1,1)),floor(size(firing2,1))];

count = min(nums)/2;

if count < 1
    F = NaN;
    COHT = NaN;
    pCSI_all = NaN;
    pCSI = NaN;
else
% Run function
    for k1 = 1:count
        for t = 1:Iter

            group1 = randperm(size(firing1,1));
            group2 = randperm(size(firing2,1));

            group1 = group1(1:k1);
            group2 = group2(1:k1);

            % original dev vecchio approach
            [Pxx,F] = cpsd(detrend(sum(firing1(group1(1:k1),:),1)),detrend(sum(firing1(group1(1:k1),:),1)),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
            [Pyy,F] = cpsd(detrend(sum(firing2(group2(1:k1),:),1)),detrend(sum(firing2(group2(1:k1),:),1)),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
            [Pxy,F] = cpsd(detrend(sum(firing1(group1(1:k1),:),1)),detrend(sum(firing2(group2(1:k1),:),1)),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
            PxxT1 = PxxT1 + Pxx;
            PyyT1 = PyyT1 + Pyy;
            PxyT1 = PxyT1 + Pxy;

            coh = abs(Pxy).^2./(Pxx.*Pyy);    
            coht = abs(PxyT1).^2./(PxxT1.*PyyT1);
            pCSI_all(k1,t) = mean(coht(F>0.1 & F<5)); % using Pxx, Pxy, Pyy + 0
        end
        COHT(k1,:) = abs(PxyT1).^2./(PxxT1.*PyyT1);
        pCSI(k1,:) = mean(COHT(k1,F>0.1 & F<5));
    end
    
end

end
