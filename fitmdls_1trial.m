function [data] = fitmdls_1trial(data)
% Fit linear regressions between all of the variables of interest
% dat = PFdata...MUdata.(mus)

% Across 1-s and 5-s windowed data:
        %  MUsXC = median cross-correlation between individual MUs and first PC
            %  MUsXCRaw = median cross-correlation between raw individual MUs and derived first PC
            
        %  expl = mean % variance explained by the first PC
            %  explRaw = mean % variance explained by the first PC of raw IDR lines
            
        %  SD_CST = standard deviation of the HPF CST
        
        %  SDisi = median standard deviation for ISI of individual MUs
        
        %  SDfpc = standard deviation of the first PC
                %  SDfpcRaw = standard deviation of the raw first PC

                
                
% ****** WINDOWED PCA *****************************************************


% ------ Smoothed vs raw --------------------------------------------------
        % 1-second Windows ------------------------------------
            % Explained
            for w = 1:30
                if isempty(data.PCA.iter.w1.explained_means{w}) || isempty(data.PCA.iter.raw.w1.explained_means{w})
                elseif data.w1.bad_wins(w) == 1
                else
                expS_w1(w) = data.PCA.iter.w1.explained_means{w}(end);
                expR_w1(w) = data.PCA.iter.raw.w1.explained_means{w}(end);
                end
            end
            expS_w1(expS_w1==0) = NaN;
            expR_w1(expR_w1==0) = NaN;
            data.lms.w1.expl_explRaw = fitlm(expS_w1,expR_w1);
        % Stdev
            data.PCA.iter.w1.fpc_sd(data.PCA.iter.w1.fpc_sd==0) = NaN;
                data.PCA.iter.w1.fpc_sd(data.w1.bad_wins== 1) = NaN;
            data.PCA.iter.raw.w1.fpc_sd(data.PCA.iter.raw.w1.fpc_sd==0) = NaN;
                data.PCA.iter.raw.w1.fpc_sd(data.w1.bad_wins== 1) = NaN;
            data.lms.w1.SDfpc_SDfpcRaw = fitlm(data.PCA.iter.w1.fpc_sd,data.PCA.iter.raw.w1.fpc_sd);
                data.lms.w1.SDfpc_SDfpcRaw(data.w1.bad_wins== 1) = NaN;
            
        % MUsXC
            MUsXCS_w1 = data.PCA.iter.w1.MUsXCsmooth;
            MUsXCR_w1 = data.PCA.iter.w1.MUsXCraw;
            MUsXCS_w1(MUsXCS_w1==0) = NaN; MUsXCS_w1 = nanmedian(MUsXCS_w1,2);
                MUsXCS_w1(data.w1.bad_wins== 1) = NaN;
            MUsXCR_w1(MUsXCR_w1==0) = NaN; MUsXCR_w1 = nanmedian(MUsXCR_w1,2);
                MUsXCS_w1(data.w1.bad_wins== 1) = NaN;
            data.lms.w1.MUsXC_MUsXCRaw = fitlm(MUsXCS_w1,MUsXCR_w1);

      % 5-second Windows ------------------------------------
            % Explained
            for w = 1:6
                if isempty(data.PCA.iter.w5.explained_means{w}) || isempty(data.PCA.iter.raw.w5.explained_means{w})
                elseif data.w5.bad_wins== 1
                else
                expS_w5(w) = data.PCA.iter.w5.explained_means{w}(end);
                expR_w5(w) = data.PCA.iter.raw.w5.explained_means{w}(end);
                end
            end
            expS_w5(expS_w5==0) = NaN;
            expR_w5(expR_w5==0) = NaN;
            data.lms.w5.expl_explRaw = fitlm(expS_w5,expR_w5);
       % Stdev
            data.PCA.iter.w5.fpc_sd(data.PCA.iter.w5.fpc_sd==0) = NaN;
                data.PCA.iter.w5.fpc_sd(data.w5.bad_wins== 1) = NaN;
            data.PCA.iter.raw.w5.fpc_sd(data.PCA.iter.raw.w5.fpc_sd==0) = NaN;
                data.PCA.iter.raw.w5.fpc_sd(data.w5.bad_wins== 1) = NaN;
            data.lms.w5.SDfpc_SDfpcRaw = fitlm(data.PCA.iter.w5.fpc_sd,data.PCA.iter.raw.w5.fpc_sd);
                data.lms.w5.SDfpc_SDfpcRaw(data.w5.bad_wins== 1) = NaN;
            
        % MUsXC
            MUsXCS_w5 = data.PCA.iter.w5.MUsXCsmooth;
            MUsXCR_w5 = data.PCA.iter.w5.MUsXCraw;
            MUsXCS_w5(MUsXCS_w5==0) = NaN; MUsXCS_w5 = nanmedian(MUsXCS_w5,2);
                   MUsXCS_w5(data.w5.bad_wins== 1) = NaN;
            MUsXCR_w5(MUsXCR_w5==0) = NaN; MUsXCR_w5 = nanmedian(MUsXCR_w5,2);
                   MUsXCS_w5(data.w5.bad_wins== 1) = NaN;
            data.lms.w5.MUsXC_MUsXCRaw = fitlm(MUsXCS_w5,MUsXCR_w5);

