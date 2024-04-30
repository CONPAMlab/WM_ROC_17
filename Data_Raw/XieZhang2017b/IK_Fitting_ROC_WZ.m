
addpath(genpath('H:\My Drive\RAC_Standard_Zane\WayZ MTLBtbx PTB3'))

clear all;clc;close all

%% 

% DataAll{1}.IsSame
% 
% DataAll{1}.Rating([1:160],:)
% 
% Reslt_All1 = [];
% Reslt_All1 = [DataAll{1}.Rating([1:160],:), DataAll{1}.Corr([1:160],:)] 
% 
% %Reslt_All1 = [DataAll{1}.Rating([1:160],:)] 
% 
% data1 = Reslt_All1(Reslt_All1(:,2) == 0,1);
% data2 = Reslt_All1(Reslt_All1(:,2) == 1,1);
% 
% %[Myhistc, myBin] = histc(Reslt_All1,[1:1:6],2)
% [Myhistc, myBin] = histc(data1,[1:1:6],2)
% [Myhistc1, myBin1] = histc(data2,[1:1:6],2)
% 
% CntAllNow=sum(Myhistc)
% CntAllNow1=sum(Myhistc1)
% 
% nPOint = 6;
% 
% FA_Hit_all(:,:,1)=[CntAllNow1; CntAllNow];
% 
% % temp = [47, 7, 3, 1, 10, 7; 8, 1, 1, 0, 10, 55];
% 
% IfPlot = 0;
% 
% [ROCNow, zROC] = CompROCs(temp(:,:,1),IfPlot);
% 
% ROC_all(:,:,j)=ROCNow;


%% fitting data with Weiwei's toolbox
nPOint = 6;
IfPlot = 0;

for i = 1:size(DataAll, 2)
 % i = 3

Reslt_All1 = [];
Reslt_All2 = [];

Reslt_All1 = [DataAll{i}.Rating(DataAll{i}.Task == 1,:), DataAll{i}.IsSame(DataAll{i}.Task == 1,:)]; 
Reslt_All2 = [DataAll{i}.Rating(DataAll{i}.Task == 2,:), DataAll{i}.IsSame(DataAll{i}.Task == 2,:)];

data1 = Reslt_All1(Reslt_All1(:,2) == 0,1);
data2 = Reslt_All1(Reslt_All1(:,2) == 1,1);

data3 = Reslt_All2(Reslt_All2(:,2) == 0,1);
data4 = Reslt_All2(Reslt_All2(:,2) == 1,1);

%[Myhistc, myBin] = histc(Reslt_All1,[1:1:6],2)
[Myhistc, myBin] = histc(data1,[1:1:6],2);
[Myhistc1, myBin1] = histc(data2,[1:1:6],2);

[Myhistc2, myBin2] = histc(data3,[1:1:6],2);
[Myhistc3, myBin3] = histc(data4,[1:1:6],2);

CntAllNow=sum(Myhistc);
CntAllNow1=sum(Myhistc1);
CntAllNow2=sum(Myhistc2);
CntAllNow3=sum(Myhistc3);

%tot_Cnt=[CntAllNow; CntAllNow1; CntAllNow2; CntAllNow3]
tot_Cnt=[CntAllNow1; CntAllNow; CntAllNow3; CntAllNow2]

% FA_Hit_all(:,:,1,i)=[CntAllNow1; CntAllNow];
% FA_Hit_all(:,:,2,i)=[CntAllNow3; CntAllNow2];

for j = 1:2
    if j == 1
        %FA_Hit_all(:,:,j,i) = [CntAllNow(nPOint:-1:1); CntAllNow1(nPOint:-1:1)]; % exp2
        %FA_Hit_all(:,:,j,i) = [CntAllNow; CntAllNow1]; % exp1
        FA_Hit_all(:,:,j,i) = [CntAllNow1; CntAllNow]; % exp3
    elseif j == 2
        %FA_Hit_all(:,:,j,i)=[CntAllNow2(nPOint:-1:1); CntAllNow3(nPOint:-1:1)];
        %FA_Hit_all(:,:,j,i)=[CntAllNow2; CntAllNow3]; % exp1
        FA_Hit_all(:,:,j,i) = [CntAllNow3; CntAllNow2]; % exp3
    end
