%% Get Data Ready
% TM
% 3/11/24


clc
clear
close all

cd('/Users/macpro/Mack/Data_WM_ROC/XieZhang2017/Exp3_consolidation_masking_20')

load('DataFit20161222.mat')

Nsubj = length(DataAll);
maxr = 6;
DataAllHAHA = cell(Nsubj,1);
for subj = 1:Nsubj
    data_now = DataAll{subj};
    Nsame_all = sum(data_now.IsSame(data_now.Task == 2) == 1);
    Nchange_all = sum(data_now.IsSame(data_now.Task == 2) == 0);
    % check
    if (Nsame_all + Nchange_all) ~= length(data_now.IsSame(data_now.Task == 2))
        error('hahaha')
    end
    Nhit_now = zeros(1,maxr);
    Nfa_now = zeros(1,maxr);
    Nfa_now(1) = Nchange_all;
    Nhit_now(1) = Nsame_all;
    for r = maxr:-1:2
        trial_id_hit = data_now.Rating >= r & data_now.Task == 2 & data_now.IsSame == 1;
        Nhit_now(r) = sum(trial_id_hit);
        trial_id_fa = data_now.Rating >= r & data_now.Task == 2 & data_now.IsSame == 0;
        Nfa_now(r) = sum(trial_id_fa);
    end
    plot(Nfa_now(2:end)/Nchange_all,Nhit_now(2:end)/Nsame_all, 'o-', 'Color', [0 0 0])
    hold on
    DataAllHAHA{subj}.Nhit = Nhit_now;
    DataAllHAHA{subj}.Nfa = Nfa_now;
end
plot([0 1],[0 1],'k:')
xlim([0 1])
ylim([0 1])

save('ROC_Xie2017_E3','DataAllHAHA')
fprintf('Merged data from %d subjects\n',Nsubj)