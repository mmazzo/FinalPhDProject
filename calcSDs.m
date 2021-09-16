function [MUdata] = calcSDs(MUdata,muscles)
% Calculate SD of FPCs, CST and individual IDR lines
% High-pass filter CST ands force first
warning('off','all')
% --------- Individual Muscles -----------------------------------------
for m = 1:length(muscles)
    mus = muscles{m};
    % WINDOWED FPC
        MUdata.(mus).PCA.iter.w1.mergedfpc = [];
        MUdata.(mus).PCA.iter.w5.mergedfpc = [];
        
        % fpc from 1-s windows
            for w = 1:30
                % Index of bad windows:
                if isfield(MUdata.(mus).PCA.iter.w1,'coeff_mean')
                    if length(MUdata.(mus).PCA.iter.w1.coeff_mean) ==1
                    elseif length(MUdata.(mus).PCA.iter.w1.coeff_mean) < w || isempty(MUdata.(mus).PCA.iter.w1.coeff_mean{w})
                        MUdata.(mus).w1.bad_wins(w) = 1; % 1 = bad
                        MUdata.(mus).PCA.iter.w1.mergedfpc = horzcat(MUdata.(mus).PCA.iter.w1.mergedfpc,repelem(0,2000));
                    else
                        MUdata.(mus).w1.bad_wins(w) = 0; % 0 = good
                        MUdata.(mus).PCA.iter.w1.fpc_sd(w) = std(MUdata.(mus).PCA.iter.w1.coeff_mean{w});
                        MUdata.(mus).PCA.iter.w1.fpc_mean(w) = mean(MUdata.(mus).PCA.iter.w1.coeff_mean{w});
                        MUdata.(mus).PCA.iter.w1.fpc_cv(w) = (MUdata.(mus).PCA.iter.w1.fpc_sd(w)/MUdata.(mus).PCA.iter.w1.fpc_mean(w))*100;
                        MUdata.(mus).PCA.iter.w1.mergedfpc = horzcat(MUdata.(mus).PCA.iter.w1.mergedfpc,MUdata.(mus).PCA.iter.w1.coeff_mean{w});
                    end
                else
                end
            end
         % smoothed version (200 ms hanning window)
         if isempty(MUdata.(mus).PCA.iter.w1.mergedfpc)
         else
           MUdata.(mus).PCA.iter.w1.mergedfpc_smooth = conv(MUdata.(mus).PCA.iter.w1.mergedfpc,hann(400),'same');
         end
        % fpc from 5-s windows
        for w = 1:6
                % Index of bad windows:
                if isfield(MUdata.(mus).PCA.iter.w5,'coeff_mean')
                    if length(MUdata.(mus).PCA.iter.w5.coeff_mean) ==1
                    elseif length(MUdata.(mus).PCA.iter.w5.coeff_mean) < w || isempty(MUdata.(mus).PCA.iter.w5.coeff_mean{w})
                        MUdata.(mus).w5.bad_wins(w) = 1; % 1 = bad
                        MUdata.(mus).PCA.iter.w5.mergedfpc = horzcat(MUdata.(mus).PCA.iter.w5.mergedfpc,repelem(0,10000));
                    else
                        MUdata.(mus).w5.bad_wins(w) = 0; % 0 = good
                        MUdata.(mus).PCA.iter.w5.fpc_sd(w) = std(MUdata.(mus).PCA.iter.w5.coeff_mean{w});
                        MUdata.(mus).PCA.iter.w5.fpc_mean(w) = mean(MUdata.(mus).PCA.iter.w5.coeff_mean{w});
                        MUdata.(mus).PCA.iter.w5.fpc_cv(w) = (MUdata.(mus).PCA.iter.w5.fpc_sd(w)/MUdata.(mus).PCA.iter.w5.fpc_mean(w))*100;
                        MUdata.(mus).PCA.iter.w5.mergedfpc = horzcat(MUdata.(mus).PCA.iter.w5.mergedfpc,MUdata.(mus).PCA.iter.w5.coeff_mean{w});
                    end
                else
                end
        end     
        % smoothed version
       if isempty(MUdata.(mus).PCA.iter.w5.mergedfpc)
         else
           MUdata.(mus).PCA.iter.w5.mergedfpc_smooth = conv(MUdata.(mus).PCA.iter.w5.mergedfpc,hann(400),'same');
       end
