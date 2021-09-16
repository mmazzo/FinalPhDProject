%% Variable PCA pseudoA vs simple PCA FCC explained values across trials
  
% Select variables
    level = 'submax10';
    day = 'stretch';
    window = 'w1';
% Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.iter.(window).pseudoA;
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_mean(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.(window).pseudoA;
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_mean(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.iter.(window).pseudoA;
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_mean(1);
    end
    % Create plot
    s1 = scatter(dat1(1,:),dat2(1,:),'r','filled'); hold on;
    s2 = scatter(dat1(2,:),dat2(2,:),'b','filled');
    s3 = scatter(dat1(3,:),dat2(3,:),'g','filled');
    legend([s1,s2,s3], row);
    %title('Stretch Day');
    xlim([10 55])
    

 % Select variables
    level = 'submax35';
    day = 'stretch';
    window = 'w1';
    % Select data for each muscle across the same day, diff trials
    for m = 1:3
        mus = muscles{m};
        % Rows
        row{m,1} = mus;
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.iter.(window).pseudoA;
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.(window).explained_mean(1);

        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.(window).pseudoA;
        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.(window).explained_mean(1);

        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.iter.(window).pseudoA;
        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.(window).explained_mean(1);
    end
    % Create plot
    s4 = scatter(dat1(1,:),dat2(1,:),'r','filled'); hold on;
    s5 = scatter(dat1(2,:),dat2(2,:),'b','filled');
    s6 = scatter(dat1(3,:),dat2(3,:),'g','filled');
    xlabel('Variable # of MUs PCA: pseudo-asymptote')
    ylabel('Simple PCA: % Explained')

%% PseudoA vs pCSI
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
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.iter.(window).pseudoA;

        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.(window).pseudoA;

        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.iter.(window).pseudoA;
    end
    % Create plot
    dat1(dat1==0) = NaN;
    dat2(dat2==0) = NaN;
    
    s1 = scatter(dat1(1,:),dat2(1,:),'r','filled'); hold on;
    s2 = scatter(dat1(2,:),dat2(2,:),'b','filled');
    s3 = scatter(dat1(3,:),dat2(3,:),'g','filled');
    legend([s1,s2,s3], row);
    %title('Stretch Day');
    xlim([18 40])
    xlabel('Variable # of MUs PCA: pseudo-asymptote')
    ylabel('pCSI difference bewteen 1v1 and 2v2 MU pairs')
    
    
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
        dat2(m,1) = PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.before.(mus).pCSI.(window).pCSI(1);
        dat1(m,1) = PFdata.(day).(level).MUdata.before.(mus).PCA.iter.(window).pseudoA;

        dat2(m,2) = PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.pre.(mus).pCSI.(window).pCSI(1);
        dat1(m,2) = PFdata.(day).(level).MUdata.pre.(mus).PCA.iter.(window).pseudoA;

        dat2(m,3) = PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(num)...
            - PFdata.(day).(level).MUdata.post.(mus).pCSI.(window).pCSI(1);
        dat1(m,3) = PFdata.(day).(level).MUdata.post.(mus).PCA.iter.(window).pseudoA;
    end
    % Create plot
    dat1(dat1==0) = NaN;
    dat2(dat2==0) = NaN;
    
    s1 = scatter(dat1(1,:),dat2(1,:),'r','filled'); hold on;
    s2 = scatter(dat1(2,:),dat2(2,:),'b','filled');
    s3 = scatter(dat1(3,:),dat2(3,:),'g','filled');
    %legend([s1,s2,s3], row);
    %title('Control Day');

