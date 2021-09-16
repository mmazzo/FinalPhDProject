% Compare mean % explained at certain MU number for diff muscles
level = 'submax10';
%% Day 1 - Boxplot data
MG{1} = PFdata.stretch.(level).MUdata.before.MG.PCA.iter.w1.explained_mean;
MG{2} = PFdata.stretch.(level).MUdata.pre.MG.PCA.iter.w1.explained_mean;
MG{3} = PFdata.stretch.(level).MUdata.post.MG.PCA.iter.w1.explained_mean;

LG{1} = PFdata.stretch.(level).MUdata.before.LG.PCA.iter.w1.explained_mean;
LG{2} = PFdata.stretch.(level).MUdata.pre.LG.PCA.iter.w1.explained_mean;
LG{3} = PFdata.stretch.(level).MUdata.post.LG.PCA.iter.w1.explained_mean;

SOL{1} = PFdata.stretch.(level).MUdata.before.SOL.PCA.iter.w1.explained_mean;
SOL{2} = PFdata.stretch.(level).MUdata.pre.SOL.PCA.iter.w1.explained_mean;
SOL{3} = PFdata.stretch.(level).MUdata.post.SOL.PCA.iter.w1.explained_mean;

%% Day 2 - Boxplot data
MG{4} = PFdata.control.(level).MUdata.before.MG.PCA.iter.w1.explained_mean;
MG{5} = PFdata.control.(level).MUdata.pre.MG.PCA.iter.w1.explained_mean;
MG{6} = PFdata.control.(level).MUdata.post.MG.PCA.iter.w1.explained_mean;

LG{4} = PFdata.control.(level).MUdata.before.LG.PCA.iter.w1.explained_mean;
LG{5} = PFdata.control.(level).MUdata.pre.LG.PCA.iter.w1.explained_mean;
LG{6} = PFdata.control.(level).MUdata.post.LG.PCA.iter.w1.explained_mean;

SOL{4} = PFdata.control.(level).MUdata.before.SOL.PCA.iter.w1.explained_mean;
SOL{5} = PFdata.control.(level).MUdata.pre.SOL.PCA.iter.w1.explained_mean;
SOL{6} = PFdata.control.(level).MUdata.post.SOL.PCA.iter.w1.explained_mean;

%% Line plots
set(gcf, 'Renderer', 'painters');

mg = zeros(6,33);
lg = zeros(6,33);
sol = zeros(6,33);

tiledlayout(2,1)
nexttile
    for p = 1:6
        plot(MG{p},'c');
        hold on;
        plot(LG{p},'b');
        plot(SOL{p},'g');
    end

nexttile
    for p = 1:6
        % rearrange boxplot data
        mg(p,1:length(MG{p})) = MG{p};
        lg(p,1:length(LG{p})) = LG{p};
        sol(p,1:length(SOL{p})) = SOL{p};
    end
    dat = horzcat(mg(:,8),lg(:,8),sol(:,8));
    boxplot(dat);
    title('5 MUs')
    
%% Sum coeffs for all three muscles
% 5-s window
mg = [];
lg = [];
sol = [];
for w = 1:6
    vec = PFdata.control.(level).MUdata.post.MG.PCA.iter.w5.coeffs_mean{w}(end,:);
    mg = horzcat(mg,vec);
    vec = PFdata.control.(level).MUdata.post.LG.PCA.iter.w5.coeffs_mean{w}(end,:);
    lg = horzcat(lg,vec);
    vec = PFdata.control.(level).MUdata.post.SOL.PCA.iter.w5.coeffs_mean{w}(end,:);
    sol = horzcat(sol,vec);
end

%% Find # active
for mu = 1:size(PFdata.control.(level).MUdata.post.MG.binary)
    temp = PFdata.control.(level).MUdata.post.MG.binary(mu,:);
    if sum(temp(PFdata.control.(level).force.post.steady30.start:(PFdata.control.(level).force.post.steady30.endd))) == 0
        count(mu) = 0;
    else
        count(mu) = 1;
    end
end
mglen = sum(count);
% Find # active
count = [];
for mu = 1:size(PFdata.control.(level).MUdata.post.LG.binary)
    temp = PFdata.control.(level).MUdata.post.LG.binary(mu,:);
    if sum(temp(PFdata.control.(level).force.post.steady30.start:(PFdata.control.(level).force.post.steady30.endd))) == 0
        count(mu) = 0;
    else
        count(mu) = 1;
    end