%     % FULL 30 s CONTINUOUS FPC
%         % fpc whole 30s broken up (1-s windows)
%             for w = 1:30
%                 s = MUdata.w1.starts(w)-MUdata.start+1;
%                 e = MUdata.w1.endds(w)-MUdata.start+1;
%                 fpc = MUdata.(mus).PCA.iter.w30.coeffs_mean(end,:); % the FPC using most # MUs available
%                 fpcsec = fpc(s:e);
%                 MUdata.(mus).PCA.iter.w30.w1.fpc_secs{w} = fpcsec;
%                 MUdata.(mus).PCA.iter.w30.w1.fpc_sd(w) = std(fpcsec);
%                 MUdata.(mus).PCA.iter.w30.w1.fpc_mean(w) = mean(fpcsec);
%                 MUdata.(mus).PCA.iter.w30.w1.fpc_cv(w) = (std(fpcsec)/mean(fpcsec))*100;
%             end
% 
%          % fpc whole 30s broken up (5-s windows)
%             for w = 1:6
%                 s = MUdata.w5.starts(w)-MUdata.start+1;
%                 e = MUdata.w5.endds(w)-MUdata.start+1;
%                 fpc = MUdata.(mus).PCA.iter.w30.coeffs_mean(end,:); % the FPC using most # MUs available
%                 fpcsec = fpc(s:e);
%                 MUdata.(mus).PCA.iter.w30.w5.fpc_secs{w} = fpcsec;
%                 MUdata.(mus).PCA.iter.w30.w5.fpc_sd(w) = std(fpcsec);
%                 MUdata.(mus).PCA.iter.w30.w5.fpc_mean(w) = mean(fpcsec);
%                 MUdata.(mus).PCA.iter.w30.w5.fpc_cv(w) = (std(fpcsec)/mean(fpcsec))*100;
%             end
            
    % -------- RAW FPC ---------------------------------------------------
    
        % WINDOWED FPC
        MUdata.(mus).PCA.iter.raw.w1.mergedfpc = [];
        MUdata.(mus).PCA.iter.raw.w5.mergedfpc = [];
        % fpc from 1-s windows
            for w = 1:30
                % Index of bad windows:
                if isfield(MUdata.(mus).PCA.iter.raw.w1,'coeff_mean')
                    if length(MUdata.(mus).PCA.iter.raw.w1.coeff_mean)==1
                    elseif length(MUdata.(mus).PCA.iter.raw.w1.coeff_mean) < w || isempty(MUdata.(mus).PCA.iter.raw.w1.coeff_mean{w})
                        MUdata.(mus).w1.bad_wins(w) = 1; % 1 = bad
                        MUdata.(mus).PCA.iter.raw.w1.mergedfpc = horzcat(MUdata.(mus).PCA.iter.raw.w1.mergedfpc,repelem(0,2000));
                    else
                        MUdata.(mus).w1.bad_wins(w) = 0; % 0 = good
                        MUdata.(mus).PCA.iter.raw.w1.fpc_sd(w) = std(MUdata.(mus).PCA.iter.raw.w1.coeff_mean{w});
                        MUdata.(mus).PCA.iter.raw.w1.fpc_mean(w) = mean(MUdata.(mus).PCA.iter.raw.w1.coeff_mean{w});
                        MUdata.(mus).PCA.iter.raw.w1.fpc_cv(w) = (MUdata.(mus).PCA.iter.raw.w1.fpc_sd(w)/MUdata.(mus).PCA.iter.raw.w1.fpc_mean(w))*100;
                        MUdata.(mus).PCA.iter.raw.w1.mergedfpc = horzcat(MUdata.(mus).PCA.iter.raw.w1.mergedfpc,MUdata.(mus).PCA.iter.raw.w1.coeff_mean{w});
                    end
                else
                end
            end
       % smoothed version
       if isempty(MUdata.(mus).PCA.iter.raw.w1.mergedfpc)
         else
           MUdata.(mus).PCA.iter.raw.w1.mergedfpc_smooth = conv(MUdata.(mus).PCA.iter.raw.w1.mergedfpc,hann(200),'same');
       end
        % fpc from 5-s windows
        if isfield(MUdata.(mus).PCA.iter.raw.w5,'coeff_mean')
            for w = 1:6
                % Index of bad windows:
                if length(MUdata.(mus).PCA.iter.raw.w5.coeff_mean)==1
                elseif length(MUdata.(mus).PCA.iter.raw.w5.coeff_mean) < w || isempty(MUdata.(mus).PCA.iter.raw.w5.coeff_mean{w})
                    MUdata.(mus).w5.bad_wins(w) = 1; % 1 = bad
                    MUdata.(mus).PCA.iter.raw.w5.mergedfpc = horzcat(MUdata.(mus).PCA.iter.raw.w5.mergedfpc,repelem(0,10000));
                else
                    MUdata.(mus).w5.bad_wins(w) = 0; % 0 = good
                    MUdata.(mus).PCA.iter.raw.w5.fpc_sd(w) = std(MUdata.(mus).PCA.iter.raw.w5.coeff_mean{w});
                    MUdata.(mus).PCA.iter.raw.w5.fpc_mean(w) = mean(MUdata.(mus).PCA.iter.raw.w5.coeff_mean{w});
                    MUdata.(mus).PCA.iter.raw.w5.fpc_cv(w) = (MUdata.(mus).PCA.iter.raw.w5.fpc_sd(w)/MUdata.(mus).PCA.iter.raw.w5.fpc_mean(w))*100;
                    MUdata.(mus).PCA.iter.raw.w5.mergedfpc = horzcat(MUdata.(mus).PCA.iter.raw.w5.mergedfpc,MUdata.(mus).PCA.iter.raw.w5.coeff_mean{w});
                end
            end 
        else
        end
        % smoothed version
        if isempty(MUdata.(mus).PCA.iter.raw.w5.mergedfpc)
         else
           MUdata.(mus).PCA.iter.raw.w5.mergedfpc_smooth = conv(MUdata.(mus).PCA.iter.raw.w5.mergedfpc,hann(200),'same');
        end
