% pCSI vs PCA plots

%% pCSI vs SIMPLE PCA FCC explained values across trials
set(0,'DefaultLegendAutoUpdate','off')

tiledlayout(1,2)
nexttile
    % Select variables
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        if length(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);
        end
        
        if length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);
        end
        
        if length(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
        end
    end
    % Create plot
    s1 = scatter(dat1(1,:),dat2(1,:),'r','filled'); hold on;
    s2 = scatter(dat1(2,:),dat2(2,:),'b','filled');
    s3 = scatter(dat1(3,:),dat2(3,:),'g','filled');
    legend([s1,s2,s3],row(1:3));
    title('Day 1');
    xlabel('Increase in pCSI between 1v1 and 2v2 MU Pairs');
    ylabel('% Explained by FCC');
    xlim([0 0.15]);
    ylim([40 70]);

%nexttile
    % Select variables
    level = 'submax35';
    day = 'control';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        
        if length(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);
        end
        
        if length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);
        end
        
        if length(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
        end
    end
    % Create plot
    s4 = scatter(dat1(1,:),dat2(1,:),'r','filled'); hold on;
    s5 = scatter(dat1(2,:),dat2(2,:),'b','filled');
    s6 = scatter(dat1(3,:),dat2(3,:),'g','filled');
    
    
nexttile
    % Select variables
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        
        if length(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);
        end
        
        if length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);
        end
        
        if length(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
        end
    end
    % Create plot
    s1 = scatter(dat1(1,:),dat2(1,:),'r','filled'); hold on;
    s2 = scatter(dat1(2,:),dat2(2,:),'b','filled');
    s3 = scatter(dat1(3,:),dat2(3,:),'g','filled');
    legend([s1,s2,s3], row(1:3));
    title('Day 2');
    xlabel('Increase in pCSI between 1v1 and 2v2 MU Pairs');
    ylabel('% Explained by FCC');
    xlim([0 0.15]);
    ylim([40 70]);
%nexttile
    % Select variables
    level = 'submax35';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        
        if length(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);
        end
        
        if length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);
        end
        
        if length(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
        end
    end       
    % Create plot
    s4 = scatter(dat1(1,:),dat2(1,:),'r','filled'); hold on;
    s5 = scatter(dat1(2,:),dat2(2,:),'b','filled');
    s6 = scatter(dat1(3,:),dat2(3,:),'g','filled');
    


    
    
    
    
%% pCSI vs variable-#-MUs-PCA FCC explained values across trials
set(0,'DefaultLegendAutoUpdate','off')

tiledlayout(1,2)
nexttile
    % Select variables
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        if length(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_mean(5);
        end
        
        if length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_mean(5);
        end
        
        if length(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_mean(5);
        end
    end
    % Create plot
    s1 = scatter(dat1(1,:),dat2(1,:),'r','filled'); hold on;
    s2 = scatter(dat1(2,:),dat2(2,:),'b','filled');
    s3 = scatter(dat1(3,:),dat2(3,:),'g','filled');
    legend([s1,s2,s3],row(1:3));
    title('Day 1');
    xlabel('Increase in pCSI between 1v1 and 2v2 MU Pairs');
    ylabel('% Explained by FCC');
    xlim([0 0.15]);
    ylim([40 70]);

%nexttile
    % Select variables
    level = 'submax35';
    day = 'control';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        
        if length(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_mean(5);
        end
        
        if length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_mean(5);
        end
        
        if length(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_mean(5);
        end
    end
    % Create plot
    s4 = scatter(dat1(1,:),dat2(1,:),'r','filled'); hold on;
    s5 = scatter(dat1(2,:),dat2(2,:),'b','filled');
    s6 = scatter(dat1(3,:),dat2(3,:),'g','filled');
    
    
nexttile
    % Select variables
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        
        if length(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_mean(5);
        end
        
        if length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_mean(5);
        end
        
        if length(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_mean(5);
        end
    end
    % Create plot
    s1 = scatter(dat1(1,:),dat2(1,:),'r','filled'); hold on;
    s2 = scatter(dat1(2,:),dat2(2,:),'b','filled');
    s3 = scatter(dat1(3,:),dat2(3,:),'g','filled');
    legend([s1,s2,s3], row(1:3));
    title('Day 2');
    xlabel('Increase in pCSI between 1v1 and 2v2 MU Pairs');
    ylabel('% Explained by FCC');
    xlim([0 0.15]);
    ylim([40 70]);
%nexttile
    % Select variables
    level = 'submax35';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        
        if length(PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_mean(5);
        end
        
        if length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_mean(5);
        end
        
        if length(PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI) < 2
        else
        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(2)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_mean(5);
        end
    end       
    % Create plot
    s4 = scatter(dat1(1,:),dat2(1,:),'r','filled'); hold on;
    s5 = scatter(dat1(2,:),dat2(2,:),'b','filled');
    s6 = scatter(dat1(3,:),dat2(3,:),'g','filled');
    

