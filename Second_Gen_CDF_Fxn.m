% Benjamin Gincley
% 2/19/2016
% Glickfeld Lab
% Second Gen Mice Behavior Learning Indicator - Analyzing and Outputting
% CDF Point Extraction and Differences

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load Second_Gen_Mice_Variables.mat

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Enables Datatype Compatibility
%{
i527_cdf_pLower = double(cell2mat(i527_cdf_pLower));
i527_cdf_pUpper = double(cell2mat(i527_cdf_pUpper));
i527_cdfDiff = double(cell2mat(i527_cdfDiff));
i529_cdf_pLower = double(cell2mat(i529_cdf_pLower));
i529_cdf_pUpper = double(cell2mat(i529_cdf_pUpper));
i529_cdfDiff = double(cell2mat(i529_cdfDiff));
i533_cdf_pLower = double(cell2mat(i533_cdf_pLower));
i533_cdf_pUpper = double(cell2mat(i533_cdf_pUpper));
i533_cdfDiff = double(cell2mat(i533_cdfDiff));
i534_cdf_pLower = double(cell2mat(i534_cdf_pLower));
i534_cdf_pUpper = double(cell2mat(i534_cdf_pUpper));
i534_cdfDiff = double(cell2mat(i534_cdfDiff));
i535_cdf_pLower = double(cell2mat(i535_cdf_pLower));
i535_cdf_pUpper = double(cell2mat(i535_cdf_pUpper));
i535_cdfDiff = double(cell2mat(i535_cdfDiff));
%}
% Establishes Plot Parameters
lower_threshold = 0.24;
upper_threshold = 0.30;
identifierThreshold = 0.30;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 1]; 
xLimit = [1 30];
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'HD';

% i527
%%%%%%%%%%%%%%%%%%%%
mouse = '527';
i527_smoothU = smooth(i527_cdf_pUpper, 3, 'moving');
i527_smoothL = smooth(i527_cdf_pLower, 3, 'moving');
i527_smoothD = smooth(i527_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,redD,5,i527_cdf_pUpper,i527_cdf_pLower,i527_cdfDiff,i527_day1,i527_day2,trainPeriod,threshold,yLimit,xLimit,type)

% i529
%%%%%%%%%%%%%%%%%%%%
mouse = '529';
i529_smoothU = smooth(i529_cdf_pUpper, 3, 'moving');
i529_smoothL = smooth(i529_cdf_pLower, 3, 'moving');
i529_smoothD = smooth(i529_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,orangeD,4,i529_cdf_pUpper,i529_cdf_pLower,i529_cdfDiff,i529_day1,i529_day2,trainPeriod,threshold,yLimit,xLimit,type)

% i533
%%%%%%%%%%%%%%%%%%%%
mouse = '533';
i533_smoothU = smooth(i533_cdf_pUpper, 3, 'moving');
i533_smoothL = smooth(i533_cdf_pLower, 3, 'moving');
i533_smoothD = smooth(i533_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,yellowD,1,i533_cdf_pUpper,i533_cdf_pLower,i533_cdfDiff,i533_day1,i533_day2,trainPeriod,threshold,yLimit,xLimit,type)

% i534
%%%%%%%%%%%%%%%%%%%%
mouse = '534';
i534_smoothU = smooth(i534_cdf_pUpper, 3, 'moving');
i534_smoothL = smooth(i534_cdf_pLower, 3, 'moving');
i534_smoothD = smooth(i534_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,greenD,3,i534_cdf_pUpper,i534_cdf_pLower,i534_cdfDiff,i534_day1,i534_day2,trainPeriod,threshold,yLimit,xLimit,type)

% i535
%%%%%%%%%%%%%%%%%%%%
mouse = '535';
i535_trainingDay = 1:trainPeriod535;
i535_smoothU = smooth(i535_cdf_pUpper, 3, 'moving');
i535_smoothL = smooth(i535_cdf_pLower, 3, 'moving');
i535_smoothD = smooth(i535_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,blueD,6,i535_cdf_pUpper,i535_cdf_pLower,i535_cdfDiff,i535_day1,i535_day2,trainPeriod535,threshold,yLimit,xLimit,type)

% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}Second Gen Mice % of All Trials with React Time of 150-550 ms')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}% Trials between 150-550ms')
ylim([0 0.75]);
xlim(xLimit);
plot(trainingDay, i527_smoothD,'Color', redD, 'LineWidth', 3); % Plots i527 DIFFERENCE over training days
plot(trainingDay, i529_smoothD,'Color', orangeD,'LineWidth', 3); % Plots i529 DIFFERENCE over training days
plot(trainingDay, i533_smoothD,'Color', yellowD, 'LineWidth', 3);  % Plots i533 DIFFERENCE over training days
plot(trainingDay, i534_smoothD, 'Color', greenD, 'LineWidth', 3); % Plots i534 DIFFERENCE over training days
plot(i535_trainingDay, i535_smoothD,'Color', blueD,'LineWidth', 3); % Plots i535 DIFFERENCE over training days
% Reference Lines
plot(t,upper,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[0.27 0.27],'Color', greenM, 'LineStyle', ':', 'LineWidth', 2.0) % Plots Learning Threshold
plot(t,[0.55 0.55],'Color', cyan, 'LineStyle', ':', 'LineWidth', 2.0) % Plots Proficiency Threshold
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Northwest','i527','i529','i533','i534','i535'); %Legend
plot(i527_day1,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i529_day1,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i533_day1,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i534_day1,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i535_day1,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
