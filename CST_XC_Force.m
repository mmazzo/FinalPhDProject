% All CSTs vs force
% Each row is a time (before, pre, post)
days = {'stretch','control'};
levels = {'submax10','submax35'};
times = {'before','pre','post'};
tally = [];

for d = 1:2
    day = days{d};
    for l = 1:2
        level = levels{l};
        for t = 1:length(times)
            time = times{t};
            % --------- For each time / level / day -----------
            MUdata = PFdata.(day).(level).MUdata.(time);
            fdat = PFdata.(day).(level).force.(time);

            % --------- Check alignment -----------------------
            disp(strcat(day,{' '},level,{' '},'time'))
            fadj = CSTforceAlign(MUdata.cst,fdat.filt{1,l});
                % adjust if necessary
                if fadj > 0
                     % Force shortened / shifted left
                     newF = fdat.filt{1,l}(fadj:end);
                else % fadj < 0
                     % Force lengthenend / shifted right
                     pad = zeros(abs(fadj),1);
                     newF = vertcat(pad,fdat.filt{1,l});
                end
                fdat.filt{1,l} = newF;
                PFdata.(day).(level).force.(time).filt{1,l} = newF;
                
                if abs(fadj) ~= 0
                    tally = horzcat(tally,1);
                end
                
            % --------- Get all muscles for this time point ---
            muscles = {};
            if isempty(MUdata.MG)
            else
                muscles = [muscles,{'MG'}];
            end
            if isempty(MUdata.LG)
            else
                muscles = [muscles,{'LG'}];
            end
            if isempty(MUdata.SOL)
            else
                muscles = [muscles,{'SOL'}];
            end
            
            cst = highpass(MUdata.cst,0.75,2000);
            f = highpass(fdat.filt{1,l},0.72,2000);
            
            % Trim sections out of both that are flagged
            fl = [];
            for m = 1:length(muscles)
                mus = muscles{m};
                fl = vertcat(fl,MUdata.(mus).flags);
            end
            % Flags for all PFs
            if size(fl,1) == 1
                allflags = fl;
            else
            allflags = sum(fl);
            end
            allflags(allflags>1) = 1;
            % Shorten flags to match shorter recording
            if length(f) < length(cst)
                allflags = allflags(1:length(f));
            else
                allflags = allflags(1:length(cst));
            end
            % Manually select continuous subset to use
            num =[];
            if sum(allflags(MUdata.start:MUdata.endd)) > 0
               fig = figure(1);
               fig.Position = [100 100 1000 400];
                     yyaxis left
                     area(allflags(MUdata.start:MUdata.endd))
                     %xline(MUdata.start,'--r','linewidth',2)
                     %xline(MUdata.endd,'--r','linewidth',2)
                     yyaxis right
                     plot(MUdata.cst(MUdata.start:MUdata.endd),'k-'); hold on;
                     num = inputdlg('How many sections to keep?');
                     num = str2num(cell2mat(num));
                     title(strcat(day,{' '},level,{' '},'time'));
                     if num == 0
                     else
                     [x,y] = ginput(num*2);
                     end
                waitfor(fig)
                
                if num == 0
                else
                    ind = zeros(1,length(allflags));
                    for i = 1:num
                        ind(x(1)+MUdata.start:x(2)+MUdata.start) = 1;
                        if length(x) > 1
                        x = x(3:end);
                        end
                    end
                    cststeady = cst(ind == 1);
                    fsteady = f(ind == 1);
                end
            else
                cststeady = cst(MUdata.start:MUdata.endd);
                fsteady = f(MUdata.start:MUdata.endd);
            end
        
                % Whole 30s
                if num == 0
                else
                [sigcor,siglag] = xcorr(cststeady,fsteady,2000,'coeff');
                [maxcor,xind] = max(sigcor);
                xlag = siglag(xind);
                    xcorrs.w30.f_cst_r(t) = maxcor;
                    xcorrs.w30.f_cst_lag(t) = xlag;
                end
                
                % Adjust based on whole 30-s cross correlation lag
                if num == 0
                else
                    if xcorrs.w30.f_cst_lag(t) < 0
                        fedit = fsteady(abs(xcorrs.w30.f_cst_lag(t)):end);
                    else
                        pad = repelem(NaN,abs(xcorrs.w30.f_cst_lag(t)));
                        fedit = vertcat(pad',fsteady);
                    end
                    %xcorrs.w30.cst{t} = cst;
                    xcorrs.w30.cststeady{t} = cststeady;
                    %xcorrs.w30.force{t} = f;
                    xcorrs.w30.forcesteady{t} = fedit;
                end

                % 1-s Windows
                for w = 1:30
                    s = MUdata.w1.starts(w);
                    e = MUdata.w1.endds(w);
                    if sum(allflags(s:e)) == 0
                    cstvec = cst(s:e);
                    fvec = f(s:e);
                    % Do XC
                    [sigcor,siglag] = xcorr(cstvec,fvec,2000,'coeff');
                    [maxcor,ind] = max(sigcor);
                    lag = siglag(ind);
                    xcorrs.w1.f_cst_r(t,w) = maxcor;
                    xcorrs.w1.f_cst_lag(t,w) = lag;
                    else
                    end
                end  
                % 5-s windows
                for w = 1:6
                    s = MUdata.w5.starts(w);
                    e = MUdata.w5.endds(w);
                    if sum(allflags(s:e)) == 0
                    cstvec = cst(s:e);
                    fvec = f(s:e);
                    % Do XC
                    [sigcor,siglag] = xcorr(cstvec,fvec,2000,'coeff');
                    [maxcor,ind] = max(sigcor);
                    lag = siglag(ind);
                    xcorrs.w5.f_cst_r(t,w) = maxcor;
                    xcorrs.w5.f_cst_lag(t,w) = lag;
                    else
                    end
                end
        end
        xc.(day).(level) = xcorrs;
    end
end 

disp('Done with Calculations')
if tally > 0
    disp('Resave PFdata.mat')
end

%%
CSTxF.SFU22 = xc;

%% 
CSTxF.SFU16.stretch.submax35.w30.f_cst_r(1) = 0.6643;
CSTxF.SFU16.stretch.submax35.w30.f_cst_lag(1) = -1792;
CSTxF.SFU16.stretch.submax35.w30.cststeady{1} = xc.stretch.submax35.w30.cststeady{1};
CSTxF.SFU16.stretch.submax35.w30.forcesteady{1} = xc.stretch.submax35.w30.forcesteady{1};
%%
clearvars -except CSTxF