end
lglen = sum(count);
% Find # active
count = [];
for mu = 1:size(PFdata.control.(level).MUdata.post.SOL.binary)
    temp = PFdata.control.(level).MUdata.post.SOL.binary(mu,:);
    if sum(temp(PFdata.control.(level).force.post.steady30.start:(PFdata.control.(level).force.post.steady30.endd))) == 0
        count(mu) = 0;
    else
        count(mu) = 1;
    end
end
sollen = sum(count);

pfs = (mg*mglen)+(lg*lglen)+(sol*sollen);
%%
fdat = PFdata.control.(level).force.post.filt{1,1}(PFdata.control.(level).force.post.steady30.start:PFdata.control.(level).force.post.steady30.endd+5);
fdat = highpass(fdat,0.75,2000); 

r = xcorr(fdat,normalize(pfs),2000,'coeff');
[R.pfs_hpf,Lag.pfs_hpf] = max(r); Lag.pfs_hpf= Lag.pfs_hpf - 2000;

r = xcorr(fdat,normalize(mg),2000,'coeff');
[R.mg,Lag.mg] = max(r); Lag.mg= Lag.mg - 2000;

r = xcorr(fdat,normalize(lg),2000,'coeff');
[R.lg,Lag.lg] = max(r); Lag.lg= Lag.lg - 2000;

r = xcorr(fdat,normalize(sol),2000,'coeff');
[R.sol,Lag.sol] = max(r); Lag.sol= Lag.sol - 2000;


tiledlayout(4,1)
set(gcf, 'Renderer', 'painters');
nexttile
    yyaxis left
    plot(normalize(pfs),'k')
    title(strcat('Summed, merged PF first PCs R =',string(R.pfs),' Lag =',string(Lag.pfs)))
    yyaxis right
    plot(fdat)
    legend('normalized PCA coeff','hpf force');
nexttile
    yyaxis left
    plot(normalize(mg),'c')
    title(strcat('MG R =',string(R.mg),'Lag =',string(Lag.mg)))
    yyaxis right
    plot(fdat)
    legend(strcat('n =',string(mglen)))
nexttile
    yyaxis left
    plot(normalize(lg),'b')
    title(strcat('LG R =',string(R.lg),'Lag =',string(Lag.lg)))
    yyaxis right
    plot(fdat)
    legend(strcat('n =',string(lglen)))
nexttile
    yyaxis left
    plot(normalize(sol),'g')
    title(strcat('SOL R =',string(R.sol),'Lag =',string(Lag.sol)))
    yyaxis right
    plot(fdat)
    legend(strcat('n =',string(sollen)))
 
%% CST vs PCA?
cstdat = highpass(PFdata.control.(level).MUdata.post.cst(PFdata.control.(level).force.post.steady30.start:PFdata.control.(level).force.post.steady30.endd+5),0.75,2000);


tiledlayout(2,1)
nexttile
    yyaxis left
    plot(fdat)
    yyaxis right
    plot(cstdat,'r')
    r = xcorr(fdat,cstdat,2000,'coeff');
    [R.cst,Lag.cst] = max(r); Lag.cst= Lag.cst - 2000;
    title(strcat('Force vs CST R =',string(R.cst),' Lag =',string(Lag.cst))) 
nexttile
    yyaxis left
    plot(pfs)
    yyaxis right
    plot(cstdat,'r')
    r = xcorr(normalize(pfs),cstdat,2000,'coeff');
    [R.pfs_cst,Lag.pfs_cst] = max(r); Lag.pfs_cst= Lag.pfs_cst - 2000;
    title(strcat('PFs PCA Coeff vs CST R =',string(R.pfs_cst),' Lag =',string(Lag.pfs_cst))) 

%% Merged coeffs from iterative PCA with all MUs:
mc = [];
for w = 1:6
    temp = PFdata.control.(level).MUdata.post.PCA.iter.w5.coeffs_mean{w}(end,:);
    mc = horzcat(mc,temp);
end

tiledlayout(3,1)
nexttile
    yyaxis left
    plot(mc,'r');
    yyaxis right
    plot(fdat,'k')
    legend('Merged w5 FP Coeffs from all MUs','Force')
    r = xcorr(fdat,normalize(mc),2000,'coeff');
    [R.coeffs_fdat,Lag.coeffs_fdat] = max(r); Lag.coeffs_fdat= Lag.coeffs_fdat - 2000;
        title(strcat('R =',string(R.coeffs_fdat),' Lag =',string(Lag.coeffs_fdat))) 
