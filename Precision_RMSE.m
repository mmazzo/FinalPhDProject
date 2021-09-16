% Precision (rms error)
% of iterations for a certain # MUs within 1 window
for w = 1:30
    nMUs(w) = length(PFdata.stretch.submax35.MUdata.before.MG.PCA.iter.w1.explained{1,w})-1;
    
    % PCA
        PCA_dat = PFdata.stretch.submax35.MUdata.before.MG.PCA.iter.w1.explained{1,w}{1,nMUs(w)}/100; 
        % divide by 100 to maych with 0-1 scale of coherence values (pCSI)
        PCA_ctr = mean(PFdata.stretch.submax35.MUdata.before.MG.PCA.iter.w1.explained{1,w}{1,nMUs(w)}/100);
        PCA_diffs = (PCA_dat-PCA_ctr);

        % Root-mean squared error
        PCA_RMSE(w) = sqrt(mean(PCA_diffs.^2)); % or = rms(PCA_diffs);
end

    % pCSI - no separate windows
        nMUshalf = floor(max(nMUs)/2);
        pCSI_dat = PFdata.stretch.submax35.MUdata.before.MG.pCSI.w1.pCSI_all(nMUshalf,:);
        pCSI_ctr = mean(PFdata.stretch.submax35.MUdata.before.MG.pCSI.w1.pCSI_all(nMUshalf,:));
        pCSI_diffs = (pCSI_dat-pCSI_ctr);

        % Root-mean squared error
        pCSI_RMSE = sqrt(mean(pCSI_diffs.^2)); % or = rms(pCSI_diffs);