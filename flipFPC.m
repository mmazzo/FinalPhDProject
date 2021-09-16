function [data] = flipFPC(data,muscles)
% data = PFdata....MUdata.(time)
% Flip FPC if there were NaNs in the PCA and
% the if statement in PCAiter.m didn't work 
% (aka run with old vers. of PCAiter code)

% --------- Individual Muscles -----------------------------------------

for m = 1:length(muscles)
    mus = muscles{m};
    if length(data.(mus).cst) == 1 
    elseif isnan(data.(mus).cst)
    else
        % High pass filter CST
        hpfcst = highpass(data.(mus).cst(data.start:data.endd),0.75,2000);

%         % CONTINUOUS FPC - Smooth
%         if isfield(data.(mus).PCA.iter,'w30')
%         [cors,~] = xcorr(data.(mus).PCA.iter.w30.coeffs_mean(end,:),hpfcst,200,'normalized');
%             if max(cors) < 0 || mean(cors) < 0
%                 data.(mus).PCA.iter.w30.coeffs_mean = data.(mus).PCA.iter.w30.coeffs_mean*-1;
%             end
%         else
%         end
% 
%         % CONTINUOUS FPC - Raw
%         if isfield(data.(mus).PCA.iter.raw,'w30')
%         [cors,~] = xcorr(data.(mus).PCA.iter.raw.w30.coeffs_mean(end,:),hpfcst,200,'normalized');
%             if max(cors) < 0 || mean(cors) < 0
%                 data.(mus).PCA.iter.raw.w30.coeffs_mean = data.(mus).PCA.iter.raw.w30.coeffs_mean*-1;
%             end
%         else
%         end

        % 1-S WINDOWS
        hpfcst = highpass(data.(mus).cst,0.75,2000);
        for w = 1:30
            s = data.w1.starts(w);
            e = data.w1.endds(w);
            cstsec = hpfcst(s:e);
            if ~isfield(data.(mus).PCA.iter,'w1')
                if isfield(data.(mus).PCA.iter.w1,'explained')
                    if isempty(data.(mus).PCA.iter.w1.explained{w})
                    else
                        % smooth
                        [cors_s,~] = xcorr(data.(mus).PCA.iter.w1.coeffs_mean{w}(end,:),cstsec,200,'normalized');
                        if max(cors_s) < 0 || mean(cors_s) < 0
                            data.(mus).PCA.iter.w1.coeffs_mean{w} = data.(mus).PCA.iter.w1.coeffs_mean{w}*-1;
                        end
                        % raw
                        if isfield(data.(mus).PCA.iter,'raw')
                            if isfield(data.(mus).PCA.iter.raw.w1,'coeffs_mean')
                                [cors_r,~] = xcorr(data.(mus).PCA.iter.raw.w1.coeffs_mean{w}(end,:),cstsec,200,'normalized');
                                if max(cors_r) < 0 || mean(cors_r) < 0
                                    data.(mus).PCA.iter.raw.w1.coeffs_mean{w} = data.(mus).PCA.iter.raw.w1.coeffs_mean{w}*-1;
                                end
                            end
                        end
                    end
                end
            end
        end

        % 5-S WINDOWS
        hpfcst = highpass(data.(mus).cst,0.75,2000);
        for w = 1:6
            s = data.w5.starts(w);
            e = data.w5.endds(w);
            cstsec = hpfcst(s:e);
            if ~isfield(data.(mus).PCA.iter,'w5')
                if isfield(data.(mus).PCA.iter.w1,'explained')
                    if isempty(data.(mus).PCA.iter.w5.explained{w})
                    else
                        % smooth
                        [cors_s,~] = xcorr(data.(mus).PCA.iter.w5.coeffs_mean{w}(end,:),cstsec,200,'normalized');
                        if max(cors_s) < 0 || mean(cors_s) < 0
                            data.(mus).PCA.iter.w5.coeffs_mean{w} = data.(mus).PCA.iter.w5.coeffs_mean{w}*-1;
                        end
                        % raw
                        if isfield(data.(mus).PCA.iter,'raw')
                            if isfield(data.(mus).PCA.iter.raw.w5,'coeffs_mean')
                            [cors_r,~] = xcorr(data.(mus).PCA.iter.raw.w5.coeffs_mean{w}(end,:),cstsec,200,'normalized');
                                if max(cors_r) < 0 || mean(cors_r) < 0
                                    data.(mus).PCA.iter.raw.w5.coeffs_mean{w} = data.(mus).PCA.iter.raw.w5.coeffs_mean{w}*-1;
                                end
                            end
                        else
                        end
                    end
                end
            end
        end
    end