% ------------- Explained, MUsXC, and SD for FPC ---------------------------------------------
    % MUsXC vs Explained
        data.lms.w1.MUsXC_expl = fitlm(MUsXCS_w1,expS_w1); % smooth
        data.lms.w1.MUsXCRaw_explRaw = fitlm(MUsXCR_w1,expR_w1); % raw
    % MUsXC vs SD for FPC     
        data.lms.w1.MUsXC_SDfpc = fitlm(MUsXCS_w1,data.PCA.iter.w1.fpc_sd);
        data.lms.w1.MUsXCRaw_SDfpcRaw = fitlm(MUsXCR_w1,data.PCA.iter.raw.w1.fpc_sd);
    % Explained vs SD for FPC
        data.lms.w1.expl_SDfpc = fitlm(expS_w1,data.PCA.iter.w1.fpc_sd);
        data.lms.w1.explRaw_SDfpcRaw = fitlm(expR_w1,data.PCA.iter.raw.w1.fpc_sd);
        
% ------------- Median values for SD for ISI, Smooth & Raw IDR Lines --------------------------  
    SDisi_w1 = nanmedian(data.w1.SDisi);        SDisi_w1(SDisi_w1==0) = NaN;        SDisi_w1(data.w1.bad_wins== 1) = NaN;
    SDisi_w5 = nanmedian(data.w5.SDisi);        SDisi_w5(SDisi_w5==0) = NaN;        SDisi_w5(data.w5.bad_wins== 1) = NaN;
    SDidrsS_w1 = nanmedian(data.w1.SDidrs);     SDidrsS_w1(SDidrsS_w1==0) = NaN;    SDidrsS_w1(data.w1.bad_wins== 1) = NaN;
    SDidrsR_w1 = nanmedian(data.w1.SDidrsRaw);  SDidrsR_w1(SDidrsR_w1==0) = NaN;    SDidrsR_w1(data.w1.bad_wins== 1) = NaN;
    SDidrsS_w5 = nanmedian(data.w5.SDidrs);     SDidrsS_w5(SDidrsS_w5==0) = NaN;    SDidrsS_w5(data.w5.bad_wins== 1) = NaN;
    SDidrsR_w5 = nanmedian(data.w5.SDidrsRaw);  SDidrsR_w5(SDidrsR_w5==0) = NaN;    SDidrsR_w5(data.w5.bad_wins== 1) = NaN;
    
    % Explained vs median SD for ISI           
        data.w1.lms.expl_SDisi = fitlm(expS_w1,SDisi_w1);
        data.w1.lms.explRaw_SDisi = fitlm(expR_w1,SDisi_w1);
    % Explained vs median SD for IDRs          
        data.w1.lms.expl_SDidrs = fitlm(expS_w1,SDidrsS_w1);
        data.w1.lms.explRaw_SDidrsRaw = fitlm(expR_w1,SDidrsR_w1);        
    % Median SD for ISI   vs median SD for IDRs  
        data.w1.lms.SDisi_SDidrs = fitlm(SDisi_w1,SDidrsS_w1);
        data.w1.lms.SDisi_SDidrsRaw = fitlm(SDisi_w1,SDidrsR_w1);     
            
            
            
% ****** CONTINUOUS PCA *****************************************************




end