nexttile
    yyaxis left
    plot(mc,'r');
    yyaxis right
    plot(pfs,'b')
    legend('Merged w5 FP Coeffs from all MUs','Reconstructed Coeff from MG, LG, SOL FPCs')
    r = xcorr(normalize(pfs),normalize(mc),2000,'coeff');
    [R.coeffs_pfs,Lag.coeffs_pfs] = max(r); Lag.coeffs_pfs= Lag.coeffs_pfs - 2000;
        title(strcat('R =',string(R.coeffs_pfs),' Lag =',string(Lag.coeffs_pfs))) 
nexttile
    yyaxis left
    plot(mc,'r');
    yyaxis right
    plot(normalize(cstdat),'y')
    legend('Merged w5 FP Coeffs from all MUs','CST')
    r = xcorr(normalize(cstdat),normalize(mc),2000,'coeff');
    [R.coeffs_cst,Lag.coeffs_cst] = max(r); Lag.coeffs_cst= Lag.coeffs_cst - 2000;
        title(strcat('R =',string(R.coeffs_cst),' Lag =',string(Lag.coeffs_cst))) 


%% Covariance across trials/windows between FPC correlation with force & % explained?

% Where the CST is more correlated with force, is the % explained by the FPC higher?
for w = 1:6
    s = (2000*w)-1999;
    e = s+(10000);
    cors.coeffs(w,:) = PFdata.control.(level).MUdata.post.PCA.iter.w5.coeffs_mean{w}(end,:);
    cors.expl(w) = PFdata.control.(level).MUdata.post.PCA.iter.w5.explained_means{w}(end);
    cors.cst(w,:) = cstdat(s:e);
    cors.pfs(w,:) = pfs(s:e);
    cors.fdat(w,:) = fdat(s:e);
end

for w = 1:6
    r = xcorr(cors.coeffs(w,:),cors.fdat(w,:),2000,'coeff');
    [cors.R.coeffs_fdat(w),cors.Lags.coeffs_fdat(w)] = max(r); cors.Lags.coeffs_fdat(w) = cors.Lags.coeffs_fdat(w) - 2000;
    
    r = xcorr(cors.cst(w,:),cors.fdat(w,:),2000,'coeff');
    [cors.R.cst_fdat(w),cors.Lags.cst_fdat(w)] = max(r); cors.Lags.cst_fdat(w) = cors.Lags.cst_fdat(w) - 2000;
    
    r = xcorr(cors.pfs(w,:),cors.fdat(w,:),2000,'coeff');
    [cors.R.pfs_fdat(w),cors.Lags.pfs_fdat(w)] = max(r); cors.Lags.pfs_fdat(w) = cors.Lags.pfs_fdat(w) - 2000;
    
    r = xcorr(cors.pfs(w,:),cors.cst(w,:),2000,'coeff');
    [cors.R.pfs_cst(w),cors.Lags.pfs_cst(w)] = max(r); cors.Lags.pfs_cst(w) = cors.Lags.pfs_cst(w) - 2000;
  
    r = xcorr(cors.coeffs(w,:),cors.pfs(w,:),2000,'coeff');
    [cors.R.coeffs_pfs(w),cors.Lags.coeffs_pfs(w)] = max(r); cors.Lags.coeffs_pfs(w) = cors.Lags.coeffs_pfs(w) - 2000;
end

%% Plot covariance
set(gcf, 'Renderer', 'painters');
    plot([1:6],normalize(cors.R.coeffs_fdat),'r');
    hold on;
    plot([1:6],normalize(cors.R.cst_fdat),'b');
    plot([1:6],normalize(cors.R.pfs_fdat),'g');
    plot([1:6],normalize(cors.R.pfs_cst),'c');
    plot([1:6],normalize(cors.expl),'k');
    plot([1:6],normalize(cors.R.coeffs_pfs),'color',[0.5 0.5 0.5]);
    legend('Force vs. Coeffs','Force vs CST','Force vs Merged PF FPCs','CST vs Merged PF FPCs','% Explained','All MUs Coeff vs Merged PF FPCs')
    
%% 1-s windows