%     % FULL 30 s CONTINUOUS FPC
%         % fpc whole 30s broken up (1-s windows)
%             for w = 1:30
%                 s = MUdata.w1.starts(w)-MUdata.start+1;
%                 e = MUdata.w1.endds(w)-MUdata.start+1;
%                 fpc = MUdata.(mus).PCA.iter.raw.w30.coeffs_mean(end,:); % the FPC using most # MUs available
%                 fpcsec = fpc(s:e);
%                 MUdata.(mus).PCA.iter.raw.w30.w1.fpc_secs{w} = fpcsec;
%                 MUdata.(mus).PCA.iter.raw.w30.w1.fpc_sd(w) = std(fpcsec);
%                 MUdata.(mus).PCA.iter.raw.w30.w1.fpc_mean(w) = mean(fpcsec);
%                 MUdata.(mus).PCA.iter.raw.w30.w1.fpc_cv(w) = (std(fpcsec)/mean(fpcsec))*100;
%             end
% 
%          % fpc whole 30s broken up (5-s windows)
%             for w = 1:6
%                 s = MUdata.w5.starts(w)-MUdata.start+1;
%                 e = MUdata.w5.endds(w)-MUdata.start+1;
%                 fpc = MUdata.(mus).PCA.iter.raw.w30.coeffs_mean(end,:); % the FPC using most # MUs available
%                 fpcsec = fpc(s:e);
%                 MUdata.(mus).PCA.iter.raw.w30.w5.fpc_secs{w} = fpcsec;
%                 MUdata.(mus).PCA.iter.raw.w30.w5.sd(w) = std(fpcsec);
%                 MUdata.(mus).PCA.iter.raw.w30.w5.fpc_mean(w) = mean(fpcsec);
%                 MUdata.(mus).PCA.iter.raw.w30.w5.fpc_cv(w) = (std(fpcsec)/mean(fpcsec))*100;
%             end
               
            
     % -------- CST sections - High pass filtered! -----------------------
     if length(MUdata.(mus).cst) == 1
     else
            ss = MUdata.(mus).steady30.start;
            se = MUdata.(mus).steady30.endd;
            %cstS = highpass(MUdata.(mus).cst(ss:se),0.75,2000);
            cst = highpass(MUdata.(mus).cst,0.75,2000);
            cstorig = MUdata.(mus).cst;
            for w = 1:30 % 1-s windows
                s = MUdata.w1.starts(w);
                e = MUdata.w1.endds(w);
                MUdata.(mus).w1.cst_sd(w) = std(cst(s:e)); % HPF CST!
                MUdata.(mus).w1.cst_mean(w) = mean(cstorig(s:e)); % ORIG CST!
                MUdata.(mus).w1.cst_cv(w) = (std(cstorig(s:e))/mean(cstorig(s:e)))*100; % ORIG!
                MUdata.(mus).w1.cst_secs{w} = cst(s:e); % HPC CST!
            end
            
            for w = 1:6 % 5-s windows
                s = MUdata.w5.starts(w);
                e = MUdata.w5.endds(w);
                MUdata.(mus).w5.cst_sd(w) = std(cst(s:e)); % HPF CST!
                MUdata.(mus).w5.cst_mean(w) = mean(cstorig(s:e)); % ORIG CST!
                MUdata.(mus).w5.cst_cv(w) = (std(cstorig(s:e))/mean(cstorig(s:e)))*100; % ORIG!
                MUdata.(mus).w5.cst_secs{w} = cst(s:e); % HPF CST!
            end
     end
     
        % IDRs & ISIs
        idrfilts = []; idrsRaw = [];
        for mu = 1:length(MUdata.(mus).rawlines)
            len = length(MUdata.(mus).binary);
            isivec = MUdata.(mus).binary_ISI;
            isivec(isivec == 0) = NaN;
            if isempty(MUdata.(mus).rawlines{mu})
            elseif isnan(MUdata.(mus).rawlines{mu})
            else
                temp = MUdata.(mus).rawlines{mu};
                start = find(~isnan(temp),1,'first');
                endd = find(~isnan(temp),1,'last');
                temp = temp(start:endd);
                tempR = highpass(temp,0.75,2000);
                temp = conv(temp,hann(800),'same');
                temp = highpass(temp,0.75,2000);
                nans1 = repelem(NaN,start-1);
                nans2 = repelem(NaN,(len-endd));
                idrfilts(mu,:) = horzcat(nans1,temp,nans2);
                idrsRaw(mu,:) = horzcat(nans1,tempR,nans2);
                for w = 1:30
                    s = MUdata.w1.starts(w);
                    e = MUdata.w1.endds(w);
                    MUdata.(mus).w1.SDidrs(mu,w) = nanstd(idrfilts(mu,s:e));
                    MUdata.(mus).w1.SDidrsRaw(mu,w) = nanstd(idrsRaw(mu,s:e));
                    temp3 = isivec(mu,s:e);
                    MUdata.(mus).w1.SDisi(mu,w) = nanstd(temp3);
                end
                for w = 1:6
                    s = MUdata.w5.starts(w);
                    e = MUdata.w5.endds(w);
                    MUdata.(mus).w5.SDidrs(mu,w) = nanstd(idrfilts(mu,s:e));
                    MUdata.(mus).w5.SDidrsRaw(mu,w) = nanstd(idrsRaw(mu,s:e));
                    temp3 = isivec(mu,s:e);
                    MUdata.(mus).w5.SDisi(mu,w) = nanstd(temp3);
                end
            end
        end
        if ~isfield(MUdata.(mus),'w1')
            MUdata.(mus).w1 = [];
        elseif ~isfield(MUdata.(mus).w1,'SDidrs')
        else
        MUdata.(mus).w1.SDidrs(MUdata.(mus).w1.SDidrs == 0) = NaN;
        MUdata.(mus).w1.SDidrsRaw(MUdata.(mus).w1.SDidrsRaw == 0) = NaN;
        MUdata.(mus).w1.SDisi(MUdata.(mus).w1.SDisi == 0) = NaN;
        end
        if ~isfield(MUdata.(mus),'w5')
            MUdata.(mus).w5 = [];
        elseif ~isfield(MUdata.(mus).w5,'SDidrs')
        else
        MUdata.(mus).w5.SDisi(MUdata.(mus).w5.SDisi == 0) = NaN;
        MUdata.(mus).w5.SDidrsRaw(MUdata.(mus).w5.SDidrsRaw == 0) = NaN;
        MUdata.(mus).w5.SDidrs(MUdata.(mus).w5.SDidrs == 0) = NaN;
        end
