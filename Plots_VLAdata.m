% All VLA data
Bxdat = [];
Bydat = [];
Pxdat = [];
Pydat = [];

for sub = 1:length(VLAdata.bIDRs)
    fig = figure(1);
    for r = 1:size(VLAdata.bTqs{sub},1)
    s1 = scatter(VLAdata.bTqs{sub}(r,4:end),VLAdata.bIDRs{sub}(r,4:end),'r');
    end
    hold on;
    for r = 1:size(VLAdata.pTqs{sub},1)
    s2 = scatter(VLAdata.pTqs{sub}(r,4:end),VLAdata.pIDRs{sub}(r,4:end),'b');
    end
    Bxdat = horzcat(Bxdat,s1.XData);
    Bydat = horzcat(Bydat,s1.YData);
    Pxdat = horzcat(Pxdat,s2.XData);
    Pydat = horzcat(Pydat,s2.YData);
end

s3 = scatter(mean(Bxdat),mean(Bydat),'g','filled');
s4 = scatter(mean(Pxdat),mean(Pydat),'g','filled');

%%
histogram(Bxdat,10,'FaceAlpha',0.5);
hold on;
histogram(Pxdat,10,'FaceAlpha',0.5);

histogram(Bydat,10,'FaceAlpha',0.5);
hold on;
histogram(Pydat,10,'FaceAlpha',0.5);

%% Removing zeros and negatives first

for sub = 1:length(VLAdata.bIDRs)
    for r = 1:size(VLAdata.bTqs{sub},1)
    temp = VLAdata.bTqs{sub}(r,:);
    temp(temp==0) = NaN; temp(temp<0) = NaN;
    VLAdata.bTqs{sub}(r,:) = temp;
    temp = VLAdata.bIDRs{sub}(r,:);
    temp(temp==0) = NaN; temp(temp<0) = NaN;
    VLAdata.bIDRs{sub}(r,:) = temp;
    end
    hold on;
    for r = 1:size(VLAdata.pTqs{sub},1)
    temp = VLAdata.pTqs{sub}(r,:);
    temp(temp==0) = NaN; temp(temp<0) = NaN;
    VLAdata.pTqs{sub}(r,:) = temp;
    temp = VLAdata.pIDRs{sub}(r,:);
    temp(temp==0) = NaN; temp(temp<0) = NaN;
    VLAdata.pIDRs{sub}(r,:) = temp;
    end
end
%%
Bxdat = [];
Bydat = [];
Pxdat = [];
Pydat = [];

for sub = 1:length(VLAdata.bIDRs)
    fig = figure(1);
    for r = 1:size(VLAdata.bTqs{sub},1)
    s1 = scatter(VLAdata.bTqs{sub}(r,4:end),VLAdata.bIDRs{sub}(r,4:end),'r');
    end
    hold on;
    for r = 1:size(VLAdata.pTqs{sub},1)
    s2 = scatter(VLAdata.pTqs{sub}(r,4:end),VLAdata.pIDRs{sub}(r,4:end),'b');
    end
    Bxdat = horzcat(Bxdat,s1.XData);
    Bydat = horzcat(Bydat,s1.YData);
    Pxdat = horzcat(Pxdat,s2.XData);
    Pydat = horzcat(Pydat,s2.YData);
end

s3 = scatter(mean(Bxdat),mean(Bydat),'g','filled');
s4 = scatter(mean(Pxdat),mean(Pydat),'g','filled');

%%
histogram(Bxdat,10,'FaceAlpha',0.5);
hold on;
histogram(Pxdat,10,'FaceAlpha',0.5);

histogram(Bydat,10,'FaceAlpha',0.5);
hold on;
histogram(Pydat,10,'FaceAlpha',0.5);