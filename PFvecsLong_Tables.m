%% W1 - Create PFVecs table in long format
count = 1;
for i = 1:228
    for w = 1:6
        data{count,1} = PFvecs.subs{i};
        data{count,2} = PFvecs.days{i};
        data{count,3} = PFvecs.levels{i};
        data{count,4} = PFvecs.times{i};
        data{count,5} = PFvecs.w5.f_sd(i,w);
        data{count,6} = PFvecs.w5.cst_sd(i,w);
        data{count,7} = PFvecs.w5.fpc_sd(i,w);
        data{count,8} = PFvecs.w5.f_cst_r(i,w);
        data{count,9} = PFvecs.w5.fpc_cst_r(i,w);
        data{count,10} = PFvecs.w5.f_fpc_r(i,w);
        data{count,11} = w;
        count = count+1;
    end
end

%%
t = table(data);
writetable(t,'PFvecsLong_W5_35.csv');

%%
t = table(data);
writetable(t,'PFvecsLong_W1_35.csv');
