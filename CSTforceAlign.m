function [fadj] = CSTforceAlign(cst,force)
% CST / Force align
cst = cst;
force = force;
% default
new_force = force;

fig = figure(1);
tiledlayout(3,1)
    nexttile
        yyaxis left
        plot(cst,'color','blue');
        yyaxis right
        plot(force,'color','black');
            ax = gca;
            ax.YLim = [0 inf];
            ax.YAxis(2).Color = 'k';
            set(gcf,'units','normalized','outerposition',[0.1 0.1 0.8 0.9]);
   nexttile
        yyaxis left
        plot(cst(40000:85000),'color','blue');
        yyaxis right
        plot(force(40000:85000),'color','black');
   nexttile
        yyaxis left
        plot(highpass(cst(40000:85000),0.75,2000),'color','blue');
        yyaxis right
        plot(highpass(new_force(40000:85000),0.75,2000),'color','black');
        
% Ask    
answ = questdlg('Do the signals match?', ...
    'Matching?', ...
    'Yes','No','No');

while contains(answ,'No') == 1
% Un-matched signals
        % Which is leading?
        lead = questdlg('Which signal is ahead?', ...
        'Leading signal?', ...
        'Blue - CST','Black - Force','Cancel','Cancel');
        % User input additional offset
        [offinds,~] = ginput(2);
        % Adjust 
        offset = round(offinds(2,1)-offinds(1,1));
        offset = abs(offset);
        close(fig);
   % Shift force as needed
    if exist('lead','var') == 1
       switch lead
           case 'Blue - CST' % EMG is leading force
               new_force = force(offset:end); % shift force left
           case 'Black - Force' % Force is leading EMG
               offset = zeros(offset,1);
               new_force = vertcat(offset,force); % shift force right
       end
       
    % Plot again
    fig = figure;
    ax = gca;
    ax.YLim = [0 inf];
    set(gcf,'units','normalized','outerposition',[0.1 0.1 0.8 0.9]);
    tiledlayout(3,1)
    nexttile
        yyaxis left
        plot(cst,'color','blue');
        yyaxis right
        plot(new_force,'color','black');
    nexttile
        yyaxis left
        plot(cst(40000:85000),'color','blue');
        yyaxis right
        plot(new_force(40000:85000),'color','black');
    nexttile
        yyaxis left
        plot(highpass(cst(40000:85000),0.75,2000),'color','blue');
        yyaxis right
        plot(highpass(new_force(40000:85000),0.75,2000),'color','black');
    
    end
        % Ask again
        answ = questdlg('Do the signals match?', ...
        'Matched?', ...
        'Yes','No','No');
end
close(fig);


 % Find final offset
 fadj = length(force) - length(new_force);
 % fadj > 0
     % Force shortened / shifted left
 % fadj < 0
     % Force lengthenend / shifted right
 assignin('base','fadj',fadj);
end