[ROCNow, zROC] = CompROCs(FA_Hit_all(:,:,j,i),IfPlot);

ROC_all(:,:,j)=ROCNow;
end
ROC_allxSubj(:,:,:,i)=ROC_all;
end

% ROC_allxSubj = ROC_all;

Dowhat=[1 1 1 1 0 0 0 0];
%Dowhat = [0 0 0 1]; %HLT, UVSD,Slot, DPSD
IfPlot=0;
Roc2Fit = ROC_allxSubj(:,:,1,1);
StartGuess=[zeros(0,size(Roc2Fit,2))+0.2 0.54 0.3];
PlotFName='test';
% 
% [OutFit,hdlcfg,ROC_TheoNow,zROC_TheoNow, Fitted] = FitROCsXModels(ROC_allxSubj(:,:,1),IfPlot,StartGuess,Dowhat,PlotFName)
% Fitted_allSubj(1,i).Rst = Fitted;
% DPSD_allSubj(:,1,i) = Fitted_allSubj(1,i).Rst(3).Rst
% Slot_allSubj(:,1,i) = Fitted_allSubj(1,i).Rst(4).Rst
        
% size(ROC_allxSubj),  2     5     2    16, first is hit and FA, Third is bins.
for i = 1: size(ROC_allxSubj,4) % subjects
    for j = 1: 2 % conditions; coherent vs. scrambled
        % [OutFit,hdlcfg,ROC_TheoNow,zROC_TheoNow, Fitted, Predicted_dots] = FitROCsXModels(ROC_allxSubj(:,:,j,i),IfPlot,StartGuess,Dowhat,PlotFName);
        [OutFit,hdlcfg,ROC_TheoNow,zROC_TheoNow, Fitted] = FitROCsXModels(ROC_allxSubj(:,:,j,i),IfPlot,StartGuess,Dowhat,PlotFName);
        ROC_TheoNowAllSubj(:,:,:,j,i)=ROC_TheoNow;
        zROC_TheoNowAllSubj(:,:,:,j,i)=zROC_TheoNow;
        Fitted_allSubj(j,i).Rst = Fitted;
        
        DPSD_allSubj(:,j,i) = Fitted_allSubj(j,i).Rst(3).Rst;
        Slot_allSubj(:,j,i) = Fitted_allSubj(j,i).Rst(4).Rst;
    end
    i
end

temp = [];
temp1 = [];
for i = 1:size(DataAll, 2)
    
    temp = [temp; reshape(DPSD_allSubj(:,:,i), [1 4])];
    temp1 = [temp1; reshape(Slot_allSubj(:,:,i), [1 6])];

end

mean( temp)

mean( temp1)

[t,p] = ttest(temp(:,1),temp(:,3), 'both', 'paired')
[t,p] = ttest(temp1(:,1),temp1(:,4), 'both', 'paired')


%%
% 
% for i = 1:12
% 
%     [OutFit,hdlcfg,ROC_TheoNow,zROC_TheoNow, Fitted] = FitROCsXModels(ROC_allxSubj(:,:,1,i),IfPlot,StartGuess,Dowhat,PlotFName);
%     %[OutFit,hdlcfg,ROC_TheoNow,zROC_TheoNow, Fitted] = FitROCsXModels(ROC_allxSubj(:,:,j,i),IfPlot,StartGuess,Dowhat,PlotFName);
%         ROC_TheoNowAllSubj(:,:,:,1,i)=ROC_TheoNow;
%         zROC_TheoNowAllSubj(:,:,:,1,i)=zROC_TheoNow;
%         Fitted_allSubj(1,i).Rst = Fitted;
%         
%         DPSD_allSubj(:,1,i) = Fitted_allSubj(1,i).Rst(3).Rst;
%         Slot_allSubj(:,1,i) = Fitted_allSubj(1,i).Rst(4).Rst;
% end


% DPSD_allSubj(3,:,:)


% clear all