end


% ----------------- All PFs --------------------------
    % WINDOWED FPC
        MUdata.PCA.iter.w1.mergedfpc = [];
        MUdata.PCA.iter.w5.mergedfpc = [];
        % fpc from 1-s windows
            for w = 1:30
                % Index of bad windows:
                if length(MUdata.PCA.iter.w1.coeff_mean)==1
                elseif length(MUdata.PCA.iter.w1.coeff_mean) < w || isempty(MUdata.PCA.iter.w1.coeff_mean{w})
                    MUdata.w1.bad_wins(w) = 1; % 1 = bad
                    MUdata.PCA.iter.w1.mergedfpc = horzcat(MUdata.PCA.iter.w1.mergedfpc,repelem(0,2000));
                else
                    MUdata.w1.bad_wins(w) = 0; % 0 = good
                    MUdata.PCA.iter.w1.fpc_sd(w) = std(MUdata.PCA.iter.w1.coeff_mean{w});
                    MUdata.PCA.iter.w1.fpc_mean(w) = mean(MUdata.PCA.iter.w1.coeff_mean{w});
                    MUdata.PCA.iter.w1.fpc_cv(w) = (MUdata.PCA.iter.w1.fpc_sd(w)/MUdata.PCA.iter.w1.fpc_mean(w))*100;
                    MUdata.PCA.iter.w1.mergedfpc = horzcat(MUdata.PCA.iter.w1.mergedfpc,MUdata.PCA.iter.w1.coeff_mean{w});
                end
            end
       % smoothed version
       if isempty(MUdata.PCA.iter.w1.mergedfpc)
       else
       MUdata.PCA.iter.w1.mergedfpc_smooth = conv(MUdata.PCA.iter.w1.mergedfpc,hann(400),'same');
       end
        % fpc from 5-s windows
        for w = 1:6
                % Index of bad windows:
                if length(MUdata.PCA.iter.w5.coeff_mean)==1
                elseif length(MUdata.PCA.iter.w5.coeff_mean) < w || isempty(MUdata.PCA.iter.w5.coeff_mean{w})
                    MUdata.w5.bad_wins(w) = 1; % 1 = bad
                    MUdata.PCA.iter.w5.mergedfpc = horzcat(MUdata.PCA.iter.w5.mergedfpc,repelem(0,10000));
                else
                    MUdata.w5.bad_wins(w) = 0; % 0 = good
                    MUdata.PCA.iter.w5.fpc_sd(w) = std(MUdata.PCA.iter.w5.coeff_mean{w});
                    MUdata.PCA.iter.w5.fpc_mean(w) = mean(MUdata.PCA.iter.w5.coeff_mean{w});
                    MUdata.PCA.iter.w5.fpc_cv(w) = (MUdata.PCA.iter.w5.fpc_sd(w)/MUdata.PCA.iter.w5.fpc_mean(w))*100;
                    MUdata.PCA.iter.w5.mergedfpc = horzcat(MUdata.PCA.iter.w5.mergedfpc,MUdata.PCA.iter.w5.coeff_mean{w});
                end
        end  
       % smoothed version
       if isempty(MUdata.PCA.iter.w5.mergedfpc)
       else
           MUdata.PCA.iter.w5.mergedfpc_smooth = conv(MUdata.PCA.iter.w5.mergedfpc,hann(400),'same');
       end
