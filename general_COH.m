function [F,COHT] = general_COH(vec1,vec2,LW,fsamp)
% Most updated by M.M. - Feb 2021

PxxT1 = 0;
PyyT1 = 0;
PxyT1 = 0;

% original dev vecchio approach
[Pxx,F] = cpsd(detrend(vec1),detrend(vec1),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
[Pyy,F] = cpsd(detrend(vec2),detrend(vec2),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
[Pxy,F] = cpsd(detrend(vec1),detrend(vec2),hanning(round(LW*fsamp)),0,10*fsamp,fsamp);
PxxT1 = PxxT1 + Pxx;
PyyT1 = PyyT1 + Pyy;
PxyT1 = PxyT1 + Pxy;

COHT = abs(PxyT1).^2./(PxxT1.*PyyT1);
end
