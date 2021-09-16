function [MUdata] = pCSIfuncIter(MUdata,fdat)
% Apply pCSI function to individual muscles & between-muscle coherence
% Only the section where that muscle's motor units are active
% Removes flagged sections first!
warning('off','all')

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

% --------- Individual Muscles -----------------------------------------
for m = 1:length(muscles)
    mus = muscles{m};
    % Identify empty lines
    rem = [];
    for mu = 1:size(MUdata.(mus).binary,1)
        if sum(MUdata.(mus).binary(mu,:)) == 0
            rem = horzcat(rem,mu);
        end    
    end
    % Remove empty MUs
    binmat = MUdata.(mus).binary;
    binmat(rem,:) = [];
    % 1-s windows
    win = 2000;
    num = 30;
    rem = [];
    for w = 1:num
        ws = MUdata.start + (w*win) - win;
            MUdata.w1.starts(w) = ws;
        we = ws + win;
            MUdata.w1.endds(w) = we;
        % skip to next window if any flags in this one = 1
        if sum(MUdata.(mus).flags(ws:we)) == 0
            % Subset
            binmat1 = binmat(:,ws:we);
            for mu = 1:size(binmat1,1)
                if sum(isnan(binmat1(mu,:))) > 0
                    rem = horzcat(rem,mu);
                elseif sum((binmat1(mu,:))) == 0
                    rem = horzcat(rem,mu);
                end
            end
            % Remove empty IDRs
            bindat = binmat1;
            bindat(rem,:) = [];
            % If < 3 MUs are active
            if size(bindat,1) < 3
            else
            % Run coherence analysis
            [F,COHT,pCSI_all,pCSI] = pCSI_COH(bindat,1,2000,100);
            % Save variables for this muscle
            MUdata.(mus).pCSI.iter.w1.F = F;
            MUdata.(mus).pCSI.iter.w1.COHT{w} = COHT;
            MUdata.(mus).pCSI.iter.w1.pCSI_all{w} = pCSI_all;
            MUdata.(mus).pCSI.iter.w1.pCSI{w} = pCSI;
            end
        end
    end
    
% 5-s windows
    % Remove empty MUs
    binmat = MUdata.(mus).binary;
    binmat(rem,:) = [];
    % 1-s windows
    win = 10000;
    num = 6;
    rem = [];
    for w = 1:num
        ws = MUdata.start + (w*win) - win;
            MUdata.w5.starts(w) = ws;
        we = ws + win;
            MUdata.w5.endds(w) = we;
        % skip to next window if any flags in this one = 1
        if sum(MUdata.(mus).flags(ws:we)) == 0
            % Subset
            binmat5 = binmat(:,ws:we);
            for mu = 1:size(binmat5,1)
                if sum(isnan(binmat5(mu,:))) > 0
                    rem = horzcat(rem,mu);
                elseif sum((binmat5(mu,:))) == 0
                    rem = horzcat(rem,mu);
                end
            end
            % Remove empty IDRs
            bindat = binmat5;
            bindat(rem,:) = [];
            % If < 3 MUs are active
            if size(bindat,1) < 3
            else
            % Run coherence analysis
            [F,COHT,pCSI_all,pCSI] = pCSI_COH(bindat,5,2000,100);
            % Save variables for this muscle
            MUdata.(mus).pCSI.iter.w1.F = F;
            MUdata.(mus).pCSI.iter.w1.COHT{w} = COHT;
            MUdata.(mus).pCSI.iter.w1.pCSI_all{w} = pCSI_all;
            MUdata.(mus).pCSI.iter.w1.pCSI{w} = pCSI;
            end
        end
    end
end 

% ------------- For all PFs combined ---------------------------------
    % Steady portion only
    binary = MUdata.binary(:,MUdata.start:MUdata.endd);
    flags = fdat.allflags(MUdata.start:MUdata.endd);
    % Only where MUs are active
    start = find(sum(binary) > 0,1,'first');
    endd = find(sum(binary) > 0,1,'last');
    binary = binary(:,start:endd);
    flags = flags(start:endd);
    % Remove flagged sections 
    binary = binary(:,flags == 0);
 % Remove empty lines
    rem = [];
    for mu = 1:size(binary,1)
        if sum(binary(mu,:)) == 0
            rem = horzcat(rem,mu);
        end    
    end
    % Take subset
    binmat = binary;
    binmat(rem,:) = [];
    % 1-s windows
        [F,COHT,pCSI_all,pCSI] = pCSI_COH(binmat,1,2000,100);
        % Save variables for this muscle
        MUdata.pCSI.w1.F = F;
        MUdata.pCSI.w1.COHT = COHT;
        MUdata.pCSI.w1.pCSI_all = pCSI_all;
        MUdata.pCSI.w1.pCSI = pCSI;
    % 5-s windows
        [F,COHT,pCSI_all,pCSI] = pCSI_COH(binmat,5,2000,100);
        % Save variables for this muscle
        MUdata.pCSI.w5.F = F;
        MUdata.pCSI.w5.COHT = COHT;
        MUdata.pCSI.w5.pCSI_all = pCSI_all;
        MUdata.pCSI.w5.pCSI = pCSI;