%     % FULL 30 s CONTINUOUS FPC
%         % fpc whole 30s broken up (1-s windows)
%             for w = 1:30
%                 s = MUdata.w1.starts(w)-MUdata.start+1;
%                 e = MUdata.w1.endds(w)-MUdata.start+1;
%                 fpc = MUdata.PCA.iter.w30.coeffs_mean(end,:); % the FPC using most # MUs available
%                 fpcsec = fpc(s:e);
%                 MUdata.PCA.iter.w30.w1.fpc_secs{w} = fpcsec;
%                 MUdata.PCA.iter.w30.w1.fpc_sd(w) = std(fpcsec);
%                 MUdata.PCA.iter.w30.w1.fpc_mean(w) = mean(fpcsec);
%                 MUdata.PCA.iter.w30.w1.fpc_cv(w) = (std(fpcsec)/mean(fpcsec))*100;
%             end
% 
%          % fpc whole 30s broken up (5-s windows)
%             for w = 1:6
%                 s = MUdata.w5.starts(w)-MUdata.start+1;
%                 e = MUdata.w5.endds(w)-MUdata.start+1;
%                 fpc = MUdata.PCA.iter.w30.coeffs_mean(end,:); % the FPC using most # MUs available
%                 fpcsec = fpc(s:e);
%                 MUdata.PCA.iter.w30.w5.fpc_secs{w} = fpcsec;
%                 MUdata.PCA.iter.w30.w5.fpc_sd(w) = std(fpcsec);
%                 MUdata.PCA.iter.w30.w5.fpc_mean(w) = mean(fpcsec);
%                 MUdata.PCA.iter.w30.w5.fpc_cv(w) = (std(fpcsec)/mean(fpcsec))*100;
%             end
            
    % -------- RAW FPC ---------------------------------------------------
    
        % WINDOWED FPC
        MUdata.PCA.iter.raw.w1.mergedfpc = [];
        MUdata.PCA.iter.raw.w5.mergedfpc = [];
        % fpc from 1-s windows
            for w = 1:30
                % Index of bad windows:
                if isfield(MUdata.PCA.iter.raw.w1,'coeff_mean')
                    if length(MUdata.PCA.iter.raw.w1.coeff_mean)==1
                    elseif length(MUdata.PCA.iter.raw.w1.coeff_mean) < w || isempty(MUdata.PCA.iter.raw.w1.coeff_mean{w})
                        MUdata.w1.bad_wins(w) = 1; % 1 = bad
                        MUdata.PCA.iter.raw.w1.mergedfpc = horzcat(MUdata.PCA.iter.raw.w1.mergedfpc,repelem(0,2000));
                    else
                        MUdata.w1.bad_wins(w) = 0; % 0 = good
                        MUdata.PCA.iter.raw.w1.fpc_sd(w) = std(MUdata.PCA.iter.raw.w1.coeff_mean{w});
                        MUdata.PCA.iter.raw.w1.fpc_mean(w) = mean(MUdata.PCA.iter.raw.w1.coeff_mean{w});
                        MUdata.PCA.iter.raw.w1.fpc_cv(w) = (MUdata.PCA.iter.raw.w1.fpc_sd(w)/MUdata.PCA.iter.raw.w1.fpc_mean(w))*100;
                        MUdata.PCA.iter.raw.w1.mergedfpc = horzcat(MUdata.PCA.iter.raw.w1.mergedfpc,MUdata.PCA.iter.raw.w1.coeff_mean{w});
                    end
                else
                end
            end
        % smoothed version
        if isempty(MUdata.PCA.iter.raw.w1.mergedfpc)
        else
           MUdata.PCA.iter.raw.w1.mergedfpc_smooth = conv(MUdata.PCA.iter.raw.w1.mergedfpc,hann(200),'same');
        end
        % fpc from 5-s windows
        for w = 1:6
                % Index of bad windows:
                if isfield(MUdata.PCA.iter.raw.w5,'coeff_mean')
                    if length(MUdata.PCA.iter.raw.w5.coeff_mean)==1
                    elseif length(MUdata.PCA.iter.raw.w5.coeff_mean) < w || isempty(MUdata.PCA.iter.raw.w5.coeff_mean{w})
                        MUdata.w5.bad_wins(w) = 1; % 1 = bad
                        MUdata.PCA.iter.w5.mergedfpc = horzcat(MUdata.PCA.iter.w5.mergedfpc,repelem(0,10000));
                    else
                        MUdata.w5.bad_wins(w) = 0; % 0 = good
                        MUdata.PCA.iter.raw.w5.fpc_sd(w) = std(MUdata.PCA.iter.raw.w5.coeff_mean{w});
                        MUdata.PCA.iter.raw.w5.fpc_mean(w) = mean(MUdata.PCA.iter.raw.w5.coeff_mean{w});
                        MUdata.PCA.iter.raw.w5.fpc_cv(w) = (MUdata.PCA.iter.raw.w5.fpc_sd(w)/MUdata.PCA.iter.raw.w5.fpc_mean(w))*100;
                        MUdata.PCA.iter.raw.w5.mergedfpc = horzcat(MUdata.PCA.iter.raw.w5.mergedfpc,MUdata.PCA.iter.raw.w5.coeff_mean{w});
                    end
                else
                end
        end     
        % smoothed version
        if isempty(MUdata.PCA.iter.raw.w5.mergedfpc)
        else
           MUdata.PCA.iter.raw.w5.mergedfpc_smooth = conv(MUdata.PCA.iter.raw.w5.mergedfpc,hann(200),'same');
        end
