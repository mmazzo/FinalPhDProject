function [dat,fdat] = nextcalcs(dat,fdat,level)
% dat = PFdata.(day).(level).MUdata.(time)
% fdat = PFdata.stretch.(level).force.(time)
warning('off','all')
muscles = {};
    if isempty(dat.MG)
    else
        muscles = [muscles,{'MG'}];
    end
    if isempty(dat.LG)
    else
        muscles = [muscles,{'LG'}];
    end
    if isempty(dat.SOL)
    else
        muscles = [muscles,{'SOL'}];
    end
% --------- Check FPC direction (flip if necessary) --------------------
    
    dat = flipFPC(dat,muscles); disp('FPCs flipped')
    
% --------- SDs  -------------------------------------------------------

    % Motor unit data

        dat = calcSDs(dat,muscles); disp('SDs calculated')
        
       %%% dat = MUsXC(dat,muscles); disp('MUs cross-correlations calculated for muscles')
        
       %%% dat = MUsXC_allPFs(dat,muscles); disp('MUs cross-correlations calculated for all PFs')
      
% --------- Cross correlations in time domain ------------------------

        if contains(level,'10')
            l = 1;
        else
            l = 2;
        end
        
        [dat,fdat] = PFxcor1(dat,fdat,muscles,l); disp('XCorrs calculated')
        
% --------- Force data (saved into MUdata structure) ------------------

        dat = calcSD_force(dat,fdat,level); disp('SD for Force calculated')
  
      
% --------- Difference between raw & smoothed FPC --------------------
   

% --------- Models by Muscle -----------------------------------------

% for m = 1:length(muscles)
%     mus = muscles{m};
%     % Using data by window
%     dat.(mus) = fitmdls_trial1(dat.(mus));
%     disp(strcat('Models created for',{' '},mus))
% end

% --------- Averages--------------------------------------------------


end