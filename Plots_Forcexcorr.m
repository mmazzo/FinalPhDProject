%% Force & xcorr plots
histogram(test.MG.w1.cvs,10)

for p = 1:30
plot(test.MG.w1.forces{p})
hold on;
end

%%
for p = 1:30
plot(MUdata.MG.PCA.w1.coeffs{1,p}(:,1))
hold on;
end


%%
for p = 1:30
    scatter(test.MG.w1.sds(p),std(MUdata.MG.PCA.w1.coeffs{1,p}(:,1)),'r'); hold on;
    scatter(test.LG.w1.sds(p),std(MUdata.LG.PCA.w1.coeffs{1,p}(:,1)),'b')
    scatter(test.SOL.w1.sds(p),std(MUdata.SOL.PCA.w1.coeffs{1,p}(:,1)),'g')
end
xlabel('CV for Force - 1 sec Windows')
ylabel('SD for coeff')

%%
histogram(maxcor,10)
%%
w = 1;
yyaxis left
plot(MUdata.MG.CST.w1.cstvecs{w});
yyaxis right
plot(fdat.MG.w1.forces{w});
title(MUdata.MG.CST.w1.fcors.maxcors(w))

yyaxis left
plot(cstvec);
yyaxis right
plot(fvec);

%%
test = conv(MUdata.MG.cst(MUdata.start:MUdata.endd),hanning(800),'same');
yyaxis right
plot(detrend(MUdata.MG.cst(MUdata.start:MUdata.endd)),'r');
yyaxis left
plot(detrend(test),'b');