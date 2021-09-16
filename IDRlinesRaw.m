function dat = IDRlinesRaw(dat)
% Interpolates discharge rate lines from discrete points
    % Determine muscles included in this time point
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
    % Insert into data structure for future use
    dat.muscles = muscles;
% Loops through all muscles' MU data
for m = 1:length(muscles)
    mus = muscles{m};
    lines = [];
    rawlines = {};
    % Insert NaN at beginning of IDR vector
        len = length(dat.(mus).IPTs);
%         for mu = 1:length(dat.(mus).MUPulses)
%             idrs = dat.(mus).orig_IDR{1,mu};
%             idrs = [NaN,idrs];
%             dat.(mus).orig_IDR{1,mu} = idrs;
%         end

     for mu = 1:length(dat.(mus).MUPulses)
         if isempty(dat.(mus).MUPulses{1,mu})
             lines{1,mu} = NaN;
         elseif length(dat.(mus).MUPulses{1,mu}) < 5
             lines{1,mu} = NaN;
         else
            % linear interpolation
            dt = dat.(mus).MUPulses{1,mu}(2:end);
                dt_diff = diff(dt);
                first = dt(1,1);
                last = dt(1,end);
            len = length(dat.(mus).IPTs);
            line = zeros(1,len);

            idrs = dat.(mus).orig_IDR{1,mu}(2:end);
                idrs_diff = diff(idrs);

            for d = 1:(length(dt_diff)-1)
                xdiff = dt_diff(1,d)+1;
                ydiff = idrs_diff(1,d);
                slope = ydiff/xdiff;
                for pt = 1:xdiff
                    points(1,pt) = (slope*pt)+idrs(d);
                end
                start = dt(d);
                endd = dt(d+1);
                line(1,start:endd) = points;
                clear('points');
            end

            % NaN version
            line_nans = line;
            line_nans(line_nans==0) = NaN;
            rawlines{1,mu} = line_nans;
            clear('line','line_nans');
         end    
     end
     dat.(mus).rawlines = rawlines;
end
end