end

% --------- All PFs -----------------------------------------

    % High pass filter CST
%    hpfcst = highpass(data.cst(data.start:data.endd),0.75,2000);

%     % CONTINUOUS FPC - Smooth
%     [cors,~] = xcorr(data.PCA.iter.w30.coeffs_mean(end,:),hpfcst,200,'normalized');
%         if max(cors) < 0 || mean(cors) < 0
%             data.PCA.iter.w30.coeffs_mean = data.PCA.iter.w30.coeffs_mean*-1;
%         end
% 
%     % CONTINUOUS FPC - Raw
%     [cors,~] = xcorr(data.PCA.iter.raw.w30.coeffs_mean(end,:),hpfcst,200,'normalized');
%         if max(cors) < 0 || mean(cors) < 0
%             data.PCA.iter.raw.w30.coeffs_mean = data.PCA.iter.raw.w30.coeffs_mean*-1;
%         end

    % 1-S WINDOWS
    hpfcst = highpass(data.cst,0.75,2000);
    for w = 1:30
        s = data.w1.starts(w);
        e = data.w1.endds(w);
        cstsec = hpfcst(s:e);
        if ~isfield(data.PCA.iter,'w1')
        elseif isempty(data.PCA.iter.w1.explained{w})
        else
            % smooth
            [cors_s,~] = xcorr(data.PCA.iter.w1.coeffs_mean{w}(end,:),cstsec,200,'normalized');
            if max(cors_s) < 0 || mean(cors_s) < 0
                data.PCA.iter.w1.coeffs_mean{w} = data.PCA.iter.w1.coeffs_mean{w}*-1;
            end
            % raw
            if isfield(data.PCA.iter,'raw')
                if isfield(data.PCA.iter.raw.w1,'coeffs_mean')
                [cors_r,~] = xcorr(data.PCA.iter.raw.w1.coeffs_mean{w}(end,:),cstsec,200,'normalized');
                    if max(cors_r) < 0 || mean(cors_r) < 0
                        data.PCA.iter.raw.w1.coeffs_mean{w} = data.PCA.iter.raw.w1.coeffs_mean{w}*-1;
                    end
                end
            else
            end
        end
    end
    
    % 5-S WINDOWS
    hpfcst = highpass(data.cst,0.75,2000);
    for w = 1:6
        s = data.w5.starts(w);
        e = data.w5.endds(w);
        cstsec = hpfcst(s:e);
        if ~isfield(data.PCA.iter,'w5')
        elseif isempty(data.PCA.iter.w5.explained{w})
        else
            % smooth
            [cors_s,~] = xcorr(data.PCA.iter.w5.coeffs_mean{w}(end,:),cstsec,200,'normalized');
            if max(cors_s) < 0 || mean(cors_s) < 0
                data.PCA.iter.w5.coeffs_mean{w} = data.PCA.iter.w5.coeffs_mean{w}*-1;
            end
            % raw
            if isfield(data.PCA.iter,'raw')
                if isfield(data.PCA.iter.raw.w5,'coeffs_mean')
                    [cors_r,~] = xcorr(data.PCA.iter.raw.w5.coeffs_mean{w}(end,:),cstsec,200,'normalized');
                    if max(cors_r) < 0 || mean(cors_r) < 0
                        data.PCA.iter.raw.w5.coeffs_mean{w} = data.PCA.iter.raw.w5.coeffs_mean{w}*-1;
                    end
                end
            else
            end
        end
    end

end
