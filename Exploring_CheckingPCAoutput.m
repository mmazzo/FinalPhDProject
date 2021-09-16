tiledlayout(6,5)
for w = 1:30
    nexttile
    num = size(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).coeffs_mean{1,w},1);
    s = PFdata.(day).(level).MUdata.(time).(win).starts(w);
    e = PFdata.(day).(level).MUdata.(time).(win).endds(w);

    yyaxis left
    hold on;
    for mu = 1:length(PFdata.(day).(level).MUdata.(time).(mus).rawlines)
        if isnan(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
        elseif isempty(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
        else
            if sum(isnan(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu}(s:e))) > 0
            else
                plot(highpass(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu}(s:e),0.75,2000),'-','color',[0.5, 0.5, 0.5]);
            end
        end
    end
    
    yyaxis right
    plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).coeffs_mean{1,w}(num,:),'-b')
    plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.(win).coeffs_mean{1,w}(num,:),'-r')

end

%%
win = 'w5';

figure(1)
tiledlayout(3,2)
for w = 1:6
    nexttile
    num = size(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).coeffs_mean{1,w},1);
    s = PFdata.(day).(level).MUdata.(time).(win).starts(w);
    e = PFdata.(day).(level).MUdata.(time).(win).endds(w);

    yyaxis left
    hold on;
    for mu = 1:length(PFdata.(day).(level).MUdata.(time).(mus).rawlines)
        if isnan(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
        elseif isempty(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
        else
            if sum(isnan(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu}(s:e))) > 0
            else
                plot(highpass(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu}(s:e),0.75,2000),'-','color',[0.5, 0.5, 0.5]);
            end
        end
    end
    
    yyaxis right
    plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).coeffs_mean{1,w}(num,:),'-b','linewidth',2)

end



figure(2)
tiledlayout(3,2)
for w = 1:6
    nexttile
    num = size(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.raw.(win).coeffs_mean{1,w},1);
    s = PFdata.(day).(level).MUdata.(time).(win).starts(w);
    e = PFdata.(day).(level).MUdata.(time).(win).endds(w);

    yyaxis left
    hold on;
    for mu = 1:length(PFdata.(day).(level).MUdata.(time).(mus).rawlines)
        if isnan(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
        elseif isempty(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
        else
            if sum(isnan(PFdata.(day).(level).MUdata.(time).(mus).lines{mu}(s:e))) > 0
            else
                plot(highpass(PFdata.(day).(level).MUdata.(time).(mus).lines{mu}(s:e),0.75,2000),'-','color',[0.5, 0.5, 0.5]);
            end
        end
    end
    
    yyaxis right
    if w == 2 || w == 3 || w  == 6
        plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.(win).coeffs_mean{1,w}(num,:)*-1,'-r','linewidth',2)
    else
        plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.(win).coeffs_mean{1,w}(num,:),'-r','linewidth',2)
    end

end

%% 
figure(3)
w = 6;
yyaxis left
for mu = 1:length(PFdata.(day).(level).MUdata.(time).(mus).rawlines)
    hold on;
        if isnan(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
        elseif isempty(PFdata.(day).(level).MUdata.(time).(mus).rawlines{mu})
        else
            if sum(isnan(PFdata.(day).(level).MUdata.(time).(mus).lines{mu}(s:e))) > 0
            else
                plot(highpass(PFdata.(day).(level).MUdata.(time).(mus).lines{mu}(s:e),0.75,2000),'-','color',[0.5, 0.5, 0.5]);
            end
        end
end
yyaxis right
for p = 13:18 %size(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.(win).coeffs_mean{1,w},1)
    plot(PFdata.(day).(level).MUdata.(time).(mus).PCA.iter.(win).coeffs_mean{1,w}(p,:),'-r','linewidth',2)
    hold on;
end
