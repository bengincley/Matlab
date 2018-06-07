clear all;
name = '20180504_Cm_Stim2';
labels = ["Well","Median Rise Time","Median CTD10","Median CTD90"];
% l = ["Mean";"Stdev"];
[null,well] = xlsread(name,'B215:B310'); clear null; well=string(cell2mat(well)); %well=cat(1,well,l);
rise_median = xlsread(name,'AH215:AH310');
ctd10_median = xlsread(name,'AZ215:AZ310');
ctd90_median=xlsread(name,'CD215:CD310');
% rm_mean = nanmean(rise_median); rm_sig = nanstd(rise_median);
% c10_mean = nanmean(ctd10_median); c10_sig = nanstd(ctd10_median);
% c90_mean = nanmean(ctd90_median); c90_sig = nanstd(ctd90_median);
% rise_median = cat(1,rise_median,rm_mean,rm_sig);
% ctd10_median = cat(1,ctd10_median,c10_mean,c10_sig);
% ctd90_median = cat(1,ctd90_median,c90_mean,c90_sig);

m(:,1) = well; m(:,2)=rise_median; m(:,3)=ctd10_median; m(:,4)=ctd90_median;
%% xlswrite
xlswrite(name,labels,'Data','B1');
xlswrite(name,m,'Data','B2');