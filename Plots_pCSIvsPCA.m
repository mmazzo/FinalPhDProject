% pCSI vs PCA plots

%% INFLUENCED BY NUMBER OF MOTOR UNITS WHEN ALL VIEWED ON SAME PLOT

%% pCSI vs FCC explained values across trials
%tiledlayout(1,2)
%nexttile
    % Select variables
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        dat = [length(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.post.(mus).pCSI.w1.pCSI)];
        num = min(dat);
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
    end
    % Create plot
    s1 = scatter(dat1(1,:),dat2(1,:),'r'); hold on;
    s2 = scatter(dat1(2,:),dat2(2,:),'b');
    s3 = scatter(dat1(3,:),dat2(3,:),'g');
    legend([s1,s2,s3], row);
    %title('Control Day');

% nexttile
    % Select variables
    level = 'submax35';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        dat = [length(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.post.(mus).pCSI.w1.pCSI)];
        num = min(dat);
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
    end
    % Create plot
    s4 = scatter(dat1(1,:),dat2(1,:),'r'); hold on;
    s5 = scatter(dat1(2,:),dat2(2,:),'b');
    s6 = scatter(dat1(3,:),dat2(3,:),'g');
    %legend([s1,s2,s3], row);
    %title('Stretch Day');
    
    
    
%nexttile
    % Select variables
    level = 'submax10';
    day = 'control';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        dat = [length(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.post.(mus).pCSI.w1.pCSI)];
        num = min(dat);
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
    end
    % Create plot
    s1 = scatter(dat1(1,:),dat2(1,:),'r'); hold on;
    s2 = scatter(dat1(2,:),dat2(2,:),'b');
    s3 = scatter(dat1(3,:),dat2(3,:),'g');
    %legend([s1,s2,s3], row);
    %title('Control Day');

%nexttile
    % Select variables
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        dat = [length(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.post.(mus).pCSI.w1.pCSI)];
        num = min(dat);
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
    end
    % Create plot
    s4 = scatter(dat1(1,:),dat2(1,:),'r'); hold on;
    s5 = scatter(dat1(2,:),dat2(2,:),'b');
    s6 = scatter(dat1(3,:),dat2(3,:),'g');
    %legend([s1,s2,s3], row);
    %title('Stretch Day');
    


    
    
    
    
    
    
    
    
%% pCSI vs FCC explained values across trials
% Just using baseline coherence between the maximal # of MU pairs, not the
% slope if the pCSI line

%nexttile
    % Select variables
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        dat = [length(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.post.(mus).pCSI.w1.pCSI)];
        num = min(dat);
        nums(1) = num;
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_mean(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_mean(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_mean(1);
    end
    % Create plot
    s1 = scatter(dat1(1,:),dat2(1,:),'r'); hold on;
    s2 = scatter(dat1(2,:),dat2(2,:),'b');
    s3 = scatter(dat1(3,:),dat2(3,:),'g');
    legend([s1,s2,s3], row);
    %title('Control Day');

% nexttile
    % Select variables
    level = 'submax35';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        dat = [length(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.post.(mus).pCSI.w1.pCSI)];
        num = min(dat);
        nums(2) = num;
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
    end
    % Create plot
    s4 = scatter(dat1(1,:),dat2(1,:),'r'); hold on;
    s5 = scatter(dat1(2,:),dat2(2,:),'b');
    s6 = scatter(dat1(3,:),dat2(3,:),'g');
    %legend([s1,s2,s3], row);
    %title('Stretch Day');
    
    
    
%nexttile
    % Select variables
    level = 'submax10';
    day = 'control';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        dat = [length(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.post.(mus).pCSI.w1.pCSI)];
        num = min(dat);
        nums(3) = num;
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
    end
    % Create plot
    s1 = scatter(dat1(1,:),dat2(1,:),'r'); hold on;
    s2 = scatter(dat1(2,:),dat2(2,:),'b');
    s3 = scatter(dat1(3,:),dat2(3,:),'g');
    %legend([s1,s2,s3], row);
    %title('Control Day');

%nexttile
    % Select variables
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        dat = [length(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.post.(mus).pCSI.w1.pCSI)];
        num = min(dat);
        nums(4) = num;
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
    end
    % Create plot
    s4 = scatter(dat1(1,:),dat2(1,:),'r'); hold on;
    s5 = scatter(dat1(2,:),dat2(2,:),'b');
    s6 = scatter(dat1(3,:),dat2(3,:),'g');
    %legend([s1,s2,s3], row);
    %title('Stretch Day');
    

    
    
    
    
    
    
%% Just one muscle
% pCSI vs FCC explained values across trials
% Just using baseline coherence between the maximal # of MU pairs, not the
% slope if the pCSI line

dat = [];
    % Num MU Pairs
    for d = 1:2
        day = days{d};
        for l = 1:2
            level = levels{l};
            dat = vertcat(dat,length(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.post.(mus).pCSI.w1.pCSI));
        end
    end
    num = min(dat);
    
 %% nexttile
    % Select variables
    level = 'submax35';
    day = 'control';
    window = 'w1';
    mus = 'MG';
    m = 1;   
    % Select data for each muscle across the same day, diff trials
        % Rows
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
        
    % Create plot
    s1 = scatter(dat1(1,:),dat2(1,:),'r'); hold on;

% nexttile
    % Select variables
    level = 'submax35';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
        % Rows
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
    % Create plot
    s2 = scatter(dat1(1,:),dat2(1,:),'b'); hold on;
    %legend([s1,s2,s3], row);
    %title('Stretch Day');
    
    
    
%nexttile
    % Select variables
    level = 'submax10';
    day = 'control';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
    % Create plot
    s3 = scatter(dat1(1,:),dat2(1,:),'r'); hold on;
    %legend([s1,s2,s3], row);
    %title('Control Day');

%nexttile
    % Select variables
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_means(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_means(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_means(1);
    % Create plot
    s4 = scatter(dat1(1,:),dat2(1,:),'b'); hold on;
    %legend([s1,s2,s3], row);
    title('MG - 1 sec Windows');
    xlabel('pCSI Coherence: 4 v 4 MUs');
    ylabel('Simple PCA: % Explained by FCC');
    

    
    
    
    
    
    
    
    
%% Just one muscle
% pCSI vs iterative PCA curves explained pseudo-asymptote
% Just using baseline coherence between the maximal # of MU pairs, not the
% slope if the pCSI line

dat = [];
    % Num MU Pairs
    for d = 1:2
        day = days{d};
        for l = 1:2
            level = levels{l};
            dat = vertcat(dat,length(PFdata.(day).(level).MUdata.before.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.pre.(mus).pCSI.w1.pCSI),...
            length(PFdata.(day).(level).MUdata.post.(mus).pCSI.w1.pCSI));
        end
    end
    num = min(dat);
    
 %% nexttile
    % Select variables
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
    mus = 'MG';
    m = 1;   
    % Select data for each muscle across the same day, diff trials
        % Rows
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.iter.(window).pseudoA;

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.(window).pseudoA;

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.iter.(window).pseudoA;
        
    % Create plot
    s1 = scatter(dat1(1,:),dat2(1,:),'r'); hold on;

% nexttile
    % Select variables
    level = 'submax35';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
        % Rows
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num);
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.iter.(window).pseudoA;

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num);
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.(window).pseudoA;

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num);
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.iter.(window).pseudoA;
    % Create plot
    s2 = scatter(dat1(1,:),dat2(1,:),'b'); hold on;
    %legend([s1,s2,s3], row);
    %title('Stretch Day');
    
    
    