% Where the CST is more correlated with force, is the % explained by the FPC higher?
for w = 1:30
    s = (2000*w)-1999;
    e = s+(2000);
    cors.w1.coeffs(w,:) = PFdata.control.(level).MUdata.post.PCA.iter.w1.coeffs_mean{w}(end,:);
    cors.w1.expl(w) = PFdata.control.(level).MUdata.post.PCA.iter.w1.explained_means{w}(end);
    cors.w1.cst(w,:) = cstdat(s:e);
    cors.w1.pfs(w,:) = pfs(s:e);
    cors.w1.fdat(w,:) = fdat(s:e);
end

for w = 1:30
    r = xcorr(cors.w1.coeffs(w,:),cors.w1.fdat(w,:),2000,'coeff');
    [cors.w1.R.coeffs_fdat(w),cors.w1.Lags.coeffs_fdat(w)] = max(r); cors.w1.Lags.coeffs_fdat(w) = cors.w1.Lags.coeffs_fdat(w) - 2000;
    
    r = xcorr(cors.w1.cst(w,:),cors.w1.fdat(w,:),2000,'coeff');
    [cors.w1.R.cst_fdat(w),cors.w1.Lags.cst_fdat(w)] = max(r); cors.w1.Lags.cst_fdat(w) = cors.w1.Lags.cst_fdat(w) - 2000;
    
    r = xcorr(cors.w1.pfs(w,:),cors.w1.fdat(w,:),2000,'coeff');
    [cors.w1.R.pfs_fdat(w),cors.w1.Lags.pfs_fdat(w)] = max(r); cors.w1.Lags.pfs_fdat(w) = cors.w1.Lags.pfs_fdat(w) - 2000;
    
    r = xcorr(cors.w1.pfs(w,:),cors.w1.cst(w,:),2000,'coeff');
    [cors.w1.R.pfs_cst(w),cors.w1.Lags.pfs_cst(w)] = max(r); cors.w1.Lags.pfs_cst(w) = cors.w1.Lags.pfs_cst(w) - 2000;

    r = xcorr(cors.w1.coeffs(w,:),cors.w1.pfs(w,:),2000,'coeff');
    [cors.w1.R.coeffs_pfs(w),cors.w1.Lags.coeffs_pfs(w)] = max(r); cors.w1.Lags.coeffs_pfs(w) = cors.w1.Lags.coeffs_pfs(w) - 2000;
end

%% Plot covariance
set(gcf, 'Renderer', 'painters');
    plot([1:30],normalize(cors.w1.R.coeffs_fdat),'r');
    hold on;
    plot([1:30],normalize(cors.w1.R.cst_fdat),'b');
    plot([1:30],normalize(cors.w1.R.pfs_fdat),'g');
    plot([1:30],normalize(cors.w1.R.pfs_cst),'c');
    plot([1:30],normalize(cors.w1.expl),'k');
    plot([1:30],normalize(cors.w1.R.coeffs_pfs),'color',[0.5 0.5 0.5]);
    legend('Force vs. Coeffs','Force vs CST','Force vs Merged PF FPCs','CST vs Merged PF FPCs','% Explained','All MUs Coeff vs Merged PF FPCs')
    
%% scatter between R values
scatter(normalize(cors.w1.R.cst_fdat),normalize(cors.w1.expl))
scatter(normalize(cors.w1.R.pfs_fdat),normalize(cors.w1.expl))
scatter(normalize(cors.w1.R.coeffs_fdat),normalize(cors.w1.expl))

% potentially interesting?
scatter(normalize(cors.w1.R.pfs_cst),normalize(cors.w1.expl))
    % Where the % explained by the FPC is higher, the two estimates of
    % common drive are more correlated
    
%% Which one best varies with % explaiend by FPC?
cov(normalize(cors.w1.R.coeffs_fdat),normalize(cors.w1.expl)) % 0.301
cov(normalize(cors.w1.R.cst_fdat),normalize(cors.w1.expl)) % 0.123
cov(normalize(cors.w1.R.pfs_fdat),normalize(cors.w1.expl)) % 0.1995
% other pairs
cov(normalize(cors.w1.R.cst_fdat),normalize(cors.w1.R.pfs_fdat)) % 0.9192
cov(normalize(cors.w1.R.cst_fdat),normalize(cors.w1.R.pfs_fdat)) % 0.9192

