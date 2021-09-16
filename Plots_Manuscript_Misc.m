% Miscellaneous Plots to go with Exploring_CSTvPLDS_residuals.m

%% PLDS for 10 mus
figure(1)
tiledlayout(10,1,'TileSpacing','none','Padding','none')
for p = 1:10
    nexttile
    plot(submax10.before.MUdata.MG.HPF.IDRs_hpf_norm2{p},'-'); 
    hold on;
    plot(submax10.before.MUdata.MG.HPF.PLDS_hpf_norm{p});
    ax = gca;
    %ylim([-10 10]);
    set(ax,'XTick',[]);
end
%% CST for 10 Mus
figure(2)
tiledlayout(10,1,'TileSpacing','none','Padding','none')
for p = 1:10
    nexttile
    plot(submax10.before.MUdata.MG.HPF.IDRs_hpf_norm2{p},'-','color','blue'); 
    hold on;
    plot(submax10.before.MUdata.MG.HPF.CST_hpf_norm2{p});
    %ylim([-10 10]);
    ax = gca;
    set(ax,'XTick',[]);
end


%% Showing example MUs
tiledlayout(2,1)
    nexttile
    plot(normalize(submax10.before.MUdata.MG.residualsPLDS.steady30.HPF.rawlines(5,:),'center'),'-'); hold on;
    plot(normalize(submax10.before.MUdata.MG.residualsPLDS.steady30.HPF.PLDS,'center'));

    nexttile
    plot(submax10.before.MUdata.MG.residualsPLDS.steady30.res(5,:),'-','color','b'); hold on;

%%
plot(detrendnonlin(MUdat.rawlines{1,mu}(ind3:ind4),9),'-','color','r'); hold on;
plot(detrendnonlin(MUdat.cst(ind3:ind4),9),'-','color','g');

%% 
tiledlayout(2,1)
nexttile
plot(normalize(pre.MUdata.MG.residuals.steady30.res(2,:)))
nexttile
%%
yyaxis left
plot(submax10.before.MUdata.MG.residualsPLDS.steady30.res(2,:))
yyaxis right
plot(submax10.before.MUdata.MG.residualsCST.h400.steady30.res(2,:))

%plot(normalize(pre.MUdata.MG.residuals.steady30.HPF.cst))

%% Residuals vs RTs
    scatter(submax10.before.MUdata.MG.residualsCST.steady30.HPF_norm1_means,cell2mat(submax10.before.MUdata.MG.RTs.force(1:22,1))); hold on;
         %coef1 = polyfit(submax10.before.MUdata.MG.residualsCST.steady30.HPF_norm1_means,cell2mat(submax10.before.MUdata.MG.RTs.force(1:22,1)), 1);
          %  h1 = refline(coef1(1), coef1(2));
    scatter(submax10.before.MUdata.MG.residualsPLDS.steady30.HPF_norm1_means,cell2mat(submax10.before.MUdata.MG.RTs.force(1:22,1)),'r')
           % coef3 = polyfit(submax10.before.MUdata.MG.residualsPLDS.steady30.HPF_norm1_means,cell2mat(submax10.before.MUdata.MG.RTs.force(1:22,1)), 1);
            %h3 = refline(coef3(1), coef3(2));
            %h3.Color = 'r';
    legend('CST','PLDS')
    %ylim([0 0.2]);
    xlabel('Residuals Mean');
    ylabel('Recruitment Threshold');
    
%% Residuals vs Mean DR
    scatter(submax10.before.MUdata.MG.residualsCST.h150.means,submax10.before.MUdata.MG.Mean_DR); hold on;
    scatter(submax10.before.MUdata.MG.residualsCST.h400.means,submax10.before.MUdata.MG.Mean_DR,'g');
    scatter(submax10.before.MUdata.MG.residualsPLDS.means,submax10.before.MUdata.MG.Mean_DR,'r')
    legend('CST h150','CST h400','PLDS')
    %ylim([0 0.2]);
    xlabel('Residuals Mean');
    ylabel('Mean DR');
    
%% Residuals vs CV ISI
    scatter(submax10.before.MUdata.MG.residualsCST.h150.means,submax10.before.MUdata.MG.CV_ISI); hold on;
    scatter(submax10.before.MUdata.MG.residualsCST.h400.means,submax10.before.MUdata.MG.CV_ISI,'g');
    scatter(submax10.before.MUdata.MG.residualsPLDS.means,submax10.before.MUdata.MG.CV_ISI,'r')
    legend('CST h150','CST h400','PLDS')
    %ylim([0 0.2]);
    xlabel('Residuals Mean');
    ylabel('CV ISI');
    
%% RTs vs CV ISI
    scatter(cell2mat(submax10.before.MUdata.MG.RTs.force),submax10.before.MUdata.MG.CV_ISI); hold on;
    scatter(cell2mat(submax10.before.MUdata.LG.RTs.force),submax10.before.MUdata.LG.CV_ISI,'g');
    scatter(cell2mat(submax10.before.MUdata.SOL.RTs.force),submax10.before.MUdata.SOL.CV_ISI,'r')
    legend('MG','LG','SOL')
    %ylim([0 0.2]);
    xlabel('RTS');
    ylabel('CV ISI');
  %%  
    scatter(cell2mat(submax35.before.MUdata.MG.RTs.force),submax35.before.MUdata.MG.CV_ISI); hold on;
    scatter(cell2mat(submax35.before.MUdata.LG.RTs.force),submax35.before.MUdata.LG.CV_ISI,'g');
    scatter(cell2mat(submax35.before.MUdata.SOL.RTs.force),submax35.before.MUdata.SOL.CV_ISI,'r')
    legend('MG','LG','SOL')
    %ylim([0 0.2]);
    xlabel('RTS');
    ylabel('CV ISI');
    
    %%
    tiledlayout(2,1)
    nexttile
    scatter(submax10.before.MUdata.MG.HPF.times{1},submax10.before.MUdata.MG.HPF.IDRs_hpf_norm2{1})
    hold on;
    scatter(submax10.before.MUdata.MG.HPF.times{1},submax10.before.MUdata.MG.HPF.CST_hpf_norm2{1})
    nexttile
    plot(submax10.before.MUdata.MG.HPF.times{1},submax10.before.MUdata.MG.residualsCST.HPF_norm2{1})