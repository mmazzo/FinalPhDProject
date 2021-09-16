function [pcadat] = PCAiter(firing,Iter)
% Should have same "shell" as pCSI_COH.m
% Most updated by M.M. - March 2021

count = size(firing,1);

if count < 1
  % vars = []
else
    
    for c = 2:count
        for i = 1:Iter
            % Create random group of motor units
            group = randperm(size(firing,1));
            chosen = group(1:c);
            dat = firing(chosen,:);
            mudat{c}{i} = dat;
            % PCA
            [coeff,scores,lat,~,expl] = pca(dat,'centered',false);
            if isempty(coeff)
            else
                % FCC Variables
                pcadat.coeff_all{c}(i,:) = coeff(:,1)'; % timeseries FCC
                pcadat.scores_all{c}(i,:) = scores(:,1)'; % weight of each obs (MU)
                pcadat.latentvar_all{c}(i) = lat(1); % variance of FCC
                pcadat.expl_all{c}(i) = expl(1); % % of variance explained by FCC
                % Correct opposite orientations for PCs
                if nanmean(pcadat.scores_all{c}(i,:)) < 0 
                    % PREV VER. if there were NaNs in the scores, this if
                    % statement didn't flip the scores & coeffs!
                    pcadat.coeff_all{c}(i,:) = pcadat.coeff_all{c}(i,:)*-1;
                    pcadat.scores_all{c}(i,:) = pcadat.scores_all{c}(i,:)*-1;
                end
            end
        end
        % Take out 0s
        if exist('pcadat','var')
            pcadat.coeff_all{c}(pcadat.coeff_all{c} == 0) = NaN;
            pcadat.expl_all{c}(pcadat.expl_all{c} == 0) = NaN;
            pcadat.latentvar_all{c}(pcadat.latentvar_all{c} == 0) = NaN;
            % Means
            pcadat.coeff_mean(c,:) = nanmean(pcadat.coeff_all{c});
            pcadat.expl_mean(c) = nanmean(pcadat.expl_all{c});
            pcadat.latentvar_mean(c) = nanmean(pcadat.latentvar_all{c});
        else
        end
    end
    
end

if exist('pcadat','var')
else
    pcadat = NaN;
end

end