% -------------- Pairs of Muscles ------------------------------------
if length(muscles) == 3
    num = 3;
    pairs{1,1} = {'MG'}; pairs{1,2} = {'LG'};
    pairs{2,1} = {'MG'}; pairs{2,2} = {'SOL'};
    pairs{3,1} = {'LG'}; pairs{3,2} = {'SOL'};
elseif length(muscles) == 2
    num = 1;
    pairs = muscles;
else
    num = 0;
end
    
for m = 1:num
    if num == 3
        mus1 = cell2mat(pairs{m,1}); mus2 = cell2mat(pairs{m,2});
    elseif num == 1
        mus1 = pairs{m,1}; mus2 = pairs{m,2};
    else
    end
    % Steady portion only
    binary1 = MUdata.(mus1).binary(:,MUdata.start:MUdata.endd);
    binary2 = MUdata.(mus2).binary(:,MUdata.start:MUdata.endd);
    % Compare only where both are active
    ind1_1 = find(sum(binary1) > 0,1,'first');
    ind2_1 = find(sum(binary1) > 0,1,'last');
    ind1_2 = find(sum(binary2) > 0,1,'first');
    ind2_2 = find(sum(binary2) > 0,1,'last');
        if ind1_1 > ind1_2
            start = ind1_1;
        else
            start = ind1_2;
        end
        if ind2_1 < ind2_2
            endd = ind2_1;
        else
            endd = ind2_2;
        end
    % Remove same flagged sections from both muscles
    flags1 = MUdata.(mus1).flags(MUdata.start:MUdata.endd);
    flags1 = flags1(start:endd);
    flags2 = MUdata.(mus2).flags(MUdata.start:MUdata.endd);
    flags2 = flags2(start:endd);
    flags = flags1 + flags2;
    flags(flags > 1) = 1;
    % Remove flagged sections
    binary1 = binary1(:,flags == 0);
    binary2 = binary2(:,flags == 0);
    % Muscle 1 - Remove empty lines
        rem = [];
        for mu = 1:size(binary1,1)
            if sum(binary1(mu,:)) == 0
                rem = horzcat(rem,mu);
            end    
        end
        binmat1 = binary1;
        binmat1(rem,:) = [];
    % Muscle 2 - Remove empty lines
        rem = [];
        for mu = 1:size(binary2,1)
            if sum(binary2(mu,:)) == 0
                rem = horzcat(rem,mu);
            end    
        end
        binmat2 = binary2;
        binmat2(rem,:) = [];
    % Run pCSI function
        % Naming
            name = horzcat(mus1,mus2);
        % 1-s windows
            [F,COHT,pCSI_all,pCSI] = pCSI_COH_diffmuscles(binmat1,binmat2,1,2000,100);
            % Save variables for this muscle pair
            MUdata.pCSI.(name).w1.F = F;
            MUdata.pCSI.(name).w1.COHT = COHT;
            MUdata.pCSI.(name).w1.pCSI_all = pCSI_all;
            MUdata.pCSI.(name).w1.pCSI = pCSI;
        % 5-s windows
        if length(binmat1) < 10000 || length(binmat2) < 10000
            MUdata.pCSI.(name).w5.F = NaN;
            MUdata.pCSI.(name).w5.COHT = NaN;
            MUdata.pCSI.(name).w5.pCSI_all = NaN;
            MUdata.pCSI.(name).w5.pCSI = NaN;
        else
            [F,COHT,pCSI_all,pCSI] = pCSI_COH_diffmuscles(binmat1,binmat2,5,2000,100);
            % Save variables for this muscle pair
            MUdata.pCSI.(name).w5.F = F;
            MUdata.pCSI.(name).w5.COHT = COHT;
            MUdata.pCSI.(name).w5.pCSI_all = pCSI_all;
            MUdata.pCSI.(name).w5.pCSI = pCSI;
        end

end

end