%%

clc
clear 
close all

%%
blk_list = [1 2];
subj_list = [1 3:15 17:18];
Nsubj = length(subj_list);
Nblk = length(blk_list);
Ntrial = 150; % trial per blk
DataAll=cell(1,Nsubj);

for subj_id = 1:Nsubj
    data_now.IsSame = zeros(Ntrial*Nblk, 1);
    data_now.Rating = zeros(Ntrial*Nblk, 1);
    data_now.Corr = zeros(Ntrial*Nblk, 1);
    data_now.Task = zeros(Ntrial*Nblk, 1);
    for blk_id = 1:Nblk
        subj = subj_list(subj_id);
        blk = blk_list(blk_id);
        dataname = sprintf('Record_S%d_ID_sn1_b%d', subj, blk);
        load(dataname);
        datahaha = struct2table(Datastruct);
        data_now.IsSame((1+(blk_id-1)*Ntrial):Ntrial*blk_id) = datahaha.IsSame;
        data_now.Rating((1+(blk_id-1)*Ntrial):Ntrial*blk_id) = datahaha.rating;
        data_now.Corr((1+(blk_id-1)*Ntrial):Ntrial*blk_id) = datahaha.Corr;
        data_now.Task((1+(blk_id-1)*Ntrial):Ntrial*blk_id) = datahaha.Task;
    end
    DataAll{subj_id} = data_now;
end

%%
save('DataAll_ROC_New', 'DataAll')