%     % FULL 30 s CONTINUOUS FPC
%         % fpc whole 30s broken up (1-s windows)
%             for w = 1:30
%                 s = MUdata.w1.starts(w)-MUdata.start+1;
%                 e = MUdata.w1.endds(w)-MUdata.start+1;
%                 fpc = MUdata.PCA.iter.raw.w30.coeffs_mean(end,:); % the FPC using most # MUs available
%                 fpcsec = fpc(s:e);
%                 MUdata.PCA.iter.raw.w30.w1.fpc_secs{w} = fpcsec;
%                 MUdata.PCA.iter.raw.w30.w1.fpc_sd(w) = std(fpcsec);
%                 MUdata.PCA.iter.raw.w30.w1.fpc_mean(w) = mean(fpcsec);
%                 MUdata.PCA.iter.raw.w30.w1.fpc_cv(w) = (std(fpcsec)/mean(fpcsec))*100;
%             end
% 
%          % fpc whole 30s broken up (5-s windows)
%             for w = 1:6
%                 s = MUdata.w5.starts(w)-MUdata.start+1;
%                 e = MUdata.w5.endds(w)-MUdata.start+1;
%                 fpc = MUdata.PCA.iter.raw.w30.coeffs_mean(end,:); % the FPC using most # MUs available
%                 fpcsec = fpc(s:e);
%                 MUdata.PCA.iter.raw.w30.w5.fpc_secs{w} = fpcsec;
%                 MUdata.PCA.iter.raw.w30.w5.sd(w) = std(fpcsec);
%                 MUdata.PCA.iter.raw.w30.w5.fpc_mean(w) = mean(fpcsec);
%                 MUdata.PCA.iter.raw.w30.w5.fpc_cv(w) = (std(fpcsec)/mean(fpcsec))*100;
%             end
               
            
     % -------- CST sections - High pass filtered! -----------------------
            ss = MUdata.start;
            se = MUdata.endd;
            %cstS = highpass(MUdata.cst(ss:se),0.75,2000);
            cst = highpass(MUdata.cst,0.75,2000);
            cstorig = MUdata.cst;
            for w = 1:30 % 1-s windows
                s = MUdata.w1.starts(w);
                e = MUdata.w1.endds(w);
                MUdata.w1.cst_sd(w) = std(cst(s:e)); % HPF CST!
                MUdata.w1.cst_mean(w) = mean(cstorig(s:e)); % ORIG CST!
                MUdata.w1.cst_cv(w) = (std(cstorig(s:e))/mean(cstorig(s:e)))*100; % ORIG!
                MUdata.w1.cst_secs{w} = cst(s:e); % HPC CST!
            end
            
            for w = 1:6 % 5-s windows
                s = MUdata.w5.starts(w);
                e = MUdata.w5.endds(w);
                MUdata.w5.cst_sd(w) = std(cst(s:e)); % HPF CST!
                MUdata.w5.cst_mean(w) = mean(cstorig(s:e)); % ORIG CST!
                MUdata.w5.cst_cv(w) = (std(cstorig(s:e))/mean(cstorig(s:e)))*100; % ORIG!
                MUdata.w5.cst_secs{w} = cst(s:e); % HPF CST!
            end
        
end