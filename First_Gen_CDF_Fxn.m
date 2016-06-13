% Benjamin Gincley
% 2/19/2016
% Glickfeld Lab
% First Gen Mice Behavior Learning Indicator - Analyzing and Outputting
% CDF Point Extraction and Differences

clear all; close all; nfig = 0; %Cleared workspace and started fig counter
load Color_Library.mat
load Mouse_Learned_Days.mat
load First_Gen_Mice_Variables.mat

% Starts new figure
nfig = nfig +1; 
figure(nfig) 

% Enables Datatype Compatibility
i505_cdf_pLower = double(cell2mat(i505_cdf_pLower));
i505_cdf_pUpper = double(cell2mat(i505_cdf_pUpper));
i505_cdfDiff = double(cell2mat(i505_cdfDiff));
i506_cdf_pLower = double(cell2mat(i506_cdf_pLower));
i506_cdf_pUpper = double(cell2mat(i506_cdf_pUpper));
i506_cdfDiff = double(cell2mat(i506_cdfDiff));
i507_cdf_pLower = double(cell2mat(i507_cdf_pLower));
i507_cdf_pUpper = double(cell2mat(i507_cdf_pUpper));
i507_cdfDiff = double(cell2mat(i507_cdfDiff));
i508_cdf_pLower = double(cell2mat(i508_cdf_pLower));
i508_cdf_pUpper = double(cell2mat(i508_cdf_pUpper));
i508_cdfDiff = double(cell2mat(i508_cdfDiff));
i509_cdf_pLower = double(cell2mat(i509_cdf_pLower));
i509_cdf_pUpper = double(cell2mat(i509_cdf_pUpper));
i509_cdfDiff = double(cell2mat(i509_cdfDiff));

% Establishes Plot Parameters
lower_threshold = 0.24;
upper_threshold = 0.30;
identifierThreshold = 0.30;
upper = [upper_threshold upper_threshold];
lower = [lower_threshold lower_threshold];
threshold = [identifierThreshold identifierThreshold];
yLimit = [0 1]; 
xLimit = [1 20];
t = [0 trainPeriod];
d = [7 7];
trainingDay = 1:trainPeriod;
type = 'HD';

% i505
%%%%%%%%%%%%%%%%%%%%
mouse = '505';
i505_smoothU = smooth(i505_cdf_pUpper, 3, 'moving');
i505_smoothL = smooth(i505_cdf_pLower, 3, 'moving');
i505_smoothD = smooth(i505_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,redD,5,i505_cdf_pUpper,i505_cdf_pLower,i505_cdfDiff,i505_day1,i505_day2,trainPeriod,threshold,yLimit,xLimit,type)

% i506
%%%%%%%%%%%%%%%%%%%%
mouse = '506';
i506_smoothU = smooth(i506_cdf_pUpper, 3, 'moving');
i506_smoothL = smooth(i506_cdf_pLower, 3, 'moving');
i506_smoothD = smooth(i506_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,orangeD,4,i506_cdf_pUpper,i506_cdf_pLower,i506_cdfDiff,i506_day1,i506_day2,trainPeriod,threshold,yLimit,xLimit,type)

% i507
%%%%%%%%%%%%%%%%%%%%
mouse = '507';
i507_smoothU = smooth(i507_cdf_pUpper, 3, 'moving');
i507_smoothL = smooth(i507_cdf_pLower, 3, 'moving');
i507_smoothD = smooth(i507_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,yellowD,3,i507_cdf_pUpper,i507_cdf_pLower,i507_cdfDiff,i507_day1,i507_day2,trainPeriod,threshold,yLimit,xLimit,type)

% i508
%%%%%%%%%%%%%%%%%%%%
mouse = '508';
i508_smoothU = smooth(i508_cdf_pUpper, 3, 'moving');
i508_smoothL = smooth(i508_cdf_pLower, 3, 'moving');
i508_smoothD = smooth(i508_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,greenD,1,i508_cdf_pUpper,i508_cdf_pLower,i508_cdfDiff,i508_day1,i508_day2,trainPeriod,threshold,yLimit,xLimit,type)

% i509
%%%%%%%%%%%%%%%%%%%%
mouse = '509';
i509_smoothU = smooth(i509_cdf_pUpper, 3, 'moving');
i509_smoothL = smooth(i509_cdf_pLower, 3, 'moving');
i509_smoothD = smooth(i509_cdfDiff, 3, 'moving');
fxnCDFPlot(mouse,blueD,6,i509_cdf_pUpper,i509_cdf_pLower,i509_cdfDiff,i509_day1,i509_day2,trainPeriod,threshold,yLimit,xLimit,type)

% Master Overlay
%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2)
hold on;
title('\fontsize{16}First Gen Mice % of All Trials with React Time of 150-550 ms')
xlabel('\fontsize{14}Training Day')
ylabel('\fontsize{14}% Trials between 150-550ms')
ylim([0 0.75]);
xlim(xLimit);
plot(trainingDay, i505_smoothD,'Color', redD, 'LineWidth', 3); % Plots i505 DIFFERENCE over training days
plot(trainingDay, i506_smoothD,'Color', orangeD,'LineWidth', 3); % Plots i506 DIFFERENCE over training days
plot(trainingDay, i507_smoothD,'Color', yellowD, 'LineWidth', 3);  % Plots i507 DIFFERENCE over training days
plot(trainingDay, i508_smoothD, 'Color', greenD, 'LineWidth', 3); % Plots i508 DIFFERENCE over training days
plot(trainingDay, i509_smoothD,'Color', blueD,'LineWidth', 3); % Plots i509 DIFFERENCE over training days
% Reference Lines
plot(t,upper,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5) % Target Threshold
plot(t,lower,'Color', blueL, 'LineStyle', ':', 'LineWidth', 1.5)
plot(t,[0.27 0.27],'Color', greenM, 'LineStyle', ':', 'LineWidth', 2.0) % Plots Learning Threshold
plot(t,[0.55 0.55],'Color', cyan, 'LineStyle', ':', 'LineWidth', 2.0) % Plots Proficiency Threshold
for k=1:4                                                               % Denotes Week
    plot(d,yLimit,'Color', grayL, 'LineWidth', 1.0)
    d=d+7;
end
[~,~] = legend('Location','Northwest','i505','i506','i507','i508','i509'); %Legend
plot(i505_day1,yLimit,'Color', redD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i506_day1,yLimit,'Color', orangeD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i507_day1,yLimit,'Color', yellowD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i508_day1,yLimit,'Color', greenD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
plot(i509_day1,yLimit,'Color', blueD, 'LineStyle', '--', 'LineWidth', 2.0) %Plots suspected day of learning task
hold off;
